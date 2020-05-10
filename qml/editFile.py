# #!/usr/bin/env python
# -*- coding: utf-8 -*-
# 'windows-1250'

import pyotherside
import os
import json

def encOpen(filepath, enctypes):
    for encoding_type in enctypes:
     if os.path.exists(filepath):
      if os.path.exists(filepath + "~"):
       file = open(filepath + "~", 'r', encoding=encoding_type)
      else:
       file = open(filepath, 'r', encoding=encoding_type)
     else:
      file = open(filepath, 'a+', encoding=encoding_type)
     try:
      txt = file.read()
      file.close()
      if txt:
       break
     except:
      continue
    return txt, encoding_type

def openings(filepath, encoding_type):
   regions = {
      'Auto': 'Auto',
      'Unicode': ['utf-8', 'utf-16', 'utf-32'],
      'Western Europe': ['windows-1252', 'iso-8859-1'],
      'Central Europe': ['windows-1250', 'iso-8859-2'],
      'Baltic':['windows-1257', 'iso-8859-4'],
      'Middle East':['windows-1254', 'windows-1255','windows-1256']
      #'Chinese'
      #'Taiwan'
      #'Korean'
    }
   enctypes=regions.get(encoding_type)

   if encoding_type != '' and enctypes == None:
     try:
      if os.path.exists(filepath):
       if os.path.exists(filepath + "~"):
        file = open(filepath + "~", 'r', encoding=encoding_type)
       else:
        file = open(filepath, 'r', encoding=encoding_type)
      else:
       file = open(filepath, 'a+', encoding=encoding_type)
      try:
       txt = file.read()
       file.close()
      except:
       encoding_type = ''
     except:
        encoding_type = ''

   if encoding_type == '' or enctypes == 'Auto':
    if os.path.exists(filepath):
     if os.path.exists(filepath + "~"):
      file = open(filepath + "~", 'r')
     else:
      file = open(filepath, 'r')
    else:
      file = open(filepath, 'a+')
    try:
      encoding_type=file.encoding
      txt = file.read()
      file.close()
    except:
       encoding_type = 'NonAuto'

   if encoding_type == 'NonAuto' or enctypes != ('Auto' or None):
    try:
     result=encOpen(filepath, enctypes)
     txt=result[0]
     encoding_type=result[1]
    except:
     result=encOpen(filepath, ['utf-8', 'windows-1250', 'windows-1251', 'windows-1252', 'windows-1254'])
     txt=result[0]
     encoding_type=result[1]

   return txt,encoding_type

def savings(filepath, text, encoding_type):
    if encoding_type == '' or encoding_type == None:
        encoding_type='utf-8'
    if os.path.exists(filepath+"~"):
        os.remove(filepath+"~")
    file = open(filepath, 'w', encoding=encoding_type)
    file.write(text)
    file.close()
    return encoding_type

def autosave(filepath, text, encoding_type):
    if(filepath.endswith("~")):
        file = open(filepath, 'w', encoding=encoding_type)
    else:
        file = open(filepath+"~", 'w', encoding=encoding_type)
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

def tryPath(path):
    if os.path.exists(path):
     if os.path.isdir(path):
        msg = "Dir"
     else:
         msg = "File"
    else:
        msg = "Not"
    return msg

def _getFromJson(path, type):
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
    return data

def _setToJson(path, key, value):
    with open(path, "r") as data_file:
        data = json.load(data_file)
    data[key] = value

    with open(path, "w") as data_file:
        data_file.write(json.dumps(data))
    return

def getSettings():
    return _getFromJson(PATH_TO_SETTINGS, "settings")

def setValue(key, value):
    return _setToJson(PATH_TO_SETTINGS, key, value)

def getHistory():
    return _getFromJson(PATH_TO_HISTORY, "history")

def setHistory(file, encd):
    _setToJson(PATH_TO_HISTORY,"file" , file)
    return _setToJson(PATH_TO_HISTORY,"encd", encd)

def resetHistory():
    os.remove(PATH_TO_HISTORY)
    createHistoryJson()
    return

def resetSettings():
    os.remove(PATH_TO_SETTINGS)
    createSettingsJson()
    return

def createSettingsJson():
    if not os.path.exists(PATH_TO_FOLDER):
        os.mkdir(PATH_TO_FOLDER)
    str = '{"headerVisible": true, "lineNumbersVisible": false, "fontType": "Sail Sans Pro Light", "fontSize": 40, "tabType": "    ", "showHiddenFiles": false, "darkTheme": "false", "autosave": false, "encRegion": "Unicode", "encPreferred": "utf-8" }'
    file = open(PATH_TO_SETTINGS, 'w')
    file.write(str)
    file.close()
    return

def createHistoryJson():
    if not os.path.exists(PATH_TO_FOLDER):
        os.mkdir(PATH_TO_FOLDER)
    str = '{"file": [],"encd": []}'
    file = open(PATH_TO_HISTORY, 'w')
    file.write(str)
    file.close()
    return
