// ★ – START
// ◀ – STOP

var emit = console.log;

var map = function(p) {
  words = p.match(/[\w\u00C0-\u017F\-,.?!;:'"]+/g);
  words.unshift("★", "★");
  words.push("◀");

  for (var i = 3, len = words.length; i <= len; i++) {
    console.log(words.slice(i-3,i));
    emit(words.slice(i-3,i), 1);
  }
};

p1 = "Im kto większym był tchórzem, z tym większą odwagą nacierał teraz na księdza Kordeckiego, by nie narażał na zgubę świętego miejsca, stolicy Najświętszej Panny."
p2 = "- Oto ptaszkowie leśni pod opiekę Matki Bożej się udają, a wy zwątpiliście o Jej mocy?"
p3 = "Okrzyki: \"Mamy Częstochowę!... Wysadzimy ten kurnik!\" - przebiegały z ust do ust. Rozpoczęły się uczty i pijatyka."

map(p3);
