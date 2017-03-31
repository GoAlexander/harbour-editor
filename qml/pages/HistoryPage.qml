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
                        var openedFilesNew = [];
                        py2.call('editFile.getValue', ["history"], function(result) {
                            openedFiles = result; //TODO-REFACTORING: использовать сразу result (без openedFiles)
                            for (var i = 0; i < openedFiles.length; i++) {
                                if (openedFiles[i] !== labelPath.text) {
                                    openedFilesNew.push(openedFiles[i]);
                                }
                            }
                            openedFilesNew.push(labelPath.text);

                            // now save new history on file system
                            // and update qml model (UI)
                            py2.call('editFile.setValue', ["history", openedFilesNew], function(result) {
                                //remorseAction("Deleting", function () { animateRemoval(listItem)}); // here because of async nature of Python in Sailfish OS
                                myModel.clear();
                                for(var i = openedFilesNew.length-1; i >= 0; i--) {
                                    var element = { "value" : openedFilesNew[i] }
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
                        var openedFilesNew = [];

                        py2.call('editFile.getValue', ["history"], function(result) {
                            openedFiles = result;

                            openedFilesNew = openedFiles;
                            openedFilesNew.splice(openedFiles.indexOf(labelPath.text), 1);

                            // now save new history on file system
                            // and update qml model (UI)
                            py2.call('editFile.setValue', ["history", openedFilesNew], function(result) {
                                //myListItem.remorseAction("Deleting", function () {animateRemoval(listItem) });
                                //myModel.remove(labelPath.text); // here because of async nature of Python in Sailfish OS
                                myModel.clear();
                                for(var i = openedFilesNew.length-1; i >= 0; i--) {
                                    var element = { "value" : openedFilesNew[i] }
                                    myModel.append(element)
                                }
                            });
                        });
                    }
                }
            }

            Label {
                id: labelPath
                //anchors.margins:Theme.horizontalPageMargin
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
