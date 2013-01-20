var reshape = function(t) {
  var out = {}

  out._id = t._id;
  out.created_at = { $date: Date.parse(t._source.created_at) };
  out.text = t._source.text;
  out.user_mentions = t._source.user_mentions;
  out.hashtags = t._source.hashtags;
  out.urls = t._source.urls;
  out.screen_name = t._source.screen_name;
  out.track = t._type;

  return JSON.stringify(out);
}

var rest = require('restler');

var iterate = function(data) {  // funkcja rekurencyjna
  rest.get('http://localhost:9200/_search/scroll?scroll=10m', { data: data._scroll_id } )
    .on('success', function(data, response) {
      if (data.hits.hits.length != 0) {
        data.hits.hits.forEach(function(tweet) {
          console.log(reshape(tweet)); // wypisz JSONa w jednym wierszu
        });
        iterate(data);
      };
    });
};

rest.get('http://localhost:9200/tweets/_search?search_type=scan&scroll=10m&size=32')
  .on('success', function(data, response) {
    iterate(data);
});

// Przerabiamy takiego JSON-a:
// {
//  "_source" : {
//     "created_at" : "2013-01-19T20:04:08+01:00",
//     "user_mentions" : [
//        "digitalocean",
//        "etelsverdlov"
//     ],
//     "text" : "RT @digitalocean: Our first article written..",
//     "hashtags" : [],
//     "urls" : [],
//     "screen_name" : "etelsverdlov"
//  },
//  "_score" : 0,
//  "_index" : "tweets",
//  "_id" : "292709040247668737",
//  "_type" : "rails"
// }
// na:
// {
//   "_id" : "292709040247668737"
//   "created_at" : "2013-01-19T20:04:08+01:00",
//   "user_mentions" : [ "digitalocean", "etelsverdlov" ],
//   "text" : "RT @digitalocean: ...",
//   "hashtags" : [],
//   "urls" : [],
//   "screen_name" : "etelsverdlov",
//   "tag" : "rails"
// }