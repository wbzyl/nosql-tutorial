
## Trochę linków

Linki do dokumentacji:

* [tweetstream](https://github.com/intridea/tweetstream)
([rdoc](http://rdoc.info/github/intridea/tweetstream))

Zobacz też:

* Adam Wiggins.
  [Consuming the Twitter Streaming API](http://adam.heroku.com/past/2010/3/19/consuming_the_twitter_streaming_api/) –
  prościej, bez *TweetStream*
* Karel Minarik.
  [Gmail & ES](http://ephemera.karmi.cz/post/5510326335/gmail-elasticsearch-ruby)
* Mirko Froehlich.
  [Building a Twitter Filter With Sinatra, Redis, and TweetStream](http://www.digitalhobbit.com/2009/11/08/building-a-twitter-filter-with-sinatra-redis-and-tweetstream/)


# Aplikacja EST

Kod aplikacji umieściłem na na serwerze GitHub w repozytorium
[EST](https://github.com/wbzyl/est).

Śledząc spływające statusy na konsoli i analizując
wyniki wyszukiwania fasetowego dla hashtagów,
wkrótce zaczynamy orientować się co się dzieje w świecie
rails, mongodb, couchdb, redis, elasticsearch, neo4j, riak (basho),
meteorjs, emberjs, backbonejs.

Napiszemy prostą aplikację Rails umożliwiającą nam przeglądanie
offline zapisanych w bazie statusów.

Aplikacja będzie składała się z jednego modelu *Tweet*,
kontroler będzie miał jedną metodę *index*.

Na stronie indeksowej umieścimy formularz do wyszukiwania
interesujących nas statusów.
Wyszukane statusy będą stronicowane (skorzystamy z gemu
*will_paginate*).

Po wejściu na stronę główną, aplikacja wyświetli stronę z ostatnio
pobranymi statusami.

Skorzystamy z gemu Tire dla Elasticsearch oraz frameworka Bootstrap:

* [Tire](https://github.com/karmi/tire)
([rdoc](http://rdoc.info/github/karmi/tire/frames))
* [Bootstrap](http://twitter.github.com/bootstrap/):
  - [3. Customize variables](http://twitter.github.com/bootstrap/customize.html#variables)
  - [twitter-bootstrap-rails](https://github.com/seyhunak/twitter-bootstrap-rails)

Warto zainstalować kilka „front ends clients” dla Elasticsearch:

* [Elasticsearch Clients](http://www.elasticsearch.org/guide/appendix/clients.html)


## Generujemy rusztowanie aplikacji

Aplikację nazwiemy krótko **EST** (*ElasticSearch Statuses*):

    :::bash
    rails new est --skip-active-record --skip-test-unit --skip-bundle
    rm est/public/index.html

Podmieniamy wygenerowany plik *Gemfile* na (*TODO:* handlebars_assets):

    :::ruby Gemfile
    source 'https://rubygems.org'
    gem 'rails', '~> 3.2.11'

    group :assets do
      gem 'coffee-rails', '~> 3.2.1'
      gem 'therubyracer', :platforms => :ruby
      gem 'less-rails'
      gem 'twitter-bootstrap-rails'

      gem 'uglifier', '>= 1.0.3'
    end

    group :development do
      gem 'wirble'
      gem 'hirb'
      gem 'quiet_assets'
    end

    gem 'jquery-rails'
    gem 'tire'
    gem 'will_paginate'
    gem 'thin'

i instalujemy gemy:

    :::bash
    cd est
    bundle install --path=$HOME/.gems

### post-install: Twitter Bootstrap

Postępujemy, tak jak to opisano w [README](https://github.com/seyhunak/twitter-bootstrap-rails):

    :::bash konsola
    rails generate bootstrap:install less
          insert  app/assets/javascripts/application.js
          create  app/assets/javascripts/bootstrap.js.coffee
          create  app/assets/stylesheets/bootstrap_and_overrides.css.less
            gsub  app/assets/stylesheets/application.css
            gsub  app/assets/stylesheets/application.css
    rails g bootstrap:layout application fixed
          conflict  app/views/layouts/application.html.erb

(odpowiadamy **Y**)

Dopiero teraz przystępujemy do kodowania aplikacji.
Zaczynamy od wygenerowania kontrolera:

    :::bash konsola
    rails generate controller tweets index
      create  app/controllers/tweets_controller.rb
       route  get "tweets/index"
      invoke  erb
      create    app/views/tweets
      create    app/views/tweets/index.html.erb
      invoke  helper
      create    app/helpers/tweets_helper.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/tweets.js.coffee
      invoke    less
      create      app/assets/stylesheets/tweets.css.less

oraz następującej zmiany w routingu:

    :::ruby config/routes.rb
    Est::Application.routes.draw do
      get "tweets/index"
      # You can have the root of your site routed with "root"
      # just remember to delete public/index.html.
      root :to => 'tweets#index'
    end

Po tej zmianie, polecenie:

    :::bash
    rake routes

powinno wypisać taki routing:

    :::text
    tweets_index GET /tweets/index(.:format) tweets#index
            root     /                       tweets#index

Zanim uruchomimy serwer, towrzymy pustą ikonkę:

    :::bash
    touch app/assets/favicon.ico

(dla trybu development; w trybie production należy wykonać takie polecenie…)


<blockquote>
 {%= image_tag "/images/mark-otto.jpg", :alt => "[Mark Otto]" %}
 <p>Bootstrap is a toolkit from Twitter designed to kickstart
 development of webapps and sites.  It includes base CSS and HTML for
 typography, forms, buttons, tables, grids, navigation, and more.<p>
 <p class="author">— Mark Otto</p>
</blockquote>

## Korzystamy z Twitter Bootstrap

Po uruchomieniu aplikacji:

    :::bash
    rails server -p 3000

widzimy, zę jest kilka rzeczy do poprawki: layout, css…
Poprawiamy to co nam nie psauje.

Przykładowo:

    :::css app/assets/stylesheets/bootstrap_and_overrides.css.less
    @baseFontSize: 18px;
    @baseLineHeight: 24px;

    @navbarBackground: #EB7F00;
    @navbarBackgroundHighlight: darken(#EB7F00, 10%);
    @navbarText: black;
    @navbarLinkColor: black;
    @navbarLinkBackgroundHover: white;

    body {
      padding-top: 40px;
    }
    article {
      clear: both;
    }
    // statuses: datetime
    .date {
      float: right;
      font-style: italic;
      font-size: 90%;
    }
    a.entities {
      margin-left: .5em;
    }


## Dodajemy pozostałe elementy MVC

Kontroler:

    :::ruby app/controllers/tweets_controller.rb
    class TweetsController < ApplicationController
      def index
        @tweets = Tweet.search(params)
      end
    end

Formularz:

    :::rhtml app/views/tweets/index.html.erb
    <%= form_tag tweets_index_path, method: :get, class: 'form-search' do %>
      <%= text_field_tag :q, params[:q], class: 'span4' %>
      <%= submit_tag 'Search', name: nil, class: 'btn' %>
    <% end %>

Paginacja:

    :::rhtml app/views/tweets/index.html.erb
    <div class="digg_pagination">
      <div clas="page_info">
        <%= page_entries_info @tweets.results %>
      </div>
      <%= will_paginate @tweets.results %>
    </div>

Pozostała część widoku *index* (*TODO:* napisać kilka metod pomocniczych):

    :::rhtml app/views/tweets/index.html.erb
    <% @tweets.results.each do |tweet| %>
    <article>
    <p>
     <% text = (tweet.highlight && tweet.highlight.text) ? tweet.highlight.text.first : tweet.text %>
     <%= text.html_safe %>
    </p>
    <% date = Time.parse(tweet.created_at).strftime('%d.%m.%Y %H:%M') %>
    <p class="date">published on <%= content_tag :time, date, datetime: tweet.created_at %></p>
    <p>
     <% unless tweet.urls.empty? %>
       Links:
       <% tweet.urls.each_with_index do |url, index| %>
         <%= content_tag :a, "[#{index+1}]", href: url, class: :entities %>
       <% end %>
      <% end %>
    </p>
    </article>
    <% end %>

Model:

    :::ruby app/models/tweet.rb
    class Tweet
      include Tire::Model::Persistence

      property :text
      property :screen_name
      property :created_at
      property :hashtags
      property :urls
      property :user_mentions

      def self.search(params)
        #Tire.search('statuses', type: 'mongodb', page: params[:page], per_page: 3) do |search|
        Tire.search('tweets', page: params[:page], per_page: 8) do |search|
          per_page = search.options[:per_page]
          current_page = search.options[:page] ? search.options[:page].to_i : 1
          offset = search.options[:per_page] * (current_page - 1)

          search.query do
            boolean do
              #must { string params[:q].blank? ? "*": params[:q] }
              must { string params[:q] } if params[:q].present?
              must { range :created_at, lte: Time.zone.now }
            end
          end
          search.sort { by :created_at, "desc" }
          search.highlight text: {number_of_fragments: 0}, options: {tag: '<mark>'}

          search.size per_page
          search.from offset
        end
      end
    end

Pobieramy style stronicowania ze strony
[Samples of pagination styles for will_paginate](http://mislav.uniqpath.com/will_paginate/),
przepisujemy je na LESS i importujemy kod *digg_pagination.less*
w *bootstrap_and_overrides.css.less*:

    :::css app/assets/stylesheets/bootstrap_and_overrides.css.less
    @import "digg_pagination";


## Fasety

**Zadanie:** Dodać wyszukiwanie fasetowe po hashtagach.
