#ifndef TEXTMARKUPCOMMON_H_INCLUDED
#define TEXTMARKUPCOMMON_H_INCLUDED

#include "../UI/Root.h"

#define NMARKUP_STRING( s ) ( L##s )
#define NMARKUP_DUMP 


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace NMarkup
{

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
typedef wchar_t TChar;
typedef wstring TString;
typedef int TOffset;

const static TOffset NullOffset = TString::npos;
typedef float TUnit; //������� ��������� �������������� ���������� ������; �.�. int ��� float

struct TPoint
{
  //NOTICE: ���������� �� �������� ����� ����������!!
  //���� ����������� ���-���� ����� �������������, ����� ��������� � ��� ������������� ������� CVec2 � CTPoint<>
  TUnit x, y;
  TPoint() : x( 0 ), y( 0 ) {}
  TPoint( TUnit _x, TUnit _y ) : x( _x ), y( _y ) {}
};



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct SBounds
{
  TUnit   width; //���������� ������ ������
  TUnit   ascent; //���������� ������ ������
  TUnit   descent; //���������� ������ "���������" ��� baseline. � � � � � � � � � � � � � ��������
  TUnit   gapAbove; //�������������� ������ ������
  TUnit   gapUnder; //�������������� ������ �����
  SBounds() : width( 0 ), ascent( 0 ), descent( 0 ), gapAbove( 0 ), gapUnder( 0 ) {}
};



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_interface IStyle;
_interface IImage;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_interface IUiRender
{
public:
  virtual IStyle *  GetStyle( const TChar * style ) = 0; // for ( style == 0) should return default style; should never return 0
  virtual IImage *  CreateImage( TPoint * size, const TChar * image ) = 0;
};



_interface IImage
{
public:
  virtual void      RenderImage( const TPoint & offset, const TPoint & size ) = 0;
};



_interface IStyle
{
public:
  //�������� ������ ������ ������
  //���������� �������� (�������� 'maxWidth', ���� �� 0) ���������� �������� ������
  virtual TOffset   GetTextBounds( SBounds * bounds, const TChar * text, TOffset length, TUnit maxWidth ) const = 0;

  //�������� ������������ ������� ������; ������������ � DefaultLineGap() � VisualHeight()
  virtual void      GetDefaultBounds( SBounds * bounds ) const = 0;

  //������ �������
  virtual TUnit     DefaultGlyphWidth() const = 0;

  //���������� �������� (����� base-line-���), ������������ ��� ������� ������ �����
  virtual TUnit     DefaultLineGap() const = 0;

  //������ ��������� ���� ������ ��� baseline; ������������ ��� ������������ ����������� �� ������ ������
  virtual TUnit     VisualHeight() const = 0;

  virtual void      RenderText( const SBounds & bounds, const TPoint & offset, const TChar * text, TOffset length ) = 0;
};

}; //namespace NMarkup

#endif //TEXTMARKUPCOMMON_H_INCLUDED
