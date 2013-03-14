
conn = new Mongo();
db = conn.getDB("test");

db.people.drop();

db.people.save({
	"imie":"Marian", 
	"nazwisko":"Pazdzioch",
	"wiek":54,
	"zarobki":1400,
	"adres":{
		"miasto":"Wroclaw",
		"ulica":"Zlodziei",
		"nr":5,
		"kod":"32-012"
	},
	"cechy": ["stary", "lysy", "oszust"]
});

db.people.save({
	"imie":"Helena", 
	"nazwisko":"Pazdzioch",
	"wiek":48,
	"zarobki":1000,
	"adres":{
		"miasto":"Wroclaw",
		"ulica":"Zlodziei",
		"nr":5,
		"kod":"32-012"
	},
	"cechy": ["kobieta", "pracujaca", "jedza"]
});

db.people.save({
	"imie":"Ferdynand", 
	"nazwisko":"Kiepski",
	"wiek":51,
	"zarobki":0,
	"adres":{
		"miasto":"Wroclaw",
		"ulica":"Zlodziei",
		"nr":5,
		"kod":"32-012"
	},
	"cechy": ["stary", "nierob", "pijak"]
});

db.people.save({
	"imie":"Waldemar", 
	"nazwisko":"Kiepski",
	"wiek":32,
	"zarobki":500,
	"adres":{
		"miasto":"Wroclaw",
		"ulica":"Zlodziei",
		"nr":5,
		"kod":"32-012"
	},
	"cechy": ["uposledzony", "przyglup", "pijak", "nierob"]
});

db.people.save({
	"imie":"Mariusz", 
	"nazwisko":"Kosmita",
	"wiek":90,
	"zarobki":1000,
	"adres":{
		"miasto":"Kociuby Male",
		"ulica":"Zakrecona",
		"nr":35,
		"kod":"02-701"
	},
	"cechy": ["kozak", "ufoludek", "przyglup"]
});

db.people.save({
	"imie":"Mieczyslaw", 
	"nazwisko":"Parapet",
	"wiek":43,
	"zarobki":5000,
	"adres":{
		"miasto":"Stare Zapiekanki",
		"ulica":"Zachlapana",
		"nr":21,
		"kod":"42-722"
	},
	"cechy": ["pijak", "zlodziej"]
});

db.people.save({
	"imie":"Helmut", 
	"nazwisko":"Wunderbaum",
	"wiek":82,
	"zarobki":10000,
	"adres":{
		"miasto":"Berlin",
		"ulica":"Luftfaust",
		"nr":104,
		"kod":"13-666"
	},
	"cechy": ["szkop", "ssman"]
});

db.people.save({
	"imie":"Rocky", 
	"nazwisko":"Balboa",
	"wiek":49,
	"zarobki":50000,
	"adres":{
		"miasto":"NewYork",
		"ulica":"Wall Street",
		"nr":1933,
		"kod":"13-8933"
	},
	"cechy": ["bokser", "sepleni"]
});

db.people.save({
	"imie":"Halinka", 
	"nazwisko":"Kiepski",
	"wiek":45,
	"zarobki":1600,
	"adres":{
		"miasto":"Wroclaw",
		"ulica":"Zlodziei",
		"nr":5,
		"kod":"32-012"
	},
	"cechy": ["kobieta", "pracujaca"]
});

/*Dolaczanie i wykluczanie pol */
p1 = db.people.aggregate({
	$project:{
		_id: 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1
	}}
);

/* Pola dodatkowe */
p2 = db.people.aggregate({
	$project:{
		_id: 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		pole_dodatkowe: {$add:["$wiek", "$zarobki"]},
		z_wrocalwia: {$eq:["$adres.miasto", "Wroclaw"]}
	}}
);

/* Zmiana nazwy pol */
p3 = db.people.aggregate({
	$project:{
		_id: 0,
		name: "$imie",
		surname: "$nazwisko",
		age: "$wiek",
		earnings: "$zarobki",
		pole_dodatkowe: {$add:["$wiek", "$zarobki"]},
	}}
);

/* Zagniezdzone dokumenty */
p4 = db.people.aggregate({
	$project:{
		_id: 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		adres: 1,
		miasto: "$adres.miasto",
		ulica: "$adres.ulica"
	}}
);

/* Operacje arytmetyczne */
p5 = db.people.aggregate({
	$project:{
		_id: 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		dodawanie: {$add:["$wiek", "$zarobki"]},
		odejmowanie: {$subtract:["$wiek", "$zarobki"]},
		mnozenie: {$multiply:["$wiek", "$zarobki"]},
		dzielenie: {$divide:["$wiek", "$zarobki"]},
		cos: {$multiply:[2,{$divide:["$wiek", "$zarobki"]}]}
	}}
);

