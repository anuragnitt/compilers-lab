#!/bin/bash

build() {
    lex lex.l
    yacc -d yacc.y
    gcc y.tab.c -ll -ly -o 3ac
    g++ optimize_3ac.cpp -o optimize
}

run() {
    ./3ac input.c > test2.txt
    ./optimize test2.txt > optimized2.txt
    ./optimize test1.txt > optimized1.txt
}

clean() {
    rm lex.yy.c y.tab.c y.tab.h
    rm optimized*.txt
    rm 3ac optimize
}

if [ $1 == "clean" ]; then
    clean 2>/dev/null
else
    build
    run
fi
