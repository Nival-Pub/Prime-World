# -*- coding: utf-8 -*-
# Automatically generated file. do not modify it!!!

import sys, os
from base.helpers import addRelPath
from modeldata.baseclasses import *
from modeldata.changes import *
from modeldata.collects import *
from modeldata.ref import *

addRelPath("../modeldata", "../modeldata/SharedTypes")


from BuySpecialHeroEventInfo_base import *

class BuySpecialHeroEventInfo(RefCounted, Identified, ChangeHandler, BaseObject, BuySpecialHeroEventInfo_base):
    _changeFields = {
        "HeroIdA":1,
        "HeroIdB":1,
        "Price":1,
    }

    def __init__(self, modeldata, id=None, path=None):
        ChangeHandler.__init__(self, path, modeldata)
        RefCounted.__init__(self)
        Identified.__init__(self, id)
        _dict = self.__dict__
        _dict["_modeldata"] = modeldata
        _dict["HeroIdA"] = "alchemist"
        _dict["HeroIdB"] = "demonolog"
        _dict["Price"] = 5
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
        ChangeHandler.__setattr__(self, name, val)


    def generateJsonDict(self):
        json_dict = BuySpecialHeroEventInfo_base.generateBaseDict(self)
        json_dict['id'] = self.id
        json_dict['path'] = self.path
        json_dict['refCounter'] = self.refCounter
        _dict = self.__dict__
        json_dict["HeroIdA"]=_dict.get("HeroIdA")
        json_dict["HeroIdB"]=_dict.get("HeroIdB")
        json_dict["Price"]=_dict.get("Price")
        return {"BuySpecialHeroEventInfo": json_dict}

if not hasattr(BuySpecialHeroEventInfo_base, "generateBaseDict"):
    BuySpecialHeroEventInfo_base.generateBaseDict = generateEmptyDict
