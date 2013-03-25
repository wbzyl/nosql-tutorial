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
c = GeoIP.new('GeoLiteCity.dat').city('inf.ug.edu.pl')
c.city_name # Gdansk
c.latitude  # 54.36080  szerokość
c.longitude # 18.65829  długość
```

# Node.js


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
