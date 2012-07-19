#ifndef INCLUDE_utilities_hh
#define INCLUDE_utilities_hh

#include <llvm/BasicBlock.h>


inline llvm::BasicBlock::iterator after(llvm::Instruction * const instruction)
{
  return ++llvm::BasicBlock::iterator(instruction);
}


inline llvm::BasicBlock::iterator before(llvm::Instruction * const instruction)
{
  return --llvm::BasicBlock::iterator(instruction);
}


#endif	// !INCLUDE_utilities_hh
