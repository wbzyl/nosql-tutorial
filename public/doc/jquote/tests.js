(function () {
  this.assert = function(value, desc) {
    print(desc + ' :  ' + (value ? "PASS" : "FAIL"));
  };
  this.test = function(name, callback) {
    print('\n' + name);
    print('----');
    callback();
  };
})();

test ("Testowanie aliasów i wersji.", function () {
  assert($ === jQuote, 'Zmienna $ jest aliasem jQuote');
  assert($.fn === jQuote.fn, 'Zmienna $.fn jest aliasem jQuote.fn');
  assert($.fn === jQuote.init.prototype, 'Zmienna $.fn jest aliasem jQuote.init.prototype');
  assert($.fn.version == '0.0.1', 'aktualna wersja $.fn to 0.0.1');
});

test ("Testowanie selektora $(2)", function () {
  assert($(2).kontekst === dokument, 'this.kontekst === dokument');
  assert($(2)[0] === 2, '$(2)[0] wskazuje na 2');
  assert($(2).length == 1, '$(2).length równa się 1');
  assert($(2).get(0) === dokument[2], '$(2).get(0) wskazuje na dokument[2]');
});

test ("Testowanie selektora $([1,2,4])", function () {
  assert($([1,2,4])[2] == 4, '$([1,2,4])[2] wskazuje na 4');
  assert($([1,2,4]).length == 3, '$([1,2,4]).length równa się 3');
  assert($([1,2,4]).get(2) === dokument[4], '$([1,2,4]).get(2) wskazuje na dokument[4]');
});

test ("Testowanie iteratora $([2,4]).each(function () {})", function () {
  var indeksy = [],
     elementy = [];
  $([2,4]).each(function (e, i) {
    elementy.push(e);
    indeksy.push(i);
  });
  assert(indeksy[0] == 2 && indeksy[1] == 4, 'iteracja po kolekcji: indeksy');
  assert(elementy[0].match(/^Failure/) !== null && 
     elementy[1].match(/^The dumbest/) !== null, 'iteracja po kolekcji: elementy');
  assert( $([2,4]).each(function (e,i) { }).each(function (e,i) { }).length == 2,
    'można składać iteracje');
});

test ("Testowanie selektora $().text()", function () {
    assert($(3).text().match(/^A clever man/) !==null, 'selects text');
    assert($([3,4]).text().match(/^A clever man/) !==null, 'selects only the first item');
    $(3).text('[----]');
    assert(dokument[3] == '[----]', 'set dokument[3] to [----]');
    $([1,4]).text('[----]');
    assert(dokument[1] == '[----]' && dokument[4] == '[----]', 
      'set dokument[1] and dokument[4] to [----]');
});
