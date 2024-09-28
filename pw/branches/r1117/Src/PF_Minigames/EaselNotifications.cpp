#include "stdafx.h"

#include "EaselNotifications.h"

#include "../System/Updater.h"

namespace PF_Minigames
{

NDebug::PerformanceDebugVar easelPerf_WorldClientNotifications("World-Client notify", "EaselPerf", 0, 0.0f, true);

EaselNotifier::EaselNotifier( PF_Core::IWorld* _pWorld )
: PF_Core::WorldObjectBase(_pWorld, false )
{
 // updater = new Updater::CUpdater();
}

void EaselNotifier::Register( tObserver& observer )
{
  updater.Register(&observer);
}

void EaselNotifier::Register(int _typeID, Updater::IUpdateProcessorFunc *_pFunc)
{
  updater.Register(_typeID,_pFunc);
}

bool EaselNotifier::Notify( tNotification& notification )
{
  NDebug::PerformanceDebugVarGuard(easelPerf_WorldClientNotifications, false);

  //
  // REMARK !!! ��� ���� ��� �������� �� ������, ����� ����� ������� ���������
  // �� � ������� ������ ����� ��������� � ������� new
  // �� ����� ��������, ����� ���������� ������ ��� ������� ��������� ������
  // ��� ��������� ��� �����
  //
  // ��� �������� �� � ������, � � CObjectBase. ��� ����� ��������� ������ ����� new � ���������� ������ ����� CObj/CPtr.
  // �� � ����� ������ ���� ��������� �� ����������. ���������� ����� �������� �� ������ ����� - ������ ��������. �������� �� ��������� ���� 
  // ������ � ����� ������ ����� �� ������. � ����� ���� �� � ���� ������ �� ������ ����������� � new/delete. ���� ������ ��� ��������� CObj, �� 
  // delete ������� ����� �� �������. 

  updater.Push( &notification, false);
  return true;
}

} // namespace PF_Minigames

BASIC_REGISTER_CLASS( PF_Minigames::IEaselNotifier )
REGISTER_SAVELOAD_CLASS_NM( EaselNotifier, PF_Minigames )
