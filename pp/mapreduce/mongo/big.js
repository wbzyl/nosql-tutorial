m = function() {
   emit("answer", { min: this.x, max: this.x });
};
r =  function(key, values) {
  var value = values.reduce(function(prev, cur) {
    if (cur.min < prev.min) prev.min = cur.min;
    if (cur.max > prev.max) prev.max = cur.max;
    return prev;
  }, {min: 1, max: 0});
  return value;
};

res = db.big.mapReduce(m, r, { out: {inline: 1} });