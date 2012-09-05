var couchapp = require('couchapp');

ddoc = {
  _id: '_design/default'
  , views: {}
  , lists: {}
};

module.exports = ddoc;

ddoc.views.jsons = {
  map: function(doc) {
    emit(null, doc);
  }
};

ddoc.lists.all = function(head, req) {
  var row;
  start({
    "headers": {
      "Content-Type": "text/plain"
     }
  });
  while(row = getRow()) {
    send(JSON.stringify(row.value));
    send("\n");
  }
};

// Instrukcja użycia:
// 
//   couchapp push rock.js http://localhost:5984/rock
// 
//   curl http://localhost:5984/rock/_design/default/_list/all/jsons | \
//     mongoimport --type json --drop  -d test -c rock
// 
// na konsoli mongo usuwamy zbędne pola:
// 
//   db.rock.update({}, { $unset: { _rev: 1, tracks: 1, similar: 1 } }, false, true)
