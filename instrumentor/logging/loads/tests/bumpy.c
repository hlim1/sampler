#include <ctype.h>


int main()
{
  char *ptr = "123abc";
  unsigned digits = 0;
  
  while (isdigit(*ptr))
    {
      ptr++;
      digits++;
    }

  return 0;
}
