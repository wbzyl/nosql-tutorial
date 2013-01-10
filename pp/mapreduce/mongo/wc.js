db.books.insert({ _id: 1, filename: "hamlet.txt",  content: "to be or not to be" });
db.books.insert({ _id: 2, filename: "phrases.txt", content: "to wit" });

// function emit(k, v) {
//   print("emit"); print(" key: " + k + " value: " + tojson(v));
// };

m = function() {
  this.content.match(/[a-z]+/g).forEach(function(word) {
    emit(word, 1);
  });
};

// x = db.books.findOne();
// m.apply(x);

r = function(key, values) {
  return Array.sum(values);
  // var value = 0;
  // values.forEach(function(count) {
  //   value += count;
  // });
  // return value;
};

res = db.books.mapReduce(m, r, {out: "wc"});
z = res.convertToSingleObject();

printjson(z);  // to samo co print(tojson(z))
// z == { "be" : 2, "not" : 1, "or" : 1, "to" : 3, "wit" : 1 }

assert.eq( 2 , z.be, "liczba wystąpień 'be'" );
assert.eq( 1 , z.not, "liczba wystąpień 'not'" );
assert.eq( 1 , z.or, "liczba wystąpień 'or'" );
assert.eq( 3 , z.to, "liczba wystąpień 'to'" );
assert.eq( 1 , z.wit, "liczba wystąpień 'wit'" );

// sprzątamy po skrypcie
// db.books.drop();
// db.wc.drop();