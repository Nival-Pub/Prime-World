#pragma once

#include <RPC/RPC.h>
#include "LobbyAccountingStructs.h"

namespace NDb
{
  struct ImpulsiveBuffsContainer;
}


namespace Billing
{
  _interface IBillingProcessor;
}


namespace Lobby
{

REMOTE class LobbyAccounting : public BaseObjectMT
{
  NI_DECLARE_REFCOUNT_CLASS_1( LobbyAccounting, BaseObjectMT )

  LobbyAccounting() : uniqueId() {}

public: 
  RPC_ID();
  LobbyAccounting(Billing::IBillingProcessor* _processor) :
  processor( _processor ), uniqueId( 0 )
  {}

  ~LobbyAccounting() 
  {
  }

  REMOTE int  BlockMoney( int userId, int serviceId );  // �������� ������������� ���������� ����� ����������� ��� ������� ���������� �������, ���������� ������������� ����������
  REMOTE void UnblockMoney( int userId, int blockId ); // ������������ ��������� ����������
  REMOTE int  GetServicePrice( int serviceId ); // ���������� ���� ���������� �������
  REMOTE bool BuyBlockedService( int userId, int blockId, int serviceId );  // �������� ���������� ��������� ������ �� ��������������� �����, ���������� true/false � ������ ������/�������� ��������
  REMOTE Lobby::BuyResult BuyService( int userId, int serviceId );  // �������� ���������� ��������� ������, ���������� true/false � ������ ������/�������� ��������
  REMOTE int  GetMoney( int userId ); // ���������� ������� ��������� ����� 
  
  REMOTE bool GiveMoneyToUser( int userId, int userDstId, int serviceId); // allows to transfer possession of service serviceId between users
  REMOTE const nstl::vector<Lobby::ServiceInfo>& GetServices();

  bool RewardUser( int userId, int rewardId ); // �������� ��������� ����� �������� rewardId, ���������� true/false � ������ ������/�������� ��������

  void SetPrice( int serviceId, int price );
  void SetupReward( int rewardId, int billingRewardId, int size );

private:
  struct SReward
  {
    int   billingId;
    int   size;
    SReward() : billingId(), size() {}
  };

  typedef nstl::map<int, int> ServiceMap;
  typedef nstl::map<nstl::pair<int, int>, int> BlockMap;
  typedef map<int, SReward> RewardsMap;

  int uniqueId;
  ServiceMap servicePrices;
  BlockMap blocks;
  CPtr<Billing::IBillingProcessor> processor;
  nstl::vector<Lobby::ServiceInfo> services;

  RewardsMap rewardSizes;
};

} // Lobby
