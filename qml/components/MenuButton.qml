import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    //width: sizeBackgroundItemMainMenu
    height: Theme.itemSizeSmall
    property string mySource
    property string myText

    Row {
        anchors.centerIn: parent
        spacing: Theme.paddingSmall
        Image {
            width: Theme.iconSizeSmallPlus
            height: Theme.iconSizeSmallPlus
            //source: "image://theme/icon-m-acknowledge"
            source: mySource
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            width: contentWidth
            font.pixelSize: Theme.fontSizeTiny
            //text: qsTr("Save   ")
            text: myText
        }
    }
}
