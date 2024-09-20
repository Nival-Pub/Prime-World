# -*- coding: utf-8 -*-
#automatically generated file. do not modify it!!!

#!/usr/bin/env python
import sys
from modeldata.baseclasses import *
from modeldata.changes import *
from modeldata.collects import *
from modeldata.ref import *


from Dialog_base import *

class Dialog(RefCounted, Identified, ChangeHandler, BaseObject, Dialog_base):
  _changeFields = {
    "dbid":1,
    "state":1,
  } 

  def __init__( self, modeldata, id=None, path=None ):
    ChangeHandler.__init__( self, path, modeldata )
    RefCounted.__init__( self )
    Identified.__init__( self, id )
    _dict = self.__dict__
    _dict["_modeldata"] = modeldata
    _dict["dbid"] = 0
    _dict["state"] = 0
    _dict["isDeleting"] = False

  # вызывается во всех случаях кроме model.addNewName() -- например, в keeper.init() после загрузки
  def init( self ):
    pass
  
  # вызывается после model.addNewName()
  def init_add( self ):
    pass
    
  def setPath( self, path ):
    ChangeHandler.init( self, path, self._modeldata )
  
  def deleteByID( self, id ):
    if not self.isDeleting:
      self.isDeleting = True
      self.isDeleting = False

  def __setattr__( self, name, val ):
    ChangeHandler.__setattr__( self, name, val )
    
  def generateJsonDict( self ):
    json_dict = Dialog_base.generateBaseDict(self)
    json_dict['id'] = self.id
    json_dict['path'] = self.path
    json_dict['refCounter'] = self.refCounter
    _dict = self.__dict__
    json_dict["dbid"]=_dict.get("dbid")
    json_dict["state"]=_dict.get("state")
    return { "Dialog": json_dict }

if not hasattr( Dialog_base, "generateBaseDict" ):
  Dialog_base.generateBaseDict = generateEmptyDict
