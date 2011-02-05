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

var html = Mustache.to_html(template, view);

util.puts(html);
