var kanso = require('kanso/core');

exports.artists = function (head, req) {
    log("LISTS: HEAD");
    log(head);
    log("LISTS: REQ");
    log(req);

    start({headers: {'Content-Type': 'text/html'}});
    var row, rows = [];
    while (row = getRow()) {
        rows.push(row);
    }
    // create a html list of artists
    var content = kanso.template('artists.html', req, {rows: rows});

    if (req.client) {
        // if client-side, replace the HTML of the content div with the list
        $('#content').html(content);
        // update the page title
        document.title = 'Artists';
    }
    else {
        // if server-side, return a newly rendered page using the base template
        return kanso.template('base.html', req, {
            title: 'Artists',
            content: content
        });
    }
};
