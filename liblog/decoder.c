#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include "primitive.h"


enum { StringMax = PATH_MAX };


void slurp(void *buffer, size_t bytes)
{
  fread(buffer, bytes, 1, stdin);
}


int slurpString(char *buffer)
{
  int length = 0;
  int character = getchar();
  if (character == 0 || character == -1)
    return 0;

  while (character != 0 && character != -1)
    {
      if (length < StringMax - 1)
	buffer[length++] = character;

      character = getchar();
    }

  assert(length < StringMax);
  buffer[length] = '\0';
  return 1;
}


/**********************************************************************/


char recentFile[StringMax];


static void file()
{
  slurpString(recentFile);
  if (!feof(stdin))
    printf("%s:", recentFile);
}


static void line()
{
  unsigned line;
  slurp(&line, sizeof line);
  
  if (!feof(stdin))
    printf("%u:\n", line);
}


static int name()
{
  char buffer[StringMax];

  if (slurpString(buffer))
    {
      printf("\t%s == ", buffer);
      return 1;
    }
  else
    return 0;
}


static void value()
{
  switch (getchar())
    {
    case Char:
      {
	char data;
	slurp(&data, sizeof(data));
	printf("%hhu", data);
	break;
      }
    case SignedChar:
      {
	signed char data;
	slurp(&data, sizeof(data));
	printf("%hhd", data);
	break;
      }
    case UnsignedChar:
      {
	unsigned char data;
	slurp(&data, sizeof(data));
	printf("%hhu", data);
	break;
      }
    case Int:
      {
	int data;
	slurp(&data, sizeof(data));
	printf("%d", data);
	break;
      }
    case UnsignedInt:
      {
	unsigned data;
	slurp(&data, sizeof(data));
	printf("%u", data);
	break;
      }
    case Short:
      {
	short data;
	slurp(&data, sizeof(data));
	printf("%hd", data);
	break;
      }
    case UnsignedShort:
      {
	unsigned short data;
	slurp(&data, sizeof(data));
	printf("%hu", data);
	break;
      }
    case Long:
      {
	long data;
	slurp(&data, sizeof(data));
	printf("%ld", data);
	break;
      }
    case UnsignedLong:
      {
	unsigned long data;
	slurp(&data, sizeof(data));
	printf("%lu", data);
	break;
      }
    case LongLong:
      {
	long long data;
	slurp(&data, sizeof(data));
	printf("%Ld", data);
	break;
      }
    case UnsignedLongLong:
      {
	unsigned long long data;
	slurp(&data, sizeof(data));
	printf("%Lu", data);
	break;
      }
    case Float:
      {
	float data;
	slurp(&data, sizeof(data));
	printf("%g", data);
	break;
      }
    case Double:
      {
	double data;
	slurp(&data, sizeof(data));
	printf("%g", data);
	break;
      }
    case LongDouble:
      {
	long double data;
	slurp(&data, sizeof(data));
	printf("%Lg", data);
	break;
      }
    case Pointer:
      {
	void *data;
	slurp(&data, sizeof(data));
	printf("%p", data);
	break;
      }
    case EOF:
      break;
    default:
      assert(0);
    }

  putchar('\n');
}


/**********************************************************************/


int main()
{
  const int character = getchar();
  assert(character != 0);
  ungetc(character, stdin);

  do
    {
      file();
      line();

      while (name())
	value();
    }
  while (!feof(stdin));
  
  return 0;
}
