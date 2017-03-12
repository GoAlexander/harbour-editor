import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0
import io.thp.pyotherside 1.3
import "../components"
import "../components/pullMenus/rows"

Page {
    id: editorPage

    property int lastLineCount: 0
    property int sizeBackgroundItemMainMenuFirstRow: pullMenu2.width / 4
    property int sizeBackgroundItemMainMenu: pullMenu2.width / 5
    property int sizeBackgroundItem: hotActionsMenu.width / 5
    property string filePath: "" //"autosave"
    property bool saveFlag: false

    property bool searched: false


    Notification {
        id: outputNotifications
        category: "Editor."
    }

    function setFilePath(filePathFromChooser) { //TODO refactoring of this function (it uses ALSO HystoryPage)
        filePath = filePathFromChooser;
        pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePathFromChooser}, PageStackAction.Animated);
        pageStack.nextPage();
    }

    //TODO rewrite (delete)
    function saveAsSetFilePath(filePathFromChooser) {
        filePath = filePathFromChooser;
        pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePathFromChooser}, PageStackAction.Animated);
        pageStack.nextPage();
        if (filePath!=="") {
            py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
        }
        py.call('editFile.openings', [filePath], function(result) {//filePath is path where file that you want to open is
            myTextArea.text = result;
        });

        outputNotifications.close()
        outputNotifications.previewBody = qsTr("Document saved!")
        outputNotifications.publish()
    }

    function numberOfLines() {
        var count = (myTextArea.text.match(/\n/g) || []).length;
        count += 1;
        return count;
    }

    function lineNumberChanged() {
        if (myTextArea._editor.lineCount > lastLineCount) {
            console.log("Last character = " + myTextArea.text.slice(-1));
            if(myTextArea.text.slice(-1) !== "\n") {
                lineNumbers.text += "\n"
            }
            else {
                lineNumbers.text += numberOfLines() + "\n";
            }

            lastLineCount = myTextArea._editor.lineCount;

        } else if (myTextArea._editor.lineCount < lastLineCount) {
            lineNumbers.text = lineNumbers.text.slice(0, -2);
            lastLineCount = myTextArea._editor.lineCount;
        }
    }

    SilicaFlickable {
        id: view
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            Column {
                width: parent.width
                height: childrenRect.height

                // my own component (To Do need some cleaning and optimisation)
                SearchRow {
                    //id: pullMenu3
                    width: parent.width
                    height: childrenRect.height
                }

                // my own component (To Do need some cleaning and optimisation)
                MainRow {
                    id: pullMenu2
                    width: parent.width
                    height: childrenRect.height
                    myMenuButtonWidth:sizeBackgroundItemMainMenuFirstRow
                }

                // my own component (To Do need some cleaning and optimisation)
                EditRow {
                    id: pullMenu
                    width: parent.width
                    height: childrenRect.height
                    myMenuButtonWidth: sizeBackgroundItemMainMenu
                }

            }

            MenuItem {
                visible: (filePath == "") ? false : true
                text: filePath
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.highlightColor
                onClicked: {
                    Clipboard.text = filePath;
                    outputNotifications.close()
                    outputNotifications.previewBody = qsTr("File path copied to the clipboard")
                    outputNotifications.publish()
                }
            }

        }


        PageHeader {
            id: header
            height: hotActionsMenu.height
            visible: headerVisible

            // my own component (To Do need some cleaning and optimisation)
            EditRow {
                id: hotActionsMenu
                width: parent.width
                height: childrenRect.height
                myMenuButtonWidth: sizeBackgroundItem
            }
        }


        SilicaFlickable {
            id: editorView
            anchors.fill: parent
            anchors.topMargin: header.visible ? header.height : 0 // для сдвига при отключении quick actions menu
            contentHeight: myTextArea.height
            clip: true

            Label {
                id: lineNumbers
                y: 8
                height: myTextArea.height
                color: Theme.secondaryHighlightColor
                font.pixelSize: fontSize
                text: "1"
                visible: lineNumbersVisible
            }
            TextArea {
                id: myTextArea
                width: parent.width
                font.family: fontType
                font.pixelSize: fontSize
                background: null
                selectionMode: TextEdit.SelectCharacters
                //color: "green"
                focus: true
                onTextChanged: {
                    console.log("filePath = " + filePath, fontSize, font.family);
                    console.log("Real lines: " + myTextArea._editor.lineCount);
                    saveFlag = true;

                    //For line numeration: //TODO: BUG: В начале неправильно определяет количество строк + он длинную строчку (с автоматическим переносом) считает за несколько строк
                     //console.log(font.pixelSize, myTextArea._editor.lineCount);
                    lineNumberChanged();

                    //For cover:
                    charNumber = myTextArea.text.length;
                    linesNumber = numberOfLines();

                    //Autosave
                    if (filePath!=="") {
                        py.call('editFile.autosave', [filePath,myTextArea.text], function(result) {});
                    }
                }
//                onRotationChanged: {
//                    //TODO пересчитать label
//                }
            }
            VerticalScrollDecorator { flickable: editorView }
        }
    }


    onStatusChanged: {
        if(status !== PageStatus.Active){
            return
        }else{
            console.log(filePath)
            if (filePath!=="") {
                py.call('editFile.openings', [filePath], function(result) {//filePath is path where file that you want to open is
                    myTextArea.text = result;
                });
            }
        }
    }

    Python {
        id: py

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../.'));
            importModule('editFile', function () {});
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: console.log('Unhandled event: ' + data)
    }
}
