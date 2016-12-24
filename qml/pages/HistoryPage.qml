import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: historyPage

    SilicaListView {
            id: dialogsList
            anchors.fill: parent
            clip: true

//            model: myModel

            header: PageHeader {
                title: qsTr("Dialogs")
            }

            delegate: BackgroundItem {
                id: dialogItem
                width: parent.width
                height: Theme.itemSizeMedium

                Label {
                    width: parent.width
//                    color: dialogItem.highlighted || unread ? Theme.secondaryHighlightColor :
//                                                              Theme.secondaryColor
//                    linkColor: dialogItem.highlighted ? Theme.primaryColor : Theme.highlightColor
//                    truncationMode: TruncationMode.Fade
//                    maximumLineCount: 1
//                    text: preview.replace('\n', ' ')

                    text: "test"
                }

                onClicked: {
                    //поставить filePath
                    //и уйти обратно
                }

                Component.onCompleted: {

                }
            }

            VerticalScrollDecorator {}
        }

    Component.onCompleted: {
        for(var i=0;i<=100;i++) {
            var element = { "value" : i }
            myModel.append(element)
        }
    }
}





    /*
    SilicaGridView {
        id:list
        width: parent.width;
        height: parent.height

        cellWidth: width
        cellHeight: width / 2

        model: ListModel {
           id: myJSModel

        }
        //header: MyHeader {}
        delegate: Item {
            width: list.cellWidth
            height: list.cellHeight



            Label {
                text: value
                font.pixelSize: Theme.fontSizeMedium
                anchors {
                            left: parent.left
                            right: parent.right
                            margins: Theme.paddingLarge

                        }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var value = list.model.get(index).value
                    console.log(value);
                }
            }
        }

        Component.onCompleted: {
            for(var i=0;i<=100;i++) {
                var element = { "value" : i }
                myJSModel.append(element)
            }
        }
    }

    */


