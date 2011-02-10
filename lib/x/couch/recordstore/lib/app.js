var kanso = require('kanso/core');

exports.rewrites = [
    {from: '/static/*', to: 'static/*'},
    {from: '/', to: '_show/welcome'}
];

// exports.rewrites = [
//     {from: '/static/*', to: 'static/*'},
//     {from: '/', to: '_list/artists/artists', query: {group: true}}
// ];

var kanso = require('kanso/core');

exports.rewrites = [
  {from: '/static/*', to: 'static/*'},
  {from: '/', to: '_show/welcome'}
];

exports.shows = {
  welcome: function (doc, req) {
    if (req.client) {
      var content = kanso.template('welcome.html', req, {});
      console.log('CLIENT (BROWSER) REQUEST');
      console.log(req);
      $('#content').html(content);
      //document.title = 'It worked!';
    }
    else {
      log('SERVER (APPLICATION) REQUEST');
      log(req);
      return kanso.template('base.html', req, {
        title: 'It worked!'
      });
    }
  }
};

// exports.views = require('./views');
// exports.lists = require('./lists');
