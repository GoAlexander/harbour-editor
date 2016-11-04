#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pyotherside
import os

def openings(filepath):
    if os.path.exists(filepath):
        file = open(filepath, 'r')
    else:
        file = open(filepath, 'w')
    txt = file.read()
    file.close()
    return txt



def savings(filepath, text):
    file = open(filepath, 'w')
    file.write(text)
    file.close()
    return
