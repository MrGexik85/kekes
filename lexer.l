%{
	#include "parser.tab.h"
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>

%}

%option yylineno
%option noyywrap

%%
"var"                 {   
        printf("\'var\' keyword\n");
        return kVAR;   
    }
";"                   {
	    printf("\';\' token\n");
	    return SEMICOLUMN; 
    }
":="                  {
        printf("\':=\' token\n");
	    return ASSIGN; 
    }
"-"				      {	
	    printf("\'-\' token\n");
	    return MINUS;	
    }
"+"				      {	
        printf("\'+\' token\n");
        return PLUS;	
    }
    "*"			  	    {	
        printf("\'*\' token\n");
        return MULT;	
    }
    "/"			  	    {	
        printf("\'/\' token\n");
        return DIVIDE;	
    }
    "<"			        {	
        printf("\'<\' token\n");
        return LT;	
    }
    ">"			  	    {	
        printf("\'>\' token\n");
        return GT;	
    }
    "<="                {   
        printf("\'<=\' token\n");
        return LE;   
    }
    ">="                {   
        printf("\'>=\' token\n");
        return GE;  
    }
    "="                 {   
        printf("\'=\' token\n");
        return EQ;     
    }
    "<>"			    {	
        printf("\'<>\' token\n");
        return NE;	
    } 		
    "("			 	    {
        printf("\'(\' token\n");	
        return LPAREN;	
    } 
    ")"			    	{
        printf("\')\' token\n"); 	
        return RPAREN;	
    }
    ","                 {   
        printf("\',\' token\n");
        return COLUMN;      
    }
    ":"	           	 	{   
        printf("\':\' token\n");
        return COLON; 
    }
    "."                 {   
        printf("\'.\' token\n");
        return POINT;   
    }
    \"[^']*\" {
        printf("\'string\' token\n");
        strcpy(yylval.var, yytext);
        return STRINGLITERAL;   
    }
    "do"                 {
        printf("\'do\' keyword\n");
        return kDO;   
    }
    "var"                 {   
        printf("\'var\' keyword\n");
        return kVAR;   
    }
    "real"                 {   
        printf("\'real\' keyword\n");
        return kREAL;   
    }
    "integer"                 {   
        printf("\'integer\' keyword\n");
        return kINTEGER;   
    }
    "boolean"                 {   
        printf("\'boolean\' keyword\n");
        return kBOOLEAN;   
    }
    "begin"                 {   
        printf("\'begin\' keyword\n");
        return kBEGIN;   
    }
    "end"                 {   
        printf("\'end\' keyword\n");
        return kEND;   
    }
    "if"                 {   
        printf("\'if\' keyword\n");
        return kIF;   
    }
    "then"                 {   
        printf("\'then\' keyword\n");
        return kTHEN;   
    }
    "else"                 {   
        printf("\'else\' keyword\n");
        return kELSE;   
    }
    "while"                 {   
        printf("\'while\' keyword\n");
        return kWHILE;   
    }
    "write"                 {   
        printf("\'write\' keyword\n");
        return kWRITE;   
    }
    "div"                 {   
        printf("\'div\' keyword\n");
        return kDIV;   
    }
    "mod"                 {   
        printf("\'mod\' keyword\n");
        return kMOD;   
    }
    "and"                 {   
        printf("\'and\' keyword\n");
        return kAND;   
    }
    "or"                 {   
        printf("\'or\' keyword\n");
        return kOR;   
    }
    "not"                 {   
        printf("\'not\' keyword\n");
        return kNOT;   
    }
    [0-9]+				    {
        printf("\'intnum\' token\n");	
        yylval.no = atoi(yytext) ; 
        return INTNUM;
    }
    [0-9]*\.[0-9]+ 		{
        printf("\'realnum\' token\n");
        yylval.fno = atof(yytext);
        return REALNUM;
    }
    [a-z]([a-z]|[0-9])*		    {
        printf("\'id\' token\n");	
        strcpy(yylval.var, yytext); 
        return ID;
    } 

    [ \t\n]					;

    .	{   printf("invalid char.");  }

%%