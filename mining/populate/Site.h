#ifndef INCLUDE_populate_Site_h
#define INCLUDE_populate_Site_h

#include <list>
#include <stdint.h>
#include "File.h"
#include "Samples.h"

class PgDatabase;


class Site
{
public:
  Site(unsigned long long, const string &, unsigned);

  void registerFiles(PgDatabase &) const;
  void copySite(PgDatabase &, unsigned) const;

  template<typename T> void addSample(const Sample<T> &);
  template<typename T> void copySamples(PgDatabase &, unsigned) const;

private:
  const unsigned long long sampleCount;
  const File file;
  const unsigned line;

  template<typename T> void copySamples(PgDatabase &, unsigned, const Samples<T> &) const;

  Samples<int8_t> int8s;
  Samples<uint8_t> uint8s;
  Samples<int16_t> int16s;
  Samples<uint16_t> uint16s;
  Samples<int32_t> int32s;
  Samples<uint32_t> uint32s;
  Samples<int64_t> int64s;
  Samples<uint64_t> uint64s;
  Samples<float> float32s;
  Samples<double> float64s;
  Samples<long double> float96s;
  Samples<const void *> pointer32s;
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
