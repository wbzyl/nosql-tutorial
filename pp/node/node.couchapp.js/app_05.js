var couchapp = require('couchapp'),
  path = require('path'),
  fs = require('fs');

var ddoc = {
  _id:'_design/app',
  shows: {},
  updates: {},
  views: {},
  lists: {},
  lib: {},
  templates: {},
};

ddoc.lib.dust = fs.readFileSync('lib/dust-full-0.3.0.min.js', 'utf-8');
ddoc.templates.quotation = fs.readFileSync('templates/quotation.html.dust', 'utf-8');

ddoc.shows.quotation = function(doc, req) { 
  var dust = require('lib/dust');
  var template = this.templates.quotation; /* this == design document (JSON) */

  var compiled = dust.compile(template, "page");

  var html = dust.render("page,", {quotation: doc.quotation}, function(err, out) {
    console.log(out);
  });
  return html;
};

couchapp.loadAttachments(ddoc, path.join(__dirname, 'attachments_m'));

module.exports = ddoc;
