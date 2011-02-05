var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  name: "Joe",
  winnings: {
    value: 1000,
    taxed_value: function() {
        return this.value - (this.value * 0.4);
    }
  }
};

var template = "Welcome, {{name}}! {{>winnings}}"
var partials = {
  winnings: "You just won ${{value}} (which is ${{taxed_value}} after tax)."
};

var html = Mustache.to_html(template, view, partials);

util.puts(html);
