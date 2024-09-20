using System;

namespace DAL.Entities
{
  /// <summary>
  /// ���������� ������.
  /// </summary>
  public class SocialSession
  {
    /// <summary>
    /// �������������.
    /// </summary>
    public virtual long Id { get; set; }

    /// <summary>
    /// �����.
    /// </summary>
    public virtual Player Player { get; set; }

    /// <summary>
    /// IP ����� ������
    /// </summary>
    public virtual string PlayerIp { get; set; }

    /// <summary>
    /// ������.
    /// </summary>
    public virtual string Server { get; set; }

    /// <summary>
    /// �������.
    /// </summary>
    public virtual string Cluster { get; set; }

    /// <summary>
    /// ����� ������ ������.
    /// </summary>
    public virtual DateTime StartTime { get; set; }

    /// <summary>
    /// ����� ��������� ������.
    /// </summary>
    public virtual DateTime EndTime { get; set; }

  }
}