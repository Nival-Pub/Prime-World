#ifndef THREADWITHTASK_H_4FF430BA_CE8C_4
#define THREADWITHTASK_H_4FF430BA_CE8C_4

#include "SyncPrimitives.h"
#include "Thread.h"
#include "StarForce/StarForce.h"

namespace threading
{
namespace detail 
{
  // ���������� ���������� ������ �������, ���� ���� ���� ��������� void
  template< class T >
  struct ResultStorage
  {
    T t;

    ResultStorage(): t() {}
    ResultStorage(const T &t): t(t) {}
    template<class FncT> void Call( const FncT &fn ) { t = fn(); }
    const T &Result() const { return t; }
  };

  template<>
  struct ResultStorage<void>
  {
    template<class FncT> void Call( const FncT &fn ) { fn(); }
    void Result() const {}
  };  
}
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ����� ������������ ��� ���������� ������������ ����� � ��������� ������. 
// ������� ��������� ��� ���������� � �������� ������ ������� ���� TaskT, ����� �������� ������ 
// ���������� ��� ResultT.
// ����� ��������� ������������ ������ ���� ������ ������������, ������� ����� ��������� �
// ������ ��������� ������. ��� ������� ���������� ����� ������ � �������� ���������� ����������
// ���������� ����� ����� ������������ �� ����� � ����������. ������� ����� �� ��������������.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
template< class TaskT, class ResultT = void >
class AsyncInvoker: private Thread, private detail::ResultStorage<ResultT>
{
  typedef detail::ResultStorage<ResultT> ResultStorage;
  
public:

  // ����������� ������ �����, ������� ����� ������� ����������� �����
  AsyncInvoker(): needStop(false), m_task()
  {
    hCanStartTaskEvent = CreateEvent( 0, FALSE, FALSE, 0 );
    NI_ASSERT( hCanStartTaskEvent != NULL, "" );
    
    hTaskCompleateEvent = CreateEvent( 0, FALSE, FALSE, 0 );
    NI_ASSERT( hTaskCompleateEvent != NULL, "" );
    
    hTaskMutex = CreateMutex( 0, FALSE, 0 );
    NI_ASSERT( hTaskMutex != NULL, "" );
     
    Thread::Resume();
  }
  
  // ���������� ������� ��������� ���������� ����� � ��������� �����
  ~AsyncInvoker()
  {
    NI_VERIFY_NO_RET( WaitObject(hTaskMutex), "" );  
    needStop = true;  
    NI_VERIFY_NO_RET( SetEvent(hCanStartTaskEvent), "" );
    NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
     
    NI_VERIFY_NO_RET( Thread::Wait(), "" );     
    NI_VERIFY_NO_RET( CloseHandle(hCanStartTaskEvent), "" );
    NI_VERIFY_NO_RET( CloseHandle(hTaskCompleateEvent), "" );
    NI_VERIFY_NO_RET( CloseHandle(hTaskMutex), "" );
  }
 
  // ��������� ���������� ������ task. ������ ����� ��������� � ��������� ������. 
  // ���� � ������ ������ ������� ����������� ������ ������, �� ���������� ����� 
  // ����� ������������ �� ����� � ����������.  
  // ��� �������� ���������� ������ ������������� EndInvoke() � Sync() 
  STARFORCE_FORCE_INLINE void BeginInvoke( const TaskT &task )
  {
    NI_VERIFY_NO_RET( WaitObject(hTaskMutex), "" ); 
     
    // ��� ���� ������, ������� ����������� � ���������� �� ��� �� ���������
    if( CheckObject(hCanStartTaskEvent) )
    {
      //�������� ������ � ���������� ������
      ResultStorage::Call(m_task);     
    }
    
    m_task = task; 
      
    NI_VERIFY_NO_RET( SetEvent(hCanStartTaskEvent), "" );
    
    //���������� ������� � ���������� ���������� ������.
    //��� ����� ��� ���� ����� ������������� ��������, ����� ��� ������������������ 
    //������� [BeginInvoke, BeginInvoke, EndInvoke] ���������� ��� EndInvoke �������� 
    //���������� ������ ��� ������� ������, � ����� EndInvoke ����� ����������� ��������, 
    //��� �� ���������� ������� �������. 
    NI_VERIFY_NO_RET( ResetEvent(hTaskCompleateEvent), "" );
    
    NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
  }
  
