#ifndef WINDOWPOINTJOB_H_INCLUDED
#define WINDOWPOINTJOB_H_INCLUDED

#include "Window.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace UI
{

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ����������� ����������� ��� �������� ����, ������������� ��� �������� ������,
// � ���������� ����������� ��������� 2D <-> 3D � ������� �����
class WindowPointJob : public IWindowJob
{
public:
  WindowPointJob();
  WindowPointJob( const Point & _point );
  void SetPoint( const Point & _point ) { unconverted = _point; point = _point; }
  void SetCaptureTarget( Window * capture, bool _ignoreCapturedRect ) { captureTarget = capture; ignoreCapturedRect = _ignoreCapturedRect; }
  void SetIgnoreWindow( Window * ignore ) { ignoreWindow = ignore; }

protected:
  //����������� ��������� ��� 3D-����
  Point   unconverted, point;

  //����� ��������� ��� ���� � ��� ��� �����
  Window * ignoreWindow;
  //
  bool    ignoreCapturedRect;

  //��� ��������� ������ captureTarget � ���� ����
  Window * captureTarget;
  bool    processingCaptured;

  virtual EWindowJobCode::Enum BeforeChildren( Window * target );
  virtual EWindowJobCode::Enum AfterChildren( Window * target );
  virtual bool Act( Window * target ) = 0;
};

} //namespace UI

#endif //WINDOWPOINTJOB_H_INCLUDED
