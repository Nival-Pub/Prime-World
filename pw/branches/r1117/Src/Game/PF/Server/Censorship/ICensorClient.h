#ifndef ICENSORCLIENT_H_INCLUDED
#define ICENSORCLIENT_H_INCLUDED

#include "System/EnumToString.h"
#include "System/Pointers/Pointers.h"

namespace censorship
{

typedef long long TRequestId;
typedef long long TAuxId;



namespace ECheckResult
{
  enum Enum
  {
    Clean,      //��������� ������������ �� ����������
    Dirty,      //� ������ ���� ������� ������������ �����
    SvcFailure  //����� ������� (������ �����, ���������� web-service)
  };

  NI_ENUM_DECL_STD;
}


// ����� ���� ������ ������������ ��������� ��������
// ������ ���������� ������ �� ��������� ������
// ���� "_filteredText" ������ �������� ���������� �����, ���� ���� _result=ECheckResult::Clean
class ICensorClientCallback : public IBaseInterfaceMT
{
  NI_DECLARE_CLASS_1( ICensorClientCallback, IBaseInterfaceMT );

public:
  virtual void TextCheckResult( TRequestId _reqId, TAuxId _auxId, ECheckResult::Enum _result, const wstring & _filteredText ) = 0;
};



class ICensorClient : public IBaseInterfaceMT
{
  NI_DECLARE_CLASS_1( ICensorClientCallback, IBaseInterfaceMT );

public:
  // ���������� ������ �� �������� ������
  // ���������� id �������.
  // ���� ����� ������ 0, �� ������ ���������� (������ �����, ����������). � ����� ������ ������ �� ����� ������.
  // ����������� �� ����� ������� ����� ���������, �������� � 0 �������� "censor_queue_limit"
  // ������ �������� �� ������ ������
  // ������ � �������� ����� �������� ���� 64������ ���������������� ��������
  virtual TRequestId Check( TAuxId _auxId, ICensorClientCallback * _callback, const wstring & _text ) = 0;

  // ����������� ���� �������. ������ �� ���� ����� ���������� ��� �������.
  // WARNING: ���� ����� �������� Poll ����� ���������� ����� ����� ��������, �� ����� �������� ����� ��������� ��� ������ ��������.
  // ����������� �� ����� ������� ����� ���������, �������� � 0 �������� "censor_out_queue_limit"
  virtual void Poll() = 0;
};


ICensorClient * CreateClient();

} //namespace censorship

#endif //ICENSORCLIENT_H_INCLUDED
