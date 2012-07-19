#include "Scheme.hh"
#include "SitesRegistry.hh"
#include "utilities.hh"
#include <llvm/Support/IRBuilder.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/Utils/BasicBlockUtils.h>

using namespace llvm;


namespace
{
  class Returns : public Scheme<Returns>
  {
  public:
    static char ID;
    static const char name[];
    enum { arity = 3 };

    bool visitCallInst(CallInst &);
    bool visitInvokeInst(InvokeInst &);

  private:
    bool instrument(Instruction &);
  };
}


////////////////////////////////////////////////////////////////////////


static bool isInterestingType(const Type &type)
{
  switch (type.getTypeID())
    {
      // enums appear here as integers
    case Type::IntegerTyID:
    case Type::PointerTyID:
      return true;
    default:
      return false;
    }
}


bool Returns::visitCallInst(CallInst &call)
{
  const auto instrumented(instrument(call));
  if (instrumented)
    call.setTailCall(false);
  return instrumented;
}


inline bool Returns::visitInvokeInst(InvokeInst &invoke)
{
  return instrument(invoke);
}


bool Returns::instrument(Instruction &call)
{
  if (!isInterestingType(*call.getType()))
    return false;

  const auto callBlock(call.getParent());
  const auto function(callBlock->getParent());

  const auto instrumentation(SplitBlock(callBlock, after(&call), this));
  const auto __attribute__((unused)) afterInstrumentation(SplitEdge(callBlock, instrumentation, this));
  assert(callBlock == instrumentation->getSinglePredecessor());
  assert(instrumentation == afterInstrumentation->getSinglePredecessor());
  sitesRegistry.emplace(function, instrumentation);

  IRBuilder<> builder(instrumentation->begin());
  const auto zero(ConstantInt::get(call.getType(), 0));
  const auto gt(builder.CreateICmpSGT(&call, zero, "positive"));
  const auto ge(builder.CreateICmpSGE(&call, zero, "non-negative"));
  const auto predicate(builder.CreateAdd(gt, ge, "slot", true));
  increment(builder, predicate);

  return true;
}


char Returns::ID;
const char Returns::name[] = "returns";

static const RegisterPass<Returns> registration(Returns::name, "Instrument values returned to callers");
