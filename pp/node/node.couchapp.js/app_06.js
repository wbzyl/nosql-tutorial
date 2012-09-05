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
  templates: {}
};

ddoc.lib.mustache = fs.readFileSync('lib/mustache.js', 'utf-8');
ddoc.templates.info = fs.readFileSync('templates/info.html.mustache', 'utf-8');

ddoc.shows.info = function(doc, req) { 
  var mustache = require('lib/mustache');
  var template = this.templates.info;

  // użyteczne rzeczy: path, requested_path
  // log("---------")
  // log(doc);
  // log("---------")
  // log(req);
  // log("---------")

  var info = {};
  info.title = doc.title;
  info.released = doc.released;
  info.songs = doc.songs;
  info.id = doc._id;
  info.dbname = req.info.db_name 

  var html = mustache.to_html(template, info);
  return html;
};

couchapp.loadAttachments(ddoc, path.join(__dirname, 'attachments_lz'));

module.exports = ddoc;
