#include "stdafx.h"

// NOTE: ��� ����� � ������� ���������� ������� ����� �������, ����� ����������� (linker) ����������� �� � ��������� �������.
// ��� workaround ������ � ����� StarForce: ���������� �� ���������, ���� � ������ � ���������� ����� ��� ������������ �������.
// �� ������������ StarForce

#ifdef STARFORCE_PROTECTED

#include <System/StarForce/StarForce.h>

#pragma code_seg(push, "~")
STARFORCE_EXPORT void zzz()
{
  /* placeholder */
}
#pragma code_seg(pop)

#endif
