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
    else: # For what? :)
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
    return

def isSaved(filepath):
    if os.path.exists(filepath + "~"):
        return False
    else:
        return True

#----------------------------------------

PATH_TO_SETTINGS = os.environ['HOME'] + "/.local/share/harbour-editor/settings.json"
PATH_TO_HISTORY = os.environ['HOME'] + "/.local/share/harbour-editor/history.json"
PATH_TO_FOLDER = os.environ['HOME'] + "/.local/share/harbour-editor"

def getValue(key):
    try:
        with open(PATH_TO_SETTINGS, "r") as data_file:
            data = json.load(data_file)
    except:
        createSettingsJson()
        with open(PATH_TO_SETTINGS, "r") as data_file:
            data = json.load(data_file)
    return data[key]

def setValue(key, value):
    with open(PATH_TO_SETTINGS, "r") as data_file:
        data = json.load(data_file)
    data[key] = value

    with open(PATH_TO_SETTINGS, "w") as data_file:
        data_file.write(json.dumps(data))
    return

def getHistory(key):
    try:
        with open(PATH_TO_HISTORY, "r") as data_file:
            data = json.load(data_file)
    except:
        createHistoryJson()
        with open(PATH_TO_HISTORY, "r") as data_file:
            data = json.load(data_file)
    return data[key]

def setHistory(key, value):
    with open(PATH_TO_HISTORY, "r") as data_file:
        data = json.load(data_file)
    data[key] = value

    with open(PATH_TO_HISTORY, "w") as data_file:
        data_file.write(json.dumps(data))
    return


def createSettingsJson():
    if not os.path.exists(PATH_TO_FOLDER):
        os.mkdir(PATH_TO_FOLDER)

    #+ '"tabType": "\t", '
    str = '{' + '"headerVisible": true, ' + '"lineNumbersVisible": false, ' + '"fontType": "Sail Sans Pro Light", ' + '"fontSize": 40, ' + '"tabType": "    ", ' + '"showHiddenFiles": false, ' + '"bgColor": "transparent" ' + '}'
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
