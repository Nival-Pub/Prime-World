#pragma once

#include "System/Thread.h"
#include "System/HPTimer.h"

#include "Server/DebugVarUpdate/RDebugVarReporter.auto.h" 

namespace NDebug
{
typedef NHPTimer::FTime TIMESTAMP;

enum TSpecialUpdatePeriod {
  ONCE = 0,
  COMMAND = -1
};

struct SClientVar
{
  TIMESTAMP lastRequested;
  TIMESTAMP lastReceived;
  TIMESTAMP updPeriod; // 0 == once (dont auto-update); 
  wstring   wsValue;
  bool      isChecked; // ������������ ���������� GetNextUpdatedVar()

  inline SClientVar() {}

  inline SClientVar( const TIMESTAMP period_ ): updPeriod( period_ ), isChecked(true)
  { lastRequested = lastReceived = 0; }
};

const TIMESTAMP DEFAULT_UPDATE_PERIOD = 10.0;
const TIMESTAMP REMOTE_CMD_PERIOD = -1.0; // ������ < 0 ����� ������� ��������� "immediate" �������, ��� ���������� RunCmd
const TIMESTAMP MAX_REMOTE_WAIT_TIME = 1.0;

class DebugVarRequesterMap; // forward
typedef long TUserId;

class DebugVarRequester: public BaseObjectMT
{
  NI_DECLARE_REFCOUNT_CLASS_1(DebugVarRequester, BaseObjectMT);
public:
  typedef nstl::map<wstring, SClientVar> TClientVars;

protected:
  TClientVars vars;
  TUserId userId; // ���������� ��� ForEach

  // �� ����, ����� �� ��� ����� step-��������� thread-safety.. �� ��������� requester ���� ����� �����, ����� ����� Map �����
  //threading::Mutex mutex;

  StrongMT<RDebugVarReporter> remote;
  TIMESTAMP timeRemoteRequested;
  bool waitingForRemote;  // "��� ��� ����" (�� ������ Step ����������� � ���)

  TIMESTAMP lastVarsReceived; // ����� ��������� ��� �������� ���-������ �������� � CallbackValueReceive
  TIMESTAMP lastVarsChecked;  // ����� � ��� ��������� ��� �������� �������� ����������

  // ��������� mutex �������, ����� ��������� ������ ����� DebugVarRequesterMap 
  // (������ � ��������� � ReqVar ��������� ��� ������ ��������� ������ ������������� ����������)
  friend class DebugVarRequesterMap; 
  DebugVarRequester();
  ~DebugVarRequester();

public: 

  void AttachTo( rpc::Node* node );
  void AttachQuery( rpc::Node* node, const char *path );
  void Detach();

  // ������������ ���� ���������� Reporter'� ����� ��������: �� ��� ����������, � ������� ����� ������ �������
  void UpdateStep();
    void CallbackValueReceive( const wchar_t* reply ); // CALLBACK for remote DebugVar requests
    void CallbackCmdReplyReceive( const wchar_t* reply ); // CALLBACK for remote RunCommand requests
    void CallbackRemotePtrReceive( RDebugVarReporter* ); // ����� �� Query<RDebugVarReporter>
  bool IsReady(); // ���� �������� remote (��� ���� ��� ���� ���)

  inline bool ReqVarOnce( const wstring &name ) { return ReqVar( name, 0 ); } 
  bool ReqVar( const wstring &name, TIMESTAMP secPeriod = DEFAULT_UPDATE_PERIOD );
  bool RemoveVar( const wstring &name );
  
  // ���������� ������ ������� �������� (���������� �� ���������� reporter'�), ���� ��� �� �������� -> false
  bool GetValue( const wstring &name, wstring& outValue ) const; 

  // �.�. ������� ������, �������� �������� ���� �� THREAD-SAFE, ����������; ������� ������� ������ Callback-�� ������ ����������
  inline bool IsChecked() { return (lastVarsChecked >= lastVarsReceived); } // true = �� ���� �������� �� �������� ������
  inline void SetChecked() { lastVarsChecked = lastVarsReceived; } // ���������� ���������, �� ���������� Receive ����� �� ������� 

