%{
    #include <stdio.h>
%}

%%
"float" {fprintf(yyout, "double");}
.       {fprintf(yyout, "%s", yytext); }
%%

int yywrap(void) {
    return 1;
}

int main(){
    extern FILE *yin, *yyout;
    yyin = fopen("before5.c", "r");
    yyout = fopen("after5.c", "w");
    yylex();
    return 0;
}
