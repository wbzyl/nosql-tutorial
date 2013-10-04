#### {% title "GridFS 101" %}

Duże i szczególnie bardzo duże pliki możemy zapisać
w MongoDB korzystając z mechanizmu GridFS.

Jak zapisywać wplik, wypisywać listę plików
oraz wyciągać plik zapisany wcześniej w GridFS?
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
