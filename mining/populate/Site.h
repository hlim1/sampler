#ifndef INCLUDE_populate_Site_h
#define INCLUDE_populate_Site_h

#include <list>
#include "Sample.h"

class PgDatabase;


class Site : public list<Sample>
{
public:
  Site(unsigned long long, const string &, unsigned);

  void copySite(PgDatabase &, const string &) const;
  void copySamples(PgDatabase &, const string &) const;

private:
  const unsigned long long sampleCount;
  const string file;
  const unsigned line;
};


////////////////////////////////////////////////////////////////////////


inline Site::Site(unsigned long long sampleCount,
		  const string &file,
		  unsigned line)
  : sampleCount(sampleCount),
    file(file),
    line(line)
{
}


#endif // !INCLUDE_populate_Site_h
