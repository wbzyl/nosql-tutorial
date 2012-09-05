var couchapp = require('couchapp'),
  fs = require('fs');

var ddoc = {
  _id:'_design/app',
  templates: {}
};

//ddoc.templates.utf8 = fs.readFileSync('utf8.mustache', 'utf-8');
ddoc.templates.utf8 = fs.readFileSync('utf8.mustache');

module.exports = ddoc;
