import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3



Page {
    id: page

    property int lastLineCount: 0
    property string filePath: "/home/nemo/Documents/test.txt"

    function numberOfLines() {
        var count = (myTextArea.text.match(/\n/g) || []).length;
        count += 1;
        return count;


    }

    //    function lineNumberChanged(){
    //        lineNumbers.text = "";
    ////        for (var i = 1; i < (myTextArea._editor.lineCount+1); i++) {
    ////            lineNumbers.text += i + "\n";
    ////        }

    //        var count = (myTextArea.text.match(/\n/g) || []).length;
    //        console.log(count);

    //        for (var i = 1; i < (count+2); i++) {
    //            lineNumbers.text += i + "\n";
    //        }
    //    }

    function lineNumberChanged() {
        if (myTextArea._editor.lineCount > lastLineCount) {
            console.log("Last character = " + myTextArea.text.slice(-1));
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

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: view
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
            MenuItem {
                text: qsTr("Save as")
                onClicked: py.call('editFile.savings', [filePath,myTextArea.text], function() {});//filePath is path where you want to save!
            }
            MenuItem {
                text: qsTr("Select all text")
                onClicked: {
                    myTextArea.selectAll();
                }
            }
            MenuItem {
                text: qsTr("Turn on read-only mode")
                onClicked: {
                    if (myTextArea.readOnly == false) {
                        text = qsTr("Turn off read-only mode");
                        myTextArea.readOnly = true;
                    }
                    else {
                        text = qsTr("Turn on read-only mode");
                        myTextArea.readOnly = false;
                    }
                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: myTextArea.height

        Label {
            id: lineNumbers
            //y: Theme.horizontalPageMargin
            y: 8
            height: myTextArea.height //???
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeMedium
            text: "1"
        }

        TextArea {
            id: myTextArea

            x: 30  // TODO фактически компоненты друга на друге :( Нормально?
            width: parent.width

            //TEST
            /*
            text: "TextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextText Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text" +
                  "\n\n\n\n\n\n\n\n\n\n\n\n" +
                  "TextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextTextText Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
            */

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

        VerticalScrollDecorator { flickable: view }

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

