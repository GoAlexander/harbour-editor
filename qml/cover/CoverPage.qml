import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages"

CoverBackground {
    Column {
            width: parent.width
            anchors.centerIn: parent
            spacing: Theme.paddingMedium

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                source: closestMatchingIcon()
                   sourceSize.width: width
                   sourceSize.height: height

                   function closestMatchingIcon() {
                       var icon = "harbour-editor"

                       if (width <= 500) {
                           return "/usr/share/icons/hicolor/86x86/apps/"+icon+".png"
                       } else if (width <= 100) {
                           return "/usr/share/icons/hicolor/108x108/apps/"+icon+".png"
                       } else {
                           return "/usr/share/icons/hicolor/256x256/apps/"+icon+".png"
                       }
                   }
            }
//            Label {
//                anchors.horizontalCenter: parent.horizontalCenter
//                color: Theme.highlightColor
//                wrapMode: Text.WordWrap
//                font.bold: true
//                text: "Editor."
//            }
            Label {
                id: label
                //anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.Center
                width: parent.width
                wrapMode: Text.WordWrap
                color: Theme.highlightColor
                //x: Theme.horizontalPageMargin

                text: "Editor."
            }
        }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-sync"
            onTriggered: {
                label.text = qsTr("Doc name: ") + fileName + "\n" +
                        qsTr("Lines: ") + linesNumber + "\n" +
                        qsTr("Words: ") + wordsNumber + "\n" +
                        qsTr("Chars: ") + charNumber
            }
        }
    }
}
