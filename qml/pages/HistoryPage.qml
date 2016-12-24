import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: historyPage

    SilicaGridView {
        id:list
        width: parent.width;
        height: parent.height

        cellWidth: width / 2
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

}
