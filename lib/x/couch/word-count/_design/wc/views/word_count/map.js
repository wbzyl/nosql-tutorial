function(doc) {
    var words = doc.text.toLowerCase().split(/\W+/);
    var len = words.length;
    for (var i = 0; i < len; i++) {
        var word = words[i];
        if (word.length > 0) {
            emit([word, doc.title], 1);
        }
    }
}
