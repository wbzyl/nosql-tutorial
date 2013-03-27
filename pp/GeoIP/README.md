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
  "status": "304", "request":
  "GET /css/style.css?v=2 HTTP/1.1",
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

## Ruby *Time* Cheatsheet

Ściąga z *Time* dla Ruby:

Przykład:

```ruby
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
