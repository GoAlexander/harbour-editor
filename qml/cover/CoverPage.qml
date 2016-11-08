import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages"

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        horizontalAlignment: Text.Center
        width: parent.width

        text: "Editor." + "\n" + "\n" +
              qsTr("Number of lines: ") + linesNumber + "\n" +
              qsTr("Number of charactes: ") + charNumber

        wrapMode: Text.WordWrap

    }

//    CoverActionList {
//        id: coverAction

//        CoverAction {
//            iconSource: "image://theme/icon-cover-next"
//        }

//        CoverAction {
//            iconSource: "image://theme/icon-cover-pause"
//        }
//    }
}

