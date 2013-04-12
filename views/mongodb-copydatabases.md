#### {% title "Kopiowanie baz danych" %}

<blockquote>
<p>{%= image_tag "/images/copy-database-icon.png", :alt => "copy database" %}</p>
</blockquote>

Dokumentacja:

* [Copy Database Commands](http://www.mongodb.org/display/DOCS/Copy+Database+Commands)

Powłoka *mongo* zawiera dwa polecenia do kopiowania baz danych z jednego
serwera na drugi: *copyDatabase* oraz *cloneDatabase*.
(Ale brak polecenia do kopiowania kolekcji.)

Druga metoda jest łatwiejsza w użyciu. Przykładowo:

    :::js
    use books
    db.cloneDatabase("tao.inf.ug.edu.pl")
      { "ok" : 1 }
    db.dostojewski.count()
      4662

kopiuje bazę *books* z podanego serwera.

Do kopiowania kolekcji można użyć potoku utworzonego z programów
*mongoexport* (pobierz) i *mongoimport* (zapisz).

<!--
Oczywiście przed kopiowaniem należy uruchomić MongoDB na Tao:

    :::bash
    sudo systemctl start mongod.service
    sudo systemctl status mongod.service

Zob. Fedora 15 [SysVinit to Systemd Cheatsheet](http://fedoraproject.org/wiki/SysVinit_to_Systemd_Cheatsheet).
-->
