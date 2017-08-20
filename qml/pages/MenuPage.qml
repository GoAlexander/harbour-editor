import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/pullMenus/rows"


Page {

    Rectangle {
        color: Theme.highlightBackgroundColor //"transparent"
        opacity: 0.25 //0.1 //0.2 //0.3
        z: -1
        anchors.fill: parent
        //Behavior on opacity {  FadeAnimator { } }
    }

    SilicaFlickable {
        id: view
        anchors.fill: parent

        Column {
            spacing: Theme.paddingLarge
            width: parent.width

            Row {
                width: parent.width

                Switch {
                    width: parent.width / 2
                    icon.source: "image://theme/icon-m-keyboard"
                    checked: myTextArea.readOnly
                    onCheckedChanged:{
                        if (!myTextArea.readOnly) {
                            myTextArea.readOnly = true;
                        }
                        else {
                            myTextArea.readOnly = false;
                        }
                    }
                }

                Switch {
                    width: parent.width / 2
                    icon.source: "../img/icon-m-code.svg"
                    checked:{

                    }
                }
            }


            // Fix it! (does not work because access to some variables does not exist
//            EditRow {
//                id: pullMenu
//                width: parent.width
//                height: childrenRect.height
//                myMenuButtonWidth: pullMenu.width / 4
//                visible: !headerVisible
//            }

            MainRow {
                id: pullMenu2
                width: parent.width
                height: childrenRect.height
                myMenuButtonWidth: pullMenu2.width / 4
            }

            //TODO need refactoring for this row
            Row {
                width: parent.width
                height: childrenRect.height

                MenuButton {
                    width: parent.width
                    mySource: "../img/icon-m-qnote.svg"
                    myText: qsTr("Quick note")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("QuickNotePage.qml"))
                    }
                }

//                MenuButton {
//                    width: parent.width / 2
//                    mySource: "../img/icon-m-code.svg";
//                    myText: qsTr("Highlight")
//                    onClicked: {
//                        if (highlightingEnabled == false) {
//                            highlightingEnabled = true;
//                            //pageStatusChange(editorPage); //bug
//                            pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePath, highlightingEnabled: highlightingEnabled}, PageStackAction.Replace);

//                            outputNotifications.close()
//                            outputNotifications.previewBody = qsTr("Highlighting enabled");
//                            outputNotifications.publish()
//                        }
//                        else {
//                            highlightingEnabled = false;
//                            pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePath}, PageStackAction.Replace);

//                            outputNotifications.close()
//                            outputNotifications.previewBody = qsTr("Highlighting disabled");
//                            outputNotifications.publish()

//                        }
//                    }
//                }
            }

        }
    }
}
