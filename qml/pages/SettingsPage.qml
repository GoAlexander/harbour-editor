import QtQuick 2.6
import Sailfish.Silica 1.0
import harbour.editor.generallogic 1.0
//import "../harbour-editor.qml"

Page {
    id: page

    //for xdg-mime
    GeneralLogic {
        id: myGeneralLogic
    }

    property bool editorDefault: myGeneralLogic.isDefaultApp();
    property real sizeIndex: getSizeIndex()
    property real typeIndex: getTypeIndex()

    function getSizeIndex(){
        var sizes = [ Theme.fontSizeTiny, Theme.fontSizeExtraSmall, Theme.fontSizeSmall, Theme.fontSizeMedium, Theme.fontSizeLarge, Theme.fontSizeExtraLarge, Theme.fontSizeHuge ]
        var index = sizes.indexOf(fontSize);
        return index
    }

    function getTypeIndex(){
        var types = [ Theme.fontFamily, "Open Sans", "Helvetica", "Droid Sans Mono", "Comic Sans", "Ubuntu", "DejaVu Sans Mono" ]
        var index = types.indexOf(fontType);
        return index
    }

    function resetSettings(){
         py2.call('editFile.resetSettings', [], function(result) {});
    }
    
    function saveSettings(){
        if(customcolortxt.text === "" || !customcolorsw.checked){
            customButtColor="";
           }
        else
           {
            customButtColor=customcolortxt.text;
           }
        py2.call('editFile.setValue', ["headerVisible", headerVisible], function(result) {});
        py2.call('editFile.setValue', ["lineNumbersVisible", lineNumbersVisible], function(result) {});

        py2.call('editFile.setValue', ["fontType", fontType], function(result) {});
        py2.call('editFile.setValue', ["fontSize", fontSize], function(result) {});
        py2.call('editFile.setValue', ["tabType", tabType], function(result) {});

        py2.call('editFile.setValue', ["showHiddenFiles", inclHiddenFiles], function(result) {});
        py2.call('editFile.setValue', ["darkTheme", darkTheme], function(result) {});

        py2.call('editFile.setValue', ["encRegion", encRegion], function(result) {});
        py2.call('editFile.setValue', ["encPreferred", encPreferred], function(result) {});

        py2.call('editFile.setValue', ["customButtColor", customButtColor], function(result) {});
        py2.call('editFile.setValue', ["autosave", autosave], function(result) {});
       console.log("Manual Save");
    }

    SilicaFlickable {
        id: view
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column {
            id: column
            //spacing: 5
            spacing: Theme.paddingLarge
            width: parent.width

            PageHeader {
                title: qsTr("Settings")
            }


            SectionHeader { text: qsTr("Appearance") }

            TextSwitch {
                id: lineNumbersVisibleSwitch
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: checked ? qsTr("Line numeration enabled") : qsTr("Line numeration disabled")
                checked: lineNumbersVisible
                onCheckedChanged: lineNumbersVisible = lineNumbersVisibleSwitch.checked;
            }

            Row{
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                TextSwitch {
                    id:darkT
                    checked: darkTheme
                    text: qsTr("Dark Theme")
                    width: parent.width/2
                    onCheckedChanged: {
                        darkTheme = checked
                        lightT.checked = !checked;
                        mainwindow.applyThemeColors();
                    }
                }

                TextSwitch {
                    id:lightT
                    checked: !darkTheme
                    text: qsTr("Ambience Theme")
                    width: parent.width/2
                    onCheckedChanged: {
                        darkT.checked = !checked;
                    }
                }
            }

            Column{
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                TextSwitch {
                    id: customcolorsw
                    enabled: darkTheme ? 0 : 1
                    checked: customButtColor != "" ? true : false
                    text: qsTr("Custom button color")
                    width: parent.width
                }

                TextField{
                    id:customcolortxt
                    width: parent.width
                    enabled: darkTheme ? 0 : customcolorsw.checked
                    labelVisible: enabled
                    color: buttonsColor
                    text: customButtColor
                    onTextChanged: {
                        customButtColor=customcolortxt.text;
                    }
                }
                LinkedLabel{
                    plainText: "Please use standard QML representation of color, see more here\nhttps://doc.qt.io/qt-5/qml-color.html"
                    width: parent.width
                }
            }

            SectionHeader { text: qsTr("Fonts and size") }

            TextField{
                text: "Test your text here"
                color: "white"
                font.family: fontType
                font.pixelSize: fontSize
            }
            ComboBox {
                label: qsTr("Font size")
                currentIndex: sizeIndex
                menu: ContextMenu {
                    MenuItem {
                        text: "(" + Theme.fontSizeTiny + ") " + qsTr("Tiny")
                        onClicked: {fontSize = Theme.fontSizeTiny;}
                    }
                    MenuItem {
                        text: "(" + Theme.fontSizeExtraSmall + ") " + qsTr("Extra small")
                        onClicked: {fontSize = Theme.fontSizeExtraSmall;}
                    }
                    MenuItem {
                        text: "(" + Theme.fontSizeSmall + ") " + qsTr("Small")
                        onClicked: {fontSize = Theme.fontSizeSmall;}
                    }
                    MenuItem {
                        text: "(" + Theme.fontSizeMedium + ") " + qsTr("Medium (default)")
                        onClicked: {fontSize = Theme.fontSizeMedium;}
                    }
                    MenuItem {
                        text: "(" + Theme.fontSizeLarge + ") " + qsTr("Large")
                        onClicked: {fontSize = Theme.fontSizeLarge;}
                    }
                    MenuItem {
                        text: "(" + Theme.fontSizeExtraLarge + ") " + qsTr("Extra large")
                        onClicked: {fontSize = Theme.fontSizeExtraLarge;}
                    }
                    MenuItem {
                        text: "(" + Theme.fontSizeHuge + ") " + qsTr("Huge")
                        onClicked: {fontSize = Theme.fontSizeHuge;}
                    }
                }
            }

            ComboBox {
                label: qsTr("Font:")
                value: fontType
                currentIndex: typeIndex
                    menu: ContextMenu {
                        MenuItem {
                            text: "Sail Sans Pro Light (default)"
                            onClicked: {fontType = Theme.fontFamily;}
                        }
                        MenuItem {
                            text: "Open Sans"
                            onClicked: {fontType = text;}
                        }
                        MenuItem {
                            text: "Helvetica"
                            onClicked: {fontType = text;}
                        }
                        MenuItem {
                            text: "Droid Sans Mono"
                            onClicked: {fontType = text;}
                        }
                        MenuItem {
                            text: "Comic Sans"
                            onClicked: {fontType = text;}
                        }
                        MenuItem {
                            text: "Ubuntu"
                            onClicked: {fontType = text;}
                        }
                        MenuItem {
                            text: "DejaVu Sans Mono"
                            onClicked: {fontType = text;}
                       }
                  }
            }
            ComboBox {
                label: qsTr("Type of tab:")
                value: {
                    if (tabType == "\t") {
                        value = "\\t";
                    } else if (tabType == "  ") {
                        value = "2 spaces";
                    } else if (tabType == "    ") {
                        value = "4 spaces";
                    } else if (tabType == "        ") {
                        value = "8 spaces";
                    }
                }

                menu: ContextMenu {
                    MenuItem {
                        text: "\\t"
                        onClicked: tabType = "\t";
                    }
                    MenuItem {
                        text: "2 spaces"
                        onClicked: tabType = "  ";
                    }
                    MenuItem {
                        text: "4 spaces"
                        onClicked: tabType = "    ";
                    }
                    MenuItem {
                        text: "8 spaces"
                        onClicked: tabType = "        ";
                    }
                }
            }

            SectionHeader { text: qsTr("Default text editor") }

            TextSwitch {
                id: editorT
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                checked: editorDefault
                text: "Editor."
                width: parent.width/2
                description: qsTr("Turn off to enable default notes")

                onClicked: {
                    //console.log(myGeneralLogic.isDefaultApp());
                    if (myGeneralLogic.isDefaultApp()) {
                        editorT.checked = false;
                        myGeneralLogic.setDefaultApp("jolla-notes.desktop");
                    } else {
                        editorT.checked = true;
                        myGeneralLogic.setDefaultApp("harbour-editor.desktop");
                    }
                }
            }

            SectionHeader { text: qsTr("General") }

            TextSwitch {
                id: autosaveT
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Autosave")
                description: qsTr("If enabled text will be stored in files with postfix ~")
                checked: autosave
                onCheckedChanged: autosave = autosaveT.checked;
            }

            SectionHeader { text: qsTr("File browser") }

            TextSwitch {
                id: showHiddenFilesSwitch
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Show hidden files")
                description: qsTr("Be careful to enable this option!")
                checked: inclHiddenFiles
                onCheckedChanged: inclHiddenFiles = showHiddenFilesSwitch.checked;
            }

            SectionHeader { text: qsTr("Encoding") }

            ComboBox {
                id: comb_encRegion
                label: qsTr("Region:")
                value: encRegion
                description: ""

                menu: ContextMenu {
                    MenuItem {
                        text: "Auto"
                        onClicked: {
                            encRegion = text;
                            comb_encRegion.description="Automatic";
                        }
                    }
                    MenuItem {
                        text: "Manual"
                        onClicked: {
                            encRegion = text;
                            comb_encRegion.description="";
                        }
                    }
                    MenuItem {
                        text: "Unicode"
                        onClicked: {
                            encRegion = text;
                            comb_encRegion.description="utf-8, utf-16, utf-32"}
                    // utf-8,utf-16,utf-32
                   }
                    MenuItem {
                        text: "Western Europe"
                        onClicked: {
                            encRegion = text;
                            comb_encRegion.description="windows-1252,iso8859-1"}
                    // 1252,iso8859-1
                    }

                    MenuItem {
                        text: "Central Europe"
                        onClicked: {
                            encRegion = text;
                            comb_encRegion.description="windows-1250,iso8859-2"}
                    // 1250,iso8859-2
                    }

                    MenuItem {
                        text: "Baltic"
                        onClicked: {
                            encRegion = text;
                            comb_encRegion.description="windows-1257,iso8859-4"}
                    // 1257,iso8859-4
                    }
                    MenuItem {
                        text: "Middle East"
                        onClicked: {
                            encRegion = text;
                            comb_encRegion.description="windows-1254,1255,1256"}
                    // 1254,1255,1256
                    }
             //       MenuItem {
             //           text: "Chinese"
             //           onClicked: {
             //               encRegion = text;
             //               comb_encRegion.description="GB 2312,18030"}
             //       // GB 2312,18030
             //       }
             //       MenuItem {
             //           text: "Taiwan"
             //           onClicked: {
             //               encRegion = text;
             //               comb_encRegion.description="HKSCS"}
             //       // HKSCS
             //       }
             //       MenuItem {
             //           text: "Korean"
             //           onClicked: {
             //               encRegion = text;
             //               comb_encRegion.description="KS X 1001"}
             //       // KS X 1001
             //       }
                }
            }
            TextField{
                id: encManual
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                enabled: comb_encRegion.value == "Manual" ? true : false
                text: encPreferred
                label: "Only on Manual"
                onTextChanged: encPreferred = encManual.text;
            }
        //    Rectangle{
            //    color: "transparent"
Row {
                anchors { horizontalCenter: parent.horizontalCenter;}// leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingSmall }
                height: Theme.itemSizeMedium
                spacing: Theme.paddingSmall
             Button{
                text: qsTr("Reset settings")
                anchors{ verticalCenter: parent.verticalCenter; bottomMargin: Theme.paddingSmall}
                onClicked: resetSettings();
             }
         Button{
                text: qsTr("Save settings")
                anchors{ verticalCenter: parent.verticalCenter; bottomMargin: Theme.paddingSmall}
                onClicked: saveSettings();
             }
            }

             VerticalScrollDecorator {}
        }
    }

    Component.onDestruction: {
        saveSettings();
    }
}
