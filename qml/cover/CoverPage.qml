import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages"

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: "Test"
//        text: qsTr("Number of lines: ") + FirstPage.editorPage.numberOfLines() + "\n" +
//              qsTr("Number of charactes: ") + FirstPage.editorPage.myTextArea.length
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }
    }
}

