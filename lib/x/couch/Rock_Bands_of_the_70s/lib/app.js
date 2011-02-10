var kanso = require('kanso/core');

// exports.rewrites = [
//     {from: '/static/*', to: 'static/*'},
//     {from: '/', to: '_show/welcome'}
// ];

exports.rewrites = [
    {from: '/static/*', to: 'static/*'},
    {from: '/', to: '_list/artists/artists', query: {group: true}}
];

exports.artists = function (head, req) {
  start({headers: {'Content-Type': 'text/html'}});
  var row, rows = [];
  while (row = getRow()) {
    rows.push(row);
  }

  if (req.client) {
    console.log("CLIENT REQUEST:");
    console.log(req);

    // create a html list of artists
    var content = kanso.template('artists.html', req, {rows: rows});

    // if client-side, replace the HTML of the content div with the list
    $('#content').html(content);
    // update the page title
    document.title = 'Artists';
  }
  else {
    log("APP REQUEST:");
    log(req);

    // if server-side, return a newly rendered page using the base template
    return kanso.template('base.html', req, {
      title: 'Artists'
    });
  }
};

// exports.shows = {
//     welcome: function (doc, req) {
//         if (req.client) {
//           console.log("CLIENT REQUEST:");
//           console.log(req);

//           var content = kanso.template('welcome.html', req, {});
//           $('#content').html(content);
//         }
//         else {
//           log("APP REQUEST:");
//           log(req);

//           return kanso.template('base.html', req, {
//             title: 'Rock Bands of the 70s'
//           });
//         }
//     }
// };

exports.views = require('./views');
exports.lists = require('./lists');
