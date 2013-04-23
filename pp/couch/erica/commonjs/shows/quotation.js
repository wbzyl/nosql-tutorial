function(doc, req) {
  var Mustache = require('lib/mustache');
  // this == design document
  var template = this.templates['quotation.html'];
  log("template:\n" + template);

  return "<h3>quotation</h3>";
}
