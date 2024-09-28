#include "stdafx.h"
#include "LoginServerAsync.h"
#include "Coordinator/SimpleLoginProcessor.h"
#include "Server/ServerAppBase/ServerCfg.h"
#include "Server/LobbyPvx/CommonTypes.h"
#include "Coordinator/CoordinatorServerNaming.h"
#include "UserManagerSvc/UserManagerNaming.h"
#include "UserManagerSvc/LUserManagerIface.auto.h"
#include "Network/RSessionKeyRegisterIface.auto.h"
#include "Network/ClusterConfiguration.h"


namespace Login
{

static unsigned int s_nozzimaFirstUserId = 1000;
static unsigned int s_nozzimaUserIdMask = 0x40000000;

unsigned int g_MaxAsyncOpsPerStep = 100; // ����. ���-�� ����������� �������� (rpc) �� 1 ���� Login Server 
unsigned int g_LoginContextDumpFreq = 100; // ���� ��� �� ������� ������� ������� ������ ������� �������� � �����-����������
unsigned int g_CtorCountDumpFreq = 1000; // ��� � ������� ����� ������� ���������� �������� �������������/������������ �����-����������

REGISTER_VAR( "nozzima_first_user_id", s_nozzimaFirstUserId, STORAGE_GLOBAL);
REGISTER_VAR( "nozzima_user_id_mask", s_nozzimaUserIdMask, STORAGE_GLOBAL);
REGISTER_VAR( "login_max_ops_per_step", g_MaxAsyncOpsPerStep, STORAGE_NONE );
REGISTER_VAR( "login_timings_dump_freq", g_LoginContextDumpFreq, STORAGE_NONE );
REGISTER_VAR( "login_ctors_dump_freq", g_CtorCountDumpFreq, STORAGE_NONE );



REGISTER_CMD(login_add_session_key, &LoginServerAsync::onCmdAddSessionKey); //  ���������� sessionKey ��� ������

TSessionContextMap LoginServerAsync::predefinedSessionMap;

bool LoginServerAsync::onCmdAddSessionKey(const char *name, vector<wstring> const & params)
{
  nstl::string sessionKey;
  Transport::TServiceId svcpath;
  nstl::string login;
  Cluster::TUserId auid = 0;

  if (params.size() < 4)
    return false;

  for(int i = 0; i < params.size(); ++i)
  {
    if (0 == i)
    {
      sessionKey = NStr::ToMBCS(params[i]);
    }
    else
    if (1 == i)
    {
      svcpath = NStr::ToMBCS(params[i]).c_str();
    }
    else
    if (2 == i)
    {
      login = NStr::ToMBCS(params[i]);
    }
    else
    if (3 == i)
    {
      auid = _wtoi(params[i].c_str());
    }
  }

  predefinedSessionMap[sessionKey] = new SSessionContext(svcpath.c_str(), login.c_str(), auid, Cluster::INVALID_GAME_ID, true);

  return true;
}
 



LoginServerAsync::LoginServerAsync( const Transport::ServiceParams & _svcParams, const Transport::CustomServiceParams & _customParams ) :
LoginServerBase( _svcParams, _customParams, Network::GetLoginServerAddress() ),
asyncProcessor( 0 ),
debug_stepCount(0),
sessionLogin( SESSION_LOGIN_NONE )
{
  sessionLogin = ParseLoginMode( SvcOptions() );
  MessageTrace( "Creating login service. login_mode=%d", (int)sessionLogin ); 

  asyncProcessor = new SimpleLoginProcessor( s_nozzimaFirstUserId, s_nozzimaUserIdMask );;

  RegisterBackendObject<ISessionKeyRegister>( this, serviceIface.c_str() );

  userMngrIface_ = new rpc::IfaceRequester<UserManager::RIUserManager>;
  userMngrIface_->init( BackendGk(), UserManager::ServiceClass, UserManager::ServiceRpcIface, &GetSystemLog(), LOGIN_CHNL );

  RegisterBackendAttach<UserManager::IPrepareUserEnvCallback, UserManager::LIPrepareUserEnvCallback>();
  asyncProcessor->setUserManagerIface(userMngrIface_);

  // DEBUG //////////////////////////////////////
  if( sessionLogin != SESSION_LOGIN_NONE )
  {
    for(TSessionContextMap::iterator it = predefinedSessionMap.begin(); it != predefinedSessionMap.end(); ++it)
    {
      StrongMT<SSessionContext> const & ctx = it->second;
      AddSessionKey(it->first, ctx->sessionPath, ctx->zz_login, ctx->zz_uid, Cluster::INVALID_GAME_ID, 0);
    }
  }
  // DEBUG //////////////////////////////////////
}



ESessionLoginMode LoginServerAsync::ParseLoginMode( const Transport::TServiceOptions & _options )
{
  if ( _options.find( "session_login_only" ) != _options.end() )
    return SESSION_LOGIN_ONLY;  // ��������� ������ login ����� session key (������� ���� ����� login/������ ����������)
  else if ( _options.find( "session_login" ) != _options.end() )
    return SESSION_LOGIN_CHECK; // ��������� login ����� session key � ����� login/������
  else
    return SESSION_LOGIN_NONE;
}



LoginServerAsync::~LoginServerAsync()
{
  SAFE_DELETE( asyncProcessor );

  contexts.clear();
}



void LoginServerAsync::AddSessionKey( nstl::string const & _sessionKey, Transport::TServiceId const & _sessionPath, 
                                  nstl::string const & _login, Cluster::TUserId _userid, Cluster::TGameId _gameid, IAddSessionKeyCallback* _pcb )
{
  LOG_M(LOGIN_CHNL).Trace("%s (sessionKey=%s sessionPath=%s login=%s userid=%d gameid=%d)", 
    __FUNCTION__, _sessionKey.c_str(), _sessionPath.c_str(), _login.c_str(), _userid, _gameid);

  
  int rc = -1;

  if (_sessionKey.empty())
  {
    LOG_E(LOGIN_CHNL).Trace("%s. Empty session key(sessionKey=%s sessionPath=%s login=%s uid=%d)", _sessionKey.c_str(), _sessionPath.c_str(), _login.c_str(), _userid);
    if (_pcb)
      _pcb->OnAddSessionKey(rc, "", _userid);
    return;
  }

  if (Cluster::INVALID_USER_ID == _userid)
  {
    LOG_E(LOGIN_CHNL).Trace("%s. Invalid user id(sessionKey=%s sessionPath=%s login=%s uid=%d)", 
      _sessionKey.c_str(), _sessionPath.c_str(), _login.c_str(), _userid);
    if (_pcb)
      _pcb->OnAddSessionKey(rc, "", _userid);
    return;
  }

  {
    threading::MutexLock lock( mutexSessionMap );
    StrongMT<SSessionContext> context = new SSessionContext( _sessionPath.c_str(), _login.c_str(), _userid, _gameid, true );
    TSessionContextMap::iterator it = sessionMap.find(_sessionKey);
    if (it != sessionMap.end())
    {
      LOG_E(LOGIN_CHNL).Trace("%s. Session key already registered (sessionKey=%s sessionPath=%s login=%s uid=%d)", 
        _sessionKey.c_str(), _sessionPath.c_str(), _login.c_str(), _userid);
    }
    else
    {
      rc = 0;
      sessionMap[ _sessionKey ] = context;
    }

    if (_pcb)
      _pcb->OnAddSessionKey(rc, Network::GetLoginServerAddress(), _userid);
  }
}



void LoginServerAsync::Poll( timer::Time _now )
{
  LoginServerBase::StepLogin(); // step connection handler: �������� ����� connections, �������� ������

  userMngrIface_->step();

  //Timestamp t1 = NHPTimer::GetScalarTime();

  if ( asyncProcessor && asyncProcessor->MainStep() ) // true == ����� ����������� ��������
  {
    asyncProcessor->AsyncStep(); // ��������� ������� web-������ (����������� ������ ����������� ��������, ������������ �� context-�� � �.�.)

    StrongMT<SLoginContext> context;
    TLoginContexts::iterator it;
    {
      threading::MutexLock lock( mutexContexts );

      it = contexts.begin();
      context = (it != contexts.end()) ? (*it) : 0;
    }

    while ( context )
    {
      bool client_ok = false;
      int userIdBefore = -1;
      int userIdAfter = -1;

      try
      { // ������� �������� � ��������� ���������� ���������� (������� ���������� - �������)
        userIdBefore = context->response.userId;
        client_ok = asyncProcessor->ClientStep(context); // false == ������� ����� �������
        userIdAfter = context->response.userId;
      } 
      catch(...)
      {
        LOG_A( LOGIN_CHNL ) << "context processing failed, finishing";
      }

      if( client_ok && ( userIdAfter != userIdBefore ) && ( userIdAfter > 0 ) )
      {// ��� ��������� userId; ���� �������� � map
        threading::MutexLock lock( mutexContextMap );
        contextMap[userIdAfter] = context;
      }

      if ( client_ok )
      {
        threading::MutexLock lock( mutexContexts );
        ++it;
        context = (it != contexts.end()) ? (*it) : 0;
      }
      else
      {
        int userId = 0;

        try
        { // ������� �������� � ��������� ���������� ���������� (������� ���������� - �������)
          userId = context->GetUserId();
          SendReply( context );
          context->SetStage( SLoginContext::_TIME_REPLY_SENT );
          if ( g_LoginContextDumpFreq )
            if ( ( context->response.userId % g_LoginContextDumpFreq ) == 0 )
              context->DumpStageTimes(); // ����������� �� ������� N-���� ������� � ���
        }
        catch(...)
        {
          LOG_A( LOGIN_CHNL ) << "context reply/dump failed, erasing";
        }

        try
        {// ���� � ��� ��� �������� userId, ������ ���� ��������� � �� mapContext
          if(userId > 0)
            contextMap.erase( userId );
        } 
        catch(...)
        {
          LOG_A( LOGIN_CHNL ) << "context map erase failed";
        }

        try
        {
          threading::MutexLock lock( mutexContexts );
          it = contexts.erase( it );
          context = (it != contexts.end()) ? (*it) : 0;
        }
        catch(...) 
        {// ����� ����� ��������� StrongMT<SLoginContext> context
          LOG_A( LOGIN_CHNL ) << "context delete failed, skip";
        }
      }

      // �� ��������� ����� ��� N ������. �������� � �����-����������� �� 1 ���� (����� �� ��������� ������� ������ ��������)
      if ( asyncProcessor->GetAsyncOpCount() >= g_MaxAsyncOpsPerStep )
      {
        LOG_D( LOGIN_CHNL ) << "too many async ops per step, breaking";
        break;
      }
    }
  }

  if ( g_CtorCountDumpFreq )
    if ( ( ++debug_stepCount % g_CtorCountDumpFreq ) == 0 ) // ��� � ����� ����� (~��� � �������)
      SLoginContext::DumpCtorCounters(); 
}



bool LoginServerAsync::ProcessNewContext( SLoginContext * context )
{
  context->SetStage( SLoginContext::STAGE_NEW ); // debug timing
  context->resultData.nUserID = 0; 

  bool hasSessionKey = (!context->request.sessionKey.empty());

  if (LoginType::ORDINARY == context->request.loginType)
  {
    // ��-������, ��������, ���� �� � ������� sessionKey (���������� �������� ������� �� sessionLogin-������)
    if( sessionLogin != SESSION_LOGIN_NONE)
    {
      bool mustHaveSessionKey = (sessionLogin == SESSION_LOGIN_ONLY);
      bool sessionLoginResult = false;
      if( hasSessionKey )
      {
        threading::MutexLock lock( mutexSessionMap );
        TSessionContextMap::iterator it = sessionMap.find( context->request.sessionKey );
        if( it != sessionMap.end() )
        {// ��, � ��� ���� ����� ���������� ����, �������
          if( context->request.login == it->second->zz_login )
          {
            sessionLoginResult = true;
            context->response.sessionPath = it->second->sessionPath;
            //context->resultData.sessionPath = it->second->sessionPath;

            context->request.password.clear(); // ������ ��� ZZima-������ ��������� ������
            context->resultData.nUserID = it->second->zz_uid; // ZZima login �� ������ nUserID ��� ��������� resultData.nUserID
            context->gameid = it->second->gameid_;

            LOG_M(LOGIN_CHNL) << "found sessionKey:" << context->request.sessionKey 
              << ", login=" << context->request.login << ", zz_uid=" << context->resultData.nUserID << ", loginMode=" << sessionLogin;

            // ����������� "��� �������������� ������" sessionKey?..
            if( it->second->useOnce )
            {
              LOG_M(LOGIN_CHNL) << "removing a useOnce sessionKey:" << context->request.sessionKey;
              sessionMap.erase( it );
            }
          }
          else
          {
            LOG_W(LOGIN_CHNL) << "SessionLogin FAIL for sessionKey:" << context->request.sessionKey 
              << ", request login=" << context->request.login.c_str() << ", stored zz_login=" << it->second->zz_login.c_str();
          }
        }
        else
        {
          LOG_W(LOGIN_CHNL) << "NO such sessionKey, reconnect check will be started:" << context->request.sessionKey 
            << ", login=" << context->request.login << ", loginMode=" << sessionLogin;
        }
      }
      else
      {
        Transport::TServiceId fullSessionPath;
        Transport::MakeFullServiceId(HostServer::Cfg::GetSvcPath().c_str(), lobby::serviceIds::Service, -1, fullSessionPath);
        context->response.sessionPath = fullSessionPath;
        LOG_W(LOGIN_CHNL) << "EMPTY sessionKey for login=" << context->request.login << ", loginMode=" << sessionLogin
          << ", sessionPath='" << fullSessionPath.c_str() << "'";
      }

      if( (!sessionLoginResult) && (mustHaveSessionKey || hasSessionKey) && SLoginContext::STAGE_RECONNECT_CHECK_START != context->stage ) 
      {// ���� ������ 1) ������ ����� �������� sessionKey ��� 2) ���� ������ sessionKey, � ��� ���� �� ������ �������� => �� �������
        LOG_W(LOGIN_CHNL) << "sessionLogin FAILED, login=" << context->request.login << ", loginMode=" << sessionLogin;
        context->response.loginResult = ELoginResult::Refused;
        context->SetStage( SLoginContext::_TIME_FAIL ); // debug timing
        SendReply( context );
        return true;
      }
    }
  }
  else
  {
    if (LoginType::FAST_RECONNECT == context->request.loginType ||
      LoginType::PARTIAL_RECONNECT == context->request.loginType)
    {
      //  here can be fast reconnect or partial reconnect
      if( sessionLogin != SESSION_LOGIN_NONE)
      {
        if (hasSessionKey)
        {
          LOG_W(LOGIN_CHNL) << "NO such sessionKey, reconnect check will be started:" << context->request.sessionKey 
            << ", login=" << context->request.login << ", loginMode=" << sessionLogin << ", clientLoginType=" << LoginType::ToString(context->request.loginType);

          context->SetStage(SLoginContext::STAGE_RECONNECT_CHECK_START);
        }
        else
        {
          LOG_E(LOGIN_CHNL).Trace("Reconnect is acquired, but reconnect supported with session key only(login=%s loginMode=%d clientLoginType=%s)", 
            context->request.login.c_str(), (int)sessionLogin, LoginType::ToString(context->request.loginType));

          context->response.loginResult = ELoginResult::Refused;
          context->SetStage( SLoginContext::_TIME_FAIL ); // debug timing
          SendReply( context );
          return true;
        }
      }
    }
    else
    {
      LOG_E(LOGIN_CHNL).Trace("Invalid login type (login=%s loginMode=%d clientLoginType=%s)", 
        context->request.login.c_str(), (int)sessionLogin, LoginType::ToString(context->request.loginType));
    }
  }

  {// ����� ���� � ��������� (�����������) �����������: ������������ ����� �����-������, � ������ ��������� �� �������� Step()
    threading::MutexLock lock( mutexContexts );
    contexts.push_back( context );
  }

  return false; // � ����� ������: �� ���� ����� ������� connection (��� �������, ������ ����� SendReply)
}

} // namespace Login
