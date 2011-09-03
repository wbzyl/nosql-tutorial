#### {% title "Why MongoDB?" %}

Starbienino 2011.09.22.

* [MongoDB in Three Minutes](http://kylebanker.com/blog/2009/11/mongodb-in-three-minutes/)

Przykład:

    gem install twitter
    irb

Kod:

    :::ruby
    require 'twitter'
    a = Twitter::Search.new.containing("rails").fetch ; nil
    a[0].text

[Twitter RDOC](http://rdoc.info/gems/twitter/1.6.2/Twitter/Search)
