#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pyotherside
import os
import json

def openings(filepath):
    if os.path.exists(filepath):
        if os.path.exists(filepath + "~"):
            file = open(filepath + "~", 'r')
        else:
            file = open(filepath, 'r')
    else:
        file = open(filepath, 'a+')
    txt = file.read()
    file.close()
    return txt

def savings(filepath, text):
    if os.path.exists(filepath+"~"):
        os.remove(filepath+"~")
    file = open(filepath, 'w')
    file.write(text)
    file.close()
    return

def autosave(filepath, text):
    if(filepath.endswith("~")):
        file = open(filepath, 'w')
    else:
        file = open(filepath+"~", 'w')
    file.write(text)
    file.close()

def isSaved(filepath):
    if os.path.exists(filepath + "~"):
        return False
    else:
        return True

#----------------------------------------

PATH_TO_FOLDER = os.environ['HOME'] + "/.local/share/harbour-editor"
PATH_TO_SETTINGS = PATH_TO_FOLDER + "/settings2.json"
PATH_TO_HISTORY = PATH_TO_FOLDER + "/history.json"

def _getFromJson(path, type, key):
    try:
        with open(path, "r") as data_file:
            data = json.load(data_file)
    except:
        if type == "settings":
            createSettingsJson()
        elif type == "history":
            createHistoryJson()
        with open(path, "r") as data_file:
            data = json.load(data_file)
    return data[key]

def _setToJson(path, key, value):
    with open(path, "r") as data_file:
        data = json.load(data_file)
    data[key] = value

    with open(path, "w") as data_file:
        data_file.write(json.dumps(data))
    return

def getValue(key):
    return _getFromJson(PATH_TO_SETTINGS, "settings", key)

def setValue(key, value):
    return _setToJson(PATH_TO_SETTINGS, key, value)

def getHistory(key):
    return _getFromJson(PATH_TO_HISTORY, "history", key)

def setHistory(key, value):
    return _setToJson(PATH_TO_HISTORY, key, value)


def createSettingsJson():
    if not os.path.exists(PATH_TO_FOLDER):
        os.mkdir(PATH_TO_FOLDER)
    str = '{' + '"headerVisible": true, ' + '"lineNumbersVisible": false, ' + '"fontType": "Sail Sans Pro Light", ' + '"fontSize": 40, ' + '"tabType": "    ", ' + '"showHiddenFiles": false, ' + '"darkTheme": "false", ' + '"autosave": true ' + '}'
    file = open(PATH_TO_SETTINGS, 'w')
    file.write(str)
    file.close()
    return

def createHistoryJson():
    if not os.path.exists(PATH_TO_FOLDER):
        os.mkdir(PATH_TO_FOLDER)
    str = '{' + '"history": [' + ' ' + ']' + '}'
    file = open(PATH_TO_HISTORY, 'w')
    file.write(str)
    file.close()
    return
