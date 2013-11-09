## jQuery – ściąga z $.getJSON

```js
$.getJSON("/tweets/_search?q=redis", function(data) { console.log(data); })
```

```sh
curl -X GET "localhost:9200/tweets/_search?pretty=true" -d '
{
  "query": { "query_string": {"query": "redis"} },
  "sort": { "created_at": { "order": "desc" } }
}'
```

Without `.done`:

```js
$.getJSON("/tweets/_search", { query: {query_string: {query: "redis"} } } ,function(data) { console.log(data); })
```

With `.done`:

```js
$.getJSON( "/tweets/_search", { query: { query_string: { query: "redis"} } } )
  .done(function(data) {
    console.log(data);
  })
  .fail(function( jqxhr, textStatus, error ) {
    var err = textStatus + ", " + error;
    console.log( "Request Failed: " + err );
  });
```
