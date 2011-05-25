t = db.scope;
t.drop();

t.save( { tags : [ "a" , "b" ] } );
t.save( { tags : [ "b" , "c" ] } );
t.save( { tags : [ "c" , "a" ] } );
t.save( { tags : [ "b" , "c" ] } );

m = function() {
  this.tags.forEach(function(tag) {
    emit(tag , xx); // zmienna globalna
  });
};

r = function(key, values) {
  var total = 0;
  values.forEach(function(count) {
    total += count;
  });
  return total;
};

res = t.mapReduce( m, r, {scope: {xx: 2}, out: "scope.out"} );
z = res.convertToSingleObject()

printjson(res);
printjson(z);

assert.eq( 4 , z.a, "liczbie wystąpień 'a' × 2" );
assert.eq( 6 , z.b, "liczbie wystąpień 'b' × 2" );
assert.eq( 6 , z.c, "liczbie wystąpień 'c' × 2" );

res.drop();
t.drop();
