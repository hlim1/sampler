%{
#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include "primitive.h"

static char recentFile[PATH_MAX];
%}

%option main
%option nodefault

%x FILENAME
%x LINE
%x EXPR
%x EXPR0
%x VALUE
%x END

null	\0
string	[ -~]+{null}
byte	.|\n


%%


<INITIAL,FILENAME>{string} {
  strncpy(recentFile, yytext, PATH_MAX - 1);
  printf("%s:", recentFile);
  BEGIN LINE;
}

<FILENAME>{null} {
  printf("%s:", recentFile);
  BEGIN LINE;
}

<LINE>{byte}{4} {
  printf("%u:\n", * (const unsigned *) (yytext + 1));
  BEGIN EXPR;
}

<EXPR,EXPR0>{string} {
  printf("\t%s == ", yytext);
  BEGIN VALUE;
}

<EXPR0>{null} {
  BEGIN FILENAME;
}

<VALUE>\1{byte} {
  assert(yytext[0] == Char);
  assert(yyleng - 1 == sizeof(char));
  printf("%hhu\n", * (const char *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\2{byte} {
  assert(yytext[0] == SignedChar);
  assert(yyleng - 1 == sizeof(signed char));
  printf("%hhd\n", * (const signed char *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\3{byte} {
  assert(yytext[0] == UnsignedChar);
  assert(yyleng - 1 == sizeof(unsigned char));
  printf("%hhu\n", * (const unsigned char *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\4{byte}{4} {
  assert(yytext[0] == Int);
  assert(yyleng - 1 == sizeof(int));
  printf("%d\n", * (const int *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\5{byte}{4} {
  assert(yytext[0] == UnsignedInt);
  assert(yyleng - 1 == sizeof(unsigned int));
  printf("%u\n", * (const unsigned int *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\6{byte}{2} {
  assert(yytext[0] == Short);
  assert(yyleng - 1 == sizeof(short));
  printf("%hd\n", * (const short *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\7{byte}{2} {
  assert(yytext[0] == UnsignedShort);
  assert(yyleng - 1 == sizeof(unsigned short));
  printf("%u\n", * (const unsigned short *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\10{byte}{4} {
  assert(yytext[0] == Long);
  assert(yyleng - 1 == sizeof(long));
  printf("%ld\n", * (const long *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\11{byte}{4} {
  assert(yytext[0] == UnsignedLong);
  assert(yyleng - 1 == sizeof(unsigned long));
  printf("%lu\n", * (const unsigned long *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\12{byte}{8} {
  assert(yytext[0] == LongLong);
  assert(yyleng - 1 == sizeof(long long));
  printf("%Ld\n", * (const long long *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\13{byte}{8} {
  assert(yytext[0] == UnsignedLongLong);
  assert(yyleng - 1 == sizeof(unsigned long long));
  printf("%Lu\n", * (const unsigned long long *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\14{byte}{4} {
  assert(yytext[0] == Float);
  assert(yyleng - 1 == sizeof(float));
  printf("%g\n", * (const float *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\15{byte}{8} {
  assert(yytext[0] == Double);
  assert(yyleng - 1 == sizeof(double));
  printf("%g\n", * (const double *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\16{byte}{12} {
  assert(yytext[0] == LongDouble);
  assert(yyleng - 1 == sizeof(long double));
  printf("%Lg\n", * (const long double *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\17{byte}{4} {
  assert(yytext[0] == Pointer);
  assert(yyleng - 1 == sizeof(const void *));
  printf("%p\n", * (const void * const *) (yytext + 1));
  BEGIN EXPR0;
}

<INITIAL,FILENAME>\377 {
  BEGIN END;
}

<END><<EOF>> {
  puts("\n(terminated normally)");
  return 0;
}

<FILENAME,EXPR,EXPR0><<EOF>> {
  puts("\n(terminated abnormally)");
  return 1;
}

<LINE,VALUE><<EOF>> {
  puts("\n\n(terminated abnormally)");
  return 1;
}

<*>{byte} {
  puts("\n\n(garbled input)");
  return 2;
}
