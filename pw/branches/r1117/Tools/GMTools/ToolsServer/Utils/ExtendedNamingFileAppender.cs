using System;
using log4net.Appender;

namespace ToolsServer.Utils
{
  /// <summary>
  /// ���������� ����� ������ ����� ���� � ��� ����� ����� ��������� ��� ����� � �������
  /// yyyy.MM.dd-HH.mm.ss-����������, �� ����� ���� ���� ����������� ������ �� ����
  /// </summary>
  public class ExtendedNamingFileAppender : RollingFileAppender
  {
    public static string ServiceName = String.Empty;
    private string suffixmarker = "TIMEANDSVC";

    protected override void OpenFile(string fileName, bool append)
    {
      string suffix = DateTime.UtcNow.ToString("HH.mm.ss") + ServiceName;
      DatePattern = DatePattern.Replace(suffixmarker, suffix);
      suffixmarker = suffix;

      base.OpenFile(fileName, append);
    }
  }
}