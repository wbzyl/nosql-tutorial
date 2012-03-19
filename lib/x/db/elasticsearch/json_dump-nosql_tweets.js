var rest = require('restler');

// https://github.com/danwrong/restler

// funkcja rekurencyjna

var iterate = function(data) {
  rest.post('http://localhost:9200/_search/scroll?scroll=10m', { data: data._scroll_id } )
    .on('success', function(data, response) {
      if (data.hits.hits.length != 0) {
        data.hits.hits.forEach(function(tweet) {
          console.log(JSON.stringify(tweet)); // wypisz json w jednym wierszu
        });
        iterate(data);
      };
    });
};

// TODO:
//
// iterate(data, callback)
//   ...
//   console.log(JSON.stringify(callback(tweet)));

// TODO:
//
// ARGV -- jakiś moduł, coś w stylu optparse?
// opcje podobne do tych z polecenia mongoexport

rest.get('http://localhost:9200/nosql_tweets/_search?search_type=scan&scroll=10m&size=8')
  .on('success', function(data, response) {
    iterate(data);
  });

// 1 step: get _scroll_id
//
// { _scroll_id: 'c2NhbjsxOzEzOTpDb3FnTWp2QlNkdVF0T2VEaGl2VnVROzE7dG90YWxfaGl0czoxOTs=',
//   took: 0,
//   timed_out: false,
//   _shards: { total: 1, successful: 1, failed: 0 },
//   hits: { total: 19, max_score: 0, hits: [] } }

// 2nd step: get tweets
//
// { _scroll_id: 'c2NhbjsxOzEzOTpDb3FnTWp2QlNkdVF0T2VEaGl2VnVROzE7dG90YWxfaGl0czoxOTs=',
//   took: 0,
//   timed_out: false,
//   _shards: { total: 1, successful: 1, failed: 0 },
//   hits:
//    { total: 19,
//      max_score: 0,
//      hits:
//       [ [Object],
//         ...
//         [Object] ] } }

// Search API - Scroll: http://www.elasticsearch.org/guide/reference/api/search/scroll.html
// Search API - Search Type, Scan: http://www.elasticsearch.org/guide/reference/api/search/search-type.html
