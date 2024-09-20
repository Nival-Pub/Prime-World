using System;
using System.Collections.Generic;
using LocKit.Tokens;

namespace LocKit.Localization
{
  /// <summary>
  /// ��������������� ����� ��� ������ � ������� �����������.
  /// </summary>
  public class LocalizationProcessor
  {
    private LocalizationFile resource;
    private int ifcounter;
    private readonly object _locker = new object();

    /// <summary>
    /// �������������� ������ ������� � ������ ����� �����������.
    /// </summary>
    /// <param name="filename">��� ��������� ����� (������ ����� ������)</param>
    /// <param name="tokens"></param>
    public LocalizationFile TokensToLocalization( string filename, List<Token> tokens )
    {
      lock ( _locker )
      {
        resource = new LocalizationFile( filename );
        resource.Body = new LocalizationFilePart();
        Convert( tokens, resource.Body );
        if ( resource.Ifs != null )
          resource.Ifs.Sort( ( a, b ) => a.Id.CompareTo( b.Id ) );
        return resource;
      }
    }

    /// <summary>
    /// ��������� ������� � ���������� ���������� � ���� resource.
    /// </summary>
    private void Convert( List<Token> tokens, LocalizationFilePart dest )
    {
      // ���������� � ������� ����� ��������� ����
      int txtst = tokens.FindIndex( t => t is TextToken );
      int txtfi = tokens.FindLastIndex( t => t is TextToken );

      int pos;
      // ���������� ������ "prefix".
      for ( pos = 0; pos < ( txtst == -1 ? tokens.Count : txtst ); pos++ )
      {
        if ( tokens[pos] is IfToken )
        {
          if ( resource.Ifs == null )
            resource.Ifs = new List<LocalizationIfBlock>();

          // ���� ���������� IfToken, �� �������������� ��������
          int cnt = ConvertIf( tokens, ref pos );
          dest.Prefix += String.Format( LocalizationIfBlock.IFPATTERN, cnt );
        }
        else
        {
          dest.Prefix += tokens[pos].Text;
        }
      }

      // ���� �� ������� �� ������ TextToken, �� �� - ���� ������� �������
      if ( txtst != -1 )
      {
        // ���������� ������ "text"
        for ( ; pos <= txtfi; pos++ )
        {
          if ( tokens[pos] is IfToken )
          {
            if ( resource.Ifs == null )
              resource.Ifs = new List<LocalizationIfBlock>();

            int cnt = ConvertIf( tokens, ref pos );
            dest.Text += String.Format( LocalizationIfBlock.IFPATTERN, cnt );
          }
          else
          {
            dest.Text += tokens[pos].Text;
          }
        }
        // ���������� ������ "suffix"
        for ( ; pos < tokens.Count; pos++ )
        {
          if ( tokens[pos] is IfToken )
          {
            if ( resource.Ifs == null )
              resource.Ifs = new List<LocalizationIfBlock>();

            int cnt = ConvertIf( tokens, ref pos );
            dest.Suffix += String.Format( LocalizationIfBlock.IFPATTERN, cnt );
          }
          else
          {
            dest.Suffix += tokens[pos].Text;
          }
        }
      }
    }

    /// <summary>
    /// ��������� ����������� If.
    /// </summary>
    private int ConvertIf( List<Token> tokens, ref int pos )
    {
      if ( !( tokens[pos] is IfToken ) )
        throw new Exception( "There is no IF in position = " + pos );

      var ifdata = new LocalizationIfBlock( ifcounter++ );
      var iftoken = (IfToken)tokens[pos];

      try
      {
        if ( tokens[pos + 1] is IfCloseToken || tokens[pos + 1] is IfElseToken )
        {
          // ��������� then
          ifdata.ThenPart = new LocalizationFilePart();
          ifdata.ThenPart.Prefix += iftoken.Text;

          if ( iftoken.childTokens != null )
          {
            Convert( iftoken.childTokens, ifdata.ThenPart );
          }

          // ���� ���� else - ��������� else
          if ( ( tokens[pos + 1] is IfElseToken ) && ( tokens[pos + 2] is IfCloseToken ) )
          {
            var elsetoken = (IfElseToken)tokens[++pos];

            ifdata.ElsePart = new LocalizationFilePart();
            ifdata.ElsePart.Prefix += elsetoken.Text;

            if ( elsetoken.childTokens != null )
              Convert( elsetoken.childTokens, ifdata.ElsePart );

            ifdata.ElsePart.AppendTag( tokens[++pos].Text );
          }
          else
            // ������������ end
            ifdata.ThenPart.AppendTag( tokens[++pos].Text );
        }
        else
        {
          throw new Exception( "I can't stand it in pos = " + pos );
        }
      }
      catch ( IndexOutOfRangeException ex )
      {
        throw new Exception( "Skip pos = " + pos, ex );
      }

      // ���������� � ������ if
      resource.Ifs.Add( ifdata );
      return ifdata.Id;
    }

    public List<Token> LocalizationToTokens( LocalizationFile file )
    {
      throw new NotImplementedException();
    }

  }
}