t = db.map;
t.drop();

t.insert({_id: 1, tags: ['ą', 'ć', 'ć', 'ł']});
t.insert({_id: 2, tags: ['ł', 'ń', 'ą']});

m = function() {
  this.tags.forEach(function(tag) {
    emit(tag, {count: 1});
  });
};

function emit(key, value) {
  print("emit( " + key + ", " + tojson(value) + " )");
};

print('MAP: test one doc')
x = t.findOne();
m.apply(x);  // call our map function, client side, with 'x' as 'this'

print('MAP: test multiple docs:')
t.find().forEach(function(doc) {
  m.apply(doc);
});

r = function(key, values) {
  var total = 0;
  values.forEach(function(value) {
    total += value.count;
  });
  return {count: total};
};

print("REDUCE: r('a', [ {count: 2}, {count: 4}, {count: 2} ])")
printjson(r('a', [ {count: 2}, {count: 4}, {count: 2} ]));

print("REDUCE: r('a', [ {count: 2}, r('a', [{count: 4}, {count: 2}]) ])")
printjson(r('a', [ {count: 2}, r('a', [{count: 4}, {count: 2}]) ]));

res = t.mapReduce(m, r, {out: "map.lc"});
printjson(res);

// res.drop();
