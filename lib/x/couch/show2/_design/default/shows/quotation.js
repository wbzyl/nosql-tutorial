function(doc, req) { 
    var mustache = require('templates/mustache');
    var template = this.templates.quotation; /* this == design document (JSON) */

    var html = mustache.to_html(template, {quotation: doc.quotation});
    return html;
}
