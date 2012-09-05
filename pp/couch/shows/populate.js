var cc = require('couch-client')('http://wlodek:sekret13@localhost:4000/lec')
, fs = require('fs');

// var callback = function(err, doc) {
//   if (err) throw err;
//   console.log("saved %s", JSON.stringify(doc));
// };

//console.log(cc.uri);

text = fs.readFileSync('lec.json', 'UTF-8')
//console.log(JSON.parse(text));

cc.request("POST", cc.uri.pathname + "/_bulk_docs", JSON.parse(text), function (err, results) {
    if (err) throw err;
    console.log("saved %s", JSON.stringify(results));
});
