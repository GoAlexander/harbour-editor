import QtQuick 2.6
import Sailfish.Silica 1.0
import "../../" //for import of MenuButton
import "../../../pages" //for import of SaveAsPage.qml + to do visible functions


// Save as - Open - New - History
SilicaFlickable
{
    property int mainRowButtonWidth: isPortrait ? Screen.width / 4.5 : Screen.height / 4.5
    property int mainRowButtonWidth2: isPortrait ? Screen.width / 3.5 : Screen.height / 3.5
    Rectangle {
        anchors.fill: parent
        color: "#1e1e27"//bgColor
        opacity: 0.6
    }
    Row {
    id: row1

    width: isPortrait ? Screen.width / 2 : Screen.height / 2
    opacity: visible ? 1.0 : 0.0

    Behavior on opacity {
        PropertyAnimation { duration: 150; easing.type: Easing.Linear }
    }

    MenuButton {
        width: mainRowButtonWidth
        mySource: "image://theme/icon-m-note";
        myText: qsTr("New")
        onClicked: {

            filePath = "";
            myTextArea.text = "";
        }
    }

    MenuButton {
        width: mainRowButtonWidth
        mySource: "image://theme/icon-m-folder"
        myText: qsTr("Open")
        onClicked: {
            console.log(inclHiddenFiles);
            pageStack.push(Qt.resolvedUrl("../../../pages/FileChooserPage.qml"), {
                               showFormat: true,
                               title: "Select file",
                               inclHiddenFiles: inclHiddenFiles,
                               callback: setFilePath
                           })
        }
    }

    MenuButton {
        width: mainRowButtonWidth
        mySource: "image://theme/icon-m-sd-card"
        myText: qsTr("Save as")
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../../../pages/SaveAsPage.qml"), {
                              // homePath: "/",
                               docencoding: docencoding,
                               filePath: filePath,
                               showFormat: true,
                               title: "Select file",
                               showHiddenFiles: inclHiddenFiles,
                               callback: saveAsSetFilePath
                           })
        }
    }

    MenuButton {
        width: mainRowButtonWidth
        mySource: "image://theme/icon-m-time"
        myText: qsTr("History")
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../../../pages/HistoryPage.qml"), {
                               callback: setFilePath
                           })
        }
    }

    MenuButton {
        width: mainRowButtonWidth / 2
        mySource:  "image://theme/icon-m-right"
        onClicked: {
            row1.visible=!row1.visible;
            row2.visible=!row2.visible;
        }
    }
}

Row {
    id: row2
    width: isPortrait ? Screen.width / 2 : Screen.height / 2
    visible: false
    opacity: visible ? 1.0 : 0.0

    Behavior on opacity {
        PropertyAnimation { duration: 150; easing.type: Easing.Linear }
    }

    MenuButton {
        width: mainRowButtonWidth / 2
        mySource:  "image://theme/icon-m-left"
        onClicked: {
            row1.visible=!row1.visible;
            row2.visible=!row2.visible;
         //   if(mainRowVisible){extendedMenuSource = "image://theme/icon-m-down";}
         //   else{extendedMenuSource = "image://theme/icon-m-up";}
        }
    }

    MenuButton {
        width: mainRowButtonWidth2
        mySource: "image://theme/icon-m-text-input?" + (myTextArea.readOnly ? Theme.highlightColor : Theme.primaryColor);
        myText: qsTr("R-only")
        onClicked: {
            myHighlighted = !myHighlighted;
            if (!myTextArea.readOnly) {
                myTextArea.readOnly = true;
            }
            else {
                myTextArea.readOnly = false;
            }
        }
    }

    MenuButton {
        width: mainRowButtonWidth2
        mySource:  "image://theme/icon-m-note"
        myText: qsTr("Quick note")
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../../../pages/QuickNotePage.qml"))
        }
    }

    MenuButton {
        width: mainRowButtonWidth2
        mySource: "image://theme/icon-m-flashlight"
        myText: qsTr("Highlight")
        onClicked: {
            myHighlighted = !myHighlighted;
            mainRowVisible=!mainRowVisible;
            id_ret_lbl.visible=!id_ret_lbl.visible
            id_lblinfo.visible=!id_lblinfo.visible
            if(mainRowVisible){extrabutton.opacity = 1.0;extendedMenuSource = "image://theme/icon-m-down";}
            else{extrabutton.opacity = 0.4;extendedMenuSource = "image://theme/icon-m-up";}

            if (highlightingEnabled == false) {
                highlightingEnabled = true; //bug
               // pageStack.replaceAbove(null, Qt.resolvedUrl("../../../pages/FirstPage.qml"), {filePath: filePath, highlightingEnabled: highlightingEnabled}, PageStackAction.Replace);
                pageStatusChange(editorPage);

            }
            else {
                highlightingEnabled = false;
           //     pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePath}, PageStackAction.Replace);
                pageStatusChange(editorPage);

           //     outputNotifications.close()
           }
        }
    }
  }
}
