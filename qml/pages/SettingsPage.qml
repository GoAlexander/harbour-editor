import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        id: view
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column {
            id: column
            spacing: 5
            width: parent.width

            PageHeader {
                title: qsTr("Settings")
            }


            SectionHeader { text: qsTr("Appearance") }

            TextSwitch
            {
                id: headerVisibleSwitch
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Quick menu enabled")
                checked: headerVisible
                onCheckedChanged: headerVisible = headerVisibleSwitch.checked;
//                onCheckedChanged: {
//                    if (headerVisibleSwitch.checked === true) {
//                        headerVisible = headerVisibleSwitch.checked;
//                    }
//                    else {
//                        headerVisible = null;
//                    }
//                }
            }

            TextSwitch
            {
                id: lineNumbersVisibleSwitch
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Line numeration enabled") + "\n" + "(experimental, broken)"
                checked: lineNumbersVisible
                onCheckedChanged: lineNumbersVisible = lineNumbersVisibleSwitch.checked;
//                onCheckedChanged: {
//                    if (lineNumbersVisibleSwitch.checked === true) {
//                        lineNumbersVisible = lineNumbersVisibleSwitch.checked;
//                    }
//                    else {
//                        lineNumbersVisible = null;
//                    }
//                }
            }

            SectionHeader { text: qsTr("Fonts and size") }

            ComboBox {
                label: "Font size"
                value: fontSize

                menu: ContextMenu {
                    MenuItem {
                        text: "fontSizeMedium (default)"
                        onClicked: fontSize = Theme.fontSizeMedium;
                    }
                    MenuItem {
                        text: "fontSizeSmall"
                        onClicked: fontSize = Theme.fontSizeSmall;
                    }
                    MenuItem {
                        text: "fontSizeLarge"
                        onClicked: fontSize = Theme.fontSizeLarge;
                    }
                }
            }

            ComboBox {
                label: "Font"
                value: fontType
                //font.family: fontType //TODO implement!

                menu: ContextMenu {
                    MenuItem {
                        text: "Sail Sans Pro Light (default)"
                        onClicked: fontType = Theme.fontFamily;
                    }
                    MenuItem {
                        text: "Open Sans"
                        onClicked: fontType = "Open Sans";
                    }
                    MenuItem {
                        text: "Helvetica"
                        onClicked: fontType = "Helvetica";
                    }
                    MenuItem {
                        text: "Droid Sans Mono"
                        onClicked: fontType = "Droid Sans Mono";
                    }
                    MenuItem {
                        text: "Comic Sans"
                        onClicked: fontType = "Comic Sans";
                    }
                    MenuItem {
                        text: "Ubuntu"
                        onClicked: fontType = "Ubuntu";
                    }
                    MenuItem {
                        text: "DejaVu Sans Mono"
                        onClicked: fontType = "DejaVu Sans Mono";
                   }
                }
            }

        }
    }


}



//    SilicaListView {
//        id: listView
//        model: 20
//        anchors.fill: parent
//        header: PageHeader {
//            title: qsTr("Settings")
//        }
//        delegate: BackgroundItem {
//            id: delegate

//            Label {
//                x: Theme.paddingLarge
//                text: qsTr("Item") + " " + index
//                anchors.verticalCenter: parent.verticalCenter
//                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
//            }
//            onClicked: console.log("Clicked " + index)
//        }
//        VerticalScrollDecorator {}
//    }



//        // Tell SilicaFlickable the height of its content.
//        contentHeight: column.height

//        // Place our content in a Column.  The PageHeader is always placed at the top
//        // of the page, followed by our content.
//        Column {
//            id: column

//            width: page.width
//            spacing: Theme.paddingLarge
//            PageHeader {
//                title: qsTr("UI Template")
//            }
//            Label {
//                x: Theme.paddingLarge
//                text: qsTr("Hello Sailors")
//                color: Theme.secondaryHighlightColor
//                font.pixelSize: Theme.fontSizeExtraLarge
//            }
//        }

//onHorizontalAlignmentChanged: {
//        if (explicitHorizontalAlignment) {
//            textEdit.horizontalAlignment = horizontalAlignment
//        }

//            color: {
//                if (myTextArea.focus == true) {
//                    myTextArea.color = Theme.secondaryColor;
//                } else {
//                    myTextArea.color = Theme.HighlightColor;
//                }
//            }




//font.strikeout


