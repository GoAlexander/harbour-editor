import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: historyPage

    property string file
    property string encd
    property var callback

    function deleteHistory(){
         py2.call('editFile.resetHistory', [], function(result) {});
    }

    SilicaListView {
        id: historyList
        anchors {top: parent.top; bottom: rect_deletehistory.top; left: parent.left; right: parent.right; bottomMargin: Theme.itemSizeMedium }
       // width: parent.width
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
         //   height: Theme.iconSizeExtraLarge
            onClicked: {
                console.log(labelPath.text);
                //callback(labelPath.text);
                pageStack.replaceAbove(null, Qt.resolvedUrl("../pages/FirstPage.qml"), {filePath: file, docencoding: encd}, PageStackAction.Animated);
                pageStack.nextPage();
            }

            menu: ContextMenu {
                Label {
                    wrapMode: Text.WordWrap
                    height: Theme.iconSizeExtraLarge
                    width: parent.width
                    font.pixelSize: Theme.fontSizeSmall
                    text: file
                }
                MenuItem {
                    text: qsTr("Move to top")
                    onClicked: {
                        var openedFiles = [];
                        py2.call('editFile.getHistory', ["history"], function(result) {
                            for (var i = 0; i < result.length; i++) {
                                if (result[i].history !== labelPath.text) {
                                    openedFiles.push(result[i].history);
                                }
                            }
                            openedFiles.push(labelPath.text);

                            // now save new history on file system
                            // and update qml model (UI)
                            py2.call('editFile.setHistory', ["history", openedFiles], function(result) {
                                myModel.clear();
                                for (var i = openedFiles.length-1; i >= 0; i--) {
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
                        //TODO revisit
                        var result
                        result=py2.call_sync('editFile.getHistory');
                            var openedFiles = [];
                            var encodings = [];
                            openedFiles = result.file;
                            encodings = result.encd;
                            for (var i = 0; i < result.length; i++) {
                                if (result[i] !== labelPath.text) {
                                    openedFiles.push(result[i]);
                                }
                            }

                            // now save new history on file system
                            // and update qml model (UI)
                            py2.call('editFile.setHistory', ["history", openedFiles], function(result) {
                                myModel.clear();
                                for (var i = openedFiles.length-1; i >= 0; i--) {
                                    var element = { "file" : openedFiles[i]}
                                    myModel.append(element)
                                }
                            });
                    }
                }
            }
            Row{
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: Text.verticalCenter
                margins: Theme.paddingMedium
            }
            Label {
                id: labelPath
                width: parent.width - (Theme.itemSizeSmall * 1.8)
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                text: (file.split("/")[(file.split("/").length)-1])
            }
            Label {
                id: labelEncd
                width: Theme.itemSizeSmall * 1.8
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Theme.fontSizeExtraSmall
                color: "lightblue"
                text: encd
            }

            }
            Rectangle {width: parent.width; height: 2; color: Theme.highlightDimmerColor}
        }

        Component.onCompleted: {
            var result
            result=py2.call_sync('editFile.getHistory');
                var openedFiles = [];
                var encodings = [];
                openedFiles = result.file;
                encodings = result.encd;

                for (var i = openedFiles.length-1; i >= 0; i--) {
                    var element = { "file" : openedFiles[i], "encd": encodings[i] }
                    myModel.append(element)
                }
        }
    }
    Rectangle{
        id: rect_deletehistory
        height: Theme.itemSizeMedium
        anchors{bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: Theme.paddingSmall}
        z: historyList.z + 1
     Button{
        anchors {horizontalCenter: parent.horizontalCenter}
        text: qsTr("Delete history")
        onClicked: deleteHistory();
    }
   }
}
