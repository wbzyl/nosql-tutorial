#### {% title "Fedora 16" %}

Instalacja MongoDB, CouchDB, Redis, ElasticSearch, PostgreSQL.

* [Working with Spec Files](http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch-specfiles.html)
* [Built-in macros](http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch09s07.html)

## MongoDB

Tworzymy paczkę RPM.

Dodajemy siebie do grupy *mock*:

    :::bash
    sudo usermod -a -G mock wbzyl

Tworzymy katalogi dla programu *rpmbuild*:

    :::bash
    rpmdev-setuptree
    rpmbuild -bi SPECS/mongodb-2.1.1.spec
    rpmbuild -bl SPECS/mongodb-2.1.1.spec

Jeśli wszystko jest OK, to budujemy pakiet SRC:

    :::bash
    rpmbuild -bs SPECS/mongodb-2.1.1.spec

Budujemy pakiet RPM korzystając z programu *mock* (ok. 1h):

    :::bash
    mock -r fedora-16-x86_64 --resultdir ./RPMS/ SRPMS/mongo-2.1.1-2.fc16.src.rpm

albo budujemy RPM bezpośrednio:

    :::bash
    rpmbuild --rebuild SRPMS/mongo-2.1.1-2.fc16.src.rpm

Instalujemy / uaktualniamy za pomocą programu *yum*:

    :::bash
    cd RPMS/x86_64/
    yum update mongo-2.1.1-4.fc16.x86_64.rpm mongo-server-2.1.1-4.fc16.x86_64.rpm

Może się przydać też taka wskazówka: Dopisać
na końcu sekcji *%install* w pliku SPEC:

    :::bash
    rm -rf $RPM_BUILD_ROOT/usr/include/mongo

Użyteczne polecenia:

    :::bash
    rpm --eval '%configure'
    rpm --eval '%makeinstall'



## ElasticSearch

[Elasticsearch RPMs](https://github.com/tavisto/elasticsearch-rpms) –
an easy way to install elasticsearch on fedora/rhel based systems.
