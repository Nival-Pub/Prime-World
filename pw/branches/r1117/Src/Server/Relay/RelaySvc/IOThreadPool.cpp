#pragma warning( disable : 4996)
#include "stdafx.h"
#include "RelaySvc/IOThreadPool.h"
#include "System/ThreadNames.h"

namespace Relay
{
  IOThreadPool::IOThreadPool(const ACE_TCHAR *name, ACE_Log_Msg_Callback* logcb)
    : Terabit::IOThreadPool(name),
    logcb_(logcb)
  {
  }

  IOThreadPool::~IOThreadPool()
  {
  }

  int IOThreadPool::svc()
  {
    threading::SetDebugThreadName("relaytp");

    NI_PROFILE_THREAD;

    //  ����� �� ����������� instance'��� ACE_log_msg
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
