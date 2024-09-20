#include "stdafx.h"
#include <signal.h>
#include "Signals.h"

namespace Signals {

	#if defined( NV_WIN_PLATFORM )

		void SignalHandler(int signal)
		{
			LOG_A(0) << "ABORT SIGNALED";
			throw "ABRT";
		}

		// ������������� abort (������� � ��� ����� ������ ���-���, �� ����� ���������� �������, �� ��� ACE/IOTerabit)
		void CatchAbort()
		{
			signal(SIGABRT, SignalHandler);
			_set_abort_behavior( 0, _WRITE_ABORT_MSG ); // ����� �� ����� �������� ��������� � ������ CrtDbgBreak()
		}

		//// ��� �����, ����� ������ abort, ����������� �� ACE_ASSERT � ������� dll-��, � �����:
		//  try {
		//    abort();
		//  }
		//  catch(...) {
		//    printf( "Abort catched\n");
		//  }

	#elif defined( NV_LINUX_PLATFORM )

		void SignalHandler( int signal )
		{
			LOG_A(0) << "ABORT SIGNALED";
		}

		void CatchAbort()
		{
			signal( SIGABRT, SignalHandler );
		}

	#endif

} // namespace Signals

