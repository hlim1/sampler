#include <iostream>
#include <libpq++/pgdatabase.h>


PgDatabase database("");


void require(bool condition)
{
  if (!condition)
    {
      std::cerr << database.ErrorMessage();
      exit(1);
    }
}


int main()
{
  require(!database.ConnectionBad());
  require(database.ExecCommandOk("CREATE TEMPORARY TABLE import_session ("
				 "expression text NOT NULL CHECK (expression <> ''),"
				 "type smallint NOT NULL CHECK (type BETWEEN 1 AND 15),"
				 "value text NOT NULL CHECK (value <> '')"
				 ")"));
  require(database.ExecCommandOk("CREATE TEMPORARY TABLE import_site ("
				 "expression text NOT NULL CHECK (expression <> ''),"
				 "type smallint NOT NULL CHECK (type BETWEEN 1 AND 15),"
				 "value text NOT NULL CHECK (value <> '')"
				 ")"));
  
  return 0;
}
