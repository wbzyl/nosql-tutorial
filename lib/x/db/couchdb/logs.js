var couchapp = require('couchapp');

ddoc = {
  _id: '_design/logs'
  , views: {}
}
module.exports = ddoc;

ddoc.views.date = {
  map: function(doc) {
    emit(doc.ping, null);
  },
  reduce: "_count"
}

// couchapp push logs.js http://localhost:5984/logs-2011
