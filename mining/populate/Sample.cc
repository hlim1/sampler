#include <libpq++/pgdatabase.h>
#include <sstream>
#include "Sample.h"


void Sample::copy(PgDatabase &database, unsigned sessionId, unsigned long long sampleCount) const
{
  ostringstream tuples;
  tuples << sessionId << '\t'
	 << sampleCount << '\t'
	 << expression << '\t'
	 << typeCode << '\t'
	 << value << '\n';

  database.PutLine(tuples.str().c_str());
}
