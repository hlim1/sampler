#ifndef INCLUDE_populate_Session_h
#define INCLUDE_populate_Session_h

#include <list>
#include "Site.h"

class PgDatabase;


class Session : public list<Site>
{
public:
  static Session singleton;

  void upload(PgDatabase &,
	      const char application[],
	      unsigned sparsity,
	      unsigned seed,
	      unsigned inputSize,
	      unsigned short signum) const;

private:
  template<typename T> void uploadSamples(PgDatabase &, unsigned) const;
};


#endif // !INCLUDE_populate_Session_h
