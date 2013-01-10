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

// concat performance test
//   http://jsperf.com/multi-array-concat/7
//
// values = [ {names: [2, 3]}, {names: [3, 1]}, {names: [5]}]
// values.reduce(function(a,b) { return a.concat(b.names); }, [])

r = function(key, values) {
  var list = values.reduce(function(a, b) {
    return a.concat(b.names);
  }, []);
  return { names: list };

  // var value = values.reduce(function(prev, cur) {
  //   return { names: prev.names.concat(cur.names) };
  // }, { names: [] });
  // return value;

  // var list = { names: [] };
  // values.forEach(function(x) {
  //   list.names = x.names.concat(list.names);
  // });
  // return list;
};

f = function(key, value) {
  return value.names;  // a to po co? kto wie?
};

res = db.rock.mapReduce(m, r, { finalize: f, out: "pivot" });
printjson(res);

// db.pivot.findOne();
// {
// 	"_id" : "00s",
// 	"value" : [
// 		"Queen + Paul Rodgers",
// 		"Izzy Stradlin",
// 		"Gilby Clarke"
// 	]
// }
// db.pivot.find().pretty()
// db.pivot.find().forEach(printjson)

db.genres.drop();

db.pivot.find().forEach(function(doc) {
  var ddoc = {};
  ddoc.tag = doc._id;
  ddoc.names = doc.value;
  db.genres.insert(ddoc);
});

// db.genres.findOne();
// {
//   "_id": ObjectId("50ef109a42b2d7efca2179e0"),
//   "tag": "00s",
//   "names": [
//     "Gilby Clarke",
//     "Izzy Stradlin",
//     "Queen + Paul Rodgers"
//   ]
// }
// db.genres.find().pretty();

assert.eq(181, db.genres.count(), "liczba tagów");