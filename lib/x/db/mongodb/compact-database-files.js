// source: http://learnmongo.com/posts/compacting-mongodb-data-files/

// Usage: mongo DATABASE compact-database-files.js

// Get a the current collection size.
var storage = db.foo.storageSize();
var total = db.foo.totalSize();

print('Storage Size: ' + tojson(storage));

print('TotalSize: ' + tojson(total));

print('-----------------------');
print('Running db.repairDatabase()');
print('-----------------------');

// Run repair
db.repairDatabase()

// Get new collection sizes.
var storage_a = db.foo.storageSize();
var total_a = db.foo.totalSize();

print('Storage Size: ' + tojson(storage_a));
print('TotalSize: ' + tojson(total_a));
