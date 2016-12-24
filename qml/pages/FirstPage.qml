import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0
import io.thp.pyotherside 1.3
import "../components"

Page {
    id: editorPage

    property int lastLineCount: 0
    property int sizeBackgroundItemMainMenuFirstRow: pullMenu2.width / 4
    property int sizeBackgroundItemMainMenu: pullMenu2.width / 5
    property int sizeBackgroundItem: hotActionsMenu.width / 5 //TODO rewrite?
    property string filePath: "" //"autosave" //TODO сделать предзагрузку последнего открытого
    property bool saveFlag: false

    property bool searched: false


    Notification {
        id: outputNotifications
        category: "Editor."
    }


    function setFilePath(filePathFromChooser) {
        filePath = filePathFromChooser;
        pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePathFromChooser}, PageStackAction.Animated);
        pageStack.nextPage();
    }

    //TODO rewrite (delete)
    function saveAsSetFilePath(filePathFromChooser) {
        filePath = filePathFromChooser;
        pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePathFromChooser}, PageStackAction.Animated);
        pageStack.nextPage();
        if (filePath!=="") { //TODO delete if
            py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
        }
        py.call('editFile.openings', [filePath], function(result) {//filePath is path where file that you want to open is
            myTextArea.text = result;
        });

        outputNotifications.close()
        outputNotifications.previewBody = qsTr("Document saved!")
        outputNotifications.publish()
    }

    function numberOfLines() {
        var count = (myTextArea.text.match(/\n/g) || []).length;
        count += 1;
        return count;
    }

    function lineNumberChanged() {
        if (myTextArea._editor.lineCount > lastLineCount) {
            console.log("Last character = " + myTextArea.text.slice(-1));
            if(myTextArea.text.slice(-1) !== "\n") {
                lineNumbers.text += "\n"
            }
            else {
                lineNumbers.text += numberOfLines() + "\n";
            }

            lastLineCount = myTextArea._editor.lineCount;

        } else if (myTextArea._editor.lineCount < lastLineCount) {
            lineNumbers.text = lineNumbers.text.slice(0, -2);
            lastLineCount = myTextArea._editor.lineCount;
        }
    }

    function search(text, position, direction, id) {
        var reg = new RegExp(text, "ig")
        var match = myTextArea.text.match(reg)
        if(direction == "back"){
            myTextArea.cursorPosition = myTextArea.text.lastIndexOf(match[match.length-1], position)
        }else myTextArea.cursorPosition = myTextArea.text.indexOf(match[0],position)
        //id.focus =false
        myTextArea.forceActiveFocus();
    }

    SilicaFlickable {
        id: view
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            Column {
                width: parent.width
                height: childrenRect.height

                Row {
                    id: pullMenu2
                    width: parent.width
                    height: childrenRect.height

                    MenuButton {
                        width: sizeBackgroundItemMainMenuFirstRow
                        mySource: "image://theme/icon-m-acknowledge";
                        myText: qsTr("Save as")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("SaveAsPage.qml"), {
                                               homePath: "/home/nemo",
                                               showFormat: true,
                                               title: "Select file",
                                               showHiddenFiles: showHiddenFiles,
                                               callback: saveAsSetFilePath
                                           })
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenuFirstRow
                        mySource: "image://theme/icon-m-folder";
                        myText: qsTr("Open")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("FileChooserPage.qml"), {
                                               homePath: "/home/nemo",
                                               showFormat: true,
                                               title: "Select file",
                                               showHiddenFiles: showHiddenFiles,
                                               callback: setFilePath
                                           })
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenuFirstRow
                        mySource: "image://theme/icon-m-note";
                        myText: qsTr("New")
                        onClicked: {
                            //TODO ask:Are you sure?
                            filePath = "";
                            myTextArea.text = "";
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenuFirstRow
                        mySource: "image://theme/icon-m-document";
                        myText: qsTr("History")
                        onClicked: {
//                            pageStack.push(Qt.resolvedUrl("HistoryPage.qml"), {
//                                               currentFilePath: filePath,
//                                               callback: setFilePath
//                                           })
                        }
                    }

                }


                Row {
                    width: parent.width
                    height: childrenRect.height
                    spacing: Theme.paddingSmall

                    SearchField{
                        id:searchField
                        width: parent.width / 1.5
                        height: Theme.itemSizeSmall
                        font.pixelSize: Theme.fontSizeTiny
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        placeholderText: qsTr("Search")
                        EnterKey.onClicked:{
                            //flipable.search(text,0,"forward",searchField);
                            search(text,0,"forward",searchField);
                            searched=true
                        }
                        onTextChanged: searched = false
                    }

                    IconButton {
                        id:previous
                        icon.source: "image://theme/icon-m-previous"
                        height: searchField.height
                        enabled: searched
                        onClicked:{
                            //flipable.search(searchField.text,myTextArea.cursorPosition-1,"back",previous);
                            search(searchField.text,myTextArea.cursorPosition-1,"back",previous);
                            myTextArea.forceActiveFocus();
                        }
                        visible:searchField.activeFocus || searchField.text.length>0
                    }
                    IconButton {
                        id:next
                        icon.source: "image://theme/icon-m-next"
                        height: searchField.height
                        enabled: searched
                        onClicked:{
                            //flipable.search(searchField.text,myTextArea.cursorPosition+1,"forward",next);
                            search(searchField.text,myTextArea.cursorPosition+1,"forward",next);
                            myTextArea.forceActiveFocus();
                        }
                        visible:searchField.activeFocus || searchField.text.length>0
                    }
                }


                Row {
                    id: pullMenu
                    width: parent.width
                    height: childrenRect.height

                    MenuButton {
                        width: sizeBackgroundItemMainMenu
                        mySource: "image://theme/icon-m-acknowledge";
                        myText: qsTr("Save")
                        enabled: saveFlag
                        onClicked: {
                            if (filePath!=="") {
                                py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!

                                outputNotifications.close()
                                outputNotifications.previewBody = qsTr("Document saved!")
                                outputNotifications.publish()
                                saveFlag = false;
                            }

                            if (filePath==="") {
                                outputNotifications.close()
                                outputNotifications.previewBody = qsTr("Document can`t be saved!")
                                outputNotifications.publish()
                            }
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenu
                        mySource: "image://theme/icon-m-keyboard";
                        myText: qsTr("R-only")
                        onClicked: {
                            if (myTextArea.readOnly == false) {
                                myTextArea.readOnly = true;
                            }
                            else {
                                myTextArea.readOnly = false;
                            }
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenu
                        mySource: "image://theme/icon-m-rotate-left";
                        myText: qsTr("Undo")
                        onClicked: {
                            //myTextArea.undo();
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenu
                        mySource: "image://theme/icon-m-rotate-right";
                        myText: qsTr("Redo")
                        onClicked: {
                            //myTextArea.redo();
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenu
                        mySource: "image://theme/icon-m-forward";
                        myText: qsTr("Tab")
                        onClicked: {
                            var previousCursorPosition = myTextArea.cursorPosition;
                            myTextArea.text = myTextArea.text.slice(0, myTextArea.cursorPosition) + "\t" + myTextArea.text.slice(myTextArea.cursorPosition, myTextArea.text.length);
                            myTextArea.cursorPosition = previousCursorPosition + 1;

                        }
                    }

                }
            }

            MenuLabel {
                text: filePath
            }

//            MenuItem {
//                text: filePath
//                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
//                font.pixelSize: Theme.fontSizeTiny
//            }
//            https://supportforums.blackberry.com/t5/Native-Development/How-to-access-ClipBoard-from-QML/td-p/2074663

        }


        PageHeader {
            id: header
            height: hotActionsMenu.height
            visible: headerVisible

            Row {
                id: hotActionsMenu
                width: parent.width
                height: childrenRect.height

                MenuButton {
                    width: sizeBackgroundItem
                    mySource: "image://theme/icon-m-acknowledge";
                    myText: qsTr("Save")
                    enabled: saveFlag
                    onClicked: {
                        if (filePath!=="") {
                            py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!

                            outputNotifications.close()
                            outputNotifications.previewBody = qsTr("Document saved!")
                            outputNotifications.publish()
                            saveFlag = false;
                        }

                        if (filePath==="") {
                            outputNotifications.close()
                            outputNotifications.previewBody = qsTr("Document can`t be saved!")
                            outputNotifications.publish()
                        }
                    }
                }

                MenuButton {
                    width: sizeBackgroundItem
                    mySource: "image://theme/icon-m-keyboard";
                    myText: qsTr("R-only")
                    onClicked: {
                        if (myTextArea.readOnly == false) {
                            myTextArea.readOnly = true;
                        }
                        else {
                            myTextArea.readOnly = false;
                        }
                    }
                }

                MenuButton {
                    width: sizeBackgroundItem
                    mySource: "image://theme/icon-m-rotate-left";
                    myText: qsTr("Undo")

                    onClicked: {
                        //myTextArea.undo();
                    }
                }

                MenuButton {
                    width: sizeBackgroundItem
                    mySource: "image://theme/icon-m-rotate-right";
                    myText: qsTr("Redo")

                    onClicked: {
                        //myTextArea.redo();
                    }
                }

                MenuButton {
                    width: sizeBackgroundItem
                    mySource: "image://theme/icon-m-forward";
                    myText: qsTr("Tab")
                    onClicked: {
                        var previousCursorPosition = myTextArea.cursorPosition;
                        myTextArea.text = myTextArea.text.slice(0, myTextArea.cursorPosition) + "\t" + myTextArea.text.slice(myTextArea.cursorPosition, myTextArea.text.length);
                        myTextArea.cursorPosition = previousCursorPosition + 1;

                    }
                }

//                Label {
//                    width: sizeBackgroundItem
//                }
//                Label {
//                    width: sizeBackgroundItem
//                }

//                Item {
//                    width: sizeBackgroundItemMainMenu
//                    height: Theme.itemSizeSmall
//                    Image {
//                        id: saveFlag
//                        width: Theme.iconSizeSmallPlus
//                        height: Theme.iconSizeSmallPlus
//                        anchors.centerIn: parent
//                        source: "image://theme/icon-s-edit"
//                        visible: false
//                    }
//                }
            }
        }


        SilicaFlickable {
            id: editorView
            anchors.fill: parent
            anchors.topMargin: header.visible ? header.height : 0 // для сдвига при отключении quick actions menu
            contentHeight: myTextArea.height
            clip: true

            Label {
                id: lineNumbers
                y: 8
                height: myTextArea.height
                color: Theme.secondaryHighlightColor
                font.pixelSize: fontSize
                text: "1"
                visible: lineNumbersVisible
            }
            TextArea {
                id: myTextArea
                width: parent.width
                font.family: fontType
                font.pixelSize: fontSize
                background: null
                selectionMode: TextEdit.SelectCharacters
                //color: "green"
                focus: true
                onTextChanged: {
                    console.log("filePath = " + filePath, fontSize, font.family);
                    console.log("Real lines: " + myTextArea._editor.lineCount);
                    saveFlag = true;

                    //For line numeration: //TODO: BUG: В начале неправильно определяет количество строк + он длинную строчку (с автоматическим переносом) считает за несколько строк
                     //console.log(font.pixelSize, myTextArea._editor.lineCount);
                    lineNumberChanged();

                    //For cover:
                    charNumber = myTextArea.text.length;
                    linesNumber = numberOfLines();

                    //Autosave
                    if (filePath!=="") {
                        py.call('editFile.autosave', [filePath,myTextArea.text], function(result) {});
                    }
                }
                onRotationChanged: {
                    //TODO пересчитать label
                }
            }
            VerticalScrollDecorator { flickable: editorView }
        }
    }


    onStatusChanged: {
        if(status !== PageStatus.Active){
            return
        }else{
            console.log(filePath)
            if (filePath!=="") {
                py.call('editFile.openings', [filePath], function(result) {//filePath is path where file that you want to open is
                    myTextArea.text = result;
                });
            }
        }
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
        }
        onReceived: console.log('Unhandled event: ' + data)
    }
}