/**** $match ****/

/* Osoby o nazwisko Kiepski i wieku z przedzialu 30-50 lat z miasta Wroclaw*/
p6 = db.people.aggregate({
	$project:{
		_id: 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		miasto: "$adres.miasto"
	}},{
	$match:{
		nazwisko: "Kiepski",
		wiek: {$gte: 30, $lte: 50},
		miasto: "Wroclaw"
	}}
);

/* Dluzszy lancuszek aggregate({$project:},{$match:},{$project:},{$match:}....) */
p7 = db.people.aggregate({
	$project:{
		_id: 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		miasto: "$adres.miasto"
	}},{
	$match:{
		nazwisko: "Kiepski",
		wiek: {$gte: 30, $lte: 50},
		miasto: "Wroclaw"
	}},{
	$project:{
		imie: 1,
		wiek: 1
	}}
);

/**** $group ****/

/* Prosty count osob o tym samym nazwisku */
p8 = db.people.aggregate({
	$project:{
		_id : 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		miasto: "$adres.miasto"
	}},{
	$group:{
		_id: "$nazwisko",
		liczba_osob: {$sum: 1}
	}}
);

/* Zarobki wg nazwiska */
p9 = db.people.aggregate({
	$project:{
		_id : 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		miasto: "$adres.miasto"
	}},{
	$group:{
		_id: "$nazwisko",
		liczba_osob: {$sum: 1},
		zarobki_w_rodzinie: {$sum: "$zarobki"},
	}}
);

/* Zarobki wg nazwiska z liczba osob > 1 */
p10 = db.people.aggregate({
	$project:{
		_id : 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		miasto: "$adres.miasto"
	}},{
	$group:{
		_id: "$nazwisko",
		liczba_osob: {$sum: 1},
		zarobki_w_rodzinie: {$sum: "$zarobki"},
	}},{
	$match:{
		liczba_osob: {$gt: 1}
	}}
);
/* Zarobki na osobe w rodzinie posortowane malejaco */
p11 = db.people.aggregate({
	$project:{
		_id : 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		miasto: "$adres.miasto"
	}},{
	$group:{
		_id: "$nazwisko",
		liczba_osob: {$sum: 1},
		zarobki_w_rodzinie: {$sum: "$zarobki"},
	}},{
	$match:{
		liczba_osob: {$gt: 1}
	}},{
	$project:{
		nazwisko: 1,
		liczba_osob: 1,
		zarobki_w_rodzinie: 1,
		zarobki_na_osobe: {$divide:["$zarobki_w_rodzinie", "$liczba_osob"]}
	}},{
	$sort:{
		zarobki_na_osobe: -1,
		liczba_osob: -1
	}}
);

/* Najbogatsza rodzina wg zarobkow na osobe */
p12 = db.people.aggregate({
	$project:{
		_id : 0,
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		zarobki: 1,
		miasto: "$adres.miasto"
	}},{
	$group:{
		_id: "$nazwisko",
		liczba_osob: {$sum: 1},
		zarobki_w_rodzinie: {$sum: "$zarobki"},
	}},{
	$match:{
		liczba_osob: {$gt: 1}
	}},{
	$project:{
		nazwisko: 1,
		liczba_osob: 1,
		zarobki_w_rodzinie: 1,
		zarobki_na_osobe: {$divide:["$zarobki_w_rodzinie", "$liczba_osob"]}
	}},{
	$sort:{
		zarobki_na_osobe: -1,
		liczba_osob: -1
	}},{
	$limit: 1
	}
);

/**** $unwind ****/

/* Najprostszy sposob uzycia $unwind */
p13 = db.people.aggregate({
	$project:{
		imie: 1,
		nazwisko: 1,
		cechy: 1
	}},{
	$unwind: "$cechy"
	}
);

/* Zliczenie osob posiadajacych kazda z cech, posortowane malejaca, 
 * wraz z srednim wiekiem osob w danej grupie */
p14 = db.people.aggregate({
	$project:{
		imie: 1,
		nazwisko: 1,
		wiek: 1,
		cechy: 1
	}},{
	$unwind: "$cechy"
	},{
	$group:{
		_id: "$cechy",
		liczba_osob: {$sum: 1},
		najmlodsza: {$min: "$wiek"},
		najstarsza: {$max: "$wiek"},
		sredni_wiek: {$avg: "$wiek"}
	}},{
	$match:{
		liczba_osob: {$gt: 1}
	}},{
	$sort: {
		liczba_osob: -1
	}}
);
