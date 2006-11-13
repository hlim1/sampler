#include "String.h"


ODBC::String::String(const char *source)
  : std::basic_string<value_type>((value_type *) source)
{
}
