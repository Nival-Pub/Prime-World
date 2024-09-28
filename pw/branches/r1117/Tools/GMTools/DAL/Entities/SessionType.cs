namespace DAL.Entities
{
  /// <summary>
  /// ��� ������������ ������.
  /// ������������� namespace EGameType (\Src\PF_GameLogic\GameStatisticTypes.h)
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

    /// <summary>
    /// �����������.
    /// </summary>
    PvX_Matchmaking = 2,

    /// <summary>
    /// ����������.
    /// </summary>
    PvX_Training = 3,

    /// <summary>
    /// ����������� ����� ���������� ������.
    /// </summary>
    Soc_Matchmaking,

    /// <summary>
    /// ���������� ����� ���������� ������.
    /// </summary>
    Soc_Training
  }
}