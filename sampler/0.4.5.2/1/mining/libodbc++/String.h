#include <sql.h>
#include <string>


namespace ODBC
{
  class String : public std::basic_string<SQLCHAR>
  {
  public:
    String(const char *);
  };
}
