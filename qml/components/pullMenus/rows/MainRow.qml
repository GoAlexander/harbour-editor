import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../" //for import of MenuButton
import "../../../pages" //for import of SaveAsPage.qml + to do visible functions


// Save as - Open - New - History
Row {
    property int myWidth
    property int myHeight
    property int myMenuButtonWidth

    width: myWidth
    height: myHeight

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
        mySource: "image://theme/icon-m-folder";
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
            //TODO ask:Are you sure?
            filePath = "";
            myTextArea.text = "";
        }
    }

    MenuButton {
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-document";
        myText: qsTr("History")
        onClicked: {
//                            pageStack.push(Qt.resolvedUrl("HistoryPage.qml"), {
//                                               currentFilePath: filePath,
//                                               callback: setFilePath
//                                           })
            pageStack.push(Qt.resolvedUrl("../../../pages/HistoryPage.qml"), {
                               callback: setFilePath
                           })
            //pageStack.push(Qt.resolvedUrl("HistoryPage.qml"))
        }
    }
}
