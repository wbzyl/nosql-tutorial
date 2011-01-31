# Word count example && Markov

## markov

Dodać kontekst na więcej wyrazów. Teraz jest 1 wyraz kontekstu.

## gem couch_docs

Czy są jakieś zamienniki w innych klasach dla tego co robimy
w *Rakefile* korzystając wyłącznie z klasy *CouchDocs::DesignDirectory*:

    desc "Upload database logic from _design/wc"
    task :views do
      require 'couch_docs'
      dir = CouchDocs::DesignDirectory.new('_design/wc')
      ...
