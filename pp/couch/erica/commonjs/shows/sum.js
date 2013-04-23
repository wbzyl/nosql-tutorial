function(doc, req) {
  var math = require('lib/math');
  log(math.add.toString());

  return "<p>∑_{i=1}^4 i = " + math.add(1,2,3,4) + "</p>";
}
