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
"!"                        %{ return 'tK_not';}%
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
    
INSTRUCCION :   INSTRUCCION WHILE
                | INSTRUCCION ASIGNACION
                | INSTRUCCION IF ELSE
                | INSTRUCCION IF
                | IF ELSE 
                        {
                            
                        }
                | IF tk_else tK_la INSTRUCCION tK_lc 
                        {
                                                    
                        }
                | IF 
                        {
                            
                        }
                | WHILE 
                    {
                        $$ = {

                        }   
                    }
                | ASIGNACION 
                    {
                        $$ = {

                        }
                    };

WHILE : while tk_pa ELOGOR tk_pc tK_la INSTRUCCION tK_lc
            {
                $$ = {
                    er : "L"+idEtiqueta,
                    c3d : "L"+idEtiqueta +": \n" + $3.c3d +  $3.ev + ":\n" + $5.c3d + "\n"+ "goto " 
                    + "L"+idEtiqueta +"\n" + $3.ef + ":"   
                }
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

ELOGOR  : ELOGOR tK_or ELOGAND 
            {
                $$ = {
                    ev : $1.ev + ", " + $3.ev,
                    ef : $3.ef,
                    c3d : $1.c3d + $1.ef + ":\n" + $3.c3d   
                }
            }
        | ELOGAND 
            {
                $$ = {
                    ev : $1.ev,
                    ef : $1.ef,
                    c3d : $1.c3d
                }
            };

ELOGAND : ELOGAND tK_and ELOGNOT 
            {
                $$ = {
                    ev : $3.ev,
                    ef : $1.ef + ", " + $3.ef,
                    c3d : $1.c3d + $1.ev + ":\n" + $3.c3d   
                }
            }
        | ELOGNOT 
            {
                $$ = {
                    ev : $1.ev,
                    ef : $1.ef,
                    c3d : $1.c3d
                }
            };

ELOGNOT : tK_not ELOGNOT 
            {
                $$ = {
                    ev : $2.ef,
                    ef : $2.ev,
                    c3d : $2.c3d
                }
            }
        | EREL 
            {
                $$ = {
                    ev : $1.ev,
                    ef : $1.ef,
                    c3d : $1.c3d
                }
            };

EREL :  EREL tk_mayor E {
                            $$ = {
                                ev:"L"+idEtiqueta,
                                ef:"L"+idEtiqueta+1,
                                c3d: $1.c3d + $3.c3d + "\n" + "if " + $1.tmp + " > " + " goto L"+idEtiqueta 
                                + "\n goto L" +idEtiqueta+1
                            }
                            idEtiqueta += 2;
                        }
        | EREL tk_igual tk_igual E 
                        {
                            $$ = {
                                ev:"L"+idEtiqueta,
                                ef:"L"+idEtiqueta+1,
                                c3d: $1.c3d + $3.c3d + "\n" + "if " + $1.tmp + " == " + " goto L"+idEtiqueta 
                                + "\n goto L" +idEtiqueta+1
                            }
                            idEtiqueta += 2;
                        }  
        | EREL tK_menor E   
                        {
                            $$ = {
                                ev:"L"+idEtiqueta,
                                ef:"L"+idEtiqueta+1,
                                c3d: $1.c3d + $3.c3d + "\n" + "if " + $1.tmp + " < " + " goto L"+idEtiqueta 
                                + "\n goto L" +idEtiqueta+1
                            }
                            idEtiqueta += 2;
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
                
