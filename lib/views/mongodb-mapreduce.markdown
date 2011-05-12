#### {% title "MapReduce" %}

<blockquote>
 {%= image_tag "/images/speed.jpg", :alt => "[Speed]" %}
</blockquote>

Na początek kilka ilustracji. Oto jak
Ketrina Yim, Sally Ahn, Dan Garcia. „Computer Science Illustrated”
rozrysowały ideę mapreduce:

* [An Example: Distributed Word Count](http://csillustrated.berkeley.edu/PDFs/mapreduce-example.pdf)
* [Parallelism and Functional Programming](http://csillustrated.berkeley.edu/PDFs/mapreduce.pdf)
* [The wordcount in Code](http://csillustrated.berkeley.edu/PDFs/mapreduce-code.pdf)

Podstawowa dokumentacja:

* [MapReduce](http://www.mongodb.org/display/DOCS/MapReduce)
* [Troubleshooting MapReduce](http://www.mongodb.org/display/DOCS/Troubleshooting+MapReduce)
* [A Look At MongoDB 1.8's MapReduce Changes](http://blog.evilmonkeylabs.com/2011/01/27/MongoDB-1_8-MapReduce/)
* Źródła MongoDB: [mr1](https://github.com/mongodb/mongo/blob/master/jstests/mr1.js),
  [mr2](https://github.com/mongodb/mongo/blob/master/jstests/mr2.js)

Przykłady z internetu:

* K. Banker. [A Cookbook for MongoDB](http://cookbook.mongodb.org/index.html) –
  kilka przykładów z MapReduce
* [Yet another MongoDB Map Reduce tutorial](http://www.mongovue.com/2010/11/03/yet-another-mongodb-map-reduce-tutorial/) –
  fajne ilustracje
* [Malware, MongoDB and Map/Reduce : A New Analyst Approach](http://blog.9bplus.com/malware-mongodb-and-mapreduce-a-new-analyst-a)

## Zaczynamy

Pierwszy przykład:

    :::javascript
    db.mr.drop();

    db.mr.insert({_id: 1, tags: ['ą', 'ć', 'ę']});
    db.mr.insert({_id: 2, tags: ['']});
    db.mr.insert({_id: 3, tags: []});
    db.mr.insert({_id: 4, tags: ['ć', 'ę', 'ł']});
    db.mr.insert({_id: 5, tags: ['ą', 'a']});

    m = function() {
      this.tags.forEach(function(tag) {
        emit(tag, {count: 1});
      });
    };

    r = function(key, values) {
      var total = 0;
      values.forEach(function(value) {
        total += value.count;
      });
      return {count: total};
    };

    res = db.mr.mapReduce(m, r, {out: "mr.tc"});

    printjson(res);
    print("==>> To display results run: db.mr.tc.find()");
