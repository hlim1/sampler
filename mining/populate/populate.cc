#include <libpq++/pgdatabase.h>
#include <sstream>
#include "liblog/decoder.h"
#include "database.h"
#include "progress.h"
#include "require.h"
#include "session.h"


static int populate(unsigned short signum)
{
  ostringstream command;
  command << "INSERT INTO sessions (signal) VALUES (" << signum << ")";
  require(database.ExecCommandOk(command.str().c_str())); 
      
  require(database.ExecTuplesOk("SELECT currval('session_seq')"));
  sessionId = database.GetValue(0, 0);
      
  initializeAlarm();

  switch (yylex())
    {
    case Normal:
      if (signum)
	{
	  cout << "rollback: terminated normally, but with signal " << signum << '\n';
	  return 1;
	}
      else
	{
	  cout << "commit session " << sessionId << ": terminated normally with no signal\n";
	  return 0;
	}
    case Abnormal:
      if (signum)
	{
	  cout << "commit session " << sessionId << ": terminated abnormally with signal " << signum << '\n';
	  return 2;
	}
      else
	{
	  cout << "rollback: terminated abnormally, but no signal\n";
	  return 3;
	}
    default:
      cout << "rollback: garbled trace\n";
      return 4;
    }
}


int main(int argc, char *argv[])
{
  const char usage[] = "usage: populate <signum>\n";
  require(argc == 2, usage);
  istringstream parse(argv[1]);
  unsigned short signum;
  parse >> signum;
  require(parse.good(), usage);
  require(parse.peek() == EOF, usage);
  
  require(!database.ConnectionBad());

  require(database.ExecCommandOk("BEGIN"));
  try
    {
      const int error = populate(signum);
      require(database.ExecCommandOk(error ? "ROLLBACK" : "COMMIT"));
    }
  catch (...)
    {
      cout << "rollback: uncaught exception\n";
      require(database.ExecCommandOk("ROLLBACK"));
      throw;
    }
}
