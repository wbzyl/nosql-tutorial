#### {% title "Security 101" %}

Po zalogowaniu z *localhost* do Mongo chcemy mieć uprawnienia administratora,
a po zalogowaniu z innych komputerów chcemy mieć prawa do czytania kolekcji
w bazie *test*.

Jak to zrobić?

Zaczynamy od dopisania opcji *--auth* do wywołania serwera *mongod*.
(Jeśli korzystamy z Fedory, to dopisujemy tę opcję do pliku
*/etc/sysconfig/mongod*).

Następnie logujemy się za pomocą programu *mongo* do bazy z *localhost*.
Po zalogowaniu [wykonujemy](http://docs.mongodb.org/manual/reference/security/):

    :::bash
    use test
    db.addUser({user: "student", pwd: "pass", roles: ["read"]})

    db.system.users.find()
    {
      "_id": ObjectId("524d2ffc01bbc634206e43e6"),
      "user": "student",
      "pwd": "a009ae3fc42b5a3311d464e7da5a31e3",
      "roles": [
        "read"
      ]
    }

Na koniec restartujemy demona *mongod*. I już!

Teraz zdalnie logujemy się do bazy tak:

    :::bash
    mongo --quiet -u student -p pass 153.19.7.108:27017/test

albo tak:

    :::bash
    mongo 153.19.7.108:27017/test

i w powłoce wpisujemy:

    :::js
    db.auth({user: "student", pwd: "pass"})

Dlaczego taka autentykacja+autoryzacja działa tak jak to opisano
w pierwszym akapicie? Ponieważ korzystamy z tzw.
[localhost-exception](http://docs.mongodb.org/manual/tutorial/add-user-administrator/#localhost-exception).
