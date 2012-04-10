// var couchapp = require('couchapp');

// couchapp push flickr.js http://localhost:5984/tatry

ddoc = {
  _id: '_design/photos'
  , views:   {}
  , lists:   {}
  , shows:   {}
  , spatial: {}
}
module.exports = ddoc;

ddoc.spatial.points = function(doc) {
  if (doc.geometry && doc.title) {
    emit(doc.geometry, {title: doc.title, image: doc.image_url_medium});
  };
};

// Spatial queries:
//   http://localhost:5984/tatry/_design/photos/_spatial/points?bbox=0,0,180,90
//   http://localhost:5984/tatry/_design/photos/_spatial/points?bbox=0,0,180,90&count=true

ddoc.lists.wkt = function(head, req) {
  var row;
  start({
    "headers": { "Content-Type": "text/html" }
  });
  while (row = getRow()) {
    log(JSON.stringify(row));
    send("<p><a href='" + row.value.image + "'>" + row.value.title + "</a>\n" );
  };
};

// List query:
//   http://localhost:5984/tatry/_design/photos/_spatial/_list/wkt/photos/points?bbox=0,0,180,90
