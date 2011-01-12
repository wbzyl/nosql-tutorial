#### {% title "Datamapper" %}

# Datamapper: dm-couchdb, …


## Instalacja

Instalujemy następujące gemy:

    sudo gem install dm-core dm-more
    sudo gem install do_sqlite3 do_postgres
    sudo gem install dm-validations dm-timestamps 
    sudo gem install dm-aggregates dm-types 

oraz trochę wtyczek. Wszystkie są 
[opisane tutaj](http://datamapper.org/doku.php?id=docs:more).


## Zestawianie połączenia z bazą SQL

SQLite

    :::ruby
    # baza danych w RAM
    DataMapper.setup(:default, 'sqlite3::memory:')
    # baza danych plikiem
    DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/test.sqlite")

PostgreSQL

    :::ruby
    # Postgres 8.2+
    DataMapper.setup(:default, 'postgres://localhost/test')

**Uwaga**: You may be wondering how to be more specific about your database
connection. The second argument can be a hash, containing :host,
:adapter, :database, :username, :password, :socket, etc. These are
database-specific but this ought to get you going.


## Zestawianie połączenia z bazą noSQL

TODO
