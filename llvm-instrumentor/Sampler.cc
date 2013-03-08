#include "SitesRegistry.hh"
#include "utilities.hh"
#include <boost/bind/bind.hpp>
#include <boost/functional/hash.hpp>
#include <boost/range/adaptor/filtered.hpp>
#include <boost/range/adaptor/indirected.hpp>
#include <boost/range/adaptor/map.hpp>
#include <boost/range/algorithm/copy.hpp>
#include <boost/range/algorithm/for_each.hpp>
#include <llvm/ADT/DenseSet.h>
#include <llvm/ADT/SmallSet.h>
#include <llvm/Function.h>
#include <llvm/InstrTypes.h>
#include <llvm/IntrinsicInst.h>
#include <llvm/Module.h>
#include <llvm/Pass.h>
#include <llvm/Support/CallSite.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/IRBuilder.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/Utils/BasicBlockUtils.h>
#include <llvm/Transforms/Utils/Cloning.h>
#include <llvm/ValueSymbolTable.h>
#include <unordered_set>
#include <utility>

using namespace boost;
using namespace boost::adaptors;
using namespace llvm;

using std::make_pair;
using std::pair;


namespace
{
  typedef pair<const BasicBlock *, const BasicBlock *> BackEdge;
  typedef pair<BasicBlock *, BasicBlock *> RegionHeader;
  typedef std::unordered_set<RegionHeader> RegionHeaders;
  typedef DenseMap<BasicBlock *, unsigned> RegionThresholds;
  typedef std::unordered_set<BasicBlock *> SitesSet;

  class Sampler : public FunctionPass
  {
  public:
    static char ID;
    Sampler();

    bool doInitialization(Module &) override;
    bool runOnFunction(Function &) override;

  private:
    IntegerType *int32;
    Constant *zero32;
    Constant *zero1;
    GlobalVariable *nextEventCountdown;
    Function *getNextEventCountdown;
    Function *intrinsicExpect;
    Value *addDecrementCountdown(IRBuilder<> &) const;
    pair<BasicBlock *, BasicBlock *> splitEdge(const RegionHeader &edge);
  };
}

namespace std
{
  template<> struct hash<RegionHeader> : public unary_function<RegionHeader, size_t>
  {
    size_t operator()(const RegionHeader &header) const
    {
      return hash_value(header);
    }
  };
}


////////////////////////////////////////////////////////////////////////


char Sampler::ID;

static const RegisterPass<Sampler> registration("sampler", "Transform instrumentation to be randomly sampled at run time");

static cl::opt<bool> PredictChecks("predict-checks", cl::desc("Emit static branch prediction hints for countdown checks"), cl::init(true));


inline Sampler::Sampler()
  : FunctionPass(ID)
{
}


bool Sampler::doInitialization(Module &module)
{
  static const StringRef nextName("cbi_nextEventCountdown");
  static const StringRef getNextName("cbi_getNextEventCountdown");

  auto &context(module.getContext());
  int32 = Type::getInt32Ty(context);
  zero32 = ConstantInt::get(int32, 0);

  nextEventCountdown = module.getNamedGlobal(nextName);
  getNextEventCountdown = module.getFunction(getNextName);
  assert(nextEventCountdown != nullptr);
  assert(getNextEventCountdown != nullptr);

  if (PredictChecks)
    {
      const auto int1 = Type::getInt1Ty(context);
      zero1 = ConstantInt::get(int1, 0);
      const auto id(Intrinsic::ID::expect);
      intrinsicExpect = Intrinsic::getDeclaration(&module, id, int1);
    }

  return false;
}


static void declone(const ValueToValueMapTy &valueMap, Value &original)
{
  const auto cloned(valueMap.lookup(&original));
  cloned->replaceAllUsesWith(&original);
}


static inline bool shouldSplitAfter(const Instruction &instruction)
{
  // split after non-intrinsic calls and after all invokes
  return (isa<CallInst>(instruction) && !isa<IntrinsicInst>(instruction)) || isa<InvokeInst>(instruction);
}


static inline bool isBackEdge(const RegionHeaders &regionHeaders, BasicBlock * const header, BasicBlock * const tail)
{
  const auto candidate(make_pair(header, tail));
  return regionHeaders.find(candidate) != regionHeaders.end();
}


static unsigned weighRegion(const RegionHeaders &regionHeaders, SitesSet &sites, RegionThresholds &thresholds, BasicBlock * const block)
{
  const auto found(thresholds.find(block));
  if (found != thresholds.end())
    return found->second;

  const auto terminator(block->getTerminator());
  auto maxSubweight(0U);
  for (auto slot = terminator->getNumSuccessors(); slot--; )
    {
      const auto successor(terminator->getSuccessor(slot));
      if (!isBackEdge(regionHeaders, block, successor))
	{
	  const auto subweight(weighRegion(regionHeaders, sites, thresholds, successor));
	  maxSubweight = std::max(maxSubweight, subweight);
	}
    }
  const unsigned selfWeight(sites.find(block) != sites.end());
  const unsigned weight(maxSubweight + selfWeight);

  thresholds[block] = weight;
  return weight;
}


