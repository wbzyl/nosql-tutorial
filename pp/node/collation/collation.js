var cc = require('couch-client');
var coll = cc("http://localhost:4000/coll");

for (var i=32; i<=126; i++) {
  coll.save({"x": String.fromCharCode(i)}, function(err, doc) {
    if (err) throw err;
    console.log("saved %s", JSON.stringify(doc));
  });
};
