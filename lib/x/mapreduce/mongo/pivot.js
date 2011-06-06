// mongo --shell pivot.js

// function emit(k, v) {
//    print("emit:");
//    print("  key:" + tojson(k) + " value:" + tojson(v));
// }

m = function() {
  var value = { names: [ this.name ] };
  this.tags.forEach(function(tag) {
    emit(tag, value);
  });
};

// x = db.rock.names.findOne();
// map.apply(x);

r = function(key, values) {
  var list = { names: [] };
  values.forEach(function(x) {
    list.names = x.names.concat(list.names);
  });
  return list;
};

f = function(key, value) {
  return value.names;  // a to po co? kto wie?
};

res = db.rock.mapReduce(m, r, { finalize: f, out: "pivot" });
printjson(res);

// printjson(db.pivot.findOne());
// {
// 	"_id" : "00s",
// 	"value" : [
// 		"Queen + Paul Rodgers",
// 		"Izzy Stradlin",
// 		"Gilby Clarke"
// 	]
// }
//
// db.pivot.find().forEach(printjson)

db.genres.drop();

db.pivot.find().forEach(function(doc) {
  var ddoc = {};
  ddoc.tag = doc._id;
  ddoc.names = doc.value;
  db.genres.insert(ddoc);
});

// printjson(db.genres.findOne());
// db.genres.find().forEach(printjson)

assert.eq(181, db.genres.count(), "liczba tagów");
