#include "Scheme.hh"
#include "SitesRegistry.hh"
#include "utilities.hh"
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/IRBuilder.h>
#include <llvm/Transforms/Utils/BasicBlockUtils.h>
#include <vector>

using namespace llvm;


namespace
{
  class Dummy : public Scheme<Dummy>
  {
  public:
    static char ID;
    static const char name[];
    enum { arity = 1 };

    bool visitStoreInst(StoreInst &);
    using SchemeBase::doFinalization;
    bool doFinalization(Function &) override;

    std::vector<StoreInst *> sites;
  };
}


////////////////////////////////////////////////////////////////////////


bool Dummy::visitStoreInst(StoreInst &store)
{
  if (const auto receiver = dyn_cast<GlobalValue>(store.getPointerOperand()))
    if (receiver->getName() == "dummy")
      sites.push_back(&store);

  return false;
}


bool Dummy::doFinalization(Function &)
{
  for (const auto store : sites)
    {
      auto pre(store->getParent());
      auto instrumentation(SplitBlock(pre, store, this));
      auto post(SplitBlock(instrumentation, after(store), this));
      instrumentation->setName(pre->getName() + ".dummy.instrumentation");
      post->setName(pre->getName() + ".dummy.after");
      sitesRegistry.emplace(instrumentation->getParent(), instrumentation);
    }

  return !sites.empty();
}


char Dummy::ID;
const char Dummy::name[] = "dummy";

static const RegisterPass<Dummy> registration(Dummy::name, "Instrument stores to a dummy variable");
