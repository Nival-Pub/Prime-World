using System.Collections.Generic;
using System.Text;

namespace LocKit.Tokens
{
  /// <summary>
  /// ������� ����� ��� ���� �������.
  /// </summary>
  public abstract class Token
  {
    public string Text { get; set; }

    public virtual string GetAllText()
    {
      return Text;
    }
  }

  /// <summary>
  /// ������� ����� ��� ���� �����.
  /// </summary>
  public class TagToken : Token { }

  public class AtomToken : TagToken { }
  public class AtomCloseToken : TagToken { }
  public class BrToken : TagToken { }
  public class CenterToken : TagToken { }
  public class FJustifyToken : TagToken { }
  public class FRightToken : TagToken { }
  public class IfToken : TagToken
  {
    public List<Token> childTokens;

    public override string GetAllText()
    {
      if (childTokens == null)
        return base.GetAllText();

      var sb = new StringBuilder();
      sb.Append(base.GetAllText());
      childTokens.ForEach(t => sb.Append(t.GetAllText()));
      return sb.ToString();
    }
  }
  public class IfCloseToken : TagToken { }
  public class IfElseToken : IfToken { }
  public class ImageToken : TagToken { }
  public class JustifyToken : TagToken { }
  public class LeftToken : TagToken { }
  public class RightToken : TagToken { }
  public class SpaceToken : TagToken { }
  public class StyleToken : TagToken { }
  public class StyleCloseToken : TagToken { }
  public class ValueToken : TagToken { }

  /// <summary>
  /// ������� ����� ��� ���� "������-�����" $(###).
  /// </summary>
  public class PTagToken : Token { }

  /// <summary>
  /// ����������� ����� ��� ��������� ������� ������
  /// </summary>
  public class AngleBracketToken : Token { }

  /// <summary>
  /// ����� ��� �������� ������.
  /// </summary>
  public class TextToken : Token
  {
  }

}