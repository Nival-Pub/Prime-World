using System;

namespace DAL.Entities
{
  /// <summary>
  /// ������������� ��������� �������
  /// </summary>
  public class CharacterUnlock
  {
    /// <summary>
    /// �������������
    /// </summary>
    public virtual int Id { get; set; }

    /// <summary>
    /// ����� ����������� ������
    /// </summary>
    public virtual PlayerCharacter PlayerCharacter { get; set; }

    /// <summary>
    /// ����������� �������
    /// </summary>
    public virtual ResourceLog ResourceLog { get; set; }

    /// <summary>
    /// ���� ������
    /// </summary>
    public virtual DateTime Timestamp { get; set; }

    //���� �� ������� Character ��� Name
    public virtual string CharacterName { get; set; }

    #region Equality code

    public virtual bool Equals(CharacterUnlock other)
    {
      if (ReferenceEquals(null, other)) return false;
      if (ReferenceEquals(this, other)) return true;
      return Timestamp.Equals(other.Timestamp) && Equals(ResourceLog, other.ResourceLog) && Equals(PlayerCharacter, other.PlayerCharacter) && Id == other.Id;
    }

    public override bool Equals(object obj)
    {
      if (ReferenceEquals(null, obj)) return false;
      if (ReferenceEquals(this, obj)) return true;
      if (!(obj is CharacterUnlock)) return false;
      return Equals((CharacterUnlock)obj);
    }

    public override int GetHashCode()
    {
      unchecked
      {
        int hashCode = Timestamp.GetHashCode();
        hashCode = (hashCode*397) ^ (ResourceLog != null ? ResourceLog.GetHashCode() : 0);
        hashCode = (hashCode*397) ^ (PlayerCharacter != null ? PlayerCharacter.GetHashCode() : 0);
        hashCode = (hashCode*397) ^ Id;
        return hashCode;
      }
    }

    public static bool operator ==(CharacterUnlock left, CharacterUnlock right)
    {
      return Equals(left, right);
    }

    public static bool operator !=(CharacterUnlock left, CharacterUnlock right)
    {
      return !Equals(left, right);
    }

    #endregion
  }
}