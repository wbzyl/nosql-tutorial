function(doc, req) {
  var Mustache = require('lib/mustache');
  var name = Mustache.name;
  var version = Mustache.version;

  log(name + ": " + version); // szukamy wierszy zawierających ' Log :: '

  return "<h3>read commonjs module: " + name + ", version: " + version + "</h3>";
}
