dokument = [
  "A goal without a plan is just a wish. (Antoine de Saint-Exupery)",
  "Everything's got a moral, if only you can find it. (Lewis Carroll)",
  "Failure is success if we learn from it. (Malcolm Forbes)",
  "A clever man commits no minor blunders. (Johann Wolfgang von Goethe)",
  "The dumbest people I know are those who know it all. (Malcolm Forbes)",
  "Great ideas often receive violent opposition from mediocre minds. (Albert Einstein)"
];

(function () {

  $ = jQuote = function(selektor) {
    return new jQuote.init(selektor);
  };
  jQuote.init = function(selektor) {
    var elementy; // indeksy elementów z tablicy kontekst
    
    if (typeof selektor == 'number') {
      elementy = [selektor];
    } else if (selektor.constructor === Array) {
      elementy = selektor;
    } else {
      throw('jQuote: nieznany typ selektora (tylko liczba lub tablica liczb');          
    };
    
    this.kontekst = dokument;
    addArray(this, elementy);
    return this;
  };
  $.fn = jQuote.init.prototype = {
    version: '0.0.1',
    get: function(i) {
      return this.kontekst[this[i]];
    },
    each: function(callback) {
      for(var i = 0, len = this.length; i < len; i++)
        callback(this.kontekst[this[i]], this[i]);
      return this;
    },
    text: function() {
      if (arguments.length == 0) {
        return this.get(0);
      } else {
        for(var i = 0, len = this.length; i < len; i++)
          this.kontekst[this[i]] = arguments[0];
        return this;
      };
    }
  };

  // prywatna funkcja pomocnicza
  function addArray(self, array) {
    array.unshift(0, array.length);
    Array.prototype.splice.apply(self, array);
  };    

})();
