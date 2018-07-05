# Editor.
Description is in progress...

Rules for translation
---------------------
Translation of buttons on FirstPage has to be NOT longer than 7 symbols (better 4-5 symbols).  
Examples:
- `Save as` - maximal length
- `Save` - optimal length  
  
If you can not do translation of buttons short try solution of @rabauke - empty the translation context.  
Screenshot: https://cloud.githubusercontent.com/assets/1159508/22174835/1e7fa1e2-dfe8-11e6-8c81-f1391a6ab08a.png

Public To Do
------------
[Trello](https://trello.com/b/Gyu7pPqi/harbour-editor)

Markets
-------
Application published in the following repositories:
- Official Jolla Store
- [openrepos.net](https://openrepos.net/content/goalexander/editor)

Important notes
---------------
- Because of OS default File Manager minimal version of Sailfish OS should be 2.0.5 

Some tips for the developers
----------------------------

If you want to have automatically changeable version counter in your QML you can read this thread:
https://lists.sailfishos.org/pipermail/devel/2015-January/005559.html

>a) in your .yaml add the lines:  
QMakeOptions:  
\- VERSION=%{version}  
b) in your .pro add the lines:  
DEFINES += APP_VERSION=\"\\\"$${VERSION}\\\"\"  
c) in your .c's main() function add the lines:  
QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));  
app->setApplicationVersion(QString(APP_VERSION));  
d) now your app's version is available in QML through  
Qt.application.version  
  
Alternative:  
In .pro file add:  
`VERSION = $$system("echo $(awk -F ':' '/Version/ {print $2}' rpm/$${TARGET}.yaml)")`  
And then same steps in C++ files...
  
License
-------

    Copyright (c) 2016-2017 Alexander Dydychkin

    Editor. is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Editor. is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Editor.. If not, see http://www.gnu.org/licenses/.
