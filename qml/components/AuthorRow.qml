import QtQuick 2.6
import Sailfish.Silica 1.0

Row {
    property string author
    property string myText

    x: Theme.horizontalPageMargin
    Label {
        text: author
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeExtraSmall
    }
    Label {
        text: myText
        color: Theme.secondaryColor
        font.pixelSize: Theme.fontSizeExtraSmall
    }
}
