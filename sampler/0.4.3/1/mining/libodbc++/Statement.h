#include <sql.h>
#include <string>


namespace ODBC
{
  class Connection;

  
  class Statement
  {
  public:
    Statement(const Connection &);
    ~Statement();

    void bindColumn(SQLSMALLINT, SQLCHAR *, SQLLEN);

    void execDirect(const String &);

  private:
    const SQLHSTMT handle;
    static SQLHSTMT allocate(const Connection &);

    void check(SQLRETURN) const;
  };
}
