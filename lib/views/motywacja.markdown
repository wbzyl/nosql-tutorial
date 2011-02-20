#### {% title "NoSQL is about choice", false %}

# „NoSQL is about choice” – Jan Lehnardt

<blockquote>
 <p>
  Structurally speaking, they are multilevel treemaps (kind of, at
  least Cassandra). Nothing fancy, just something from the
  60ies. Hashmaps are just the quickest way to get data after an
  array. Which sounds very good for a database.
 </p>
 <p>
  […] Ok, what's more? Nothing. That's it. So
  the next question is now: Why haven't we thought about it earlier?
  <b>Why have we spent decades trying to make it more complicated instead
  of simpler?</b> The aforementioned new-comer expects some juice and I
  can't provide any.
 </p>
<!--
 <p>
  Ok, I don't see banks going to NoSQL in the short-run, it's a nice
  model for a database with simple schemas like web-apps. I can think
  easily of an usage of a NoSQL for twitter, digg etc., maybe tougher
  for a Bank. But maybe again it's my 20th century brain. How can I
  optimize my schema? Simple: don't have one. Mhm…
 </p>
-->
 <p class="author">— <a href="http://blog.acaro.org/entry/why-herb-kelleher-of-southwest-invented-nosql">Claudio Martella</a></p>
</blockquote>

[K. Haines][key-value stores part 1]:
„Applications, whether web apps, simple dynamic websites or command
line apps, frequently need some sort of persistent data store. As a
result, databases have become ubiquitous on modern systems, and
because of this chicken and egg relationship, programmers will often
habitually reach for a relational database when the project only calls
for a way to persist data.”

[L. Carlson, L. Richardson][ruby receptury]:
Wszyscy chcą pozostawić po sobie coś trwałego. […]
Każdy program, który piszemy, pozostawia jakiś ślad swojego działania
(w najprostszym przypadku są to dane wyświetlane na standardowym
urządzeniu wyjściowym). Większość bardziej rozbudowanych programów
idzie o krok dalej: zapisują one – w pliku o określonej strukturze –
dane stanowiące rezultat jednego uruchomienia, by przy następnym
uruchomieniu rozpocząć działanie w stanie, w którym zakończyła się
poprzednia sesja. **Istnieje wiele sposobów takiego
*utrwalania danych*, zarówno bardzo prostych, jak i wielce
skomplikowanych.**


## What Does Big Data Mean to Infrastructure Professionals?

Cytat z [Ten “Big Data” Realities and What They Mean to You](http://wikibon.org/blog/ten-%E2%80%9Cbig-data%E2%80%9D-realities-and-what-they-mean-to-you/):

* Big data means the amount of data you’re working with today will
  look trivial within five years.
* Huge amounts of data will be kept longer and have way more value than
  today’s archived data.
* Business people will covet a new breed of alpha geeks. You will need
  new skills around data science, new types of programming, more math
  and statistics skills and data hackers… lots of data hackers.
* **You are going to have to develop new techniques to access, secure,
  move, analyze, process, visualize and enhance data; in near real
  time.**
* **You will be minimizing data movement wherever possible by moving
  function to the data instead of data to function.** You will be
  leveraging or inventing specialized capabilities to do certain types
  of processing — e.g. early recognition of images or content types —
  so you can do some processing close to the head.
* The cloud will become the compute and storage platform for big data
  which will be populated by mobile devices and social networks.
* Metadata management will become increasingly important.
* **You will have opportunities to separate data from applications and
  create new data products.**
* You will need orders of magnitude cheaper infrastructure that
  emphasizes bandwidth, not iops and data movement and efficient
  metadata management.
* You will realize sooner or later that data and your ability to
  exploit it is going to change your business, social and personal
  life; permanently.


## CAP Theorem

&nbsp;{%= image_tag "/images/cap.png", :alt =>"Visual Guide to NoSQL systems" %}

Źródło: Nathan Hurst.
[Visual Guide to NoSQL Systems](http://blog.nahurst.com/visual-guide-to-nosql-systems).

Zobacz też:

* Mike Stonebraker,
  [Errors in Database Systems, Eventual Consistency, and the CAP Theorem](http://cacm.acm.org/blogs/blog-cacm/83396-errors-in-database-systems-eventual-consistency-and-the-cap-theorem/fulltext)
* [NoSQL Deep Dive – The Missing White Paper](http://www.pythian.com/news/16817/nosql-deep-dive-the-missing-white-paper/)
(posted by shapira on Sep 14, 2010).



[key-value stores part 1]: http://www.engineyard.com/blog/2009/key-value-stores-in-ruby/ "Kirk Haines, Key-Value Stores in Ruby: Part 1"
[ruby receptury]: http://helion.pl/ksiazki/rubyre.htm "Ruby Receptury, Bazy danych i trwałość obiektów."
