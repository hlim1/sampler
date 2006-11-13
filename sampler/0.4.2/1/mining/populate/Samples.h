#ifndef INCLUDE_populate_Samples_h
#define INCLUDE_populate_Samples_h

#include <list>
#include "Sample.h"


template<typename T> class Samples : public list<Sample<T> >
{
public:
  void copy(PgDatabase &, unsigned, unsigned long long) const;
};


////////////////////////////////////////////////////////////////////////


template<typename T>
void Samples<T>::copy(PgDatabase &database, unsigned sessionId,
		      unsigned long long sampleCount) const
{
  for (const_iterator sample = begin(); sample != end(); ++sample)
    sample->copy(database, sessionId, sampleCount);
}


#endif // !INCLUDE_populate_Site_h
