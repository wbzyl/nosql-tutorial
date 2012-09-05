var couchapp = require('couchapp')
  , path = require('path')
  , fs = require('fs');

ddoc = {
  _id: '_design/test'
  , views: {}
  , lists: {}
  , shows: {}
  , templates: {}
}

module.exports = ddoc;

ddoc.views.cloud = {
  map: function(doc) {
    var retweeted = /\b(via|RT)\s*(@\w+)/ig;
    var match = retweeted.exec(doc.text);
    if (match != null) {
      emit([match[2].toLowerCase(), doc.screen_name], null);
    };
  }
}

ddoc.lists.all = function(head, req) {
  var row;
  start({
    "headers": {
      "Content-Type": "text/html"
    }
  });
  while(row = getRow()) {
    // send(JSON.stringify(row));
    send("<p>RT <b>" + row.key[0] + "</b> <a href='http://localhost:5984/nosql-slimmed/" + row.id +"'>" + row.key[1] + "</a></p>\n");
  };
}

ddoc.lists.tweets = function(head, req) {
  var mustache = require('templates/mustache');
  /* this == design document (JSON) zawierający tę funkcję */
  var template = this.templates['tweet.html'];

  var row;
  var rows = [];
  start({
    "headers": {
      "Content-Type": "text/html"
    }
  });
  while(row = getRow()) {
    // {"id":"47402480702730240","key":["@_brooklynemm","StephSideris"]
    rows.push({id: row["id"], author: row.key[0] , tweeterer: row.key[1]});
  };
  var view = {rows: rows};
  var html = mustache.to_html(template, view);
  return html;}


ddoc.templates.mustache = fs.readFileSync('templates/mustache.js', 'UTF-8');
ddoc.templates['tweet.html'] = fs.readFileSync('templates/tweet.html.mustache', 'UTF-8');


couchapp.loadAttachments(ddoc, path.join(__dirname, 'attachments'));

// couchapp push tweets.js http://localhost:5984/nosql-slimmed
// curl 'http://localhost:5984/nosql-slimmed/_design/test/_view/cloud?limit=2'
// {"total_rows":5205,"offset":0,"rows":[
// {"id":"47402480702730240","key":["@_brooklynemm","StephSideris"],"value":null},
// {"id":"49327072274948097","key":["@_felipera","mumoshu"],"value":null}
// ]}

// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/cloud?limit=2'
// <p>RT <b>@_brooklynemm</b> <a href='http://localhost:5984/nosql-slimmed/47402480702730240'>StephSideris</a></p>
// <p>RT <b>@_felipera</b> <a href='http://localhost:5984/nosql-slimmed/49476940209455104'>cameronhunter</a></p>

// curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/tweets/cloud?limit=2'
// {"id":"47402480702730240","key":["@_brooklynemm","StephSideris"],"value":null}
// {"id":"47731847161057280","key":["@_felipera","kimchy"],"value":null}
