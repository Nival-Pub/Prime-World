using System;
using log4net.Appender;

namespace StatisticService.LoadTests.Utils
{
  /// <summary>
  /// ���������� ����� ������ ����� ���� � ��� ����� ����� ��������� ��� ����� � �������
  /// yyyy.MM.dd-HH.mm.ss, �� ����� ���� ���� ����������� ������ �� ����
  /// </summary>
  public class ExtendedNamingFileAppender : RollingFileAppender
  {
    private string timemarker = "TIME";

    protected override void OpenFile(string fileName, bool append)
    {
      string time = DateTime.Now.ToString("HH.mm.ss");
      DatePattern = DatePattern.Replace(timemarker, time);
      timemarker = time;

      base.OpenFile(fileName, append);
    }
  }
}