function raz () {};  // raz.name == 'raz'
var dwa = function  () {};  // dwa.name == 'dwa'
var cztery = function trzy () {};
// trzy.name: ReferenceError: trzy is not defined
// cztery.name == 'trzy'

function each(array, callback) {
  for (var i=0, len = array.length; i < len; i++) {
    print(callback.length);
  };
}
