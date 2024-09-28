#include "stdafx.h"
#include "StarForce.h"

#pragma code_seg(push, "~")

#ifdef STARFORCE_PROTECTED
  #include "StarForce/PsaApi.h"
  #include "../AsyncInvoker.h"
#endif


namespace Protection
{
#ifdef STARFORCE_PROTECTED

class CallProxy
{
  SeparateThreadFuncPtr funcPtr;
  const void *pData;  

public: 
  CallProxy( SeparateThreadFuncPtr funcPtr = 0, const void *pData = 0 ):
    funcPtr(funcPtr), pData(pData) 
  {}
  
  void operator()() const
  {
    (*funcPtr)( pData );
  }
};

struct AsyncInvokerPriority: threading::AsyncInvoker<CallProxy>
{
  AsyncInvokerPriority()
  {
    SetPriority( THREAD_PRIORITY_BELOW_NORMAL );
  }
};

static AsyncInvokerPriority g_invoker;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static STARFORCE_FORCE_INLINE void CheckForTerminate( int line, bool result, unsigned __int32 status = PSC_STATUS_SUCCESS )
{
  if( status != PSC_STATUS_SUCCESS || !result )
  {
    ErrorTrace( "Protection Error. Status: 0x%08X, line: %d", status, line );
    int volatile * volatile p = 0;
    *p = 0; 

    exit( 0xDeadBeef ); 
  }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static STARFORCE_FORCE_INLINE void CheckForLog( int line, bool result, unsigned __int32 status = PSC_STATUS_SUCCESS )
{
  if( status != PSC_STATUS_SUCCESS || !result )
    WarningTrace( "Protection Warning. Status: 0x%08X, line: %d", status, line );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

STARFORCE_EXPORT void CheckReadOnlyAndExecutableImpl( const void * )
{
  STARFORCE_STOPWATCH();

  //�� ������ ��������� �������� �������������� �������� StripReloc � �������� ������ 
  //PSA_CheckProtectedModulesReadOnlyMem �������� ����� ��� � 50 ���
  //http://www.jrsoftware.org/striprlc.php

  bool checkResult = false;
  const unsigned __int32 status  = PSA_CheckProtectedModulesReadOnlyMem( &checkResult );

  // NUM_TASK ����� CheckForTerminate ������� �� CheckForLog
  // �������� ����� ����������� ������������ ������ ���������. ���� �������� ����������, ������ ���� ����������� ��������� ���-�� �� ������,
  // ������� "��������� ���������� ������" ���������.
  CheckForLog( __LINE__, checkResult, status );  
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
STARFORCE_EXPORT void CheckSystemDllsImpl( const void * )
{
  STARFORCE_STOPWATCH();
  
  //�� ��������� ������������� ���� ������� ���������� ������. ��������,
  //PSA_CheckSystemLibsReadOnlySections ����������� ��� ��������� 
  //���������� Avast. 
  //�� ��������� �� StarForce:
  //
  // > �, �������, ���� �� ��� ������� ������, ��������� ������� ����� 
  // > ������������� ��������, �� ����� �� �������� � ������������? 
  //
  // � ����� ������� ��� ������������� �������, �� ���� �������, ��������� 
  // ������ ������� �� ����� ������������ ��� ���������� ���������� ������
  // ����������, ��� ��� ��� ����� ����������� � ��� ������� ������������ ��. 
  // ��� ������ ����������� �������������� ���������� � �������������� �����. 
  // ��� ��������� �������: PSA_CheckSystemLibsLocation ����� ������� ������
  // ������������ �� ����������� ������������������ ��������, �������� �� 
  // ������������� ������������� Windows. 
  // PSA_CheckSystemLibsIat � PSA_CheckSystemLibsReadOnlySections ����� ����� 
  // ������� ������ ������������, ��� ������� ���������� �� (��������, ���������).
  {
    bool systemLibLocationChanged = true;
    const unsigned __int32 status  = PSA_CheckSystemLibsLocation( NULL, NULL, &systemLibLocationChanged );
    CheckForLog( __LINE__, !systemLibLocationChanged, status ); 
  }
  
  {
    bool systemLibIatModifiedPtr = true;
    const unsigned __int32 status  = PSA_CheckSystemLibsIat( NULL, NULL, &systemLibIatModifiedPtr );
    CheckForLog( __LINE__, !systemLibIatModifiedPtr, status ); 
  }
  
  #ifdef OPTION_ENABLE_SYSTEM_LIBS_CODE_SECTION_CHECK
  {
    bool readOnlySectionsModified = true;
    const unsigned __int32 status  = PSA_CheckSystemLibsReadOnlySections( NULL, NULL, &readOnlySectionsModified );
    CheckForLog( __LINE__, !readOnlySectionsModified, status ); 
  } 
  #endif
}
#endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

STARFORCE_EXPORT void CheckReadOnlyAndExecutable()
{
  #ifdef STARFORCE_PROTECTED
    //���� ������ ������� BeginInvoke, �� �������� ��������, �����
    //������� ������ ��� ������ ��� �� ��������� � � ����� ������ 
    //�������� ����� ����� ���������� �� ������� ���������� 
    //������������ ������. ��� ���� ����� ��� �� ��������� �����
    //����� ������ ������������ ����� ������ ������, ����� � 
    //���������� �� ���������� �� ������ ����
    if( !g_invoker.IsBusy() )
      g_invoker.BeginInvoke( CheckReadOnlyAndExecutableImpl ); 
    else
      STARFORCE_LOG( "Implementation call skip: %s",  __FUNCTION__ );  
  #endif 
}

STARFORCE_EXPORT bool CheckReadOnlyAndExecutableImmediate()
{
#ifdef STARFORCE_PROTECTED
  STARFORCE_STOPWATCH();

  bool checkResult = false;

  const unsigned __int32 status  = PSA_CheckProtectedModulesReadOnlyMem( &checkResult );

  CheckForLog(__LINE__, checkResult, status);

  if (status != PSC_STATUS_SUCCESS)
    return false;
  if (checkResult != true)
    return false;
#endif

  return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

STARFORCE_EXPORT void CheckSystemDlls()
{
  #ifdef STARFORCE_PROTECTED
    if( !g_invoker.IsBusy() ) //��. ����
      g_invoker.BeginInvoke( CheckSystemDllsImpl );
    else
      STARFORCE_LOG( "Implementation call skip: %s",  __FUNCTION__ );  
  #endif 
}

STARFORCE_EXPORT void CallFunctionInProtectedSpace( SeparateThreadFuncPtr funcPtr, const void *pData )
{
  #ifdef STARFORCE_PROTECTED
    STARFORCE_STOPWATCH();
  
    if( !g_invoker.IsBusy() )
    { 
      g_invoker.BeginInvoke( CallProxy(funcPtr, pData) );
      g_invoker.EndInvoke();
    }
    else
    {
      //�� �� ����� ���� ��������� ������ ������������ ����� funcPtr, �����, ���
      //��� ���������� � ��������� ������, ������� ������ ������� ��� ������� � 
      //�������� ������
      (*funcPtr)( pData );
    }
  #else
    (*funcPtr)( pData );
  #endif 

}

} //namespace Protection

#pragma code_seg(pop)
