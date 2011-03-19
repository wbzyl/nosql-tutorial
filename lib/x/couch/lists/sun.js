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

ddoc.lists.all = function(head, req) {


  var row;
  start({
    "headers": {
      "Content-Type": "text/html"
    }
  });

  row = getRow();
  send(row.value);
  log("------------------------------");
  log(row);
  log("------------------------------");

  row = getRow();
  send(row.value);
  log("------------------------------");
  log(row);
  log("------------------------------");

  // while(row = getRow()) {
  //   send(row.value);
  // }
}

// couchapp push sun.js http://localhost:5984/nosql-slimmed
// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?reduce=false&limit=2&q="rbates"'
