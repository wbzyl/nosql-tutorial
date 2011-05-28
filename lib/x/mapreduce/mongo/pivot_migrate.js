var cursor = db.pivot.find({})

while (cursor.hasNext()) {
  var doc = cursor.next();
  var ddoc = {};
  ddoc.tag = doc._id;
  ddoc.names = doc.value;
  db.rock.tags.insert(ddoc);
};

db.pivot.drop();
