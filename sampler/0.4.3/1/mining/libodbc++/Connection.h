#include <sql.h>


namespace ODBC
{
  class Environment;
  class String;

  
  class Connection
  {
  public:
    Connection(const Environment &, const String &, const String &, const String &);
    ~Connection();

    const SQLHDBC handle;
    void check(SQLRETURN) const;

  private:
    static SQLHDBC allocate(const Environment &);
  };
}
