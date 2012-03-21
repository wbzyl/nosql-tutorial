var http = require('http')

// curl 'localhost:9200/nosql_tweets/_search?size=8&pretty=true' -d '{"sort":[ {"created_at": "desc"} ]}'

var client = http.request({
  host: 'localhost'
, port: 9200
, path: '/nosql_tweets/_search?size=8&pretty=true'
, method: 'POST'
});

client.on('error', function(e) {
  console.log('problem with request:', e.message);
});

var query = { "sort": [ { "created_at": "desc" } ] };

http.createServer(function(request, response) {
  if (request.url == '/') {
    client.on('response', function(result) {
      result.setEncoding('utf8');
      result.on('data', function (chunk) {
        var tweets = JSON.parse(chunk).hits.hits

        var output = ['<!doctype html><html><head></head><body><h1>Latest Tweets</h1>'];
        tweets.forEach(function(tweet) {
          output.push('<p>' + tweet._source.text + '</p>');
        });
        output.push('</body></html>');

        // console.log(output.join(""));
        response.writeHead(200, {'Content-Type': 'text/html'});
        response.end(output.join(""));
      });
    });
    client.end(JSON.stringify(query));
  };
}).listen(8000, '127.0.0.1');