  bool GetNextUpdatedVar( wstring &outName, wstring& outValue ); // ������ ������������ ���������� ����� ���������� ��� checked
};


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct SScenarioVar
{
  TIMESTAMP updPeriod; // 0 == once (dont auto-update); 
  wstring   wsName;
  inline SScenarioVar(): updPeriod( 0 ) {}
  inline SScenarioVar( const wstring &name_, const TIMESTAMP period_ ): wsName( name_ ), updPeriod( period_ ) {}
  inline SScenarioVar( const wchar_t *name_, const TIMESTAMP period_ ): wsName( name_ ), updPeriod( period_ ) {}

  bool Parse( const nstl::string &pair, bool cmd_may_omit_period=false );
};

/// DebugVarRequesterMap.
///
/// ��� ��������� ������������� ����� ��������� �� ������������ DebugVarRequester, 
/// � ����� �� ����� (������������� �� ������ long connectionId),
/// �����, ��������, �� ������ ���������� (�������) ������ ���� "�������� ����������".
/// ����� ����������, ����� ��� "���������" ����������� � ������ "��������� ������", 
/// �.�. ������� ������������� ���������� � �� �����. ���������������.
class DebugVarRequesterMap: public NonCopyable
{
public:
  typedef nstl::vector< SScenarioVar > TScenarioVars;
protected:
  TScenarioVars defaultScenario;
  
  typedef nstl::map<TUserId, StrongMT<DebugVarRequester> > TRequesters;
  TRequesters requesters;

  // �� ����, ����� �� ��� ����� step-��������� thread-safety.. ����� �����
  threading::Mutex mutex;

public:  
  DebugVarRequesterMap() {}
  ~DebugVarRequesterMap();

  // ���������� ��������� ��� ���� ����� ����� ���� ���������� �������������� ������� ���������� 
  // (�������� ���� �� ������������ ������-��������)
  DebugVarRequester* AddRequester( TUserId userId, rpc::Node* node, bool bApplyDefaultScenario = true );
  DebugVarRequester* QueryRequester( TUserId userId, rpc::Node* node, const char *path, bool bApplyDefaultScenario = true );
  bool RemoveRequester( TUserId userId );

  // ��������� "�����������" ����������/�������, ��� ����������� ����������, ��� ���������� � ������ ��������
  bool AddImmediate( TUserId userId, const wstring &name, TIMESTAMP secPeriod = REMOTE_CMD_PERIOD );

  // ��������� ���������� "��� ������������ ���������� ����", �.�. �� ���� ������������ requester'�� (�� �� � default ���������)
  void AddVarBroadcast( const wstring &name, TIMESTAMP secPeriod );

  // ����� ����� ���� �������� �������� � ���� �������: req.AddScenario().AddScenario()...
  DebugVarRequesterMap& AddScenario( const wstring &varName, const TIMESTAMP secUpdatePeriod = 0 );
  void AddScenarios( const TScenarioVars& vec ); // ��������� ����� ������ (����. �� �������)
  bool RemoveScenario( const wstring &varName ); // ������� ���������� �� �������� (true ���� � ������ ���� �����)
  bool RemoveScenarioByPrefix( const wstring &varName ); // ������� �� �������� ��� ���������� � ������ ��������� (true ���� ���� ���� ���� �����)
  void ClearScenarios() { defaultScenario.clear(); }
  void ListScenarios( wstring& out ); // ������� ���� � ������� "name:period \n name:period.."
 
  // ���������� ������ ������� �������� (���������� �� ���������� reporter'�), ���� ��� �� �������� -> false
  bool GetValue( const TUserId userId, const wstring &name, wstring& outValue ) const; 

  // ��������� �� ��������� ������������, ����� ����-�� ���� ������ ���������� � ������� �����
  void UpdateStep();

  // ��������� "��������" (������ ���������� �������), � ������� ���-�� ���������� (��� Receive) �� �������� ������
  DebugVarRequester* GetNextUpdated();

  typedef void (*TCallbackType)(const TUserId&, wstring&, wstring&, void*); // foreach-callback, ������� ��� "������" vars
  int ForEachUpdatedVar( TCallbackType funcCallback, void* param); 
};

} // namespace NDebug
