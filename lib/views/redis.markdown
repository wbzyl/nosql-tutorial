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

[To Redis or Not To Redis?] [redis-or-not]

[Redis] [redis] is key/value store:

* which is blazingly fast
* works best when data set is small enough that it can fit in available RAM
* it's OK if some recently updated records are lost in a catastrophic failure
* makes your life would a lot easier whenever you want cheap and easy
  set and list operations

Zob. też [Object-Hash Mapping for Redis] [ohm].


[redis]: http://www.engineyard.com/blog/2009/key-value-stores-for-ruby-part-4-to-redis-or-not-to-redis/ "Redis or not…"
[ohm]: http://ohm.keyvalue.org/ "Object-Hash Mapping for Redis"
[redis-or-not]: http://www.engineyard.com/blog/2009/key-value-stores-for-ruby-part-4-to-redis-or-not-to-redis/ "Redis orn not…"
