import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {
    property var database

    Component.onCompleted: {
        database = LocalStorage.openDatabaseSync("HarbourEditor", "1.0")
        database.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS SettingsTable(
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 date TEXT,
                 sum INTEGER,
                 category_id INTEGER,
                 type INTEGER,
                 goal_id INTEGER,
                 description TEXT)");
//            tx.executeSql("CREATE TABLE IF NOT EXISTS CategoriesTable(
//                 id INTEGER PRIMARY KEY AUTOINCREMENT,
//                 name TEXT,
//                 type INTEGER)");
//            tx.executeSql("CREATE TABLE IF NOT EXISTS GoalTable(
//                 id INTEGER PRIMARY KEY AUTOINCREMENT,
//                 name TEXT,
//                 sum INTEGER,
//                 isFinished INTEGER)");
//            var result = tx.executeSql("SELECT COUNT(*) as count FROM CategoriesTable").rows.item(0).count;
//            if (result === 0) {
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Food"), TransactionTypeEnum.Expense]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Car"), TransactionTypeEnum.Expense]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Cafe"), TransactionTypeEnum.Expense]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Cellular"), TransactionTypeEnum.Expense]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("House"), TransactionTypeEnum.Expense]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Health"), TransactionTypeEnum.Expense]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Others"), TransactionTypeEnum.Expense]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Salary"), TransactionTypeEnum.Income]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Savings"), TransactionTypeEnum.Income]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Premium"), TransactionTypeEnum.Income]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Goal progress"), TransactionTypeEnum.Goal]);
//                tx.executeSql("INSERT INTO CategoriesTable(name, type) VALUES(?, ?)",
//                              [qsTr("Goal finish"), TransactionTypeEnum.FinishedGoal]);
//            }
        });
//        updateStatisticsValue();
    }
}
