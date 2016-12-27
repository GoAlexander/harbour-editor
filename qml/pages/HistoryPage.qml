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
    }
}
