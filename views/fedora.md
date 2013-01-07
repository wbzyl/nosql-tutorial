#### {% title "Fedora 16+" %}

Tworzenie własnych paczek RPM dla MongoDB, CouchDB, Redis, ElasticSearch, PostgreSQL.

Hugo Lindgren,
[Be Wrong as Fast as You Can](http://www.nytimes.com/2013/01/06/magazine/be-wrong-as-fast-as-you-can.html):

**Ideas, in a sense, are overrated.** Of course, you need good ones, but
at this point in our supersaturated culture, precious few are so novel
that nobody else has ever thought of them before.
**It’s really about where you take the idea, and how committed you are
to solving the endless problems that come up in the execution.**

RPM info:

* [Working with Spec Files](http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch-specfiles.html)
* [Built-in macros](http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch09s07.html)

Tworzymy katalogi dla programu *rpmbuild*:

    :::bash
    rpmdev-setuptree

Czasami warto wkleić tę linijkę do pliku SPEC na końcu sekcji *%install*:

    :::bash
    rm -rf $RPM_BUILD_ROOT/usr/include/mongo

Użyteczne polecenia:

    :::bash
    rpm --eval '%configure'
    rpm --eval '%makeinstall'


## MongoDB

Klonujemy repozytorium z MongoDB:

    :::bash
    git://github.com/mongodb/mongo.git

Przechodzimy do katalogu *mongo* i wykonujemy polecenie:

    :::bash
    cd mongo
    git archive --format=tar --prefix=mongo-2.3.2/ be56edc259 | gzip > ~/rpmbuild/SOURCES/mongo-2.3.2.tar.gz

gdzie `be56edc259` to (ostatni) commit z 6.01.2013.

**TODO:** skąd pobrać mongo-2.3.2.spec?

Przechodzimy do katalogu `~/rpmbuild/SPECS/` gdzie wykonujemy polecenia:

    :::bash
    rpmbuild -bi mongo-2.3.2.spec
    rpmbuild -bl mongo-2.3.2.spec

Jeśli wszystko jest OK, to budujemy pakiet SRC:

    :::bash
    rpmbuild -bs mongo-2.3.2.spec

Budujemy pakiet RPM korzystając z programu *mock* (ok. 1h):

    :::bash
    sudo usermod -a -G mock wbzyl # dodajemy siebie do grupy mock
    mock -r fedora-16-x86_64 --resultdir ../RPMS/ mongo-2.3.2-2.fc16.src.rpm

albo budujemy pakiet RPM bezpośrednio:

    :::bash
    rpmbuild --rebuild mongo-2.3.2-2.fc16.src.rpm

Instalujemy / uaktualniamy MongoDB za pomocą programu *yum*:

    :::bash
    cd RPMS/x86_64/
    yum update mongo-2.3.3-2.fc16.x86_64.rpm mongo-server-2.3.2-2.fc16.x86_64.rpm


## CouchDB

* [couchdb-rpm](https://github.com/wendall911/couchdb-rpm) (v1.2.1)
* [fedora git](http://pkgs.fedoraproject.org/cgit/couchdb.git/) (v1.2.0)


## ElasticSearch

[Elasticsearch RPMs](https://github.com/tavisto/elasticsearch-rpms) –
an easy way to install elasticsearch on fedora/rhel based systems.


## PostgreSQL

TODO.
