// http://docs.mongodb.org/manual/tutorial/write-scripts-for-the-mongo-shell/
var conn = new Mongo();
db = conn.getDB("gutenberg");

m = function() {
  this.words.forEach(function(word) {
    emit(word.toLowerCase(), 1);
  });
};

r = function(key, values) {
  return Array.sum(values);
};

res = db.chesterton.mapReduce(m, r, {out: "wc"});
printjson(res);
// db.wc.find().sort({value: -1})