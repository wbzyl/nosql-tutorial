var couchapp = require('couchapp');

ddoc = {
    _id: '_design/app'
  , views: {}
}

module.exports = ddoc;

ddoc.views.by_date = {
  map: function(doc) {
    emit(doc.created_at, doc.quotation.length);
  },
  reduce: "_sum"
}

ddoc.views.by_tag = {
  map: function(doc) {
    for (var k in doc.tags)
      emit(doc.tags[k], null);
  },
  reduce: "_count"
}
