# Descripción
Traductor a codigo de 3 direcciones construido con jison y node.js

## Reglas Semánticas
![image text](/img/F.png)
* En la producción F al encontrar un terminal sintetiza el atributo "c3d" como cadena vacía y el lexema en el atributo "temp", si es una expresión entre parentesis sintetiza los atrigutos igual.

![image text](/img/T.png)
* En la produción T y E con operador genera un nuevo "tmp" y concatena el c3d que traen los operandos con el nuevo tmp y los valores de los operandos, en las producciones sin operador sintentiza los valores que trae.

## Salidas
### Entrada 1
* (a + b) * (a + c) 

![image text](/img/e1.png)
### Entrada 2
* x * x

![image text](/img/e2.png)
### Entrada 3
* y * y

![image text](/img/e3.png)
### Entrada 4
* x2 + y2

![image text](/img/e4.png)
### Entrada 5
* b + c + d

![image text](/img/e5.png)
### Entrada 6
* a * a + b * b

![image text](/img/e6.png)
### Entrada 7
* 5 + 2 * b

![image text](/img/e7.png)
### Entrada 8
* 6 + 7 * 10+5 / 1

![image text](/img/e8.png)
### Entrada 9
* ((7 + 9)/(((3 + 1) * (6 + 7) + 8) * 7) / 9) + 100

![image text](/img/e9.png)
### Entrada 10
* 7 * 9 - 89 + 63

![image text](/img/e10.png)
