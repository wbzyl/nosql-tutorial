var couchapp = require('couchapp');

var ddoc = {
  _id:'_design/app', 
};

ddoc.shows = {};
ddoc.updates = {};
ddoc.views = {};
ddoc.lists = {};

module.exports = ddoc;
