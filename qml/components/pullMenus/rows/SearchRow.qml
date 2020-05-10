import QtQuick 2.6
import Sailfish.Silica 1.0
import "../../../pages" //to do visible some variables

//TODO -> use next variables as parameters (don`t use import)
//-searched
//-searchRowVisible
//-myTexstArea.*

Row {

    function search(text, position, direction, id) {
        text = text.toLowerCase()
        var myText = myTextArea.text.toLowerCase()
        Theme.highlightText(myText,text,Theme.highlightColor)
        //var reg = new RegExp(text, "ig")
        //var match = myTextArea.text.match(reg)
        var match = myText.match(text)
        if (match) {
            if (direction=="back") {
                myTextArea.cursorPosition = myText.lastIndexOf(match[match.length-1], position)
                if(myText.lastIndexOf(match[match.length-1], position) != -1) myTextArea.select(myTextArea.cursorPosition, myTextArea.cursorPosition+text.length)
            } else {
                myTextArea.cursorPosition = myText.indexOf(match[0],position)
                if (myText.indexOf(match[0],position)!=-1) myTextArea.select(myTextArea.cursorPosition, myTextArea.cursorPosition+text.length)
            }
            //myTextArea.forceActiveFocus()
        } else {
            searchField.errorHighlight = true
        }
    }

    SearchField {
        id:searchField
        //width: parent.width / 1.5
        width: isPortrait ? Screen.width / 1.8 : Screen.height / 1.8
        height: Theme.itemSizeSmall

        font.pixelSize: Theme.fontSizeMedium
        EnterKey.iconSource: "image://theme/icon-m-enter-next"
        placeholderText: qsTr("Search")
        EnterKey.onClicked:{
            //flipable.search(text,0,"forward",searchField);
            search(text,0,"forward",searchField);
            searched=true
        }
        onTextChanged: searched = false
        inputMethodHints: Qt.ImhNoAutoUppercase
    }

    Row {
        spacing: Theme.paddingSmall

        IconButton {
            id:previous
            icon.source: "image://theme/icon-m-previous"
            height: searchField.height
            scale: 0.8
            enabled: searched
            onClicked: {
                //flipable.search(searchField.text,myTextArea.cursorPosition-1,"back",previous);
                search(searchField.text,myTextArea.cursorPosition-1,"back",previous);
                myTextArea.forceActiveFocus();
            }
            visible: searchField.activeFocus || searchField.text.length>0
        }

        IconButton {
            id:next
            icon.source: "image://theme/icon-m-next"
            height: searchField.height
            scale: 0.8
            enabled: searched
            onClicked: {
                //flipable.search(searchField.text,myTextArea.cursorPosition+1,"forward",next);
                search(searchField.text,myTextArea.cursorPosition+1,"forward",next);
                myTextArea.forceActiveFocus();
            }
            visible: searchField.activeFocus || searchField.text.length>0
        }

        IconButton {
            icon.source: "image://theme/icon-m-close"
            height: searchField.height
            onClicked: {
                searchRowVisible = false;
            }
        }
    }
}
