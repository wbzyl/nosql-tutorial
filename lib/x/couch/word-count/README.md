# Word count example

## TODO: Pierwszy sposób

Wykonać kolejno polecenia:

    ruby word_count.rb
    ruby word_count_views.rb
    ruby word_count_query.rb  # czekamy ok. 8–10 minut na szybkim komputerze

## TODO: Drugi sposób

Wykonać kolejno polecenia:

    ruby word_count.rb
    cd extra
    couchapp push default
    cd ..
    ./markow dog  # czekamy ok. 15–20 minut na szybkim komputerze
    ./markow dog
    ./markow your
    ./markow you    
    ./markov love
    ruby word_count_query.rb
