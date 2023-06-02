%{
    #inlcude <stdio.h>
%}

%token OPENTAG
%token CLOSETAG
%token SELFCLOSETAG
%token DIGIT
%token NUM
%token CHAR
%token STRING

%%
    start: OPENTAG STRING CLOSETAG
%%