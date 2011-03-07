var couchapp = require('couchapp')
  , path = require('path')
  , fs = require('fs');

ddoc = {
    _id: '_design/default'
  , views: {}
  , lists: {}
  , shows: {}
  , templates: {}
}

module.exports = ddoc;

ddoc.shows.quotation = function(doc, req) {
  var mustache = require('templates/mustache');

  /* this == design document (JSON) zawierający tę funkcję */
  var template = this.templates['quotation.html'];
  var html = mustache.to_html(template, {quotation: doc.quotation});

  return html;
}

ddoc.templates.mustache = fs.readFileSync('templates/mustache.js', 'UTF-8');
ddoc.templates['quotation.html'] = fs.readFileSync('templates/quotation.html.mustache', 'UTF-8');

couchapp.loadAttachments(ddoc, path.join(__dirname, '_attachments'));
