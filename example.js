var fs = require("fs");
var parser = require("./index");

fs.writeFileSync('example_output.json', JSON.stringify(parser.parse(fs.readFileSync('example_input', 'UTF-8'))));
