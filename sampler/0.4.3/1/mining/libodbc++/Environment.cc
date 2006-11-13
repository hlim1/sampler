#include <sql.h>
#include <sqlext.h>
#include "Environment.h"
#include "check.h"

using namespace ODBC;


Environment::Environment()
  : handle(allocate())
{
  const SQLRETURN status = SQLSetEnvAttr(handle, SQL_ATTR_ODBC_VERSION, (void *) SQL_OV_ODBC3, 0);
  check(status);
}


Environment::~Environment()
{
  SQLFreeHandle(SQL_HANDLE_ENV, handle);
}


SQLHENV Environment::allocate()
{
  SQLHENV handle;
  const SQLRETURN status = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &handle);
  check(status);
  return handle;
}


void Environment::check(SQLRETURN status)
{
  ODBC::check(status, SQL_HANDLE_ENV, SQL_NULL_HANDLE);
}
