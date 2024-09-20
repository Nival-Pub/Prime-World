using System;

namespace DAL.Entities
{
  /// <summary>
  /// ������ ������������
  /// </summary>
  public class MMakingSession
  {
    /// <summary>
    /// �������������
    /// </summary>
    public virtual long Id { get; set; }

    /// <summary>
    /// ���������� id �� ������� ������������
    /// </summary>
    public virtual long PersistentId { get; set; }

    /// <summary>
    /// ������ { None = 0, Launched = 1, Dismissed = 2 }
    /// </summary>
    public virtual int Status { get; set; }

    /// <summary>
    /// �������, ��� ������� ���������� ������ { None = -1, Team1 = 0, Team2 = 1 }
    /// </summary>
    public virtual int ManoeuvresFaction { get; set; }

    /// <summary>
    /// ��� ������ (�� ����� "�������" ������������ ��� �������)
    /// { Undefined = -1, Newbie = 0, Normal = 1, Guard = 2 }
    /// </summary>
    public virtual int Basket { get; set; }

    /// <summary>
    /// �����
    /// </summary>
    public virtual string Map { get; set; }

    /// <summary>
    /// ����� �������� ������
    /// </summary>
    public virtual DateTime Timestamp { get; set; }

  }
}