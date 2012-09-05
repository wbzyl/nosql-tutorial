var cursor = db.goog.find( {$query: {}, $snapshot: true} )

while (cursor.hasNext()) {
  var doc = cursor.next();
  var ms = Date.parse(ISODate(doc.Date));
  doc.Date = new Date(ms);
  db.goog.save(doc);
}

// mongo stock goog_fix_Date.js

// start = new Date(2008, 1, 31)
// db.goog.find({Date: {$gt: start}}).sort({Date: 1})
