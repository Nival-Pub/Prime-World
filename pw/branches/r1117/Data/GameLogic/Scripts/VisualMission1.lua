------------------------------------------------------------------------------------------------------
-- Mission1.lua 
------------------------------------------------------------------------------------------------------
include ("GameLogic/Scripts/Debug.lua")
include ("GameLogic/Scripts/StatesManager.lua")
include ("GameLogic/Scripts/Common.lua")

-- ����� ���, ��� ������ �������� ������� ����������� ����� ��� ��� ��������
function Init()
	LuaDebugTrace ("Mission1")
	-- ������ �� ������ ������, � ������ ���� ������� ������ ������. ������ ���� ������ ���� � ��� �������.
	LuaGroupHide ("Mission2", true)
	--LuaGroupHide ("Mission1", false)
	LuaDebugTrace ("Mission1True")
end
