// couchapp push props.js http://localhost:5984/ksiazki
// couchapp push props.js http://Admin:Pass@sigma.ug.edu.pl:5984/ksiazki

var couchapp = require('couchapp');

ddoc = {
    _id: '_design/test'
  , views: {}
}
module.exports = ddoc;

ddoc.views.props = {
  map: function(doc) {
    for (var p in doc) {
      emit(p);
    }
  },
  reduce: "_count"
}
