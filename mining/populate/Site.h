#ifndef INCLUDE_populate_Site_h
#define INCLUDE_populate_Site_h

#include <list>
#include "File.h"
#include "Sample.h"

class PgDatabase;


class Site : public list<Sample>
{
public:
  Site(unsigned long long, const string &, unsigned);

  void registerFiles(PgDatabase &) const;
  void copySite(PgDatabase &, unsigned) const;
  void copySamples(PgDatabase &, unsigned) const;

private:
  const unsigned long long sampleCount;
  const File file;
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
