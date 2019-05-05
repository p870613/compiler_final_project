%{
	#include<stdio.h>
	#include<string.h>
	#include<stdbool.h>
	#include<stdlib.h>
	void yyerror(char *mes);	
	

	typedef struct ast_node
	{
		int type;
		struct ast_node *left;
		struct ast_node *right;
		int int_value;
		bool bool_value;
		
	}ast_node;

	/*function parameter*/
	typedef struct para_node
	{
		int type;
		ast_node* value;
		char *name;
		int value_type;
	}para_node;
	
	/*define*/
	typedef struct define_id
	{
		int type;
		int value_type;
		char *name;
		ast_node *value;
		
	};


	/*if else*/
	typedef struct if_node
	{
		int type;
		ast_node *condition;
		ast_node *if_exp;
		ast_node *else_exp;
	};

	typedef struct fun_node
	{
		int type;
		ast_node *argu;
		ast_node *fun_body;
	};

	typedef struct num_node
	{
		int type;
		int value;
	};

	typedef struct bool_node
	{
		int type;
		bool value;
	};

	typedef struct variable
	{
		int type;
		char *name;
		int value;
	};

	struct fun_argu
	{
		ast_node *value;
		char *name;	
	};

	ast_node *travel(ast_node *node);
	ast_node *logic_recursive(int type, ast_node *cur);
	ast_node *find_define_id(ast_node *cur, char *name);
	struct define_id store[100];
	int top = 0;
	ast_node *head;

	/*argu*/
	ast_node *new_argu(ast_node *b, ast_node *c)
	{
		ast_node *a = malloc(sizeof(ast_node));
		a -> left= b;
		a -> right = c;
		a -> type = 'A';
		return (ast_node*) a; 
	}

	/*constant*/
	ast_node* new_num(int value)
	{
		struct num_node *a = malloc(sizeof(struct num_node));
		a->value = value;
		a->type = 'N';
		return (ast_node*)a;
	}
	

	ast_node* new_bool_val(bool value)
	{
		struct bool_node  *a = malloc(sizeof(struct bool_node));
		a->type = 'B';
		a->value = value;
		return (ast_node*) a;
	}

	
	ast_node* new_num_op(int type, ast_node *l, ast_node *r)
	{
		ast_node *a = malloc(sizeof(ast_node));
		a -> left = l;
		a -> right = r;
		a->type = type;
		
		return a;
	}
	
	ast_node *exp_recursive(int type, ast_node *cur, ast_node *next )
	{
		
		
		ast_node *a = malloc(sizeof(ast_node));
		a -> left = cur;
		a -> right = next;
		a->type = 'R';
		return a;
	}

	ast_node* new_logic(int type, ast_node *l,  ast_node *r)/*and = 1  or = 2  not = 3*/
	{
		ast_node *a = malloc(sizeof(ast_node));
		a -> left = l;
		a -> right = r;
		a -> type = type;
		return a;
	}
	
	
	ast_node * new_pra_node(char *name)
	{
		struct para_node *a = malloc(sizeof(struct para_node));
		a -> name = strdup(name);
		a -> type = 'P';
		return (ast_node *)a;
	}
	
	ast_node *new_def_node(char *name, ast_node *f)
	{
	
		struct define_id *a = malloc(sizeof(struct define_id));
		a -> value = f;
		a -> type = 'D';
		a -> name = strdup(name);
		return (ast_node*)a;
	}
	
	struct ast_node *Recursive(int type, ast_node *cur)
	{
		
		if(type == '+')
		{
			
			struct num_node *l;
			struct num_node *r;
			struct num_node *re_node = malloc(sizeof(struct num_node));
			l = (struct num_node*)(travel((cur->left)));
			
			if(cur -> right != NULL)
			{
				r = (struct num_node*)Recursive('+', cur->right);
				re_node -> value = l->value + r->value;
				re_node -> type = 'N';
				return	(ast_node*)re_node;
			}
			else
				return (ast_node*)l;
			

		}
		else if(type == '*')
		{
			struct num_node *l;
			struct num_node *r;
			struct num_node *re_node = malloc(sizeof(struct num_node));
			l = (struct num_node*)(travel(cur->left));
			if(cur -> right != NULL)
			{
				r = (struct num_node*)Recursive('*', cur->right);
				re_node -> value = l->value * r->value;
				re_node -> type = 'N';
				return	(ast_node*)re_node;
			}
			else
				return (ast_node*)l;
			
		}
	}
	ast_node *equ_recursive(ast_node *cur)
	{
		struct num_node *l = (struct num_node*)travel(cur->left);
		struct bool_node *re_node = malloc(sizeof(struct bool_node));
			
		if(cur -> right != NULL)
		{
			ast_node *a = equ_recursive(cur->right);
			if(a->type == 'N')
			{
				struct num_node *r = (struct num_node*)a;
				bool ans;
				if(l-> value == r->value)
					ans = 0;
				else
					ans = 1;
				re_node -> value = ans;
				re_node ->type = 'B';
			}
			else if(a ->type == 'B')
			{
				struct bool_node *r = (struct bool_node*)a;
				if(r -> value == 1)
				{
					re_node -> value = 1;
					re_node -> type = 'B';
				}
				else
				{
					struct num_node *check = (struct num_node*)(travel(cur->right->left));
					bool ans;
					if(check -> value == l -> value)
						ans = 0;
					else
						ans = 1;
					re_node -> value = ans;
					re_node -> type = 'B';
				}
			}
			return	(ast_node*)re_node;
		}
		else
			return (ast_node*)l;			

	}
	ast_node *new_fun_node(ast_node * a, ast_node *b )
	{
		struct fun_node *c = malloc(sizeof(struct fun_node));
		c -> argu = a;
		c -> fun_body = b;
		c -> type = 'F';
		return (ast_node*)c;
	}
	ast_node *new_ast_node(int type, ast_node *l, ast_node *r)
	{
		ast_node *a = malloc(sizeof(ast_node));
		a -> type = type;
		a -> left = l;
		a -> right = r;
		return a;
	}
	ast_node *new_if_node(ast_node* con, ast_node* bra, ast_node *then)
	{
		struct if_node *a = malloc(sizeof(struct if_node));
		a -> condition = con;
		a -> if_exp = bra;
		a -> else_exp = then;
		a -> type = 'I';
		return (ast_node*) a;
	}

	ast_node *logic_recursive(int type, ast_node *cur)
	{
		
		if(type == 1)
		{
			struct bool_node *re_node = malloc(sizeof(struct bool_node));
			struct bool_node *l = (struct bool_node*)travel(cur -> left);
			
			if(cur -> right != NULL)
			{
				
				struct bool_node *r = (struct bool_node*)logic_recursive(1, cur -> right);
				if( l->value == 0 && r->value == 0)
					re_node -> value = 0;
				else
					re_node -> value = 1;
				re_node -> type = 'B';
				return (ast_node*)re_node;
				
			}
			else
				return (ast_node*) l;
		}
		else if(type == 2)
		{
			struct bool_node *re_node = malloc(sizeof(struct bool_node));
			struct bool_node *l = (struct bool_node*)travel(cur -> left);
			if(cur -> right != NULL)
			{
				
				struct bool_node *r = (struct bool_node*)logic_recursive(2, cur -> right);
				if( l->value == 0 || r->value == 0)
					re_node -> value = 0;
				else
					re_node -> value = 1;
				re_node -> type = 'B';
				return (ast_node*)re_node;
				
			}
			else
				return (ast_node*) l;

		}
		
	}
	
	void get_value(ast_node *cur_value, ast_node *cur_name, struct fun_argu store[], int *fun_top)
	{
		
		if(cur_name -> right != NULL || cur_value -> right != NULL)
		{
			
			if(cur_name -> right == NULL)
				return ;
			if(cur_value -> right == NULL)
				return ;
		
			store[*fun_top].value = cur_value -> left;
			struct para_node *tmp = (struct para_node*) (cur_name ->left);
			store[*fun_top].name = strdup(tmp->name);
			(*fun_top) ++;
			get_value(cur_value->right, cur_name->right, store, fun_top);

		}
		else 
		{	
		
			store[*fun_top].value = cur_value -> left;
			struct para_node *tmp = (struct para_node*) (cur_name ->left);
			store[*fun_top].name = strdup(tmp->name);
			(*fun_top) ++;
		}	
	}
	void put_value(ast_node *cur, struct fun_argu store[], int *fun_top)
	{
		if(cur -> type == 'B' || cur->type == 'N')
			return ;

		if(cur->left != NULL)
		{
			if((cur->left)->type == 'P')
			{
				
				struct para_node *s = (struct para_node *)(cur->left);
				int i;
				
				for(i = 0; i < *fun_top; i++)
				{
					if(strcmp(s->name, store[i].name) == 0)
					{
						cur -> left = store[i].value;
						break;
					}
				}
				if(i == *fun_top)
				{
					printf("argu error");
					exit(0);
				}
			}
			else
				put_value(cur->left, store, fun_top);
		}
        if(cur->right != NULL)
		{
			if((cur->right)->type == 'P')
			{
				struct para_node *s = (struct para_node *)(cur->right);
				int i;
				for(i = 0; i < *fun_top; i++)
				{
					if(strcmp(s->name, store[i].name) == 0)
					{
						cur -> right = store[i].value;
						break;
					}
				}
				if(i == *fun_top)
				{
					printf("argu error\n");
					exit(0);
				}
			}
			else
				put_value(cur->right, store, fun_top);
		}

	}
	ast_node* fun_fuction(ast_node *cur)
	{
		
		struct fun_node *fun_exp = (struct fun_node*)cur->left;
		ast_node *body = fun_exp -> fun_body;
		ast_node *para = NULL;//value
		ast_node *argu = NULL;//name
		//return travel(body);
		
		if((cur->right) != NULL)
		{
			argu = cur->right;
			para = fun_exp -> argu;
			struct fun_argu store[100];
			int fun_top = 0;
			get_value(argu, para, store, &fun_top);
			put_value(body , store, &fun_top);
			return travel(body);
		}	
		else 
		{ 	
			return travel(body);
		}
		
	}

	ast_node *travel(ast_node *node)
	{
		int type = node->type;
		
		if(type == 'A')
		{
			travel(node -> left);
			travel(node -> right);
		}
		else if(type == 'N')
		{
			return node;
		}
		else if(type == 'B')
		{
			return node;
		}
		else if(type == '+')
		{
			if((node->right)->type == 'R')
			{
				struct num_node *l = (struct num_node*)travel(node -> left);	
				struct num_node *r = (struct num_node*)Recursive('+', node->right);
				struct num_node *re_node = malloc(sizeof(struct num_node));
				re_node -> value = (l->value ) + (r ->value);
				re_node -> type = 'N';
				return re_node;
				
			}
			else
			{
				struct num_node *l = (struct num_node*)travel(node -> left);
				struct num_node *r = (struct num_node*)travel(node -> right);
				struct num_node *re_node = malloc(sizeof(struct num_node));
				re_node -> value = (l -> value) + (r -> value);
				re_node -> type = 'N';
				return re_node;
			}	
		}
		else if(type == '-')
		{
               		struct num_node *l = (struct num_node*)travel(node -> left);
			struct num_node *r = (struct num_node*)travel(node -> right);
			struct num_node *re_node = malloc(sizeof(struct num_node));
			re_node -> value = (l -> value) - (r -> value);
			re_node -> type = 'N';
			return re_node;
		}
		else if(type == '*')
		{
		
			if((node->right)->type == 'R')
			{
				struct num_node *l = (struct num_node*)travel(node -> left);	
				struct num_node *r = (struct num_node*)Recursive('*', node->right);
				struct num_node *re_node = malloc(sizeof(struct num_node));
				re_node -> value = (l->value ) * (r ->value);
				re_node -> type = 'N';
				return re_node;
				
			}
			else
			{
				struct num_node *l = (struct num_node*)travel(node -> left);
				struct num_node *r = (struct num_node*)travel(node -> right);
				struct num_node *re_node = malloc(sizeof(struct num_node));
				re_node -> value = (l -> value) * (r -> value);
				re_node -> type = 'N';
				return re_node;
			}	
		}
		else if(type == '/')
		{
	
               		struct num_node *l = (struct num_node*)travel(node -> left);
			struct num_node *r = (struct num_node*)travel(node -> right);
			struct num_node *re_node = malloc(sizeof(struct num_node));
			re_node -> value = (l -> value) / (r -> value);
			re_node -> type = 'N';
			return re_node;
		}
		else if(type == '%')
		{
        		struct num_node *l = (struct num_node*)travel(node -> left);
			struct num_node *r = (struct num_node*)travel(node -> right);
			struct num_node *re_node = malloc(sizeof(struct num_node));
			re_node -> value = (l -> value) % (r -> value);
			re_node -> type = 'N';
			return re_node;
			
		}
		else if(type == '>')
		{
			struct num_node *l = (struct num_node*)travel(node -> left);
			struct num_node *r = (struct num_node*)travel(node -> right);
			struct bool_node *re_node = malloc(sizeof(struct bool_node));
			bool ans;
			if(l->value > r->value)
				ans = 0;
			else
				ans = 1;
			re_node -> value = ans;
			re_node -> type = 'B';
			return re_node;
			
		}
		else if(type == '<')
		{
			struct num_node *l = (struct num_node*)travel(node -> left);
			struct num_node *r = (struct num_node*)travel(node -> right);
			struct bool_node *re_node = malloc(sizeof(struct bool_node));
			bool ans;
			if(l->value < r->value)
				ans = 0;
			else
				ans = 1;
			re_node -> value = ans;
			re_node -> type = 'B';
			return re_node;
		}
		else if(type == '=')
		{
			if((node->right)->type == 'R')
			{
				return	equ_recursive(node);
			}
		}
		else if(type == 'R')
		{
			travel(node -> left);
			if(node -> right != NULL)
				travel(node -> right);
		}
		else if(type == 1)// and
		{
			
			return logic_recursive(1, node);
			
		}
		else if(type == 2) // or
		{
			return logic_recursive(2, node);

			
		}
		else if(type ==3) //not
		{
			struct bool_node *re = malloc(sizeof(struct bool_node));
			re = (struct bool_node *)(travel(node -> left));
			if(re -> value == 0)
				re -> value = 1;
			else
				re -> value = 0;
			
		}
		else if(type == 'P')
		{
			struct para_node *a = (struct para_node*)node;
			struct para_node *re_node = malloc(sizeof(struct para_node));
			int i;
			for(i = 0; i < top; i++)
			{
				if(strcmp(store[i].name, a->name) == 0)
				{
					return store[i].value;
				}
			}
			if(i == top)
			{
				printf("not found\n");
				exit(0);
			}	
		}
		else if(type == 'D')
		{
			struct define_id *re_node = malloc(sizeof(struct define_id));
			struct define_id *a = (struct define_id *)node;
			ast_node *define_value = travel(a -> value);
			re_node -> value = define_value;
			re_node -> type = 'D';
			re_node -> value_type = define_value->type;
			re_node -> name = strdup(a -> name);
			store[top].value = define_value;
			store[top].type = 'D';
			store[top].name = strdup(a -> name);
			store[top].value_type = define_value -> type;
			top ++;
			return (ast_node*)re_node;	
		}
		else if(type == 'F')
		{
			struct fun_node *a = (struct fun_node*) node;
			if(a -> argu != NULL)
				travel(a -> argu);
			if(a -> fun_body != NULL)
				travel(a -> fun_body);
		}
		else if(type == 'I')
		{
			struct if_node *a = (struct if_node*) node;
			if(((struct bool_node*)travel(a -> condition)) -> value == 0)
			{
				return travel(a -> if_exp);
			}
			else
			{
				return travel(a -> else_exp);
			}
		}
		else if(type == 'C')
		{
			return fun_fuction(node);
		}
		else if(type == 'H')
		{
			if(node -> left != NULL)
				travel(node -> left);
			if(node -> right != NULL)
				travel(node -> right);
		}
		else 
		{
			printf("123");
		}
	}

	
%}
%union{
	int value;
        char *str;
	struct ast_node *ast;
	struct para_node *para;
	struct define_node *defi;
	
}
%token<value> NUM
%token<str>ID BOOL_VAL
%token ADD SUB MUL DIV MOD EQUAL
%token AND OR NOT
%token BIGGER SMALLER
%token DEFINE IF FUN
%token SEP
%token PRINT_BOOL PRINT_NUM
%token PRA_L PRA_R

