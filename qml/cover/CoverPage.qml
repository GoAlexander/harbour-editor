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
}
