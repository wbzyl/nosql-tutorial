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
    var match = retweeted.exec(doc.text);
    if (match != null) {
      // emit([match[2].toLowerCase(), doc.screen_name], null);
      emit([match[2].toLowerCase(), doc.screen_name], doc.text);
    };
  }
}

ddoc.lists.circo = function(head, req) {
  var row;
  start({
    "headers": {
      "Content-Type": "text/plain"
    }
  });

  send("strict digraph {\n");
  while(row = getRow()) {
    // "@JustinBieber" -> "eliyahhhxD" [tweet_id=45577472607125504];
    send('"' + row.key[0] + '"' + " -> " + '"' + row.key[1] + '"' + " [tweet_id=" + row.id + "];\n");
  };
  send("}\n");
}

// bez funkcji listowej, bo nie działa tak jak należy

ddoc.views.graph = {
  map: function(doc) {
    var retweeted = /\b(via|RT)\s*(@\w+)/ig;
    var match = retweeted.exec(doc.text);
    if (match != null) {
      emit([match[2].toLowerCase(), doc.screen_name], null);
    };
  },
  reduce: function(keys, values, rereduce) {
    var retwitters = [];

    if (!rereduce) {
      keys.map(function(key) {
          // [["@tapajos","dirceu"],"45880323204067328"]
          retwitters.push(key[0][1]);
      });
    } else {
      values.map(function(o) {
          //if (value.retwitters.length < 32) {
          retwitters.push(o.retwitters[0]);
          //};
      });
    };
    return retwitters;
  }
}

// couchapp push circo.js http://localhost:5984/nosql-slimmed
// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/circo/sun?limit=100' > nosql-tweets.gv
// circo -v -s32 -Tpng -Onosql-tweets nosql-tweets.gv

// curl 'http://localhost:5984/nosql-slimmed/_design/test/_view/graph'
