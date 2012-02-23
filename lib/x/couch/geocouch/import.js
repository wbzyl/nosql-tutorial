// Author: D. Thompson
// Source: https://github.com/dthompson/example_geocouch_data/blob/master/flickr_data/import.js

var cradle = require("cradle")
, util = require("util")
, fs = require("fs");

// first create 'tatry' database (for example, in the Futon)

var connection = new(cradle.Connection)("localhost", 5984);
var db = connection.database('tatry');

var couchimport = function(filename) {
  var data = fs.readFileSync(filename, "utf-8");
  var flickr = JSON.parse(data);

  var counter = 0;

  for (var p in flickr.photos.photo) {
    photo = flickr.photos.photo[p];

    var longitude = photo.longitude;
    var latitude  = photo.latitude;

    if (longitude && latitude && longitude != 0 && latitude != 0) {
      // console.log("[lng, lat] = ", photo.longitude, photo.latitude)

      photo.geometry = {"type": "Point", "coordinates": [longitude, latitude]};

      // save the url to the flickr image: s – small, m – medium, b – big
      // http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
      photo.image_url_medium = "http://farm"+photo.farm+".static.flickr.com/"+photo.server+"/"+photo.id+"_"+photo.secret+"_m.jpg";

      counter++;

      db.save(photo.id, photo, function(er, ok) {
        if (er) {
          util.puts("Error: " + er);
          return;
        }
      });
    }
  }
  return counter;
};

var filenames =  ["flickr_search-01.json", "flickr_search-02.json", "flickr_search-03.json", "flickr_search-04.json"]

filenames.forEach(function (name) {
  var n = couchimport(name);
  console.log("imported data from:", name, "(#" + n + ")");
});
