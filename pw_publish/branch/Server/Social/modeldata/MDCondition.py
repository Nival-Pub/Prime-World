# -*- coding: utf-8 -*-
# Automatically generated file. do not modify it!!!

import sys, os
from base.helpers import addRelPath
from modeldata.baseclasses import *
from modeldata.changes import *
from modeldata.collects import *
from modeldata.ref import *

addRelPath("../modeldata", "../modeldata/SharedTypes")


from MDCondition_base import *

class MDCondition(RefCounted, Identified, ChangeHandler, BaseObject, MDCondition_base):
    _changeFields = {
        "LastEventId":1,
        "PersistentIds":1,
        "TotalValue":1,
        "TypeToCollect":1,
    }

    def __init__(self, modeldata, id=None, path=None):
        ChangeHandler.__init__(self, path, modeldata)
        RefCounted.__init__(self)
        Identified.__init__(self, id)
        _dict = self.__dict__
        _dict["_modeldata"] = modeldata
        _dict["LastEventId"] = 0
        _dict["PersistentIds"] = SimpleList(modeldata)
        _dict["TotalValue"] = 0
        _dict["TypeToCollect"] = 0
        _dict["isDeleting"] = False

    # ���������� �� ���� ������� ����� model.addNewName() -- ��������, � keeper.init() ����� ��������
    def init(self):
        pass
        if not getattr(self,"PersistentIds",None ):
            self.__dict__["PersistentIds"] = SimpleList(self._modeldata)
        self.PersistentIds.init(self.path + u"/PersistentIds", self._modeldata)

    # ���������� ����� model.addNewName()
    def init_add(self):
        pass
        if not getattr(self,"PersistentIds",None ):
            self.__dict__["PersistentIds"] = SimpleList(self._modeldata)
        self.PersistentIds.init(self.path + u"/PersistentIds", self._modeldata)

    def setPath(self, path):
        ChangeHandler.init(self, path, self._modeldata)
        self.PersistentIds.init(self.path + u"/PersistentIds", self._modeldata)

    def deleteByID(self, id):
        if not self.isDeleting:
            self.isDeleting = True
            self.PersistentIds.deleteByID(id)
            self.isDeleting = False

    def __setattr__(self, name, val):
        if name not in self.__dict__ or  val != self.__dict__[name]:
            ChangeHandler.__setattr__(self, name, val)


    def generateJsonDict(self):
        json_dict = MDCondition_base.generateBaseDict(self)
        json_dict['id'] = self.id
        json_dict['path'] = self.path
        json_dict['refCounter'] = self.refCounter
        _dict = self.__dict__
        json_dict["LastEventId"]=_dict.get("LastEventId")
        json_dict["PersistentIds"]=_dict.get("PersistentIds").getJsonDict()
        json_dict["TotalValue"]=_dict.get("TotalValue")
        json_dict["TypeToCollect"]=_dict.get("TypeToCollect")
        return {"MDCondition": json_dict}

if not hasattr(MDCondition_base, "generateBaseDict"):
    MDCondition_base.generateBaseDict = generateEmptyDict
