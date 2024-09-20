#include "stdafx.h"
#include "DebugVarRequester.h"
#include "System/sleep.h"
#include "System/DebugVar.h"

namespace NDebug
{

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DebugVarRequester::DebugVarRequester()
{
  LOG_D(0) << "DebugVarRequester";
  lastVarsReceived = lastVarsChecked = 0;
  waitingForRemote = false;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DebugVarRequester::~DebugVarRequester()
{
  LOG_D(0) << "~DebugVarRequester";

  vars.clear();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DebugVarRequester::AttachTo( rpc::Node* node )
{
  if( node )
  {
    remote = node->Create<NDebug::RDebugVarReporter>(); 
  }
  else
  {
    LOG_M(0) << "DebugVarRequester::AttachTo bad rpc node (0)";
  }
}

void DebugVarRequester::AttachQuery( rpc::Node* node, const char *path )
{
  if( node )
  {
    waitingForRemote = true;
    timeRemoteRequested = NHPTimer::GetScalarTime();

    bool res = node->Query<NDebug::RDebugVarReporter>(path, this, &DebugVarRequester::CallbackRemotePtrReceive); 
    LOG_D(0) << "DebugVarRequester::AttachTo Query ( path=" << path << " res=" << res << ")";
  }
  else
  {
    LOG_M(0) << "DebugVarRequester::AttachTo bad rpc node (0)";
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DebugVarRequester::Detach()
{
  remote = 0;
  waitingForRemote = false;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ������������ ���� ���������� Reporter'� ����� ��������: �� ��� ����������, � ������� ����� ������ �������
void DebugVarRequester::UpdateStep()
{
  TIMESTAMP now = NHPTimer::GetScalarTime();
  
  if( IsValid( remote ) )
  {
    for(TClientVars::iterator it = vars.begin(); it != vars.end(); ++it )
    {
      SClientVar& var = it->second;
      if ( (var.lastRequested == 0) // ����������� 1-� ���
            || (( var.updPeriod > 0 ) && ( var.lastRequested + var.updPeriod <= now )) // ����������� ������������, � ����� ��� ��� ���
         )  
      {
        LOG_D(0) << "req var " << it->first << " /time " << now;
        var.lastRequested = now;

        // request upd from Remote
        if ( var.updPeriod >= 0)
        {
          remote->GetDebugVar( it->first, this, &DebugVarRequester::CallbackValueReceive );
        }
        else
        {// RunCommand
          remote->RunRemoteCommand( it->first, this, &DebugVarRequester::CallbackCmdReplyReceive );
        }
      }
    }
  }
  else if ( waitingForRemote )
  {
    if ( now - timeRemoteRequested  > MAX_REMOTE_WAIT_TIME )
    {
      LOG_M(0) << "DebugVarRequester: NO remote, stopping operation";
      waitingForRemote = false;
    }
    else
      LOG_M(0) << "DebugVarRequester::UpdateStep bad remote (no node?)";
  }

  return;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DebugVarRequester::IsReady()
{
  return IsValid( remote ) || waitingForRemote;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DebugVarRequester::CallbackValueReceive(const wchar_t* rawReply)
{
  wstring reply( rawReply ); //FIXME ������� ���� �������� � ������� ������� ��� raw wchar_t*

  TIMESTAMP now = NHPTimer::GetScalarTime();
  // ����� reply �� ���|��������
  size_t pos = reply.find( L"|" );
  if ( pos >= 0 )
  {
    wstring name  = reply.substr( 0, pos ); 
    wstring value = reply.substr( pos+1 );

    LOG_D(0) << "recv var '" << name << "', value '" << value << "' /time " << now;
  
    {//LOCKED SetValue(name,value) ?
            
      TClientVars::iterator it = vars.find( name);
      if ( it != vars.end() )
      {
        SClientVar& var = it->second;
        var.wsValue = value;
        var.lastReceived = now;
        var.isChecked = false;

        LOG_D(0) << " -> set var '" << name << "' = '" << value << "'   /trip " << (now - var.lastRequested);

        lastVarsReceived = now;

        if( var.updPeriod < 0 ) 
        {// ������� ��������� ������ ����������
          LOG_D(0) << " // remove finished cmd '" << name << "'";
          vars.erase( it ); 
        }
      }
    }
  }
  else
  {
    LOG_D(0) << "bad var reply: '" << reply << "'";
  }
}


// ��������� ���������� ��� RunCmd: ��� "cmd|bool_result|log_string(s)"
void DebugVarRequester::CallbackCmdReplyReceive(const wchar_t* rawReply)
{
  wstring reply( rawReply ); //FIXME ������� ���� �������� � ������� ������� ��� raw wchar_t*

  TIMESTAMP now = NHPTimer::GetScalarTime();
  // ����� reply �� ���|��������|���
  vector<wstring> words;
  NStr::SplitString( reply, &words, L"|" );
  if ( words.size() >= 3 )
  {
    wstring name  = words[0];
    wstring value = words[1];
    wstring execution_log = words[2];

    LOG_D(0) << "recv cmd '" << name << "', result '" << value << "' /time " << now 
      << "\nCOMMAND EXECUTION LOG:\n" 
      << "--------------------------------------------------------------------------------------------------------\n"
      << execution_log
      << "--------------------------------------------------------------------------------------------------------"
      ;
  
    {//LOCKED SetValue(name,value) ?
            
      TClientVars::iterator it = vars.find( name);
      if ( it != vars.end() )
      {
        SClientVar& var = it->second;
        LOG_D(0) << " /trip " << (now - var.lastRequested);

        lastVarsReceived = now;

        // ������� ��������� ������ ����������
        LOG_D(0) << " // remove finished cmd '" << name << "'";
        vars.erase( it ); 
      }
    }
  }
  else
  {
    LOG_D(0) << "bad cmd reply: '" << reply << "'";
  }
}


void DebugVarRequester::CallbackRemotePtrReceive( RDebugVarReporter* pReporter ) // ����� �� Query<RDebugVarReporter>
{
  LOG_W(0) << "DebugVarRequester received queried ptr: " << (void*)pReporter;
  remote = pReporter;
  waitingForRemote = false;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DebugVarRequester::ReqVar( const wstring &name, TIMESTAMP msecPeriod )
{
  bool wasPresent = ( vars.find( name) != vars.end() );
  vars[name] = SClientVar( msecPeriod );

  return wasPresent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DebugVarRequester::RemoveVar( const wstring &name )
{
  TClientVars::iterator it = vars.find( name);
  if ( it != vars.end() )
  {
    vars.erase( it );
    return true;
  }

  return false; // no such
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DebugVarRequester::GetValue( const wstring &name, wstring& value ) const
{
  TClientVars::iterator it = vars.find( name);
  if ( it != vars.end() && it->second.lastReceived )
  {
    value = it->second.wsValue;
    return true;
  }
  
  return false; //fail
}

bool DebugVarRequester::GetNextUpdatedVar( wstring &outName, wstring& outValue )
{// ������ ������������ ���������� ����� ���������� ��� checked
  for(TClientVars::iterator it = vars.begin(); it != vars.end(); ++it )
  {
    SClientVar& var = it->second;
    if( var.lastReceived >= lastVarsChecked && (!var.isChecked) )
    {
      outName = it->first;
      outValue = var.wsValue;
      var.isChecked = true;
      return true;
    }
  }
  return false; // nothing new
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DebugVarRequesterMap::~DebugVarRequesterMap()
{
  threading::MutexLock lock( mutex );

  //for( TRequesters::const_iterator it = requesters.begin(); it != requesters.end(); ++it ) - ������ ��� StrongMT<>
  //  delete it->second;
  requesters.clear();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DebugVarRequesterMap& DebugVarRequesterMap::AddScenario( const wstring &varName, const TIMESTAMP secUpdatePeriod )
{ 
  threading::MutexLock lock( mutex );

  defaultScenario.push_back( SScenarioVar( varName, secUpdatePeriod ) );
  return *this; // ����� ����� ���� �������� �������� � ���� �������: req.AddScenario().AddScenario()...
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DebugVarRequesterMap::RemoveScenario( const wstring &varName )
{// ������� ���������� �� �������� (true ���� � ������ ���� �����)
  threading::MutexLock lock( mutex );

  for( TScenarioVars::iterator it=defaultScenario.begin(); it != defaultScenario.end(); ++it )
    if ( it->wsName == varName )
    {
      defaultScenario.erase( it );
      return true;
    }

  return false; // no such
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DebugVarRequesterMap::RemoveScenarioByPrefix( const wstring &varName )
{// ������� �� �������� ��� ���������� � ������ ��������� (true ���� ���� ���� ���� �����)
  threading::MutexLock lock( mutex );
  bool result = false;

  int prefixLen = varName.length();
  for( TScenarioVars::iterator it=defaultScenario.begin(); it != defaultScenario.end(); )
    if ( it->wsName.substr(0, prefixLen) == varName )
    {
      it = defaultScenario.erase( it );
      result = true;
    }
    else
      ++it;

  return result;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DebugVarRequesterMap::ListScenarios( nstl::wstring& out ) 
{// ������� ���� � ������� "name:period,name:period.."
  threading::MutexLock lock( mutex );

  out.clear();
  for( TScenarioVars::iterator it=defaultScenario.begin(); it != defaultScenario.end(); ++it )
  {
    wchar_t buf[256];
    NStr::SWPrintf(buf, 256, L"\"%ls\":%.1f\n", it->wsName.c_str(), it->updPeriod);
    out += buf;
  }

  if ( out.length() )
    out.erase( out.length()-1 ); // ������� ��������� (������) �������
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DebugVarRequesterMap::AddScenarios( const TScenarioVars& vec )
{
  threading::MutexLock lock( mutex );

  defaultScenario.insert( defaultScenario.end(), vec.begin(), vec.end() ); 
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ��������� "�����������" ����������/�������, ��� ����������� ����������, ��� ���������� � ������ ��������
bool DebugVarRequesterMap::AddImmediate( TUserId userId, const wstring &name, TIMESTAMP secPeriod )
{
  threading::MutexLock lock( mutex );

  StrongMT<DebugVarRequester> req(0); // ���� �� ������ ������������ requester, ������� �����
  TRequesters::iterator itReq = requesters.find( userId );
  if ( itReq == requesters.end() )
    req = new DebugVarRequester();
  else
    req = itReq->second;

  return req->ReqVar( name, secPeriod );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DebugVarRequester* DebugVarRequesterMap::AddRequester( long userID, rpc::Node* node, bool bApplyDefaultScenario )
{
  threading::MutexLock lock( mutex );

  StrongMT<DebugVarRequester> req = new DebugVarRequester();
  if( req )
  {
    // ��������� "�������� ������ ����������", �������� ��� ���� ����� ���������
    if ( bApplyDefaultScenario )
      for( TScenarioVars::const_iterator it = defaultScenario.begin(); it != defaultScenario.end(); ++it )
        req->ReqVar( it->wsName, it->updPeriod );

    req->userId = userID;
    req->AttachTo( node );

    requesters[ userID ] = req;
  }

  return req;
}


DebugVarRequester* DebugVarRequesterMap::QueryRequester( TUserId userID, rpc::Node* node, const char *path, bool bApplyDefaultScenario )
{ 
  threading::MutexLock lock( mutex );

  StrongMT<DebugVarRequester> req = new DebugVarRequester();
  if( req )
  {
    // ��������� "�������� ������ ����������", �������� ��� ���� ����� ���������
    if ( bApplyDefaultScenario )
      for( TScenarioVars::const_iterator it = defaultScenario.begin(); it != defaultScenario.end(); ++it )
        req->ReqVar( it->wsName, it->updPeriod );

    req->userId = userID;
    req->AttachQuery( node, path );

    requesters[ userID ] = req;
  }

  return req;
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DebugVarRequesterMap::RemoveRequester( TUserId userId )
{
  threading::MutexLock lock( mutex );

  TRequesters::iterator itReq = requesters.find( userId );
  if ( itReq != requesters.end() )
  { 
    //SAFE_DELETE( itReq->second ); - ������ ��� StrongMT<>
    requesters.erase( itReq );
    return true;
  }
  return false;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool DebugVarRequesterMap::GetValue( const TUserId userId, const wstring &name, wstring& outValue ) const
{
  threading::MutexLock lock( mutex );

  TRequesters::iterator itReq = requesters.find( userId );
  if ( itReq != requesters.end() )
    return itReq->second->GetValue( name, outValue );
  else
    return false;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DebugVarRequesterMap::UpdateStep()
{
  threading::MutexLock lock( mutex );

  for( TRequesters::const_iterator it = requesters.begin(); it != requesters.end(); ++it )  
    it->second->UpdateStep();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DebugVarRequester* DebugVarRequesterMap::GetNextUpdated()
{
  threading::MutexLock lock( mutex );

  for( TRequesters::const_iterator it = requesters.begin(); it != requesters.end(); ++it )
    if ( !it->second->IsChecked() )
      return it->second;
 
  return NULL; // ������ ������
}

int DebugVarRequesterMap::ForEachUpdatedVar( TCallbackType funcCallback, void* param )
{
  int updatedCount = 0; // ������ ���������, ������� ���������� ���������� (� ������� ���� �������)

  if ( funcCallback )
  {
    DebugVarRequester* req = GetNextUpdated();
    wstring name, value;
    while( req ) // while ( req = GetNext() ) ��������, ��-�� warning
    {
      while ( req->GetNextUpdatedVar( name, value ) )
      {
        funcCallback( req->userId, name, value, param );
        updatedCount++;
      }

      req->SetChecked();
      req = GetNextUpdated();
    }
  }

  return updatedCount;
}

// ��������� ���������� "��� ������������ ���������� ����", �.�. �� ���� ������������ requester'��
void DebugVarRequesterMap::AddVarBroadcast( const wstring &name, TIMESTAMP secPeriod )
{
  threading::MutexLock lock( mutex );

  for( TRequesters::const_iterator it = requesters.begin(); it != requesters.end(); ++it )
    it->second->ReqVar( name, secPeriod );
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool SScenarioVar::Parse( const nstl::string &pair, bool cmd_may_omit_period )
{
  if ( pair.length() )
  {
    int split = pair.find(":");
    if ( split > 0 && split < pair.length() )
    {// "var:value"
      nstl::string name = pair.substr(0, split);
      nstl::string val = pair.substr(split+1);
      float period = NStr::Convert<float>(val.c_str());

      wchar_t buf[256];
      NStr::ToWString<char const*>( name.c_str(), buf, 256 );

      wsName = buf;
      updPeriod = period;
      LOG_D(0) << "parsed scenario var pair (" << wsName << " : " << updPeriod << ")";

      return true;
    }
    else if ( cmd_may_omit_period )
    {// ��� �������� ������ ����� �������� ":-1"
      wchar_t buf[256];
      NStr::ToWString<char const*>( pair.c_str(), buf, 256 );
    
      wsName = buf;
      updPeriod = NDebug::COMMAND;
      LOG_D(0) << "parsed scenario command (" << wsName << ")";

      return true;
    }
  }
  return false;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TEST
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Test_DebugVarRequester: public DebugVarRequester
{
  void TEST_Case1();
};

struct Test_DebugVarRequesterMap: public DebugVarRequesterMap
{
  void TEST_Case1();
};

void Test_DebugVarRequester::TEST_Case1()
{
  wstring value;

  ReqVarOnce( L"var1" ); // ��� ������� 1 ���
  ReqVar( L"var2", 0.1 ); // ��� ����� ���������� 10 ��� � �������

  ReqVar( L"var3", 0.2 ); // ��� ����� ���������� 5 ��� � �������
  RemoveVar( L"var3" ); // ���, ����� �� �����

  NI_ASSERT( vars.size() == 2, "bad vars count" ); 
  NI_ASSERT( false == GetValue( L"var1", value ), "var1 returned w/o request" ); // lastReceived �� ����������������
    
  TIMESTAMP t1 = NHPTimer::GetScalarTime();

  // ������ ���� ������ 
  while( NHPTimer::GetScalarTime() - t1 < 0.5 )
  {
    UpdateStep();
    nival::sleep( 50 );
  }

  TIMESTAMP t2 = NHPTimer::GetScalarTime();

  NI_ASSERT( vars.size() == 2, "bad vars size" ); 
  
  TClientVars::iterator it = vars.find( L"var1" );
  NI_ASSERT( it != vars.end(), "no var1" );
  NI_ASSERT( it->second.lastRequested > 0, "var1 not requested" ); // ������ ���������  
  NI_ASSERT( it->second.lastRequested - t1 < 0.2, "bad var1 request time" ); // ��������� ���������� �����, �.�. �������� ����������

  it = vars.find( L"var2" );
  NI_ASSERT( it != vars.end(), "no var2" );
  NI_ASSERT( it->second.lastRequested > 0, "var2 not requested" ); // ������ ���������  
  NI_ASSERT( t2 - it->second.lastRequested < 0.2, "bad var2 request time" ); // ��������� �������, �.�. ������������

  CallbackValueReceive( L"var1|value1" );
  bool ok = GetValue( L"var1", value );
  NI_ASSERT( ok, "dummy callback var1 value not set" );
  NI_ASSERT( value == L"value1", "dummy callback var1 value not match" );
}

static int g_ForEach_CallCount = 0;
static void OnVarChanged(const TUserId& userId, wstring& name, wstring& value, void*)
{
  LOG_D(0) << "changed user " << userId << ", var " << name << ", value " << value;
  g_ForEach_CallCount++;
}

void Test_DebugVarRequesterMap::TEST_Case1()
{// ���� ����� Map
  AddScenario( L"var1" ).AddScenario( L"var2", 1.0 );

  DebugVarRequester *req1 = AddRequester( 1, NULL );
  DebugVarRequester *req2 = AddRequester( 2, NULL );

  DebugVarRequester *req3 = AddRequester( 3, NULL );
  req3->ReqVar( L"UNKNOWN", 20 );

  RemoveRequester( 3 );

  NI_ASSERT( requesters.size() == 2, "bad vars size" ); 

  UpdateStep();

  NI_ASSERT( GetNextUpdated() == NULL, "GetNextUpdated returns with no updates" ); 

  // ������ ����� ������ ���-������
  req2->CallbackValueReceive( L"var1|some_val" );

  DebugVarRequester *updated = GetNextUpdated();
  NI_ASSERT( updated, "GetNextUpdated doesnt return after forced receive" );  
  
  if ( updated )
  {
    wstring name, value;
    bool gotVar = updated->GetNextUpdatedVar( name, value ); 
    NI_ASSERT( gotVar, "GetNextUpdatedVar doesnt return after forced receive" );  

    gotVar = updated->GetNextUpdatedVar( name, value ); 
    NI_ASSERT( !gotVar, "GetNextUpdatedVar returns twice after single forced receive" );  
  }

  updated->SetChecked();
  NI_ASSERT( GetNextUpdated() == NULL, "GetNextUpdated returns after SetChecked" ); 

  // ����� ������ 2 ����������
  req1->CallbackValueReceive( L"var2|some_val2" );
  req2->CallbackValueReceive( L"var1|some_val1" );
  
  // � �������� ForEach, � ��������� ���-�� ������������
  g_ForEach_CallCount = 0;
  int retCount = ForEachUpdatedVar( &OnVarChanged, NULL );

  NI_ASSERT( retCount == 2, "bad foreach return count" );
  NI_ASSERT( g_ForEach_CallCount == 2, "bad callback use count" );
}

void TEST_DebugVarRequester()
{
  Test_DebugVarRequester obj;
  obj.TEST_Case1();

  Test_DebugVarRequesterMap reqMap;
  reqMap.TEST_Case1();
}

} // namespace NDebug