inline RegionHeader deconstBackEdge(const BackEdge &backEdge)
{
  const auto head(const_cast<BasicBlock *>(backEdge.first));
  const auto tail(const_cast<BasicBlock *>(backEdge.second));
  return make_pair(head, tail);
}


Value *Sampler::addDecrementCountdown(IRBuilder<> &builder) const
{
  assert(nextEventCountdown != nullptr);
  const auto load(builder.CreateLoad(nextEventCountdown, "original"));
  const auto one(ConstantInt::get(load->getType(), 1));
  const auto sub(builder.CreateSub(load, one, "decremented", true, true));
  builder.CreateStore(sub, nextEventCountdown);
  return sub;
}


inline BasicBlock &getUniqueSuccessor(const BasicBlock &block)
{
  const auto terminator(block.getTerminator());
  assert(terminator->getNumSuccessors() == 1);
  return *terminator->getSuccessor(0);
}


#ifndef NDEBUG
static void assertSequence(const BasicBlock &before, const BasicBlock &after)
{
  const auto &beforeTerminator(*before.getTerminator());
  assert(beforeTerminator.getNumSuccessors() == 1);
  assert(beforeTerminator.getSuccessor(0) == &after);
}
#endif	// !NDEBUG


pair<BasicBlock *, BasicBlock *> Sampler::splitEdge(const RegionHeader &edge)
{
  SplitEdge(edge.first, edge.second, this);
  const BasicBlock &beforeBlock(*edge.first);
  auto &middleBlock(getUniqueSuccessor(beforeBlock));
  auto &afterBlock(getUniqueSuccessor(middleBlock));
  assert(edge.second == &middleBlock || edge.second == &afterBlock);
  assert(middleBlock.getSinglePredecessor() == &beforeBlock);
  DEBUG(assertSequence(beforeBlock, middleBlock));
  DEBUG(assertSequence(middleBlock, afterBlock));
  const std::string afterName(edge.second->getName());
  const std::string middleName(afterName + ".crossover");
  afterBlock.setName(afterName);
  middleBlock.setName(middleName);
  return make_pair(&middleBlock, &afterBlock);
}


inline BasicBlock *clonedBlock(const ValueToValueMapTy &valueMap, BasicBlock * const original)
{
  const auto found(valueMap.lookup(original));
  return cast_or_null<BasicBlock>(&*found);
}


inline bool isDebugDeclare(Instruction &instruction)
{
  return isa<DbgDeclareInst>(instruction);
}


