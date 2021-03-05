/*------------------------------------------------IMPORTACIONES----------------------------------------------*/
%{
    let idTemporal = 0;
    let idEtiqueta = 0;
    let salidas = [];
%}
%lex
%options case-sensitive
%%
"true"                      %{  return 'tk_true';  %}
"false"                     %{  return 'tk_false';  %}
"if"                        %{  return 'tk_if';  %}
"else"                      %{  return 'tk_else';  %}
[0-9]+\b                    %{  return 'tk_entero';  %}
[a-zA-Z]([a-zA-Z0-9_])*     %{  return 'tk_identificador';  %}
"("                         %{  return 'tk_pa';  %}
")"                         %{  return 'tk_pc';  %}
"+"                         %{ return 'tk_mas'; %}
"-"                         %{ return 'tk_menos';%}
"*"                         %{ return 'tk_multiplicar';%}
"/"                         %{ return 'tk_division';%}
"="                         %{ return 'tk_igual';}%
">"                         %{ return 'tk_mayor';}%
"<"                         %{ return 'tK_menor';}%
"&&"                        %{ return 'tK_and';}%
"||"                        %{ return 'tK_or';}%
";"                         %{ return 'tK_puntocoma';}%
"{"                         %{ return 'tK_la';}%
"}"                         %{ return 'tK_lc';}%
[ \t\r\n\f]+         { /*se ignoran*/ }

<<EOF>>     {  return 'EOF';   }

.	       { tbl_error.push(['Error Lexico: ' + yytext , yylloc.first_line ,yylloc.first_column])   }
  

/lex


%left tk_mas tk_menos
%left tk_division tk_multiplicar


%start INICIO
%% 
INICIO: ASIGNACION EOF   {   
                    $$ = $1
                    idTemporal = 0;
                    return  $$.c3d;
                };
    
INSTRUCCION :   INSTRUCCION IF ELSE
                | INSTRUCCION IF
                | IF ELSE
                | IF tk_else tK_la ASIGNACION tK_lc {}
                | IF

IF : tk_if tk_pa EREL tk_pc tK_la ASIGNACION tK_lc
            {
                $$ = {
                    tmp: "L"+idEtiqueta++,
                    c3d: "if " + $3.tmp + " goto L" + idEtiqueta +"\ngoto L" + idEtiqueta+ "\nL"+ idEtiqueta +":" + "\n"+ $6.c3d + "\n goto L"+ idEtiqueta + 2 + "\nL" +  ; 
                    salida:idEtiqueta + 2; 
                }
                idEtiqueta = idEtiqueta + 2;
                salidas.push(idEtiqueta + 2);
            };

ELSE :    ELSE tk_else IF {}
        | ELSE tk_else tK_la ASIGNACION tK_lc {}
        | tk_else IF 
            {
                $$ = {
                    tmp: "L"+idEtiqueta,
                    c3d: "if " + $3.tmp + " goto L" + idEtiqueta +"\ngoto L" + idEtiqueta+ + "\n"+ $6.c3d + "\n goto L"+ idEtiqueta + 2; 
                    salida:idEtiqueta + 2; 
                }
                salidas.push(idEtiqueta + 2); 
                idEtiqueta = idEtiqueta + 2;
            };


ASIGNACION: ASIGNACION tk_identificador tk_igual E tK_puntocoma 
                        {
                            $$ = {
                                c3d: $1.c3d +  " " + $2 +" " + "=" + "t" + $4.tmp
                            }
                        }
            | tk_identificador tk_igual E tK_puntocoma 
                        {
                            $$ = {
                                c3d: $1.c3d +  " " + $2 +" " + "=" + "t" + $4.tmp
                            }
                        };

ELOG :  ELOG tK_and EREL {}
        | ELOG tK_or EREL {}
        | EREL {};

EREL :  EREL tk_mayor E {
                                $$ = {
                                    tmp:$1.tmp + ">" $3.tmp,
                                    c3d: $1.c3d + $3.c3d + "\n" 
                                }
                            }
        | EREL tk_igual tk_igual E {
                                        $$ = {
                                            tmp:$1.tmp + "==" $4.tmp,
                                            c3d: $1.c3d + $4.c3d + "\n" 
                                        }
                                    }  
        | EREL tK_menor E   {
                                $$ = {
                                        tmp:$1.tmp + ">" $3.tmp,
                                        c3d: $1.c3d + $3.c3d + "\n" 
                                    }
                            }
        | E {
                $$ = {tmp: $1.tmp, c3d:$1.c3d};
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
                        }
    | tk_false          {
                            $$ = {tmp: $1, c3d:""};
                        }
    | tk_true           {
                            $$ = {tmp: $1, c3d:""};
                        }
                
