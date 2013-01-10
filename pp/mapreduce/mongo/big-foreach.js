m = function() {
   emit("answer", { min: this.x, max: this.x });
};
r =  function(key, values) {
  var value = {min: 1, max: 0};
  values.forEach(function(cur) {
    if (cur.min < value.min) value.min = cur.min;
    if (cur.max > value.max) value.max = cur.max;
  });
  return value;
};

res = db.big.mapReduce(m, r, { out: {inline: 1} });