bool Sampler::runOnFunction(Function &function)
{
  // bail out early if no instrumentation to sample
  const auto sitesEqualRange(sitesRegistry.equal_range(&function));
  if (sitesEqualRange.first == sitesRegistry.end())
    return false;
  SitesSet sites;
  copy(sitesEqualRange | map_values, std::inserter(sites, sites.begin()));

  // isolate initial alloca calls; we will not clone these
  auto &entryBlock(function.front());
  const auto &symbolTable(function.getValueSymbolTable());
  static const StringRef splitPointName("reg2mem alloca point");
  const auto afterAllocas(cast<Instruction>(symbolTable.lookup(splitPointName)));
  assert(afterAllocas != nullptr);
  assert(afterAllocas->getParent() == &entryBlock);
  const auto postEntryBlock(SplitBlock(&entryBlock, after(afterAllocas), this));
  postEntryBlock->setName(entryBlock.getName() + ".after-prologue");

  // identify acyclic region headers; will add threshold checks later
  RegionHeaders regionHeaders;

  // region header at entry to function
  regionHeaders.insert(make_pair(&entryBlock, postEntryBlock));

  // split blocks so that calls appear at end, just before terminator
  auto blocks(std::next(function.begin()));
  assert(&*blocks == postEntryBlock);
  std::vector<Instruction *> splitPoints;
  for (auto &block : make_iterator_range(blocks, function.end()))
    for (auto &callSite : block | filtered(shouldSplitAfter))
      splitPoints.push_back(&callSite);

  // region header after each invoke or non-intrinsic call
  for (const auto &callSite : splitPoints)
    {
      const auto block(callSite->getParent());
      const auto afterCall(SplitBlock(block, after(callSite), this));
      afterCall->setName(block->getName() + ".after-call");
      regionHeaders.insert(make_pair(block, afterCall));
    }

  // region header at end of each acyclic region
  SmallVector<BackEdge, 4> backEdges;
  FindFunctionBackedges(function, backEdges);
  const auto backEdgeHeaders(backEdges | transformed(deconstBackEdge));
  for (const auto header : backEdgeHeaders)
    regionHeaders.insert(header);

  // weigh acyclic regions, recursively descending from each header
  RegionThresholds regionThresholds;
  for (const auto &header : regionHeaders)
    weighRegion(regionHeaders, sites, regionThresholds, header.second);

  // clone function body into temporary function, since cloning a
  // function directly into itself loops forever
  ValueToValueMapTy valueMap;
  const auto clonedFunction(CloneFunction(&function, valueMap, false));
  assert(clonedFunction->getParent() == nullptr);
  for (const auto &mapping : valueMap)
    {
      const auto &fastName(mapping.first->getName());
      if (!fastName.empty())
	mapping.second->setName(fastName + ".slow");
    }

  // discard cloned debug declarations; these are redundant
  for (auto &clonedBlock : clonedFunction->getBasicBlockList())
    {
      SmallVector<Instruction *, 4> chaff;
      for (auto &clonedInstr : clonedBlock | filtered(isDebugDeclare))
	chaff.push_back(&clonedInstr);
      for (const auto &instr : chaff)
	instr->eraseFromParent();
    }

  // move cloned body back into original function
  auto &blockList(function.getBasicBlockList());
  blockList.splice(blockList.end(), clonedFunction->getBasicBlockList());
  const auto clonedAllocaBlock(clonedBlock(valueMap, &entryBlock));

  // rewrite cloned locals (allocas) and args back to originals, then
  // discard cloned alloca block
  const auto boundDeclone(bind(declone, cref(valueMap), _1));
  const auto allocas(make_iterator_range(entryBlock.begin(), BasicBlock::iterator(afterAllocas)));
  for_each(allocas, boundDeclone);
  for_each(function.getArgumentList(), boundDeclone);
  clonedAllocaBlock->eraseFromParent();

  // specialize original and cloned instrumentation
  for (auto &fastBlock : sites | indirected)
    {
      // original instrumentation: remove all but decrement and terminator
      auto &instructions(fastBlock.getInstList());
      while (instructions.size() > 1)
	std::next(instructions.rbegin())->eraseFromParent();
      IRBuilder<> fastBuilder(fastBlock.begin());
      addDecrementCountdown(fastBuilder);

      // cloned instrumentation: decrement and possibly make observation
      const auto slowBlock(clonedBlock(valueMap, &fastBlock));
      const auto observation(SplitBlock(slowBlock, slowBlock->begin(), this));
      observation->setName(slowBlock->getName() + ".observation");
      slowBlock->getTerminator()->eraseFromParent();
      IRBuilder<> slowBuilder(slowBlock);
      const auto decremented(addDecrementCountdown(slowBuilder));
      const auto compared(slowBuilder.CreateICmpEQ(decremented, zero32, "observation-now"));
      const auto observationTerminator(observation->getTerminator());
      assert(observationTerminator->getNumSuccessors() == 1);
      slowBuilder.CreateCondBr(compared, observation, observationTerminator->getSuccessor(0));
      IRBuilder<> observationBuilder(observation->begin());
      const auto call(observationBuilder.CreateCall(getNextEventCountdown, "reset"));
      observationBuilder.CreateStore(call, nextEventCountdown);
    }

  // add threshold check to each region header
  for (const auto &regionHeader : regionHeaders)
    {
      // look up region weight before splicing moves things around
      const auto found(regionThresholds.find(regionHeader.second));
      assert(found != regionThresholds.end());
      const auto threshold(found->second);

      // splice new, completely empty block into fast code
      BasicBlock *crossoverBlock, *fastRegionEntryBlock;
      std::tie(crossoverBlock, fastRegionEntryBlock) = splitEdge(regionHeader);
      crossoverBlock->getTerminator()->eraseFromParent();

      // splice same decision-making block into slow code
      BasicBlock *slowRegionEntryBlock;
      if (regionHeader.first == &entryBlock)
	{
	  slowRegionEntryBlock = clonedBlock(valueMap, regionHeader.second);
	  assert(slowRegionEntryBlock != nullptr);
	}
      else
	{
	  const auto clonedRegionHeader(make_pair(clonedBlock(valueMap, regionHeader.first),
						  clonedBlock(valueMap, regionHeader.second)));
	  BasicBlock *slowCrossoverBlock;
	  std::tie(slowCrossoverBlock, slowRegionEntryBlock) = splitEdge(clonedRegionHeader);
	  slowCrossoverBlock->replaceAllUsesWith(regionHeader.second);
	  slowCrossoverBlock->eraseFromParent();
	}

      // compare countdown to threshold and branch to fast or slow code
      IRBuilder<> crossoverBuilder(crossoverBlock);
      if (threshold <= 1)
	crossoverBuilder.CreateBr(slowRegionEntryBlock);
      else
	{
	  const auto countdown(crossoverBuilder.CreateLoad(nextEventCountdown, "nextEventCountdown"));
	  const auto thresholdValue(ConstantInt::get(int32, threshold));
	  auto imminent(crossoverBuilder.CreateICmpULE(countdown, thresholdValue, "observation-imminent"));
	  if (PredictChecks)
	    imminent = crossoverBuilder.CreateCall2(intrinsicExpect, imminent, zero1, "observation-unexpected");
	  crossoverBuilder.CreateCondBr(imminent, slowRegionEntryBlock, fastRegionEntryBlock);
	}
    }

  return true;
}
