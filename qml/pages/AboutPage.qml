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


Page {
    id: aboutPage

    Column {
        id: column
        spacing: 5
        width: parent.width

        PageHeader {
            title: qsTr("About")
        }

        Text
        {
            id: titleLabel
            anchors { horizontalCenter: parent.horizontalCenter }
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
            color: Theme.highlightColor
            text: "<style>a:link { color: " + Theme.highlightColor + "; }</style><br/>" +
                qsTr("\"Editor.\" is feature-rich text/code editor!") +
                "<br/>" +
                qsTr("License: GPLv3") +
                "<br/><br/>" + qsTr("You can find the source code at the:") +
                "<br/> <a href=\"https://github.com/GoAlexander/harbour-editor\">" +
                qsTr("GitHub") + "</a>" +
                "<br/>" +
                "<br/>" +
                qsTr("If you want to support this app star the repository at the github \u263a") +
                "<br/>" +
                "<br/>" +
                qsTr("Special thanks:") +
                "<br/>" + qsTr("-eekkelund for save/load function and feedback") +
                "<br/>" + qsTr("-osanwe for consultations about qml code") +
                "<br/>" + qsTr("-coderus for various tips") +
                "<br/>" + qsTr("-Russian community for feed back and help") +
                "<br/>" +
                "<br/>" +
                qsTr("Tips:")+
                "<br/>" +
                qsTr("Write about select all...");

            onLinkActivated:
            {
                Qt.openUrlExternally("https://github.com/GoAlexander/harbour-editor");
            }

        }
    }

}





