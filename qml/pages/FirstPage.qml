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
    property bool saveFlag: false


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
//                                               showHiddenFiles: showHiddenFiles,
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
//                                               showHiddenFiles: showHiddenFiles,
                                               callback: setFilePath
                                           })
                        }
                    }

                    MenuButton {
                        width: sizeBackgroundItemMainMenu //height: Theme.itemSizeExtraSmall
                        mySource: "image://theme/icon-m-note";
                        myText: qsTr("New")
                        onClicked: {
                            //TODO ask:Are you sure?
                            filePath = "";
                            myTextArea.text = "";
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

            MenuLabel {
                text: filePath
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
