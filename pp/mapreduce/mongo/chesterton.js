m = function() {
  this.paragraph.toLowerCase().match(/[A-Za-z\u00C0-\u017F]+/g).forEach(function(word) {
    emit(word, 1);
  });
};

r = function(key, values) {
  var value = 0;
  values.forEach(function(count) {
    value += count;
  });
  return value;
};

var res = db.chesterton.mapReduce(m, r, {out: "wc"});

printjson(res);
