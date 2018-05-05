import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.editor.generallogic 1.0

Page {
    id: page

    //for xdg-mime
    GeneralLogic {
        id: myGeneralLogic
    }

    property bool editorDefault: myGeneralLogic.isDefaultApp();

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
                id: headerVisibleSwitch
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Quick menu enabled")
                description: qsTr("Use it to get more space for text")
                checked: headerVisible
                onCheckedChanged: headerVisible = headerVisibleSwitch.checked;
            }

            TextSwitch {
                id: lineNumbersVisibleSwitch
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Line numeration enabled") + "\n" + "(experimental, broken)"
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
                        lightT.checked = !checked
                        if (darkTheme) {
                            textColor="#cfbfad"
                            qmlHighlightColor="#ff8bff"
                            keywordsHighlightColor="#808bed"
                            propertiesHighlightColor="#ff5555"
                            javascriptHighlightColor="#8888ff"
                            stringHighlightColor="#ffcd8b"
                            commentHighlightColor="#cd8b00"
                            bgColor="#1e1e27"
                        } else {
                            textColor=Theme.highlightColor
                            qmlHighlightColor=Theme.highlightColor
                            keywordsHighlightColor=Theme.highlightDimmerColor
                            propertiesHighlightColor=Theme.primaryColor
                            javascriptHighlightColor=Theme.secondaryHighlightColor
                            stringHighlightColor=Theme.secondaryColor
                            commentHighlightColor= Theme.highlightBackgroundColor
                            bgColor="transparent"
                        }
                    }
                }

                TextSwitch {
                    id:lightT
                    checked: !darkTheme
                    text: qsTr("Ambience Theme")
                    width: parent.width/2
                    onCheckedChanged: {
                        darkT.checked = !checked
                    }
                }
            }

            SectionHeader { text: qsTr("Fonts and size") }

            ComboBox {
                label: qsTr("Font size")
                value: fontSize

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Tiny")
                        onClicked: fontSize = Theme.fontSizeTiny;
                    }
                    MenuItem {
                        text: qsTr("Extra small")
                        onClicked: fontSize = Theme.fontSizeExtraSmall;
                    }
                    MenuItem {
                        text: qsTr("Small")
                        onClicked: fontSize = Theme.fontSizeSmall;
                    }
                    MenuItem {
                        text: qsTr("Medium (default)")
                        onClicked: fontSize = Theme.fontSizeMedium;
                    }
                    MenuItem {
                        text: qsTr("Large")
                        onClicked: fontSize = Theme.fontSizeLarge;
                    }
                    MenuItem {
                        text: qsTr("Extra large")
                        onClicked: fontSize = Theme.fontSizeExtraLarge;
                    }
                    MenuItem {
                        text: qsTr("Huge")
                        onClicked: fontSize = Theme.fontSizeHuge;
                    }
                }
            }

            ComboBox {
                label: qsTr("Font:")
                value: fontType

                menu: ContextMenu {
                    MenuItem {
                        text: "Sail Sans Pro Light (default)"
                        onClicked: fontType = Theme.fontFamily;
                    }
                    MenuItem {
                        text: "Open Sans"
                        onClicked: fontType = "Open Sans";
                    }
                    MenuItem {
                        text: "Helvetica"
                        onClicked: fontType = "Helvetica";
                    }
                    MenuItem {
                        text: "Droid Sans Mono"
                        onClicked: fontType = "Droid Sans Mono";
                    }
                    MenuItem {
                        text: "Comic Sans"
                        onClicked: fontType = "Comic Sans";
                    }
                    MenuItem {
                        text: "Ubuntu"
                        onClicked: fontType = "Ubuntu";
                    }
                    MenuItem {
                        text: "DejaVu Sans Mono"
                        onClicked: fontType = "DejaVu Sans Mono";
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
                checked: showHiddenFiles
                onCheckedChanged: showHiddenFiles = showHiddenFilesSwitch.checked;
            }


             VerticalScrollDecorator {}
        }
    }

    Component.onDestruction: {
        py2.call('editFile.setValue', ["headerVisible", headerVisible], function(result) {});
        py2.call('editFile.setValue', ["lineNumbersVisible", lineNumbersVisible], function(result) {});

        py2.call('editFile.setValue', ["fontType", fontType], function(result) {});
        py2.call('editFile.setValue', ["fontSize", fontSize], function(result) {});
        py2.call('editFile.setValue', ["tabType", tabType], function(result) {});

        py2.call('editFile.setValue', ["showHiddenFiles", showHiddenFiles], function(result) {});
        py2.call('editFile.setValue', ["darkTheme", darkTheme], function(result) {});

        py2.call('editFile.setValue', ["autosave", autosave], function(result) {});

    }
}
