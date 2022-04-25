%{
	#include <stdio.h>
	#include<math.h>
	#include<ctype.h>
	#include <stdlib.h>
	#include<string.h>
	extern char *yytext;
		
%}

%token ID NUM IF ELSE
%right '='
%left '+' '-'
%left '*' '/'
%left '>' '<' LE GE EQ NE OR AND
%left UMINUS
%%

S : IF '(' E ')'{lab1();} E ';'{lab4();}
  ;
E :V '='{push();} E{codegen_assign();}
  | E '+'{push();} E{codegen();}
  | E '-'{push();} E{codegen();}
  | E '*'{push();} E{codegen();}
  | E '/'{push();} E{codegen();}
  | E '>'{push();} E{codegen();}
  | E '<'{push();} E{codegen();}
  | E '!'{push();} E{codegen();}
  | E EQ {push();} E{codegen();}
  | E GE {push();} E{codegen();}
  | E LE {push();} E{codegen();}
  | E NE {push();} E{codegen();}
  | E OR {push();} E{codegen();}
  | E AND {push();} E{codegen();}
  | '(' E ')'
  | '-'{push();} E{codegen_umin();} %prec UMINUS
  | V
  | NUM{push();}
  ;
V : ID {push();}
  ;
%%


char st[100][10];
int top=0;
char i_[2]="0";
char temp[2]="t";

int label[20];
int lnum=0;
int ltop=0;

main()
 {
 printf("Enter the expression : ");
 yyparse();
 }

push()
 {
  strcpy(st[++top],yytext);
 }

codegen()
 {
 strcpy(temp,"t");
 strcat(temp,i_);
  printf("%s = %s %s %s\n",temp,st[top-2],st[top-1],st[top]);
  top-=2;
 strcpy(st[top],temp);
 i_[0]++;
 }

codegen_umin()
 {
 strcpy(temp,"t");
 strcat(temp,i_);
 printf("%s = -%s\n",temp,st[top]);
 top--;
 strcpy(st[top],temp);
 i_[0]++;
 }

codegen_assign()
 {
 printf("%s = %s\n",st[top-2],st[top]);
 top-=2;
 }

lab1()
{
 lnum++;
 strcpy(temp,"t");
 strcat(temp,i_);
 printf("%s = not %s\n",temp,st[top]);
 printf("if %s goto L%d\n",temp,lnum);
 i_[0]++;
 label[++ltop]=lnum;
}

lab2()
{
int x;
lnum++;
x=label[ltop--];
printf("goto L%d\n",lnum);
printf("L%d: \n",x);
label[++ltop]=lnum;
}

lab4()
{
int x;
lnum++;
x=label[ltop--];
printf("L%d: \n",x);
label[++ltop]=lnum;
}


lab3()
{
int y;
y=label[ltop--];
printf("L%d: \n",y);
}

int yyerror (char *s) {fprintf (stderr, "%s\n", s);}
