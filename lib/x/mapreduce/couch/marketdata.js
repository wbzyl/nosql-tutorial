var couchapp = require('couchapp');

ddoc = {
  _id: '_design/test'
  , views: {}
}
module.exports = ddoc;

ddoc.views.total = {
  map: function(doc) {
    emit([doc.volume, doc.price], doc.volume * doc.price);
  },
  reduce: function(keys, values, rereduce) {
    log('REREDUCE: ' + rereduce);
    log('KEYS: ' + keys);
    log('VALUES: ' + values);
    return sum(values);
  }
}

// couchapp push marketdata.js http://localhost:5984/marketdata
// curl http://localhost:5984/marketdata/_design/test/_view/total
