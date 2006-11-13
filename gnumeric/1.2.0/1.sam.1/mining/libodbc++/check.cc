#include <cstdlib>
#include <iostream>
#include <sql.h>
#include "check.h"

using namespace std;


void ODBC::check(SQLRETURN status, SQLSMALLINT handleType, SQLHANDLE handle)
{
  if (status != SQL_SUCCESS && status != SQL_SUCCESS_WITH_INFO)
    {
      SQLSMALLINT record = 1;
      SQLRETURN status;
      SQLCHAR state[6];
      SQLINTEGER native;
      SQLCHAR message[SQL_MAX_MESSAGE_LENGTH];
      SQLSMALLINT length;
      
      while ((status = SQLGetDiagRec(handleType, handle, record,
				     state, &native,
				     message, sizeof(message), &length))
	     == SQL_SUCCESS)
	{
	  cerr << "ODBC Error " << state << ": " << message << endl;
	  ++record;
	}
      
      if (status != SQL_NO_DATA)
	cerr << "ODBC Error in SQLGetDiagRec" << endl;
      
      exit(2);
    }
}
