#include <libpq++/pgdatabase.h>
#include <map>
#include <sstream>
#include "File.h"
#include "require.h"
#include "serial.h"


typedef map<string, string> IdMap;
IdMap registry;


void File::upload(PgDatabase &database) const
{
  string &slot = registry[name];
  
  if (slot.empty())
    {
      ostringstream selection;
      selection << "SELECT file FROM files WHERE name = '" << name << '\'';
      require(database.ExecTuplesOk(selection.str().c_str()), database);

      switch (database.Tuples())
	{
	case 0:
	  {
	    ostringstream insertion;
	    insertion << "INSERT INTO files (name) VALUES ('" << name << "')";
	    require(database.ExecCommandOk(insertion.str().c_str()), database);
	    slot = currval(database, "file_seq");
	  }
	  break;

	case 1:
	  require(database.Fields() == 1, "file id has too many fields");
	  slot = database.GetValue(0, 0);
	  break;

	default:
	  require(false, "file id has too many tuples");
	}
    }
}


const string &File::id() const
{
  const string &result = registry[name];
  require(!result.empty(), "unregistered file name");
  return result;
}


bool operator < (const File &a, const File &b)
{
  return a.name < b.name;
}
