var couchapp = require('couchapp');

ddoc = {
  _id: '_design/test'
  , views: {}
  , lists: {}
}
module.exports = ddoc;

ddoc.views.sun = {
  map: function(doc) {
    var retweeted = /\b(via|RT)\s*(@\w+)/ig;
    // w tej wersji tylko pierwsze dopasowanie
    var match = retweeted.exec(doc.text);
    if (match != null) {
      emit([match[2].toLowerCase(), doc.screen_name], doc.text);
    };
  },
  reduce: "_count"
}

// couchapp push sun.js http://localhost:5984/nosql-slimmed
