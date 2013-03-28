# GeoIP Lite databases & MongoDB

GeoIP:

* [GeoLite Free Downloadable Databases](http://dev.maxmind.com/geoip/geolite)
* [geoip](https://github.com/cjheath/geoip) – gem for ruby
* [GeoIP-lite](https://github.com/bluesmoon/node-geoip) – node module
  ([npm registry](https://npmjs.org/package/geoip-lite))
* [oj](http://rubydoc.info/github/ohler55/oj/file/README.md) – optimized json

MongoDB:

* [The Ruby Driver Documentation](http://api.mongodb.org/ruby/current/)
* [The Node.JS MongoDB Driver Manual](http://mongodb.github.com/node-mongodb-native/)

Instalujemy gemy:

    gem install geoip
    gem install mongo
    gem install bson_ext
    gem install oj

Moduły dla node instalujemy lokalnie:

    npm install geoip-lite-with-city-data
    npm install mongodb


## Ruby

Use country database:

```ruby
require 'geoip'

c = GeoIP.new('GeoIP.dat').country('inf.ug.edu.pl')
c.ip            # 153.19.7.228
c.country_name  # Poland

c = GeoIP.new('GeoIP.dat').country('153.19.7.228')
c.country_name  # Poland
```

Use city database:

```ruby
require 'geoip'

c = GeoIP.new('GeoLiteCity.dat').city('inf.ug.edu.pl')
# #<struct GeoIP::City request="inf.ug.edu.pl", ip="153.19.7.228",
#   country_code2="PL", country_code3="POL", country_name="Poland",
#   continent_code="EU", region_name="82", city_name="Gdansk", postal_code="",
#   latitude=54.36080000000001, longitude=18.658299999999997,
#   dma_code=nil, area_code=nil,
#   timezone="Europe/Warsaw">
c.city_name # Gdansk
c.latitude  # 54.36080  szerokość
c.longitude # 18.65829  długość
```

## Node.js

GeoIP Lite with city data:

```js
var geoip = require('geoip-lite-with-city-data');
var ip = '153.19.7.228';
var geo = geoip.lookup(ip);
console.log(geo);
  { range: [ 2568159232, 2568183295 ],
    country: 'PL',
    region: '82',
    city: 'Gdansk',
    ll: [ 54.35, 18.6667 ] } // [<latitude>, <longitude>]
```


## Misc

* [Aggregation Framework Examples](http://docs.mongodb.org/manual/tutorial/aggregation-examples/);
  [the Zip Code Data Set](http://media.mongodb.org/zips.json)
  plik zwiera JSONY z powtórzonym **_id**;

W bazie dokumenty zapisujemy korzystając z tego skryptu:

```sh
./json2mongo -c zipcodes --drop data/zips.json
```

Po wykonaniu tego polecenia, kolekcja *zips* składa się z 29467
dokumentów.

Możemy zaimportować dane korzystając z programu *mongoimport*.
Program raportuje ze zostało zaimportowanych
29470 dokumentów. Ale w kolekcji jest 29467 dokumentów.


## Tao

Do zapisania w MongoDB logów Nginx z Tao użyjemy tego skryptu:

```sh
tao2mongo -c tao < data/tao.json.log
```

Przykładowy JSON generowany przez Nginx:

```json
{
  "timestamp": "2013-01-13T20:26:23+01:00",
  "fields": {
     "remote_addr": "81.190.49.213",
     "remote_user": "-",
     "body_bytes_sent": "0",
     "request_time": "0.000",
     "status": "304", "request":
     "GET /css/style.css?v=2 HTTP/1.1",
     "request_method": "GET",
     "http_referrer": "http://tao.inf.ug.edu.pl/",
     "http_user_agent": "Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0"
  }
}
```

Do MongoDB chcemy zapisać „spłaszczony” dokument z dodatkowymi
polami pobranymi z bazy GeoIP:

```json
{
  "timestamp": "2013-01-13T20:26:23+01:00",
  "time" : [23, 26, 19, 13, 1, 2013, 0, 13, false, "UTC"],

  "remote_addr": "81.190.49.213",
  "remote_user": "-",
  "body_bytes_sent": "0",
  "request_time": "0.000",
  "status": "304",
  "request": "GET /css/style.css?v=2 HTTP/1.1",
  "request_method": "GET",
  "http_referrer": "http://tao.inf.ug.edu.pl/",
  "http_user_agent": "Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0",

  "city_name": "Gdansk",
  "ll": [ 54.36080000000001, 18.658299999999997],
  "country_name": "Poland",
  "country_code2": "pl",
  "continent_code": "eu"
}
```

Przykładowa agregacja na konsoli *mongo*:

```js
db.tao.aggregate(
  { $group: {_id: "$country", total: {$sum: 1}} },
  { $sort : {total: 1} }
);
  ...
  {
     "_id" : "China",
     "total" : 1813
  },
  {
     "_id" : "United States",
     "total" : 9717
  },
  {
    "_id" : "Poland",
    "total" : 106646
  }
```

Zob. [Aggregation Framework Reference](http://docs.mongodb.org/manual/reference/aggregation/)


## Ruby *Time* Cheatsheet

Ściąga z *Time* dla Ruby:

```ruby
require 'time'

timestamp =               "2013-01-13T20:26:23+01:00"
o = Time.parse timestamp # 2013-01-13 20:26:23 +0100
u = o.utc                # 2013-01-13 19:26:23 UTC

o.utc? # false
o.to_i # 1358105183 – miliseconds from Epoch
o.to_a # [23, 26, 20, 13, 1, 2013, 0, 13, false, "CET"]

u.utc? # true
u.to_i # 1358105183
u.to_a # [23, 26, 19, 13, 1, 2013, 0, 13, false, "UTC"]

u.strftime "%F"    # "2013-01-13"
u.strftime "%Y-%j" # "2013-013"
u.strftime "%T"    # "19:26:23"
```

## Ruby Mongo Driver Cheatsheet

przykładowe polecenia:

```ruby
require "mongo"
include Mongo

db = MongoClient.new("localhost", 27017, w: 1, wtimeout: 200, j: true).db("test")
db.collection_names

coll = db.collection "zipcodes"
coll.find_one

require "time"

coll = db.collection "animals"
coll.insert name: "Figa", dob: Time.parse("1992-07-01")
coll.insert name: "Bazylek", dob: Time.parse("2005-06-24")
```

Lazy evaluation (lazy enumerators):

```ruby
# lazy fetch
coll.find.each { |row| puts row.inspect }
# lazy fetch in batches
coll.find.each_slice(10) do |slice|
  puts slice.inspect
end
```

Dalsze przykłady:

```ruby
doc = coll.find_one name: /^B.zyl/
doc.class # BSON::OrderedHash

#    cursor
coll.find.sort name: :desc
coll.count

coll.find( name: /^B.zyl/ ).to_a
coll.find( dob: {"$gt" => Time.parse("2000-01-01")} ).to_a

# update
id = coll.insert name: "Burek", dob: Time.now
id.class # BSON::ObjectId
puts coll.find( _id: id ).to_a

coll.update( { _id: id }, { "$set" => {name: "Burasek"} } )
#=> {"updatedExisting"=>true, "n"=>1, "connectionId"=>351, "err"=>nil, "ok"=>1.0}

# remove
coll remove _id: id
#=> {"n"=>1, "connectionId"=>351, "err"=>nil, "ok"=>1.0}

# remove ALL DOCUMENTS
coll.remove
#=> {"n"=>3, "connectionId"=>351, "err"=>nil, "ok"=>1.0}
```

Importujemy dane:

```sh
mongoimport --drop -c imieniny --headerline --type csv data/imieniny.csv
```

Przekształcamy dane z takiego formatu

```json
{ "day"=>1, "month"=>1, "names"=>"Mieszka Mieczysława Marii"}
```

na taki format:

```json
{ "day"=>1, "month"=>1, "names"=> ["Mieszka", "Mieczysława", "Marii"] }
```

Robimy to w ten sposób:

```ruby
coll = db.collection "imieniny"
# ... wykonanie tego polecenia trwa około jednej minuty
coll.find({}, {snapshot: true}).each { |doc| doc["names"] = doc["names"].split(" "); coll.save(doc) }
coll.count    #=> 364
coll.find_one
{"_id"=>BSON::ObjectId('5154..'), "day"=>18, "month"=>1, "names"=>["Piotra", "Małgorzaty"]}
```

Proste indeksy:

```ruby
coll.create_index("names") #=> "names_1"
puts coll.find("names" => "Włodzimierza").to_a

coll.find("names" => "Włodzimierza").explain
{
  "cursor"=>"BtreeCursor names_1",
  "isMultiKey"=>true,
  "n"=>2,
  "nscannedObjects"=>2,
  "nscanned"=>2,
  "nscannedObjectsAllPlans"=>2,
  "nscannedAllPlans"=>2,
  ...
}
```

Dla pól bez indeksów:

```ruby
coll.find("day" => 1).explai
{
  "cursor"=>"BasicCursor",
  "isMultiKey"=>false, "n"=>11,
  "nscannedObjects"=>364,
  "nscanned"=>364,
  "nscannedObjectsAllPlans"=>364,
  "nscannedAllPlans"=>364,
  ...
}
```
