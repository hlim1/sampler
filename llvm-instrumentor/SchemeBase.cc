#include "SchemeBase.hh"
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>

using namespace llvm;
using namespace std;


ArrayType *SchemeBase::deconstructCountersType() const
{
  const auto countersType(counters->getType());
  const auto pointerType(cast<PointerType>(countersType));
  const auto outerArrayType(cast<ArrayType>(pointerType->getElementType()));
  const auto innerArrayType(cast<ArrayType>(outerArrayType->getElementType()));

  assert(outerArrayType->getNumElements() == 0);
  assert(innerArrayType->getElementType()->isIntegerTy());

  return innerArrayType;
}


void SchemeBase::prepare(Module &module, StringRef schemeName, unsigned schemeArity __attribute__((unused)))
{
  auto &context(module.getContext());
  int32 = Type::getInt32Ty(context);
  zero = ConstantInt::get(int32, 0);

  static const StringRef prefix("cbi_");
  static const StringRef suffix("Counters");
  SmallVector<char, 32> buffer;
  const auto countersName((prefix + schemeName + suffix).toStringRef(buffer));
  counters = module.getNamedGlobal(countersName);
  nextSiteNum_ = 0;

#ifndef NDEBUG
  const auto innerArrayType(deconstructCountersType());
  assert(innerArrayType->getNumElements() == schemeArity);
#endif	// !NDEBUG
}


bool SchemeBase::doFinalization(llvm::Module &)
{
  if (nextSiteNum_ == 0)
    return false;

  const auto innerArrayType(deconstructCountersType());
  const auto newOuterArrayType(ArrayType::get(innerArrayType, nextSiteNum_));
  const auto newPointerType(PointerType::getUnqual(newOuterArrayType));

  counters->mutateType(newPointerType);
  counters->getInitializer()->mutateType(newOuterArrayType);
  return true;
}


void SchemeBase::increment(IRBuilder<> &builder, Value *predicate, Constant *siteNum) const
{
  Value * const indexes[] = {
    zero,
    siteNum,
    predicate,
  };
  const auto counter(builder.CreateInBoundsGEP(counters, indexes, "counter"));
  const auto load(builder.CreateLoad(counter, "original"));
  const auto one(ConstantInt::get(load->getType(), 1));
  const auto add(builder.CreateAdd(load, one, "incremented", true));
  builder.CreateStore(add, counter);
}
