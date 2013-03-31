# Bulk Opertions Examples

* [API / Bulk](http://www.elasticsearch.org/guide/reference/api/bulk/)
* [API / Bulk UDP](http://www.elasticsearch.org/guide/reference/api/bulk-udp/)

The Elasticsearch REST API expects the following JSON structure:

```json
{ "index" : { "_index" : "db", "_type" : "collection", "_id" : "id" } }
```
Depending on the usage some fields are optional.


## The sample data

Data source:
[Stanisław Jerzy Lec – Cytaty](http://cytaty.eu/autor/stanislawjerzylec.html).

Lec data, *lec.bulk*:

```json
{ "index": { "_type": "lec", "_id": 1 } }
{ "quote": "Mężczyźni wolą kobiety ładne niż mądre, ponieważ łatwiej im przychodzi patrzenie niż myślenie.", "tags": ["people", "women", "man"] }
{ "index": { "_type": "lec", "_id": 2 } }
{ "quote": "Podrzuć własne marzenia swoim wrogom, może zginą przy ich realizacji.", "tags": ["people", "dremas"] }
{ "index": { "_type": "lec", "_id": 3 } }
{ "quote": "By dojść do źródła, trzeba płynąć pod prąd.", "tags": ["idea"] }
{ "index": { "_type": "lec", "_id": 4 } }
{ "quote": "Chociaż krowie dasz kakao, nie wydoisz czekolady.", "tags": ["animal", "cow", "milk"] }
```

Steinhaus data, *steinhaus.bulk*:

```json
{ "index": { "_type" : "steinhaus" } }
{ "quote": "Idioci i geniusze są wolni od obowiązku rozumienia dowcipów.", "tags": ["people", "jokes", "man"] }
{ "index": { "_type" : "steinhaus" } }
{ "quote": "Unikaj skarżącego się na brak czasu, chce ci zabrać twój. ", "tags": ["people", "time"] }
{ "index": { "_type" : "steinhaus" } }
{ "quote": "Ludzie myślą, mówią i robią to, czego nie wolno robić, o czym nie wolno mówić ani myśleć.", "tags": ["people", "reflection"] }
{ "index": { "_type" : "steinhaus" } }
{ "quote": "Między duchem a materią pośredniczy matematyka.", "tags": ["matter", "spirit", "mathematics"] }
```


## Mapping

**TODO**


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

## Bulk UDP

> The idea is to provide a low latency UDP service
> that allows to easily index data
> that **is not of critical nature**.

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

(*-w* – timeout, *_u* – use UDP)
