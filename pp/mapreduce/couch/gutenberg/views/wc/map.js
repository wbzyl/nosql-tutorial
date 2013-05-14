function(doc) {
  var words = doc.text.toLowerCase().match(/[A-Za-z\u00C0-\u017F]+/g);
  words.forEach(function(word) {
    emit([word, doc.title], 1);
  });
}
