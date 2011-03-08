// couchapp push wc.js http://Admin:Pass@localhost:5984/gutenberg

var couchapp = require('couchapp');

ddoc = {
    _id: '_design/app'
  , views: {}
}
module.exports = ddoc;

ddoc.views.wc = {
  map: function(doc) {
    var words = doc.text.toLowerCase().split(/\W+/);
    for (var i = 0, len = words.length; i < len; i++) {
        var word = words[i];
        if (word != '') {
            emit([word, doc.title], 1);
        }
    }
  },
  reduce: "_sum"
}

ddoc.views.by_title = {
  map: function(doc) {
    var words = doc.text.toLowerCase().split(/\W+/);
    for (var i = 0, len = words.length; i < len; i++) {
        var word = words[i];
        if (word != '') {
            emit([doc.title, word], 1);
        }
    }
  },
  reduce: "_sum"
}
