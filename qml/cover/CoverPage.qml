import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages"

CoverBackground {

    Image {
            source: "/usr/share/icons/hicolor/256x256/apps/harbour-editor.png"
            asynchronous: true
            width: parent.width
            anchors.left: parent.left
            anchors.top:parent.top
            anchors.topMargin: Theme.paddingLarge
            anchors.leftMargin: -Theme.paddingLarge
            fillMode: Image.PreserveAspectFit
            opacity: 0.15
    }

    Column {
        width: parent.width
        anchors.centerIn: parent
        spacing: Theme.paddingMedium

        Label {
            horizontalAlignment: Text.Center
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall
            font.family: Theme.fontFamilyHeading

            text: fileName
        }

        Label {
            id: label
            //anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.Center
            width: parent.width
            wrapMode: Text.WordWrap
            color: Theme.highlightColor
            //x: Theme.horizontalPageMargin

            text: qsTr("Lines: ") + linesNumber + "\n" +
                  qsTr("Words: ") + wordsNumber + "\n" +
                  qsTr("Chars: ") + charNumber;
        }
    }

    CoverActionList {
        id: coverAction

//        CoverAction {
//            iconSource: "../img/icon-m-open.svg"
//            onTriggered: {
//                pageStack.push(Qt.resolvedUrl("../pages/FileChooserPage.qml"), {
//                                   homePath: "/home/nemo",
//                                   showFormat: true,
//                                   title: "Select file",
//                                   showHiddenFiles: showHiddenFiles,
//                                   callback: setFilePath
//                               })
//                mainwindow.activate();
//            }
//        }

        CoverAction {
            iconSource: "../img/icon-m-qnote.svg"
            onTriggered: {
                pageStack.replace(Qt.resolvedUrl("../pages/QuickNotePage.qml"))
                mainwindow.activate();
            }
        }
    }
}
