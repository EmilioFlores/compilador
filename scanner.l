%{
#include <iostream>
#include <string.h>
using namespace std;
#define YY_DECL extern "C" int yylex()
#include "parser.tab.h"  // to get the token types that we return
int line_num = 1;
void yyerror(const char *s);

%}

digit [0-9]
letter [a-zA-Z]
ID [a-z][a-z0-9]*

%%
[ \t]          ;
"+"                  			{ return PLUS;       }
"-"                  			{ return MINUS;      }
"*"                  			{ return TIMES;      }
"/"                  			{ return SLASH;      }
"("                  			{ return LPAREN;     }
")"                  			{ return RPAREN;     }
"{"                  			{ return LCURLY;     }
"}"                  			{ return RCURLY;     }
"["                  			{ return LBRACKET;     }
"]"                  			{ return RBRACKET;     }
";"                  			{ return SEMICOLON;  }
","                  			{ return COMMA;      }
"."                  			{ return DOT;      }
"="                  			{ return EQL;        }
"=="                  			{ return EQLEQL;        }
"!="                 			{ return NEQ;        }
":"                 			{ return COLON;        }
"<"                  			{ return LSS;        }
">"                  			{ return GTR;        }
"<="                  			{ return LSSOEQL;        }
">="                  			{ return GTROEQL;        }
"||"                  			{ return OR;        }
"&&"                  			{ return AND;        }

"condicion"           			{ return CONDICIONSYM;      }
"programa"            			{ return PROGRAMASYM;    }
"fallo"               			{ return FALLOSYM;    }
"var"                			{ return VARSYM;     }
"muestra"              			{ return MUESTRASYM;   }
"muestraLinea"		   			{ return MUESTRALINEASYM;   }
"lee"		   					{ return LEESYM;   }
"bandera"						{ return BANDERASYM; 	}
"caracter"						{ return CARACTERSYM; 	}
"entero"						{ return ENTEROSYM; }
"gran entero"					{ return GRANENTEROSYM; }
"decimal"						{ return DECIMALSYM; }
"texto"							{ return TEXTOSYM; }
"arreglo"						{ return ARREGLOSYM; }
"matriz"						{ return MATRIZSYM; }
"ciclo"							{ return CICLOSYM; }
"haz"							{ return HAZSYM; }
"mientras"						{ return MIENTRASSYM; }
"funcion"						{ return FUNCIONSYM; }
"regresa"						{ return REGRESASYM; }
"incluir"						{ return INCLUIRSYM; }
"falso"							{   yylval.bval = 0; 
									return BANDERA; 
								}
"verdadero"						{ 	yylval.bval = 1; 
									return BANDERA; 
								}
"objeto"						{ return OBJETOSYM; }
"privado"						{ return PRIVADOSYM; }
"publico"						{ return PUBLICOSYM; }
{letter}({letter}|{digit})*		{ 
									
									yylval.sval=_strdup(yytext);
									return IDENTIFICADOR; 
								}
({digit})+\.({digit})+			{ 	
									 yylval.fval = atof(yytext);
									 return DECIMAL; 
								}
({digit})+       				{ 
									yylval.ival = atoi(yytext);
									return ENTERO;
								 }
\"{letter}({letter}|{digit})*\" { 
									yylval.sval = strdup(yytext);
									return TEXTO;
								}
\n             					{ ++line_num; }
.								{ECHO ; yyerror ("unexpected character");}
%% 