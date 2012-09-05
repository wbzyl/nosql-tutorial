#### {% title "CouchDB — Autentykacja" %}

* [CouchDB 0.11 and CouchApp Notes](http://www.owengriffin.com/posts/2010/04/27/CouchDB_0.11_and_CouchApp_Notes.html)
  — przykładowa aplikacja CouchApp korzystająca z Evently.

# Dokumentacja do CouchApp

TODO: na razie wkleiłem zawartość plików Markdown z katalogu:

    http://github.com/couchapp/couchapp/tree/master/vendor/docs/


## Docs for the docs system.

You are encouraged to use the couchapp docs system to write
documentation for your plugins and applications. Extra bonus points
because it's fun.

Docs automatically make divs based on `$("#foo")` pattern
matching. That is, we regex the code looking for the first id we see
referenced. Remember ids need to be unique on a page. For doc examples
you only get one id.

Example Code:

    :::javascript
    $("#hide_foo").hide("slow");

That's all it takes. You only get one div in each example for now. Have fun!


## Evently Docs

Evently is an declarative framework for evented jQuery applications. You write your code as widgets made up of templates and callbacks, while Evently handles the busywork of linking them together.

Evently has special handlers for CouchDB views and `_changes` feeds, and could be easily extended for other server-side frameworks.

### Hello World

At it's simplest an Evently widget is a set of events connected to a single DOM element.

JavaScript:

    :::javascript
    $("#hello").evently({
      _init : {
        mustache : "<p>Hello world</p>",
      },
      click : {
        mustache : "<p>What a crazy world!</p>",
      }
    });

You can also do some more interesting things:

    :::javascript
    $("#heyjane").evently({
      _init : {
        mustache : '<p>Hello <a href="#jane">Jane</a>, <a href="#joan">Joan</a> (pick one)</p>',
        selectors : {
          'a[href=#joan]' : {
            click : 'hiJoan'
          },
          'a[href=#jane]' : {
            click : 'hiJane'
          }
        }
      },
      hiJoan : {
        mustache : '<p>Hello Joan!</p>'
      },
      hiJane : {
        mustache : "<p>Darn, it's Jane...</p>",
        after : function() {
          setTimeout(function() {
            // automatically trigger the "janeRocks" event after 2 seconds.
            $("#heyjane").trigger("janeRocks");
          }, 2000);
        }
      },
      janeRocks : {
        render : "append",
        mustache : "<p>Actually Jane is awesome.</p>"
      }
    });


The imporant thing about this is that the widget is defined by an JavaScript object. This means we can save it as files on our hard drive and `couchapp` will handle saving it as a JSON object for us.

[screenshot of the above code in textmate's file drawer]

When we let CouchApp package our evently apps we get to work on them in individual files, instead of as a great big giant mess of JavaScript. This means HTML is HTML, JSON is JSON, and JavaScript is JavaScript. Yay!

### Ajax Hello World

Let's do a little Ajax. We'll just load the version of the CouchDB instance we happen to be serving our HTML from:

    :::javascript
    $("#ajax").evently({
      _init : {
        mustache : '<p>Loading CouchDB server info.</p>',
        after : function() {
          var widget = $(this);
          $.ajax({
            url : '/',
            complete : function(req) {
              var resp = $.httpData(req, "json");
              widget.trigger("version", [resp]);
            }
          })
        }
      },
      version : {
        mustache : "<p>Running CouchDB version {{version}}</p>",
        data : function(e, resp) {
          return resp;
        }
      }
    });

Explain `mustache` and `data`

-- triggering other events
  -- selectors
  -- create a doc

### Evently and CouchApp together

Evently makes it easy to write decoupled JavaScript code, but as the examples above show, Evently widgets can turn into a lot of JSON to look at all on one screen. Because Evently code is declarative, and each handler and callback stands on its own (instead of being wrapped in a common closure), it can be broken out into individual files.

CouchApp provides a mechanism for mapping between individual files and JSON structures. In this model a directory structure is mapped to a JSON object. So if you have a directory structure like:

    _init/
      mustache.html
      selectors/
        form/
          submit.js
        input.name/
          change.js
        a.cancel/
          click.txt
    cancelled/
      mustache.html
      selectors/
        a.continue/
          click.txt

It will appear within your CouchApp design document as:

    :::javascript
    {
      _init : {
        mustache : "contents of mustache.html",
        selectors {
          form : {
            submit : "function() { ... }"
          },
          "input.name" {
            change : "function() { ... }"
          },
          "a.cancel" {
            click : "cancelled"
          }
        }
      },
      cancelled : {
        mustache : "contents of mustache.html",
        selectors : {
          "a.continue" : {
            click : "_init"
          }
        }
      }
    }

This makes Evently and CouchApp a natural fit for each other. I swear I didn't plan this when I started writing Evently, it just turned out to be an awesome side effect of trying to stay as close to JSON as possible.

In the [account widget tutorial](#/topic/account) we see the details of the account widget. What isn't discussed much there, is how the code is edited on your filesystem.

If you are writing an Evently CouchApp widget you can edit the individual pieces on your filesystem. This has the added advantage of giving you native syntax highlighting for all the code. Instead of editing everything as JSON or JavaScript, the templates can be treated as HTML, the paths as text, etc.

### Evently Queries

Evently understands CouchDB in a couple of very simple ways. If you know CouchDB, you're probably familiar with its Map Reduce views. Evently lets you specify view queries in a declarative way, and even takes care of the Ajax request. All you have to do is write code to handle the returned data.

-- new rows, etc

-- run a query

-- connect to changes

-- links to example apps

### Freeform Asynchronous Actions

Watch out, you're dangerous! Evently allows you to make any old asyncronous action you want, with the `widget.async` member. The callback is the first argument to the `async` function. Check it out:

    :::javascript
    $("#async").evently({
      _init : {
        mustache : "<p>How many databases on the local host?</p><p>Answer: {{number_of_dbs}}</p><p>Other stuff: {{args}}</p><p>More: {{allArgs}}</p>",
        async : function(cb) {
          var ag = Array.prototype.slice.call(arguments).map(function(a){return a.toSource ? a.toSource() : a});
          $.couch.allDbs({
            success : function(resp) {
              cb(resp.length, ag);
            }
          })
        },
        data : function(count, args) {
          return {
            number_of_dbs : count,
            args : JSON.stringify(args),
            allArgs : JSON.stringify(Array.prototype.slice.call(arguments))
          };
        }
      },
      click : {
        mustache : "<p>What a crazy world!</p>",
      }
    });


## Docs for $.couch.app

The simplest use of CouchApp in the browser is to get access to information about the database you are running in.

    :::javascript
    $.couch.app(function(app) {
      $("#dbinfo").evently({
        _init : {
          mustache : '<p>The db name is <strong>{{name}}</strong></p>',
          data : app.db
        }
      });
    });

Yay couchapp.

The `$.couch.app()` function also loads the current design document so that it is available for templates etc. That is how the words you are reading were loaded. This file is included in the CouchApp application library. Let's look at the design doc:

    :::javascript
    $.couch.app(function(app) {
      $("#ddoc").evently({
        _init : {
          mustache : '<p>Click to show the full doc source:</p><pre>{{ddoc}}</pre>',
          data : {
            ddoc : JSON.stringify(app.ddoc, null, 2).slice(0,100) + '...'
          }
        },
        click : {
          mustache : '<p>The full doc source (rerun to hide):</p><pre>{{ddoc}}</pre>',
          data : {
            ddoc : JSON.stringify(app.ddoc, null, 2)
          }
        }
      });
    });


## Docs for the profile evently widget

This widget makes it easy to give users a profile for your application.


## Docs about $.pathbinder

Pathbinder is a tiny framework for triggering events based on paths in URL hash. For example, you might want to render one panel when the user clicks a link to `#/foo` and another when the URL hash changes to `#/bar`. If you've never used URL hashes for application state in an Ajax app before, prepare to be happy.

There are two big advantages to having the state in the URL-hash. One is that users can bookmark screens they may have reached by navigating within your app. The other is that the back button will continue to work.

The page you are on has a URL hash of `#/topic/pathbinder` right now. You can follow links to other "pages" within this application, and Pathbinder takes care of triggering the proper events.

### A simple example

    :::javascript
    $("#basic_path").html('<p><a href="#/foo">click for foo</a></p>');
    $("#basic_path").bind("foo", function() {
      $(this).html("<p>you went to foo</p>");
    });
    $("#basic_path").pathbinder("foo", "/foo");

This code sets up the `#basic_path` div with some initial content, including a link to `#/foo`. If you click the link to foo, you'll see the URL change. It is the changed URL which Pathbinder sees and uses to trigger any running code. You can experiment by manually entering the `#/foo` URL hash, instead of clicking the link, and you'll see that it also triggers the `foo` event.

### Using path parameters

Pathbinder was inspired by the path handling in [Sammy.js](http://github.com/aq/sammy.js). Like Sammy, you can use it to pull parameters from the URL-hash. This page can be linked [using a path that has "pathbinder" as a parameter](#/topic/pathbinder). Let's explore how you can pull parameters out of a path.

    :::javascript
    $("#param_path").html('<p><a href="#/foo/super">click for super foo</a></p>');
    $("#param_path").bind("foo", function(e, params) {
      $(this).html("<p>you went to foo - "+params.id+"</p>");
    });
    $("#param_path").pathbinder("foo", "/foo/:id");

When you click the link to super foo, you'll see the param is passed through the event. You can also edit the URL to see that "super" is not hard coded and can be replaced with other values.

### Pathbinder with Evently

It should be no suprise that Pathbinder and Evently play well together. The gist of it is that Evently looks for a key called `path` and if it finds it, uses Pathbinder to connect that event handler to the path. Let's try it out:

    :::javascript
    $("#evently_path").evently({
      _init : {
        path : '/index',
        mustache : '<p>the index. <a href="#/cowbell">more cowbell!</a></p>'
      },
      cowbell : {
        path : '/cowbell',
        mustache : '<p>Now that is a lot of cowbell. <a href="#/index">back to the index</a></p>'
      }
    });

Note that when you use an Evently path, Evently also takes care to visit the path when the corresponding event is triggered. So running the above example code (which automatically triggers the `_init` event) will set the hash to `#/index`. If you were to trigger the `cowbell` event through non-path means, you'd see that it changes the path to `#/cowbell` anyway.

### Too many widgets

One thing worth noting: there is only one URL hash for any given page, so be aware that if you have multiple widgets competing for the real-estate, they could conflict with each other. Pathbinder won't do anything when presented with a path it doesn't care about (go ahead, try out some non-sense ones on this page).

This means that if you have a few widgets all using the path, the page should still behave in a useful way. However, this breaks down if you intend people to be able to use the URL hash to link to page state. Since there can be only one URL hash, whichever action they took last will be reflected in the bookmarked URL. For this reason it makes sense to limit yourself to one path-based Evently widget per page.


## Docs for the account widget

You should use this widget in any CouchApp that allows users to login or signup.

It is easy to install. To use the account widget, just define a `div` in your page and use [CouchApp](#/topic/couchapp) to load it from the design document and [Evently](#/topic/evently) to apply it to the page.

Here's the most basic usage:

    :::javascript
    $.couch.app(function(app){
      $("#basic_account").evently(app.ddoc.vendor.couchapp.evently.account);
    });

Run this example and try signing up, and logging in and out. This code is part of the CouchApp standard library, so feel free to use it in your applications. It is also "trivial" to replace and extend the functionality. In a minutes, we'll start by replacing a template, and then show how you can use Evently to connect multiple widgets, to build more complex applications.

### A widget is a collection of event handlers

First lets look more closely at the account widget (click Run to see the code we're about to discuss, it will appear in the sidebar -- the example code below is just used for loading and displaying the account widget source code).

    :::javascript
    $.couch.app(function(app){
      $("#account_widget_code").evently({
        _init : {
          mustache : "<pre>{{json}}</pre>",
          data : function() {
            var widget = app.ddoc.vendor.couchapp.evently.account;
            return {
              json : JSON.stringify(widget, null, 2)
            }
          }
        }
      });
    });

The top level keys are the most important: `loggedIn`, `loggedOut`, `adminParty`, `signupForm`, `loginForm`, `doLogin`, `doSignup`, and `_init`. Each one of these corresponds to an event or state the system can be in. Some of them draw user interface elements, other directly trigger further events.

### _init

The `_init` event is special, in that Evently will automatically trigger it when the widget is created. Here is the code for the account widget's `_init` event handler.

    :::javascript
    function() {
      var elem = $(this);
      $.couch.session({
        success : function(r) {
          var userCtx = r.userCtx;
          if (userCtx.name) {
            elem.trigger("loggedIn", [r]);
          } else if (userCtx.roles.indexOf("_admin") != -1) {
            elem.trigger("adminParty");
          } else {
            elem.trigger("loggedOut");
          };
        }
      });
    }

This code does one query to CouchDB, to retrieve the session information for the current user. For this we use the `$.couch.session()` function which is part of the [jquery.couch.js](/_utils/script/jquery.couch.js) library which is part of the CouchDB distribution.

The response is handled in one of three ways, depending on the user's session information. Either we trigger the `loggedIn` or `loggedOut` events, or in the special case where we detect that CouchDB's security is not properly configured, we trigger the `adminParty` event to warn the user.

### loggedOut

Because most visitors start logged out, let's now turn our attention to the `loggedOut` event handler to see what will greet a new visitor:

    "loggedOut": {
        "mustache": "<a href=\\"#signup\\">Signup</a> or <a href=\\"#login\\">Login</a>",
        "selectors": {
          "a[href=#login]": {
            "click": "loginForm"
          },
          "a[href=#signup]": {
            "click": "signupForm"
          }
        }
      }

There are two main components to this handler: `mustache` and `selectors`. `mustache` is a template file with two HTML links. `selectors` contains a set of CSS selectors with events bound to them. You can think of each selector as a nested Evently widget. In this case, clicking "Login" will trigger the `loginForm` event, while clicking "Signup" triggers the `signupForm` event.

### signupForm

Let's see what happens during signup. We'll skip showing the whole handler (it should be in the sidebar anyway if you clicked "run" earlier.)

When the `signupForm` event is triggered, a mustache template draws the form. Then the selectors are run, assigning this function to the form's submit event:

    :::javascript
    function(e) {
      var name = $('input[name=name]', this).val(),
        pass = $('input[name=password]', this).val();
      $(this).trigger('doSignup', [name, pass]);
      return false;
    }

This handler is as simple as possible, all it does is use jQuery to pull the user data from the form, and send the name and password to the `doSignup` event. We could just use a function call here, but it's nice to keep our individual events as small as possible, as this makes customizing Evently widgets simpler.

### doSignup

Here is the `doSignup` handler:

    :::javascript
    function(e, name, pass) {
      var elem = $(this);
      $.couch.signup({
        name : name
      }, pass, {
        success : function() {
          elem.trigger("doLogin", [name, pass]);
        }
      });
    }

Again, all the complex signup logic (encrypting passwords, etc) is pushed to the [jquery.couch.js](/_utils/script/jquery.couch.js) library (via the `$.couch.signup()` call), so our application code can stay as simple as possible. When signup is complete, we trigger the `doLogin` event, so new users don't have to go through another action.

### doLogin

The code for `doLogin` isn't much different, just take the name and password, and call a jquery.couch.js library function with it.

    :::javascript
    function(e, name, pass) {
      var elem = $(this);
      $.couch.login({
        name : name,
        password : pass,
        success : function(r) {
          elem.trigger("_init")
        }
      });
    }

The last thing that `doLogin` does is trigger `_init`, so we come full circle! This time, `_init` will see that the user is logged in, and trigger the `loggedIn` event. You'll probably want to hook your application to this `loggedIn` event, to activate any features which are reserved for registered users. We'll cover linking events in a later section.

## Customizing the account widget

Evently widgets are built out of JSON objects, which makes it easy to replace bits and pieces of them without having to mess with the entire widget. We'll start by customizing what users see when they are logged in.

    :::javascript
    $.couch.app(function(app){
      var customizedWidget = $.extend(true, {}, app.ddoc.vendor.couchapp.evently.account, {
        loggedIn : {
          mustache : '<span>Hello <strong>{{name}}</strong> you are logged in! ' +
            '<a href="#logout">Would you like to logout?</a></span>'
        }
      });
      $("#customWelcome").evently(customizedWidget);
    });

Take a moment to run this example code and login to see how our custom template has replaced just one screen in the widget. The first time I did this I thought it was pretty cool. Hopefully you can think of a lot of powerful stuff you could do with it. The sky is the limit.

Here's another quick one:

    :::javascript
    $.couch.app(function(app){
      var customizedWidget = $.extend(true, {}, app.ddoc.vendor.couchapp.evently.account, {
        loggedOut : {
          after : "function(){alert('Bye bye');}"
        }
      });
      $("#afterAlert").evently(customizedWidget);
    });

For a deeper reference on what the various parts of an Evently widget are named, and how you can use them, see [the Evently docs page](#/topic/evently).

## Linking two widgets

First, lets create a basic widget. This one just has an `_init` handler and a handler called `loggedIn`. There is nothing in this widget definition that will trigger `loggedIn`, unless something else triggers it, there's no way it will run.

    :::javascript
    $("#link_target").evently({
      _init : {
        mustache : "<p>Not much to see here</p>"
      },
      loggedIn : {
        mustache : "<p>loggedIn was triggered from another widget, {{name}}.</p>",
        data : function(e, r) {
          return { name : r.userCtx.name };
        }
      }
    });

Be sure to run the above example code before the next one, otherwise there won't be anything to link to.

This next block of code demonstrates how to link two widgets together. First we create a normal account widget on the `#link_source` element, then we tell Evently to connect it to the `#link_target` element. Now whenever the `loggedIn` evenr is triggered on the source, it will be triggered on the target.

    :::javascript
    $.couch.app(function(app){
      $("#link_source").evently(app.ddoc.vendor.couchapp.evently.account);
      // link the source to the target, for the loggedIn event
      $.evently.connect($("#link_source"), $("#link_target"), ["loggedIn"]);
    });

### Conclusion

If you are writing a CouchApp that will have users logging and and logging out, you'd do well to use the account widget. It's customizable and linkable. And what's more, it's code that's already written.

Enjoy!
