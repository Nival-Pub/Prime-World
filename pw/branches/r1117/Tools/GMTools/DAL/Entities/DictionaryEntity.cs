namespace DAL.Entities
{
  /// <summary>
  /// ������� �������� ��� ������������.
  /// </summary>
  public class DictionaryEntity
  {
    /// <summary>
    /// �������������.
    /// </summary>
    public virtual int Id { get; set; }

    private string name;

    /// <summary>
    /// ��������.
    /// </summary>
    public virtual string Name
    {
      get { return name; }
      set { name = Truncate(value); }
    }

    /// <summary>
    /// ������� ����, ��� ������ ������.
    /// </summary>
    public virtual bool Deleted { get; set; }

    /// <summary>
    /// ����������� ������ �� 255 �������� (����� �� ��������� � NHibernate)
    /// </summary>
    /// <param name="value">������.</param>
    protected string Truncate(string value)
    {
      return Truncate(value, 255);
    }

    /// <summary>
    /// ����������� ������, ������� �������� ��������.
    /// </summary>
    /// <param name="value">������.</param>
    /// <param name="size">�����.</param>
    protected string Truncate(string value, int size)
    {
      if (System.String.IsNullOrEmpty(value))
        return value;
      return value.Length <= size ? value : value.Remove(size);
    }

    #region Equality code

    public override bool Equals(object obj)
    {
      return base.Equals(obj);
    }

    public virtual bool Equals(DictionaryEntity other)
    {
      if (ReferenceEquals(null, other)) return false;
      if (ReferenceEquals(this, other)) return true;
      return Equals(other.Name, Name) && other.Id == Id && other.Deleted.Equals(Deleted);
    }

    public override int GetHashCode()
    {
      unchecked
      {
        int result = (Name != null ? Name.GetHashCode() : 0);
        result = (result*397) ^ Id;
        result = (result*397) ^ Deleted.GetHashCode();
        return result;
      }
    }

    public static bool operator ==(DictionaryEntity left, DictionaryEntity right)
    {
      return Equals(left, right);
    }

    public static bool operator !=(DictionaryEntity left, DictionaryEntity right)
    {
      return !Equals(left, right);
    }

    #endregion
  }
}