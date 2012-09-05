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

// wersja 1.
// ddoc.lists.all = function(head, req) {
//   var row;
//   start({
//     "headers": {
//       "Content-Type": "text/plain"
//     }
//   });
//   while(row = getRow()) {
//     send(row.value);
//     send("\n");
//   }
// }

// wersja 2.
// ddoc.lists.all = function(head, req) {
//   var row;
//   var rows = [];
//   start({
//     "headers": {
//       "Content-Type": "text/plain"
//     }
//   });
//   while(row = getRow()) {
//     rows.push(row);
//   };
//   rows.sort(function(a, b) {
//     return b.value - a.value;
//   });
//   rows.map(function(row) {
//     send(JSON.stringify(row));
//     send("\n");
//   });
// }

// wersja 3.
ddoc.lists.all = function(head, req) {
    var row;
    var rows = [];
    var cutoff = req.query["cutoff"] || 1;
    start({
        "headers": {
            "Content-Type": "text/plain"
        }
    });
    while(row = getRow()) {
        if (row.value >= cutoff) {
            rows.push(row);
        };
    };
    rows.sort(function(a, b) {
        return b.value - a.value;
    }).map(function(row) {
        send(JSON.stringify(row));
        send("\n");
    });
}

// couchapp push sun.js http://localhost:5984/nosql-slimmed

// pierwsza wersja all
// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?reduce=false&limit=2&q="rbates"'
// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?reduce=false&limit=4'
// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?reduce=false&limit=4&skip=100'

// druga wersja all
// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?group_level=1'

// trzecia wersja all
// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?group_level=1&cutoff=40'
