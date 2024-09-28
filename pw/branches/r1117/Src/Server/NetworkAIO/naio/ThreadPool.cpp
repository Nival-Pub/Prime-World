#include "naio/stdafx.h"
#include "naio/ThreadPool.h"
#include <System/ThreadNames.h>

namespace naio
{
  ThreadPool::ThreadPool(const ACE_TCHAR *name,
                         ACE_Log_Msg_Callback* logcb)
    : Terabit::IOThreadPool(name),
    logcb_(logcb)
  {
  }

  ThreadPool::~ThreadPool()
  {
  }

  int ThreadPool::svc()
  {
    threading::SetDebugThreadName("naio");

    NI_PROFILE_THREAD;

    //  log callback �� ����������� instance'��� ACE_log_msg
    //  ������� ���������� ��� ��� ������� �������� (� ������ ������)
    if (logcb_)
    {
      ACE_LOG_MSG->set_flags (ACE_Log_Msg::MSG_CALLBACK);
      ACE_LOG_MSG->clr_flags (ACE_Log_Msg::STDERR);
      ACE_LOG_MSG->msg_callback (logcb_);
    }

    return Terabit::IOThreadPool::svc();
  }
}
