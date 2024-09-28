#include "stdafx.h"
#include "GameTestClient_Other.h"


static unsigned g_maxAllowedChatLoopbackTime = 20.0; // ���� �� ������� ������ ��� �� ������ ������� ���� �� ���������, ��������
static unsigned g_maxAllowedChatConnectTime = 20.0; // ���� �� ������� ������ �� ������������, ��������

namespace gtc
{

StepResult Client_Login::MainStep()
{
  StepResult result = TestClientBase::MainStep();
  if ( !result.Ok() || result.Handled() )
    return result;

  switch(stage_)
  {
    default:
      return StepResult( false, true );

    case Stage::LOGIN_FINISHED:
      if( transport_ ) 
      {
        userId_ = transport_->GetUserId(); // quick hack (���� ����� �� ������� ��� id)

        LOG_D(0) << "success: login finished for user " << params.user << ", userId " << userId_;

        //// � ���������, ������� ���� ����������� �� ������� (��������� ������ �� Read Error'��)
        //transport_->Logout();
        timeLoginFinished_ = timer::Now();
        stage_ = Stage::LOGIN_WAIT_AFTER;
      }
      return StepResult( true, true );

    case Stage::LOGIN_WAIT_AFTER:
      //if( timer::Now() - timeLoginFinished_ > 1 )
      return StepResult( true, false ); // ����� ��������� �������

      //// � ���������, ������� ���� ����������� �� ������� (��������� ������ �� Read Error'��)
      //{// relogin after pause
      //  LOG_D(0) << "user " << params.user << " relogging";
      //  stage_ = Stage::NONE;
      //}
      //bres = true;
      break;
  }
}











StepResult Client_Replay::MainStep()
{
  StepResult result = Client_GS::MainStep();
  if ( !result.Ok() || result.Handled() )
    return result;

  switch(stage_)
  {
    default:
      return StepResult( false, true );

    case Stage::LOGIN_FINISHED:
      stage_ = Stage::GAME; 
      timePlaySessionStarted = timer::Now();
      return StepResultOk();

    case Stage::GAME:
      // command replay
      if ( replay.HasReplay() )
      {
        NCore::ReplaySegment::Commands::iterator cmd;
        if( replay.GetCurrentCommand( cmd ) )
        {// �� ���� �� ���������?
          while( timer::Now() - timePlaySessionStarted > replay.GetCommandTimestamp( cmd ) )
          {// ���� �������� �������
            // � ���� ������ ������ ������������� ������� (�.�. �� � ����� �� �� � ������, ������ ������������) 
            LOG_D(0) << "replay cmd time(ofs): " << (*cmd)->TimeSent() - replay.GetStartTime() << ", time(sent): " << (*cmd)->TimeSent();

            if( !replay.GetNextCommand( cmd ) ) // ������� ��������� �������
              break;
          }
        }
      }
      return PollGame();
  }
}


bool Client_Replay::LoadReplay( const char * replayFileName, int replayClientId )
{ 
  return replay.LoadReplay( replayFileName, replayClientId );
}
} //namespace gtc
