/*------------------------------------------------IMPORTACIONES----------------------------------------------*/
%{
    let idTemporal = 0;
%}
%lex
%options case-sensitive
%%

[0-9]+\b                %{  return 'tk_entero';  %}
[a-zA-Z]([a-zA-Z0-9_])* %{  return 'tk_identificador';  %}
"("                     %{  return 'tk_pa';  %}
")"                     %{  return 'tk_pc';  %}
"+"                     %{ return 'tk_mas'; %}
"-"                     %{ return 'tk_menos';%}
"*"                     %{ return 'tk_multiplicar';%}
"/"                     %{ return 'tk_division'%}
[ \t\r\n\f]+         { /*se ignoran*/ }

<<EOF>>     {  return 'EOF';   }

.	       { tbl_error.push(['Error Lexico: ' + yytext , yylloc.first_line ,yylloc.first_column])   }
  

/lex


%left tk_mas tk_menos
%left tk_division tk_multiplicar


%start INICIO
%% 
INICIO: E EOF   {   
                    $$ = $1
                    idTemporal = 0;
                    return  $$.c3d;
                };



E : E tk_mas T      {
                        $$ = {
                                tmp:"t" + idTemporal,
                                c3d: $1.c3d + $3.c3d + "t"+ idTemporal +" = " + $1.tmp + " + " + $3.tmp +"\n"  
                            }
                            idTemporal++;
                    }
    | E tk_menos T  {
                        $$ = {
                                tmp:"t" + idTemporal,
                                c3d: $1.c3d + $3.c3d + "t"+ idTemporal +" = " + $1.tmp + " - " + $3.tmp + "\n" 
                            }
                            idTemporal++;
                    }
    | T             {
                        $$ = {tmp: $1.tmp, c3d:$1.c3d};
                    };



T : T tk_multiplicar F  {
                            $$ = {
                                tmp:"t" + idTemporal,
                                c3d: $1.c3d + $3.c3d + "t"+ idTemporal +" = " + $1.tmp + " * " + $3.tmp +"\n"  
                            }
                            idTemporal++;
                        }
    | T tk_division F   {
                            $$ = {
                                tmp:"t" + idTemporal,
                                c3d: $1.c3d + $3.c3d + "t"+ idTemporal +" = " + $1.tmp + " / " + $3.tmp +"\n"  
                            }
                            idTemporal++;
                        }
    | F     { 
                $$ = {tmp: $1.tmp, c3d:$1.c3d};
            };


F : tk_pa E tk_pc       { 
                            $$ = {tmp: $2.tmp, c3d:$2.c3d};
                        }
    | tk_entero         { 
                            $$ = {tmp: $1, c3d:""};
                        }
    | tk_identificador  { 
                            $$ = {tmp: $1, c3d:""};
                        };
