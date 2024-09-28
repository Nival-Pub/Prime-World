#include "stdafx.h"

#include "Network/Network.h"
#include "Network/Transport.h"
#include "Server/AppFramework/Interfaces.h"
#include "Coordinator/LoginProcessorBase.h"

#include "System/ThreadHelpers.h"

namespace ZZima
{
struct Invoker;
class InvokerOld;
}

namespace Login {
  
// ������ ��� thread-pool �������
struct SZZimaLoginRequest
{
  enum TStatus {
    NEW = 0,
    TAKEN, // ������� � ������ ��������� over web
    READY, // web-������ �����
    ERASED // ���������, � ���� �� ���� ������ (debug)
  };
  TStatus status; 
  unsigned int workerId; // id worker thread, ������� ������ ���� ������ �� ����������
  string login;
  string password;
  // weak ������: ����� ���� ���������, ��� ����������� ������ context->result ��� ���������� ������ (if still alive)
  StrongMT<Login::SLoginContext> context; 
  Login::LoginResultData resultData;

  SZZimaLoginRequest( string const & login_, string const & pwd_, const StrongMT<Login::SLoginContext> & context_ );
};

typedef nstl::vector<SZZimaLoginRequest*> TWebLoginRequests;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ����� ���� ��������� worker threads ����� �������� ������ �� ZZimaLoginProcessor::requests[]
struct IRequestQueue
{
  virtual SZZimaLoginRequest* GetNextRequest( unsigned getterId ) = 0;
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct ConnectionInfo
{
  string authServer;
  string serviceName;
  string servicePassword;
  string socNetServer;
  string socNetKey;
  string socNetSecret;
  bool authAutoSubscribe;
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// worker thread:
// - �������� ������ �� requests 
// - ��������� PerformSynchroLogin( request )
// ! ������ ������ � ����, ��� worker ��������� �� timeout
class ZZimaWorkerThread: public threading::AutostopThread // Thread � ��� NonCopyable
{
  IRequestQueue* requestSource;

public:
  ZZimaWorkerThread( IRequestQueue* requestSource_, const ConnectionInfo& connectionInfo );
  virtual ~ZZimaWorkerThread();

protected:
  virtual unsigned Work();
  int PerformSynchroLogin( const string & login, const string & _password, Login::LoginResultData & result );

private:
  // ��������� ��� ���������� web-XML: (������ ���� � ������ zzima login processor)
  ZZima::Invoker* invoker;
  ZZima::InvokerOld* invokerOld;
  bool authAutoSubscribe;
  AppFramework::InstanceStatistics authStats;
  AppFramework::InstanceStatistics socnetStats;
};

typedef nstl::map<int, ZZimaWorkerThread*> TZZimaWorkerThreads;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct ZZimaLoginProcessor : public Login::ServerLoginProcessorBase, public IRequestQueue
{
  ZZimaLoginProcessor( const ConnectionInfo& connectionInfo );
  virtual ~ZZimaLoginProcessor();

protected:
  // ILoginProcessor
  virtual bool PerformLoginCheck( string const &login, string const &password, Network::IConnection *connection, Login::LoginResultData* result );
  virtual void AsyncLoginRequest( string const & login, string const & pwd, const StrongMT<Login::SLoginContext> & context );
  virtual void AsyncStep(); // ����� ������������ �������, ���������� �����������, �������� ��������, � �.�.

  // IRequestQueue:
  SZZimaLoginRequest* GetNextRequest( unsigned getterId ); 

private:
  ConnectionInfo connectionInfo; // ���� ������� respawn'��� worker threads, �� ���� ����� ����������� ��� info
  TZZimaWorkerThreads threads;

  threading::Mutex mutexRequests;
  TWebLoginRequests requests; // ������ �� web-����� (��������� � ZZima), ���� ����� �������� worker threads
};

} // namespace Login