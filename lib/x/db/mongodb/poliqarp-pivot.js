m = function() {
  var word = this.orth;
  this.lex.forEach(function(x) {
    emit(x.base, { lex: [ { orth: word, ctag: x.ctag } ] });
  });
}

// function emit(key, value) {
//   print("emit( " + key + ", " + tojson(value) + " )");
// };
// x = db.base.findOne();
// m.apply(x);

r = function(key, values) {
  var list = { lex: [] };
  values.forEach(function(x) {
    list.lex = x.lex.concat(list.lex);
  });
  return list;
};

// printjson(r('ziemski', [ {"lex": [{"orth":"ziemskimi","ctag":1}]}, {"lex": [{"orth":"ziemskiej","ctag":2}]} ]));

f = function(key, value) {
  return value.lex;  // a to po co? kto wie?
};

db.base.mapReduce(m, r, { finalize: f, out: "pivot" });
