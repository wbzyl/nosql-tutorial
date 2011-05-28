// mongo --shell mapreduce pivot.js

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
  return value.names;
};

db.pivot.drop();

db.rock.names.mapReduce(m, r, { finalize: f, out: "pivot" });

printjson(db.pivot.findOne());

// db.pivot.find().forEach(printjson);
// {
//   "_id" : "00s",
//   "value" : [
//     "Queen + Paul Rodgers",
//     "Izzy Stradlin",
//     "Gilby Clarke"
//   ]
// }
