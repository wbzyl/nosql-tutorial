#### {% title "Ściąga z API" %}

* [HTTP_view_API, Quering Options](http://wiki.apache.org/couchdb/HTTP_view_API#Querying_Options)
* [CouchDB API Overview](http://localhost:5984/_utils/docs/api-basics.html#couchdb-api-overview)

CouchDB Manual:

* 18.4. [Document Methods](http://localhost:5984/_utils/docs/api/documents.html#api-doc)
* 18.5. [Design Document Methods](localhost:5984/_utils/docs/api/design.html)


## Show

Odpytywanie funkcji show (*querying show functions*):

    GET /db/_design/mydesign/_show/myshow/72d43a93eb74b5f2

albo, bez *id* dokumentu:

    GET /db/_design/mydesign/_show/myshow

wtedy `doc == null`.

Odpytywanie z *query parameters*:

    GET /db/_design/mydesign/_show/myshow?parrot=Captain

wtedy obiekt `req.query` zawiera *query parameters*:

    :::js
    req.query.parrot //=> Captain

Przykładowa funkcja *show*:

    :::js
    function(doc, req) {
      return {
        body : '<h1>' + doc.title + '</h1>',
        headers : {
          "Content-Type" : "application/html",
          "X-My-Own-Header": "you can set your own headers"
        }
      }
    }
