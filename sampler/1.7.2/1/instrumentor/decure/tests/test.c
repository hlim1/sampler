#include <stdio.h>


char *message = "Hi!";


void put(int slot)
{
  putchar(message[slot]);
}


int main()
{
  put(0);
  putchar(message[1]);
  put(2);
  putchar('\n');
}
