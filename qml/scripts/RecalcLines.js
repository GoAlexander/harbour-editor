WorkerScript.onMessage = function(query) {

    var line
    var result = "";

    for(var i = 0; i < query.myTextArea;i++ )
       {
        line=query.documentHandler[i];
        if(line == " "){result += "\n";}
        else{
            result += line + "\n";
         }
        }
    WorkerScript.sendMessage({'queryResult': result})
}
