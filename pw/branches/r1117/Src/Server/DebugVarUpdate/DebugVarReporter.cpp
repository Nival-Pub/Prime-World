#include "stdafx.h"
#include "DebugVarReporter.h"
#include "LDebugVarReporter.auto.h" // ��������� ������� ��� factory::Register

#include "System/DebugVar.h"
#include "System/Commands.h"
#include "System/StringDumper.h"

namespace NDebug
{

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DebugVarReporter::DebugVarReporter()
{
  LOG_D(0) << "remote CREATE DebugVarReporter";
}

DebugVarReporter::DebugVarReporter( rpc::GateKeeper *gateKeeper, const char* serviceName ) 
{ 
  LOG_D(0) << "CREATE DebugVarReporter( gateKeeper=" << gateKeeper << " service='" << serviceName << "' )";
  RegisterObject( gateKeeper, serviceName ) ; 
}

DebugVarReporter::~DebugVarReporter()
{
  LOG_D(0) << "~DebugVarReporter";
}


// ���� ����� ���������������� ������� ������� ��������� (����. �� ��� �������� ��� ����� ������ ������),
// ������������ ������� ������ ����� ���� RegisterObject()
void DebugVarReporter::RegisterObject( rpc::GateKeeper *gateKeeper, const char* serviceName )
{
  if ( gateKeeper )
  {
    nstl::string name ( serviceName );
    name += VarPathSuffix;
    gateKeeper->GetGate()->RegisterObject<DebugVarReporter>( this, name.c_str() );
  }
}

// ���� �� ����� ��������� �������� ����������, � ����� ��������� ��� �� ������ � remote �������, 
//  ����� ���������������� ���� ������� �������� ����� (���������� ����� ����� �������� gatekeeper � factory)
void DebugVarReporter::AttachTo( rpc::LocalEntityFactory* factory )
{
  if ( factory )
    factory->Register<DebugVarReporter, LDebugVarReporter>();

  // ��. � ������� ��� �������: factory_->RegisterAttach<DebugVarUpdater, LDebugVarUpdater>(); 
  //  RegisterAttach �� ����� ��������� ������, ��� ��� ����� �������� (��� ����������� ����� RegisterObject?)
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
const wchar_t* DebugVarReporter::GetDebugVar(const wstring& sVarName) 
{
  LOG_M(0) << "GetDebugVar(" << sVarName << ")";

  NStr::SWPrintf(buf, 128, L"%ls|", sVarName.c_str()); // ����� �������� ��� ���������� (� ����� ������ ��������)
  int nextPos = sVarName.size()+1;
  
  IDebugVar* var = FindDebugVar( sVarName.c_str() );
  if ( var )
  {
    var->FormatValue(buf + nextPos, 128);
  }
  else
  {
    NStr::WCopy(L"NIL", buf + nextPos, 128); // ���� ��� ����� ����������, ������ �������� "NIL"
  }

  return buf;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
const wchar_t* DebugVarReporter::RunRemoteCommand(const wstring& cmdline) 
{
  LOG_M(0) << "RunRemoteCommand(" << cmdline << ")";

  // �������� ����������� ���: ������ ����������� string dumper, ����� �������� �� ��� ����� �������� � ��� � ����� �� ���� �������
  char cbuf[1024] = "";
  StrongMT<NLogg::CStringDumper> strDumper = new NLogg::CStringDumper( &GetSystemLog(), cbuf, sizeof(cbuf) );

  bool res = NGlobal::RunCommand( cmdline.c_str() );

  // � ����� ��������� ���� ����� ������ (�������, ���� ����� ��� ��� ����� ������ ������� "����� ���-�������", �� ��������)
  GetSystemLog().RemoveDumper( strDumper );

  int written = NStr::SWPrintf(buf, sizeof(buf), L"%ls|%d|", cmdline.c_str(), res);
  NStr::ConvertToWString(cbuf, buf+written, sizeof(buf)-written); // �������� ����� | ����� | ��� ��� �������� � ��� (�������� �� ~1000 ��������)

  return buf;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// unit-TEST vars
DebugVar<int> __var1("DebugVarReport1", ""); 
PerformanceDebugVar __var2("DebugVarReport2", "", 8, 1000.0, false); 

DebugVar<int> __var3("DebugVarMMC1", ""); 
PerformanceDebugVar __var4("DebugVarMMC2", "", 8, 1000.0, false); 

} // namespace NDebug
