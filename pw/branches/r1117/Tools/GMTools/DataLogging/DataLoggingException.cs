using System;

namespace DataLogging
{
  /// <summary>
  /// ���������� ��� ������ ���������� �������.
  /// </summary>
  public class DataLoggingException : Exception
  {
    public DataLoggingException(string message)
      : base(message)
    {
    }

    public DataLoggingException(string message, Exception innerException)
      : base(message, innerException)
    {
    }
  }
}