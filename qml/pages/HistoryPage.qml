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

        delegate: ListItem {
            onClicked: {
                console.log(labelPath.text);
                callback(labelPath.text);
            }

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Move to top")
                    onClicked: {

                    }
                }
                MenuItem {
                    text: qsTr("Delete")
                    onClicked: {
                        //TODO вынести массив "выше"? (чтобы несколько раз запросы не делать...
                        var openedFiles = [];
                        var openedFilesNew = [];
                        py2.call('editFile.getValue', ["history"], function(result) {
                            openedFiles = result;

                            //var index = openedFiles.indexOf(labelPath.text);
                            //openedFiles.splice(index, 1);
                            for (var i = 0; i < openedFiles.length; i++) {
                                if (openedFiles[i] !== labelPath.text) {
                                    openedFilesNew[i] = openedFiles[i];
                                }
                            }
                        });

                        py2.call('editFile.setValue', ["history", openedFilesNew], function(result) {});
                        remorseAction("Deleting", function () { animateRemoval(listItem)});
                    }
                }
            }

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

        }

        Component.onCompleted: {
            var openedFiles = [];
            py2.call('editFile.getValue', ["history"], function(result) {
                openedFiles = result;
                console.log(result)

                for(var i = openedFiles.length-1; i >= 0; i--) {
                    var element = { "value" : openedFiles[i] }
                    myModel.append(element)
                }
            });
        }
    }
}
