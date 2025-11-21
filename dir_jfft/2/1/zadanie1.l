%{
#include <stdio.h>

int line_count = 0;
int word_count = 0;
int last_was_word = 0;

extern FILE *yyin;
%}

%option noyywrap
%option nounistd

%%

^[ \t]*\n        { last_was_word = 0; }

^[ \t]+          { last_was_word = 0; }

[ \t]+\n         {
                    printf("\n");
                    line_count++;
                    last_was_word = 0;
                 }

[^ \t\n]+        {
                    ECHO;
                    word_count++;
                    last_was_word = 1;
                 }

[ \t]+           {
                    printf(" ");
                    last_was_word = 0;
                 }

\n               {
                    printf("\n");
                    line_count++;
                    last_was_word = 0;
                 }

<<EOF>>          {
                    if (last_was_word) {
                        printf("\n");
                        line_count++;
                    }

                    printf("\n--- PODSUMOWANIE ---\n");
                    printf("Liczba linii: %d\n", line_count);
                    printf("Liczba słów: %d\n", word_count);
                    return 0;
                 }

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