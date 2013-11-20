#### {% title "Przygotowywanie rpmów dla Fedory 16+" %}

<blockquote>
  {%= image_tag "/images/overrated-ideas.jpg", :alt => "[overrated ideas]" %}
  <p><b>Ideas, in a sense, are overrated.</b>
  Of course, you need good ones, but
  at this point in our supersaturated culture, precious few are so novel
  that nobody else has ever thought of them before.
  <b>It’s really about where you take the idea</b>, and how committed you are
  to solving the endless problems that come up in the execution.</p>
  <p class="author">– Hugo Lindgren,
  <a href="http://www.nytimes.com/2013/01/06/magazine/be-wrong-as-fast-as-you-can.html">Be Wrong as Fast as You Can</a></p>
</blockquote>

…na przykładzie programów MongoDB, CouchDB, ElasticSearch, Redis i PostgreSQL.

Podstawowe informacje o plikach *SPEC*:

* [Working with Spec Files](http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch-specfiles.html)
* [Built-in macros](http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch09s07.html)

Pakiety będziemy budować lokalnie. Składniki rpmów umieszczamy
w katalogach przeszukiwanych przez program *rpmbuild*:

    :::bash
    rpmdev-setuptree

Na koniec, kilka użytecznych poleceń:

    :::bash
    rpm --eval '%configure'
    rpm --eval '%makeinstall'

<!--
Czasami warto wkleić podobną linijkę do pliku SPEC na końcu sekcji *%install*:

    :::bash
    rm -rf $RPM_BUILD_ROOT/usr/include/mongodb
-->

## MongoDB

Klonujemy repozytorium z MongoDB:

    :::bash
    git clone git://github.com/mongodb/mongo.git

Przechodzimy do katalogu *mongo* i wykonujemy polecenie:

    :::bash
    cd mongo
    git archive --format=tar --prefix=mongodb-2.5.4/ r2.5.4 | gzip > ~/rpmbuild/SOURCES/mongodb-2.5.4.tar.gz

gdzie `c40533e` to (ostatni) commit z 10.03.2013.

Plik [mongodb-2.5.4.spec](https://raw.github.com/wbzyl/disasters/master/mongod/mongodb-2.5.4.spec)
zapisujemy w katalogu `~/rpmbuild/SPECS`.
Przechodzimy do tego katalogu, gdzie wykonujemy polecenie:

    :::bash
    rpmbuild -bi mongodb-2.5.4.spec

Jeśli powyższe polecenie kończy się komunikatem o niespakietowanych
plikach, dodajemy je do pliku *mongodb-2.5.4.spec* i sprawdzamy
czy wszystko jest OK:

    rpmbuild -bl mongodb-2.5.4.spec

Jeśli polecenie wykona się bez błędów, to budujemy pakiet SRC:

    :::bash
    rpmbuild -bs mongodb-2.5.4.spec

a następnie pakiety RPM:

    :::bash
    rpmbuild --rebuild mongodb-2.5.4-1.fc16.src.rpm

Paczkę instalujemy / uaktualniamy korzystając z programu *yum*:

    :::bash
    cd RPMS/x86_64/
    yum update mongodb-2.5.4-2.fc16.x86_64.rpm mongodb-server-2.5.4-1.fc16.x86_64.rpm

*Uwaga:* Pakiety RPM powinniśmy budować za pomocą programu *mock*:

    :::bash
    sudo usermod -a -G mock wbzyl # dodajemy siebie do grupy mock
    mock -r fedora-16-x86_64 --resultdir ../RPMS/ mongodb-2.5.4-1.fc16.src.rpm

Dlaczego?

Po instalacji, sprawdzamy jak skonfigurowane jest MongoDB na Fedorze.
W tym celu przeglądamy następujące pliki:

* {%= link_to "/etc/mongod.conf", "/fedora/f16/mongod.conf" %} –
 dopisałem *rest=true* oraz *nohttpinterface=false*
* {%= link_to "/etc/init.d/mongod", "/fedora/f16/mongod.sh" %}
* {%= link_to "/etc/sysconfig/mongod", "/fedora/f16/mongod-sysconfig.txt" %}
* {%= link_to "/etc/logrotate.d/mongodb", "/fedora/f16/mongod-logrotate.txt" %}

Status MongoDB sprawdzamy w taki sposób:

    systemctl status mongod.service


## ElasticSearch

Pobieramy gotowy RPM ze strony [Download | Elasticsearch](http://www.elasticsearch.org/download/).


## CouchDB

Postępujemy podobnie jak w przypadku MongoDB. Korzystamy
z gotowych łat przygotowanych przez W. Cada:

* [couchdb-rpm](https://github.com/wendall911/couchdb-rpm) (v1.2.1)

Oficjalne repo Fedory (Peter Lemenkov):

* [fedora git](http://pkgs.fedoraproject.org/cgit/couchdb.git/) (v1.2.0)

Pakiety wymagane w trakcie kompilacji programu ze źródeł:

    :::bash
    sudo yum install js js-devel
    sudo yum install autoconf autoconf-archive automake libtool \
      curl-devel \
      erlang-erts erlang-etap erlang-ibrowse erlang-mochiweb erlang-oauth erlang-os_mon \
      help2man libicu-devel perl-Test-Harness \
      erlang-crypto erlang-erts erlang-inets erlang-kernel \
      erlang-sasl erlang-stdlib erlang-tools

    sudo yum install python-pygments
    # sudo easy_install -U Pygments
    sudo yum install python-sphinx
    # sudo easy_install -U Sphinx

Niestety, w ten sposób zainstalujemy tylko wersję 1.2.1. A aktualna
wersja to 1.4.x. Dlatego program skompilujemy ze źrodeł.

Pobieramy repozytorium z kodem, kompilujemy i instalujemy system CouchDB:

    :::bash
    git clone
    cd couchdb
    ./bootstrap
    ./configure --prefix=$HOME/.couchdb --with-erlang=/usr/lib64/erlang/usr/include
    make
    make install

Teraz w odpowiednich katalogach zapisujemy te pliki:

* {%= link_to "/etc/init.d/couchdb", "/fedora/f16/couchdb-service.sh" %}
* {%= link_to "$HOME/.data/etc/couchdb/local.d/sigma.ini", "/fedora/f16/couchdb-sigma.ini" %}
* {%= link_to "/etc/logrotate.d/couchdb", "/fedora/f16/couchdb-logrotate.txt" %}

### CouchDB & Nginx

Wirtualny host:

    :::bash /etc/hosts
    127.0.0.1 localhost.localdomain localhost sinatra.local couch.local

Nginx:

    :::bash /etc/nginx/conf.d/wbzyl.conf
    server  {
      listen         80;
      server_name  couch.local;

      location / {
        proxy_pass http://localhost:5984;
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      }

      location ~ ^/(.*)/_changes {
        proxy_pass http://localhost:5984;
        proxy_redirect off;
        proxy_buffering off;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      }
  }

Teraz CouchDB jest dostępny pod takim URI:

    http://couch.local
