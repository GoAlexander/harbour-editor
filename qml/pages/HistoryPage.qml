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
            description: qsTr("Documents are in order of first opening")
        }

        model: ListModel {
            id: myModel
        }

        delegate: ListItem {
            id: myListItem
            onClicked: {
                console.log(labelPath.text);
                callback(labelPath.text);
            }

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Move to top")
                    onClicked: {
                        var openedFiles = [];
                        py2.call('editFile.getHistory', ["history"], function(result) {
                            for (var i = 0; i < result.length; i++) {
                                if (result[i] !== labelPath.text) {
                                    openedFiles.push(result[i]);
                                }
                            }
                            openedFiles.push(labelPath.text);

                            // now save new history on file system
                            // and update qml model (UI)
                            py2.call('editFile.setHistory', ["history", openedFiles], function(result) {
                                myModel.clear();
                                for(var i = openedFiles.length-1; i >= 0; i--) {
                                    var element = { "value" : openedFiles[i] }
                                    myModel.append(element)
                                }
                            });
                        });
                    }
                }

                MenuItem {
                    text: qsTr("Delete")
                    onClicked: {
                        var openedFiles = [];

                        py2.call('editFile.getHistory', ["history"], function(result) {
                            openedFiles.splice(result.indexOf(labelPath.text), 1);

                            // now save new history on file system
                            // and update qml model (UI)
                            py2.call('editFile.setHistory', ["history", openedFiles], function(result) {
                                myModel.clear();
                                for(var i = openedFiles.length-1; i >= 0; i--) {
                                    var element = { "value" : openedFiles[i] }
                                    myModel.append(element)
                                }
                            });
                        });
                    }
                }
            }

            Label {
                id: labelPath
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: Text.verticalCenter
                    margins: Theme.paddingLarge
                }
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                text: value
            }

        }

        Component.onCompleted: {
            var openedFiles = [];
            py2.call('editFile.getHistory', ["history"], function(result) {
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
