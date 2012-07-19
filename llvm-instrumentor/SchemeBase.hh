#ifndef INCLUDE_SchemeBase_hh
#define INCLUDE_SchemeBase_hh

#include "InstBoolVisitor.hh"
#include <llvm/Pass.h>
#include <llvm/Support/IRBuilder.h>


class SchemeBase : public llvm::BasicBlockPass
{
protected:
  explicit SchemeBase(char &);

  void prepare(llvm::Module &, llvm::StringRef, unsigned);
  llvm::Type *int32;
  llvm::Constant *zero;
  llvm::GlobalVariable *counters;

  using llvm::BasicBlockPass::doFinalization;
  bool doFinalization(llvm::Module &) override;

  llvm::Constant *nextSiteNum();
  void increment(llvm::IRBuilder<> &, llvm::Value *);
  void increment(llvm::IRBuilder<> &, llvm::Value *, llvm::Constant *) const;

private:
  unsigned nextSiteNum_;

  llvm::ArrayType *deconstructCountersType() const;
};


////////////////////////////////////////////////////////////////////////


inline SchemeBase::SchemeBase(char &id)
  : BasicBlockPass(id)
    // other fields initialized in SchemeBase::prepare
{
}



inline llvm::Constant *SchemeBase::nextSiteNum()
{
  const auto claimed(nextSiteNum_++);
  return llvm::ConstantInt::get(int32, claimed);
}


inline void SchemeBase::increment(llvm::IRBuilder<> &builder, llvm::Value *predicate)
{
  increment(builder, predicate, nextSiteNum());
}

  
#endif // !INCLUDE_SchemeBase_hh
