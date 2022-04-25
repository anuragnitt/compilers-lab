%{
    #include<stdio.h>
%}

%s STATE1 STATE2 DEAD

%%
<INITIAL>a BEGIN STATE1;
<INITIAL>b BEGIN INITIAL;
<INITIAL>[^ab\n] BEGIN DEAD;
<INITIAL>\n BEGIN INITIAL; {fprintf(yyout, "Accepted\n");}

<STATE1>b BEGIN STATE2;
<STATE1>a BEGIN STATE1;
<STATE1>[^ab\n] BEGIN DEAD;
<STATE1>\n BEGIN INITIAL; {fprintf(yyout, "Accepted\n");}

<STATE2>b BEGIN DEAD;
<STATE2>a BEGIN STATE1;
<STATE2>[^ab\n] BEGIN DEAD;
<STATE2>\n BEGIN INITIAL; {fprintf(yyout, "Accepted\n");}

<DEAD>[^\n] BEGIN DEAD;
<DEAD>\n BEGIN INITIAL; {fprintf(yyout, "Not Accepted\n");}
%%

int yywrap() {return 1;}

int main(){
    extern FILE *yin, *yyout;
    yyin = fopen("input4.txt", "r");
    yyout = fopen("output4.txt", "w");
    yylex();
    return 0;
}
