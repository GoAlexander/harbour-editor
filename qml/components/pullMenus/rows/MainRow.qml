import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../" //for import of MenuButton
import "../../../pages" //for import of SaveAsPage.qml + to do visible functions


// Save as - Open - New - History
Row {
    property int myMenuButtonWidth

    MenuButton {
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-acknowledge";
        myText: qsTr("Save as")
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../../../pages/SaveAsPage.qml"), {
                               homePath: "/home/nemo",
                               showFormat: true,
                               title: "Select file",
                               showHiddenFiles: showHiddenFiles,
                               callback: saveAsSetFilePath
                           })
        }
    }

    MenuButton {
        width: myMenuButtonWidth
        mySource: "../img/icon-m-open.svg"
        myText: qsTr("Open")
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../../../pages/FileChooserPage.qml"), {
                               homePath: "/home/nemo",
                               showFormat: true,
                               title: "Select file",
                               showHiddenFiles: showHiddenFiles,
                               callback: setFilePath
                           })
        }
    }

    MenuButton {
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-note";
        myText: qsTr("New")
        onClicked: {

            filePath = "";
            myTextArea.text = "";
        }
    }

    MenuButton {
        width: myMenuButtonWidth
        mySource: "../img/icon-m-history.svg"
        myText: qsTr("History")
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../../../pages/HistoryPage.qml"), {
                               callback: setFilePath
                           })
        }
    }
}
