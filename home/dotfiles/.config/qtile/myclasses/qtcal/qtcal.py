"""
    Copyright (C) 2024  Simon Heise

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""

import sqlite3
import psutil
from re import match
import os, sys
from PyQt6.QtCore import Qt, QDate
from PyQt6 import uic
from datetime import date, datetime, timedelta
from PyQt6.QtGui import QFont
from PyQt6.QtWidgets import QMainWindow, QApplication, QTableWidgetItem

############################################################

class QtCalWindow(QMainWindow):
    def showAppointment(self, date):
        # Change dateinputfields to selected date
        self.iDatetimeStart.setDate(date)
        self.iDatetimeEnd.setDate(date)

        self.selectedQDate = date
        selectedDate = (
            str(date.getDate()[0])
            + "-"
            + str(date.getDate()[1]).zfill(2)
            + "-"
            + str(date.getDate()[2]).zfill(2)
        )

        # fill list with tracking entries
        vSqlResults = selectDbData(
            self.sqlCon,
            """SELECT * from appointments where date = ? order by date, starttime asc""",
            (selectedDate,),
        )
        self.lEntries = []
        # write sql results into list
        for results in vSqlResults:
            self.lEntries.append(results)
        # add rows to the table according to the number of tracking results
        self.tableWidget.setRowCount(len(self.lEntries))

        # fill table with entries
        curRow = 0
        for entry in self.lEntries:
            for column in range(0, len(entry)):
                qtTableItem = QTableWidgetItem(str(entry[column]))
                if column == 0:
                    # show tracking id but don't allow to change
                    qtTableItem.setFlags(
                        qtTableItem.flags() & ~Qt.ItemFlag.ItemIsEditable
                    )
                self.tableWidget.setItem(curRow, column, qtTableItem)
            curRow += 1

    def createAppointment(self):
        # entered text and dates/times
        appointmentText = self.iEventText.toPlainText()
        print()
        appointmentDate = self.iDatetimeStart.dateTime().toPyDateTime().date()
        startTime = self.iDatetimeStart.dateTime().toPyDateTime().strftime("%H:%M")
        endTime = self.iDatetimeEnd.dateTime().toPyDateTime().strftime("%H:%M")
        vSqlQuery = """ INSERT INTO appointments(date, text,starttime, endtime)
                        VALUES(?,?,?,?) """
        vSqlData = (appointmentDate, appointmentText, startTime, endTime)
        sqlResult = insertDbData(self.sqlCon, vSqlQuery, vSqlData)

        # Update events table
        self.showAppointment(self.selectedQDate)

    def getEntryList(self):
        return self.tableWidget.selectedItems()

    def deleteAppointment(self):
        lListofEntries = QTableWidgetItem()
        lListofEntries = self.getEntryList()

        firstItemIndex = lListofEntries[0].row()
        lastItemIndex = lListofEntries[len(lListofEntries) - 1].row()

        # create one sql-query for deletion of all selected items
        sqlQuery = "delete from appointments where id in ( "

        # lListofEntries contains list with all columns of all selected rows
        # -->delete entries where index%NumColumns=0
        for numEntry in range(0, len(lListofEntries) - 1):
            entrySplit = str(lListofEntries[numEntry].text())
            if numEntry % self.numColumns == 0:
                sqlQuery = sqlQuery + entrySplit + ","
        # cut last "," and finish query-string
        sqlQuery = sqlQuery[:-1] + " )"

        # Delete selection from database
        deletionResult = deleteDbData(self.sqlCon, sqlQuery, ())
        if deletionResult == 0:
            # items where deleted --> update table
            for numEntry in reversed(range(0, len(lListofEntries) - 1)):
                try:
                    self.tableWidget.removeRow(lListofEntries[numEntry].row())
                except:
                    None

    def setupUIfunctions(self):
        # Show appointments in table when date is selected
        self.calendarWidget.clicked.connect(self.showAppointment)

        # buttons
        # new appointment
        self.bNewEvent.clicked.connect(self.createAppointment)
        # delete appointment
        self.bDeleteEvent.clicked.connect(self.deleteAppointment)

        # Datetimeimputs
        self.iDatetimeStart.setDateTime(datetime.today())
        self.iDatetimeEnd.setDateTime(datetime.today() + timedelta(hours=1))

        # table headers
        columnHeaders = ("id", "date", "starttime", "endtime", "appointment")
        self.tableWidget.setHorizontalHeaderLabels(columnHeaders)
        self.tableWidget.setColumnWidth(0, 60)
        self.tableWidget.setColumnWidth(1, 140)
        self.tableWidget.resizeColumnToContents(4)

    def __init__(self, sqlVer, sqlCon):
        super(QtCalWindow, self).__init__()
        self.sqlCon = sqlCon
        self.curDay = date.today()
        self.numColumns = 5

        self.absolute_path = os.path.dirname(__file__)

        uic.loadUi(os.path.join(self.absolute_path, "config/ui/QtCalWindow.ui"), self)
        self.setupUIfunctions()
        self.selectedQDate = self.calendarWidget.selectedDate()

        # create DB-Model
        vSqlQuery = """CREATE TABLE IF NOT EXISTS databasemodel (
                        id integer PRIMARY KEY,
                        modelversion text  NOT NULL,
                        sqlcommand text  NOT NULL,
                        executed text NOT NULL,
                        UNIQUE (modelversion, sqlcommand)
                        )"""
        vSqlData = ()
        updateDbData(sqlCon, vSqlQuery, vSqlData)

        vSqlQuery = """CREATE TABLE IF NOT EXISTS appointments (
                        id integer PRIMARY KEY,
                        date text NOT NULL,
                        starttime text NOT NULL,
                        endtime text NOT NULL,
                        text text NOT NULL
                        )"""
        vSqlData = ()
        updateDbData(sqlCon, vSqlQuery, vSqlData)

        # insert modelversion of database
        vSqlQuery = """INSERT INTO databasemodel (modelversion, sqlcommand, executed) VALUES (20240203, 'create table databasemodel', 'run')"""
        vSqlData = ()
        updateDbData(sqlCon, vSqlQuery, vSqlData)


###############################################################################


def createDatabaseConnection(dbFile):
    DbConnection = None
    DbVersion = None
    try:
        DbConnection = sqlite3.connect(dbFile)
        DbVersion = sqlite3.version
    except sqlite3.Error as e:
        DbVersion = e
    return DbVersion, DbConnection


def insertDbData(conn, sqlQuery, insertData):
    try:
        dbCursor = conn.cursor()
        dbCursor.execute(sqlQuery, insertData)
        conn.commit()
        return dbCursor.lastrowid
    except sqlite3.Error as e:
        return e


def selectDbData(conn, sqlQuery, whereData):
    try:
        dbCursor = conn.cursor()
        dbCursor.execute(sqlQuery, whereData)
        selectResults = dbCursor.fetchall()
        return selectResults
    except sqlite3.Error as e:
        return e


def updateDbData(conn, sqlQuery, sqlData):
    try:
        dbCursor = conn.cursor()
        dbCursor.execute(sqlQuery, sqlData)
        conn.commit()
        return 0
    except sqlite3.Error as e:
        return e


def deleteDbData(conn, sqlQuery, whereData):
    try:
        dbCursor = conn.cursor()
        dbCursor.execute(sqlQuery, whereData)
        conn.commit()
        return 0
    except sqlite3.Error as e:
        return e


def execute_sqlfile(conn, filename):
    try:
        dbCursor = conn.cursor()
        # read files into array aSqlFile
        filehandler = open(filename, "r")
        aSqlFile = filehandler.read()
        aSqlFileSplit = aSqlFile.split("##")
        filehandler.close()
        for sqlQuery in aSqlFileSplit:
            dbCursor.execute(sqlQuery)
        conn.commit()
    except sqlite3.OperationalError as e:
        return e, sqlQuery
    return 0, 0


def main():
    try:
        if match("--datadir", sys.argv[1]):
            datadir = sys.argv[1][10:]
            if not os.path.exists(datadir):
                os.makedirs(datadir)
    except:
        absolute_path = os.path.dirname(__file__)

        relative_path = "data"
        datadir = os.path.join(absolute_path, relative_path)
        if not os.path.exists(datadir):
            os.makedirs(datadir)

    vDbVersion = None
    vDbConnection = None
    # create Database-Connection to sqllite-DB
    # important: "~" for home doesn't work
    vDbVersion, vDbConnection = createDatabaseConnection(datadir + "/qtcal.db")

    instance_found = False
    for process in psutil.process_iter(["name"]):
        print(process.info["name"])
        for item in process.info["name"]:
            if match(".*qtcal", item):
                instance_found = True

    if instance_found == False:
        # You need one (and only one) QApplication instance per application.
        # Pass in sys.argv to allow command line arguments for your app.
        # If you know you won't use command line arguments QApplication([]) works too.
        qtcalApp = QApplication(sys.argv)
        qtcalApp.setFont(QFont("Awesome", 16))
        qtcalApp.setApplicationName("qtcal")

        # Create a Qt widget, which will be our window.
        qtcalWindow = QtCalWindow(vDbVersion, vDbConnection)
        qtcalWindow.setWindowTitle("qtcal")
        # IMPORTANT!!!!! Windows are hidden by default.
        qtcalWindow.show()
        # Start the event loop.
        sys.exit(qtcalApp.exec())


if __name__ == "__main__":
    main()
