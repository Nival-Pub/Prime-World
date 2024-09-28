include ("GameLogic/Scripts/Debug.lua")
include ("GameLogic/Scripts/StatesManager.lua")
include ("GameLogic/Scripts/Common.lua")
include ("GameLogic/Scripts/Consts.lua")

LuaDebugTrace( "PvPMod4.lua launched!" )

function Init( reconnecting )
	if not reconnecting then
		LuaApplyPassiveAbility ("MainBuildingA", "MainBuildingBuff") -- ������� ������ ��
		LuaApplyPassiveAbility ("MainBuildingB", "MainBuildingBuff")
		
		for team = 0, 1 do
			for hero = 0, 4 do
				currentHero = tostring(team) .. tostring(hero)
				LuaHeroTakeConsumable ( currentHero, "NaftaPotion2000" ) -- �������� � dictionary 
				LuaHeroTakeConsumable ( currentHero, "RemoveCooldown" ) -- �������� � dictionary 
			end
		end
				
	end
end