%{ // -*- c++ -*-
const char *scheme;
const char *tag;
%}

%option noyywrap
%option nounput
%option nodefault
%option align
%option fast
%option read

%x COUNTS


%%


<INITIAL>[0-9a-f]{32}\n {
  BEGIN(COUNTS);
  yytext[yyleng - 1] = '\0';
  printf("<%s unit=\"%s\" scheme=\"%s\">\n", tag, yytext, scheme);
}


<COUNTS>(.+\n)*\n {
  BEGIN(INITIAL);
  fwrite(yytext, 1, yyleng - 1, stdout);
  printf("</%s>\n", tag);
}


%%


#include <cstdio>


int main(int argc, char *argv[])
{
  if (argc != 3)
    {
      fprintf(stderr, "Usage: %s <scheme> <tag>\n", argv[0]);
      exit(2);
    }

  scheme = argv[1];
  tag = argv[2];
  yylex();

  return 0;
}
