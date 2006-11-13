#ifndef INCLUDE_populate_Sample_h
#define INCLUDE_populate_Sample_h

#include <liblog/primitive.h>
#include <libpq++/pgdatabase.h>
#include <sstream>
#include <string>
#include "Sample.h"


template<typename T> class Sample
{
public:
  Sample(const string &, T);
  
  void copy(PgDatabase &, unsigned, unsigned long long) const;

private:
  void serialize(ostream &) const;
  
  const string expression;
  const T value;
};


////////////////////////////////////////////////////////////////////////


template<typename T> inline
void Sample<T>::serialize(ostream &sink) const
{
  sink << value;
}


template<typename T> inline
Sample<T>::Sample(const string &expression, T value)
  : expression(expression),
    value(value)
{
}


template<> inline
void Sample<int8_t>::serialize(ostream &sink) const
{
  sink << int(value);
}


template<> inline
void Sample<uint8_t>::serialize(ostream &sink) const
{
  sink << uint(value);
}


template<> inline
void Sample<const void *>::serialize(ostream &sink) const
{
  sink << intptr_t(value);
}


template<typename T>
void Sample<T>::copy(PgDatabase &database, unsigned sessionId,
		     unsigned long long sampleCount) const
{
  ostringstream tuples;
  tuples << sessionId << '\t'
	 << sampleCount << '\t'
	 << expression << '\t';
  serialize(tuples);
  tuples << '\n';

  database.PutLine(tuples.str().c_str());
}


#endif // !INCLUDE_populate_Site_h
