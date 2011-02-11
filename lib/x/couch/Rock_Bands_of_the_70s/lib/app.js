var kanso = require('kanso/core');

exports.rewrites = [
    {from: '/static/*', to: 'static/*'},
//    {from: '/', to: '_list/all/artists', query: {group: true}}
    {from: '/', to: '_list/all/artists', query: {reduce: false}}
];

exports.views = require('./views');
exports.lists = require('./lists');

// show

// exports.rewrites = [
//     {from: '/static/*', to: 'static/*'},
//     {from: '/', to: '_show/welcome'}
// ];

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
