var PATH_TO_JSON = "/home/nemo/.local/share/harbour-editor/editor.json"         //"js/editor.json"; // TODO перенести json в другую локацию + переименовать файл json + JsonParse.js

function getValue(key) {

    var jsonObject; // = JSON.parse(PATH_TO_JSON);
    try {
        jsonObject = JSON.parse(PATH_TO_JSON);
    } catch (e) {
        //return false;
        createJson();
        jsonObject = JSON.parse(PATH_TO_JSON);
    }
    //var jsonObject = JSON.parse(' {"headerVisible": true, "lineNumbersVisible": false} ');

    console.log(jsonObject);
	return jsonObject[key]; //TODO: проверить, то правильно передается key	
}

function setValue(key, value){
    var jsonObject = JSON.parse(PATH_TO_JSON);
	jsonObject[key] = value;
}

function createJson() {
//    var fs = require('fs');
//    var dir = '/home/nemo/.local/share/harbour-editor';

//    if (!fs.existsSync(dir)){
//        fs.mkdirSync(dir);
//    }

    var file = new File(PATH_TO_JSON);
    //Todo add /n
    var str = '{' +
            '"headerVisible": true,' +
            '"lineNumbersVisible": false,' +
            '"fontType": "Theme.fontFamily",' +
            '"fontSize": "Theme.fontSizeMedium",' +
            '"showHiddenFiles": false,' +
            '"history": [' +
            '"/home/nemo/Documents/notes.txt",' +
            '"/home/nemo/Documents/test.txt"' +
            ']' +
            '}';

    file.open("w"); // open file with write access
    file.write(str);
    file.close();
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
