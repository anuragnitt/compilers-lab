#!/bin/bash
lex lexprog.l
yacc -d yaccprog.y
g++ lex.yy.c y.tab.c -ll -w -o lab7
./lab7 < test1.txt > out1.txt
./lab7 < test2.txt > out2.txt
