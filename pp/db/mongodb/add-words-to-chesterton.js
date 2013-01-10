// Node.JS MongoDB Driver Manual
//   http://mongodb.github.com/node-mongodb-native/contents.html

var natural = require('natural')
, tokenizer = new natural.WordTokenizer()
, assert = require('assert')
, mongoClient = require('mongodb').MongoClient;

mongoClient.connect("mongodb://localhost:27017/gutenberg", {native_parser: true}, function(err, db) {
  assert.equal(null, err);

  var collection = db.collection('chesterton');
  var cursor = collection.find({}, {snapshot: true});

  cursor.each(function(err, doc) {
    if (err) throw err;
    if (doc == null) {
      db.close();
    } else {
      var words = tokenizer.tokenize(doc.paragraph);
      doc.words = words;
      // Simple full document replacement function. 
      // Not recommended for efficiency, use atomic operators 
      // and update instead for more efficient operations.
      collection.save(doc, {w: 1}, function(err, result) {
        assert.equal(null, err);
        console.log(result);
      });
      console.dir(doc);
    };
  });
});

// ========================================================================================
// =  Please ensure that you set the default write concern for the database by setting    =
// =   one of the options                                                                 =
// =                                                                                      =
// =     w: (value of > -1 or the string 'majority'), where < 1 means                     =
// =        no write acknowlegement                                                       =
// =     journal: true/false, wait for flush to journal before acknowlegement             =
// =     fsync: true/false, wait for flush to file system before acknowlegement           =
// =                                                                                      =
// =  For backward compatibility safe is still supported and                              =
// =   allows values of [true | false | {j:true} | {w:n, wtimeout:n} | {fsync:true}]      =
// =   the default value is false which means the driver receives does not                =
// =   return the information of the success/error of the insert/update/remove            =
// =                                                                                      =
// =   ex: new Db(new Server('localhost', 27017), {safe:false})                           =
// =                                                                                      =
// =   http://www.mongodb.org/display/DOCS/getLastError+Command                           =
// =                                                                                      =
// =  The default of no acknowlegement will change in the very near future                =
// =                                                                                      =
// =  This message will disappear when the default safe is set on the driver Db           =
// ========================================================================================