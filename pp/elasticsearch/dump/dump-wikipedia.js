var rest = require('restler');

var iterate = function(data) {  // funkcja rekurencyjna
  rest.get('http://localhost:9200/_search/scroll?scroll=10m', { data: data._scroll_id } )
    .on('success', function(data, response) {
      if (data.hits.hits.length != 0) {
        data.hits.hits.forEach(function(tweet) {
          console.log(JSON.stringify(tweet)); // wypisz JSONa w jednym wierszu
        });
        iterate(data);
      };
    });
};

rest.get('http://localhost:9200/tmp/_search?search_type=scan&scroll=10m&size=32')
  .on('success', function(data, response) {
    iterate(data);
});
