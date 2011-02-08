var couchapp = require('couchapp');

var ddoc = {
  _id:'_design/app',
  shows: {}
};

ddoc.shows.foo = function (doc, req) {
  return "ąćęłńóśźż ĄĆĘŁŃÓŚŹŻ";
};

module.exports = ddoc;
