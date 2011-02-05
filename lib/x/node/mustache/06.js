var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  a_object: {
    title: 'this is an object',
    description: 'one of its attributes is a list',
    a_list: [{label: 'listitem1'}, {label: 'listitem2'}]
  }
};

var template = fs.readFileSync('./06.mustache', 'utf-8');

util.puts("---- TEMPLATE");
util.puts(template);

util.puts("--- DATA");
util.puts(util.inspect(view));

var html = Mustache.to_html(template, view);
util.puts("\n---- RENDERED TEMPLATE");
util.puts(html);
