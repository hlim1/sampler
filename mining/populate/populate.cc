#include <cstdlib>
#include <iostream>
#include "Connection.h"
#include "Environment.h"
#include "Statement.h"
#include "String.h"

using namespace ODBC;


int main()
{
  Environment environment;
  Connection connection(environment, "PostgreSQL", "", "");
  Statement statement(connection);

  return 0;
}
