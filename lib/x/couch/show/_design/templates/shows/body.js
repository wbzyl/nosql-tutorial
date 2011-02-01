// Zobacz też:
//
//  http://guide.couchdb.org/draft/show.html
//  https://developer.mozilla.org/en/Core_JavaScript_1.5_Guide/Processing_XML_with_E4X

function(doc, req) {
    return '<p>' + doc.body + '</p>\\n';
}
