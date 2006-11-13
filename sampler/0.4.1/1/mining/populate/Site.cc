#include <libpq++/pgdatabase.h>
#include <sstream>
#include "Site.h"


void Site::registerFiles(PgDatabase &database) const
{
  file.upload(database);
}


void Site::copySite(PgDatabase &database, unsigned sessionId) const
{
  ostringstream tuples;
  tuples << sessionId << '\t'
	 << sampleCount << '\t'
	 << file.id() << '\t'
	 << line << '\n';

  database.PutLine(tuples.str().c_str());
}


////////////////////////////////////////////////////////////////////////


template<>
void Site::addSample(const Sample<int8_t> &sample)
{
  int8s.push_back(sample);
}


template<>
void Site::addSample(const Sample<uint8_t> &sample)
{
  uint8s.push_back(sample);
}


template<>
void Site::addSample(const Sample<int16_t> &sample)
{
  int16s.push_back(sample);
}


template<>
void Site::addSample(const Sample<uint16_t> &sample)
{
  uint16s.push_back(sample);
}


template<>
void Site::addSample(const Sample<int32_t> &sample)
{
  int32s.push_back(sample);
}


template<>
void Site::addSample(const Sample<uint32_t> &sample)
{
  uint32s.push_back(sample);
}


template<>
void Site::addSample(const Sample<int64_t> &sample)
{
  int64s.push_back(sample);
}


template<>
void Site::addSample(const Sample<uint64_t> &sample)
{
  uint64s.push_back(sample);
}


template<>
void Site::addSample(const Sample<float> &sample)
{
  float32s.push_back(sample);
}


template<>
void Site::addSample(const Sample<double> &sample)
{
  float64s.push_back(sample);
}


template<>
void Site::addSample(const Sample<long double> &sample)
{
  float96s.push_back(sample);
}


template<>
void Site::addSample(const Sample<const void *> &sample)
{
  pointer32s.push_back(sample);
}


////////////////////////////////////////////////////////////////////////


template<typename T>
void Site::copySamples(PgDatabase &database, unsigned sessionId, const Samples<T> &samples) const
{
  for (Samples<T>::const_iterator sample = samples.begin(); sample != samples.end(); ++sample)
    sample->copy(database, sessionId, sampleCount);
}


template<>
void Site::copySamples<int8_t>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, int8s);
}


template<>
void Site::copySamples<uint8_t>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, uint8s);
}


template<>
void Site::copySamples<int16_t>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, int16s);
}


template<>
void Site::copySamples<uint16_t>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, uint16s);
}


template<>
void Site::copySamples<int32_t>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, int32s);
}


template<>
void Site::copySamples<uint32_t>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, uint32s);
}


template<>
void Site::copySamples<int64_t>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, int64s);
}


template<>
void Site::copySamples<uint64_t>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, uint64s);
}


template<>
void Site::copySamples<float>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, float32s);
}


template<>
void Site::copySamples<double>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, float64s);
}


template<>
void Site::copySamples<long double>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, float96s);
}


template<>
void Site::copySamples<const void *>(PgDatabase &database, unsigned sessionId) const
{
  copySamples(database, sessionId, pointer32s);
}
