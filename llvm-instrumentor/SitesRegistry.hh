#ifndef INCLUDE_SitesRegistry_hh
#define INCLUDE_SitesRegistry_hh

#include <unordered_map>
#include <unordered_set>

namespace llvm
{
  class BasicBlock;
  class Function;
}


class SitesRegistry
{
private:
  typedef std::unordered_multimap<const llvm::Function *, llvm::BasicBlock *> Map;
  typedef Map::const_iterator const_iterator;
  typedef Map::iterator iterator;

  Map sitesInFunction;
  std::unordered_set<const llvm::BasicBlock *> sites;

public:
  void emplace(const llvm::Function *, llvm::BasicBlock *);
  const_iterator end() const;
  std::pair<iterator, iterator> equal_range(const llvm::Function *);

  bool contains(const llvm::BasicBlock *) const;
};

extern SitesRegistry sitesRegistry;


////////////////////////////////////////////////////////////////////////


inline void SitesRegistry::emplace(const llvm::Function *function, llvm::BasicBlock *block)
{
  sitesInFunction.emplace(function, block);
  sites.insert(block);
}


inline SitesRegistry::const_iterator SitesRegistry::end() const
{
  return sitesInFunction.end();
}


inline std::pair<SitesRegistry::iterator, SitesRegistry::iterator> SitesRegistry::equal_range(const llvm::Function *function)
{
  return sitesInFunction.equal_range(function);
}


inline bool SitesRegistry::contains(const llvm::BasicBlock *block) const
{
  return sites.find(block) != sites.end();
}


#endif	// !INCLUDE_SitesRegistry_hh
