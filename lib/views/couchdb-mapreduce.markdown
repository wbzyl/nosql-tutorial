#### {% title "Map ⇒ Reduce → Rereduce" %}


## Design documents & MapReduce

W bazie zapiszemy dokumenty z info o fotografiach:

    :::json pictures.json
    [
      {"_id":"1","name":"fish.jpg","created_at":"Fri, 31 Dec 2010 14:50:03 GMT",
       "user":"bob","type":"jpeg","camera":"nikon",
       "info":{"width":100,"height":200,"size":12345},"tags":["tuna","shark"]},
      {"_id":"2","name":"trees.jpg","created_at":"Fri, 31 Dec 2010 14:46:47 GMT",
       "user":"john","type":"jpeg","camera":"canon",
       "info":{"width":30,"height":250,"size":32091},"tags":["oak"]},
      {"_id":"3","name":"snow.png","created_at":"Fri, 31 Dec 2010 14:59:13 GMT",
       "user":"john","type":"png","camera":"canon",
       "info":{"width":64,"height":64,"size":1253},"tags":["tahoe","powder"]},
      {"_id":"4","name":"hawaii.png","created_at":"Fri, 31 Dec 2010 15:05:49 GMT",
       "user":"john","type":"png","camera":"nikon",
       "info":{"width":128,"height":64,"size":92834},"tags":["maui","tuna"]},
      {"_id":"5","name":"hawaii.gif","created_at":"Fri, 31 Dec 2010 15:09:55 GMT",
       "user":"bob","type":"gif","camera":"canon",
       "info":{"width":320,"height":128,"size":49287},"tags":["maui"]},
      {"_id":"6","name":"island.gif","created_at":"Fri, 31 Dec 2010 14:58:35 GMT",
       "user":"zztop","type":"gif","camera":"nikon",
       "info":{"width":640,"height":480,"size":50398},"tags":["maui"]}
    ]

Skrypt zapisujący dokumenty w bazie. Dokumenty zapisujemy hurtem:


Przykłady Map & Reduce:

    :::javascript
    function(doc) {
      emit(doc.user, 1);
    }
    function(keys, values, rereduce) {
      log(keys);
      log(values);
      sum(values);
    }

Unique cameras per user:

    :::javascript
    function(doc) {
      emit([doc.user, doc.camera], 1);
    }
    function(keys, values, rereduce) {
      sum(values);
    }
