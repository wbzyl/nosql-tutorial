for (var i = 0; i < 10000000; ++i) {
  db.uniques.insert({ dim0: Math.floor(Math.random()*1000000) });
};
