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


void Site::copySamples(PgDatabase &database, unsigned sessionId) const
{
  for (const_iterator sample = begin(); sample != end(); ++sample)
    sample->copy(database, sessionId, sampleCount);
}
