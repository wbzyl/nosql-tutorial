#### {% title "Kopiowanie baz danych i kolekcji" %}

<blockquote>
<p>{%= image_tag "/images/copy-database-icon.png", :alt => "copy database" %}</p>
</blockquote>

Dokumentacja:

* [Copy Databases Between Instances](http://docs.mongodb.org/manual/tutorial/copy-databases-between-instances/)
* [cloneCollection](http://docs.mongodb.org/master/reference/command/cloneCollection/)

### Kopiowanie bazy danych

Powłoka *mongo* zawiera dwa polecenia do kopiowania baz danych z jednego
serwera na drugi: *copyDatabase* oraz *cloneDatabase*.

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


### Kopiowanie kolekcji

Ale tylko między różnymi bazami danych i do bieżącej instacji *mongod*.
Na przykład (od wersji 2.4.6, sprawdzić):

    :::js
    db.cloneCollection("<hostname>", "<collection>", { <query> })


<!--
Oczywiście przed kopiowaniem należy uruchomić MongoDB na Tao:

    :::bash
    sudo systemctl start mongod.service
    sudo systemctl status mongod.service

Zob. Fedora 15 [SysVinit to Systemd Cheatsheet](http://fedoraproject.org/wiki/SysVinit_to_Systemd_Cheatsheet).
-->
