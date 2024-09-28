using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace LocKit.Tokens
{
  /// <summary>
  /// ��������������� ����� ��� ������ � ��������.
  /// </summary>
  public class TokenProcessor
  {
    /// <summary>
    /// ����������� �������� ����� � ������������������ �������.
    /// </summary>
    public List<Token> ProcessText( string text )
    {
      var tokens = new List<Token>();
      int pos = 0;

      // ����������� ����� ������ ����� ��������� � � ����� ������� ����������.
      var fqs = new List<ITokenFabrique>
                  {
                    new TagTokenFabrique(),
                    new PTagTokenFabrique(),
                    new AngleBracketTokenFabrique(),
                    new TextTokenFabrique()
                  };

      // ����������� ������ �����.
      while ( pos < text.Length )
      {
        string filepart = text.Substring( pos );
        Token t = null;

        foreach ( ITokenFabrique fq in fqs )
        {
          t = fq.GetToken( filepart );
          if ( t != null ) break;
        }

        if ( t == null )
          throw new Exception( "Cannot parse string :\n" + filepart );

        pos += t.Text.Length;
        tokens.Add( t );
      }

      // �������������� ������.
      List<Token> result = Syntax( tokens );

      return result;
    }

    /// <summary>
    /// �������������� ������ ���������� �������, ���������� ��������.
    /// </summary>
    private List<Token> Syntax( List<Token> tokens )
    {
      var result = new List<Token>();
      // ������� ����������� �� ������ � ������ �������������� ������� �������� ���������.
      int pos = 0;
      while ( pos < tokens.Count )
      {
        // ���� ���������� IfToken, �� ��� ��������� ������ �� IfCloseToken ��������� ��� �������������.
        if ( tokens[pos] is IfToken )
          SyntaxIf( tokens, ref pos, result );
        else
          result.Add( tokens[pos] );
        pos++;
      }
      return result;
    }

    /// <summary>
    /// ��������� If-then ����� �� ������� �������.
    /// </summary>
    private void SyntaxIf( List<Token> tokens, ref int pos, List<Token> result )
    {
      IfToken token = tokens[pos] as IfToken;
      if ( token == null )
        throw new Exception( "This is not IF! pos = " + pos );

      result.Add( token );
      // ���� if ����� ��� �� �� �������������, �� ����� ������������� ��������� �������� �������
      if ( !( tokens[pos + 1] is IfElseToken ) && !( tokens[pos + 1] is IfCloseToken ) )
        token.childTokens = new List<Token>();

      do
      {
        pos++;
        Token item = tokens[pos];
        if ( item is IfElseToken )
        {
          // ��������� else
          SyntaxIfElse( tokens, ref pos, result );
          break;
        }
        else if ( item is IfToken )
        {
          // ��������� ��������� if'��.
          SyntaxIf( tokens, ref pos, token.childTokens );
        }
        else if ( item is IfCloseToken )
        {
          // IfCloseToken ��������� ���������.
          result.Add( item );
          break;
        }
        else
        {
          token.childTokens.Add( item );
        }
      } while ( pos < tokens.Count - 1 );
    }

    /// <summary>
    /// ��������� If-else ����� �� ������� �������.
    /// </summary>
    private void SyntaxIfElse( List<Token> tokens, ref int pos, List<Token> result )
    {
      IfElseToken token = tokens[pos] as IfElseToken;
      if ( token == null )
        throw new Exception( "This is not ELSE! pos = " + pos );

      result.Add( token );
      // ���� else ����� ��� �� �� �������������, �� ����� ������������� ��������� �������� �������
      if ( !( tokens[pos + 1] is IfCloseToken ) )
        token.childTokens = new List<Token>();

      do
      {
        pos++;
        Token item = tokens[pos];
        if ( item is IfToken )
        {
          // ��������� ��������� if'��.
          SyntaxIf( tokens, ref pos, token.childTokens );
        }
        else if ( item is IfCloseToken )
        {
          // IfCloseToken ��������� ���������.
          result.Add( item );
          break;
        }
        else
        {
          token.childTokens.Add( item );
        }
      } while ( pos < tokens.Count - 1 );
    }

    /// <summary>
    /// ��������� ����������� ������� �������
    /// </summary>
    /// <param name="tokens"></param>
    /// <param name="warncount"></param>
    /// <param name="errorcount"></param>
    public void SyntaxVerification( List<Token> tokens, ref int warncount, ref int errorcount )
    {
      for ( int i = 0; i < tokens.Count; i++ )
      {
        if ( ( tokens[i] is IfToken ) && ( ( tokens.Count - i ) > 1 )
          && !( tokens[i + 1] is IfElseToken ) && !( tokens[i + 1] is IfCloseToken ) )
        {
          Trace.TraceError( String.Format( "ERROR : {0} after {1}", tokens[i + 1].GetType().Name, tokens[i].GetType().Name ) );
          errorcount++;
        }
        if ( ( tokens[i] is IfElseToken ) && ( ( tokens.Count - i ) > 1 )
          && !( tokens[i + 1] is IfCloseToken ) )
        {
          Trace.TraceError( String.Format( "ERROR : {0} after {1}", tokens[i + 1].GetType().Name, tokens[i].GetType().Name ) );
          errorcount++;
        }
        if ( tokens[i] is IfToken )
        {
          var t = (IfToken)tokens[i];
          if ( t.childTokens != null )
            SyntaxVerification( t.childTokens, ref warncount, ref errorcount );
        }
        if ( tokens[i] is IfElseToken )
        {
          var t = (IfElseToken)tokens[i];
          if ( t.childTokens != null )
            SyntaxVerification( t.childTokens, ref warncount, ref errorcount );
        }
      }
    }


  }
}