// database: mapreduce

var cursor =  db.spam.subjects.find().sort({value: -1}).limit(13);

// -> scope
var subject = {};

cursor.forEach(function(doc) {
  subject[doc._id] = doc.value;
});

m = function() {
  var s = this['Subject'];
  if (subject[s]) {
    emit(this['From'], 1);
  };
};

r = function(key, values) {
  var value = 0;
  values.forEach(function(count) {
    value += count;
  });
  return value;
};

res = db.spam.mapReduce(m, r, {out: "spammers", scope: {subject: subject}});

printjson(res);
