import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    Column {
        id: column
        spacing: 5
        width: parent.width

        PageHeader {
            title: qsTr("About")
        }

        Text {
            id: titleLabel
            anchors { horizontalCenter: parent.horizontalCenter }
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
            color: Theme.highlightColor
            text: "<style>a:link { color: " + Theme.highlightColor + "; }</style><br/>" +
                qsTr("\"Editor.\" is feature-rich text/code editor!") +
                "<br/>" +
                qsTr("License: GPLv3") +
                "<br/><br/>" + qsTr("You can find the source code at the:") +
                "<br/> <a href=\"https://github.com/GoAlexander/harbour-editor\">" +
                qsTr("GitHub") + "</a>" +
                "<br/>" +
                "<br/>" +
                "<b>" + qsTr("If you want to support the developer:") +
                "<br/>" +
                qsTr("Make a donation:  (in progress...)") +
                "<br/>" +
                qsTr("or") +
                "<br/>" +
                qsTr("Star the repository at the github \u263a") + "</b>" +
                "<br/>" +
                "<br/>" +
                qsTr("Special thanks:") +
                "<br/>" + qsTr("-eekkelund for save/load/autosave functions and feedback") +
                "<br/>" + qsTr("-osanwe for very often consultations about qml code") +
                "<br/>" + qsTr("-coderus for various tips and code") +
                "<br/>" + qsTr("-Russian community for feed back and help") +
                "<br/>" +
                "<br/>" +
                qsTr("Tips:")+
                "<br/>" +
                qsTr("-To 'Select all text' hold your finger until 3 vibrations") +
                "<br/>" +
                qsTr("-Unsaved changes are saved in the file ending with '~' in the same dir where you placed ");

            onLinkActivated: {
                Qt.openUrlExternally("https://github.com/GoAlexander/harbour-editor");
            }
        }
        VerticalScrollDecorator {}
    }
}
