#### {% title "Node.JS" %}

* Co to jest [Node.JS](http://nodejs.org/)?
* [Mastering NodeJS](http://visionmedia.github.com/masteringnode/) – open source Node eBook
* [API v0.4.3](http://nodejs.org/docs/v0.4.3/api/)

Program „hello world” dla NodeJS, to prosty serwer www:

    :::javascript server.js
    var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello World\n');
    }).listen(8124, "127.0.0.1");
    console.log('Server running at http://127.0.0.1:8124/');

Tak uruchamiamy ten serwer:

    node server.js

Co ten serwer robi?

Więcej przykładów?

* [OSButler](http://blog.osbutler.com/categories/node-by-example/)


### Instalacja modułu *Socket.IO-node*

Korzystamy z NPM:

    npm install socket.io

Albo, klonujemy repozytorium:

    git clone git://github.com/LearnBoost/Socket.IO-node.git socket.io --recursive
    cd socket.io
    npm link .


## Chat korzystający z websockets

Program *chat* to program „hello world” dla websockets.

Serwer *server.js* („2in1” – serwer www + serwer dla websocket):

    :::javascript
    var http = require('http')
      , url = require('url')
      , fs = require('fs')
      , io = require('socket.io')
      , sys = require(process.binding('natives').util ? 'util' : 'sys')
      , server;

    server = http.createServer(function(req, res){
      // prosty routing
      var path = url.parse(req.url).pathname;
      switch (path){
        case '/':
          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write('<h1>Welcome. Try the <a href="/chat.html">chat</a> example.</h1>');
          res.end();
          break;

        case '/chat.html':
          fs.readFile(__dirname + path, function(err, data){
            if (err) return send404(res);
            res.writeHead(200, {'Content-Type': 'text/html'})
            res.write(data, 'utf8');
            res.end();
          });
          break;

        default: send404(res);
      }
    }),

    send404 = function(res){
      res.writeHead(404);
      res.write('404');
      res.end();
    };

    server.listen(8080);

    // socket.io, I choose you simplest chat application ever
    var io = io.listen(server)
      , buffer = [];  // storage for recent messages

    io.on('connection', function(client) {
      // we push to clients:
      //   { buffer: Array with the last four messages }
      //   { announcement: String }
      //   { message: Array: sessionID, String }

      client.send({ buffer: buffer });
      client.broadcast({ announcement: client.sessionId + ' connected' });

      client.on('message', function(message) {
        var msg = { message: [client.sessionId, message] };
        buffer.push(msg);
        // new clients receive last 4 messages
        if (buffer.length > 4) buffer.shift();
        client.broadcast(msg);
      });

      client.on('disconnect', function() {
        client.broadcast({ announcement: client.sessionId + ' disconnected' });
      });
    });

Plik *chat.html*:

    :::html
    <!doctype html>
    <html lang=pl>
      <head>
        <meta charset=utf-8>
        <title>socket.io client test</title>
        <style>
          body { font-size: 20px; }
          h1 { font-size: 120%; color: #6D0839; }
          #chat { height: 200px; overflow: auto; width: 800px; }
          #chat p { padding: 8px; margin: 0; }
          #chat p:nth-child(odd) { background: #F6F6F6; }
          #form { width: 782px; background: #6D0839; padding: 5px 10px; }
          #form input[type=text] { width: 700px; padding: 5px; background: white; border: 1px solid #fff; }
          #form input[type=submit] { cursor: pointer; background: #D8C358; border: none; padding: 6px 8px;
            -moz-border-radius: 8px;
            -webkit-border-radius: 8px;
            margin-left: 5px; text-shadow: 0 1px 0 #fff; }
          #form input[type=submit]:hover { background: white; }
          #form input[type=submit]:active { position: relative; top: 2px; }
        </style>
        <script src="/socket.io/socket.io.js"></script><!-- a to skąd jest pobierane? -->
      </head>
      <body>
        <script>
          function message(obj){
            var el = document.createElement('p');
            if ('announcement' in obj) el.innerHTML = '<em>' + esc(obj.announcement) + '</em>';
            else if ('message' in obj) el.innerHTML = '<b>' + esc(obj.message[0]) + ':</b> ' + esc(obj.message[1]);
            document.getElementById('chat').appendChild(el);
            document.getElementById('chat').scrollTop = 1000000;
          }

          function send(){
            var val = document.getElementById('text').value;
            socket.send(val);
            message({ message: ['you', val] });
            document.getElementById('text').value = '';
          }

          function esc(msg){
            return msg.replace(/</g, '&lt;').replace(/>/g, '&gt;');
          };

          var socket = new io.Socket(null, {port: 8080, rememberTransport: false});
          socket.connect();
          socket.on('message', function(obj) {
            if ('buffer' in obj) {
              document.getElementById('chat').innerHTML = '';

              for (var i in obj.buffer) message(obj.buffer[i]);
            } else {
              message(obj);
            }
          });
        </script>

        <h1>Sample chat client</h1>
        <div id="chat"><p>Connecting...</p></div>
        <form id="form" onsubmit="send(); return false">
          <input type="text" autocomplete="off" id="text"><input type="submit" value="Send">
        </form>

      </body>
    </html>
