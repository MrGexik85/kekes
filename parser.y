%{
    #include <stdio.h>
    #include <string.h>
	#include <stdio.h>
	#include <stdlib.h>
    
    FILE *yyout;

    void yyerror(const char *str)
    {
        fprintf(stderr,"error: %s\n",str);
    }
    
    int yywrap()
    {
        return 1;
    }
    
    main()
    {
        yyout = fopen("output.c", "w");
        yyparse();
    }
%}

%union{
	int no;
	float fno;
	char var[2048];
}


%token kBEGIN kEND // Токены аналог '{' и '}'
%token kIF kTHEN kELSE // Токены для организации ветвления
%token ASSIGN // Токен для операции присваивания
%token SEMICOLUMN // Токен ';'
%token LPAREN RPAREN // Токены для '(' и ')'
%token COLUMN COLON POINT // Токены ',' ':' '.'
%token kWHILE kDO // Токены для организации циклов
%token kWRITE // Токены для вывода 
%token PLUS MINUS MULT DIVIDE kDIV kMOD // Токены для арифметических операций
%token kAND kOR kNOT LT GT EQ NE LE GE // Токены для логических операций
%token<no> INTNUM // Токены для числовых, строковых значений
%token<fno> REALNUM
%token<var> STRINGLITERAL 
%token<var> ID // Токен для идентификаторов
%token kVAR kREAL kINTEGER kBOOLEAN // Токены для типов данных, кроме kVAR, который указывает на объявление переменной

// Приоритеты операций
%left ASSIGN
%left kOR
%left kAND
%left LT GT LE GE EQ NE
%left MINUS PLUS
%left MULT DIVIDE kDIV kMOD
%left kNOT

%type<var> expr arg args ops op op1 op2 lsts lst lsttype ids


%%

start: lsts kBEGIN ops kEND POINT            { 
    fprintf(yyout, "#include \"stdio.h\"\n#include \"stdlib.h\"\n#include \"string.h\"\n\nint main(int argc, char** argv) { \n%s\n%s \n}", $1,$3); 
    printf("Successful interpretation");
    exit(0);}
;

lsts: lst                               {sprintf($$, "%s", $1);}
    | lsts lst                          {sprintf($$, "%s\n%s", $1, $2);}
;

lst: kVAR ids COLON lsttype SEMICOLUMN  {sprintf($$, "%s %s;", $4, $2);}
;

ids: ID                                 {sprintf($$, "%s", $1);}
   | ids COLUMN ID                      {sprintf($$, "%s, %s", $1, $3);}
;

lsttype: kINTEGER                       {sprintf($$, "%s", "int");};
    | kREAL                             {sprintf($$, "%s", "float");};
    | kBOOLEAN                          {sprintf($$, "%s", "char");};
;

ops: op                                 {sprintf($$, "%s", $1);}
    | ops op                            {sprintf($$, "%s%s", $1, $2);}
;

op: op1                                 {sprintf($$, "%s", $1);}
    | op2                               {sprintf($$, "%s", $1);}
;

op1: kBEGIN ops kEND SEMICOLUMN         {sprintf($$, "{ \n%s}\n", $2);}
    | expr SEMICOLUMN                   {sprintf($$, "%s;\n", $1);}
    | kIF LPAREN expr RPAREN kTHEN op1 kELSE op1 {sprintf($$, "if (%s) \n%s else \n%s", $3, $6, $8);}
    | kWHILE LPAREN expr RPAREN kDO op1 {sprintf($$, "while(%s) \n%s", $3, $6);}
;

op2: kIF LPAREN expr RPAREN kTHEN op          {sprintf($$, "if (%s) \n%s", $3, $6);}
    | kIF LPAREN expr RPAREN kTHEN op1 kELSE op2 {sprintf($$, "if (%s) \n%s else \n%s", $3, $6, $8);}
    | kWHILE LPAREN expr RPAREN kDO op2     {sprintf($$, "while(%s) \n%s", $3, $6);}
;


expr: INTNUM                            {sprintf($$, "%d", $1);} 
    | REALNUM                           {sprintf($$, "%f", $1);}
    | ID                                {sprintf($$, "%s", $1);}
    | ID LPAREN args RPAREN             {sprintf($$, "%s(%s)", $1, $3);}
    | LPAREN expr RPAREN                {sprintf($$, "(%s)", $2);}
    | expr EQ expr                      {sprintf($$, "%s == %s", $1, $3);}
    | expr NE expr                      {sprintf($$, "%s != %s", $1, $3);}
    | expr GE expr                      {sprintf($$, "%s >= %s", $1, $3);}
    | expr LE expr                      {sprintf($$, "%s <= %s", $1, $3);}
    | expr GT expr                      {sprintf($$, "%s > %s", $1, $3);}
    | expr LT expr                      {sprintf($$, "%s < %s", $1, $3);}
    | expr kAND expr                    {sprintf($$, "%s && %s", $1, $3);}
    | expr kOR expr                     {sprintf($$, "%s || %s", $1, $3);}
    | kNOT expr                         {sprintf($$, "!%s", $2);}
    | expr MINUS expr                   {sprintf($$, "%s - %s", $1, $3);}
    | expr PLUS expr                    {sprintf($$, "%s + %s", $1, $3);}
    | expr DIVIDE expr                  {sprintf($$, "%s / %s", $1, $3);}
    | expr MULT expr                    {sprintf($$, "%s * %s", $1, $3);}
    | expr kDIV expr                    {sprintf($$, "%s / %s", $1, $3);}
    | expr kMOD expr                    {sprintf($$, "%s %% %s", $1, $3);}
    | ID ASSIGN expr                    {sprintf($$, "%s = %s", $1, $3);}
;

args: arg                               {sprintf($$, "%s", $1);}
    | args COLUMN arg                   {sprintf($$, "%s,%s", $1, $3);}
    |                                   {sprintf($$, "%s", "");}
;

arg: expr                               {sprintf($$, "%s", $1);}
    | STRINGLITERAL                     {sprintf($$, "%s", $1);}
;
%%