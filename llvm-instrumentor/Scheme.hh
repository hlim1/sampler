#ifndef INCLUDE_Scheme_hh
#define INCLUDE_Scheme_hh

#include "InstBoolVisitor.hh"
#include "SchemeBase.hh"


template<typename Subclass>
class Scheme : public SchemeBase, public InstBoolVisitor<Subclass>
{
protected:
  Scheme();

  using SchemeBase::doInitialization;
  bool doInitialization(llvm::Module &) override;

  bool runOnBasicBlock(llvm::BasicBlock &) override;
};


////////////////////////////////////////////////////////////////////////

#include "SitesRegistry.hh"


template<typename Subclass> inline Scheme<Subclass>::Scheme()
  : SchemeBase(Subclass::ID)
{
}


template<typename Subclass> inline bool Scheme<Subclass>::doInitialization(llvm::Module &module)
{
  prepare(module, Subclass::name, Subclass::arity);
  return false;
}


template<typename Subclass> inline bool Scheme<Subclass>::runOnBasicBlock(llvm::BasicBlock &block)
{
  return sitesRegistry.contains(&block) ? false : this->visit(block);
}


#endif // !INCLUDE_Scheme_hh
