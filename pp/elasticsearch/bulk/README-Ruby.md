# Bulk Opertions Examples in Ruby

* [UDPSocket](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/socket/rdoc/UDPSocket.html)
* Karel Minarik, [Tire](https://github.com/karmi/tire) gem
* Russs Olsen, *Design Patterns in Ruby*, Addison-Wesley 2008


The Elasticsearch REST API expects the following JSON structure:

```json
{ "index" : { "_index" : "db", "_type" : "collection", "_id" : "id" } }
```
Depending on the usage some fields are optional.


## Mapping

**TODO**


# Implementacja: Template Pattern

TODO


# Implementacja: Strategy Pattern

TODO


## Bulk UDP

Konfiguracja, */etc/elasticsearch/elasticsearch.yml*:

```
bulk.udp.enabled: true
```

Use the *szymborska.bulk* file:

```json
{ "index": { "_index": "ideas", "_type": "szymborska", "_id": 1 } }
{ "quote": "Tyle wiemy o sobie, ile nas sprawdzono.", "tags": ["idea", "lechery"] }
{ "index": { "_index": "ideas", "_type": "szymborska", "_id": 2 } }
{ "quote": "Kto patrzy z góry, ten najłatwiej się myli.", "tags": ["above", "mistake"] }
{ "index": { "_index": "ideas", "_type": "szymborska", "_id": 3 } }
{ "quote": "Żyjemy dłużej, ale mniej dokładnie i krótszymi zdaniami.", "tags": ["life"] }
{ "index": { "_index": "ideas", "_type": "szymborska", "_id": 4 } }
{ "quote": "Cud pierwszy lepszy: krowy są krowami.", "tags": ["miracle", "cow"] }
```

Index data (use the *netcat* utility):

```sh
cat szymborska.bulk | nc -w 0 -u localhost 9700
```

Opcje: *-w* – timeout, *-u* – use UDP.


## Index

First, delete the *ideas* index:

```sh
curl -s -XDELETE localhost:9200/ideas ; echo # add newline
# {"error":"IndexMissingException[[ideas] missing]","status":404}
```
Now add data to *ideas* index:

```sh
curl -s -XPOST localhost:9200/ideas/_bulk --data-binary @lec.bulk ; echo
curl -s -XPOST localhost:9200/ideas/_bulk --data-binary @steinhaus.bulk ; echo
# {
#   "took":168,
#   "items":[
#     {"index":{"_index":"ideas","_type":"lec","_id":"1","_version":1,"ok":true}},
#     ...
#   ]
# }
# {
#   "took":7,
#   "items":[
#     {"create":{"_index":"ideas","_type":"steinhaus","_id":"l8KcOn4PTfS4u9c51Aaeqg","_version":1,"ok":true}},
#     ...
#   ]
# }
```

## Delete

Use the *delete-lec-ideas.bulk* file:

```json
{ "delete" : { "_index" : "ideas", "_type" : "lec", "_id" : "1" } }
{ "delete" : { "_index" : "ideas", "_type" : "lec", "_id" : "2" } }
```

Delete both documents:

```sh
curl -s -XPOST localhost:9200/_bulk --data-binary @delete-lec-ideas.bulk ; echo
# {
#   "took":1,
#   "items":[
#     {"delete":{"_index":"ideas","_type":"lec","_id":"1","_version":2,"ok":true}},
#     {"delete":{"_index":"ideas","_type":"lec","_id":"2","_version":2,"ok":true}}
#   ]
# }
```

## Create or ‘put-if-absent’

Use the *create-ideas.bulk* file:

```json
{ "create": { "_index": "ideas", "_type": "lec", "_id": 1 } }
{ "quote": "Czas robi swoje. A ty człowieku?", "tags": ["man", "time"] }
{ "create": { "_index": "ideas", "_type": "lec", "_id": 4 } }
{ "quote": "Bądź realistą: nie mów prawdy.", "tags": ["idea", "truth"] }
```

Create ideas:

```sh
curl -s -XPOST localhost:9200/_bulk --data-binary @create-ideas.bulk ; echo
{
  "took":5,
  "items":[
    {"create":{"_index":"ideas","_type":"lec","_id":"1","_version":1,"ok":true}},
    {"create":{"_index":"ideas","_type":"lec","_id":"4",
     "error":"DocumentAlreadyExistsException[[ideas][0] [lec][4]: document already exists]"}}
  ]
}
```
