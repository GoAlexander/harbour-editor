import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: aboutPage

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader {
                title: qsTr("About")
            }

            Button {
                text: qsTr("Paypal donation")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=E8CL7QXGEMQEG");
                }
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
                      qsTr("Make a donation (button above)") +
                      "<br/>" +
                      qsTr("or") +
                      "<br/>" +
                      qsTr("Star the repository at the github \u263a ") +  "</b>"  +
                      "<br/>" +
                      "<br/>" +
                      qsTr("Special thanks:") +
                      "<br/>" + qsTr("-eekkelund for save/load/autosave functions and feedback") +
                      "<br/>" + qsTr("-osanwe for very often consultations about qml code") +
                      "<br/>" + qsTr("-coderus for various tips and code") +
                      "<br/>" + qsTr("-Russian community for feedback and help") +
                      "<br/>" +
                      "<br/>" +
                      qsTr("Tips:")+
                      "<br/>" +
                      qsTr("-To 'Select all text' hold your finger until 3 vibrations") +
                      "<br/>" +
                      qsTr("-Unsaved changes are saved in the file with ending '~' in the same dir where you placed your original file") +
                      "<br/>" +
                      qsTr("-You can copy the file path to the clipboard by selecting appropriate MenuItem in pulley menu");

                onLinkActivated: {
                    Qt.openUrlExternally("https://github.com/GoAlexander/harbour-editor");
                }
            }


            SectionHeader { text: qsTr("Translators") }

            AuthorRow{
                author: "atlochowski"
                myText: qsTr(" - Polish translation")
            }

            AuthorRow{
                author: "Caballlero"
                myText: qsTr(" - Spanish translation")
            }

            AuthorRow{
                author: "eson57"
                myText: qsTr(" - Swedish translation")
            }

            AuthorRow{
                author: "GoAlexander"
                myText: qsTr(" - Russian translation")
            }

            AuthorRow{
                author: "Quent-in"
                myText: qsTr(" - French translation")
            }

            VerticalScrollDecorator {}
        }

    }
}
