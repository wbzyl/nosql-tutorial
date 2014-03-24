## How to speed up MongoDB Map Reduce by 20x

Przykład z artykułu Antoine Girbal’a
[How to speed up MongoDB Map Reduce by 20x](http://edgystuff.tumblr.com/post/54709368492/how-to-speed-up-mongodb-map-reduce-by-20x).

```sh
time mongo create_uniques_collection.js
    MongoDB shell version: 2.6.0-rc2
    connecting to: test

    real	80m25.280s
    user	55m21.615s
    sys     4m33.078s
mongo
MongoDB shell version: 2.6.0-rc2
connecting to: test
Mongo-Hacker 0.0.4
localhost(mongod-2.6.0-rc2) test>

  db.uniques.ensureIndex({dim0: 1})  // takes a couple of minutes
    {
      "createdCollectionAutomatically": false,
      "numIndexesBefore": 1,
      "numIndexesAfter": 2,
      "ok": 1
    }
  db.uniques.stats()
    {
      "ns": "test.uniques",
      "count": 10000000,
      "size": 480000256,
      "avgObjSize": 48,
      "storageSize": 857440256,
      "numExtents": 17,
      "nindexes": 2,
      "lastExtentSize": 227803136,
      "paddingFactor": 1,
      "systemFlags": 1,
      "userFlags": 1,
      "totalIndexSize": 576056432,
      "indexSizes": {
        "_id_": 324472736,
        "dim0_1": 251583696
      },
      "ok": 1
    }

```

Counting unique values with MapReduce, *mr-without-sort.js*:

```js
m = function () {
  emit(this.dim0, 1);
};
r = function (key, values) {
  return Array.sum(values);
};
db.uniques.mapReduce(m, r, {out: "mrout"});
```
Running MR **without** sorting:

```sh
time mongo mr-without-sort.js
# ... from mongo log ...
  build index on: test.tmp.mr.uniques_0 properties: { v: 1, key: { _id: 1 }, name: "_id_", ns: "test.tmp.mr.uniques_0" }
      added index to empty collection
# ... takes forever ...
```

Running MR with sorting, *mr-sort.js*:

```sh
time mongo mr-sort.js

MongoDB shell version: 2.6.0-rc2
connecting to: test

real	20m17.176s
user	0m0.051s
sys	0m0.011s
```
Dopisujemy w opcjach *sort*:

```js
db.uniques.mapReduce(m, r, {sort: {dim0: 1}, out: "mrout"});
```
That’s a ∞/20.25 = ∞ times improvement!

Using multiple threads (takes a several seconds to complete):

```sh
time mongo mr-scoped.js

real	3m7.268s
user	0m0.253s
sys	0m0.037s
```
That’s a 20.25/3.1 ≈ 6.6 times improvement!
