# -*- coding: utf-8 -*-
# Automatically generated file. do not modify it!!!

import sys, os
from base.helpers import addRelPath
from modeldata.baseclasses import *
from modeldata.changes import *
from modeldata.collects import *
from modeldata.ref import *

addRelPath("../modeldata", "../modeldata/SharedTypes")


from Skin_base import *

class Skin(RefCounted, Identified, ChangeHandler, BaseObject, Skin_base):
    _changeFields = {
        "IsAnimatedAvatar":1,
        "PersistentId":1,
        "WasBought":1,
    }

    def __init__(self, modeldata, id=None, path=None):
        ChangeHandler.__init__(self, path, modeldata)
        RefCounted.__init__(self)
        Identified.__init__(self, id)
        _dict = self.__dict__
        _dict["_modeldata"] = modeldata
        _dict["IsAnimatedAvatar"] = False
        _dict["PersistentId"] = 0
        _dict["WasBought"] = False
        _dict["isDeleting"] = False

    # ���������� �� ���� ������� ����� model.addNewName() -- ��������, � keeper.init() ����� ��������
    def init(self):
        pass

    # ���������� ����� model.addNewName()
    def init_add(self):
        pass

    def setPath(self, path):
        ChangeHandler.init(self, path, self._modeldata)

    def deleteByID(self, id):
        if not self.isDeleting:
            self.isDeleting = True
            self.isDeleting = False

    def __setattr__(self, name, val):
        if name not in self.__dict__ or  val != self.__dict__[name]:
            ChangeHandler.__setattr__(self, name, val)


    def generateJsonDict(self):
        json_dict = Skin_base.generateBaseDict(self)
        json_dict['id'] = self.id
        json_dict['path'] = self.path
        json_dict['refCounter'] = self.refCounter
        _dict = self.__dict__
        json_dict["IsAnimatedAvatar"]=_dict.get("IsAnimatedAvatar")
        json_dict["PersistentId"]=_dict.get("PersistentId")
        json_dict["WasBought"]=_dict.get("WasBought")
        return {"Skin": json_dict}

if not hasattr(Skin_base, "generateBaseDict"):
    Skin_base.generateBaseDict = generateEmptyDict
