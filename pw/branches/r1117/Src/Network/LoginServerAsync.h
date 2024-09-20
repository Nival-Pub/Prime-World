#pragma once
#include "LoginServerBase.h"

#include "RPC/RPC.h" 
#include "RPC/LocalEntityFactory.h" 
#include "RPC/GateKeeper.h"
#include "Coordinator/LoginServerNaming.h"
#include "RPC/IfaceRequester.h"
#include "UserManager/UserManagerSvc/RUserManagerIface.auto.h"
#include "SessionKeyRegisterIface.h"

namespace Login
{

struct SSessionContext: public BaseObjectMT
{// matchmaker ������ ���� (sessionKey, sessionPath) ��� ������� ��������, ��� ��������� matchmaking
  NI_DECLARE_REFCOUNT_CLASS_1( SSessionContext, BaseObjectMT );

  SSessionContext( const char * path_, const char* zz_login_, int zz_uid_, Cluster::TGameId _gameid, bool useOnce_ )
    : sessionPath(path_), zz_login(zz_login_), zz_uid(zz_uid_), gameid_(_gameid), timestamp(NHPTimer::GetScalarTime()), useOnce(useOnce_) { }
   
  Transport::TServiceId sessionPath; // ���� ������� ������ �������� �� ����� sessionKey (lobby? hybrid? ���, �� �������� �������� ������ RequestNode)
  nstl::string zz_login; 
  int zz_uid;
  Cluster::TGameId gameid_;
  Timestamp timestamp; // ���, ��� �������� ����� ������ (�����, ����������� ������� ���������)
  bool useOnce;
};



// [sessionKey] -> sessionPath, ��� ������� ��������, ��� ��������� matchmaking
typedef nstl::map<nstl::string,StrongMT<SSessionContext> > TSessionContextMap; 




class LoginServerAsync : public LoginServerBase, public ISessionKeyRegister
{
  NI_DECLARE_REFCOUNT_CLASS_2( LoginServerAsync, LoginServerBase, ISessionKeyRegister );

public:
  RPC_ID();

  // async processor version (server):
  LoginServerAsync( const Transport::ServiceParams & _svcParams, const Transport::CustomServiceParams & _customParams );
  ~LoginServerAsync();

  virtual void Poll( timer::Time _now );

  static bool onCmdAddSessionKey(const char *name, vector<wstring> const & params);

protected:
  //ISessionKeyRegister
  void AddSessionKey( nstl::string const & _sessionKey, Transport::TServiceId const & _sessionPath, nstl::string const & _login, Cluster::TUserId _userid, Cluster::TGameId _gameid, IAddSessionKeyCallback * _pcb );

  virtual bool ProcessNewContext( SLoginContext * context );

private:
  IAsyncLoginProcessor * asyncProcessor;

  threading::Mutex mutexContexts;
  TLoginContexts contexts; // ����� ������ �� ����� (���� ��� ������, ��� �����. �������� ����� ���� ������� map[clientId]); �� ����� ������ ��������� ��������� � Step()

  threading::Mutex mutexContextMap;
  TLoginContextMap contextMap; // ��������� ���� [userId]->context: ���������, ������� ��� ������ AddUser, ��������� ����, ��� �������� �����������

  threading::Mutex mutexSessionMap;
  TSessionContextMap sessionMap; // [sessionKey] -> sessionPath, ��� ������� ��������, ��� ��������� matchmaking
  ESessionLoginMode sessionLogin; // ��������� �� sessionKey, � ��������� ������

  int debug_stepCount;

  StrongMT<rpc::IfaceRequester<UserManager::RIUserManager> > userMngrIface_;

  static TSessionContextMap predefinedSessionMap; //  ��� ������ ����������� �� ������� login_add_session_key
  
  static ESessionLoginMode ParseLoginMode( const Transport::TServiceOptions & _options );
};

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
} // namespace Login
