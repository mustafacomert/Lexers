%{ 
	int op_count = 0;
	int cp_count = 0;
	int quote_count = 0;
	void handle_op();
	void handle_cp();
	void handle_quote();

%}

value 							"0"|"-"*[1-9][0-9]*
identifier 						[a-zA-Z][a-zA-Z0-9]*

%%
"and"							{printf ("KW_AND\n"); }
"or"							{printf ("KW_OR\n"); }
"not"							{printf ("KW_NOT\n"); }
"equal"							{printf ("KW_EQUAL\n"); }
"less"							{printf ("KW_LESS\n"); }
"nil"							{printf ("KW_NIL\n"); }
"list"							{printf ("KW_LIST\n"); }
"append"						{printf ("KW_APPEND\n"); }
"concat"						{printf ("KW_CONCAT\n"); }
"set"							{printf ("KW_SET\n"); }
"deffun"						{printf ("KW_DEFFUN\n"); }
"for"							{printf ("KW_FOR\n"); }
"if"							{printf ("KW_IF\n"); }
"exit"							{printf ("KW_EXIT\n"); }
"load"							{printf ("KW_LOAD\n"); }
"disp"							{printf ("KW_DISP\n"); }
"true"							{printf ("KW_TRUE\n"); }
"false"							{printf ("KW_FALSE\n"); }

"+"								{printf ("OP_PLUS\n"); }
"-"								{printf ("OP_MINUS\n"); }
"/"								{printf ("OP_DIV\n"); }
"*"								{printf ("OP_MULT\n"); }
"("								{handle_op(); }
")"								{handle_cp(); }
"\""							{handle_quote(); }
"**"							{printf ("OP_DBLMULT\n"); }
","								{printf ("OP_COMMA\n"); }


";;".*							{printf("Comment"); }

{value}							{printf ("VALUE\n"); }
[0]+{value}						{printf ("SYNTAX_ERROR, number with leading zeros, exiting\n"); exit(1);}

{identifier}					{printf ("IDENTIFIER\n"); }

{value}{identifier}				{printf ("SYNTAX_ERROR, identifier with leading digits, exiting\n"); exit(1);}
%%
void handle_op()
{ 
	++op_count;
	printf("OP_OP\n");
}

void handle_cp()
{
	++cp_count;
	if (op_count != cp_count)
    {
  		printf("SYNTAX ERROR UNMATCHED PARANTHESIS\n");
  		exit(1);	
    } 
	printf("OP_CP\n");
}

void handle_quote()
{
	++quote_count;
	if ((quote_count % 2) == 1)
	{
		printf("OP_OC\n");
	}
	else
		printf("OP_CC\n");
}
int main()
{
  printf("Input Waiting: ");
  yylex();
}
