function(doc, req) {
  var math = require('lib/math');
  log(math.add.toString());

  return "<p>1 + 2 + 3 + 4 = " + math.add(1,2,3,4) + "</p>";
}
