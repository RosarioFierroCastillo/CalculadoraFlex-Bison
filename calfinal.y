%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>
  #include <string.h>
  void yyerror(char *);
  int yylex(void);
  int vet[3];
  extern FILE* yyin;
%}

%token NUMBER VARIAVEL
%token ABREP FECHAP MAIS MENOS VEZES DIV IGUAL ENTER EXP RAIZ UMENOS ABS SHIFTLEFT SHIFTRIGHT MOD ABSS
%left MAIS MENOS IGUAL 
%left DIV VEZES 
  
%%
  
program:
  program statement ENTER
  | /* NULL */
  ;
statement:
 expression  { printf("%d", $1); }
 | VARIAVEL IGUAL expression { vet[$1] = $3; printf("%d", $3); }
 ;
expression:
 NUMBER
 | VARIAVEL { $$ = vet[$1]; }
 | MENOS expression { $$ = -$2; }
 | expression MAIS expression { $$ = $1 + $3; }
 | expression MENOS expression { $$ = $1 - $3; }
 | expression VEZES expression { $$ = $1 * $3; }
 | expression DIV expression { $$ = $1 / $3; }
 | ABREP expression FECHAP { $$ = $2; }
 | expression EXP expression { $$ = pow($1, $3); }
 | RAIZ expression %prec UMENOS {$$ = sqrt($2);}
 | ABS expression %prec UMENOS { $$ = fabs($2);}
 | expression SHIFTLEFT expression { $$ = $1 << $3;}
 | expression SHIFTRIGHT expression {$$ = $1>>$3;}
 | expression MOD expression {$$ = $1 % $3;}
 | ABSS expression ABSS {$$ =$2;}
 ;

%%

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

void leerArchivo(FILE *file) {
    char caracter;
    // Mientras haya caracteres en el archivo, imprímelos
    while ((caracter = fgetc(file)) != EOF) {
        printf("%c", caracter);
    }
    // Restablecer el puntero de archivo al inicio
    rewind(file);
}

//funcion principal
int main(int argc, char *argv[]) { 
  char caracter;
  if (argc != 2) {
    fprintf(stderr, "Uso: %s archivo_entrada\n", argv[0]);
    return 1;
  }

  FILE *file = fopen(argv[1], "r");
  if (!file) {
     perror("Error al abrir el archivo");
     return 1;
  }

  leerArchivo(file);

  yyin = file;
  
  yyparse();
  
  fclose(file);
  
  return 0;
}

