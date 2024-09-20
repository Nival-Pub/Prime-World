#pragma once
#include "Network/TransportTypes.h"

namespace Coordinator
{
  struct SConfigServiceOption
  {
    Transport::TServiceId serviceId; 
    nstl::string option;

    // ������� �����, ������� ����� ��������� ���� �������� (�� ������ �����������)
    bool IsGlobalOption() const { return serviceId.empty() || ("all" == NStr::GetLower( string(serviceId.c_str()) )); } 
  };

  // Global singleton vector <serviceName, option>
  typedef vector<SConfigServiceOption*> TConfigServiceOptions;
  TConfigServiceOptions & GetConfigServiceOptions();
}
