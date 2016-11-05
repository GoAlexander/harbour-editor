import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: editorPage

    property int lastLineCount: 0
    property int sizeBackgroundItemMainMenu: pullMenu2.width / 5
    property int sizeBackgroundItem: hotActionsMenu.width / 5 //TODO rewrite?
    property string filePath: "" //TODO сделать предзагрузку последнего открытого
    property bool headerVisible: true //TODO set it in settings!
    property bool lineNumbersVisible: true //TODO set it in settings!

    function setFilePath(filePathFromChooser) {
        filePath = filePathFromChooser;
        pageStack.replaceAbove(null, Qt.resolvedUrl("FirstPage.qml"), {filePath: filePathFromChooser}, PageStackAction.Animated);
        pageStack.nextPage();
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

                Row {
                    id: pullMenu2
                    width: parent.width
                    height: childrenRect.height

                    BackgroundItem {
                        width: sizeBackgroundItemMainMenu
                        height: Theme.itemSizeSmall //height: Theme.itemSizeExtraSmall

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.paddingSmall
                            Image {
                                width: Theme.iconSizeSmallPlus
                                height: Theme.iconSizeSmallPlus
                                source: "image://theme/icon-m-acknowledge"
                            }
                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                width: contentWidth
                                font.pixelSize: Theme.fontSizeTiny
                                text: qsTr("Save as")
                            }
                        }
                        onClicked: {

                            //TODO вызвать диалог ввода пути

                            if (filePath!=="") {
                                py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
                            }
                        }
                    }

                    BackgroundItem {
                        width: sizeBackgroundItemMainMenu
                        height: Theme.itemSizeSmall

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.paddingSmall

                            Image {
                                width: Theme.iconSizeSmallPlus
                                height: Theme.iconSizeSmallPlus
                                source: "image://theme/icon-m-folder"
                            }
                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                width: contentWidth
                                font.pixelSize: Theme.fontSizeTiny
                                text: qsTr("Open")
                            }
                        }
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("FileChooserPage.qml"), {
                                               homePath: "/home/nemo",
                                               showFormat: true,
                                               title: "Select file",
                                               callback: setFilePath
                                           })
                        }
                    }
                }


                Row {
                    id: pullMenu
                    width: parent.width
                    height: childrenRect.height

                    BackgroundItem {
                        width: sizeBackgroundItemMainMenu
                        height: Theme.itemSizeSmall //height: Theme.itemSizeExtraSmall

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.paddingSmall
                            Image {
                                width: Theme.iconSizeSmallPlus
                                height: Theme.iconSizeSmallPlus
                                source: "image://theme/icon-m-acknowledge"
                            }
                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                width: contentWidth
                                font.pixelSize: Theme.fontSizeTiny
                                text: qsTr("Save   ")
                            }
                        }
                        onClicked: {
                            if (filePath!=="") {
                                py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
                            }
                        }
                    }

                    BackgroundItem {
                        width: sizeBackgroundItemMainMenu
                        height: Theme.itemSizeSmall

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.paddingSmall
                            Image {
                                width: Theme.iconSizeSmallPlus
                                height: Theme.iconSizeSmallPlus
                                source: "image://theme/icon-m-rotate-left"
                            }
                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                width: contentWidth
                                font.pixelSize: Theme.fontSizeTiny
                                text: qsTr("Undo")
                            }
                        }
                        onClicked:  {
                            //                            myTextArea.undo();
                        }
                    }

                    BackgroundItem {
                        width: sizeBackgroundItemMainMenu
                        height: Theme.itemSizeSmall

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.paddingSmall
                            Image {
                                width: Theme.iconSizeSmallPlus
                                height: Theme.iconSizeSmallPlus
                                source: "image://theme/icon-m-rotate-right"
                            }
                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                width: contentWidth
                                font.pixelSize: Theme.fontSizeTiny
                                text: qsTr("Redo")
                            }
                        }
                    }

                    BackgroundItem {
                        width: sizeBackgroundItemMainMenu
                        height: Theme.itemSizeSmall

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.paddingSmall
                            Image {
                                width: Theme.iconSizeSmallPlus
                                height: Theme.iconSizeSmallPlus
                                source: "image://theme/icon-m-keyboard"
                            }
                            Label {
                                id: labelReadOnly
                                anchors.verticalCenter: parent.verticalCenter
                                width: contentWidth
                                font.pixelSize: Theme.fontSizeTiny
                                text: qsTr("R-only")
                                wrapMode: Text.WordWrap
                            }
                        }
                        onClicked: {
                            if (myTextArea.readOnly == false) {
                                myTextArea.readOnly = true;
                            }
                            else {
                                myTextArea.readOnly = false;
                            }
                        }
                    }
                }
            }
        }


        PageHeader {
            id: header
            height: hotActionsMenu.height
            visible: headerVisible

            Row {
                id: hotActionsMenu
                width: parent.width
                height: childrenRect.height

                BackgroundItem {
                    width: sizeBackgroundItem
                    height: Theme.itemSizeSmall //height: Theme.itemSizeExtraSmall

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.paddingSmall
                        Image {
                            width: Theme.iconSizeSmallPlus
                            height: Theme.iconSizeSmallPlus
                            source: "image://theme/icon-m-acknowledge"
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            width: contentWidth
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("Save")
                        }
                    }
                    onClicked: {
                        if (filePath!=="") {
                            py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
                        }
                    }
                }

                BackgroundItem {
                    width: sizeBackgroundItem
                    height: Theme.itemSizeSmall

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.paddingSmall
                        Image {
                            width: Theme.iconSizeSmallPlus
                            height: Theme.iconSizeSmallPlus
                            source: "image://theme/icon-m-rotate-left"
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            width: contentWidth
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("Undo")
                        }
                    }
                    onClicked:  {
                        myTextArea.undo(); //TODO test it!
                    }
                }

                BackgroundItem {
                    width: sizeBackgroundItem
                    height: Theme.itemSizeSmall

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.paddingSmall
                        Image {
                            width: Theme.iconSizeSmallPlus
                            height: Theme.iconSizeSmallPlus
                            source: "image://theme/icon-m-rotate-right"
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            width: contentWidth
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("Redo")
                        }
                    }
                }

                BackgroundItem {
                    width: sizeBackgroundItem
                    height: Theme.itemSizeSmall

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.paddingSmall
                        Image {
                            width: Theme.iconSizeSmallPlus
                            height: Theme.iconSizeSmallPlus
                            source: "image://theme/icon-m-keyboard"
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            width: contentWidth
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("R-only")
                            wrapMode: Text.WordWrap
                        }
                    }
                    onClicked: {
                        if (myTextArea.readOnly == false) {
                            myTextArea.readOnly = true;
                        }
                        else {
                            myTextArea.readOnly = false;
                        }
                    }
                }

                BackgroundItem {
                    width: sizeBackgroundItem
                    height: Theme.itemSizeSmall

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.paddingSmall
                        Image {
                            width: Theme.iconSizeSmallPlus
                            height: Theme.iconSizeSmallPlus
                            source: "image://theme/icon-m-acknowledge"
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            width: contentWidth
                            font.pixelSize: Theme.fontSizeTiny
                            text: qsTr("Save")
                        }
                    }
                    onClicked: {
                        if (filePath!=="") {
                            py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
                        }
                    }
                }

            }
        }


        SilicaFlickable {
            id: editorView
            anchors.fill: parent
            anchors.topMargin:  {
                if (header.visible === true) {
                     editorView.anchors.topMargin=header.height;
                }
                else {
                    editorView.anchors.topMargin=page.height;
                }
            }

            contentHeight: myTextArea.height
            clip: true

            Label {
                id: lineNumbers
                y: 8
                height: myTextArea.height
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeMedium
                text: "1"
                visible: lineNumbersVisible
            }

            TextArea {
                id: myTextArea
                x: {  // TODO фактически компоненты друга на друге :( Нормально?
                    if (lineNumbersVisible === true) {
                        myTextArea.x = 30;
                    }
                    else {
                        myTextArea.x = 0;
                    }
                }
                width: parent.width

                //font.family: "Helvetica" //TODO implements in SettingsPage!
                //font.pointSize: 30 //TODO implements in SettingsPage!
                font.pixelSize: Theme.fontSizeMedium //use variable for that because of Label (to toggle this parameter)
                background: null
                selectionMode: TextEdit.SelectCharacters
                focus: true

                //+при смене ориентации автоматически не переписывает номера строк
                //Хм, считать во всем тексте количество символов переноса строки (а не lineCount)?!
                onTextChanged: { //TODO: BUG: В начале неправильно определяет количество строк + он длинную строчку (с автоматическим переносом) считает за несколько строк
                    console.log(myTextArea._editor.lineCount);
                    console.log(font.pixelSize);
                    lineNumberChanged();
                }

                onRotationChanged: {
                    //TODO пересчитать label
                }
            }
            VerticalScrollDecorator { flickable: editorView }
        }
    }


    Python {
        id: py

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../.'));
            importModule('editFile', function () {
                py.call('editFile.openings', [filePath], function(result) {//filePath is path where file that you want to open is
                    myTextArea.text = result;
                });
            });
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }
        onReceived: console.log('Unhandled event: ' + data)
    }
}
