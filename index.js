var fs = require('fs');
var parser = require('./gramatica');

function ejecutar(texto)
{
    try
    {
        let traduccion = parser.parse(texto);
        console.log(traduccion);
    }catch(err)
    {
        console.log(err);
    }
}

/*console.log("Salida 1:");
ejecutar("(a + b) * (a + c)");
console.log("\n");
console.log("Salida 2:");
ejecutar("x * x");
console.log("\n");
console.log("Salida 3:");
ejecutar("y * y");
console.log("\n");
console.log("Salida 4:");
ejecutar("x2 + y2");
console.log("\n");
console.log("Salida 5:");
ejecutar("b + c + d");
console.log("\n");
console.log("Salida 6:");
ejecutar("a * a + b * b");
console.log("\n");
console.log("Salida 7:");
ejecutar("5 + 2 * b");
console.log("\n");
console.log("Salida 8:");
ejecutar("6 + 7 * 10+5 / 1");
console.log("\n");
console.log("Salida 9:");
ejecutar("((7 + 9)/(((3 + 1) * (6 + 7) + 8) * 7) / 9) + 100");
console.log("\n");
console.log("Salida 10:");
ejecutar("7 * 9 - 89 + 63");
console.log("\n");*/
console.log("Salida 2:");
ejecutar("!(x<x)==(y>y)");
console.log("\n");