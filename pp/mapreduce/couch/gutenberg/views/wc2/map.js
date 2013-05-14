function(doc) {
  var words = doc.text.toLowerCase().match(/[A-Za-z\u00C0-\u017F]+/g);
  words.forEach(function(word) {
    emit([doc.title, word], 1);
  });
}
