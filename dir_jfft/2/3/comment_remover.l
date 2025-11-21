%{
#include <stdio.h>
#include <string.h>

int keep_doxygen = 0;
%}

%option noyywrap
%x ML_COMMENT
%x ML_COMMENT_DOC

%%

"/**"       { if(keep_doxygen) { fputs(yytext, stdout); BEGIN(ML_COMMENT_DOC); } else { BEGIN(ML_COMMENT); } }
"/*!"       { if(keep_doxygen) { fputs(yytext, stdout); BEGIN(ML_COMMENT_DOC); } else { BEGIN(ML_COMMENT); } }
"/*"        { BEGIN(ML_COMMENT); }

<ML_COMMENT_DOC>"*/"      { fputs(yytext, stdout); BEGIN(INITIAL); }
<ML_COMMENT_DOC>[^\*\n]+    { fputs(yytext, stdout); }
<ML_COMMENT_DOC>"*"+[^/\n]* { fputs(yytext, stdout); }
<ML_COMMENT_DOC>\n        { fputs(yytext, stdout); }

<ML_COMMENT>"*/"      { BEGIN(INITIAL); }
<ML_COMMENT>[^\*\n]+    { /* ignore */ }
<ML_COMMENT>"*"+[^/\n]* { /* ignore */ }
<ML_COMMENT>\n        { putchar('\n'); }

"///"       { if(keep_doxygen) {fputs(yytext, stdout);}
}
"//!"       { if(keep_doxygen) {fputs(yytext, stdout);}
}
"//"        { /* ignore */ }


\n          { fputs(yytext, stdout); }
.           { fputs(yytext, stdout); }

%%

int main(int argc, char* argv[]) {
    if (argc > 1 && strcmp(argv[1], "--doxygen") == 0) {
        keep_doxygen = 1;
    }

    // Read from file if provided, otherwise from stdin
    if (argc > 2) {
        yyin = fopen(argv[2], "r");
        if (!yyin) {
            perror(argv[2]);
            return 1;
        }
    }

    yylex();

    if (argc > 2) {
        fclose(yyin);
    }

    return 0;
}
