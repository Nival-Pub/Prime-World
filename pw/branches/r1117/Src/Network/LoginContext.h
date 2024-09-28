#pragma once
#include "LoginTypes.h"
#include "RPC/RPC.h"
//#include "RPC/P2PNode.h" // ValQueryCB<>
#include <RPC/IfaceRequester.h>
#include "LoginData.h"
#include "System/HPTimer.h"
#include "UserManager/UserManagerSvc/RUserManagerIface.auto.h"

// ����� ���-������� (��� ���� �����-�������)
#define LOGIN_CHNL "Login" 

namespace Relay
{
  class RIBalancer;
}

namespace Login
{

typedef NHPTimer::FTime Timestamp;


struct SLoginContext : public UserManager::IPrepareUserEnvCallback, public BaseObjectMT
{
  NI_DECLARE_REFCOUNT_CLASS_2( SLoginContext, UserManager::IPrepareUserEnvCallback, BaseObjectMT );

  enum TStage { // STAGE_XXX: ���������, _TIME_XXX: ������ ������ ������� ��� stageTimes
    #define EnUm( x ) x // ��� .h -- ��������, ��� .cpp -- �������� �������������
      EnUm( STAGE_RECONNECT_CHECK_START ),
      EnUm( STAGE_RECONNECT_CHECK_IN_PROGRESS ),
      EnUm( STAGE_RECONNECT_CHECK_FINISH ),
      EnUm( STAGE_NEW ),
      EnUm( _TIME_LOGIN_CHECK_START ),
      EnUm( STAGE_ASYNC_LOGIN_WAIT ),
      EnUm( _TIME_ASYNC_LOGIN_DONE ),
      EnUm( _TIME_REPARE_USER_ENVIRONMENT ),
      EnUm( STAGE_PREPARE_USER_ENVIRONMENT_STARTED ),
      EnUm( STAGE_PREPARE_USER_ENVIRONMENT_RETURN ),
      EnUm( STAGE_PREPARE_USER_ENVIRONMENT_IN_PROGRESS ),
      EnUm( STAGE_PREPARE_USER_ENVIRONMENT_COMPLETED ),
      EnUm( _TIME_FAIL ), // ���������� (������ ��� �������)
      EnUm( _TIME_SUCCESS ), // ��������� � �������; ����� ������ ������� �������
      EnUm( _TIME_REPLY_SENT ),
      //--
      TOTAL_STAGE_COUNT
    #undef EnUm
  };
  static const char* StageNames[];

  TStage                stage;
  volatile bool         isLoginChecked; // ��� ZZima ����� �������� ����������, ����� ��������� ������� ������
  Timestamp             timeLastRequest; // ��� ���������

  StrongMT<Network::IConnection> connection;
  LoginRequestMessage   request;
  LoginResultMessage    response;
  LoginResultData       resultData;

  Transport::TServiceId relay;
  Network::NetAddress   relayAddr;
  Transport::TServiceId secondaryRelay;
  Network::NetAddress   secondaryRelayAddr;
  string reconnectSessionKey; // reconnect session key
  UserManager::Result::Enum rcUserEnvPrep;
  Cluster::TGameId gameid;

  Timestamp             stageTimes[ TOTAL_STAGE_COUNT ];

  SLoginContext(Network::IConnection* conn_=0); // ����� ������ ����������� ����� strong/weak, ������� �� inline
  ~SLoginContext(); // ����� ������ ����������� ����� strong/weak, ������� �� inline

  void SetStage(const TStage stage_);
  bool IsTimeout(const Timestamp now_);

  void DumpStageTimes(); 
  static void DumpCtorCounters(); // DEBUG

  int GetUserId() { return response.userId; }
  string const & sessionKey() const { return request.sessionKey; }

  //  UserManager::FindUserShadow return callback
  void onFindUserSession(UserManager::UserSessionInfo _usershadow);

  //  UserManager::PrepareUserEnv return callback
  void OnPrepareUserEnvReturn(UserManager::Result::Enum _result, Cluster::TUserId _userid, rpc::CallStatus _status);
  //  UserManager::IPrepareUserEnvCallback
  void OnPrepareUserEnv(int _result, Cluster::TUserId _userid, UserManager::RelayInfo const & _relayInfo, UserManager::PartialReconnectInfo const & _partialReconnectInfo);
};

typedef nstl::list<StrongMT<SLoginContext> > TLoginContexts;
typedef nstl::map<int,StrongMT<SLoginContext> > TLoginContextMap; // [userId] -> strong<SLoginContext>, ��� �������� �����������



enum ESessionLoginMode
{
  SESSION_LOGIN_NONE = 0, // ���������� sessionKey
  SESSION_LOGIN_CHECK, // ��������� sessionKey, ����������� sessionPath
  SESSION_LOGIN_ONLY // ������ ��������� ������������ ��� ��������� sessionKey
};



struct IAsyncLoginProcessor 
{
  virtual void setUserManagerIface( rpc::IfaceRequester<UserManager::RIUserManager> * _userMngrIface ) {};

  // �� pure virtual: ����� �� ���������� ������� ����� ������ ��� ��� ��� ������ (��� ZZima � �.�.)
  virtual bool PerformLoginCheck( string const &login, string const &password, Network::IConnection *connection, Login::LoginResultData * result ) { return true; }

  // async
  virtual bool MainStep() { return false; }
  virtual bool ClientStep( StrongMT<SLoginContext> & context ) { return false; }
  virtual unsigned GetAsyncOpCount() { return 0; } // ���-�� ����������� ��������, ����������� �� ������� ����

  // ��������� ���� � context->isLoginChecked (bool) � context->result (data)
  virtual void AsyncLoginRequest( string const &login, string const &password, const StrongMT<Login::SLoginContext> & result ) {} 

  // ����� ������������ ������� async-�������� (web/XML/soap..): ���������� ����������� ������� � �.�.
  virtual void AsyncStep() {} 
};

} // namespace Login
