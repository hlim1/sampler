#include <libpq++/pgdatabase.h>
#include <sstream>
#include "Progress.h"
#include "Session.h"
#include "quote.h"
#include "require.h"
#include "serial.h"


Session Session::singleton;


void Session::upload(PgDatabase &database,
		     const char application[],
		     unsigned sparsity,
		     unsigned seed,
		     unsigned inputSize,
		     unsigned short signum) const
{
  ostringstream command;
  command << "INSERT INTO sessions (session, application, sparsity, seed, inputSize, signal) VALUES ("
	  << seed << ", '"
	  << quote(application) << "', "
	  << sparsity << ", "
	  << seed << ", "
	  << inputSize << ", "
	  << signum << ')';
  require(database.ExecCommandOk(command.str().c_str()), database);

  const unsigned sessionId = seed;

  {
    Progress progress("upload files", size());
    
    for (const_iterator site = begin(); site != end(); ++site)
      {
	site->registerFiles(database);
	progress.bump();
      }
  }

  {
    Progress progress("upload sites", size());
    const ExecStatusType status = database.Exec("COPY sites FROM STDIN");
    require(status == PGRES_COPY_IN, database);
    
    for (const_iterator site = begin(); site != end(); ++site)
      {
	site->copySite(database, sessionId);
	progress.bump();
      }
    
    database.PutLine("\\.\n");
    const int error = database.EndCopy();
    require(!error, database);
  }
  
  {
    Progress progress("upload sites' samples", size());
    const ExecStatusType status = database.Exec("COPY samples FROM STDIN");
    require(status == PGRES_COPY_IN, database);
    
    for (const_iterator site = begin(); site != end(); ++site)
      {
	site->copySamples(database, sessionId);
	progress.bump();
      }
    
    database.PutLine("\\.\n");
    const int error = database.EndCopy();
    require(!error, database);
  }
}
