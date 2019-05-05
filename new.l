%{
	#include"f.tab.h"
%}

letter		[a-z]
digit		[0-9]
sep		"\t"|"\n"|"r"|" "
id		{letter}({letter}|{digit}|"-"|"_")*
bool_val	"#t"|"#f"
number		0|[+|-]?[1-9]{digit}*	
%%
"+"		{ return ADD;}
"-"		{ return SUB;}
"*"		{ return MUL;}
"mod"		{ return MOD;}
"/"		{ return DIV;}
"="		{ return EQUAL;}
"("		{ return PRA_L;}
")"		{ return PRA_R;}
"and"		{ return AND;}
"or"		{ return OR;}
"not"		{ return NOT;}
">"		{ return BIGGER;}
"<" 		{ return SMALLER;}
"print-num"	{ return PRINT_NUM;}
"print-bool"	{ return PRINT_BOOL;}
"define"	{ return DEFINE;}
"if"		{ return IF;}
"lambda"	{ return FUN;}
{number}	{yylval.value = atoi(yytext); return NUM;}
{bool_val}	{yylval.str = strdup(yytext); return BOOL_VAL;}
{id}		{yylval.str = strdup(yytext); return ID;}
{sep}		{return SEP;}


%%

