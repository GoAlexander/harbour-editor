import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: historyPage

    property string value

    property var callback

    SilicaListView {
            id: historyList
            width: parent.width; height: parent.height
            anchors.fill: parent
            clip: true

            header: PageHeader {
                title: qsTr("History")
            }

            model: ListModel {
                id: myModel
            }

            delegate: BackgroundItem  {
                width: ListView.view.width
                height: Theme.itemSizeSmall

                Label {
                    id: labelPath
                    //anchors.margins:Theme.horizontalPageMargin
                    //anchors.verticalCenter: Text.verticalCenter
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: Text.verticalCenter
                        margins: Theme.paddingLarge
                    }
                    //spacing: Theme.paddingMedium

                    text: value
                }

                onClicked: {
                    console.log(labelPath.text);
                    callback(labelPath.text);
                    //pageStack.pop(); //TEST
                }
            }

            Component.onCompleted: {
                var openedFiles = [];
                py2.call('editFile.getValue', ["history"], function(result) {
                    openedFiles = result;
                    console.log(result)

                    //for(var i = 0; i < openedFiles.length; i++) {
                    for(var i = openedFiles.length-1; i >= 0; i--) {
                        var element = { "value" : openedFiles[i] }
                        myModel.append(element)
                    }
                });
            }



            /*

//            model: myModel

            header: PageHeader {
                title: qsTr("History")
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
//        for(var i=0;i<=100;i++) {
//            var element = { "value" : i }
//            myModel.append(element)
//        }


    */

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


