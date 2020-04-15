import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0 //org.nemomobile.notifications 1.0
import io.thp.pyotherside 1.5
import harbour.editor.documenthandler 1.0
import QtGraphicalEffects 1.0
import "../components"
import "../components/pullMenus/rows"

Page {
    id: editorPage
    onIsLandscapeChanged: {
        recalculateLineNumber();
    }

    property int lastLineCount: 1
    property int sizeBackgroundItem: hotActionsMenu.width / 5
    property string filePath: ""
    property bool saved: false
    property bool opened
    property string lineText
    property string docencoding
    property int lastcharnumber: 1

    property bool searched: false
    property bool searchRowVisible: false
    property bool mainRowVisible: false

    property string encRegion
    property string encPreferred

    property bool highlightingEnabled: false
    property bool highlightingEnabling: false

    property string extendedMenuSource: "image://theme/icon-m-up"

    onDocencodingChanged: {
        id_lblencoding.text="[" + docencoding + "]";
        id_txtreencode.text = docencoding;
    }

    Notification {
        id: outputNotifications
        category: "Editor."
    }

    BusyIndicator {
        id: busy
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: true
    }

    function saveFilePathToClip (){
                     Clipboard.text = filePath;
                        outputNotifications.close()
                        outputNotifications.previewBody = qsTr("File path copied to the clipboard")
                        outputNotifications.publish()
             }

    function reEncode(newencoding){
        console.log(docencoding + "/" + newencoding);
        openFile(filePath,newencoding);
        back_reencodeanim.start();
    }

    function openFile(filePath,encode){
        py.call('editFile.openings', [filePath,encode], function(result) {
            documentHandler.text = result[0];
            docencoding=result[1];
            outputNotifications.close()
            outputNotifications.previewBody = qsTr("Opened file's encoding: [" + result[1] + "]");
            outputNotifications.publish()
            id_lblfile.text = filePath;
            setToHistory(filePath,result[1])
        });
        opened = true;
    }

    function setVariables(readOnly){
        myTextArea.readOnly = readOnly
    }


    function pageStatusChange(page){
        if(highlightingEnabled == true){
        console.log(getFileType(filePath)); //Debug
        documentHandler.setStyle(propertiesHighlightColor, stringHighlightColor,
                                 qmlHighlightColor, javascriptHighlightColor,
                                 commentHighlightColor, keywordsHighlightColor,
                                 myTextArea.font.pixelSize);

        documentHandler.setDictionary(getFileType(filePath)); //enable appropriate dictionary file
    //    pageStack.replaceAbove(null, Qt.resolvedUrl("../../pages/FirstPage.qml"), {filePath: filePath, highlightingEnabled: highlightingEnabled}, PageStackAction.Replace)
            outputNotifications.previewBody = qsTr("Highlighting enabled");
        }
        else{
            documentHandler.setStyle(textColor, textColor, textColor, textColor, textColor,
                                     textColor, myTextArea.font.pixelSize);
            documentHandler.setDictionary("plain");
            outputNotifications.previewBody = qsTr("Highlighting disabled");
         //   outputNotifications.publish();
        }
        outputNotifications.close()
        outputNotifications.publish();
    }

    function setToHistory(filePath, encoding){
        //add new unique path to history (json)
        var result
        result=py.call_sync('editFile.getHistory');
            var openedFiles = [];
            var encodings = [];
            var fileexists
            openedFiles = result.file;
            encodings = result.encd;
            console.log (filePath + " , " + encoding);
            fileexists = openedFiles.indexOf(filePath)
            if (fileexists === -1) {
                openedFiles.push(filePath);
                encodings.push(encoding);
                py.call('editFile.setHistory', [openedFiles,encodings], function(result) {});
            }
            else
            {
               encodings[fileexists] = encoding;
                py.call('editFile.setHistory', [openedFiles,encodings], function(result) {});
            }
    }

    function setFilePath(filePathFromChooser) { //TODO refactoring of this function (it uses ALSO HistoryPage)
        filePath = filePathFromChooser;
        var result
        result=py2.call_sync('editFile.getSettings');
        encRegion=result.encRegion;
        encPreferred=result.encPreferred;

        pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePathFromChooser, encPreferred: encPreferred, encRegion:encRegion }, PageStackAction.Animated);
        pageStack.nextPage();
    }

    //TODO rewrite (delete)
    function saveAsSetFilePath(filePathFromChooser,encodeFromChooser) {
        var result
        filePath = filePathFromChooser;
        docencoding=encodeFromChooser;
        console.log("save as: " + encodeFromChooser);
        pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePathFromChooser, docencoding: docencoding}, PageStackAction.Animated);
        pageStack.nextPage();
        if (filePath!=="") {
            result = py.call_sync('editFile.savings', [filePath,myTextArea.text,docencoding]);
                outputNotifications.close()
                outputNotifications.previewBody = qsTr("Document saved!")
                outputNotifications.publish()
            console.log(result);
        }
        openFile(filePath, docencoding);
    }

    function numberOfLines() {
        var count = (myTextArea.text.match(/\n/g) || []).length;
        var length
        count += 1;
        length = (count.toString().length) + 1;
        lastcharnumber = length;
        return count;
    }

    WorkerScript {
        id: workerRecalc
        source: "../scripts/RecalcLines.js"

        onMessage: {
            lineNumbers.text = messageObject.queryResult;
            if(lastLineCount == 1){lastLineCount=myTextArea._editor.lineCount+1;}
        }
    }

    function recalculateLineNumber(){
         workerRecalc.sendMessage({ 'myTextArea': myTextArea._editor.lineCount, 'documentHandler': documentHandler.lines })
    }

    function lineNumberChanged() {
        if (myTextArea._editor.lineCount !== lastLineCount) {

            lastLineCount = myTextArea._editor.lineCount;
            console.log(lineNumbers.x);
            recalculateLineNumber();
        }
    }

    //for syntax highlighting
    function getFileType(text) {
        return text.substr(text.lastIndexOf('.') + 1 )
    }

    //Function for cover
    function getName(text) {
        return text.substr(text.lastIndexOf('/') + 1 );
    }
    //Function for cover
    function wordsCounter(text) {
        try {
            return text.match(/\S+/g).length
        }
        catch (ex) {
            return 0
        }
    }

    Rectangle {
        id: background
        color: "#1e1e27"//bgColor
        opacity: 0.6
        anchors.fill: parent
        visible: true
    }
        SilicaFlickable {
            id: view
            anchors.fill: parent

            PushUpMenu {
                MenuItem {
                    text: qsTr("Settings")
                    onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }
            Rectangle{anchors.fill: header; color: "#1e1e27"; opacity: 0.6}
            Row {

                id: header
                height: hotActionsMenu.height
                width: isPortrait ? Screen.width : Screen.height
                anchors.bottom: parent.bottom
                visible: headerVisible || searchRowVisible //header visible if EditRow active or SearchRow active

                EditRow {
                    id: hotActionsMenu
                    width: parent.width
                    height: Theme.itemSizeSmall
                    myMenuButtonWidth: sizeBackgroundItem
                    visible: !searchRowVisible
                }

                SearchRow {
                    width: parent.width
                    height: Theme.itemSizeSmall
                    visible: searchRowVisible
                }
            }

            Rectangle{
                id: extrabutton
                opacity: 0.6
                anchors {bottom: id_mainrow.top; right: parent.right}
                height: Theme.itemSizeExtraSmall
                width: Theme.itemSizeExtraSmall
                color: bgColor
                z: parent.z + 1
             Image {
                source:  extendedMenuSource
                width: parent.width
                height: parent.height
                layer {
                        enabled: true
                        effect:
                          ColorOverlay {
                            cached: true
                            color: buttonsColor
                        }
                      }
                }
             MouseArea {
                    anchors.fill: parent;
                    onClicked:{
                    mainRowVisible=!mainRowVisible;
                    id_ret_lbl.visible=!id_ret_lbl.visible
                    id_lblinfo.visible=!id_lblinfo.visible
                    if(mainRowVisible){extrabutton.opacity = 0.6;extendedMenuSource = "image://theme/icon-m-down";}//extrabutton.color="#1e1e27"}
                    else{extrabutton.opacity = 0.4;extendedMenuSource = "image://theme/icon-m-up";}//extrabutton.color=bgColor}
              }
             }
            }

            ParallelAnimation{
                id:reencodeanim
                alwaysRunToEnd: true
              SequentialAnimation {
                ColorAnimation{target: id_ret_lbl; property: "color"; to: Theme.highlightColor; duration: 150}
                ColorAnimation{target: id_ret_lbl; property: "color"; to: bgColor; duration: 150}
                PropertyAnimation{target: id_lblinfo; property: "opacity"; from: 1.0; to: 0.0; duration: 150 }
              }
                PropertyAnimation{targets:[id_reencode,id_colreencode]; property: "opacity"; from: 0.0; to: 1.0; duration: 300 }
             onStopped: {
                myTextArea.readOnly=true;
                id_ret_lbl.visible=false;
                id_lblfile.visible=false;
                id_lblencoding.visible=false;
               }
            }

            ParallelAnimation{
                id:back_reencodeanim
                alwaysRunToEnd: true
                PropertyAnimation{targets:[id_reencode,id_colreencode]; property: "opacity"; from: 1.0; to: 0.0; duration: 150 }
                PropertyAnimation{target:id_lblinfo; property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
              onStopped: {
                  myTextArea.readOnly=false;
                  id_reencode.visible = false;
                  id_ret_lbl.visible=true;
                  id_lblfile.visible=true;
                  id_lblencoding.visible=true;
              }
            }

            SequentialAnimation {
              id: anim_butt_click
              alwaysRunToEnd: true
              ColorAnimation{target: reenc_butt ; property: "color"; to: Theme.highlightColor; duration: 150}
              ColorAnimation{target: reenc_butt ; property: "color"; to: "slategrey"; duration: 150}
              onStopped: {
                  reEncode(id_txtreencode.text);
              }
            }

            Rectangle{
                id: id_ret_lbl
                visible: false
                opacity: 0.6
                anchors {bottom: extrabutton.top; right: parent.right}
                height: Screen.height
                width: Theme.itemSizeExtraSmall
                color: "#1e1e27"//bgColor
                z: parent.z + 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                           if(filePath !==""){
                                  saveFilePathToClip();
                              }
                           }
                    onPressAndHold: {
                     if(filePath !==""){
                        id_reencode.visible = true;
                        reencodeanim.start();
                      }
                    }
                }
            }

            Column{
                id: id_lblinfo
                visible: false
                anchors {bottom: extrabutton.top; right: parent.right}
                height: Theme.itemSizeExtraSmall
                width: Theme.itemSizeExtraSmall
                z: parent.z + 1
                rotation: 270

                Label{
                    id: id_lblfile
                    opacity: 0.85
                    height: Theme.itemSizeExtraSmall /2
                    verticalAlignment: Text.AlignBottom
                    font.pixelSize: Theme.fontSizeExtraSmall * 0.9
                    font.bold: true
                    color: Qt.darker(buttonsColor,1.3)
                    elide: "ElideRight"
                    text: "FileName"
                    leftPadding: Theme.fontSizeTiny
                }
                Label{
                    id: id_lblencoding
                    opacity: 0.85
                    height: Theme.itemSizeExtraSmall /2
                    verticalAlignment: Text.AlignTop
                    font.pixelSize: Theme.fontSizeExtraSmall * 0.9
                    font.italic: true
                    color: Qt.lighter(buttonsColor)
                    text: "Encoding"
                    leftPadding: Theme.fontSizeTiny
                }
            }

            Rectangle {
                id: id_reencode
                opacity: 0.0
                anchors {left: parent.left; right: parent.right; top: parent.top; topMargin: isPortrait ? (Screen.height / 3.5) : 0}
                height: Theme.itemSizeExtraLarge
                color: bgColor//"grey"
                visible: false
                z: parent.z +1
             Column{
                 id: id_colreencode
                Label{
                    width: parent.width
                    z: parent.z +1
                    font.bold: true
                    color: buttonsColor
                    text: "Open the file with different encoding"
                }
                TextField{
                    id:id_txtreencode
                    width: isPortrait ? Screen.width - Theme.itemSizeMedium : Screen.height - Theme.itemSizeMedium
                    z: parent.z +1
                    text: docencoding
                    color: buttonsColor
                    labelVisible: false
                    Keys.onReturnPressed: {
                        reEncode(text);
                    }
                }
              }
             Rectangle{
                 id: reenc_butt
                 color: "slategrey"
                 width: Theme.itemSizeMedium
                 height: width
                 anchors {right: parent.right; verticalCenter: parent.verticalCenter}
               Image{
                 anchors.margins: Theme.paddingMedium
                 anchors.fill: parent;
                 source: "image://theme/icon-m-forward"
                 fillMode: Image.PreserveAspectFit
                }
               MouseArea{
                  anchors.fill: parent;
                  onClicked: {
                      anim_butt_click.start();
                  }
                }
              }
            }

            MainRow {
                id: id_mainrow
                anchors {left:parent.left; right: parent.right; bottom: header.top}
                width: parent.width
                height: mainRowVisible ? Theme.itemSizeSmall : 0
                opacity: mainRowVisible ? 1.0 : 0.0
                visible: mainRowVisible
                z: parent.z + 1

                Behavior on height {
                    PropertyAnimation { duration: 250; easing.type: Easing.Linear }
                }
                Behavior on opacity {
                    PropertyAnimation { duration: 250; easing.type: Easing.Linear }
                }
            }

            SilicaFlickable {
                id: editorView
                anchors.fill: parent
                anchors.bottomMargin: header.visible ? header.height : 0 // для сдвига при отключении quick actions menu
                contentHeight: myTextArea.height
                clip: true

                Label {
                    id: lineNumbers
                    y: myTextArea.y + ((isPortrait ? Screen.height : Screen.width )/ 160) //12
                    height: myTextArea.height + Theme.itemSizeSmall
                    wrapMode: TextEdit.NoWrap
                    horizontalAlignment: TextEdit.AlignLeft
                    width: fontSize * 2
                    color: Theme.secondaryHighlightColor
                    font.family: fontType
                    font.pixelSize: fontSize
                    visible: lineNumbersVisible
                    z:myTextArea.z +1
                }

                TextArea {
                    id: myTextArea
                    width: parent.width - lineNumbers.width
                    anchors {right: parent.right}
                    font.family: fontType
                    font.pixelSize: fontSize
                    textLeftMargin: 0
                    horizontalAlignment: TextEdit.AlignLeft
                    background: null
                    selectionMode: TextEdit.SelectCharacters
                    color: focus ? textColor : Theme.primaryColor
                    focus: true

                    text: documentHandler.text //for highlighting

                    onTextChanged: {
                        saved = false;
           //             console.log(opened);
                        if(opened == true){
                            opened = false;
                            lastLineCount = myTextArea._editor.lineCount;
                            recalculateLineNumber();
                        }
                        //lineNumbers counter
                        else{
                            lineNumberChanged();
                        }
                        if(lineNumbers.text ==""){
                            lineNumbers.text = "1\n";
                        }
                        //For cover:
                        charNumber = myTextArea.text.length;
                        linesNumber = numberOfLines();
                        wordsNumber = wordsCounter(myTextArea.text);
                        fileName = getName(filePath);

                        //Autosave
                        if (autosave) {
                            if (filePath!=="" && documentHandler.text !== "") {
                                py.call('editFile.autosave', [filePath, myTextArea.text,docencoding], function(result) {}); // written myTextArea.text to fix autosaving
                            }
                        }
                    }

                    DocumentHandler {
                        id: documentHandler
                        target: myTextArea._editor
                        cursorPosition: myTextArea.cursorPosition
                        selectionStart: myTextArea.selectionStart
                        selectionEnd: myTextArea.selectionEnd
                        onTextChanged: {
                            myTextArea.text = documentHandler.text
                            myTextArea.update()
                        }
                    }

                }
                VerticalScrollDecorator { flickable: editorView }
            }


        }
   // }

    onStatusChanged: {
        busy.running=true;

        if (status !== PageStatus.Active) {
            return
        } else {
            if (filePath!=="") {
                // docencoding will be empty when opening file from open dialog
                // docencoding will have data of opened file when opening from history, or getting back f.e. from settings
                if(docencoding==""){
                // takes stuff from settings, if manual sets preferred encoding from settings, region types are switched within editFile.py
                    if(encRegion=="Manual"){
                        docencoding=encPreferred;
                    }
                    else if (encRegion=="Auto"){
                        docencoding="Auto";
                    }
                    else{
                        docencoding=encRegion;
                    }
                }
                openFile(filePath,docencoding);
                recalculateLineNumber();
            }
        }
        busy.running=false;
    }

    Python {
        id: py

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../.'));
            importModule('editFile', function () {});
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
            outputNotifications.close()
            outputNotifications.previewBody = qsTr("Error while opening/saving the file");
            outputNotifications.publish()
        }

        onReceived: console.log('Unhandled event: ' + data)
    }

}
