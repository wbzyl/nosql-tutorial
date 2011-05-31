#### {% title "Kopiowanie baz danych" %}

Dokumentacja:

* [Copy Database Commands](http://www.mongodb.org/display/DOCS/Copy+Database+Commands)

Powłoka *mongo* zawiera dwa polecenia do kopiowania baz danych z jednego
serwera na drugi: *copyDatabase* oraz *cloneDatabase*.

Druga metoda jest łatwiejsza w użyciu; na przykład:

    use books
    db.cloneDatabase("tao.inf.ug.edu.pl")
      { "ok" : 1 }
    db.dostojewski.count()
      4662

kopiuje bazę *books* z podanego serwera.

Oczywiście przed kopiowaniem należy uruchomić MongoDB na Tao (*Fedora 15*):

    sudo systemctl start mongod.service
    sudo systemctl status mongod.service


## Jak to działa w Ruby?

Potrzebujemy drivera:

    gem install mongo mongo_ext

**TODO**
