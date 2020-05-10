Editor.
-fork of original package from <GoAlexander>, original text:
“Editor” is the application that helps you to edit your documents and code. It has all the features of text editor and something more. There is a list of current features and it continues to increase:

    Toolbar near keyboard
    Number of lines and symbols counter
    R-only: read-only mode (disables keyboard)
    Autosave
    Undo\redo
    Search
    Tab button
    History
    Code highlighting (javascript, qml, python and sh languages)
    MIME-support

* Sat Nov 23 2019 Petr Skoumal <-willbeupdatednexttime> 0.9

CHANGED/REPAIRED:
- Line counting now works
- Line counting recalculate after orientation change
- Bottom panel rearranged to have more space at Landscape
- Little bit code refurbishment

TODO: 
- More code refurbishment
- Create patch/package/possibility to open App as root /devel 
(in a way like Tiny, FileBrowser etc.)

* Sun Jun 05 2018 GoAlexander 0.8.5
Experimental:
-There is capability of numeration of lines. But this feature is experimental one that is why it works only for NOT loaded documents.

Some tips and comments:

    Autosave feature stores your text in special file ending with ~, located in the directory where your original file is located. Don`t be afraid to forget to save the file or accidentally exit the app!
    Don`t open files which ending with ~. The last version of document will be loaded automatically. So load only(!) original files.

Known bugs:

    Combobox of tab can not be dynamically changed. It needs to reopen SettingsPage to see the changes.

Source code: https://github.com/GoAlexander/harbour-editor

Do not hesitate to contact me in case of any questions / suggestions!