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

ddoc.lib.mustache = fs.readFileSync('lib/mustache.js', 'utf-8');
ddoc.templates.quotation = fs.readFileSync('templates/quotation.html', 'utf-8');

ddoc.shows.quotation = function(doc, req) { 
  var mustache = require('lib/mustache');
  var template = this.templates.quotation; /* this == design document (JSON) */

  var html = mustache.to_html(template, {quotation: doc.quotation});
  return html;
};

couchapp.loadAttachments(ddoc, path.join(__dirname, 'attachments_m'));

module.exports = ddoc;
