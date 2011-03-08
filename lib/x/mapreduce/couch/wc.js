// couchapp push wc.js http://Admin:Pass@localhost:4000/gutenberg

var couchapp = require('couchapp');

ddoc = {
    _id: '_design/app'
  , views: {}
}
module.exports = ddoc;

ddoc.views.wc = {
  map: function(doc) {
    var words = doc.text.toLowerCase().split(/\W+/);
    var len = words.length;
    for (var i = 0; i < len; i++) {
        var word = words[i];
        if (word.length > 0) {
            emit([word, doc.title], 1);
        }
    }
  },
  reduce: "_sum"
}
