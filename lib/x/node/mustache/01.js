var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  title: 'Joe',
  calc: function() {
    return 2 + 4;
  }
}

var template = fs.readFileSync('./01.mustache', 'utf-8');
util.puts("\n---- TEMPLATE");
util.puts(template);

util.puts("---- DATA");
util.puts(util.inspect(view));

var html = Mustache.to_html(template, view);
util.puts("\n---- RENDERED TEMPLATE");
util.puts(html);
