#include <libpq++/pgdatabase.h>
#include <sstream>
#include "require.h"


const string currval(PgDatabase &database, const char serial[])
{
  ostringstream command;
  command << "SELECT currval('" << serial << "')";
  require(database.ExecTuplesOk(command.str().c_str()), database);
  require(database.Tuples() == 1, "serial value has too many tuples");
  require(database.Fields() == 1, "serial value has too many fields");
  return database.GetValue(0, 0);
}
