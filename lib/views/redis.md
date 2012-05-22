#### {% title "Redis" %}

<blockquote>
 {%= image_tag "/images/carlos_castaneda.jpg", :alt => "[Carlos Castaneda]" %}
 <p>
  Niektórzy czarownicy, wyjaśnił, są gawędziarzami.
  Snucie historii to dla nich nie tylko wysyłanie
  zwiadowców badających granice ich percepcji,
  ale także sposób na osiągnięcie doskonałości,
  zdobycia mocy i dotarcia do ducha.
 </p>
 <p class="author">— Carlos Castaneda</p><!-- Potęga milczenia, p. 126 -->
</blockquote>

* [To Redis or Not To Redis?] [redis-or-not]
* [Is CouchDB The Anti-Redis?](http://ai.mee.nu/is_couchdb_the_anti-redis?utm_source=NoSQL+Weekly+List&utm_campaign=92fe997cef-NoSQL_Weekly_Issue_37_Aug_11_2011&utm_medium=email)

[Redis] [redis] is key/value store:

* which is blazingly fast
* works best when data set is small enough that it can fit in available RAM
* it's OK if some recently updated records are lost in a catastrophic failure
* makes your life would a lot easier whenever you want cheap and easy
  set and list operations

## Gemy

* [Object-Hash Mapping for Redis] [ohm]
* [Redis Object] [redis-object]


## Sinatra + Redis

* [Sinatra with Redis on Cloud Foundry](http://nosql.mypopescu.com/post/5929530437/sinatra-with-redis-on-cloud-foundry)


[redis]: http://www.engineyard.com/blog/2009/key-value-stores-for-ruby-part-4-to-redis-or-not-to-redis/ "Redis or not…"
[ohm]: http://ohm.keyvalue.org/ "Object-Hash Mapping for Redis"
[redis-or-not]: http://www.engineyard.com/blog/2009/key-value-stores-for-ruby-part-4-to-redis-or-not-to-redis/ "Redis orn not…"
[redis-object]: https://github.com/nateware/redis-objects "Redis Object"
