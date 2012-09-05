var mongo = require('mongodb')
, server = new mongo.Server("127.0.0.1", 27017, { })
, db = new mongo.Db('gutenberg', server, { strict: true })

var natural = require('natural')
, tokenizer = new natural.WordTokenizer();

db.open(function (error, client) {
  if (error) throw error;

  var collection = new mongo.Collection(client, 'chest');

  collection.find({ }, { snapshot: true })
    .each(function(err, doc) {
      if (error) throw error;

      if (doc == null)
        db.close();
      else {
        //console.dir(doc);
        var words = tokenizer.tokenize(doc.paragraph);
        doc.words = words;
        collection.save(doc);
      };
    });

});
