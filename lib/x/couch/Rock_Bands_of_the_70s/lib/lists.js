var kanso = require('kanso/core');

exports.all = function (head, req) {

  start({headers: {'Content-Type': 'text/html'}});

  if (req.client) {
    console.log("CLIENT REQUEST:");
    console.log(req);

    var row, rows = [];
    while (row = getRow()) {
      console.log(row);
      //rows.push(row);
      rows.push({title: row.key[1], artist: row.key[0], id: row.id});
    };

    // create a html list of artists
    var content = kanso.template('artists.html', req, {rows: rows});

    // if client-side, replace the HTML of the content div with the list
    $('#content').html(content);
    // update the page title
    //document.title = 'Artists';
  }
  else {
    log("APP REQUEST:");
    log(req);

    // if server-side, return a newly rendered page using the base template
    return kanso.template('base.html', req, {
      title: 'Artists'
    });
  };
};
