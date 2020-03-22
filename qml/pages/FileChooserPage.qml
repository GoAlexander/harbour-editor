/*
*  Taken from https://github.com/CODeRUS/splashscreen-changer/blob/master/settings/SecondPage.qml
*  Thanks coderus!
*/

import QtQuick 2.6
import Sailfish.Silica 1.0
;import Nemo.FileManager 1.0
;import Sailfish.FileManager 1.0
import io.thp.pyotherside 1.5
import "../pages"

Page {
    id: page
    allowedOrientations: Orientation.All

    property int txtfldwdth
    property alias path: fileModel.path
    property string homePath
    property string title
    property bool showFormat
    property bool inclHiddenFiles

    signal formatClicked

    property var callback

    function onManual(){
    //    console.log(inclHiddenFiles);
        var query
        query=py3.call_sync('editFile.tryPath',[id_textfield.text]);
        if(query == "Dir"){
            pageStack.push(Qt.resolvedUrl("FileChooserPage.qml"),
                           { path: fileModel.appendPath(id_textfield.text), inclHiddenFiles: inclHiddenFiles, homePath: page.homePath, callback: page.callback })
           id_textfield.text=path;
        }
        else if(query == "File"){
            var textstring = id_textfield.text + "";

            if (typeof callback == "function") {
                callback(textstring); //return to the page from which this page was called
            }
        }
    }

    Python {
        id: py3 //TODO rename!
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl("."));
            importModule('editFile', function () {});
        }
    }

    backNavigation: !FileEngine.busy

    Rectangle {
        id: rect_path
        color: Theme.highlightDimmerColor
        opacity: 0.7
        height: Theme.itemSizeSmall
        anchors {left: parent.left; right: parent.right; top: parent.top}

        TextField {
            id: id_textfield
            anchors {left:parent.left; right: ret.left; top: parent.top; bottom: parent.bottom; topMargin: Theme.paddingSmall; leftMargin: Theme.itemSizeSmall}
            text: path
            labelVisible: false
            font.pixelSize: Theme.fontSizeLarge 
            Keys.onReturnPressed: {
                onManual();
               }
            }

        Row{
           id: ret
           anchors {right: parent.right;top: parent.top; bottom: parent.bottom;}
           width: Theme.itemSizeExtraLarge
          Button{
            width: ret.width /2
            Image{
                anchors.fill: parent
                source: "image://theme/icon-m-forward"
                fillMode: Image.PreserveAspectFit
            }
            onClicked: {onManual()}
          }

          Button{
            width: ret.width /2
            Image{
                id: butt_nav
                anchors.fill: parent
                source: "image://theme/icon-m-down"
                fillMode: Image.PreserveAspectFit
            }
            onClicked: {
                files_quick.visible = !files_quick.visible;
                if(files_quick.visible){
                    files_quick.height=ret.width * 2.5;
                    butt_nav.source="image://theme/icon-m-up"
                }
                else{
                    files_quick.height=0;
                    butt_nav.source="image://theme/icon-m-down"
                }
            }
          }
        }
    }

    Column {
        id: files_quick
        visible: false
        anchors {top: rect_path.bottom; left: parent.left; right: parent.right}
        height: 0 //ret.width * 3
    Behavior on height {
            PropertyAnimation { duration: 150; easing.type: Easing.Linear }
    }
        ListItem {
          Label{
            anchors {centerIn: parent}
            text: "/"
            font.pixelSize: Theme.fontSizeMedium
            font.bold: true
          }
          MouseArea{
            anchors.fill: parent
            onClicked: {
              if(id_textfield.text!="/"){
                id_textfield.text="/"; onManual();
              }
            }
          }
        }
        ListItem {
          Label{
            anchors {centerIn: parent}
            text: "/home/nemo"
            font.pixelSize: Theme.fontSizeMedium
            font.bold: true
          }
          MouseArea{
            anchors.fill: parent
            onClicked: {
              if(id_textfield.text!="/home/nemo"){
                id_textfield.text="/home/nemo"; onManual();
              }
            }
          }
        }
        ListItem {
          Label{
            anchors {centerIn: parent}
            text: "/usr/share"
            font.pixelSize: Theme.fontSizeMedium
            font.bold: true
          }
          MouseArea{
            anchors.fill: parent
            onClicked: {
              if(id_textfield.text!="/usr/share"){
                id_textfield.text="/usr/share"; onManual();
              }
            }
          }
        }

        Rectangle {width: parent.width; height: 2}
        ListItem {
          Label{
            anchors {centerIn: parent}
            text: "History"
            font.pixelSize: Theme.fontSizeMedium
            font.bold: true
          }
          MouseArea{
            anchors.fill: parent
            onClicked: {
                pageStack.push(Qt.resolvedUrl("../pages/HistoryPage.qml"));
              }
            }
          }
    //    Label {
    //        text: "Custom"
    //        font.pixelSize: Theme.fontSizeExtraSmall
            //font.bold: true
    //    }
    //    Rectangle {width: parent.width; height: 2}
    }

    FileModel {
        id: fileModel
        includeHiddenFiles: inclHiddenFiles
        path: "/home/nemo"
        active: page.status === PageStatus.Active
        directorySort: FileModel.SortDirectoriesBeforeFiles
        onPathChanged: {if (path == "/"){
                inclHiddenFiles=inclHiddenFiles;
            }}
        onError: {
            console.log("###", fileName, error)
        }
    }

    SilicaListView {
        id: fileList

        opacity: FileEngine.busy ? 0.6 : 1.0
        Behavior on opacity { FadeAnimator {} }

        anchors {left: parent.left; right: parent.right; bottom: parent.bottom; top: files_quick.bottom}
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
                        font.pixelSize: Theme.fontSizeMedium
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
             //   console.log(inclHiddenFiles);
                if (model.isDir) {
                    pageStack.push(Qt.resolvedUrl("FileChooserPage.qml"),
                                   { path: fileModel.appendPath(model.fileName), inclHiddenFiles: inclHiddenFiles, homePath: page.homePath, callback: page.callback });
                } else {
                    var filePath = fileModel.path + "/" + model.fileName;
                    console.log("###", mimeType, filePath);

                    if (typeof callback == "function") {
                        callback(filePath); //return to the page from which this page was called
                    }
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
