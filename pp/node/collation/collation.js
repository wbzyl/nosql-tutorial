var cradle = require('cradle');

// cradle.setup({
//   host: 'localhost',
//   cache: true,
//   raw: false
// });

var conn = new(cradle.Connection);
var db = conn.database('coll');

db.exists(function (err, exists) {
  if (err) {
    console.log('error', err);
  } else if (exists) {
    console.log('the database \"coll\" exists. the force is with you.');

    /* populate database with these documents */

    for (var i = 32; i <= 126; i++) {
      db.save({"x": String.fromCharCode(i)}, function(err, res) {
        if (err) throw err;
      });
    };

  } else {
    console.log('database does not exists.');
    console.log('rerun the script to populate the \"coll\" database');
    db.create();
  }
});
