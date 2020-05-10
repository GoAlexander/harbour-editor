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

import QtQuick 2.6
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import Nemo.Notifications 1.0
import "pages"

ApplicationWindow
{
    id: mainwindow
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

    property bool inclHiddenFiles
    property bool autosave

    property string encRegion
    property string encPreferred

    property bool darkTheme
    property string bgColor
    property string textColor
    property string buttonsColor
    property string qmlHighlightColor
    property string keywordsHighlightColor
    property string propertiesHighlightColor
    property string javascriptHighlightColor
    property string stringHighlightColor
    property string commentHighlightColor
    property string customButtColor
    property string theme: Theme._homeBackgroundImage

    function actualButtonColor(){
        if(customButtColor != ""){
            var themeproperties = ["darkPrimaryColor", "darkSecondaryColor", "errorColor", "highlightBackgroundColor", "highlightBackgroundOpacity", "highlightColor",
                                   "highlightDimmerColor", "lightPrimaryColor", "lightSecondaryColor", "overlayBackgroundColor", "primaryColor", "secondaryColor",
                                   "secondaryHighlightColor"]

            var svgcolors = ["aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "burlywood",
                             "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray",
                             "darkgreen", "darkgrey", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen",
                             "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue",
                             "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew",
                             "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan",
                             "lightgoldenrodyellow", "lightgray", "lightgreen", "lightgrey", "lightpink", "lightsalmon", "lightseagreen", "lightskyblue", "lightslategray",
                             "lightslategrey", "lightsteelblue", "lightyellow", "lime", "limegreen", "linen", "magenta", "maroon", "mediumaquamarine", "mediumblue", "mediumorchid",
                             "mediumpurple", "mediumseagreen", "mediumslateblue", "mediumspringgreen", "mediumturquoise", "mediumvioletred", "midnightblue", "mintcream", "mistyrose",
                             "moccasin", "navajowhite", "navy", "oldlace", "olive", "olivedrab", "orange", "orangered", "orchid", "palegoldenrod", "palegreen", "paleturquoise",
                             "palevioletred", "papayawhip", "peachpuff", "peru", "pink", "plum", "powderblue", "purple", "red", "rosybrown", "royalblue", "saddlebrown", "salmon",
                             "sandybrown", "seagreen", "seashell", "sienna", "silver", "skyblue", "slateblue", "slategray", "slategrey", "snow", "springgreen", "steelblue", "tan",
                             "teal", "thistle", "tomato", "turquoise", "violet", "wheat", "white", "whitesmoke", "yellow", "yellowgreen"]

            var custButtColorTemp= customButtColor.split(".")

            if(custButtColorTemp[0] === "Theme"){
              if(themeproperties.indexOf(custButtColorTemp[1]) != -1){
                console.log(custButtColorTemp[1]);
                buttonsColor= Theme[custButtColorTemp[1]];
              }
            }

            else{
              if(svgcolors.indexOf(customButtColor) != -1){
                 console.log(customButtColor);
                 buttonsColor=customButtColor;
              }
            }
        }
        else{
          if(Theme.colorScheme == 0){
            buttonsColor=Theme.highlightColor;}
          else if (Theme.colorScheme == 1){
            buttonsColor=Theme.darkPrimaryColor;
          }
        }
    }

    //Theme.colorScheme = 0 "DarkTheme", 1 "LightTheme"
    function applyAmbienceThemeColors(){
        qmlHighlightColor=Theme.highlightColor;
        keywordsHighlightColor=Qt.darker(Theme.highlightColor,1.5);
        propertiesHighlightColor=Qt.darker(Theme.primaryColor,1.5);
        javascriptHighlightColor=Theme.secondaryHighlightColor;
        stringHighlightColor=Theme.secondaryColor;
        commentHighlightColor= Qt.lighter(Theme.highlightBackgroundColor);
        bgColor="transparent";

        actualButtonColor();

        if(Theme.colorScheme == 0){
          textColor=Theme.highlightColor;
        }
        else if (Theme.colorScheme == 1){
          textColor=Theme.primaryColor;
        }
    }

    Timer {
        id: ambiencetimer
        interval: 1
        onTriggered: {applyAmbienceThemeColors();}
    }

    onThemeChanged: {
        if (!darkTheme) {
            ambiencetimer.start();
        }
    }

    onCustomButtColorChanged: {
        mainwindow.applyThemeColors();
    }

    Python {
        id: py2 //TODO rename!
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl("."));
            importModule('editFile', function () {});
        }
    }
    function applyThemeColors(){
        if (darkTheme) {
           textColor="#cfbfad"
           qmlHighlightColor="#ff8bff"
           keywordsHighlightColor="#808bed"
           propertiesHighlightColor="#ff5555"
           javascriptHighlightColor="#8888ff"
           stringHighlightColor="#ffcd8b"
           commentHighlightColor="#cd8b00"
           buttonsColor = "white"
           bgColor="#1e1e27"
         }
         else {
            applyAmbienceThemeColors()
         }
    }

    function getSettings(){
       var result
       result=py2.call_sync('editFile.getSettings');

       headerVisible=result.headerVisible;
       lineNumbersVisible=result.lineNumbersVisible;
       fontType=result.fontType;
       fontSize=result.fontSize;
       tabType=result.tabType;
       inclHiddenFiles=result.showHiddenFiles;
       darkTheme=result.darkTheme;
       autosave=result.autosave;
       encRegion=result.encRegion;
       encPreferred=result.encPreferred;
       customButtColor=result.customButtColor;

       applyThemeColors();
       console.log("\nheaderVisible:" + headerVisible + "\nlineNumbersVisible:" + lineNumbersVisible + "\nfontType:'" + fontType + "'\nfontSize:" + fontSize + "\ntabType:'" + tabType + "'\nshowHiddenFiles:" + inclHiddenFiles + "\ndarkTheme:" + darkTheme + "\nautosave:" + autosave + "\nencRegion:'" + encRegion + "'\nencPreferred:'" + encPreferred + "'" + "\ncustomButtColor:'" + customButtColor + "'");
    }

   initialPage: Component {
       FirstPage {
           id: mainPage
           Component.onCompleted: {
               mainwindow.getSettings();
               //open file from commandline
               var args = Qt.application.arguments
               if (args.length > 1) {
                   mainPage.filePath=args[1]
                   console.log(filePath)
               }
           }
       }
   }
}
