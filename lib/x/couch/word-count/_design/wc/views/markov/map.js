//
// To ease the strain on our keyboards Mozilla recently introduced 
// a handy forEach method for arrays: array.forEach(print);
// see https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/Array/forEach
//
function(doc) {
  var words = doc.text.toLowerCase().
    split(/\W+/).
    filter(function(w) { 
      return w.length > 0; 
    });

  words.forEach(function(word, i) { 
    if (words.slice(i, 4+i).length > 3) {
      emit(words.slice(i, 4+i), null);
    };
  });
}
