var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  title: 'Joe',
  calc: function() {
    return 2 + 4;
  }
}

var template = "{{title}} spends {{calc}}";

var html = Mustache.to_html(template, view);

util.puts(html);

util.print(html);
util.print('\n');
util.puts(util.inspect(html));

var template_from_file = fs.readFileSync('./template.mustache', 'utf-8');

util.puts(template_from_file);
var html = Mustache.to_html(template_from_file, view);
util.puts(html);
