%{
/* Definition section */
#include<stdio.h>
int flag=0;
%}

%token NUMBER

%token GE

%token LE

%token EQ

%token NE

%token AND

%token OR

%token NOT

%left GE LE EQ NE '>' '<'

%left '+' '-'

%left '*' '/' '%'

%left '(' ')'

/* Rule Section */
%%

Expression: E{

		printf("\nResult=%d\n", $$);

		return 0;

		};
E:E'+'E {$$=$1+$3;}

|E'-'E {$$=$1-$3;}

|E'*'E {$$=$1*$3;}

|E'/'E {$$=$1/$3;}

|E'%'E {$$=$1%$3;}

|'('E')' {$$=$2;}

|E GE E {$$=$1>=$3;}

|E'>'E {$$=$1>$3;}

|E'<'E {$$=$1<$3;} 

|E LE E {$$=$1<=$3;}

|E EQ E {$$=$1==$3;}

|E NE E {$$=$1!=$3;}

|E AND E {$$=$1&&$3;}

|E OR E {$$=$1||$3;}

|NOT E {$$=!$2;}
 

|NUMBER {$$=$1;}

;

%%

//driver code
void main()
{
printf("\nEnter Any Arithmetic/Relational/Boolean Expression\n");

yyparse();
if(flag==0)
printf("\nEntered expression is Valid\n\n");
}

void yyerror()
{
printf("\nEntered expression is Invalid\n\n");
flag=1;
}
