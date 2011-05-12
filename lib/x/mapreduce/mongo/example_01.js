// mongo --shell example_01.js

db.mr.drop();

db.mr.insert({_id: 1, tags: ['ą', 'ć', 'ę']});
db.mr.insert({_id: 2, tags: ['']});
db.mr.insert({_id: 3, tags: []});
db.mr.insert({_id: 4, tags: ['ć', 'ę', 'ł']});
db.mr.insert({_id: 5, tags: ['ą', 'a']});

m = function() {
  this.tags.forEach(function(tag) {
    emit(tag, {count: 1});
  });
};

r = function(key, values) {
  var total = 0;
  values.forEach(function(value) {
    total += value.count;
  });
  return {count: total};
};

res = db.mr.mapReduce(m, r, {out: "mr.tc"});

printjson(res);
print("==>> To display results run: db.mr.tc.find()");
