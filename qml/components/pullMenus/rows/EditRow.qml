import QtQuick 2.6
import Sailfish.Silica 1.0
import "../../" //for import of MenuButton
import "../../../pages" //for import of SaveAsPage.qml + to do visible functions


//TODO -> use next variables as parameters (don`t use import)
//-saved
//-filePath
//-outputNotifications
//-myTextArea.*
Row {
    property int myMenuButtonWidth

    MenuButton {
        //width: sizeBackgroundItemMainMenu
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-sd-card"
        myText: qsTr("Save")
        enabled: !saved
        onClicked: {
            console.log(filePath + " [" + docencoding +"]\n" + myTextArea.text);
            if (filePath!=="") {
                py.call_sync('editFile.savings', [filePath,myTextArea.text,docencoding]);
                    //this code is inside to fix problem with async nature of python
                    outputNotifications.close()
                    outputNotifications.previewBody = qsTr("Document saved")
                    outputNotifications.publish()
                    saved = true;
                //filePath is path where you want to save!
            }

            if (filePath==="") {
                outputNotifications.close()
                outputNotifications.previewBody = qsTr("Document can't be saved!")
                outputNotifications.publish()
            }
        }
    }

    MenuButton {
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-search?" + (searchRowVisible ? Theme.highlightColor : Theme.primaryColor);
        myText: qsTr("Search")
        onClicked: {
            if (searchRowVisible == false) {
                searchRowVisible = true;
            }
            else {
                searchRowVisible = false;
            }
        }
    }

    MenuButton {
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-rotate-left";
        myText: qsTr("Undo")
        enabled: myTextArea._editor.canUndo
        onClicked: {
            myTextArea._editor.undo()
        }
    }

    MenuButton {
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-rotate-right";
        myText: qsTr("Redo")
        enabled: myTextArea._editor.canRedo
        onClicked: {
            myTextArea._editor.redo()
        }
    }

    MenuButton {
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-transfer"
        myText: qsTr("Tab")
        myRotation: 90
        onClicked: {
            var previousCursorPosition = myTextArea.cursorPosition;
            myTextArea.text = myTextArea.text.slice(0, myTextArea.cursorPosition) + tabType + myTextArea.text.slice(myTextArea.cursorPosition, myTextArea.text.length);
            myTextArea.cursorPosition = previousCursorPosition + tabType.length;
        }
    }
}
