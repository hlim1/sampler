#include <sql.h>
#include <sqlext.h>
#include "Connection.h"
#include "Environment.h"
#include "String.h"
#include "check.h"

using namespace ODBC;


Connection::Connection(const Environment &environment,
		       const String &server,
		       const String &user,
		       const String &password)
  : handle(allocate(environment))
{
  check(SQLConnect(handle,
		   const_cast<SQLCHAR *>(server.data()), server.size(),
		   const_cast<SQLCHAR *>(user.data()), user.size(),
		   const_cast<SQLCHAR *>(password.data()), password.size()));
}


Connection::~Connection()
{
  SQLDisconnect(handle);
  SQLFreeHandle(SQL_HANDLE_DBC, handle);
}


SQLHDBC Connection::allocate(const Environment &environment)
{
  SQLHDBC handle;
  const SQLRETURN status = SQLAllocHandle(SQL_HANDLE_DBC, environment.handle, &handle);
  environment.check(status);
  return handle;
}


void Connection::check(SQLRETURN status) const
{
  ODBC::check(status, SQL_HANDLE_DBC, handle);
}
