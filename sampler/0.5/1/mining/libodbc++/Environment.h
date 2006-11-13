#include <sql.h>


namespace ODBC
{
  class Environment
  {
  public:
    Environment();
    ~Environment();

    const SQLHENV handle;
    static void check(SQLRETURN);

  private:
    static SQLHENV allocate();
  };
}
