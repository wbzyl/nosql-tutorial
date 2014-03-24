var mapred = function(min, max) {
  return db.runCommand({ mapreduce: "uniques",
      map: function () {
          emit(this.dim0, 1);
      },
      reduce: function (key, values) {
          return Array.sum(values);
      },
      out: "mrout" + min,
      // jsMode: true,
      sort:  { dim0: 1 },
      query: { dim0: { $gte: min, $lt: max } }
  });
};

var res = db.runCommand({
  splitVector: "test.uniques",
  keyPattern: {dim0: 1},
  maxChunkSizeBytes: 32 *1024 * 1024
});

var keys = res.splitKeys;

var numThreads = 4
var inc = Math.floor(keys.length / numThreads) + 1
threads = [];
for (var i = 0; i < numThreads; ++i) {
  var min = (i == 0) ? 0 : keys[i * inc].dim0;
  var max = (i * inc + inc >= keys.length) ? MaxKey : keys[i * inc + inc].dim0 ;
  print("min:" + min + " max:" + max);
  var t = new ScopedThread(mapred, min, max);
  threads.push(t);
  t.start();
};

for (var i in threads) {
  var t = threads[i];
  t.join();
  printjson(t.returnData());
};
