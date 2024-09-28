#pragma once

#include <System/Basic.h>
#include <Server/RPC/P2PNode.h>
#include <Server/RPC/GateKeeper.h>
#include <Server/rpc/LocalEntityFactory.h>
#include <Server/Network/ClientTransportSystemIntf.h>
#include <Server/Network/FreePortsFinder.h>
#include "Server/Network/TransportTypes.h" 
#include "Server/Network/AddressTranslator.h" 

#include "System/HPTimer.h"

#include "Server/ClusterAdmin/ClusterAdminSvcIntf.h"
#include "Server/ClusterAdmin/RClusterAdminSvcIntf.auto.h"

namespace TransportLayer
{
  class TransportModule;
}


namespace AdminConsole
{
  namespace Stage
  {
    enum
    {
      NONE,
      INVALID,
      LOGIN_STARTED,
      LOGIN_FINISHED,

      // ��������� ����� ������� ��� ����������� �����
      LOOP,
      WAIT,
      INPUT,
    };
  };

  namespace Result
  {
    enum 
    {
      NONE = -1,
      SUCCESS = 0,
      FAIL,
      IN_PROGRESS
    };
  };

  typedef NHPTimer::FTime Timestamp;
  #define GetTime() NHPTimer::GetScalarTime()

  class Client :  public BaseObjectMT, 
                  rpc::IGateKeeperCallback
  {
    NI_DECLARE_REFCOUNT_CLASS_2( Client, BaseObjectMT, rpc::IGateKeeperCallback );

  public:
    Client();

    Client( int localId, 
      StrongMT<Transport::ITransportSystem> clusterTransport, 
      nstl::string loginAddr
      );

    ~Client();

    int stage() const;
    int lastResult() const;

    // var update
    bool StepVarUpdate_Cluster();
  
    void OnClusterAdminPtr( ClusterAdmin::RIClusterAdmin* ptr );
    void NoConnectWarning();

    void SwitchToInput();
    bool HandleInput(); // ������������ ���������� ������� ������������ ( input_ ); ���� ���-�� �� �����������, ������� false

  protected:
    //  rpc::IGateKeeperCallback
    virtual void OnNewNode( Transport::IChannel* channel,  rpc::Node* node );
    virtual void OnChannelClosed( Transport::IChannel* channel,  rpc::Node* node );
    virtual void OnCorruptData( Transport::IChannel* channel, rpc::Node* node );

    void NextInput(); // ������ ������ �����, ������� ����������� "CMD >"
    void PrintCompletions(); // ������� ������ ������� ���������� � ��������� ��������
  
    StrongMT<Network::INetworkDriver> netdriver_;
    StrongMT<TransportLayer::TransportModule> sptm_;
    StrongMT<Transport::ITransportSystem> transport_; 
    StrongMT<rpc::GateKeeper> gateKeeper_;
    rpc::LocalEntityFactory * factory_;
    rpc::Node * rpcNode_;
    Timestamp timeConnectStarted_;

    StrongMT<ClusterAdmin::RIClusterAdmin> clusterAdmin;
    nstl::string loginAddr_;

    int stage_;
    int lastresult_;
    bool bexit_;

    nstl::string input_; // user console input
    bool need_stage_reset_;  // �������� ����� ����� ��������� service/varlist, ����� ��� ������� loop ������� ������ connect � ����������
  };

  inline int Client::stage() const
  {
    return stage_;
  }

  inline int Client::lastResult() const
  {
    return lastresult_;
  }

} // namespace AdminConsole
