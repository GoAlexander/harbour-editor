import QtQuick 2.6
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import harbour.editor.generallogic 1.0
import "../components"
import "../components/pullMenus/rows"

Page {
    id: editorPage

    //for filePath
    GeneralLogic {
        id: myGeneralLogic
    }

    property string filePath: myGeneralLogic.getQuickNotePath();
    property bool searched: false
    property bool searchRowVisible: false

    Rectangle {
        id:background
        color: bgColor
        anchors.fill: parent
        visible: true

        SilicaFlickable {
            id: view
            anchors.fill: parent

            PushUpMenu {
                MenuLabel {
                    text: qsTr("Quick note.")
                }
                MenuLabel {
                    text: qsTr("Text auto-saved in:")
                }
                MenuLabel {
                    text: "~/Documents/harbour-editor-quickNote.txt"
                }
            }

            Row {
                id: header
                height: hotActionsMenu.height
                width: parent.width
                anchors.bottom: parent.bottom

                Row {
                    id: hotActionsMenu
                    width: parent.width
                    height: childrenRect.height
                    visible: !searchRowVisible

                    MenuButton {
                        width: parent.width / 4
                        mySource: "image://theme/icon-m-rotate-left";
                        myText: qsTr("Undo")
                        enabled: myTextArea._editor.canUndo
                        onClicked: {
                            myTextArea._editor.undo()
                        }
                    }

                    MenuButton {
                        width: parent.width / 4
                        mySource: "image://theme/icon-m-rotate-right";
                        myText: qsTr("Redo")
                        enabled: myTextArea._editor.canRedo
                        onClicked: {
                            myTextArea._editor.redo()
                        }
                    }

                    MenuButton {
                        width: parent.width / 4
                        mySource: "image://theme/icon-m-search?" + (searchRowVisible ? Theme.highlightColor : Theme.primaryColor);
                        myText: qsTr("Search")
                        onClicked: {
                            if (searchRowVisible == false) {
                                searchRowVisible = true;
                            }
                            else {
                                searchRowVisible = false;
                            }
                        }
                    }

                    MenuButton {
                        width: parent.width / 4
                        mySource: "../img/icon-m-tab.svg";
                        myText: qsTr("Tab")
                        onClicked: {
                            var previousCursorPosition = myTextArea.cursorPosition;
                            myTextArea.text = myTextArea.text.slice(0, myTextArea.cursorPosition) + tabType + myTextArea.text.slice(myTextArea.cursorPosition, myTextArea.text.length);
                            myTextArea.cursorPosition = previousCursorPosition + 1;
                        }
                    }
                }

                SearchRow {
                    width: parent.width
                    height: childrenRect.height
                    visible: searchRowVisible
                }

            }

            SilicaFlickable {
                id: editorView
                anchors.fill: parent
                anchors.bottomMargin: header.visible ? header.height : 0 // для сдвига при отключении quick actions menu
                contentHeight: myTextArea.height
                clip: true

                TextArea {
                    id: myTextArea
                    width: parent.width
                    font.family: fontType
                    font.pixelSize: fontSize
                    background: null
                    selectionMode: TextEdit.SelectCharacters
                    focus: true

                    onTextChanged: {
                    //    console.log("filePath = " + filePath, fontSize, font.family);

                        //Autosave
                        if (filePath!=="" && myTextArea.text !== "") {
                            py.call('editFile.savings', [filePath,myTextArea.text,'utf-8'], function() {});
                        }
                    }
                }
                VerticalScrollDecorator { flickable: editorView }
            }
        }
    }

    onStatusChanged: {
        if (status !== PageStatus.Active) {
            return
        } else {
            console.log(filePath)
            if (filePath!=="") {
                py.call('editFile.openings', [filePath,'utf-8'], function(result) {
                    myTextArea.text = result[0];
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
