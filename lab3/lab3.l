%{
/* Definition section */
#include<stdio.h>
#include "y.tab.h"
extern int yylval;
%}

/* Rule Section */
%%
[0-9]+ {
		yylval=atoi(yytext);
		return NUMBER;

	}
[\t] ;

">=" {
		return GE;
	}
"<=" {
		return LE;
	}
"==" {
		return EQ;
	}

"!=" {
		return NE;
	}

"&&" {
		return AND;
	}

"||" {
		return OR;
	}

"!" {
		return NOT;
	}

[\n] return 0;

. return yytext[0];

%%

int yywrap()
{
return 1;
}
