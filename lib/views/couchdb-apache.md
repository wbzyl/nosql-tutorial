#### {% title " CouchDB – Apache" %}

Domyślnie wszystkie zapytania do bazy CouchDB są postaci:

    http://127.0.0.1:5984/

Zamienimy ten domyślny URL na:

    http://couch.local/

W tym celu wystarczy <em>odpowiednio</em> skonfigurować serwer
Apache, plik *couch.conf*:

    :::apache
    <VirtualHost *:80>
       DocumentRoot "/var/www"  # cokolwiek
       ServerName couch.local   # też cokolwiek
       AllowEncodedSlashes On
       ProxyRequests Off
       KeepAlive Off
       <Proxy *>
          Order allow,deny
          Allow from all
       </Proxy>
       ProxyPass / http://localhost:5984/ nocanon
       ProxyPassReverse / http://localhost:5984/
    </VirtualHost>

Fedora: Pozostaje jeszcze w pliku */etc/hosts* dopisać wiersz:

    127.0.0.1   couch.local

Taką konfigurację określamy jako „reverse proxy”, ponieważ
konfiguracja jest po stronie serwera www.

Jeśli powyższa konfiguracja nie zadziała, to sprawdzamy w jego pliku
konfiguracyjnym czy Apache korzysta z modułów *proxy*.


## Połączenie HTTPS

Ponieważ CouchDB używa HTTP Basic Authentication, hasła są
kodowane za pomocą Base64, jeśli z niego korzystamy,
to powinniśmy użyć szyfrowanego połączenia.

Wyłączamy SSL w istniejącej konfiguracji *ssl.conf*:

    :::apache
    <VirtualHost _default_:443>
    ...
    #   SSL Engine Switch:
    #   Enable/Disable SSL for this virtual host.
    #SSLEngine on
    ...

I edytujemy plik *couch.conf*:

    :::apache
    NameVirtualHost *:443
    <VirtualHost *:443>
       SSLEngine on
       SSLCertificateFile /etc/pki/tls/certs/couch.crt
       SSLCertificateKeyFile /etc/pki/tls/private/couch.key

Wyjaśnić dlaczego takie zmiany?

### Certyfikaty i klucze

Generujemy klucz i certyfikat:

    openssl req -new -x509 -days 365 -sha1 -newkey rsa:1024 -nodes \
      -keyout couch.key -out couch.crt \
      -subj '/O=Company/OU=Department/CN=couch.local'

i kopiujemy wygenerowany klucz i certyfikat do odpowiednich katalogów
(jakich? takich jak podano w konfiguracji).
