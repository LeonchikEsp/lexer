%{
	#include <stdio.h>
	int numOflines = 1;
	int currPos = 1;

	char * LOperator = "op";
	char * LVariable = "var";
	char * LInteger = "int";
	char * LComment = "comment";

	//yytext - curr lexeme
	//yyleng - len of lexeme

	printLexemeInfo(char * type)
	{
		printf("%s(%s, %i, %i, %i); ", type, yytext, numOflines, currPos, currPos -1 + yyleng);
 		currPos += yyleng;
	}
%}

digit	[0-9]
letter	[a-zA-Z]

%%
[1-9][0-9]*				{printLexemeInfo(LInteger);}
[0]+					{printLexemeInfo(LInteger);}
read 					{printLexemeInfo(LOperator);}
skip 					{printLexemeInfo(LOperator);}
write		 			{printLexemeInfo(LOperator);}
while 					{printLexemeInfo(LOperator);}
do 						{printLexemeInfo(LOperator);}
if 						{printLexemeInfo(LOperator);}
then 					{printLexemeInfo(LOperator);}
else 					{printLexemeInfo(LOperator);}

\/\/.*					{printLexemeInfo(LComment);}
\(\*.*\*\)				{printLexemeInfo("multiline_comment");}

[:][=]					{printLexemeInfo("assignment_operator");}
([+|\-|*|/|%|>|<])|([=|\!][=])|([>|<][=])|([&][&])|([\|][\|])	{printLexemeInfo(LOperator);}


\(						{printLexemeInfo("open_br");}
\)						{printLexemeInfo("close_br");}
\;						{printLexemeInfo("colon");}

[ |\f|\r|\t|\v]			{currPos+=yyleng;}

[a-zA-Z_][0-9a-zA-Z_]*	{printLexemeInfo(LVariable);}

\n 						{numOflines++; currPos = 1;}

.						{printf("\n%s %i %s %i %s\n", "ERROR! Something went wrong on", numOflines, "line", currPos, "character"); exit(1);}

%%

main(int argc, char *argv[])
{
	if (argc != 2)
	{
		printf("Usage: <./a.out> <source file> \n");
		exit(0);
	}

	yyin=fopen(argv[1], "r");

	printf("(%s, %s, %s, %s)\n", "lexeme name", "line", "start position" , "end position");

	yylex();

	printf("#\nNumber of lines = %d\n", numOflines);

	return 0;
}
