#ifndef INCLUDE_populate_Sample_h
#define INCLUDE_populate_Sample_h

#include <liblog/primitive.h>
#include <string>

class PgDatabase;


class Sample
{
public:
  Sample(const string &, PrimitiveType, const string &);
  
  void copy(PgDatabase &, const string &, unsigned long long) const;

private:
  const string expression;
  const PrimitiveType typeCode;
  const string value;
};


////////////////////////////////////////////////////////////////////////


inline Sample::Sample(const string &expression,
		      PrimitiveType typeCode,
		      const string &value)
  : expression(expression),
    typeCode(typeCode),
    value(value)
{
}


#endif // !INCLUDE_populate_Site_h
