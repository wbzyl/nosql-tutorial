# Record store

TODO: Led Zeppelin


## Remarks

    {
        "name": "recordstore",        // the name of the app
        "load": "lib/app",            // the module to get design doc properties from
        "modules": "lib",             // files and directories to load as commonjs modules
        "templates": "templates",     // templates directory
        "attachments": "static"       // files and directories to load as attachments
    }

Change to:

        "name": "recordstore",        // the name of the design document _design/recordstore

Change:

    {
      "type": "album",
      "title": "Blue Lines",
      "artist": "Massive Attack",
      "cover": "http://userserve-ak.last.fm/serve/174s/47527219.png"
    },
    {
      "type": "album",
      "title": "Mezzanine",
      "artist": "Massive Attack",
      "cover": "http://userserve-ak.last.fm/serve/174s/38150483.png"
    },
    {
      "type": "album",
      "artist": "Underworld",
      "title": "Beaucoup Fish",
      "cover": "http://userserve-ak.last.fm/serve/174s/41665159.png"
    }

tak aby było można:

    curl -X POST -H "Content-Type: application/json" --data @albums.json http://127.0.0.1:4000/recordstore/_bulk_docs