  // ��������� ���������� ������ � ������� � ���������.
  // ����� ��������� ���������� ����� �� ��� ���, ���� �� ���������� 
  // ������� ����������� ������ ���, ���� ������� ���, ���������� ����� ������������ 
  // �� ��� ���, ���� ������ ����� �� ������� ����� ������ � ��� ����� ���������. 
  // ����� ���������� ������ ����� ����� �������� ������ ���� ���, �.�. ��������� ����� ������� 
  // � ���������� ������ � �������� ����� �����. �.�. ���������� ������� ������� ������ 
  // ������ ��������������� ���������� ������� BeginInvoke(), SyncInvoke() � FakeInvoke()
  STARFORCE_FORCE_INLINE ResultT EndInvoke()
  {
    HANDLE rgSyncObjects[] = { hTaskCompleateEvent, hTaskMutex };

    NI_VERIFY_NO_RET( WaitObjects(rgSyncObjects), "" );
    
    //����� ����������� ���������, �.�. ����� ������������ �������� 
    //����� ���� ��������� � ��������� ����� ������
    ResultStorage resultCopy(*this);

    NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
  
    return resultCopy.Result();
  }
    
  // ��������� ������ � ���������� ������.
  // ����� ���� � BeginInvoke(), �� ����������� ����, ��� ��������� ������ ����������
  // �����. ��� ��������� ���������� ���������� ������ ����� ����� ������� EndInvoke()
  STARFORCE_FORCE_INLINE void SyncInvoke( const TaskT &task )
  {
    NI_VERIFY_NO_RET( WaitObject(hTaskMutex), "" ); 
    
    // ��� ���� ������, ������� ����������� � ���������� �� ��� �� ���������
    if( CheckObject(hCanStartTaskEvent) )
    {
      //�������� ������ � ���������� ������
      ResultStorage::Call(m_task);     
    }
     
    m_task = task;   
    ResultStorage::Call(m_task);
        
    NI_VERIFY_NO_RET( SetEvent(hTaskCompleateEvent), "" );
    NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
  }
  
  // ������������ ���������� ������ � ����������� result.
  // �������� result ������ ���� ���� ResultT 
  // ������ �����, ������� �������, ������������ ��� ����������� ������������ 
  // �������������� ������ EndInvoke(). ��������, ��� ������� ����� ��������� ������� 
  // �������� ������� EndInvoke(), � ����� BeginEnvoke(), �.�. ������� ������������ ��������� 
  // ���������� ������� ������, � ����� ��������� ����� ������ � ���������� � �� ����������. 
  // ����� ����� ������ ������� ����� ������� ����� ������� FakeInvoke() � ����� ����������� 
  // ����� EndInvoke �� ����� ������������.
  // � ������ �������, ���� ���������� �������� ��������� ���������� ������ �����
  // �������� ������� EndInvoke() ����� ��������������� ��������� ������:
  //      asyncInvoker.FakeInvoke( asyncInvoker.EndInvoke() );
  // �� ��������� � ����� ������� ��������� ���������� ������ � �������� ���������, � � ������
  // ������� ��������� ����������� ������������� ����� EndInvoke(). ����� ������� ��, ���
  // ����� ����� ����������� � ����� ������� EndInvoke() � FakeInvoke() ����� ��������� ������ 
  // �����, ��. ����� Sync()
  STARFORCE_FORCE_INLINE void FakeInvoke( const ResultStorage &result = ResultStorage() )
  {
    NI_VERIFY_NO_RET( WaitObject(hTaskMutex), "" ); 
    
    // ��� ���� ������, ������� ����������� � ���������� �� ��� �� ���������
    if( CheckObject(hCanStartTaskEvent) )
    {
      //�������� ������ � ���������� ������
      ResultStorage::Call(m_task);     
    }
    
    static_cast<ResultStorage &>(*this) = result;   
    NI_VERIFY_NO_RET( SetEvent(hTaskCompleateEvent), "" );
    NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
  }
  
  // ��������� ���������� ������, ���� ��� ����������, � ���� ��� - 
  // ������ ���������� ����������. 
  // ����� �� �������� ���������� ��������� � �� ������ �� ����������� ������ EndInvoke() �
  // ���������� �� EndInvoke() ���, ��� �� �������� � ��������� ��� ����������� �� ���� 
  // ��� � ������� ��� �� ������.  
  STARFORCE_FORCE_INLINE void Sync()
  {
    NI_VERIFY_NO_RET( WaitObject(hTaskMutex), "" ); 
    
    // �� ��������� ������� � ������ ������ � ������ ������ �� ����������� �  
    // �������� ������ ��������� ���������:  
    // 1. ������ ��� ��������� - ������ ������ �� ����
    // 2. ��� ������ ��� ���������� - ���� ������ ������ �� ���� 
    // 3. ������ ����������� � ���������� �� ��� �� ��������� - ����� ��������� ����
    
    if( CheckObject(hCanStartTaskEvent) )
    {
      //�������� ������ � ���������� ������
      ResultStorage::Call(m_task);     
      NI_VERIFY_NO_RET( SetEvent(hTaskCompleateEvent), "" ); 
    } 

    NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
  }
  
