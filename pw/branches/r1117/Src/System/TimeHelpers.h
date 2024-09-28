#pragma once

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ����� ��������� �������� ��������� ��������� ��������. ������ ��������� �������, ����� 
// ������ ������ Set, �������� ����� ��������� ������ � ����������
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
template< class T >
class ValueChangeSmoother
{
public:
  ValueChangeSmoother() { SetTmmediately(0); } 

  ValueChangeSmoother( T _curValue, T _diffPerTick ) 
  {
    Init( _curValue, _diffPerTick );
  }
  
  void Init( T _curValue, T _diffPerTick )
  {
    curValue = destValue = _curValue;
    diffPerTick = _diffPerTick;
  }

  void SetTmmediately( T val ) { curValue = destValue = val; } 

  void Set( T val ) 
  { 
    destValue = val; 
    correctDiffPerTick();
  } 
  
  void SetSpeed( T _diffPerTick )
  {
    diffPerTick = _diffPerTick;
    correctDiffPerTick();
  }

  T Get() const { return curValue; }

  T Tick()
  {
    if( curValue != destValue )
      curValue = CalcNextVal( diffPerTick );

    return Get();
  }
  
  T Tick( float deltaTime )
  {
    if( curValue != destValue )
      curValue = CalcNextVal( diffPerTick * deltaTime );

    return Get();
  }
 
private:
  void correctDiffPerTick()
  {
    if( (destValue >= curValue) != (diffPerTick > 0) )
      diffPerTick = -diffPerTick;
  }

  T CalcNextVal( float diff ) const
  {
    const T nextValue = curValue + diff;

    return (curValue < destValue) != (nextValue > destValue ) ? 
           nextValue : destValue;
  }
  
private:
  T curValue;
  T destValue;
  T diffPerTick;
};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////
// ������������� ������ ��������� �������� ������������ ����� ��� �������������
// � ������������ ��������������.
// �������� � ���������� ���������� ����������.
//////////////////////////////////////////////////////////////////////////////////////
class SimpleTimer
{   
public:
  SimpleTimer() { Reset(); }    

  //�������� ������ � �������� ���������
  void Reset() { curTime = totalTime = FLT_MIN; }

  //��������� ������ �� ������������ ����� time ������
  void Start( float time ) { ASSERT(time >= 0); curTime = totalTime = time; }
   
  //���������� ������
  void Stop() { curTime = FLT_MIN; }
    
  //������� �� ������ � ������� ������ � ����� ������������ ��� �� ���������
  bool IsInProgress() const { return curTime != FLT_MIN; }
  
  //������������� �� ��������� �� ����������� ������ Start
  void Restart() { ASSERT(time >= 0); curTime = totalTime; }
  
  //���������� ����� ����������� � ���������� ������ Start, ��� ��������� ������ 
  //� ���������� ������ Start ������� Restart
  //������������ Start(time); Stop();
  void SetTotalTime( float time ) { ASSERT(time >= 0); totalTime = time;  } 
  
  //�����, �� ������� ��� ������� ������ � ��������� ���
  float GetTotalTime() const { return totalTime; }
  
  //����� �� ������������ �������
  float GetTimeToAlarm() const { return curTime; }
  
  //������ �������� ������� deltaTime.
  //���� ������� ���������� true, ������ �������� ������� ������. ��� ����
  //����� ����� ��������� ������ ����� ������� Start() ��� Restart()
  bool Tick( float deltaTime )
  {          
    if ( IsInProgress() )
    {
      curTime -= deltaTime;

      if ( curTime <= 0 ) 
      { 
        Stop();      
        return true;
      }
    }

    return false;
  } 

  //���������� ������� Tick, �� ������������� ������������� ������ 
  //�� �� �� ����� ����� ��� ������������
  bool TickWithRestart( float deltaTime )
  {
    if ( IsInProgress() )
      return TickWithRestartNonStop( deltaTime );

    return false;
  }

  //���������� ������� TickWithRestart, �� ������� ����� ��� ������ 
  //������ ��� �������. ��������� ����� �������� �������.
  bool TickWithRestartNonStop( float deltaTime )
  {
    ASSERT( IsInProgress() );

    curTime -= deltaTime;

    if ( curTime <= 0 ) 
    { 
      //��� ��������� �������� ��������� �����, ���������� � �������� ������������
      curTime += totalTime;      
      return true;
    }

    return false;
  }

private:
  float curTime;   
  float totalTime;     
};

//������� ������� ������ � ������ ������ ������� �� ������������ � ���������
inline float GetPercentProgress( const SimpleTimer &t )
{
  return (t.GetTotalTime() - t.GetTimeToAlarm()) * 100 / t.GetTotalTime(); 
}
