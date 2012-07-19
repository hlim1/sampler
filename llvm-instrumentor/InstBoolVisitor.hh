#ifndef INCLUDE_InstBoolVisitor_hh
#define INCLUDE_InstBoolVisitor_hh

#include <llvm/Support/InstVisitor.h>


template <class Subclass>
class InstBoolVisitor : public llvm::InstVisitor<Subclass, bool>
{
public:
  bool visit(llvm::Module &);
  bool visit(llvm::Function &);
  bool visit(llvm::BasicBlock &);
  bool visit(llvm::Instruction &);

  template <class Referent> bool visit(Referent *);

  bool visitModule(llvm::Module &);
  bool visitFunction(llvm::Function &);
  bool visitInstruction(llvm::Instruction &);
  bool visitBasicBlock(llvm::BasicBlock &);

private:
  Subclass *downcast();
  template <class Container> bool recurse(bool (Subclass::*)(Container &), Container &);
  template <class Container> bool recurse(bool (InstBoolVisitor<Subclass>::*)(Container &), Container &);
};


////////////////////////////////////////////////////////////////////////


template <class Subclass> inline Subclass *InstBoolVisitor<Subclass>::downcast()
{
  return static_cast<Subclass *>(this);
}


template <class Subclass> template <class Container> inline bool InstBoolVisitor<Subclass>::recurse(bool (Subclass::* visitSelf)(Container &), Container &container)
{
  auto result((downcast()->*visitSelf)(container));
  for (auto &child : container)
    result |= downcast()->visit(child);
  return result;
}


template <class Subclass> template <class Component> inline bool InstBoolVisitor<Subclass>::recurse(bool (InstBoolVisitor<Subclass>::* visitSelf)(Component &), Component &component)
{
  return recurse(static_cast<bool (Subclass::*)(Component &)>(visitSelf), component);
}


template <class Subclass> bool InstBoolVisitor<Subclass>::visit(llvm::Module &module)
{
  return recurse(Subclass::visitModule, module);
}


template <class Subclass> bool InstBoolVisitor<Subclass>::visit(llvm::Function &function)
{
  return recurse(Subclass::visitFunction, function);
}


template <class Subclass> bool InstBoolVisitor<Subclass>::visit(llvm::BasicBlock &block)
{
  return recurse(&Subclass::visitBasicBlock, block);
}


template <class Subclass> inline bool InstBoolVisitor<Subclass>::visit(llvm::Instruction &instruction)
{
  return llvm::InstVisitor<Subclass, bool>::visit(instruction);
}


template <class Subclass> template <class Referent> inline bool InstBoolVisitor<Subclass>::visit(Referent *pointer)
{
  return visit(*pointer);
}


template <class Subclass> inline bool InstBoolVisitor<Subclass>::visitModule(llvm::Module &)
{
  return false;
}


template <class Subclass> inline bool InstBoolVisitor<Subclass>::visitFunction(llvm::Function &)
{
  return false;
}


template <class Subclass> inline bool InstBoolVisitor<Subclass>::visitBasicBlock(llvm::BasicBlock &)
{
  return false;
}


template <class Subclass> inline bool InstBoolVisitor<Subclass>::visitInstruction(llvm::Instruction &)
{
  return false;
}


#endif // !INCLUDE_InstBoolVisitor_hh
