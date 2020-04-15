import QtQuick 2.6
import Sailfish.Silica 1.0
import "../pages"

CoverBackground {

    function setFilePath(filePathFromChooser) { //TODO refactoring of this function (it uses ALSO HistoryPage)
        filePath = filePathFromChooser;
        var result
        result=py2.call_sync('editFile.getSettings');
        encRegion=result.encRegion;
        encPreferred=result.encPreferred;

        pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePathFromChooser, encPreferred: encPreferred, encRegion:encRegion }, PageStackAction.Animated);
        pageStack.nextPage();
    }

    Image {
            source: "/usr/share/icons/hicolor/256x256/apps/harbour-editor.png"
            asynchronous: true
            width: parent.width * 0.8
            height: parent.height * 0.8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            opacity: 0.15
    }

        Label {
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingMedium
            horizontalAlignment: Text.Center
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.8
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: Theme.fontSizeSmall
            font.family: Theme.fontFamilyHeading

            text: fileName
        }

        Label {
            id: label
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingLarge * 3
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.Center
            width: parent.width
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: qsTr("Lines: ") + linesNumber + "\n" +
                  qsTr("Words: ") + wordsNumber + "\n" +
                  qsTr("Chars: ") + charNumber;
        }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "../img/icon-m-open.svg"
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("../pages/FileChooserPage.qml"), {
                                   showFormat: true,
                                   title: "Select file",
                                   inclHiddenFiles: inclHiddenFiles,
                                   callback: setFilePath
                               })
                mainwindow.activate();
            }
        }

        CoverAction {
            iconSource: "../img/icon-m-qnote.svg"
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("../pages/QuickNotePage.qml"))
                mainwindow.activate();
            }
        }
    }
}
