/*
*  Taken from https://github.com/CODeRUS/splashscreen-changer/blob/master/settings/SecondPage.qml
*  Thanks coderus!
*/

import QtQuick 2.6
import Sailfish.Silica 1.0
;import Nemo.FileManager 1.0
;import Sailfish.FileManager 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    property alias path: fileModel.path
    property string homePath
    property string title
    property bool showFormat
    property string filePath
    property string docencoding
    property bool showHiddenFiles

    signal formatClicked

    property var callback

    function savefile (){
        filePath = nameField.text;
        if (typeof callback == "function") {
            callback(filePath,docencoding); //return to the page from which this page was called
        }
    }

    SequentialAnimation {
      id: anim_butt_click
      alwaysRunToEnd: true
      ColorAnimation{target: ret_butt ; property: "color"; to: Theme.highlightColor; duration: 150}
      ColorAnimation{target: ret_butt ; property: "color"; to: Theme.highlightDimmerColor; duration: 150}
      onStopped: {
          savefile();
      }
    }

    backNavigation: !FileEngine.busy

    FileModel {
        id: fileModel

        path: filePath != "" ? filePath.replace((filePath.split("/")[(filePath.split("/").length)-1]),"") : "/"
        active: page.status === PageStatus.Active
        includeHiddenFiles: showHiddenFiles
        onError: {
            console.log("###", fileName, error)
        }
    }

    PageHeader {
         id: header
         width: parent.width
         height: nameField.height + encodeField.height + Theme.paddingLarge

         Column {
             anchors.topMargin: Theme.paddingMedium
             anchors.fill: parent
           TextField {
                 id: nameField
                 width: parent.width
                 labelVisible: false
                 text: filePath != "" ? filePath : "/"

                 EnterKey.enabled: text.length > 0
                 EnterKey.onClicked: {
                     savefile();
                      }
                  }
           Row {
               width: parent.width

             TextField {
                 id: encodeField
                 width: parent.width - ret_butt.width
                 height: nameField.height
                 label: "Encoding"
                 labelVisible: false
                 text: docencoding
                 onTextChanged: {docencoding = text;}
                }
             Rectangle{
                 id: ret_butt
                 color: Theme.highlightDimmerColor;
                 width: header.height
                 height: nameField.height
               Image{
                 anchors.fill: parent;
                 source: "image://theme/icon-m-forward"
                 fillMode: Image.PreserveAspectFit
                }
               MouseArea{
                  anchors.fill: parent;
                  onClicked: {
                      anim_butt_click.start();
                  }
                }
             }
          }
       }
    }


    SilicaListView {
        id: fileList

        width: parent.width
        height: parent.height
        anchors.topMargin: header.height;
        clip: true // to be below than PageHeader

        opacity: FileEngine.busy ? 0.6 : 1.0
        Behavior on opacity { FadeAnimator {} }

        anchors.fill: parent
        model: fileModel


        delegate: ListItem {
            id: fileItem

            width: ListView.view.width
            contentHeight: Theme.itemSizeSmall
            Row {
                anchors.fill: parent
                spacing: Theme.paddingLarge
                Rectangle {
                    width: height
                    height: parent.height
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0.1) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }

                    Image {
                        anchors.centerIn: parent
                        source: {
                            var iconSource
                            if (model.isDir) {
                                iconSource = "image://theme/icon-m-file-folder"
                            } else {
                                var iconType = "other"
                                switch (model.mimeType) {
                                case "application/vnd.android.package-archive":
                                    iconType = "apk"
                                    break
                                case "application/x-rpm":
                                    iconType = "rpm"
                                    break
                                case "text/vcard":
                                    iconType = "vcard"
                                    break
                                case "text/plain":
                                case "text/x-vnote":
                                    iconType = "note"
                                    break
                                case "application/pdf":
                                    iconType = "pdf"
                                    break
                                case "application/vnd.oasis.opendocument.spreadsheet":
                                case "application/x-kspread":
                                case "application/vnd.ms-excel":
                                case "text/csv":
                                case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
                                case "application/vnd.openxmlformats-officedocument.spreadsheetml.template":
                                    iconType = "spreadsheet"
                                    break
                                case "application/vnd.oasis.opendocument.presentation":
                                case "application/vnd.oasis.opendocument.presentation-template":
                                case "application/x-kpresenter":
                                case "application/vnd.ms-powerpoint":
                                case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
                                case "application/vnd.openxmlformats-officedocument.presentationml.template":
                                    iconType = "presentation"
                                    break
                                case "application/vnd.oasis.opendocument.text-master":
                                case "application/vnd.oasis.opendocument.text":
                                case "application/vnd.oasis.opendocument.text-template":
                                case "application/msword":
                                case "application/rtf":
                                case "application/x-mswrite":
                                case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
                                case "application/vnd.openxmlformats-officedocument.wordprocessingml.template":
                                case "application/vnd.ms-works":
                                    iconType = "formatted"
                                    break
                                default:
                                    if (mimeType.indexOf("audio/") == 0) {
                                        iconType = "audio"
                                    } else if (mimeType.indexOf("image/") == 0) {
                                        iconType = "image"
                                    } else if (mimeType.indexOf("video/") == 0) {
                                        iconType = "video"
                                    }
                                }
                                iconSource = "image://theme/icon-m-file-" + iconType
                            }
                            return iconSource + (highlighted ? "?" + Theme.highlightColor : "")
                        }
                    }
                }
                Column {
                    width: parent.width - parent.height - parent.spacing - Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: -Theme.paddingSmall
                    Label {
                        text: model.fileName
                        width: parent.width
                        font.pixelSize: Theme.fontSizeLarge
                        truncationMode: TruncationMode.Fade
                        color: highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    Label {
                        property string dateString: Format.formatDate(model.modified, Formatter.DateLong)
                        text: model.isDir ? dateString
                                            //: Shows size and modification date, e.g. "15.5MB, 02/03/2016"
                                            //% "%1, %2"
                                          : qsTrId("filemanager-la-file_details").arg(Format.formatFileSize(model.size)).arg(dateString)
                        width: parent.width
                        truncationMode: TruncationMode.Fade
                        font.pixelSize: Theme.fontSizeSmall
                        color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    }
                }
            }


            onClicked: {
                if (model.isDir) {
                    pageStack.push(Qt.resolvedUrl("SaveAsPage.qml"),
                                   { path: fileModel.appendPath(model.fileName), homePath: page.homePath, callback: page.callback })
                } else {
                    filePath = fileModel.path + "/" + model.fileName;
                    console.log("###", mimeType, filePath);
                    nameField.text = filePath;
                }
            }

        }
        ViewPlaceholder {
            enabled: fileModel.count === 0
            //% "No files"
            text: qsTrId("filemanager-la-no_files")
        }
        VerticalScrollDecorator {}
    }
}
