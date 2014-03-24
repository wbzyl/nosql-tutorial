m = function () {
  emit(this.dim0, 1);
};
r = function (key, values) {
  return Array.sum(values);
};
db.uniques.mapReduce(m, r, {out: "mrout"});
