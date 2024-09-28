#include "stdafx.h"
#include "LoginServerSync.h"

namespace Login
{

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LoginServerSync::LoginServerSync( Network::INetworkDriver* _pDriver, const Network::NetAddress& _loginServerAddress, 
  ILoginProcessor* _processor, ::SSL_CTX* _secureContext, Login::ClientVersion const & _clientVer)
  : LoginServerBase( _pDriver, _loginServerAddress, 0, _secureContext, _clientVer )
{
  processor = _processor;
  Start(); // ��������� thread
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool LoginServerSync::ProcessNewContext( StrongMT<SLoginContext>& context )
{
  LoginRequestMessage & req = context->request;
  LoginResultMessage & resp = context->response;
  // ��������� � ������ ������������ ���������� ������ ������
  resp.loginResult = processor->CheckLogin( req.login, req.password, context->connection, &resp );
  // � ����� �� �������� �����
  SendReply( context );
  return false; // �� ���� ����� ������� �������, ����� �� ���� ������ SendReply
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void LoginServerSync::OnNewLoginSuccess( LoginResultMessage & resp )
{
  processor->NewClientLoggedIn( resp.userId, resp.sessionId );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
} // namespace Login