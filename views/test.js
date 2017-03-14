$.getJSON('http://localhost:9200/tweets/_count', function( data ) {
  console.log('is CORS supported?', $.support.cors);
  console.log('#tweets: ', data.count);
});

input = $('#ajaxform input[type="text"]');

q = {
  "sort":  { "created_at": { "order": "desc" } },
  "from": 0,
  "size": parseInt($('#ajaxform select').val(), 10),
  "query": { "query_string": { "query": input.val() } }
};

query = JSON.stringify(q);

$.ajax({
  url: "http://localhost:9200/tweets/statuses/_search", // use CORS
  type: "POST",
  data : query
}).done(function(data) {
  console.log('#tweets found: ', data.hits.total);
  console.log('#tweets found: ', data.hits);
  dh = data.hits;
});
