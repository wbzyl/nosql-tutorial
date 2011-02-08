var kanso = require('kanso/core');

// exports.rewrites = [
//     {from: '/static/*', to: 'static/*'},
//     {from: '/', to: '_show/welcome'}
// ];

exports.rewrites = [
    {from: '/static/*', to: 'static/*'},
    {from: '/', to: '_list/artists/artists', query: {group: true}}
];


// exports.shows = {
//     welcome: function (doc, req) {
//         var content = kanso.template('welcome.html', req, {});

//         if (req.client) {
//             $('#content').html(content);
//             document.title = 'It worked!';
//         }
//         else {
//             return kanso.template('base.html', req, {
//                 title: 'It worked!',
//                 content: content
//             });
//         }
//     }
// };

exports.views = require('./views');

exports.lists = require('./lists');
