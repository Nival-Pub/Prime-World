------------------------------------------------------------------------------------------------------
-- Mission2.lua 
------------------------------------------------------------------------------------------------------
include ("GameLogic/Scripts/Debug.lua")
include ("GameLogic/Scripts/StatesManager.lua")
include ("GameLogic/Scripts/Common.lua")

-- ����� ���, ��� ������ �������� ������� ����������� ����� ��� ��� ��������
function Init()
	LuaDebugTrace ("Mission2")
	-- ������ �� ������ ������, � ������ ���� ������� ������ ������. ������ ���� ������ ���� � ��� �������.
	LuaGroupHide ("Mission1", true)
	--LuaGroupHide ("Mission2", false)
	LuaDebugTrace ("Mission2True")
end
