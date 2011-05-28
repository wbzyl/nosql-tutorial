// mongo --shell mapreduce pivot.js

function emit(k, v) {
  print("emit:");
  print("  key:" + tojson(k) + " value:" + tojson(v));
}

map = function() {
  //printjson(this.tags);
  for(var i in this.tags) {
    key = { tag: this.tags[i] };
    value = { names: [ this.name ] };
    emit(key, value);
  }
}

reduce = function(key, values) {
  names_list = { names: [] };
  for(var i in values) {
    names_list.names = values[i].names.concat(names_list.names);
  }
  return names_list;
}

printjson(db.rock.names.mapReduce(map, reduce, { out: "pivot" }));

//db.pivot.find().forEach(printjson);

// x = db.rock.names.findOne();
// map.apply(x);
// printjson(reduce({ "tag" : "hiphop" }, { "names" : [ "AC" ] }));

// {
//   "_id" : {
//     "tag" : "psychedelicrock"
//   },
//   "value" : {
//     "names" : [
//       "The Yardbirds",
//       "The Velvet Underground",
//       "The Jimi Hendrix Experience",
//       "The Doors",
//       ...
//     ]
//   }
// }

// finalize function
