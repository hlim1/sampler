#include <libpq++/pgdatabase.h>
#include <sstream>
#include "Session.h"
#include "require.h"


Session Session::singleton;


void Session::upload(PgDatabase &database, unsigned short signum) const
{
  ostringstream command;
  command << "INSERT INTO sessions (signal) VALUES (" << signum << ")";
  require(database.ExecCommandOk(command.str().c_str()), database);
      
  require(database.ExecTuplesOk("SELECT currval('session_seq')"), database);
  const string sessionId = database.GetValue(0, 0);

  {
    const ExecStatusType status = database.Exec("COPY sites FROM STDIN");
    require(status == PGRES_COPY_IN, database);
    
    for (const_iterator site = begin(); site != end(); ++site)
      site->copySite(database, sessionId);
    
    database.PutLine("\\.\n");
    const int error = database.EndCopy();
    require(!error, database);
  }
  
  {
    const ExecStatusType status = database.Exec("COPY samples FROM STDIN");
    require(status == PGRES_COPY_IN, database);
    
    for (const_iterator site = begin(); site != end(); ++site)
      site->copySamples(database, sessionId);

    database.PutLine("\\.\n");
    const int error = database.EndCopy();
    require(!error, database);
  }
}
