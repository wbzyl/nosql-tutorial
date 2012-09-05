m = function() {
  if (!this.tags) {
    return;
  }

  this.tags.forEach(function(tag) {
    emit(tag, 1);
  });
};

r = function(key, values) {
  var total = 0;

  values.forEach(function(count) {
    total += count;
  });

  return total;
};

//results = db.ls.mapReduce(m, r, {out : "ls.tags"});

results = db.runCommand({
  mapreduce: "ls",
  map: m,
  reduce: r,
  out: 'ls.tags'
});

printjson(results);

print("==>> To display results run: db.ls.tags.find({_id: 'nauka'})");