%type <ast> exp exp_recursive num_op logic_op
%type <ast> plus minus multiply divide module
%type <ast> great small equ 
%type <ast> and or not
%type <ast> fun_exp fun_call
%type <ast> fun_ids fun_body  id_clo id fun_name
%type <ast> if_exp pram
%type <ast> test_exp then_exp else_exp
%type <ast> def_st 
%type <ast> stmt program print
%left AND OR NOT
%left BIGGER SMALLER
%left ADD SUB
%left MUL DIV MOD
%left PRA_L PRA_R


%%

program		: stmt sep program seps                 {$$ = new_ast_node('H',$1, $3); head = $$;}
	 	| stmt sep				{$$ = new_ast_node('H',$1, NULL); head = $$;}
		;

sep		: SEP					{}
     		| SEP sep       
		;

seps		: sep					{}
      		|
		;

stmt		: exp					{$$ = $1;travel($1);}
      		| def_st				{$$ = $1;travel($1);}
		| print		
		;

print		: PRA_L PRINT_NUM seps exp PRA_R	{
       								ast_node *a = malloc(sizeof(ast_node));
       								a = travel($4);
								struct num_node *b = (struct num_node*)a;
								printf("%d\n", b -> value);
								
							}
       		| PRA_L PRINT_BOOL  seps exp PRA_R	{
								ast_node *a = malloc(sizeof(ast_node));
       								a = travel($4);
								struct bool_node *b = (struct bool_node*)a;
								if(b ->  value == 0)
									printf("#t\n");
								else 
									printf("#f\n");
									
							}	
		;

