#include <libpq++/pgdatabase.h>
#include <sstream>
#include "Site.h"


void Site::copySite(PgDatabase &database, const string &sessionId) const
{
  ostringstream tuples;
  tuples << sessionId << '\t'
	 << sampleCount << '\t'
	 << file << '\t'
	 << line << '\n';

  database.PutLine(tuples.str().c_str());
}


void Site::copySamples(PgDatabase &database, const string &sessionId) const
{
  for (const_iterator sample = begin(); sample != end(); ++sample)
    sample->copy(database, sessionId, sampleCount);
}
