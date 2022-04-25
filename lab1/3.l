%{
    #include<stdio.h>
%}
%%
"+"|"-"|"*"|"/"|"%" { fprintf(yyout, "%s is arithmetic operator\n",yytext);}
"++"    { fprintf(yyout, "%s is increment operator\n",yytext);}
"--"    { fprintf(yyout, "%s is decrement operator\n",yytext);}
"="|"+="|"-="|"*="|"/="|"%="|"<<="|">>="|"&="|"^="|"|=" { fprintf(yyout, "%s is assignment operator\n",yytext);}
"=="|"<"|">"|"<="|">="|"!="  { fprintf(yyout, "%s is relational operator\n",yytext);}
"&&"|"!"|"||"           { fprintf(yyout, "%s is logical operator\n",yytext);}
"^"|"~"|"&"|"<<"|">>"|"|"   { fprintf(yyout, "%s is bitwise operator\n",yytext);}
. ;
%%

int yywrap(void) {
    return 1;
}

int main(){
    extern FILE *yin;
    yyin = fopen("input3.c", "r");
    yyout = fopen("output3.txt", "w");
    yylex();
    return 0;
}
