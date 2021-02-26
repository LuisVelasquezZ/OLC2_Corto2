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

console.log("Entrada 1:");
ejecutar("(a + b) * (a + c)");
console.log("\n");
console.log("Entrada 2:");
ejecutar("x * x");
console.log("\n");
console.log("Entrada 3:");
ejecutar("y * y");
console.log("\n");
console.log("Entrada 4:");
ejecutar("x2 + y2");
console.log("\n");
console.log("Entrada 5:");
ejecutar("b + c + d");
console.log("\n");
console.log("Entrada 6:");
ejecutar("a * a + b * b");
console.log("\n");
console.log("Entrada 7:");
ejecutar("5 + 2 * b");
console.log("\n");
console.log("Entrada 8:");
ejecutar("6 + 7 * 10+5 / 1");
console.log("\n");
console.log("Entrada 9:");
ejecutar("((7 + 9)/(((3 + 1) * (6 + 7) + 8) * 7) / 9) + 100");
console.log("\n");
console.log("Entrada 10:");
ejecutar("7 * 9 - 89 + 63");
console.log("\n");
