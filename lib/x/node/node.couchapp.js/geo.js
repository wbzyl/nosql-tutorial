var couchapp = require('couchapp');

ddoc = {
  _id: '_design/default'
  , views:   {}
  , lists:   {}
  , shows:   {}
  , spatial: {}
}

ddoc.spatial.points = function(doc) {
  if (doc.loc) {
    emit({type: "Point", coordinates: [doc.loc[0], doc.loc[1]]}, [doc._id, doc.loc]);
  };
};

ddoc.lists.wkt = function(head, req) {
  var row;
  while (row = getRow()) {
    send("POINT(" + row.value[1] + ")\n");
  };
};

module.exports = ddoc;

// couchapp push geo.js http://localhost:5984/places
