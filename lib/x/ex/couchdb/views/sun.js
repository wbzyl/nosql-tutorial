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

ddoc.lists.sun = function(head, req) {
    log("------------------------------");
    log(head);
    log("------------------------------");
    log(req);
    log("------------------------------");
    var row = getRow();
    log(row);
  // start({
  //     headers: {"Content-type": "text/html"}
  // });
  //   send("<ul id='people'>\n");
  //   while(row = getRow()) {
  //     doc = row.doc;
  //     send("\t<li class='person name'>" + doc.text + "</li>\n");
  //   }
  //   send("</li>\n")

}

// couchapp push sun.js http://localhost:5984/nosql-slimmed
