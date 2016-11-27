import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    //width: sizeBackgroundItemMainMenu
    height: Theme.itemSizeSmall
    opacity: enabled ? 1.0 : 0.5
    property string mySource
    property string myText

    Row {
        anchors.centerIn: parent
        spacing: Theme.paddingSmall

        Image {
            width: Theme.iconSizeSmallPlus
            height: Theme.iconSizeSmallPlus
            source: mySource
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            width: contentWidth
            font.pixelSize: Theme.fontSizeTiny
            text: myText
        }
    }
}
