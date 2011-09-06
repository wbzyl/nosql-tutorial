#### {% title "Why MongoDB?" %}

Starbienino 2011.09.22.

* [Facebook has the world's largest Hadoop cluster!](http://hadoopblog.blogspot.com/2010/05/facebook-has-worlds-largest-hadoop.html)
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


## MapReduce

* [How to process a million songs in 20 minutes](http://musicmachinery.com/2011/09/04/how-to-process-a-million-songs-in-20-minutes/) ([Million Song Dataset ](http://labrosa.ee.columbia.edu/millionsong/))
