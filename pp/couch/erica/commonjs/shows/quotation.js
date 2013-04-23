function(doc, req) {
  log(doc.quote);

  var Mustache = require('lib/mustache');
  var template = this.templates['quotation.html']; // this == design document

  var compiledTemplate = Mustache.compile(template); // funkcja
  log("compiled Template:\n" + compiledTemplate.toString());

  //return Mustache.render(template, doc);
  return compiledTemplate(doc);
}
