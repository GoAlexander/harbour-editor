function getValue(key) {
	var jsonObject = JSON.parse("harbour-editor.json"); // + перенести json в другую локацию
	return jsonObject[key]; //TODO: проверить, то правильно передается key	
	//return jsonObject.getObj(key);
}

function setValue(key, value){
	var jsonObject = JSON.parse("harbour-editor.json");
	jsonObject[key] = value;
}

//TODO: протестировать в SettingsPage загрузку всего этого!!!
//TODO: доделать еще получение и удаление из массива
//загуглить как return массив и дополнять массив
//Получение массива с помощью getValue(), но как его модифицировать? обдумать...

//By using javasript json parser
//var t = JSON.parse('{"name": "", "skills": "", "jobtitel": "Entwickler", "res_linkedin": "GwebSearch"}');
//alert(t['jobtitel'])
/*
var objectArray = JSON.parse(req.responseText);
if (objectArray.errors !== undefined)
	console.log("Error fetching tweets: " + objectArray.errors[0].message)
else {
	for (var key in objectArray.statuses) {
	    var jsonObject = objectArray.statuses[key];
        tweets.append(jsonObject);
    }
]
*/
