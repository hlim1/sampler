#include "database.h"
#include "require.h"


void require(bool condition)
{
  require(condition, database.ErrorMessage());
}


void require(bool condition, const char message[])
{
  if (!condition)
    {
      std::cerr << message;
      exit(1);
    }
}
