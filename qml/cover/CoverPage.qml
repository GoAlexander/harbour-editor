import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages"

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        horizontalAlignment: Text.Center
        width: parent.width
        color: Theme.highlightColor
        wrapMode: Text.WordWrap
        x: Theme.horizontalPageMargin

        text: "Editor."
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-sync"
            onTriggered: {
                label.text = "Editor." + "\n" + "\n" +
                        qsTr("Lines: ") + linesNumber + "\n" +
                        qsTr("Chars with \\n: ") + charNumber
            }
        }

    }
}
