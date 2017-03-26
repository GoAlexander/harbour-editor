import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {
    property var database

    Component.onCompleted: {
        database = LocalStorage.openDatabaseSync("HarbourEditor", "1.0")
        database.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS SettingsTable(
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 headerVisible INTEGER,
                 lineNumbersVisible INTEGER,
                 fontType TEXT,
                 tabType TEXT,
                 fontSize INTEGER,
                 showHiddenFiles INTEGER,
                 darkTheme INTEGER,
                 bgColor TEXT)");            
//            tx.executeSql("CREATE TABLE IF NOT EXISTS CategoriesTable(
//                 id INTEGER PRIMARY KEY AUTOINCREMENT,
//                 name TEXT,
//                 type INTEGER)");
            var result = tx.executeSql("SELECT COUNT(*) as count FROM SettingsTable").rows.item(0).count;
            if (result === 0) {
                tx.executeSql("INSERT INTO SettingsTable(headerVisible, lineNumbersVisible, fontType, tabType, fontSize, showHiddenFiles, darkTheme, bgColor) VALUES(?, ?, ?, ?, ?, ?, ?, ?)",
                              [1, 0, "Sail Sans Pro Light", "    ", 40, 0, 0, "transparent"]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Goal finish"), TransactionTypeEnum.FinishedGoal]);
            }
        });
    }

    function getValue(callback) {
        database = LocalStorage.openDatabaseSync("HarbourEditor", "1.0");
        database.readTransaction(function(tx) {
            //var result = tx.executeSql("SELECT * FROM SettingsTable WHERE isFinished = ?", [key]);
            var result = tx.executeSql("SELECT * FROM SettingsTable");
            callback(result.rows)
        });
    }

    //TODO нестабильно!
    function setValue(/*key,*/ value) {
        database = LocalStorage.openDatabaseSync("HarbourEditor", "1.0");
        database.transaction(function(tx) {
            //tx.executeSql("UPDATE SettingsTable SET darkTheme = ?", [value]);
            tx.executeSql("INSERT INTO SettingsTable(darkTheme) VALUES(?)", [value]);
        });
    }
}
