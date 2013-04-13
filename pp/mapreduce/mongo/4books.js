m = function() {
  this.paragraph.toLowerCase().match(/[A-Za-z\u00C0-\u017F]+/g).forEach(function(word) {
    emit(word, 1);
  });
};

r = function(key, values) {
  return Array.sum(values);
};

var res = db.chesterton.mapReduce(m, r, {out: "wc"});

printjson(res);