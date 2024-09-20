using System;

namespace DAL.Entities
{
  /// <summary>
  /// ���������� �� ������������ ������
  /// </summary>
  public class MMakingPlayer
  {
    /// <summary>
    /// �������������
    /// </summary>
    public virtual long Id { get; set; }

    /// <summary>
    /// ������ ������������
    /// </summary>
    public virtual MMakingSession MMakingSession { get; set; }

    /// <summary>
    /// ����� ������
    /// </summary>
    public virtual PlayerCharacter PlayerCharacter { get; set; }

    /// <summary>
    /// ��� ������ { Undefined = 0, Male = 1, Female = 2 }
    /// </summary>
    public virtual int Sex { get; set; }

    /// <summary>
    /// ������� ������ { None = -1, Team1 = 0, Team2 = 1 }
    /// </summary>
    public virtual int Faction { get; set; }

    /// <summary>
    /// �������
    /// </summary>
    public virtual int Rating { get; set; }

    /// <summary>
    /// ������� ������
    /// </summary>
    public virtual int PlayerRating { get; set; }

    /// <summary>
    /// ����
    /// </summary>
    public virtual float Force { get; set; }

    /// <summary>
    /// ����� ������
    /// </summary>
    public virtual int Party { get; set; }

    /// <summary>
    /// ����� ��������
    /// </summary>
    public virtual float WaitInterval { get; set; }

    /// <summary>
    /// ����� ���������
    /// </summary>
    public virtual int LoseStreak { get; set; }

    /// <summary>
    /// ������� ����� ������
    /// </summary>
    public virtual int FameLevel { get; set; }

    /// <summary>
    /// ��� ������ (� ����� "�������" ������������ �� ��������) { Undefined = -1, Newbie = 0, Normal = 1, Guard = 2 }
    /// </summary>
    public virtual int Basket { get; set; }

    /// <summary>
    /// ������� { None = 0, Accept = 1, Cancel = 2, Slowpoke = 3, PreGameLobbyReady=4, PreGameLobbyNotReady=5 }
    /// </summary>
    public virtual int LobbyReaction { get; set; }

    /// <summary>
    /// ����� �������, ������� ������ ��� �������, �� ���� ��������� ������� = 0
    /// </summary>
    public virtual float? LobbyReactionTime { get; set; }

    /// <summary>
    /// ����� ��������� ������������ (��������� ��� ���)
    /// </summary>
    public virtual DateTime Timestamp { get; set; }
  }
}