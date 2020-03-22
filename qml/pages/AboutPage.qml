import QtQuick 2.6
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

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeExtraLarge
                height: Theme.iconSizeExtraLarge
                source: "/usr/share/icons/hicolor/256x256/apps/harbour-editor.png"
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Version") + " " + Qt.application.version
            }

            Button {
                text: qsTr("Paypal donation - EURO")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=E8CL7QXGEMQEG");
                }
            }

            Button {
                text: qsTr("Paypal donation - RUB")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=B6EWFULGLUZR8");
                }
            }

            Button {
                text: qsTr("Source code")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Qt.openUrlExternally("https://github.com/GoAlexander/harbour-editor");
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
                      "<br/>" + qsTr("-eekkelund for save/load/autosave functions, source code and some dictionaries for syntax highlighting and feedback") +
                      "<br/>" + qsTr("-osanwe for very often consultations about qml code") +
                      "<br/>" + qsTr("-coderus for various tips and code") +
                      "<br/>" + qsTr("-Russian community for feedback and help") +
                      "<br/>" + qsTr("-Ancelad for tab icon, testing and help") +
                      "<br/>" + qsTr("-gri4994 for the wonderful app icon") +
                      "<br/>" + qsTr("-the team of GtkSourceView for the basis for .sh dictionary") +
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

            AuthorRow {
                author: "atlochowski"
                myText: qsTr(" - Polish translation")
            }

            AuthorRow {
                author: "Caballlero"
                myText: qsTr(" - Spanish translation")
            }

            AuthorRow {
                author: "eson57"
                myText: qsTr(" - Swedish translation")
            }

            AuthorRow {
                author: "GoAlexander"
                myText: qsTr(" - Russian translation")
            }

            AuthorRow {
                author: "Quent-in"
                myText: qsTr(" - French translation")
            }

            AuthorRow {
                author: "rabauke"
                myText: qsTr(" - German translation")
            }

            AuthorRow {
                author: "Nathan Follens"
                myText: qsTr(" - Dutch translation")
            }

            VerticalScrollDecorator {}
        }

    }
}
