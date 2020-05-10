import QtQuick 2.6
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

BackgroundItem {
    //width: sizeBackgroundItemMainMenu
    height: Theme.itemSizeSmall
    opacity: enabled ? 1.0 : 0.5
    property string mySource
    property string myText
    property real myRotation
    property string myColor
    property bool myHighlighted

    highlighted: myHighlighted
    Row {
        anchors.centerIn: parent
        spacing: Theme.paddingSmall

        Image {
            id: img
            width: Theme.iconSizeSmallPlus
            height: Theme.iconSizeSmallPlus
            source: mySource
            rotation: myRotation ? myRotation : 0
            layer {
                    enabled: true //myColor ? 1 : 0
                    effect:
                      ColorOverlay {
                        cached: true
                        color: myColor ? myColor : buttonsColor
                    }
                  }
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            width: contentWidth
            color: myColor ? myColor : buttonsColor//Theme.primaryColor
            font.bold: true
            font.pixelSize: Theme.fontSizeTiny
            text: myText
        }
    }

}
