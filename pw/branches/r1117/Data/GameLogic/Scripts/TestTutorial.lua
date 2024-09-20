------------------------------------------------------------------------------------------------------
-- TestTutorial.lua 
-- used for CxxTest
-- DO NOT MODIFY!
------------------------------------------------------------------------------------------------------
include ("GameLogic/Scripts/Debug.lua")
include ("GameLogic/Scripts/StatesManager.lua")
include ("GameLogic/Scripts/Common.lua")

-- ����� ���, ��� ������ �������� ������� ����������� ����� ��� ��� ��������
function Init()
	LuaDebugTrace ("��� ���������")
	-- ������ �� ������ ������, � ������ ���� ������� ������ ������. ������ ���� ������ ���� � ��� �������.
	LuaGroupHide ("TutorialMission2", true)
	-- ������ �������
	LuaCreatureHide ("01", true)
	-- ��������� ��������� ��������
	LuaSetSpawnCreeps (false)
	LuaDebugTrace ("Init ����������")
	AddStateEnd (Step1, "local")
	-- AddStateTop (HeroPositionValidate( hero , 114, 126, 15 ) -- ���� ����� ����� �������� � ��������� ���������� 
end

-- Adds wait state on the top and calls sleep for the parent state
function Wait( t )
	AddStateTop( WaitState, t )
	SleepState()
end

function HeroPositionValidateState( hero, x, y, accuracy )	
	while true do
		local hx, hy = LuaHeroGetPosition( hero )
		if ( math.abs( x - hx ) <= accuracy and math.abs( y - hy ) <= accuracy ) then
			LuaDebugTrace( "Point reached! Hero position: " .. hx .. ":" .. hy )
			LuaMessageToChat( "Checkpoint!" )
			return
		end
		SleepState()
	end
end

function HeroPositionValidate( hero, x, y, accuracy )
	AddStateTop( HeroPositionValidateState, hero, x, y, accuracy  )
	SleepState()
end

function CameraMoveAndBackState( x, y ) -- ������� �� ����������� ������
	LuaHeroAddFlag ("local", ForbidPlayerControl)
	LuaCameraLock (true)
	LuaDebugTrace ("����������� ������������ �����")

	Wait( 1 ) -- ����������� �� ��������
	LuaDebugTrace ("������ ������ ���� ��������")

	LuaCameraMoveToPosTimed( x, y, 2 ) -- 2 ����� �������� ������	

	Wait( 4 ) -- ����������� �� ��������, ��������� ����� ����������� ������ � �����
	LuaDebugTrace ("������������ � ������ ����������")

	LuaCameraMoveToUnit ("local")
	LuaHeroRemoveFlag ("local", ForbidPlayerControl)
	LuaCameraLock (false)
	LuaMessageToChat("� ��� ������� ���������� �������, �������� ���.") 
end

function CameraMoveAndBack( x, y )
	AddStateTop( CameraMoveAndBackState, x, y )
	SleepState()
end

function Step1 (hero)
	-- ���������� ������� � ������ ��� �����
	LuaCreatureTeleportTo( "01", 120, 123 ) -- ���������� ����������
	LuaMessageToChat( "������������ ��� � ���� PrimeWorld" )

	CameraMoveAndBack( 120, 123 )

	HeroPositionValidate( "local", 114, 126, 15 ) -- ����������� � ������������ � �����������

	LuaHeroAddFlag ("local", ForbidPlayerControl)
	LuaHeroAddFlag ("local", ForbidMove)
	LuaHeroAddFlag ("local", ForbidAttack)
	LuaHeroAddFlag ("local", ForbidTakeDamage)

	CameraMoveAndBack( 120, 123 ) -- ����������� � ������������
	LuaDebugTrace ("������ ����������� � ������ �����")
	
	LuaCreatureHide ("01", false)
	-- ������� ������ � ��������� ������
	LuaSpawnerSpawnWave ("SoldersA")
	LuaSpawnerSpawnWave ("SoldersB")
	Wait( 2 ) -- ����������� �� ��������, �� ��������� ������

	LuaMessageToChat("������� - ������! � �����!")
	-- ���������� �� ��������� ���� ����� (�� 4-�), ��� ��� ������ �� �����
	LuaCreatureMoveTo ("SolderA_w1_c1", 124, 126, 4)
	LuaCreatureMoveTo ("SolderA_w1_c2", 128, 127, 4)
	LuaCreatureMoveTo ("SolderB_w1_c1", 124, 126, 4)
	LuaCreatureMoveTo ("SolderB_w1_c2", 128, 127, 4)
	
	Wait( 1 ) -- ����������� �� ��������, �� ��������� ������

	-- ���������� ������� ��������� ������
	LuaDebugTrace("������� ������� ������")
	LuaCreatureMoveTo ("01", 124, 126, 2)
	LuaHeroRemoveFlag ("local", ForbidPlayerControl)
	LuaHeroRemoveFlag ("local", ForbidMove)
	LuaHeroRemoveFlag ("local", ForbidAttack)
	LuaHeroRemoveFlag ("local", ForbidTakeDamage)
	LuaSetSpawnCreeps (true)
end
