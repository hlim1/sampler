/*-*- c -*-*/

%{
#include <assert.h>
#include <limits.h>
#include <string.h>
#include "decoder.h"
#include "primitive.h"

#define sampleValue(typecode, type)				\
 do								\
   {								\
     assert(yytext[0] == typecode);				\
     assert(yyleng - 1 == sizeof(type));			\
     sample ## typecode (* (const type *) (yytext + 1));	\
     BEGIN EXPR0;						\
   }								\
 while(0)

%}

%option nomain
%option nodefault
%option nounput
%option noyywrap

%x COUNTDOWN
%x COUNTDOWN0
%x FILENAME
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
  BEGIN COUNTDOWN;
}

<COUNTDOWN,COUNTDOWN0>{byte}{4} {
  assert(yyleng == sizeof(unsigned));
  siteCountdown(* (const unsigned *) yytext);
  BEGIN FILENAME;
}

<FILENAME>{string} {
  siteFile(yytext);
  BEGIN LINE;
}

<LINE>{byte}{4} {
  assert(yyleng == sizeof(unsigned));
  siteLine(* (const unsigned *) yytext);
  BEGIN EXPR;
}

<EXPR,EXPR0>{string} {
  sampleExpr(yytext);
  BEGIN VALUE;
}

<EXPR0>{null} {
  siteEnd();
  BEGIN COUNTDOWN0;
}

<VALUE>\1{byte}{1} {
  sampleValue(Int8, int8_t);
}

<VALUE>\2{byte}{1} {
  sampleValue(UInt8, uint8_t);
}

<VALUE>\3{byte}{2} {
  sampleValue(Int16, int16_t);
}

<VALUE>\4{byte}{2} {
  sampleValue(UInt16, uint16_t);
}

<VALUE>\5{byte}{4} {
  sampleValue(Int32, int32_t);
}

<VALUE>\6{byte}{4} {
  sampleValue(UInt32, uint32_t);
}

<VALUE>\7{byte}{8} {
  sampleValue(Int64, int64_t);
}

<VALUE>\10{byte}{8} {
  sampleValue(UInt64, uint64_t);
}

<VALUE>\11{byte}{4} {
  sampleValue(Float32, float);
}

<VALUE>\12{byte}{8} {
  sampleValue(Float64, double);
}

<VALUE>\13{byte}{12} {
  sampleValue(Float96, long double);
}

<VALUE>\14{byte}{4} {
  sampleValue(Pointer32, void *);
}

<FILENAME>\377{signature} {
  BEGIN END;
}

<END><<EOF>> {
  return Normal;
}

<<EOF>> {
  return Abnormal;
}

<*>{byte} {
  return Garbled;
}
