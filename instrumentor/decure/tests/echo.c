#include <stdio.h>


int main(int argc, char *argv[])
{
  int scan;

  for (scan = 1; scan < argc; ++scan)
    {
      if (scan > 1)
	putc(' ', stdout);
      fputs(argv[scan], stdout);
    }

  putc('\n', stdout);
  return 0;
}
