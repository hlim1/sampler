#ifndef INCLUDE_populate_Session_h
#define INCLUDE_populate_Session_h

#include <list>
#include "Site.h"

class PgDatabase;


struct Session : public list<Site>
{
  static Session singleton;

  void upload(PgDatabase &, unsigned short) const;
};


#endif // !INCLUDE_populate_Session_h
