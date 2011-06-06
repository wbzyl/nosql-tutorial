var cursor = db.spam.find();

var test = {};

while (cursor.hasNext()) {
  var doc = cursor.next();
  doc['X-Spam-Tests'].forEach(function(name) {
    if (test[name] === undefined) {
      test[name] = 1;
    } else {
      test[name] += 1;
    };
  });
};

//test;

var a = [];
for (c in test) a.push(c);

//a.length;

db.spam.tests.drop();
for (c in test) {
  db.spam.tests.insert({ name: c,  count: test[c] });
};

// db.spam.tests.find(null, {_id: 0}).sort({count: -1});

for (name in test) {
  test[name] = 0;
};

var cursor = db.spam.find();
while (cursor.hasNext()) {
  var doc = cursor.next();
  var report = doc['X-Spam-Report'];
  for (name in report) {
    test[name] += report[name];
  };
};

db.spam.report.drop();
for (name in test) {
  db.spam.report.insert({ name: name,  total: test[name] });
};

// db.spam.report.find(null, {_id: 0}).sort({total: -1});
