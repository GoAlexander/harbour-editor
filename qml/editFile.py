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

#var PATH_TO_JSON = "/home/nemo/.local/share/harbour-editor/editor.json"

def getValue(key):
    try:
        with open("/home/nemo/.local/share/harbour-editor/editor.json") as data_file:
            data = json.load(data_file)
    except:
        createJson() # !!!
        with open("/home/nemo/.local/share/harbour-editor/editor.json") as data_file:
            data = json.load(data_file)
    return data[key] #TODO: проверить, что правильно передается key


def setValue(key, value):
    with open("/home/nemo/.local/share/harbour-editor/editor.json") as data_file:
        data = json.load(data_file)
    data[key] = value #TODO: проверить, что правильно передается key

def createJson():
    if (!os.path.exists("/home/nemo/.local/share/harbour-editor/editor.json")):
        os.mkdir("/home/nemo/.local/share/harbour-editor")
    str = '{' + '"headerVisible": true,' + '"lineNumbersVisible": false,' + '"fontType": "Theme.fontFamily",' + '"fontSize": "Theme.fontSizeMedium",' + '"showHiddenFiles": false,' + '"history": [' + '"/home/nemo/Documents/notes.txt",' + '"/home/nemo/Documents/test.txt"' + ']' + '}'
    file = open("/home/nemo/.local/share/harbour-editor/editor.json", 'w')
    file.write(str)
    file.close()
    return
