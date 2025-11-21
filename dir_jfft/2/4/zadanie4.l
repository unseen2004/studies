%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STACK_MAX 256
int stack[STACK_MAX];
int sp = 0;

int error_flag = 0;
char error_msg[100];

void report_error(const char* msg) {
    if (!error_flag) {
        error_flag = 1;
        strncpy(error_msg, msg, 99);
        error_msg[99] = '\0';
    }
}

void push(int val) {
    if (error_flag) return;

    if (sp >= STACK_MAX) {
        report_error("Błąd: Przepełnienie stosu");
    } else {
        stack[sp++] = val;
    }
}

int pop() {
    if (error_flag) return 0;

    if (sp <= 0) {
        report_error("Błąd: za mała liczba argumentów");
        return 0;
    }
    return stack[--sp];
}

int power(int base, int exp) {
    if (exp < 0) {
        report_error("Błąd: Ujemny wykładnik potęgi");
        return 0;
    }
    long long result = 1;
    for (int i = 0; i < exp; ++i) {
        result *= base;
        if (result > 2147483647 || result < -2147483648) {
             report_error("Błąd: Przepełnienie przy potęgowaniu");
             return 0;
        }
    }
    return (int)result;
}
%}

%option noyywrap
%option yylineno

%%

[ \t]+              { }

-?[0-9]+          { push(atoi(yytext)); }

"+"               { int op2 = pop(); int op1 = pop(); if (!error_flag) push(op1 + op2); }
"-"               { int op2 = pop(); int op1 = pop(); if (!error_flag) push(op1 - op2); }
"*"               { int op2 = pop(); int op1 = pop(); if (!error_flag) push(op1 * op2); }
"/"               {
                    int op2 = pop(); int op1 = pop();
                    if (op2 == 0) {
                        report_error("Błąd: Dzielenie przez zero");
                    } else if (!error_flag) {
                        push(op1 / op2);
                    }
                  }
"%"               {
                    int op2 = pop(); int op1 = pop();
                    if (op2 == 0) {
                        report_error("Błąd: Dzielenie przez zero (modulo)");
                    } else if (!error_flag) {
                        push(op1 % op2);
                    }
                  }
"^"               {
                    int op2 = pop();
                    int op1 = pop();
                    if (!error_flag) {
                        push(power(op1, op2));
                    }
                  }

\n                {
                    if (error_flag) {
                        printf("%s\n", error_msg);
                    } else if (sp == 1) {
                        printf("= %d\n", stack[0]);
                    } else if (sp > 1) {
                        printf("Błąd: za mała liczba operatorów\n");
                    } else {
                        printf("\n");
                    }

                    sp = 0;
                    error_flag = 0;
                  }

.                 {
                    char msg[100];
                    snprintf(msg, 100, "Błąd: zły symbol \"%s\"", yytext);
                    report_error(msg);
                  }

%%

int main(int argc, char *argv[]) {
    printf("Prosty kalkulator RPN (FLEX). Wpisz wyrażenie lub Ctrl+D aby zakończyć.\n");
    yylex();
    return 0;
}