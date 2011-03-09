var couchapp = require('couchapp');

ddoc = {
    _id: '_design/test'
  , views: {}
}
module.exports = ddoc;

ddoc.views.rating_avg = {
  map: function(doc) {
    emit(doc.rating, {"count": 1, "rating_total": doc.rating});
  },
  reduce: function(keys, values, rereduce) {
    log('REREDUCE: ' + rereduce);
    log('KEYS: ' + keys);
    // log('VALUES: ' + values); => [object Object],[object Object],...
    var count = 0;
    values.forEach(function(element) { count += element.count; });
    var rating = 0;
    values.forEach(function(element) { rating += element.rating_total; });
    return {"count": count, "rating_total": rating};
  }
}

// couchapp push movies.js http://localhost:5984/movies
// curl http://localhost:5984/movies/_design/test/_view/rating_avg
