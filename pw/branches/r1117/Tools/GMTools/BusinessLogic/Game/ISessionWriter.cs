using System;
using System.Collections.Generic;

namespace BusinessLogic.Game
{
  /// <summary>
  /// ������ ���������� � ������ � ����������� ������.
  /// </summary>
  public interface ISessionWriter : IDisposable
  {
    bool IsRunning { get; }

    /// <summary>
    /// ����������� �������
    /// </summary>
    void MMakingCancelled(MMakingPlayerInfo mmplayer, DateTime timestamp);

    /// <summary>
    /// ����������� ������ ������
    /// </summary>
    void MMakingSession(ulong persistentId, int status, int manoeuvresFaction, int basket, string map, DateTime timestamp, IEnumerable<MMakingPlayerInfo> mmplayers);

    /// <summary>
    /// ������ ������
    /// </summary>
    void SessionStart(long persistentId, string map, string server, string serveraddress, string cluster, int sessionType, DateTime timestamp, IEnumerable<SessionStartPlayerInfo> players);

    /// <summary>
    /// ���������� ������
    /// </summary>
    void SessionResult(long persistentId, int result, int sideWon, int surrendervote, DateTime timestamp, IEnumerable<SessionResultPlayerInfo> players);

    /// <summary>
    /// ���������� ���������� � relay
    /// </summary>
    void SessionRelayInfo(long persistentId, long playerid, string relayAddress);
  }
}