exp		: BOOL_VAL 				{
     								if($1[1] == 't')
									$$ = new_bool_val(0);
								else
									$$ = new_bool_val(1);
							}
		| NUM					{$$ = new_num($1);}
		| ID					{$$ = new_pra_node($1);}
		| num_op				{$$ = $1;} 
		| logic_op				{$$ = $1;}
		| fun_exp   				{$$ = $1;}
		| fun_call				{$$ = $1;}
		| if_exp				{$$ = $1;}
		;

exp_recursive	: seps exp exp_recursive		{$$ = exp_recursive('R', $2, $3);}
	  	| seps exp				{$$ = exp_recursive('R', $2, NULL);}
		;

num_op		: plus 					{$$ = $1;}
		| minus					{$$ = $1;}
		| multiply				{$$ = $1;}
		| divide				{$$ = $1;}
		| module				{$$ = $1;}
		| great					{$$ = $1;}
		| small					{$$ = $1;}
		| equ					{$$ = $1;}
		;

plus		: PRA_L ADD seps exp exp_recursive PRA_R {$$ = new_num_op('+', $4, $5);}
     		;

minus		: PRA_L SUB seps exp sep exp PRA_R	 {$$ = new_num_op('-', $4, $6);}
       		;

multiply	: PRA_L MUL seps exp exp_recursive PRA_R {$$ = new_num_op('*', $4, $5);}
		;

