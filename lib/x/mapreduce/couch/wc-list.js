var couchapp = require('couchapp');

ddoc = {
    _id: '_design/app'
  , views: {}
  , lists: {}
}
module.exports = ddoc;

ddoc.views.words = {
  map: function(doc) {
    var words = doc.text.toLowerCase().
      split(/[\W_]+/).
      filter(function(w) {
        return w.length > 0;
      });
    words.forEach(function(word) {
      emit([word, doc.title], null);
    });
  },
  reduce: "_count"
}

ddoc.views.title = {
  map: function(doc) {
    var words = doc.text.toLowerCase().
      split(/\W+/).
      filter(function(w) {
        return w.length > 0;
      });
    words.forEach(function(word) {
      emit([doc.title, word], null);
    });
  },
  reduce: "_count"
}

ddoc.lists.raw = function(head, req) {
  var row;
  start({
    "headers": {
      "Content-Type": "text/plain"
    }
  });
  while(row = getRow()) {
    send(JSON.stringify(row));
    send("\n");
  };
}

// couchapp push wc-list.js http://localhost:5984/gutenberg

// http://localhost:5984/gutenberg/_design/app/_list/raw/words
// {"key":null,"value":1427985}

// http://localhost:5984/gutenberg/_design/app/_list/raw/title?group_level=1
// {"key":["a study in scarlet"],"value":43480}
// {"key":["beyond lies the wub"],"value":2822}
// {"key":["curious creatures"],"value":512}
// {"key":["memoirs of sherlock holmes"],"value":78507}
// {"key":["newton the right and wrong uses of the bible"],"value":56684}
// {"key":["the defenders"],"value":6906}
// {"key":["the idiot"],"value":241057}
// {"key":["the innocence of father brown"],"value":79298}
// {"key":["the man who knew too much"],"value":60014}
// {"key":["the return of sherlock holmes"],"value":210527}
// {"key":["the sign of the four"],"value":83131}
// {"key":["the skull"],"value":5724}
// {"key":["war and peace"],"value":559355}

// http://localhost:5984/gutenberg/_design/app/_list/raw/words?group_level=2&skip=1000&limit=40
// http://localhost:5984/gutenberg/_design/app/_list/raw/words?group_level=1&skip=1000&limit=40

// http://localhost:5984/gutenberg/_design/app/_list/raw/words
// {"key":null,"value":1427985}

// sigma

// http://sigma.ug.edu.pl:5984/gutenberg/_design/app/_list/raw/words
// http://sigma.ug.edu.pl:5984/gutenberg/_design/app/_list/raw/title?group_level=1
// http://sigma.ug.edu.pl:5984/gutenberg/_design/app/_list/raw/words?group_level=2&skip=1000&limit=40
// http://sigma.ug.edu.pl:5984/gutenberg/_design/app/_list/raw/words?group_level=1&skip=1000&limit=40
