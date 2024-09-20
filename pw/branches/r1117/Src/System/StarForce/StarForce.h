#ifndef STARFORCE_H_B49639B9_D704_4F6D_B
#define STARFORCE_H_B49639B9_D704_4F6D_B

#include "System/HPTimer.h"
#include "System/SystemLog.h"

#pragma code_seg(push, "~")

#ifdef STARFORCE_PROTECTED
  #define STARFORCE_EXPORT __declspec(dllexport) __declspec(noinline)
  #define STARFORCE_FORCE_INLINE __forceinline
  #define STARFORCE_FORCE_NOINLINE __declspec(noinline)
#else
  #define STARFORCE_EXPORT
  #define STARFORCE_FORCE_INLINE inline
  #define STARFORCE_FORCE_NOINLINE
#endif

#if defined( STARFORCE_PROTECTED ) && 0
  #define STARFORCE_STOPWATCH() Protection::Stopwatch stopwatchImpl( __FUNCTION__ )
  #define STARFORCE_LOG( ... ) DebugTrace( __VA_ARGS__ )
#else
  #define STARFORCE_STOPWATCH() ((void)0)
  #define STARFORCE_LOG( ... ) ((void)0)
#endif

namespace Protection
{
  typedef void (*SeparateThreadFuncPtr)( const void *pData );

  //��������� �������� ������ ���������� ������� ReadOnly � Executable �� ��, 
  //��� ��� �� ���� �������� � �������� ������ ���������. �.�. �� ��������� ��� 
  //� ������ �� ����� ������ ����������. ����� ������� ������������.
  STARFORCE_EXPORT void CheckReadOnlyAndExecutable();

  STARFORCE_EXPORT bool CheckReadOnlyAndExecutableImmediate();
  
  //��������� �� ��� ��������� dll ������������ � ���������� ����. �������� �� ���� 
  //���� SpeedHack � ��� ��������. ����� ������� ������������.
  STARFORCE_EXPORT void CheckSystemDlls();
  
  //������� ����� ������� ������������ � ���������� ��������� funcPtr �� �������, 
  //����� �������, ��������� ��� ����������� ���������������� ����. ��� ������� 
  //����� ������� � ��������� ������, �� ��� ���� �������� ����� ����� ��������� 
  //�� ����� �� ����, ��� ����� ������� funcPtr �����������. �� ���� ����� �������
  //������� ������� � ����� CallFunctionInProtectedSpace, ������������ �� ����������.
  // 
  //���� ����� ���� ��������� � ����� � ���, ��� ����� PSA_CheckProtectedModulesReadOnlyMem
  //������������ 3 ������� � �� �� ����� ��������� ���� �������� ��� � �������� ������. 
  //������� ��� ��������� � �������� ������ ��������� ������ � ���������� ���������� 
  //������ � ����� ���������� ����������. ��� ���� ����� ��������� ����������� 
  //�������� ������������ ������ ������ ���� ����� ������ ��������� ����� ������� 
  //������ ��� � �����-������ ������ ����������� ����������, ��� ���� � ���������� 
  //������ �������. 
  STARFORCE_EXPORT void CallFunctionInProtectedSpace( SeparateThreadFuncPtr funcPtr, const void *pData );
  
  //������� ��������� ������� ���������� �������
  class Stopwatch
  {
  public:
    explicit Stopwatch( const char * funcName ): funcName(funcName) 
    {
      DebugTrace( "Function %s begin. Thread: 0x%08X.", 
#if defined( NV_WIN_PLATFORM )
        funcName, GetCurrentThreadId()
#elif defined( NV_LINUX_PLATFORM )
        funcName, pthread_self()
#endif
      );
      
      NHPTimer::GetTime(startTime);
    }
    
    ~Stopwatch()
    {
      NHPTimer::STime curTime;
      NHPTimer::GetTime(curTime);
      
      curTime = curTime - startTime;

      DebugTrace( "Function %s execution time: %g sec. Thread: 0x%08X.", 
#if defined( NV_WIN_PLATFORM )
        funcName, NHPTimer::Time2Seconds(curTime), GetCurrentThreadId()
#elif defined( NV_LINUX_PLATFORM )
        funcName, NHPTimer::Time2Seconds(curTime), pthread_self()
#endif
      );
    }

  private:
    NHPTimer::STime startTime;
    const char *funcName;
  };
}

#pragma code_seg(pop)

#endif //#define STARFORCE_H_B49639B9_D704_4F6D_B