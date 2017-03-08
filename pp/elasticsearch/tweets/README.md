## Create mapping and get some tweets

[Module: Elasticsearch::API::Actions ](http://www.rubydoc.info/gems/elasticsearch-api/Elasticsearch/API/Actions):

```sh
ruby create_tweets_mapping.rb
ruby fetch-tweets.rb
```

[Multiple date formats](https://www.elastic.co/guide/en/elasticsearch/reference/current/date.html).

```sh
curl -X GET "localhost:9200/tweets/_search?pretty=true" -d '
{
  "query": { "query_string": {"query": "+women +day"} },
  "sort": { "created_at": { "order": "desc" } }
}' | jq .hits.hits[]._source
```

## jQuery – ściąga z $.getJSON

```js
$.getJSON("/tweets/_search?q=redis", function(data) { console.log(data); })
```

Without `.done`:

```js
$.getJSON("/tweets/_search", { query: {query_string: {query: "women"}} },
  function(data) {
    console.log(data);
  }
)
```

With `.done`:

```js
$.getJSON( "/tweets/_search", { query: { query_string: { query: "women"} } } )
  .done(function(data) {
    console.log(data);
  })
  .fail(function( jqxhr, textStatus, error ) {
    var err = textStatus + ", " + error;
    console.log( "Request Failed: " + err );
  });
```
