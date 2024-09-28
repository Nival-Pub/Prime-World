# -*- coding: utf-8 -*-
# Automatically generated file. do not modify it!!!

import sys, os
from base.helpers import addRelPath
from modeldata.baseclasses import *
from modeldata.changes import *
from modeldata.collects import *
from modeldata.ref import *

addRelPath("../modeldata", "../modeldata/SharedTypes")


from DynamicQuestPullInfo_base import *

class DynamicQuestPullInfo(RefCounted, Identified, ChangeHandler, BaseObject, DynamicQuestPullInfo_base):
    _changeFields = {
        "LastActiveQuestId":1,
        "LastActiveQuestStartTime":1,
        "PullId":1,
    }

    def __init__(self, modeldata, id=None, path=None):
        ChangeHandler.__init__(self, path, modeldata)
        RefCounted.__init__(self)
        Identified.__init__(self, id)
        _dict = self.__dict__
        _dict["_modeldata"] = modeldata
        _dict["LastActiveQuestId"] = 0
        _dict["LastActiveQuestStartTime"] = 0
        _dict["PullId"] = 0
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
        json_dict = DynamicQuestPullInfo_base.generateBaseDict(self)
        json_dict['id'] = self.id
        json_dict['path'] = self.path
        json_dict['refCounter'] = self.refCounter
        _dict = self.__dict__
        json_dict["LastActiveQuestId"]=_dict.get("LastActiveQuestId")
        json_dict["LastActiveQuestStartTime"]=_dict.get("LastActiveQuestStartTime")
        json_dict["PullId"]=_dict.get("PullId")
        return {"DynamicQuestPullInfo": json_dict}

if not hasattr(DynamicQuestPullInfo_base, "generateBaseDict"):
    DynamicQuestPullInfo_base.generateBaseDict = generateEmptyDict
