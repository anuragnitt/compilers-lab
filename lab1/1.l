%{
    #include <stdio.h>
%}

%%
[ \t]+ {fprintf(yyout, " ");}
"//".*\n            { fprintf(yyout, ""); }
"/*"[^*/]*"*/"      { fprintf(yyout, ""); }
[\n]+ {fprintf(yyout, "");}
. {fprintf(yyout, "%s", yytext);}
%%

int yywrap(void) {
    return 1;
}

int main(){
    extern FILE *yin, *yyout;
    yyin = fopen("before1.c", "r");
    yyout = fopen("after1.c", "w");
    yylex();
    return 0;
}
