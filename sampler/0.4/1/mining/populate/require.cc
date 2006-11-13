#include <libpq++/pgdatabase.h>
#include "require.h"


void require(bool condition, const PgDatabase &database)
{
  require(condition, database.ErrorMessage());
}


void require(bool condition, const char message[])
{
  if (!condition)
    {
      std::cerr << message;
      exit(1);
    }
}
