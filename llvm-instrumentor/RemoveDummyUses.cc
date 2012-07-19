#include <llvm/Module.h>
#include <llvm/Pass.h>

using namespace llvm;


namespace
{
  class RemoveDummyUses : public ModulePass
  {
  public:
    static char ID;
    RemoveDummyUses();
    bool runOnModule(Module &) override;
  };
}


////////////////////////////////////////////////////////////////////////


inline RemoveDummyUses::RemoveDummyUses()
  : ModulePass(ID)
{
}


bool RemoveDummyUses::runOnModule(Module &module)
{
  module.getFunction("cbi_dummyUsesToKeepDeclarations")->eraseFromParent();
  return true;
}


char RemoveDummyUses::ID;

static const RegisterPass<RemoveDummyUses> registration("remove-dummy-uses", "Remove dummy uses of declarations of symbols used by CBI instrumentation");
