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


template <typename T>
T parse(const char text[], const char usage[])
{
  istringstream parse(text);
  T result;
  parse >> result;
  require(parse.good(), usage);
  require(parse.peek() == EOF, usage);
  return result;
}


int main(int argc, char *argv[])
{
  static const char usage[] = "usage: populate <application> <sparsity> <seed> <input-size> <signum>\n";
  require(argc == 6, usage);
  
  const char * const *arg = &argv[1];
  const char *application = *arg++;
  const unsigned sparsity = parse<unsigned>(*arg++, usage);
  const unsigned seed = parse<unsigned>(*arg++, usage);
  const unsigned inputSize = parse<unsigned>(*arg++, usage);
  const unsigned short signum = parse<unsigned short>(*arg++, usage);
  
  const int error = decode(signum);
  if (error)
    return error;

  PgDatabase database("");
  require(!database.ConnectionBad(), database);

  require(database.ExecCommandOk("BEGIN"), database);
  Session::singleton.upload(database, application, sparsity, seed, inputSize, signum);
  cerr << "commit: " << flush;
  require(database.ExecCommandOk("COMMIT"), database);
  cerr << "done" << endl;

  return 0;
}
