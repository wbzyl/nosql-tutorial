// function emit(k, v) {
//   print("emit"); print(" key: " + k + " value: " + tojson(v));
// };

// db.crazy.drop();
// for (var i = 0; i < 1024000; i++)
//   db.crazy.insert( { x: Math.random() } );

m = function() {
   emit("answer", this.x);
};

// x = db.crazy.findOne();
// m.apply(x);

r = function(key, values) {
  var value = values.shift();
  values.forEach(function(x, i) {
    value += x/(i+2);
  });
  return value;
};

res = db.crazy.mapReduce(m, r, { out: {inline: 1} });

printjson(res);
