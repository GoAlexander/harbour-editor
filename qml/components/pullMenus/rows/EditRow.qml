import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../" //for import of MenuButton
import "../../../pages" //for import of SaveAsPage.qml + to do visible functions


//TODO -> use next variables as parameters (don`t use import)
//-saveFlag (!)
//-filePath
//-outputNotifications
//-myTextArea.*

Row {
    property int myMenuButtonWidth
    //property string filePath

    MenuButton {
        //width: sizeBackgroundItemMainMenu
        width: myMenuButtonWidth
        mySource: "image://theme/icon-m-acknowledge";
        myText: qsTr("Save")
        enabled: saveFlag
        onClicked: {
            if (filePath!=="") {
                py.call('editFile.savings', [filePath,myTextArea.text], function() {
                    //this code is inside to fix problem with async nature of python
                    outputNotifications.close()
                    outputNotifications.previewBody = qsTr("Document saved")
                    outputNotifications.publish()
                    saveFlag = false;
                }); //filePath is path where you want to save!
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
        mySource: "image://theme/icon-m-keyboard?" + (myTextArea.readOnly ? Theme.highlightColor : Theme.primaryColor);
        myText: qsTr("R-only")
        onClicked: {
            if (myTextArea.readOnly == false) {
                myTextArea.readOnly = true;
            }
            else {
                myTextArea.readOnly = false;
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
        mySource: "../img/icon-m-tab.svg";
        myText: qsTr("Tab")
        onClicked: {
            var previousCursorPosition = myTextArea.cursorPosition;
            myTextArea.text = myTextArea.text.slice(0, myTextArea.cursorPosition) + tabType + myTextArea.text.slice(myTextArea.cursorPosition, myTextArea.text.length);
            myTextArea.cursorPosition = previousCursorPosition + 1;
        }
    }
}
