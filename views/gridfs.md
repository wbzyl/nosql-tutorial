#### {% title "GridFS 101" %}

Duże i bardzo duże pliki czasami zapisujemy w MongoDB
korzystając z mechanizmu GridFS.

Jak zapisywać plik w bazie, wypisywać listę plików
oraz wyciągać plik wcześniej zapisany za pomocą mechanizmu GridFS?

Najprościej jest skorzystać z programu *mongofiles*.
Poniższe polecenia wykonujemy na konsoli:

    :::bash
    echo "hello GridFS" > hello.txt
    mongofiles put hello.txt
    rm hello.txt

    mongofiles list
    mongofiles get hello.txt

    cat hello.txt

    mongofiles delete hello.txt
    mongofiles list
