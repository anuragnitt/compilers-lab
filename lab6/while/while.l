%{
#include "y.tab.h"
%}
ALPHA [A-Za-z]
DIGIT [0-9]
%%
if                           return(IF);
else                        return(ELSE);
{ALPHA}({ALPHA}|{DIGIT})*    return (ID);
"<="    return LE;
">="    return GE;
"=="    return EQ;
"!="    return NE;
"||"    return OR;
"&&"    return AND;
{DIGIT}+                     {yylval=atoi(yytext); return NUM;}
[ \t]                 ;
\n                yyterminate();
.                 return yytext[0];
%%

int yywrap(void){return 1;}
