var couchapp = require('couchapp')
, path = require('path');
//, fs = require('fs');

ddoc = {
  _id:   '_design/default'
}

module.exports = ddoc

couchapp.loadAttachments(ddoc, path.join(__dirname, '_attachments'))

// couchapp push hallet.js http://localhost:5984/students
//
//   http://localhost:5984/students/_design/default/index.html
