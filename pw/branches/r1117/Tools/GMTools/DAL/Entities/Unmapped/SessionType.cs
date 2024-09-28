namespace DAL.Entities
{
  /// <summary>
  /// ��� ������������ ������.
  /// ������������� namespace EGameType (\Src\Game\PF\Server\Statistic\StatisticsServerTypes.h)
  /// </summary>
  public enum SessionType
  {
    /// <summary>
    /// ��������� ��������, �� ������ ����������.
    /// </summary>
    None = 0,

    /// <summary>
    /// ����������� �������� ������.
    /// </summary>
    Dev_Custom = 1,

    // �� ������������:
    // PvX_Matchmaking = 2,
    // PvX_Training = 3,

    /// <summary>
    /// ������� �����������.
    /// </summary>
    Soc_Matchmaking = 4,

    /// <summary>
    /// ����������.
    /// </summary>
    Soc_Training = 5,

    /// <summary>
    /// ��������.
    /// </summary>
    Soc_Tutorial = 6,

    /// <summary>
    /// PvE �����.
    /// </summary>
    Soc_Singleplayer = 7,

    /// <summary>
    /// PvE ����.
    /// </summary>
    Soc_Coop = 8,

    /// <summary>
    /// ���������� ����.
    /// </summary>
    Soc_CustomGame = 9,

    /// <summary>
    /// ���������� ���� � ������
    /// </summary>
    Soc_CustomGameBots = 10
  }
}