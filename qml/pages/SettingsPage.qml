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
                id: test1
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Test1")
                //checked: !context.backgrounddisabled
            }

            TextSwitch
            {
                id: test2
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Test2")
                //checked: !context.backgrounddisabled
            }

            SectionHeader { text: qsTr("Fonts and size") }

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


