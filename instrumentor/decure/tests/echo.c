#include <stdio.h>
#include "echo.h"


void echo(char ** strings)
{
  int printed = 0;
  
  if (strings)
    while (*strings)
      {
	if (printed)
	  putc(' ', stdout);
	else
	  printed = 1;
	
	fputs(*strings, stdout);
	++strings;
      }

  if (printed)
    putc('\n', stdout);
}
