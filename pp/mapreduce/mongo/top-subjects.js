// function emit(k, v) {
//   print("emit"); print(" key: " + k + " value: " + tojson(v));
// };

m = function() {
  emit(this['Subject'], 1);
};

// x = db.books.findOne();
// m.apply(x);

r = function(key, values) {
  var value = 0;
  values.forEach(function(count) {
    value += count;
  });
  return value;
};

res = db.spam.mapReduce(m, r, {out: "spam.subjects"});
printjson(res);
