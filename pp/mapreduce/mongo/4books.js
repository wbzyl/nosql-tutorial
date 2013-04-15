m = function() {
  res = this.p.toLowerCase().match(/[\w\u00C0-\u017F]+/g);
  if (res) {
    res.forEach(function(word) {
      emit(word, 1);
    });
  }
};

r = function(key, values) {
  return Array.sum(values);
};

res = db.books.mapReduce(m, r, {out: "wc"});

printjson(res);
