%option noyywrap

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
%}

DIGIT    [0-9]
CHAR     [a-zA-Z]
NUM      {DIGIT}+
STRING   {CHAR}+


%%
    "<"      {yylval.str = strdup(yytext); return OPENTAG;}
    ">"      {yylval.str = strdup(yytext); return CLOSETAG;}
    "/>"     {yylval.str = strdup(yytext); return SELFCLOSETAG;}
    "-->"    {yylval.str = strdup(yytext); return COMMENT_END;}
    "<!--"   {yylval.str = strdup(yytext); return COMMENT_START;}
    "="      {yylval.str = strdup(yytext); return ASSIGN;}
    [a-zA-Z][_a-zA-Z0-9]*  {yylval.str = strdup(yytext); yylval.str = strdup(yytext); return ALPHANUMERIC;}
    {DIGIT}  {yylval.str = strdup(yytext); return DIGIT;}
    {NUM}    {yylval.str = strdup(yytext); return NUM;}
    {CHAR}   {yylval.str = strdup(yytext); return CHAR;}
    {STRING} {yylval.str = strdup(yytext); return STRING;}
%%