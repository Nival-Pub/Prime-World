using System;
using log4net.Appender;

namespace GameDataImporter.Utils
{
  /// <summary>
  /// ���������� ����� ������ ����� ���� � ��� ����� ����� ��������� ��� ����� � �������
  /// yyyy.MM.dd-HH.mm.ss-����������, �� ����� ���� ���� ����������� ������ �� ����
  /// </summary>
  public class ExtendedNamingFileAppender : RollingFileAppender
  {
    private string suffixmarker = "TIME";

    protected override void OpenFile(string fileName, bool append)
    {
      string suffix = DateTime.UtcNow.ToString("HH.mm.ss");
      DatePattern = DatePattern.Replace(suffixmarker, suffix);
      suffixmarker = suffix;

      base.OpenFile(fileName, append);
    }
  }
}