#ifndef GENERALLOGIC_H
#define GENERALLOGIC_H

#include <QCoreApplication>
#include <QTextStream>
#include <QProcess>

class GeneralLogic : public QObject {
    Q_OBJECT
public:
    GeneralLogic();
private:
    QString queryMime(QString code);

public slots:
    QString setDefaultApp(QString app);
    bool isDefaultApp();
    QString getQuickNotePath();
};

#endif // GENERALLOGIC_H
