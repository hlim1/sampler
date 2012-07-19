#include "Scheme.hh"
#include "SitesRegistry.hh"
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/IRBuilder.h>
#include <llvm/Transforms/Utils/BasicBlockUtils.h>

using namespace llvm;


namespace
{
  class Branches : public Scheme<Branches>
  {
  public:
    static char ID;
    static const char name[];
    enum { arity = 2 };

    bool visitBranchInst(BranchInst &);

  private:
    void instrument(BranchInst &, Constant *, bool);
  };
}


////////////////////////////////////////////////////////////////////////


bool Branches::visitBranchInst(BranchInst &branch)
{
  if (branch.isUnconditional())
    return false;

  const auto siteNum(nextSiteNum());
  instrument(branch, siteNum, false);
  instrument(branch, siteNum, true);
  return true;
}


void Branches::instrument(BranchInst &branch, Constant * const siteNum, const bool condition)
{
  auto block(branch.getParent());
  const unsigned successor(condition);
  const auto after(branch.getSuccessor(successor));
  SplitEdge(block, after, this); // does not always return new block
  const auto instrumentation(branch.getSuccessor(successor));
  sitesRegistry.emplace(branch.getParent()->getParent(), instrumentation);

  IRBuilder<> builder(instrumentation->begin());
  const auto predicate(ConstantInt::get(Type::getInt32Ty(builder.getContext()), condition));
  increment(builder, predicate, siteNum);
}


char Branches::ID;
const char Branches::name[] = "branches";

static const RegisterPass<Branches> registration(Branches::name, "Instrument branch directions");
