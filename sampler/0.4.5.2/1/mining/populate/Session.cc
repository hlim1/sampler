#include <libpq++/pgdatabase.h>
#include <sstream>
#include "PrimitiveTraits.h"
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
  
  uploadSamples<int8_t>(database, sessionId);
  uploadSamples<uint8_t>(database, sessionId);
  uploadSamples<int16_t>(database, sessionId);
  uploadSamples<uint16_t>(database, sessionId);
  uploadSamples<int32_t>(database, sessionId);
  uploadSamples<uint32_t>(database, sessionId);
  uploadSamples<int64_t>(database, sessionId);
  uploadSamples<uint64_t>(database, sessionId);
  uploadSamples<float>(database, sessionId);
  uploadSamples<double>(database, sessionId);
  uploadSamples<long double>(database, sessionId);
  uploadSamples<const void *>(database, sessionId);
}


template<typename T>
void Session::uploadSamples(PgDatabase &database, unsigned sessionId) const
{
  const char *name = PrimitiveTraits<T>::name;
  
  ostringstream title;
  title << "upload sites' samples: " << name;
  Progress progress(title.str(), size());
  
  ostringstream command;
  command << "COPY samples_" << name << " FROM STDIN";
  const ExecStatusType status = database.Exec(command.str().c_str());
  require(status == PGRES_COPY_IN, database);
  
  for (const_iterator site = begin(); site != end(); ++site)
    {
      site->template copySamples<T>(database, sessionId);
      progress.bump();
    }
    
  database.PutLine("\\.\n");
  const int error = database.EndCopy();
  require(!error, database);
}
