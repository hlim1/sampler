%{
#include <assert.h>
#include <limits.h>
#include <string.h>
#include "decoder.h"
#include "primitive.h"

static char recentFile[PATH_MAX];
%}

%option main
%option nodefault

%x FILENAME
%x FILENAME0
%x LINE
%x EXPR
%x EXPR0
%x VALUE
%x END

null	\0
string	[ -~]+{null}
byte	.|\n

signature  \212sam\r\n\032\n

%%


<INITIAL>{signature} {
  BEGIN FILENAME;
}


<FILENAME,FILENAME0>{string} {
  strncpy(recentFile, yytext, sizeof(recentFile) - 1);
  siteFile(recentFile);
  BEGIN LINE;
}

<FILENAME0>{null} {
  siteFile(recentFile);
  BEGIN LINE;
}

<LINE>{byte}{4} {
  siteLine(* (const unsigned *) (yytext + 1));
  BEGIN EXPR;
}

<EXPR,EXPR0>{string} {
  sampleExpr(yytext);
  BEGIN VALUE;
}

<EXPR0>{null} {
  BEGIN FILENAME0;
}

<VALUE>\1{byte} {
  assert(yytext[0] == Char);
  assert(yyleng - 1 == sizeof(char));
  sampleChar(yytext[1]);
  BEGIN EXPR0;
}

<VALUE>\2{byte} {
  assert(yytext[0] == SignedChar);
  assert(yyleng - 1 == sizeof(signed char));
  sampleSignedChar(yytext[1]);
  BEGIN EXPR0;
}

<VALUE>\3{byte} {
  assert(yytext[0] == UnsignedChar);
  assert(yyleng - 1 == sizeof(unsigned char));
  sampleUnsignedChar(yytext[1]);
  BEGIN EXPR0;
}

<VALUE>\4{byte}{4} {
  assert(yytext[0] == Int);
  assert(yyleng - 1 == sizeof(int));
  sampleInt(* (const int *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\5{byte}{4} {
  assert(yytext[0] == UnsignedInt);
  assert(yyleng - 1 == sizeof(unsigned int));
  sampleUnsignedInt(* (const unsigned int *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\6{byte}{2} {
  assert(yytext[0] == Short);
  assert(yyleng - 1 == sizeof(short));
  sampleShort(* (const short *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\7{byte}{2} {
  assert(yytext[0] == UnsignedShort);
  assert(yyleng - 1 == sizeof(unsigned short));
  sampleUnsignedShort(* (const unsigned short *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\10{byte}{4} {
  assert(yytext[0] == Long);
  assert(yyleng - 1 == sizeof(long));
  sampleLong(* (const long *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\11{byte}{4} {
  assert(yytext[0] == UnsignedLong);
  assert(yyleng - 1 == sizeof(unsigned long));
  sampleUnsignedLong(* (const unsigned long *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\12{byte}{8} {
  assert(yytext[0] == LongLong);
  assert(yyleng - 1 == sizeof(long long));
  sampleLongLong(* (const long long *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\13{byte}{8} {
  assert(yytext[0] == UnsignedLongLong);
  assert(yyleng - 1 == sizeof(unsigned long long));
  sampleUnsignedLongLong(* (const unsigned long long *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\14{byte}{4} {
  assert(yytext[0] == Float);
  assert(yyleng - 1 == sizeof(float));
  sampleFloat(* (const float *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\15{byte}{8} {
  assert(yytext[0] == Double);
  assert(yyleng - 1 == sizeof(double));
  sampleDouble(* (const double *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\16{byte}{12} {
  assert(yytext[0] == LongDouble);
  assert(yyleng - 1 == sizeof(long double));
  sampleLongDouble(* (const long double *) (yytext + 1));
  BEGIN EXPR0;
}

<VALUE>\17{byte}{4} {
  assert(yytext[0] == Pointer);
  assert(yyleng - 1 == sizeof(const void *));
  samplePointer(* (const void * const *) (yytext + 1));
  BEGIN EXPR0;
}

<FILENAME,FILENAME0>\377 {
  BEGIN END;
}

<END><<EOF>> {
  puts("\n(terminated normally)");
  return 0;
}

<FILENAME,FILENAME0,EXPR,EXPR0><<EOF>> {
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