divide		: PRA_L DIV seps exp sep exp PRA_R	 {$$ = new_num_op('/', $4, $6);}
		;

module		: PRA_L MOD seps exp sep exp PRA_R	 {$$ = new_num_op('%', $4, $6);}
       		;

		;
great		: PRA_L BIGGER seps exp sep exp PRA_R 	 {$$ = new_num_op('>', $4, $6);}
	        ;

small		: PRA_L SMALLER seps exp sep exp PRA_R   {$$ = new_num_op('<', $4, $6); } 
       		;

equ		: PRA_L EQUAL seps exp exp_recursive PRA_R {$$ = new_num_op('=', $4, $5); }
     		;

logic_op	: and   				{$$ = $1;}	
	 	| or					{$$ = $1;}
		| not					{$$ = $1;}
		;

and 		: PRA_L AND seps exp exp_recursive PRA_R {$$ = new_logic(1, $4, $5);}
      		;

or		: PRA_L OR seps exp exp_recursive PRA_R {$$ = new_logic(2,  $4, $5);}
		;

not		: PRA_L NOT seps exp PRA_R 		{$$ = new_logic(3,  $4, NULL);}
     		;

def_st		: PRA_L DEFINE sep ID seps exp PRA_R    {$$ = new_def_node($4, $6);}
    		;

