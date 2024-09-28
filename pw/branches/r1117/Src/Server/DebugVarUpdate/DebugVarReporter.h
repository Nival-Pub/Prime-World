#pragma once

#include "RPC/RPC.h"
#include "RPC/LocalEntityFactory.h"
#include "RPC/GateKeeper.h"


namespace NDebug
{

static const char *VarPathSuffix = ".var";
 
REMOTE class DebugVarReporter : public BaseObjectMT
{
  NI_DECLARE_REFCOUNT_CLASS_1( DebugVarReporter, BaseObjectMT )
public: 

  RPC_ID();

  wchar_t buf[1024]; // � �� ��� �� ��� ������ ������������
  
  DebugVarReporter();
  DebugVarReporter( rpc::GateKeeper *gateKeeper, const char* serviceName );

  ~DebugVarReporter();

  REMOTE const wchar_t* GetDebugVar(const wstring &sVarName);
  REMOTE const wchar_t* RunRemoteCommand(const wstring &cmd);

  // ���� ����� ���������������� ������� ������� ��������� (����. �� ��� �������� ��� ����� ������ ������),
  // ������������ ������� ������ ����� ���� RegisterObject(), � ������ ���� ��� ������� (reporter ������� � ���� �������)
  void RegisterObject( rpc::GateKeeper *gateKeeper, const char* serviceName );

  // ���� �� ����� ��������� �������� ����������, � ����� ��������� ��� �� ������ � remote �������, 
  //  ����� ���������������� ���� ������� �������� ����� (���������� ����� ����� �������� gatekeeper � factory)
  static void AttachTo( rpc::LocalEntityFactory* factory );
};

} // namespace DebugVar
