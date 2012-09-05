function dot(attr) {
  return function(obj) {
    return obj[attr]
  }
}

// https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/Reduce
//
// array.reduce(callback[, initialValue])
//
// [0,1,2,3,4].reduce(function(previousValue, currentValue, index, array) {
//   return previousValue + currentValue;
// });

// Array.prototype.reduce = function(val, func) {
//   var i
//   for (i = 0; i < this.length; i += 1) {
//     val = func(val, this[i])
//   }
//   return val
// }

// select is an Array method that given a test function returns a new
// array made up of only elements in the original array that pass the
// test.

// Array.prototype.select = function(test) {
//     return this.reduce([], function(r, e) {
//         if (test(e)) {
//             return r.concat([e]);
//         } else {
//             return r;
//         }
//     });
// };

// array.filter(callback[, thisObject])
//   callback
//     Function to test each element of the array.
//   thisObject
//     Object to use as this when executing callback.

// function isBigEnough(element, index, array) {
//   return (element >= 10);
// }
// [12,5,8,130,44].filter(isBigEnough);
// filtered is [12,130,44]

// Array.prototype.uniq = function() {
//   return this.reduce(function(list, e) {
//     if (list.indexOf(e) < 0) {
//       return list.concat([e])
//     } else {
//       return list
//     }
//   }, []);
// }

Array.prototype.uniq = function() {
  return this.reduce(function(prev, curr) {
      if (prev.indexOf(curr) < 0) {
        return prev.concat(curr)
      } else {
      return prev } },
    []);
}

// [1,2,1,4,2,6].uniq()
