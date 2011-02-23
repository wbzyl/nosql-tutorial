var couchapp = require('couchapp')
  , path = require('path');

ddoc = {
    _id: '_design/default'
  , views: {}
  , lists: {}
  , shows: {}
}

module.exports = ddoc;

ddoc.shows.aye = function(doc, req) {
  return {
    headers: { "Content-Type": "text/html" },
    body: "<h2>Aye aye: " + req.query["q"] + "</h2>\n<p>" + doc.quotation + "</p>\n"
  }
}
