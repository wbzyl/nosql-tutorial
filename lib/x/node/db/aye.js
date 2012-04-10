var couchapp = require('couchapp');

ddoc = {
  _id: '_design/default'
  , views: {}
  , lists: {}
  , shows: {}
}
module.exports = ddoc;

ddoc.shows.aye = function(doc, req) {
  return {
    headers: { "Content-Type": "text/plain" },
    body: "Aye aye: " + req.query["q"] + "!\n"
  };
};
