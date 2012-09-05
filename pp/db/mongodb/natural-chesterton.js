m = function() {
  this.words.forEach(function(word) {
    emit(word.toLowerCase(), 1);
  });
};

r = function(key, values) {
  var value = 0;
  values.forEach(function(count) {
    value += count;
  });
  return value;
};

res = db.chest.mapReduce(m, r, {out: "wc"});
printjson(res);
