#include <liblog/decoder.h>
#include <libpq++/pgdatabase.h>
#include <sstream>
#include "Session.h"
#include "require.h"


static int decode(unsigned short signum)
{
  switch (yylex())
    {
    case Normal:
      if (signum)
	{
	  cout << "bad: terminated normally, but with signal " << signum << '\n';
	  return 1;
	}
      else
	{
	  cout << "good: terminated normally with no signal\n";
	  return 0;
	}
    case Abnormal:
      if (signum)
	{
	  cout << "good: terminated abnormally with signal " << signum << '\n';
	  return 0;
	}
      else
	{
	  cout << "bad: terminated abnormally, but no signal\n";
	  return 2;
	}
    default:
      cout << "bad: garbled trace\n";
      return 3;
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
  
  const int error = decode(signum);
  if (error)
    return error;

  PgDatabase database("");
  require(!database.ConnectionBad(), database);

  require(database.ExecCommandOk("BEGIN"), database);
  Session::singleton.upload(database, signum);
  cerr << "commit: " << flush;
  require(database.ExecCommandOk("COMMIT"), database);
  cerr << "done" << endl;

  return 0;
}
