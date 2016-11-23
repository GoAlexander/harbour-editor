import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0
import io.thp.pyotherside 1.3
import "../components"

Page {
    id: editorPage

    property int lastLineCount: 0
    property int sizeBackgroundItemMainMenu: pullMenu2.width / 5
    property int sizeBackgroundItem: hotActionsMenu.width / 5 //TODO rewrite?
    property string filePath: "" //"autosave" //TODO сделать предзагрузку последнего открытого


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
                        width: sizeBackgroundItemMainMenu //height: Theme.itemSizeExtraSmall
                        mySource: "image://theme/icon-m-acknowledge";
                        myText: qsTr("Save as")

                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("SaveAsPage.qml"), {
                                               homePath: "/home/nemo",
                                               showFormat: true,
                                               title: "Select file",
                                               callback: saveAsSetFilePath
                                           })
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenu //height: Theme.itemSizeExtraSmall
                        mySource: "image://theme/icon-m-folder";
                        myText: qsTr("Open")

                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("FileChooserPage.qml"), {
                                               homePath: "/home/nemo",
                                               showFormat: true,
                                               title: "Select file",
                                               callback: setFilePath
                                           })
                        }
                    }
                }


                Row {
                    id: pullMenu
                    width: parent.width
                    height: childrenRect.height


                    MenuButton {
                        width: sizeBackgroundItemMainMenu //height: Theme.itemSizeExtraSmall
                        mySource: "image://theme/icon-m-acknowledge";
                        myText: qsTr("Save   ")

                        onClicked: {
                            if (filePath!=="") {
                                py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
                            }

                            outputNotifications.close()
                            outputNotifications.previewBody = qsTr("Document saved!")
                            outputNotifications.publish()
                        }
                    }

//                    MenuButton {
//                        width: sizeBackgroundItemMainMenu //height: Theme.itemSizeExtraSmall
//                        mySource: "image://theme/icon-m-rotate-left";
//                        myText: qsTr("Undo")

//                        onClicked: {
//                            //myTextArea.undo();
//                        }
//                    }

//                    MenuButton {
//                        width: sizeBackgroundItemMainMenu //height: Theme.itemSizeExtraSmall
//                        mySource: "image://theme/icon-m-rotate-right";
//                        myText: qsTr("Redo")

//                        onClicked: {
//                            //myTextArea.redo();
//                        }
//                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenu //height: Theme.itemSizeExtraSmall
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
                }
            }
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
                    width: sizeBackgroundItem //height: Theme.itemSizeExtraSmall
                    mySource: "image://theme/icon-m-acknowledge";
                    myText: qsTr("Save")

                    onClicked: {
                        if (filePath!=="") {
                            py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
                        }

                        outputNotifications.close()
                        outputNotifications.previewBody = qsTr("Document saved!")
                        outputNotifications.publish()
                    }
                }

//                MenuButton {
//                    width: sizeBackgroundItem //height: Theme.itemSizeExtraSmall
//                    mySource: "image://theme/icon-m-rotate-left";
//                    myText: qsTr("Undo")

//                    onClicked: {
//                        //myTextArea.undo();
//                    }
//                }

//                MenuButton {
//                    width: sizeBackgroundItem //height: Theme.itemSizeExtraSmall
//                    mySource: "image://theme/icon-m-rotate-right";
//                    myText: qsTr("Redo")

//                    onClicked: {
//                        //myTextArea.redo();
//                    }
//                }

                MenuButton {
                    width: sizeBackgroundItem //height: Theme.itemSizeExtraSmall
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

//                MenuButton {
//                    width: sizeBackgroundItem //height: Theme.itemSizeExtraSmall
//                    mySource: "image://theme/icon-m-acknowledge";
//                    myText: qsTr("Save")

//                    onClicked: {
//                        if (filePath!=="") {
//                            py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
//                        }
//                    }
//                }
            }
        }


        SilicaFlickable {
            id: editorView
            anchors.fill: parent
            anchors.topMargin:  {
                if (header.visible === true) {
                     editorView.anchors.topMargin=header.height;
                }
                else {
                    editorView.anchors.topMargin=page.height;
                }
            }

            contentHeight: myTextArea.height
            clip: true

            Label {
                id: lineNumbers
                y: 8
                height: myTextArea.height
                color: Theme.secondaryHighlightColor
                font.pixelSize: fontSize //Theme.fontSizeMedium
                text: "1"
                visible: lineNumbersVisible
            }

            TextArea {
                id: myTextArea
                x: {  // TODO фактически компоненты друга на друге :( Нормально?
                    if (lineNumbersVisible === true) {
                        myTextArea.x = 30;
                    }
                    else {
                        myTextArea.x = 0;
                    }
                }
                width: parent.width

                //font.family: "Helvetica" //TODO implements in SettingsPage!
                font.pixelSize: fontSize //Theme.fontSizeMedium
                background: null
                selectionMode: TextEdit.SelectCharacters
                focus: true

                //+при смене ориентации автоматически не переписывает номера строк
                //Хм, считать во всем тексте количество символов переноса строки (а не lineCount)?!
                onTextChanged: { //TODO: BUG: В начале неправильно определяет количество строк + он длинную строчку (с автоматическим переносом) считает за несколько строк
                    //For line numeration:
                    console.log(font.pixelSize, myTextArea._editor.lineCount);
                    console.log("filePath = " + filePath);
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


    Python {
        id: py

        Component.onCompleted: {
            if (filePath!=="") { // || filePath !== "autosave"
                addImportPath(Qt.resolvedUrl('../.'));
                importModule('editFile', function () {
                    py.call('editFile.openings', [filePath], function(result) {//filePath is path where file that you want to open is
                        myTextArea.text = result;
                    });
                });
            }
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: console.log('Unhandled event: ' + data)
    }
}
