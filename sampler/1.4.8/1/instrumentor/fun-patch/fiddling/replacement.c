#include <stdio.h>


extern void heartbeat();


int subtract_replacement(int a, int b)
{
  printf("trace: %d - %d\n", a, b);
  heartbeat();
  return a - b;
}