id 		: ID 					{$$ = new_pra_node($1);}		
		;

fun_exp		: PRA_L FUN seps fun_ids seps fun_body PRA_R	{$$ = new_fun_node($4, $6);}
	 	;

fun_ids		: PRA_L id_clo PRA_R				{$$ = $2;}
	 	;

id_clo		: id sep id_clo                                 {$$ = new_argu($1, $3);}
		| id						{$$ = new_argu($1, NULL);}	
		|						{$$ = new_argu(NULL, NULL);}	
		;

fun_body 	: exp              				{$$ = $1;}
	  	;


fun_call	: PRA_L fun_exp seps pram PRA_R	    		{$$ = new_ast_node('C', $2, $4);}          
	 	| PRA_L fun_exp seps PRA_R			{$$ = new_ast_node('C', $2, NULL);}
		| PRA_L fun_name seps pram PRA_R		{$$ = new_ast_node('C', $2, $4);}
		| PRA_L fun_name seps PRA_R			{$$ = new_ast_node('C', $2, NULL);}
		;

pram		:   exp_recursive		{$$ = $1;}
		;

fun_name	: id				{$$ = $1;}
	 ;

if_exp 		: PRA_L IF seps test_exp seps then_exp sep else_exp PRA_R	{$$ = new_if_node($4, $6, $8);}
		;

test_exp 	: exp								{$$ = $1;}
	  	;

then_exp 	: exp								{$$ = $1;}
	 	;

else_exp 	: exp								{$$ = $1;}
	  	;

		
%%
void yyerror(char *mes)
{
	printf("%s\n", mes);
	exit(0);
	printf("Invalid format\n");
}
int main()
{
	yyparse();
	return 0;
}
