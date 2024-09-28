#pragma once

#include "Core/CommandSerializer.h"
#include "Core/Replay.h"

// HELPER-����� �� �������, ��� ������������ ������ ����������� ������� �� ����� 
// (���, �������� ��� �� ����������� �������� �� ������, ���������, �������� ������ � ������ ������ Replay.cpp)
//
// ��� ���� �������� ������������� ���������:
// if( LoadReplay( filename, clientId )
// {
//   GetCurrentCommand // �������� ������� �������
//   do { ...smth... } while ( GetNextCommand ); // ���������� (�� �����) ��������� �������
// }
class ReplayCommandFeeder: public NonCopyable
{
public:
  ReplayCommandFeeder() : replay(0), startTime(0), clientId(0)
  {}

  bool LoadReplay( const char * replayFileName_, const int clientId_ );
  bool HasReplay() { return (replay != 0); }

  bool GetCurrentCommand( NCore::ReplaySegment::Commands::iterator & outCommand );
  bool GetNextCommand( NCore::ReplaySegment::Commands::iterator & outCommand );

  DWORD GetStartTime() { return startTime; }

  // ������������� ����� ("�� ������ ������� ������"), ����� ������� cmd ������ ���� ���������
  DWORD GetCommandTimestamp( const NCore::ReplaySegment::Commands::iterator & cmd ) { return ((*cmd)->TimeSent() - startTime) / 1000.0; } // timeSent � ��� � ����

private:
  bool GetReplayStartTime();

  CObj<NCore::ReplayStorage> replay;
  NCore::ReplaySegment segment;
  NCore::ReplaySegment::Commands::iterator command;
  DWORD startTime;
  int clientId;
};
