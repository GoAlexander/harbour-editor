/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import io.thp.pyotherside 1.3


ApplicationWindow
{
    id: mainwindow

    initialPage: Component { FirstPage {
            id: mainPage
            Component.onCompleted: {
                //open file from commandline
                var args = Qt.application.arguments
                if (args.length > 1) {
                    mainPage.filePath=args[1]
                    console.log(filePath)
                }
            }
        }
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All


    //These variables are in: FirstPage + SettingsPage + Cover
    property bool headerVisible
    property bool lineNumbersVisible

    property string fontType
    property int fontSize
    property string tabType

    property int charNumber: 0
    property int linesNumber: 0

    property int wordsNumber: 0
    property string fileName

    property bool showHiddenFiles

    property bool darkTheme
    property string bgColor
    property string textColor
    property string qmlHighlightColor
    property string keywordsHighlightColor
    property string propertiesHighlightColor
    property string javascriptHighlightColor
    property string stringHighlightColor
    property string commentHighlightColor

    Python {
        id: py2 //TODO rename!
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl("."));
            importModule('editFile', function () {
                py2.call('editFile.getValue', ["headerVisible"], function(result) {
                    headerVisible=result // result=headerVisible
                });
                py2.call('editFile.getValue', ["lineNumbersVisible"], function(result) {
                    lineNumbersVisible=result
                });

                py2.call('editFile.getValue', ["fontType"], function(result) {
                    fontType=result
                });
                py2.call('editFile.getValue', ["fontSize"], function(result) {
                    fontSize=result
                });
                py2.call('editFile.getValue', ["tabType"], function(result) {
                    tabType=result
                });

                py2.call('editFile.getValue', ["showHiddenFiles"], function(result) {
                    showHiddenFiles=result
                });

                py2.call('editFile.getValue', ["darkTheme"], function(result) {
                    darkTheme=result

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
                });
            });
        }
    }

}
