#ifndef LOGINPROCESSORBASE_H_E0842D12_DC
#define LOGINPROCESSORBASE_H_E0842D12_DC

#include "Network/LoginContext.h" // SLoginContext, IAsyncLoginProcessor
//#include "rpc/P2PNode.h"
#include "rpc/IfaceRequester.h"


namespace Login
{

class ServerLoginProcessorBase : public Login::IAsyncLoginProcessor
{
public:
  ServerLoginProcessorBase();

  virtual void setUserManagerIface( rpc::IfaceRequester<UserManager::RIUserManager> * _userMngrIface ) { userMngrIface_ = _userMngrIface; }

  virtual bool MainStep();
  virtual bool ClientStep( SLoginContext * context );
  virtual unsigned GetAsyncOpCount() { return asyncOpCount; }
  
  bool IsServerTimeout( const Timestamp timeout ); // �� ����� �� timeout �� ������ ���������� SetMainStage

  // helper: ������ ������� ���-�� ����������� �������� �� ���� (��� ������� isAsync == true)
  void SetClientStage( SLoginContext * context, const SLoginContext::TStage stage, const bool isAsync=false);

protected:
  StrongMT<rpc::IfaceRequester<UserManager::RIUserManager> > userMngrIface_;

private:
  // async
  Timestamp    timeServerNow; // ������ �������� ����� 1 ���, � ����� MainStep
  int          asyncOpCount; // ���-�� ����������� �������� �� ���� (����� ����������� ���������� ��� ����)
};

} // namespace Login

#endif //#define LOGINPROCESSORBASE_H_E0842D12_DC