  // ����������� �� ������ � ������ ������ �, �������, �������� �� �������� ����� ������ ���
  // �������� � ���������� ������
  STARFORCE_FORCE_INLINE bool IsBusy() const
  {
    if( !CheckObject(hTaskMutex) )
    {
      //������ ������� �����, ������ ������ �����������
      return true;
    }
    
    //������� �� ����� � ������ � ������ ������ �� �����������, ��, ��������,
    //���������� ������ ������������� � ��� ����� ����� ����������
    bool isBusyResult = false;
    
    if( CheckObject(hCanStartTaskEvent) )
    {
      isBusyResult = true;
      
      //��������� CheckObject() Event ��� �������, ����� ��� ����
      NI_VERIFY_NO_RET( SetEvent(hCanStartTaskEvent), "" );
    }
    
    //��������� CheckObject() ������� ��� ��������, ����� ��� ����
    NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
    
    return isBusyResult;
  }
    
  //���������� ��������� ������
  void SetPriority( int priority )
  {
    Thread::SetPriority(priority);  
  }
  
private:
  // ��������� ���� ������
  STARFORCE_FORCE_INLINE static bool WaitObject( HANDLE hObj )
  {
    return WaitForSingleObject(hObj, INFINITE) == WAIT_OBJECT_0;
  }  
  
  // ��������� ��������� ��������
  template< size_t N >
  STARFORCE_FORCE_INLINE static bool WaitObjects( HANDLE (&arr)[N] )
  {
    return WaitForMultipleObjects(N, arr, TRUE, INFINITE) == WAIT_OBJECT_0;
  } 
  
  // ��������� ������� ��������� �������, ��������, ��� ����, 
  // ��� �������� ������� ��������� ��������
  STARFORCE_FORCE_INLINE static bool CheckObject( HANDLE hObj )
  {
    const DWORD res = WaitForSingleObject(hObj, 0);
    NI_ASSERT( res == WAIT_OBJECT_0 || res == WAIT_TIMEOUT, "" );
    return res == WAIT_OBJECT_0;
  }       

  //������� ������� ������
  STARFORCE_EXPORT virtual unsigned Work()
  {
    HANDLE rgSyncObjects[] = { hCanStartTaskEvent, hTaskMutex };
    
    for(;;)
    {
      NI_VERIFY_NO_RET( WaitObjects(rgSyncObjects), "" );
         
      if( needStop )
      {
        NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
        return 0;  
      }
        
      ResultStorage::Call(m_task);     
      
      NI_VERIFY_NO_RET( SetEvent(hTaskCompleateEvent), "" );
      NI_VERIFY_NO_RET( ReleaseMutex(hTaskMutex), "" );
    }
  }

private:
  //����� ������, ��� ������������� �� ���������� ������
  TaskT m_task; 
  
  //������� ���������� ���������� ������
  HANDLE hTaskMutex; 
  
  //�������: ��������� ������ ��� ����������
  HANDLE hCanStartTaskEvent;
  
  //�������: ���������� ������ ���������. 
  //������������ ��� �������������� ����� ��������, ����� ����� �������� BeginInvoke() � EndInvoke() 
  //�������� ������� ���� ������� � ������� ����� �� �������� ��������� hTaskMutex
  HANDLE hTaskCompleateEvent;
  
  //���� ������������ ������� ����� ����������
  bool needStop; 
}; 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Mock-������ ��������� ������ � ���������� ������, �� ��������� ��������� AsyncInvoker
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
template< class TaskT, class ResultT = void >
class FakeAsyncInvoker: private detail::ResultStorage<ResultT>
{
  typedef detail::ResultStorage<ResultT> ResultStorage;

public:
  FakeAsyncInvoker(): m_task() {}

  void BeginInvoke( const TaskT &task )
  {
    m_task = task;   
    ResultStorage::Call(m_task); 
  }

  ResultT EndInvoke()
  {
    return ResultStorage::Result();
  }
  
  void SyncInvoke( const TaskT &task )
  {
    m_task = task;   
    ResultStorage::Call(m_task);
  }
  
  void FakeInvoke( const ResultStorage &result = ResultStorage() )
  {
    static_cast<ResultStorage &>(*this) = result;   
  }

  void Sync() 
  {
    //Nothing
  }   
  
  bool IsBusy() const
  {
    return true;
  }
  
  void SetPriority( int priority ) 
  {
    (void) priority;
    //Nothing
  }

private:
  TaskT m_task; 
}; 



}

#endif //#define THREADWITHTASK_H_4FF430BA_CE8C_4