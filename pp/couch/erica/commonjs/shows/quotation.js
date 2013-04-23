function(doc, req) {
  log(doc.quote);

  var Mustache = require('lib/mustache');
  var template = this.templates['quotation.html']; // this == design document

  return Mustache.render(template, doc);
}
