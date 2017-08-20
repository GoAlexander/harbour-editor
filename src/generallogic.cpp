#include "generallogic.h"
#include <QStandardPaths>
#include <QDebug>
#include <QObject>

GeneralLogic::GeneralLogic()
{

}

//Input can be:
//harbour-editor.desktop
//jolla-notes.desktop
QString GeneralLogic::setDefaultApp(QString app) {
    QString code = "xdg-mime default " + app + " text/plain";
    return queryMime(code);
}

//Check if harbour-editor.desktop is default app
bool GeneralLogic::isDefaultApp() {
    QString code = "xdg-mime query default text/plain";
    QString output = queryMime(code);

    return QString::compare(output, "harbour-editor.desktop") == 1;
}

QString GeneralLogic::queryMime(QString code) {
    QProcess exec;
    exec.start(code);
    exec.waitForFinished();
    QString output = exec.readAllStandardOutput();

    return output;
}


QString GeneralLogic::getQuickNotePath() {
    return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/harbour-editor-quickNote.txt";
}
