var couchapp = require('couchapp');
ddoc = {
  _id: '_design/wc'
  , views: {}
}
module.exports = ddoc;

ddoc.views.markov = {
  map: function(doc) {
    var words = doc.text.toLowerCase().
      split(/\W+/).
      filter(function(w) {
        return w.length > 0;
      });

    words.forEach(function(word, i) {
      if (words.slice(i, 4+i).length > 3) {
        emit(words.slice(i, 4+i), null);
      };
    });
  },
  reduce: "_count"
}

// couchapp push markov.js http://localhost:5984/gutenberg
// http://localhost:5984/gutenberg/_design/wc/_view/markov?startkey=["young",null]&endkey=["young",{}]&group_level=2
// {"rows":[
// {"key":["young","a"],"value":3},
// {"key":["young","accept"],"value":1},
// {"key":["young","adair"],"value":4},
// {"key":["young","aide"],"value":1},
// {"key":["young","alec"],"value":2},
// ...
