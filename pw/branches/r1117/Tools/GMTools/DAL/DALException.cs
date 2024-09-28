using System;

namespace DAL
{
  /// <summary>
  /// ���������� ���� ������� � ������.
  /// </summary>
  public class DALException : Exception
  {
   public DALException(string message)
      : base(message)
    {
    }
    
    public DALException(string message, Exception innerException)
      : base(message, innerException)
    {
    }
  }
}