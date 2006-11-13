#include <sql.h>
#include <sqlext.h>
#include "Connection.h"
#include "Statement.h"
#include "String.h"
#include "check.h"

using namespace ODBC;


Statement::Statement(const Connection &connection)
  : handle(allocate(connection))
{
}


Statement::~Statement()
{
  SQLDisconnect(handle);
  SQLFreeHandle(SQL_HANDLE_STMT, handle);
}


SQLHSTMT Statement::allocate(const Connection &connection)
{
  SQLHSTMT handle;
  const SQLRETURN status = SQLAllocHandle(SQL_HANDLE_STMT, connection.handle, &handle);
  connection.check(status);
  return handle;
}


void Statement::check(SQLRETURN status) const
{
  ODBC::check(status, SQL_HANDLE_STMT, handle);
}


void Statement::bindColumn(SQLSMALLINT column, SQLCHAR *buffer, SQLLEN size)
{
  const SQLRETURN status = SQLBindCol(handle, column, SQL_C_CHAR, buffer, size, 0);
  check(status);
}


void Statement::execDirect(const String &statement)
{
  const SQLRETURN status = SQLExecDirect(handle, const_cast<SQLCHAR *>(statement.data()), statement.size());
  check(status);
}
