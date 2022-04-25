%{
    #include <stdio.h>
    int length=0;
%}

%%
[/][/].*[\n] {fprintf(yyout, "");}
[/][][^(/)][][/] {fprintf(yyout, "");}
["].*["] {
	length= yyleng;
	fprintf(yyout,"String constant: %s, size: %d bytes\n",yytext, length-2);
}
[ =]\-?[0-9]+[ \n;] { fprintf(yyout,"Integer: %s Size: 2 bytes\n", yytext);}
[ =]\-?[0-9]+[\.][0-9]([e][0-9])?[ \n;] { fprintf(yyout,"double: %s Size: 8 bytes\n", yytext);}
[ \n\t][i][f][ \n(] {fprintf(yyout,"if: keyword\n");}
[ \n\t][e][l][s][e][ \n{] {fprintf(yyout,"else: keyword\n");}
[ \n\t][w][h][i][l][e][ \n{] {fprintf(yyout,"while: keyword\n");}
[ \n\t][d][o][ \n{] {fprintf(yyout,"do: keyword\n");}
[ \n\t][b][r][e][a][k][;] {fprintf(yyout,"break: keyword\n");}
[ \n\t][c][o][n][t][i][n][u][e][;] {fprintf(yyout,"continue: keyword\n");}
[ \n\t][r][e][t][u][r][n][ ] {fprintf(yyout,"return: keyword\n");}
[ \n\t][s][w][i][t][c][h][ (] {fprintf(yyout,"switch: keyword\n");}
[ \n\t][c][a][s][e][ ] {fprintf(yyout,"case: keyword\n");}
[ \n\t][i][n][t][ ][a-zA-Z_][a-zA-Z0-9_]*[ =;] {
	length=yyleng;
	if(length>38){
		fprintf(yyout,"Invalid indetentifier %s: Too long\n");
	}
	else{
		fprintf(yyout,"%s Size: 2 bytes\n",yytext);
	}
}
[ \n\t][c][h][a][r][ ][a-zA-Z_][a-zA-Z0-9_]*[ =;] {
	length=yyleng;
	if(length>39){
		fprintf(yyout,"Invalid indetentifier %s: Too long\n",yytext);
	}
	else{
		fprintf(yyout,"%s Size: 1 bytes\n",yytext);
	}
}
[ \n\t][d][o][u][b][l][e][ ][a-zA-Z_][a-zA-Z0-9_]*[ =;] {
	length=yyleng;
	if(length>41){
		fprintf(yyout,"Invalid indetentifier %s: Too long\n",yytext);
	}
	else{
		fprintf(yyout,"%s Size: 8 bytes\n",yytext);
	}
}
[ \n\t][f][l][o][a][t][ ][a-zA-Z_][a-zA-Z0-9_]*[ =;] {
	length=yyleng;
	if(length>39){
		fprintf(yyout,"Invalid indetentifier %s: Too long\n",yytext);
	}
	else{
		fprintf(yyout,"%s Size: 4 bytes\n",yytext);
	}
}
. { fprintf(yyout, ""); }
%%



int yywrap ()
{
	return 1;
}

int main()
{
    extern FILE *yin, *yyout;
    yyin = fopen("input2.c", "r");
    yyout = fopen("output2.txt", "w");
    yylex();
    return 0;
}
