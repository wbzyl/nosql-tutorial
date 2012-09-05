#### {% title "Serializacja danych" %}

# Serializacja danych

Po kolei: Marshal, PStore, CSV, YAML


## Marshall

TODO


## PStore datastore

Ruby comes with a simple hash based key-value store called *PStore*.
If you’ve never used it, it’s definitely worth learning. For simple
data storage, PStore can be very useful.

[PStore] [pstore] implements a file based persistance mechanism based
on a Hash. User code can store hierarchies of Ruby objects (values)
into the data store file by name (keys). An object hierarchy may be
just a single object.


## YAML

Sesja irb:

    :::ruby
    hash = { :one => 1, :two => 2, :colors => ["red", "green", "blue"] }
    require 'yaml'
    puts hash.to_yaml
    y_hash = hash.to_yaml
    new_hash = YAML.load(y_hash)
    new_hash == hash  #=> true

<b>You need a way</b> to automate the storage and retrieval of professional
and personal contacts (an address book), but you want it to be in
plain text so that you can edit the entries in a text editor as well
as alter them <i>programmatically</i>.


## Proste bazy danych

You want a simple contact manager, and you need to share the files
with someone who may not have access to YAML.

### Rozwiązanie

Our hypothetical YAML crisis provides a chance to look at a gdbm-based
solution. We'll aim for something that's as close as possible to
the YAML version of the contact manager, and the best way to guarantee
that closeness is to use a similar test suite.


## Stone: Dead-Simple Data Persistence

To może być ciekawe [Dead-Simple Data Persistence] [stone].

For small applications, a database can be overkill for storing your
data in a consistent and organized manner. Therefore, Stone was built
to provide plug-and-play data persistence for any application or
framework. It is fast, and it is easy… therefore it is good.

Instalacja:

    sudo gem install stone

Czy to będzie działać z Sinatrą? Przykład: Fortunka?


#### Linki

[stone]: http://stone.rubyforge.org/ "Dead-Simple Data Persistence"
[pstore]: http://www.ruby-doc.org/stdlib/libdoc/pstore/rdoc/classes/PStore.html "PStore"
