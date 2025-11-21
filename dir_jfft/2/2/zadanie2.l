%{
#include <stdio.h>

extern FILE *yyin;
%}

%option noyywrap
%option nounistd

%x TRI_DQ
%x TRI_SQ

%%

^[ \t]*\"\"\"        { BEGIN(TRI_DQ); }
(:|=)[ \t]*\"\"\"    { BEGIN(TRI_DQ); }
\"\"\"               { BEGIN(TRI_DQ); }

<TRI_DQ>\"\"\"       { BEGIN(INITIAL); }
<TRI_DQ>\n          { putchar('\n'); }
<TRI_DQ>.           { }

^[ \t]*\'\'\'        { BEGIN(TRI_SQ); }
(:|=)[ \t]*\'\'\'    { BEGIN(TRI_SQ); }
\'\'\'               { BEGIN(TRI_SQ); }

<TRI_SQ>\'\'\'       { BEGIN(INITIAL); }
<TRI_SQ>\n          { putchar('\n'); }
<TRI_SQ>.           { }

#[^\n]*             { }

.|\n                { ECHO; }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror(argv[1]);
            return 1;
        }
    }

    yylex();

    if (argc > 1) {
        fclose(yyin);
    }

    return 0;
}