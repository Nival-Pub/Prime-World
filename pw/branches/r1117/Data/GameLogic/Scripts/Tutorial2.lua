-- Tutorial Mission 2 script v.05 (by Grey)
 -- ������� ���������� ��������� �� �����
 -- � ������ ����� ������ "M2_", � ����� ���� ���� "_D"/"_A", ������� ��������� �� ��, � ���� ������ ������� ������������ �������
 -- M2_Flag1_B, M2_Flag1_�, M2_FlagMiddle - �����
 -- M2_Point1_Middle - ������ � �����, ������ 17
 -- M2_EnemyHero1_A, M2_EnemyHero1_D - ����� ������ 1�� ���������� �����
 -- M2_Shop_D, M2_Shop_A - ��������
 

include ("GameLogic/Scripts/Debug.lua")
include ("GameLogic/Scripts/StatesManager.lua")
include ("GameLogic/Scripts/Common.lua")
include ("GameLogic/Scripts/Consts.lua")

M_PI2 = 1.57

function Init() --��������� �������� ������� � ������
    --������ ����� ����� ���������!!!

	LuaGroupHide( "Mission1", true )
	LuaSetSpawnCreeps( false )
	--LuaCreatureHide( "01", true ) -- hide another ally hero
	AddStateEnd( BeginSpawnCreeps )
	
	rotateTime = 0.7
	rotateTimeTunder = 0.5 -- c���������� ����� ��������� �����, ���� ����� = ����
	creepCap = 14 -- ����� �� ���-�� ������ 
	debugModeOn = false
	debug1Intro = false -- ������ ���������
	debug2Intro = false -- ������ ���������
	debug1Jaba = false -- ����� � �����
	debug1AllyHeal = false -- ����� � ��������� ���������
	debug1BuyPotion = false -- ������ ������ ������
	debugTerrainOn = false -- ��� ��� �����
	debugMidPointFight = false -- ��� � ������������ �����
	debugRatCatcherDead = true -- �������� ���������
	debugTalentsBuy = false -- ��� ��� ������� ��������
	debugFirstTowerScene = false -- ������������ ��� ����� � ���� ��������
	debugFirstFightVsHero = true -- �������� ���� ������
	debugSecondFightVsHero = true -- �������� �������� �����
	LuaEnableEventLogging (true)
--	StartTrigger( Obj7_CheckFlagIsRising )
	-- ��� ������� �������, ����� �� ������ ������ ������ �� ���������
	--LuaGroupHide( "TM1_BlockAreaCentral", false )
end  

function BeginSpawnCreeps ( some ) -- ������� ������ ������ �������� �����
	LuaDebugTrace ("   ------ ������� ������ ������ �������� ����� (��� ������ �������� ���� ���) ")
-- ��������� ���������� � ����������� �� ������� ������
	-- select by player faction
	FACTION_PLAYER = LuaGetLocalFaction()
	FACTION_ENEMY = 3 - FACTION_PLAYER
	local function selectByFaction( a, b )
		if ( FACTION_PLAYER == 1 ) then
			return a
		else
			return b
		end
	end	

	local function generateCreepNames( name, wave, count )
		local arr = {}
		for i = 1, count do
			arr[i] = name .. "_w" .. wave .. "_c" .. i
		end
		return arr
	end
	
	local function FlagIsLocal ( line, flagNumber ) -- ������� ��������, ��� ��������� ���� ����������� ������� ������
		if LuaFlagGetFaction( line, flagNumber) == LuaGetLocalFaction() then
			LuaDebugTrace("DEBUG: ���� ���� ����������� ������!")
			return true
		end
		return false
	end
-- �����

if true then-- ���� ����������, ����������� �����, ������ ���� ������.
	LuaSetAchievmentsEnabled( false )

    LuaDebugTrace( "DEBUG: ���� ����������" )
	ALLY_HERO = selectByFaction( "02", "12" )
	ALLY_HERO_1 = selectByFaction( "01", "11" )
	ENEMY_HERO_1 = selectByFaction( "10", "00" )
	ENEMY_HERO_2 = selectByFaction( "11", "01" )
	ENEMY_HERO_3 = selectByFaction( "12", "02" )
	ENEMY_TOWER_1 = selectByFaction( "TowerB1_m2", "TowerA1_m2" )
	ENEMY_TOWER_2 = selectByFaction( "TowerB2_m2", "TowerA2_m2" )
	ALLY_TOWER_1 = selectByFaction( "TowerA1_m2", "TowerB1_m2" )
	ALLY_TOWER_2 = selectByFaction( "TowerB1_m2", "TowerA1_m2" )
	ENEMY_BARRACKS = selectByFaction( "BarracksB_m2", "BarracksA_m2" )
	ENEMY_BARRACKS2 = selectByFaction( "BarrackB2", "BarrackA2" )
	ALLY_BARRACKS2 = selectByFaction( "BarrackA2", "BarrackB2" )
	ALLY_MAINBUILDING = selectByFaction( "MainA" , "MainB" )
	ALLY_MAIN_SPAWNER = selectByFaction( "CreepsA", "CreepsB" )
	ENEMY_MAIN_SPAWNER = selectByFaction( "CreepsB", "CreepsA" )	
	ENEMY_MAINBUILDING = selectByFaction( "MainB", "MainA" )
	ENEMY_CREEP_MELEE = selectByFaction( "CreepMeleeB", "CreepMeleeA" )
	ENEMY_CREEP_RANGED = selectByFaction( "CreepRangeB", "CreepRangeA" )
	ENEMY_CREEP_SIEGE = selectByFaction( "CreepSiegeB", "CreepSiegeA" )
	ALLY_CREEP_SIEGE = selectByFaction( "CreepSiegeA", "CreepSiegeB" )
	ALLY_Secondery_LockTiles = selectByFaction( "TM1_BlockArea1_D", "TM1_BlockArea1_A" )
	ENEMY_Secondery_LockTiles = selectByFaction( "TM1_BlockArea1_A", "TM1_BlockArea1_D" )
	ENEMY_HERO_TOWER = selectByFaction( "EnemyHeroMoveB_m2", "EnemyHeroMoveA_m2" )

-- ������ ���� � ����, ���� ������ ������
	LuaCreatureHide( ALLY_HERO_1, true ) 
	LuaCreatureHide( ALLY_HERO, true ) -- ������ �������� ������
	LuaCreatureHide( ENEMY_HERO_2, true )
-- �����

	allyShop = selectByFaction ( "M2_Shop_D", "M2_Shop_A" )
	-- ����������� ��� �������
		KillEnemyRatcatcher = selectByFaction("TM2_Q23as", "TM2_Q23ds")
		KillEnemyFrog = selectByFaction("TM2_Q02as", "TM2_Q02ds")
		KillSiege = selectByFaction("TM2_Q35as", "TM2_Q35ds")
		KillEnemyRockman = selectByFaction("TM2_Q36ds", "TM2_Q36as")
		QuestMainbuilding = selectByFaction("TM2_Q34dp", "TM2_Q34ap")
	-- �����
	_FlagToMark = selectByFaction ("M2_Flag1_A", "M2_Flag1_B")
	_FlagEnemy = selectByFaction ("M2_Flag1_B", "M2_Flag1_A")
	FlagPosition = GetScriptArea( selectByFaction ("M2_FirstFlagPostion_A", "M2_FirstFlagPostion_B") )
--	enemyHero1_Pos = GetScriptArea( selectByFaction( "M2_EnemyHero1_D", "M2_EnemyHero1_A" ) )  
	LuaDebugTrace( "DEBUG: ����� ���� ����������" )

	LuaSetUnitStat( "FountainA", 2, 0 )
	LuaSetUnitStat( "FountainB", 2, 0 )
	LuaSetUnitStat( "TowerA1_m2", 0, 1200 )
	LuaSetUnitStat( "TowerB1_m2", 0, 1200 )
	LuaSetUnitStat( "TowerA2_m2", 0, 2000 )
	LuaSetUnitStat( "TowerB2_m2", 0, 2000 )
	LuaSetUnitStat( "BarracksB_m2", 0, 1000 )
	LuaSetUnitStat( "BarracksA_m2", 0, 1000 )
	LuaSetUnitStat( "MainA", 0, 2000 )
	LuaSetUnitStat( "MainB", 0, 2000 )
	
	-- ����������, ��� � ������ ���� ����� �� ����� �������
if not debugModeOn or debugRatCatcherDead then 
	heroesImmortal = true
	LuaUnitAddFlag( ALLY_HERO_1, ForbidDeath )
	LuaUnitAddFlag( "local", ForbidDeath )
	StartTrigger( UnitImmortalCheat, ALLY_HERO_1, 20)
	StartTrigger( UnitImmortalCheat, "local", 20)
end
	
	-- ���������� ����� ��� ������
	cinemaPos1 = GetScriptArea( selectByFaction( "RatCamB_m2", "RatCamA_m2" ) )
	cinemaPos2 = GetScriptArea( selectByFaction( "ObjectiveA2_m2", "ObjectiveB2_m2" ) )
	cinemaPos3 = GetScriptArea( selectByFaction( "HeroStartA1_m2", "HeroStartB1_m2" ) )
	Obj3Pos = GetScriptArea( selectByFaction( "M2_2EnemyHero1_A", "M2_2EnemyHero1_D" ) )
	Obj2Pos = GetScriptArea( selectByFaction( "M2_EnemyHero1_A", "M2_EnemyHero1_D" ) )
	Obj4Pos = GetScriptArea( selectByFaction( "AllyHeroMoveB_m2", "AllyHeroMoveA_m2" ) )
	cinemaPos4 = GetScriptArea( selectByFaction( "CinematicHeroA_m2", "CinematicHeroB_m2" ) )
	cinemaPos5 = GetScriptArea( selectByFaction( "CinematicAllyA_m2", "CinematicAllyB_m2" ) )
	cinemaPos6 = GetScriptArea( selectByFaction("HeroShopA_m2" , "HeroShopB_m2") )
	cinemaPos7 = GetScriptArea( selectByFaction( "TowerZone1_B_m2", "TowerZone1_A_m2" ) )
	cinemaPos8 = GetScriptArea( selectByFaction( "CinematicMainBuilding_A", "CinematicMainBuilding_B" ) )
	cinemaPos9 = GetScriptArea( selectByFaction( "M2_Flag1Check_A", "M2_Flag1Check_B" ) )
	cinemaPos10 = GetScriptArea( selectByFaction( "ObjectiveA3_m2", "ObjectiveB3_m2" ) )
	cinemaPos11 = GetScriptArea( selectByFaction( "M2_CamFlag1_A", "M2_CamFlag1_B") )
	cinemaPos12 = GetScriptArea( selectByFaction( "ObjectiveA3_m1", "ObjectiveB3_m1" ) ) -- ����� �������� ������ �� �������
	EnemyHeroMovePos = GetScriptArea( selectByFaction( "EnemyHeroMoveB_m2", "EnemyHeroMoveA_m2" ) )
	PointMiddle = GetScriptArea("M2_WaitHero")
	cinemaPos13 = GetScriptArea( selectByFaction( "CinematicHero3B2_m2", "CinematicHero3A2_m2") )
	cinemaPos14 = GetScriptArea( selectByFaction( "CinematicHero1B2_m2", "CinematicHero1A2_m2") )
	cinemaPos15 = GetScriptArea( selectByFaction( "FountainBCinema_m2", "FountainACinema_m2") )
	enemyHeroMove = GetScriptArea( selectByFaction( "NearArsenalB_m2", "NearArsenalA_m2" ) )
	cinemaPos16 = GetScriptArea( selectByFaction( "RatWaitPointB_m2", "RatWaitPointA_m2" ) )

	-- ������ �������� �� ������� ����� ����� ���������� � ������
	LuaShowUIBlock( "ChatBlock", false )
	LuaShowUIBlock( "ActionBarInventoryBtn", false )
	LuaShowUIBlock( "ActionBarSocialBtn", false )
	LuaShowUIBlock( "ActionBarStatisticBtn", false )
	LuaShowUIBlock( "FriendlyTeamMateBlock", false )
	LuaShowUIBlock( "EnemyTeamMateBlock", false )
	LuaShowUIBlock( "PortalBtn", false )
	LuaShowUIBlock( "LockActionBar", false )
	LuaGroupHide( ALLY_Secondery_LockTiles, true ) -- ��������� ������ ���� � ������� �����

	
	if not debugModeOn or debug1Intro then -- ������ ���������. � ��������� �������
		LuaUnitAddFlag (ALLY_TOWER_1, ForbidPick) 
		LuaUnitAddFlag ("local", ForbidPick)
		LuaUnitAddFlag (ALLY_BARRACKS2, ForbidPick) 
		LuaCameraLock (false)
		LuaCameraObserveUnit( "local" )
		cameraName = selectByFaction( "/Maps/Tutorial/cameraA2_1.CSPL", "/Maps/Tutorial/cameraB2_1.CSPL" )
		cameraTime = 20
		NeedToPauseAfterPhrases("D33_p3","D33_p4")
		StartCinematic ("TM2_D33") -- ����������� � �����
		LuaSplineCameraTimed (cameraName, cameraTime)
		LuaDebugTrace( "DEBUG: TeleportTo 215!") 
		
		LuaCreatureTeleportTo( "local", cinemaPos3.x, cinemaPos3.y )	
	
		if not debugModeOn or debug1Jaba then -- ��������� "������ ���� �� �����"
			AddSetPrime( "local", 0)
			LuaSetUnitHealth( ALLY_HERO_1, 250 )
			LuaSetUnitStat( ALLY_HERO_1, 3, 50 )
			LuaSetUnitStat( ENEMY_HERO_2, 3, 50 )
			LuaSetUnitHealth( ENEMY_HERO_2, 800 )
			LuaHeroActivateTalent (ENEMY_HERO_2, 2, 0, true)
			allyHeroPos = GetScriptArea( selectByFaction( "AllyHeroMoveA_m2", "AllyHeroMoveB_m2" ) )
			frogStartPos = GetScriptArea( selectByFaction( "EnemyHeroMoveA_m2", "EnemyHeroMoveB_m2" ) )
			LuaCreatureTeleportTo( ALLY_HERO_1, allyHeroPos.x, allyHeroPos.y ) -- objective 3
			LuaCreatureTeleportTo( ENEMY_HERO_2, frogStartPos.x, frogStartPos.y )
		end
		
		WaitForPhraseEnd( "D33_p3" )
		LuaDebugTrace( "DEBUG: ���� D33_p3")
		LuaPauseDialog( true )
		LuaDebugTrace( "DEBUG: �������� �����������!") 
		RemoveWarfogAll( false )
		LuaCameraLock (true)
--		LuaCameraObserveUnit( "local" )
		LuaUnitRemoveFlag (ALLY_TOWER_1, ForbidPick) 
		LuaUnitRemoveFlag ("local", ForbidPick)
		LuaUnitRemoveFlag (ALLY_BARRACKS2, ForbidPick)
	end	
 
if debugModeOn or debug1Intro then 	
	RemoveWarfogAll( true )	-- ������ ������ ����� ������
end
		-- set sight ranges
	if ( FACTION_PLAYER == 1 ) then -- ������������ � ��������
		LuaSetUnitStat( "BarracksA_m1", 14, 6 )
		LuaSetUnitStat( "TowerA1_m1",   14, 10 )
		LuaSetUnitStat( "MainA",        14, 33 )
		LuaSetUnitStat( "FountainA",    14, 20 )
		LuaSetUnitStat( "local",        14, 15 )
		LuaDirectionHintSet( "DirectionHintMtrl", 4, 2, 0 )
	else
		LuaSetUnitStat( "BarracksB_m1", 14, 6 )
		LuaSetUnitStat( "TowerB1_m1",   14, 10 )
		LuaSetUnitStat( "MainB",        14, 33 )
		LuaSetUnitStat( "FountainB",    14, 20 )
		LuaSetUnitStat( "local",        14, 15 )
		LuaDirectionHintSet( "DirectionHintMtrl", 4, 2, 0 )
	end
	
	
if LuaIsHeroMale("local") then  -- � ����������� �� ���� ������ ���������� �������� ������
	LuaLoadTalantSet( "local", "TM2_Tunder_Set" )
	LuaDebugTrace( "DEBUG: ����������, � ��� �������!") 
	HeroGenderQuest = "TM2_Q03ms"
	HeroGender = "TM2_D02_0_M"
	HeroGenderHint = "TM2_D02_1_M"
	SaveHeroQuest = selectByFaction( "TM2_Q01m_B", "TM2_Q01m_A" )
	LuaSetUnitStat( "local", 15, 80 )
	LuaSetUnitStat( "local", 16, 70 )
else
	LuaLoadTalantSet( "local", "TM2_Firefox_Set" )
	LuaDebugTrace( "DEBUG: ����������, � ��� �������!") 
	HeroGenderQuest = "TM2_Q03fs"
	HeroGender = "TM2_D02_0_F"
	HeroGenderHint = "TM2_D02_1_F"
	SaveHeroQuest = selectByFaction( "TM2_Q01f_B", "TM2_Q01f_A" )
	LuaSetUnitStat( "local", 15, 70 )
	LuaSetUnitStat( "local", 16, 80 )
end
	
	LuaDebugTrace( "DEBUG: TeleportTo 175!") 
	LuaUnitAddFlag( ENEMY_TOWER_1, ForbidTakeDamage ) -- ������ ����� ������ ����������

if not debugModeOn or debugRatCatcherDead then	
	LuaUnitAddFlag( ENEMY_HERO_1, ForbidTakeDamage ) -- ���� �� ����� �� ��������, ����� ��� ������ � �� ������ �� ����
	LuaUnitAddFlag( ENEMY_HERO_1, ForbidAutoAttack )
end
	
if not debugModeOn or debugTerrainOn then
	LuaUnitAddFlag("local", ForbidInteract ) -- ������ ������� ������ ����, ���� �� �� ��������� ��� ����
end
	genderLevel, genderColumn = FindGender( ALLY_HERO_1 )
end		
	LuaBlockActionBarChange(true) -- � ��������� �������� ������������ ������� �� ����-���� (��� ������� ��)

-- ����� ����� ����������

	if LuaHeroIsTalentActivated("local", 0, 0) == false then -- �������� ������ �1 ������
		LuaHeroActivateTalent("local", 0, 0, false)
	end		

	StartTrigger( OnlyPlayerCanKillAtThisPoint, ALLY_TOWER_1, 35 )
	checkGender=true -- ����� ������� �� ������� ���� ������
	BlockAreaCentral = GetScriptArea ("TM1_BlockAreaCentral")
	StartTrigger( ForbidZone, BlockAreaCentral )
	StartTrigger( DrinkPotion, 50 ) -- ���������, ����� ����� ����� ���� �� ��� ������
	StartTrigger( MyHeroDead, "local" )
	-- ��������� ��������, ����� ����� ����� � ������ ��� ��, ��� � ��.
	StartTrigger(HeroesLevelUp,"local",ENEMY_HERO_1, 0)
	StartTrigger(HeroesLevelUp,"local",ENEMY_HERO_2, 0)
if not debugModeOn or debugMidPointFight then 
	HeroesLevelUp_ENEMY_HERO_3_8Levels = StartTrigger(HeroesLevelUp,"local",ENEMY_HERO_3, 4)
end	
	
	if debugModeOn and debug1Intro and not debug1Jaba then 
		EndCinematic ()
	end
	
	LuaCreatureHide( ALLY_HERO_1, false ) 
	LuaCreatureHide( ENEMY_HERO_2, false )
	
if not debugModeOn or debug1Jaba then	
	LuaAddSessionQuest( SaveHeroQuest )
	LuaCreatureMoveTo( ALLY_HERO_1, cinemaPos2.x, cinemaPos2.y, 2 )
	Wait (0.3) -- ��������, ����� ������� ������ ��������
	LuaCreatureMoveTo( ENEMY_HERO_2, cinemaPos2.x, cinemaPos2.y, 2 )
	LuaDebugTrace( "DEBUG: TeleportTo 222!") 
	LuaUnitAddFlag(ENEMY_HERO_2, ForbidAutotargetMe ) -- ����� ����� �� ���� �� ���� �������
	-- ��������� ����� �����
		LuaUnitAddFlag( "local", ForbidAutoAttack )
		WaitForHeroNearUnit( "local", ALLY_HERO_1, selectByFaction(25,25) )
		LuaPauseDialog( false )
		LuaDebugTrace( "DEBUG: ���� D33_p4")
		WaitForPhraseEnd( "D33_p4" )
		LuaPauseDialog( true )
		WaitForUnitInArea( ENEMY_HERO_2, cinemaPos2.x, cinemaPos2.y, selectByFaction(13,11) ) -- ����, ����� ������� �������� � ������ �����, ����� ��������� �� �������
		LuaPauseDialog( false )
		EndCinematic ()  --add by Grey
		RotateHeroTo( "local", cinemaPos2)
		forFrogPlace = {}
		forFrogPlace.x, forFrogPlace.y = LuaHeroGetPosition( ALLY_HERO_1 ) -- ���������� ���������� �������� �� ���� ������
		LuaHeroUseTalentPos (ENEMY_HERO_2, 2, 0, selectByFaction(forFrogPlace.x+2.5,forFrogPlace.x-2.5), selectByFaction(forFrogPlace.y+1,forFrogPlace.y+1.5)) -- ������ �� ��������
		LuaDebugTrace( "DEBUG: TeleportTo 232!") 

		
		--BuyGender () -- ������� ��� ������� �������
		LuaHeroRemoveFlag( "local", ForbidAutoAttack )
		LuaHeroRemoveFlag(ENEMY_HERO_2, ForbidAutotargetMe )
		LuaShowUIBlock( "ImpulseTalent", false )
		AddSetPrime( "local", 250)
		AddSetPrime( ALLY_HERO_1, 0)
		WaitState (0.7) -- �����, ����� ���� ������ ������������
		LuaUnitAttackUnit(ENEMY_HERO_2, ALLY_HERO_1) -- ����� ���������� ���� ��������� ��������
		LuaCameraLock (true)
		localPlace = {}
		localPlace.x, localPlace.y = LuaHeroGetPosition ("local")
		CameraWaitPosition( localPlace.x , localPlace.y , 1)
		LuaDebugTrace( "DEBUG: TeleportTo 239!") 
		LuaCameraLock (false)
		LuaCameraObserveUnit ("local")
	-- ����� ����� ������
-- �����


if true then -- ����, ��� ���� �����������
		LuaUnitAddFlag( "local", ForbidPlayerControl )
		LuaUnitClearStates ("local")
		LuaUnitClearStates (ENEMY_HERO_2)
		LuaUnitClearStates (ALLY_HERO_1)
--		LuaStartCinematic ( "TM2_D04" )
		ConstructWaitConditionState (HelthDownPercent, ENEMY_HERO_2, 60)
		NeedToPauseAfterPhrases("D06_p2", "D06_p3")
		StartCinematic ( "TM2_D06" )
		LuaHeroRemoveFlag( "local", ForbidPlayerControl )
end	-- ����� ����
	
	LuaPauseDialog( true )
	LuaDebugTrace( "DEBUG: ���� ���� ������� �����" )
	WaitForUnitsDead( ENEMY_HERO_2 )
	LuaPauseDialog( false )
	AddSetPrime( "local", 70)
	AddSetPrime( ALLY_HERO_1, 0)
	WaitForPhraseEnd( "D06_p1" )
	LuaCameraObserveUnit ("")
	WaitState (1.5) -- ���� ���� ���������� �������� ������ �������
-- ����� �����
end

if not debugModeOn or debug1AllyHeal then	
-- ��������� "������� �������� �������"
		allyHeroMove = GetScriptArea( selectByFaction( "ObjectiveA4_m2", "ObjectiveB3_m1" ) )
		LuaCameraLock (true)
		LuaCameraObserveUnit( "" )	
		LuaCameraMoveToPosTimed ( cinemaPos10.x, cinemaPos10.y , 3)
		LuaCreatureMoveTo( "local", cinemaPos6.x, cinemaPos6.y, 1 )
		LuaCreatureMoveTo( ALLY_HERO_1, x, y, 1 )
		WaitForUnitInArea( ALLY_HERO_1, allyHeroMove.x, allyHeroMove.y, 10 )
			WaitForPhraseEnd( "D06_p2" )	 
		 WaitForUnitInArea( "local", cinemaPos6.x, cinemaPos6.y, 1 )
		 RotateHeroTo ( "local", allyHeroMove)
			LuaPauseDialog( false )
			WaitForPhraseEnd( "D06_p3" )
		 LuaCreatureHide( ENEMY_HERO_2, true )
		 WaitForUnitInArea( ALLY_HERO_1, allyHeroMove.x, allyHeroMove.y, 1 )
		 RotateHeroTo ( ALLY_HERO_1, cinemaPos6)
		 LuaPauseDialog( false )
		x, y = LuaUnitGetPosition ("local")
	EndCinematic ()
	if isCameraLocked then
		LuaDebugTrace( "Debug: �� ���������� ���� isCameraLocked = "..tostring(isCameraLocked)..", � ���� ������ ���� ��������� ������")
		LuaCameraObserveUnit ("local")
	end
	LuaRemoveSessionQuest( SaveHeroQuest )
-- ����� ����������	
	
if not debugModeOn or debug1BuyPotion then -- Part 4: "���� ���� ����� �� ����� ���� ������ ������"
	LuaAddSessionQuest( selectByFaction("TM2_Q34dp", "TM2_Q34ap") )
	LuaUnitAddFlag( "local", ForbidMove)
	LuaDebugTrace( "DEBUG: ���� ������ ������!" )
	MarkEnemy( allyShop, true)
	LuaAddSessionQuest( "TM2_Q04s" ) -- ����������� � �����
	shopPos1 = {}
	shopPos1.x, shopPos1.y = LuaUnitGetPosition (allyShop)
	LuaSessionQuestUpdateSignal( "TM2_Q04s", "Q204_s1", shopPos1.x, shopPos1.y)
	StartTrigger( DoNotCloseShopUI ) -- ���/��� �������� ��� �������
--	HintBuyIt ()
	WaitForOpenUI (WINDOW_SHOPBAR)
		if LuaIsWindowVisible (WINDOW_TALENTSBAR) then 
			LuaShowUIBlock ("Talents", false)
			windowTalentsCloe = true
		end
		if LuaIsWindowVisible (WINDOW_CHARSTATBAR) then 
			LuaShowUIBlock ("CharStats", false)
			windowCharStat = true
		end
		if LuaIsWindowVisible (WINDOW_SELECTIONCHARSTAT) then 
			LuaShowUIBlock ("SelectionCharStats", false)
			windowSelectCharStat = true
		end 
		if LuaIsWindowVisible (WINDOW_SELECTIONTALANTBAR) then
			LuaShowUIBlock ("SelectionTalents", false)
			windowSelectTalents = true
		end
		LuaShowUIBlock ("TalentsSetBlock", false)
	ShowHintline("")
	GreyWaitEnd()
	LuaBeginBlockSection() 
		LuaAddNonBlockedElement( "ShopBar", true )
		LuaAddNonBlockedElement( "InventoryBar", true )
		LuaAddNonBlockedElement( "Hintline", true )
		LuaAddNonBlockedElement( "QuestTracker", true )
		-- ���� ��������� ������� � ���� ���������!!!
	LuaEndBlockSection( 0 )
	ShowBubble( "TM2_D04_1", "Shop", 0, 0) -- ����������� � �����
	LuaShowTutorialShopItemHighlight (0, true) -- ��������� ������� ��� �����
	ConstructWaitConditionState( LuaHeroHasConsumable, "local", "HealingPotion" )
	LuaShowTutorialShopItemHighlight (0, false ) 
	LuaDebugTrace( "DEBUG: �� ����� ���!" )
	MarkEnemy( allyShop, false)	
	LuaRemoveSessionQuest( "TM2_Q04s" )
	LuaShowUIBlock( "MoneyBlock", true )
	getSlotPotion = LuaGetInventoryItemActionBarIndex ("HealingPotion") 
	ShopTutorialOver = true
	LuaShowUIBlock( "ActionBarTalentBtn", true )
		LuaAddNonBlockedElement( "Hintline", true )
		LuaAddNonBlockedElementActionBar( getSlotPotion, true )
	ShowBubbleButton( "TM2_D04_2", "ActionBar", getSlotPotion) -- ����������� � �����
--	LuaShowTutorialActionBarItemHighlight (1, true) -- ��������� ������� ��� ����� � ActionBar-e
	WaitForBubbleClick()

	LogSessionEvent ("ActionBar agree to popup heal potion") -- ����������� � �����

	LuaShowUIBlock( "ActionBarInventoryBtn", true )
	LuaShowUIBlock( "ImpulseTalent", true )
--	LuaShowTutorialActionBarItemHighlight (1, false)
	if LuaIsWindowVisible( WINDOW_INVENTORYBAR )==true then -- ���� ���� ��������� �� ��� ��� �������
		LuaShowTutorialElementHighlight ("ActionBarInventoryBtn", true)
		LuaAddNonBlockedElement( "ActionBarInventoryBtn", true )
		ShowBubble( "TM2_D04_3", "ActionBarInventoryBtn")
		WaitForCloseUI ( WINDOW_INVENTORYBAR ) -- ���� ���� ����� �� ������� ���� ���������
		
		LogSessionEvent ("close inventorybar with heal potion") -- ����������� � �����
		
		LuaShowTutorialElementHighlight ("ActionBarInventoryBtn", false)
		HideLastBubble()
	end
	LuaClearBlocking( 0 )
	LuaUnitRemoveFlag( "local", ForbidMove)
		LuaShowUIBlock ("TalentsSetBlock", true)
		if windowTalentsCloe then
			LuaShowUIBlock ("Talents", true)
			windowTalentsCloe = false
		end
		if windowCharStat then 
			LuaShowUIBlock ("CharStats", true)
			windowCharStat = false
		end
		if windowSelectCharStat then 
			LuaShowUIBlock ("SelectionCharStats", true)
			windowSelectCharStat = false
		end
		if windowSelectTalents then
			LuaShowUIBlock ("SelectionTalents", true)
			windowSelectTalents = false
		end	
end
-- ����� ������� �� ������ ������
end


-- ���������� �������� ������ � ������
	StartTrigger(AllyLevelUp,"local",ALLY_HERO_1, 0, 2)
	LuaShowUIBlock( "FriendlyTeamMateBlock", true )
	StartTrigger(AllyHeroDead, ALLY_HERO_1)
	LuaDebugTrace( "DEBUG: ������ ������������ ������!" )
    Part2 = true	

if not debugModeOn or debug2Intro then -- ������ ���������. � ��������� �������	

	NeedToPauseAfterPhrases("D17_p1", "D17_p3")
	StartCinematic ( "TM2_D17" )
-- ���� � ���� �� ����� ���� � ��������, ����� ���������� �� ���� �����
--	ConstructWaitConditionState( LuaIsPhraseFinished, "D17_p1" )
	LuaCameraLock (false)
	LuaPauseDialog( true )
	if not isCameraLocked then
		LuaDebugTrace( "Debug: �� ���������� ���� isCameraLocked = "..tostring(isCameraLocked)..", � ���� ������ ���� ��������� ������")
		LuaCameraObserveUnit ("local")
	end
	LuaCreatureMoveTo( "local", cinemaPos4.x, cinemaPos4.y, 1 )
	LuaCreatureMoveTo( ALLY_HERO_1, cinemaPos5.x, cinemaPos5.y, 1 )
	LuaCreatureTeleportTo( ENEMY_HERO_3, cinemaPos13.x, cinemaPos13.y )
	LuaCreatureTeleportTo( ENEMY_HERO_1, cinemaPos14.x, cinemaPos14.y )
	RotateHeroTo ( ENEMY_HERO_3, ALLY_MAINBUILDING )
	RotateHeroTo ( ENEMY_HERO_1, ALLY_MAINBUILDING )
	Wait(rotateTime)
	WaitForUnitInArea( "local", cinemaPos4.x, cinemaPos4.y, 1 )
	WaitForUnitInArea( ALLY_HERO_1, cinemaPos5.x, cinemaPos5.y, 1 )
	RotateHeroTo ( "local", ENEMY_MAINBUILDING )
	RotateHeroTo ( ALLY_HERO_1, ENEMY_MAINBUILDING )
	Wait(rotateTime)
	LuaForceAnimation (ENEMY_HERO_3, "happy", 7)
	LuaForceAnimation (ENEMY_HERO_1, "happy", 7)
		if true then -- ����� ������ �� ������ ������ �������
			LuaUnitAddFlag (ALLY_TOWER_1, ForbidPick) 
			LuaUnitAddFlag ("local", ForbidPick)
			LuaUnitAddFlag (ALLY_HERO_1, ForbidPick)
			LuaUnitAddFlag (ALLY_HERO_1, ForbidTakeDamage) 
			LuaUnitAddFlag (ALLY_HERO_1, ForbidInteract)
			LuaUnitAddFlag (ENEMY_HERO_3, ForbidPick) 
			LuaUnitAddFlag (ENEMY_HERO_1, ForbidPick)
			LuaUnitAddFlag (ENEMY_BARRACKS2, ForbidTakeDamage) 
			LuaUnitAddFlag (ENEMY_BARRACKS2, ForbidInteract)
			LuaUnitAddFlag ("local", ForbidTakeDamage) 
			LuaUnitAddFlag ("local", ForbidInteract)
		end
		RemoveWarfogAll( true ) 
--		LuaSetCinematicPause (true)
	if not isCameraLocked then
		LuaDebugTrace( "Debug: �� ���������� ���� isCameraLocked = "..tostring(isCameraLocked)..", � ���� ������ ���� ��������")
		LuaCameraObserveUnit ("")
	end
		cameraName = selectByFaction( "/Maps/Tutorial/cameraA2_2.CSPL", "/Maps/Tutorial/cameraB2_2.CSPL" )
		cameraTime = 15
		LuaPauseDialog( false )
		ConstructWaitConditionState( LuaIsPhraseFinished, "D17_p1" )
--		StartCinematic ("TM2_D01")
		--LuaPauseDialog( true )
		LuaCameraLock (true)
		LuaZoomCamera(60, 0)
		LuaCameraMoveToPos (cinemaPos8.x, cinemaPos8.y)
		LuaSplineCameraTimed( cameraName, cameraTime)
			LuaDebugTrace( "DEBUG: SecondCinematic 536!") 
		LuaPauseDialog( false )
		ConstructWaitConditionState( LuaIsPhraseFinished, "D17_p3" )
		--LuaPauseDialog( true )
			LuaUnitRemoveFlag (ALLY_HERO_1, ForbidPick)
			LuaUnitRemoveFlag ("local", ForbidPick)
			LuaUnSetCameraFree ()
		LuaCameraLock (false)
		CameraReturn (6)
		LuaPauseDialog( false )
		EndCinematic ()
		
		LogSessionEvent ("TM2_D17 cinematic end") -- ����������� � �����
		
		LuaDebugTrace( "DEBUG: SecondCinematic End 548!") 
		--LuaCameraLock (true)
		if true then -- ����� ������ �� ������ ������ �������
			LuaUnitRemoveFlag (ENEMY_BARRACKS2, ForbidTakeDamage) 
			LuaUnitRemoveFlag (ENEMY_BARRACKS2, ForbidInteract)
			LuaUnitRemoveFlag (ALLY_HERO_1, ForbidTakeDamage) 
			LuaUnitRemoveFlag (ALLY_HERO_1, ForbidInteract)
			LuaUnitRemoveFlag ("local", ForbidTakeDamage) 
			LuaUnitRemoveFlag ("local", ForbidInteract)
			LuaUnitRemoveFlag (ENEMY_HERO_3, ForbidPick)
			LuaUnitRemoveFlag (ENEMY_HERO_1, ForbidPick)
			LuaUnitRemoveFlag (ALLY_TOWER_1, ForbidPick)
		end
		RemoveWarfogAll( false )
end		

		LuaHeroAIFollowHero (ALLY_HERO_1, "local")
		LuaDirectionHintShow( LuaUnitGetPosition ( ENEMY_MAINBUILDING) )
		LuaUnitAddFlag (ALLY_BARRACKS2, ForbidPick)
		LuaUnitAddFlag (ALLY_BARRACKS2, ForbidPick)
		LuaUnitAddFlag (ENEMY_BARRACKS2, ForbidTakeDamage) 
		LuaUnitAddFlag (ENEMY_BARRACKS2, ForbidInteract)
		LuaUnitAddFlag (ALLY_BARRACKS2, ForbidTakeDamage) 
		LuaUnitAddFlag (ALLY_BARRACKS2, ForbidInteract)
--	

if not debugModeOn or debugTerrainOn then -- ��������� ��� �������� �����
		WaitForUnitInArea( "local", FlagPosition ) -- ���� ���� ����� �� ������� ���� �����
		NeedToPauseAfterPhrases( "D07_p1" )
		StartCinematic( "TM2_D07" )	
--		LuaCameraLock( true )
		LuaDirectionHintHide()
--		WaitForUnitIdle( "local" )
		RotateHeroTo( "local", ALLY_HERO_1 )
--		ConstructWaitConditionState( LuaIsPhraseFinished, "D07_p1" )
		WaitForPhraseEnd( "D07_p1" )
		CameraMove ( cinemaPos11.x , cinemaPos11.y , 2)
		MarkEnemy( _FlagToMark, true)
		LuaCameraLock (true)
		WaitState(1) -- ��������� ��������, ����� ������ �� ������� �� ����� � �����
		LuaCameraLock (false)
		CameraReturn (2)
		LuaPauseDialog( false )
		EndCinematic()
		LuaUnitRemoveFlag( "local", ForbidInteract ) -- ������ ����� ��������� ����, �� ����� ��� � ������ �������
		HintArrow(selectByFaction("M2_Flag1_A","M2_Flag1_B"), selectByFaction(1.5,0))
	-- ����� ����������
-- ����� Part 2.
	
-- ������� �����, ������� ����� ��������� ����� �� ������� �����
	LuaDebugTrace( "DEBUG: Try Siege create." )
	EnemySiege1 = selectByFaction( "EnemyHeroMoveB_m2", "EnemyHeroMoveA_m2" )
	x, y = LuaGetScriptArea( EnemySiege1 )
	LuaCreateCreep( "CreepS1", ENEMY_CREEP_SIEGE, x, y, FACTION_ENEMY, selectByFaction( -M_PI2, M_PI2 ))
	DecreaseUnitSight( "CreepS1", true )
	LuaDebugTrace( "DEBUG: Siege create." )
	LuaUnitAddFlag( "CreepS1", ForbidTakeDamage )
-- ���� ������
	
-- Part X: "��� � ������� ������ ����������� ����!"
	LuaDebugTrace( "DEBUG: Raise flag objective!" )
	_FlagID = selectByFaction ( 0, 2)
	
	-- ���������� ����� ��������� ���� � ����
		LuaDebugTrace( "DEBUG: �������� ��������� ����� � �����." )
		x, y = LuaGetScriptArea( selectByFaction ("AllyHeroB_m1", "AllyHeroA_m1") )
		LuaDebugTrace( "DEBUG: ����� ���������� ��� �����." )
		LuaCreatureTeleportTo( "CreepS1", x, y )
		LuaDebugTrace( "DEBUG: ���� ��������� � ������� �����." )
	-- ���� ���������

end
	
if not debugModeOn or debugMidPointFight then	 
	-- ������� ���������� � 1 ����� �����
		LuaUnitAddFlag( ENEMY_HERO_3, ForbidAutoAttack )
		LuaUnitAddFlag( ENEMY_HERO_3, ForbidTakeDamage )
		LuaDebugTrace( "DEBUG: ��������� ����� � ������� �����" )
		x, y = LuaGetScriptArea( selectByFaction ("AllyHeroB_m1", "AllyHeroA_m1") )
		LuaCreatureTeleportTo( ENEMY_HERO_3, x, y )
		LuaCreatureHide( ENEMY_HERO_3, true )
	-- ����� ���������
end

	FlagMark = {} -- ��� ������!

if not debugModeOn or debugTerrainOn then	
--	MarkEnemy( _FlagToMark, true)
	LuaAddSessionQuest( "TM2_Q05s" )
	Wait(0.5)
	HintTakeIt ()-- ���/��� �������� ��� ����
	FlagMark.x, FlagMark.y = LuaUnitGetPosition (_FlagToMark)
	LuaSessionQuestUpdateSignal( "TM2_Q05s", "Q205_s1", FlagMark.x, FlagMark.y)
	ConstructWaitConditionState( LuaFlagIsRising, 1, _FlagID)
	-- ��������� ��������� ��� ��������� �� �����
		LuaDebugTrace( "DEBUG: ������! ���-�� ��������� ���� 1!" )
		GreyWaitEnd()
		LuaDirectionHintHide()
		LuaSetHintLine("","None")	
		--NeedToPauseAfterPhrases() -- Grey. ����� �� ��������� ���, �� ��� ������ ����� ����� ������ �� ����� ������ �������
		FirstTerrainOnCinema ("TM2_D08")
		LuaPauseDialog( true )
		MarkEnemy( _FlagToMark, false)
--		ConstructWaitConditionState (FlagsTakeAlly, 1, _FlagID) 
		PushFlagsUp (1, _FlagID, "local", FACTION_PLAYER) -- ���� ���� ���� ������������ ����������
		LuaPauseDialog( false )
			WaitForPhraseEnd( "D08_p1" )
--			WaitForUnitIdle( "local" )
		--RotateHeroTo( "local", ALLY_HERO_1 )
		EndCinematic()
	-- ����� ����������
	LuaRemoveSessionQuest( "TM2_Q05s" )
	--LuaCameraObserveUnit ("local")
	LuaDebugTrace( "DEBUG: ������ ���� ������!" )
	HintArrow ("M2_FlagMiddle", selectByFaction(1.5,0)) -- ������� �� ����������� ����
	WaitState (2) -- �������� ����� ������������, ����� �������� ���������
-- �����
end

if not debugModeOn or debugFirstTowerScene then -- ������� ������� ������ �����
		x, y = LuaGetScriptArea( selectByFaction ("M2_FirstFlagPostion_A", "M2_FirstFlagPostion_B"))
		LuaCreateCreep( "CreepS2", ALLY_CREEP_SIEGE, x, y, FACTION_PLAYER, selectByFaction( M_PI2, -M_PI2 ))
		LuaUnitAddFlag( "CreepS2", ForbidAutoAttack )
		LuaUnitAddFlag( "CreepS2", ForbidTakeDamage )
		LuaDebugTrace( "DEBUG: Siege create." )
		DecreaseUnitSight( "CreepS2", true )
		LuaCreatureHide( "CreepS2", true ) 
		LuaDebugTrace( "DEBUG: Siege hide." )
	-- ��� ��������� ��� ����� ���������
end
   
if not debugModeOn or debugTalentsBuy then
	 AdvancedTalentBuyTutorial () -- ���� ������ ����������� ������� ����� � ���������, ��� ������ ������
end	 
	 
	LuaGroupHide( "TM1_BlockAreaCentral", true ) -- ��������� ������ ���� �� �����
	RemoveTrigger( ForbidZone )
	 
if not debugModeOn or debugTerrainOn then -- Part 10: "��� � ������� ����������� ����!"
	-- �������� �� ��, ����� ����� �������� ����� � ������
	LuaCreatureHide( "CreepS1", true )
	MarkEnemy( "M2_FlagMiddle", true)
	LuaAddSessionQuest( "TM2_Q06s" ) -- ����������� � �����
	FlagMark.x, FlagMark.y = LuaUnitGetPosition ("M2_FlagMiddle")
	LuaSessionQuestUpdateSignal( "TM2_Q06s", "Q206_s1", FlagMark.x, FlagMark.y)

	WaitForUnitInArea( "local", PointMiddle)
	LuaDebugTrace( "DEBUG: ����� �� ������ ����������") 
	LuaDirectionHintHide()	-- ������� ��������� �� ����������� ����
		-- ����� ������, ����� ���������� � ������� �����, ������� ��������� ����
			LuaCreatureHide( "CreepS1", false)
			LuaCameraLock (true)
			LuaUnitAddFlag( "local", ForbidPlayerControl )
			LuaUnitAddFlag( "local", ForbidAutoAttack )
			LuaUnitAddFlag( "local", ForbidTakeDamage )
			LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
			LuaUnitAddFlag( ALLY_HERO_1, ForbidAutoAttack )
			LuaHeroAIDisable ( ALLY_HERO_1 )
			LuaUnitClearStates ("local")
			LuaSetUnitStat( "CreepS1", 3, 80 )
			--LuaCameraObserveUnit ("")
--			LuaPauseDialog( true )
			NeedToPauseAfterPhrases("D10_Tech")  --add by Grey
			StartCinematic ( "TM2_D10" )
			LuaPauseDialog( true )
			-- ���������� ����� ��������� ���� � ����
				LuaDebugTrace( "DEBUG: �������� ��������� ����� �� 2 �����." )
				x, y = LuaGetScriptArea( "M2_MiddleFlagPoint" )
				LuaDebugTrace( "DEBUG: ����� ���������� ��� ������������ �����." )
--				LuaCreatureMoveTo( "CreepS1", x, y, 1 )
				LuaUnitInvokeItsAbility( "CreepS1", 1, "flag_11")
				LuaDebugTrace( "DEBUG: ���� ��������� � ������������ �����." )
			-- ���� ���������
			ConstructWaitConditionState (LuaIsUnitVisible, "CreepS1")
			LuaPauseDialog( false )
			WaitForPhraseEnd( "D10_Tech" )
			Wait(0.5) --add by Grey, ����� ����� ����� ���������� �����
			--LuaPauseDialog( false )
			LuaSetUnitStat( "CreepS1", 3, 60 )
			LuaCameraMoveToPosTimed ( x , y , 2)
			--LuaPauseDialog( false )
			--WaitForPhraseEnd( "D10_p1" )
			--LuaPauseDialog( true )
			ConstructWaitFlagsUp ( 1, 1, "CreepS1", FACTION_ENEMY ) -- ���� ���� ���� ������������ ����������
			LuaSetUnitStat( "CreepS1", 3, 44 )
			LuaPauseDialog( false )
			EndCinematic()
			CameraReturn(2)
			LuaUnitAddFlag ("M2_FlagMiddle", ForbidPick)
			LuaUnitAddFlag ("M2_FlagMiddle", ForbidInteract)
			LuaUnitAddFlag ("M2_FlagMiddle", ForbidTakeDamage)
			LuaHeroRemoveFlag( "local", ForbidTakeDamage )
			LuaHeroRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
			LuaHeroRemoveFlag( ALLY_HERO_1, ForbidAutoAttack )
			LuaHeroRemoveFlag( "local", ForbidPlayerControl )
			MarkEnemy( "M2_FlagMiddle", false)
--			LuaHeroAIDisable ( ALLY_HERO_1 )
			LuaHeroAIFollowHero (ALLY_HERO_1, "local")
	LuaAddSessionQuest( KillSiege )
	MarkEnemy( "CreepS1", true)
	x, y = LuaGetScriptArea( selectByFaction ("AllyHeroA_m1", "AllyHeroB_m1") )
	LuaDebugTrace( "DEBUG: ����� ���������� ��� �����." )
	LuaUnitRemoveFlag( "CreepS1", ForbidTakeDamage )
	LuaCreatureMoveTo( "CreepS1", x, y, 1 )
	WaitForUnitsDead( "CreepS1" ) -- ���� ���� ����� ����� �����
	LuaRemoveSessionQuest( KillSiege )
	
	LogSessionEvent ("Enemy siege killed on the mid flag") -- ����������� � �����
	
--	MarkEnemy( "CreepS1", false)
	MarkEnemy( "M2_FlagMiddle", true)
	HintArrow ("M2_FlagMiddle", selectByFaction(1.5,0))
	LuaUnitRemoveFlag( "M2_FlagMiddle", ForbidPick )
	LuaUnitRemoveFlag( "M2_FlagMiddle", ForbidInteract )
	LuaUnitRemoveFlag( "M2_FlagMiddle", ForbidTakeDamage )
end


if not debugModeOn or debugMidPointFight then -- ����� � ������ � ������������ �����
--	ConstructWaitConditionState( LuaFlagIsRising, 1, 1 )
	LuaUnitAddFlag ( ENEMY_TOWER_1, ForbidAutoAttack ) -- ����� ����� �� ��������� ���� �� ��������� ����
	LuaUnitAddFlag ( "local", ForbidAutoAttack )
	LuaUnitAddFlag ( ALLY_HERO_1, ForbidAutoAttack )	
	LuaUnitAddFlag( "local", ForbidTakeDamage )
	LuaUnitAddFlag( "local", ForbidAutotargetMe )
	LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
	LuaUnitAddFlag( ALLY_HERO_1, ForbidAutotargetMe )
	ConstructWaitConditionState (FlagsTakeAlly, 1, 1) 
	NeedToPauseAfterPhrases( "D14_p1" )	

	StartCinematic ( "TM2_D14" ) -- ����������� � �����
	LuaUnitRemoveFlag( "local", ForbidTakeDamage )
	LuaUnitRemoveFlag( "local", ForbidAutotargetMe )
	LuaUnitRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
	LuaCreatureHide( ENEMY_HERO_3, false ) -- ��� ���������� ��������� ������!
	LuaHeroRemoveFlag( "local", ForbidAutoAttack )	
	if isCameraLocked then
		LuaDebugTrace( "Debug: �� ���������� ���� isCameraLocked = "..tostring(isCameraLocked)..", � ���� ������ ���� ��������")
		LuaCameraObserveUnit ("")
	end
	-- ������ ���������� � ������� ��� �������� �����
		LuaUnitAddFlag( "local", ForbidTakeDamage ) -- ����� ����� ���� ������, ����� ����� ���� ����� � ������ �������� �����
		LuaUnitAddFlag(ENEMY_HERO_3, ForbidAutotargetMe ) -- ����� ����� �� ���� �� ���� ���� �����
		LuaUnitAddFlag( "local", ForbidPlayerControl )
		LuaUnitAddFlag( "local", ForbidAutoAttack )
		LuaUnitAddFlag( "local", ForbidAutotargetMe )
		LuaUnitAddFlag( ENEMY_HERO_3, ForbidAutoAttack )
		LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaUnitAddFlag( ALLY_HERO_1, ForbidAutotargetMe )
		LuaHeroAIDisable ( ALLY_HERO_1 )
		LuaDirectionHintHide()
		MarkEnemy( "M2_FlagMiddle", false)
	-- ����� ������ ����� ����������
	LuaHeroRemoveFlag( ENEMY_HERO_3, ForbidAutoAttack )
	LuaDebugTrace( "DEBUG: ��������� �����3 � ������������ �����." )
	UnitMoveTo( ENEMY_HERO_3, PointMiddle, 7 )
		WaitForPhraseEnd( "D14_p1" )
	WaitForUnitIdle( "local" )
		LuaPauseDialog( false )
		WaitForPhraseEnd( "D14_p2" )
	RotateHeroTo( "local", PointMiddle) -- ��� ���������� ������ ����������, ���� ���� ��������� �����
	RotateHeroTo ( ALLY_HERO_1, PointMiddle)
	LuaRemoveSessionQuest( "TM2_Q06s" )
	-- ������ ������ ����� ����������
		LuaCameraLock (true)
		WaitForMoveTo( ENEMY_HERO_3, PointMiddle, 0)
		RotateHeroTo ( ENEMY_HERO_3, "local" )
		ConstructWaitConditionState( LuaIsPhraseFinished, "D14_p2" )
		LuaShowTutorialOvertipLevelHighlight ( ENEMY_HERO_3, true ) -- ������������ �����, ��� �������� ������ ��� ������� �����
		ConstructWaitConditionState( LuaIsPhraseFinished, "D14_p4" )
		PlaceMarker ( "obj2", Obj2Pos.x, Obj2Pos.y ) -- ��������� �� �����, ���� ����� ������� ����. ����� 
		ConstructWaitConditionState( LuaIsDialogFinished, "TM2_D14" )
		x, y = LuaUnitGetPosition ("local")
		EndCinematic()
 
		HintArrow(Obj2Pos,0) -- ��������� � ����������� � �����, ���� ����� ������� ����. �����
		LuaCameraLock (false)
		LuaHeroRemoveFlag( "local", ForbidTakeDamage )
		LuaHeroRemoveFlag( "local", ForbidPlayerControl )
		LuaHeroRemoveFlag( "local", ForbidAutoAttack )
		LuaHeroRemoveFlag( "local", ForbidAutotargetMe )
		LuaHeroRemoveFlag(ENEMY_HERO_3, ForbidAutotargetMe )
		LuaHeroRemoveFlag(ENEMY_HERO_3, ForbidAutoAttack )
		LuaUnitRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaUnitRemoveFlag( ALLY_HERO_1, ForbidAutotargetMe )
		LuaUnitRemoveFlag ( "local", ForbidAutoAttack )
		LuaUnitRemoveFlag ( ALLY_HERO_1, ForbidAutoAttack )
		LuaShowTutorialOvertipLevelHighlight ( ENEMY_HERO_3, false )
	-- ����� ����������	
	LuaHeroRemoveFlag( ENEMY_HERO_3, ForbidTakeDamage )
	-- ��������� �������
		HighHeroPos1 = {}
		HighHeroPos1.x, HighHeroPos1.y = LuaUnitGetPosition (ENEMY_HERO_3)
		LuaAddSessionQuest( "TM2_Q14s" )
		LuaSessionQuestUpdateSignal( "TM2_Q14s", "Q214_s1", HighHeroPos1.x, HighHeroPos1.y)
	-- ����� ��������� �������
	if isCameraLocked then
		LuaDebugTrace( "Debug: �� ���������� ���� isCameraLocked = "..tostring(isCameraLocked)..", � ���� ������ ���� ��������")
		LuaCameraObserveUnit ("local")
	end
 
	LuaHeroAttackUnit(ENEMY_HERO_3, "local")
	LuaHeroAIFollowHero (ALLY_HERO_1, "local")
	LuaShowTutorialElementHighlight( "SelectionLevel", true )
	WaitForUnitsDead( ENEMY_HERO_3 ) -- ���� ���� ���� ����� ��������
	LuaShowTutorialElementHighlight( "SelectionLevel", false )
	RemoveLastMarker() --changed by Grey
 
	LuaDirectionHintHide()
	LuaUnitRemoveFlag( ENEMY_TOWER_1, ForbidAutoAttack )
end
	
 
	PeriodicalSpawn( ALLY_MAIN_SPAWNER , 18, creepCap) -- ��������� ����� ������
 
	LuaDebugTrace( "DEBUG: Let the spawn begin!" )

if not debugModeOn or debugMidPointFight then	
	LuaRemoveSessionQuest( "TM2_Q14s" )
	RemoveTrigger(HeroesLevelUp_ENEMY_HERO_3_8Levels) -- ������ ������ ����� �� ������ � ������ ���� ���
	StartTrigger(HeroesLevelUp,"local",ENEMY_HERO_3, 0)
	checkGender=false -- ������ ������� �������� ���� ��������
	LuaUnitAddFlag ( "local", ForbidAutoAttack )
	LuaUnitAddFlag ( ALLY_HERO_1, ForbidAutoAttack )	
	LuaUnitAddFlag( "local", ForbidTakeDamage )
	LuaUnitAddFlag( "local", ForbidAutotargetMe )
	LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
	LuaUnitAddFlag( ALLY_HERO_1, ForbidAutotargetMe )
	-- ��������� ��������� ����� ������ �����, �� �� ���� ����� �������� �������� �� ������
		
		StartCinematic( "TM2_D15" ) -- ����������� � �����
		LuaPauseDialog( true )
		WaitState (2.5) -- ������ �� ������������ ������ �����
		HeroTalking ( "local", ALLY_HERO_1 )
		Wait(rotateTime) --���� ��������� ��������
		LuaForceAnimation (ALLY_HERO_1, "happy", 0) -- ��������� �������� �����, ������ �������� :)
		LuaCreatureHide (ENEMY_HERO_3 , true)
		LuaPauseDialog( false )
		EndCinematic()
		LuaStopForcedAnimation (ALLY_HERO_1)
	-- ����� ����������
	LuaHeroRemoveFlag( "local", ForbidTakeDamage )
	LuaHeroRemoveFlag( "local", ForbidAutotargetMe )
	LuaUnitRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
	LuaUnitRemoveFlag( ALLY_HERO_1, ForbidAutotargetMe )
	LuaUnitRemoveFlag ( "local", ForbidAutoAttack )
	LuaUnitRemoveFlag ( ALLY_HERO_1, ForbidAutoAttack )
end
	
-- Part 22 : ���������� ����� 1
		LuaUnitRemoveFlag( ENEMY_TOWER_1, ForbidTakeDamage ) -- ������ ����� ����� ����������
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_TOWER_1, 15 )
		LuaDebugTrace( "DEBUG: ���������� �����!" )
		RemoveWarfogTarget (ENEMY_TOWER_1, true)
		MarkEnemy( ENEMY_TOWER_1, true )
		HintArrow( ENEMY_TOWER_1, 0)
		TowerPos1 = {}
		TowerPos1.x, TowerPos1.y = LuaUnitGetPosition (ENEMY_TOWER_1)
	LuaAddSessionQuest( "TM2_Q22p" )
		LuaSessionQuestUpdateSignal( "TM2_Q22p", "Q222_p1", TowerPos1.x, TowerPos1.y)
	
if not debugModeOn or debugRatCatcherDead then 	
-- ������� ���������� � 2 ����� �����
	LuaCreatureTeleportTo( ENEMY_HERO_1, EnemyHeroMovePos.x, EnemyHeroMovePos.y )
	StartTrigger( RatcatcherDead, ENEMY_HERO_1 ) -- ���� �������� ����� ���� ��� ������� ������
	LuaCreatureHide( ENEMY_HERO_1, true ) -- ������ ���������, ����� � ��� ������ ������ �� ���������
end
	
	LuaUnitAddFlag( ENEMY_TOWER_2, ForbidDeath )
	
if not debugModeOn or debugTalentsBuy then	
	HeroCanTakeTalent ("local", 10) -- ��������� ��������, �� ��, ��� ����� ����� �������� ������
end
	
	WaitForUnitsDead( ENEMY_TOWER_1 )
		LuaGroupHide( ENEMY_Secondery_LockTiles, true ) -- ��������� ������ ���� �� ������ �����
		LuaDirectionHintHide()	
	LuaRemoveSessionQuest( "TM2_Q22p" )
	
if not debugModeOn or debugFirstTowerScene then 
	-- ������ ���������, ����� ������
		LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaUnitAddFlag( "local", ForbidTakeDamage )
		LuaCameraObserveUnit ("local")
	
	NeedToPauseAfterPhrases( "D22_p1", "D22_p2" )
	StartCinematic ( "TM2_D22" ) -- ����������� � �����
	AddTriggerTop (AllyHappyInTower, ALLY_HERO_1, "local", cinemaPos7, 1)
	
	-- ������� ������ �����, ����� �������� ��� �����
		SiegeFlag = selectByFaction ("AllyHeroA_m1", "AllyHeroB_m1")
		LuaDebugTrace( "DEBUG: ���� ���� ����� �������� � �������� �����!" )
	--	if LuaFlagGetFaction( 1, 0) == FACTION_ENEMY then
			LuaDebugTrace( "DEBUG: �� ��� ����, ���������� ���������!" )
			LuaCreatureHide( "CreepS2", false ) 
			siegeMove = GetScriptArea( selectByFaction ("M2_FirstFlagPostion_B", "M2_FirstFlagPostion_A") )
			LuaSetUnitStat( "CreepS2", 3, 60 ) -- ������ ������� �������� �����, ����� ������ ��� �����
			LuaSetUnitHealth( _FlagEnemy, 1 ) -- ����� ���� ����� ��������� ��������� ����
			UnitMoveTo( "CreepS2", siegeMove, 10 )
			WaitForPhraseEnd( "D22_p1" )
			--LuaPauseDialog( true )
--			WaitForMoveTo( "CreepS2", siegeMove, 8 )
			LuaDebugTrace( "DEBUG: ���������� �����." )
			_FlagIDAlly = selectByFaction (2, 0)
			FlagMark.x, FlagMark.y = LuaUnitGetPosition (_FlagEnemy)
			CameraMove( FlagMark.x, FlagMark.y, 2) -- ���������� ������ � �����, ����� �������� ��� �� �����������
			LuaCameraLock( true )
			ConstructWaitFlagsUp ( 1, _FlagIDAlly, "CreepS2", FACTION_PLAYER )
			LuaCameraLock( false ) 
			LuaPauseDialog( false )
			WaitForPhraseEnd( "D22_p2" )
			LuaCreatureMoveTo( "CreepS2", EnemyHeroMovePos.x, EnemyHeroMovePos.y, 1 ) -- ����� ���������� ����� ������� � ���������
			LuaUnitRemoveFlag( "CreepS2", ForbidTakeDamage ) -- ������ ������ ����� ����� �����
			LuaSetUnitStat( "CreepS2", 3, 40 )
			CameraReturn(1)
			LuaPauseDialog( false )
--			ConstructWaitConditionState( LuaIsPhraseFinished, "D22_p1" )
	--	end
	-- ���� ��� ��������� ��������� ������ ����, ���� ������ �������.
	StopAllPeriodicalSpawn()
	LuaSetSpawnCreeps( true )
	EndCinematic ()
	LuaHeroAIFollowHero ( ALLY_HERO_1, "local")
	LuaHeroRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
	LuaHeroRemoveFlag( "local", ForbidTakeDamage )
	LuaHeroRemoveFlag( ALLY_HERO_1, ForbidAutoAttack )
-- ����� ����������
-- End ����� ���������
end

-- Part 29 : ���������� ����� 2
--	LuaCreatureHide( ENEMY_HERO_3, true ) -- ��������� ������ ���� � ���������
	HintArrow( ENEMY_TOWER_2, selectByFaction(1.5,0) )
	LuaAddSessionQuest( "TM2_Q29p" )
	LuaDebugTrace( "���������� ������ �����!" )
	RemoveWarfogTarget (ENEMY_TOWER_2, true)
	MarkEnemy( ENEMY_TOWER_2, true )
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_TOWER_2, 15 )
	TowerPos2 = {}
	TowerPos2.x, TowerPos2.y = LuaUnitGetPosition (ENEMY_TOWER_2)
	LuaAddSessionQuest( "TM2_Q29p" )
	LuaSessionQuestUpdateSignal( "TM2_Q29p", "Q229_s1", TowerPos2.x, TowerPos2.y)

if not debugModeOn or debugRatCatcherDead then 		
	RatKilling () -- ������� ��� �� ��������� �������� ���������
	Wait (2.5) -- ���� ���� ����������� �������� ������ ���������
	GUITeamBlock() -- ������������ ��� �������� ������ � ���������
	TestHeroRespawning (ENEMY_HERO_1, 0.5)
	Wait (0.5) 
	LuaCreatureHide( ENEMY_HERO_1, true )
	LuaDebugTrace( "DEBUG: ��������� ��������" )	
end
	
--	LuaStartDialog( "TM2_D27" )
	LuaUnitRemoveFlag( ENEMY_TOWER_2, ForbidDeath ) -- �� ����� ������� ������ ����� �� ����� ���� ���������
	WaitForUnitsDead( ENEMY_TOWER_2 )
	LuaRemoveSessionQuest( "TM2_Q29p" )
-- �����
	
-- Part 30 : ���������� �������
	LuaAddSessionQuest( "TM2_Q30p" ) -- ����������� � �����
	LuaDebugTrace( "DEBUG: ���������� �������!" )
	BarracksPos1 = {}
	BarracksPos1.x, BarracksPos1.y = LuaUnitGetPosition (ENEMY_BARRACKS)
	LuaSessionQuestUpdateSignal( "TM2_Q30p", "Q230_s1", BarracksPos1.x, BarracksPos1.y)
	RemoveWarfogTarget (ENEMY_BARRACKS, true)
	MarkEnemy( ENEMY_BARRACKS, true )
	HintArrow ( ENEMY_BARRACKS, selectByFaction(1.5,0))
	WaitForUnitsDead( ENEMY_BARRACKS )
	HintArrow( ENEMY_MAINBUILDING,0)
--	LuaUnitRemoveApplicator( ENEMY_BARRACKS, "ArrowUnitAppl" )
	LuaSetManualGameFinish (true)
	LuaRemoveSessionQuest( "TM2_Q30p" )

	LuaUnitAddFlag( ENEMY_MAINBUILDING, ForbidDeath ) -- ������� ������ ������ �����
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_MAINBUILDING, 10 ) -- ������ ����� ����� ���������� ��

if not debugModeOn or debugFirstFightVsHero then -- Part 31 : ����� ����� ������	

if not debugModeOn then -- ��������� ��� ������
	LuaCreatureHide( ENEMY_HERO_3, false )
	LuaCreatureHide( ENEMY_HERO_1, false )
elseif debugModeOn and debugMidPointFight then
	LuaCreatureHide( ENEMY_HERO_3, false )
	LuaDebugTrace( "DEBUG: ������� ��� ��")
elseif debugModeOn and debugRatCatcherDead then
	LuaCreatureHide( ENEMY_HERO_1, false )
	LuaDebugTrace( "DEBUG: ������� ��� ���������")
end
		StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_HERO_1, 10 )
		StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_HERO_3, 10 )
		LuaUnitAddFlag( ENEMY_HERO_1, ForbidTakeDamage )
		LuaUnitAddFlag( ENEMY_HERO_3, ForbidTakeDamage )
		LuaUnitAddFlag( ENEMY_HERO_1, ForbidAutoAttack )
		LuaUnitAddFlag( ENEMY_HERO_3, ForbidAutoAttack )
		BuildingPos1 = {}
		BuildingPos1.x, BuildingPos1.y = LuaUnitGetPosition (ENEMY_MAINBUILDING)
		LuaSessionQuestUpdateSignal( selectByFaction("TM2_Q34dp", "TM2_Q34ap"), "Q234_s1", BuildingPos1.x, BuildingPos1.y)
		Objective31 = GetScriptArea( selectByFaction("ObjectiveB31_m2", "ObjectiveA31_m2"))
		Objective31a = GetScriptArea( selectByFaction( "HeroPointB1_m2", "HeroPointA1_m2"))
		Objective31b = GetScriptArea( selectByFaction( "HeroPointB2_m2", "HeroPointA2_m2"))
	--	WaitState (1) -- ��� ��������, ����� ���� ����� ����� ����������� �������� � ������ � �������
		WaitForUnitInArea ("local", Objective31)	
	NeedToPauseAfterPhrases( "D32_p3" )	
	StartCinematic ( "TM2_D32", true ) -- ����������� � �����
	LuaHeroAIDisable( ALLY_HERO_1 )
	RemoveWarfogAll( true ) 
	LuaDirectionHintHide()
	LuaCameraLock (true)
	LuaCreatureMoveTo( ENEMY_HERO_1, Objective31a.x, Objective31a.y, 1 )
	LuaCreatureMoveTo( ENEMY_HERO_3, Objective31b.x, Objective31b.y, 1 )
		WaitForPhraseEnd( "D32_p3" )
	WaitForUnitInArea(ENEMY_HERO_1, Objective31a)
	WaitForUnitInArea(ENEMY_HERO_3, Objective31b)
		LuaPauseDialog( false )
		WaitForPhraseEnd( "D32_p4" )
	StartTrigger (EnemyUnitsDead, ENEMY_HERO_1, ENEMY_HERO_3)
	LuaAddSessionQuest( KillEnemyRatcatcher ) -- ����� ������� �����
	LuaAddSessionQuest( KillEnemyRockman ) -- ����� ������� �����
		LuaCameraObserveUnit ("")
	-- ������ � ������� 
		LuaSetCinematicPause (true)
		LuaUnitClearStates ("local")
	--	CameraMovePos1 = {}
	--	CameraMovePos1.x, CameraMovePos1.y = LuaUnitGetPosition (ENEMY_HERO_1)
	--	CameraWaitPosition ( CameraMovePos1.x , CameraMovePos1.y , 3)
	EndCinematic()
		LuaCameraObserveUnit ("local")
		RemoveWarfogAll( false ) 
	--	CameraReturn (1)
		LuaUnitRemoveFlag( ENEMY_HERO_1, ForbidTakeDamage )
		LuaUnitRemoveFlag( ENEMY_HERO_3, ForbidTakeDamage )
		LuaUnitRemoveFlag( ENEMY_HERO_1, ForbidAutoAttack )
		LuaUnitRemoveFlag( ENEMY_HERO_3, ForbidAutoAttack )
		MarkEnemy( ENEMY_HERO_1, true )
		MarkEnemy( ENEMY_HERO_3, true )
		Wait (0.2) -- ����� ����� �����, ��� ��� ��� �����������
		LuaHeroAIFollowHero( ALLY_HERO_1, "local" )
		LuaHeroAttackUnit (ENEMY_HERO_1, ALLY_HERO_1)
		LuaHeroAttackUnit (ENEMY_HERO_3, ALLY_HERO_1)
		LuaSetCinematicPause (false)
		LuaCameraLock (false)
	-- �����
	ConstructWaitConditionState( EnemyUnitsWellDone )
	LuaDebugTrace( "DEBUG: ��� ������")
	RemoveWarfogTarget (ENEMY_MAINBUILDING, true)
	MarkEnemy( ENEMY_MAINBUILDING, true )
	HintArrow( ENEMY_MAINBUILDING,0)
	Wait (2.5) -- ����� �� �������� ������ ���������� �����
	LuaCreatureHide (ENEMY_HERO_3 , true)
	LuaCreatureHide (ENEMY_HERO_1 , true)
end	

if not debugModeOn or debugSecondFightVsHero then -- �������� ������������ ����	
	-- ��������� �������� �����
	WaitForUnitInArea ("local", Objective31)
	if not debugModeOn then 
		LuaCreatureHide (ENEMY_HERO_2 , false)
	elseif debugModeOn and debug1Jaba then
		LuaCreatureHide (ENEMY_HERO_2 , false)
		LuaDebugTrace( "DEBUG: ������� ��� ����")
	end
--		LuaUnitClearStates ("local")
		LuaUnitAddFlag( ENEMY_HERO_2, ForbidTakeDamage )
		LuaUnitAddFlag( ENEMY_HERO_2, ForbidAutoAttack )
		LuaUnitAddFlag( "local", ForbidAutoAttack )
		LuaUnitAddFlag( "local", ForbidTakeDamage )
		LuaUnitAddFlag( ALLY_HERO_1, ForbidAutoAttack )
		LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_HERO_2, 10 )
	-- ��������� ��������� ��� ����������� ����
	x, y = LuaUnitGetPosition ("local")
	LuaCreatureMoveTo( ENEMY_HERO_2, x, y, 5 )
	StartCinematic ( "TM2_D29", true )
	LuaPauseDialog( true )
	LuaDirectionHintHide()
	WaitForUnitInArea( ENEMY_HERO_2, x, y, 10 )
	LuaPauseDialog( false )
	EndCinematic()
		LuaCameraLock (false)
		LuaAddSessionQuest( KillEnemyFrog ) -- ����� �� �������� ����
		MarkEnemy( ENEMY_HERO_2, true)
		LuaCameraObserveUnit ("local")
	Wait (0.2)
		LuaDebugTrace( "DEBUG: ������ ���������." )
	LuaSetCinematicPause (false)
		LuaUnitRemoveFlag( ENEMY_HERO_2, ForbidAutoAttack )
		LuaUnitRemoveFlag( ENEMY_HERO_2, ForbidTakeDamage )
		LuaUnitRemoveFlag( "local", ForbidAutoAttack )
		LuaUnitRemoveFlag( "local", ForbidTakeDamage )
		LuaUnitRemoveFlag( ALLY_HERO_1, ForbidAutoAttack )
		LuaUnitRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
	-- ����� ����������
	LuaHeroAttackUnit (ENEMY_HERO_2, "local")
	WaitForUnitsDead( ENEMY_HERO_2 )
		MarkEnemy( ENEMY_HERO_2, false)
		LuaDebugTrace( "DEBUG: �������, � ����� �� ��������!" )
	LuaRemoveSessionQuest( KillEnemyFrog )
	NeedToPauseAfterPhrases("D35_p1")
	StartCinematic ( "TM2_D35", true ) -- ����������� � �����
		LuaUnitClearStates ("local")
		LuaUnitAddFlag( "local", ForbidAutoAttack )
		LuaUnitAddFlag( "local", ForbidTakeDamage )
		LuaUnitAddFlag( ALLY_HERO_1, ForbidAutoAttack )
		LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
	ConstructWaitConditionState( LuaIsPhraseFinished, "D35_p1" )
		RemoveWarfogAll( true )
		LuaCameraLock (true)
		LuaCameraMoveToPosTimed (cinemaPos15.x , cinemaPos15.y, 2)
--		CameraWaitPosition ( cinemaPos15.x , cinemaPos15.y, 3 )
		WaitState(2) -- ��������� ��������, ����� ������ �� ������� �� ����� � �����
		LuaCreatureHide (ENEMY_HERO_2 , true)
		LuaPauseDialog( false )
	EndCinematic()
		LuaCameraLock (false)
		--LuaCameraObserveUnit ("")
		CameraReturn (1)
		RemoveWarfogAll( false )
		LuaUnitRemoveFlag( "local", ForbidAutoAttack )
		LuaUnitRemoveFlag( "local", ForbidTakeDamage )
		LuaUnitRemoveFlag( ALLY_HERO_1, ForbidAutoAttack )
		LuaUnitRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaSetUnitStat( "FountainA", 2, 22 ) -- ����� ������� ���������
		LuaSetUnitStat( "FountainB", 2, 22 )
		HintArrow( ENEMY_MAINBUILDING,0)
 -- ������� ������ ������ ����� ����������
		LuaDebugTrace( "������ �������� ��������� �� ��!" )
end
-- �����
	 -- ����� ��������� ����� ������ ALLY_MAIN_SPAWNER
		LuaSetSpawnCreeps( false )
		periodicalSpawnStop = false -- ����� ��������� ����� ������ ALLY_MAIN_SPAWNER
		PeriodicalSpawn( ALLY_MAIN_SPAWNER , 18, creepCap)
	 --

	LuaUnitRemoveFlag( ENEMY_MAINBUILDING, ForbidDeath )
	BuildingPos1 = {}
	BuildingPos1.x, BuildingPos1.y = LuaUnitGetPosition (ENEMY_MAINBUILDING)
	LuaSessionQuestUpdateSignal( selectByFaction("TM2_Q34dp", "TM2_Q34ap"), "Q234_s1", BuildingPos1.x, BuildingPos1.y)
	WaitForUnitsDead( ENEMY_MAINBUILDING )
	LuaDirectionHintHide ()
	LuaRemoveSessionQuest( selectByFaction("TM2_Q34dp", "TM2_Q34ap") )
	RemoveWarfogAll( true ) 
	StartCinematic ("TM2_D31", true) -- ����������� � �����
	EndCinematic()
	Wait (0.5) --�������� ����� ������ ���� �����, ����� ����� �� ����������--
	LuaGameFinish( selectByFaction ( 2, 1) )
end

function RatKilling () -- Part 23: ������� ���������	
	LuaCreatureHide( ENEMY_HERO_1, false ) -- ������ �������� � ������ ����������
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_HERO_1, 25 )
		LuaHeroSetForbidRespawn( ALLY_HERO_1, true )
		LuaHeroSetForbidRespawn( "local", true )
--		LuaHeroSetForbidRespawn( ENEMY_HERO_1, true )
	WaitForUnitInArea( ENEMY_HERO_1, EnemyHeroMovePos )
	WaitForUnitInArea( "local", cinemaPos16.x, cinemaPos16.y, 20 )
	if HeroDeadCinematicStart or KillsTimeStart then
		while HeroDeadCinematicStart or KillsTimeStart do
--			LuaDebugTrace( "DEBUG: ���� ���� ������ �������� �������� ���� ������." )
			SleepState() 
		end
		RatKillingStart = true
	else
		RatKillingStart = true
	end
		LuaUnitAddFlag( ALLY_HERO_1, IgnoreInvisible )
		LuaUnitAddFlag( ALLY_HERO_1, ForbidAutoAttack )
		LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaUnitAddFlag( "local", ForbidAutoAttack )
		LuaUnitAddFlag( "local", ForbidTakeDamage )
		LuaUnitAddFlag( "local", ForbidAutotargetMe )
		LuaHeroAIDisable( ALLY_HERO_1 )
		x, y = LuaUnitGetPosition (ENEMY_HERO_1)
	LuaCreatureMoveTo( ALLY_HERO_1, x, y, 12 )
	LuaAddSessionQuest( KillEnemyRatcatcher )
	--LuaCameraObserveUnit ("")
	LuaUnitRemoveFlag( ALLY_HERO_1, ForbidDeath ) 
	LuaUnitRemoveFlag( "local", ForbidDeath )
	heroesImmortal = false --�������� ���������� ������
	
	NeedToPauseAfterPhrases("D23_Tech", "D23_p5", "D23_p6")
	StartCinematic ( "TM2_D23" ) -- ��������� � ���������� ��� ����� ������
	MarkEnemy( ENEMY_TOWER_2, false )
	LuaDirectionHintHide()
	LuaCameraMoveToPosTimed ( cinemaPos1.x , cinemaPos1.y , 2)
	RotateHeroTo( ENEMY_HERO_1, "local")
	Wait(rotateTime) -- ���� ��������� ��������
	LuaSetCinematicPause (true)
--	WaitForPhraseEnd("D23_p2" ) -- by Grey
		x, y = LuaUnitGetPosition ("local")
	LuaDebugTrace( "DEBUG: ������ ���������." )
	WaitForPhraseEnd( "D23_p4" )
	LuaSetCinematicPause (false)
	LuaPauseDialog( true ) -- �� �������!
-- �����, ��� �������� ����������� ��������
		LuaHeroRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaHeroRemoveFlag( ALLY_HERO_1, ForbidAutoAttack )
		LuaHeroRemoveFlag( ENEMY_HERO_1, ForbidTakeDamage )
--		LuaHeroRemoveFlag( ENEMY_HERO_1, ForbidAutoAttack )
		LuaUnitAttackUnit( ALLY_HERO_1, ENEMY_HERO_1 ) -- ��� ���� ��������� �� �����, ����� ����� ��� ��� ������
		LuaUnitAttackUnit(ENEMY_HERO_1, ALLY_HERO_1) -- ���������� ��������� � ���������
		allyHero = {}
		allyHero.x, allyHero.y = LuaUnitGetPosition ( ALLY_HERO_1 )
		LuaCreatureMoveTo( ENEMY_HERO_1, allyHero.x, allyHero.y, 10 ) -- ����� �������� �� ����� ������ ����, ��� ������ ����� ����, ��� ��� ������ ������
	WaitForHeroNearUnit( ENEMY_HERO_1, ALLY_HERO_1, 10 ) -- ����, ����� �������� �������� ����� � ���������
		LuaUnitClearStates( ENEMY_HERO_1 )
	if not LuaHeroCanActivateTalent (ENEMY_HERO_1, 0 , 1) then -- ��������, ����� � ��������� ��� ������� ��� �������
		LuaHeroActivateTalent (ENEMY_HERO_1, 0 , 1, true)
	end
		LuaHeroUseTalentUnit (ENEMY_HERO_1, 0, 1, ALLY_HERO_1) -- �������� ����� �� ���� ����
	LuaPauseDialog( false ) -- �� �������!
	WaitForPhraseEnd( "D23_Tech" ) -- �� �������!
	Wait (1) -- ���� ���� �� �������� �������� �������
		LuaCreatureMoveTo( ENEMY_HERO_1, Obj4Pos.x, Obj4Pos.y, 1 ) -- �������� ����� ���� ���� ��� �����
	WaitForUnitInArea( ENEMY_HERO_1, Obj4Pos ) -- ���� ���� �� �� �������
		LuaCreatureMoveTo( ENEMY_HERO_1, EnemyHeroMovePos.x, EnemyHeroMovePos.y, 3 )
--	Part23=true ��������, ��� ���� �������� ���� ��� ���, �� ����� �������� � ���� ��� ����� (����. �.�. �����!)
--		LuaHeroAIGuardScriptArea (ENEMY_HERO_1, ENEMY_HERO_TOWER ) -- ����������� ���������, ����� ����� ��� ������
		LuaHeroRemoveFlag( ENEMY_HERO_1, ForbidAutoAttack )
	LuaPauseDialog( false )	
	WaitForPhraseEnd( "D23_p5" )
	
	LuaKillUnit ( ALLY_HERO_1 ) -- ����, ����� �������� �� ������
	WaitForUnitsDead( ALLY_HERO_1 )
	LogSessionEvent ("Ratcatcher quest: Ally hero dead") -- ����������� � �����
	
	Wait (2.5) -- ����� �� ������������ �������� ������ �������������� �����
			CameraMove (cinemaPos12.x, cinemaPos12.y, 3)
			if not LuaHeroIsRespawning (ALLY_HERO_1) then
				LuaHeroRespawn (ALLY_HERO_1)
				LuaDebugTrace( "DEBUG: ������ �� ������ ����������� �� ����!" )
			end
			WaitState (1.5) -- ���� ���� ���������� ��������� �����
	LuaPauseDialog( false )
	WaitForPhraseEnd( "D23_p6" )
			LuaUnitAddFlag( ALLY_HERO_1, ForbidAutoAttack )
			LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )	
	NeedUsePortal (ALLY_HERO_1, "local") -- �������� ���� � �����
	LuaPauseDialog( false )
	WaitForPhraseEnd( "D23_p7" )
	LuaDebugTrace( "DEBUG: NeedUsePortal ����������!" )

	LuaDebugTrace( "DEBUG: ����� D23_p6 �����������!" )
	LuaShowUIBlock( "PortalBtn", true ) -- ��������� ������ "������"
--			LuaDebugTrace( "DEBUG: �������� �����" )
--			LuaSetCinematicPause (true)
	EndCinematic ()
--			LuaSetCinematicPause (false)
	isCinematicCurrentlyPlayed = true
	LuaHeroAIDisable( ENEMY_HERO_1 )
		LuaSetAdventureControlsEnabled( false, true )
		LuaSetCinematicPause (true)
	LuaBeginBlockSection() 
		LuaAddNonBlockedElement ("PortalBtn", true)
	LuaEndBlockSection( 0 )
		LuaShowTutorialElementHighlight ( "PortalBtn", true )
		ShowBubbleButton( "TM2_D23_1", "PortalBtn")
		WaitForBubbleClick()
		
		LogSessionEvent ("Ratcatcher quest: player push the bubble button of portal") -- ����������� � �����
		
	LuaClearBlocking( 0 )
	LuaShowTutorialElementHighlight ( "PortalBtn", false )
		WaitState (0.1)
	LuaHeroAIFollowHero (ALLY_HERO_1, "local")
	MarkEnemy( ENEMY_HERO_1, true )
	HintArrow(ENEMY_HERO_1,0)
		LuaSetCinematicPause (false)
		LuaSetAdventureControlsEnabled( true, true )
		LuaHeroRemoveFlag( "local", ForbidAutoAttack )
		LuaHeroRemoveFlag( "local", ForbidTakeDamage )
		LuaHeroRemoveFlag( "local", ForbidAutotargetMe )
		LuaHeroRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaHeroRemoveFlag( ALLY_HERO_1, ForbidAutoAttack )
		RatKillingStart = false
	
	isCinematicCurrentlyPlayed = false
	WaitState (0.5)
	LuaUnitAttackUnit(ENEMY_HERO_1, "local")
	WaitForUnitsDead( ENEMY_HERO_1 ) -- ���� ���� ����� ����������� � ����������	
	LuaShowUIBlock( "EnemyTeamMateBlock", true )
	LuaDebugTrace( "DEBUG: �������� �����!" )
		MarkEnemy( ENEMY_HERO_1, false )
		MarkEnemy( ENEMY_TOWER_2, true )
		LuaDirectionHintShow( LuaUnitGetPosition( ENEMY_TOWER_2 ) )
	LuaRemoveSessionQuest( KillEnemyRatcatcher )
end
-- Part 25-26: ���� ������ �����, ����� ����������
function MyHeroDead(name)	
	dead, found = LuaUnitIsDead(name)
	if dead and found and not ImDeadFirst and not isCinematicCurrentlyPlayed then -- ���������� ��������� ���� ��� ����� ������ ������
		ImDeadFirst = true
		LuaDebugTrace( "DEBUG: ����� ����!" )
		TestHeroRespawning (name, 2.5)
			LuaCameraObserveUnit (name)
		ShowHintline( "TM2_D25_1", false )	-- ����������� � �����
		WaitState (7) -- ����� ������� ����� ������ ����
		ShowHintline("")
		--StartCinematic ( "TM2_D25" )
		--EndCinematic()
		if Part2 then
			LuaHeroAIFollowHero (ALLY_HERO_1, "local")
			LuaDebugTrace( "DEBUG: �� ��������� �������� �� ����" )
		end
		return false
	elseif dead and found then
			LuaDebugTrace( "DEBUG: ����� ����� ����!" )
--		LuaHeroSetForbidRespawn( "local", true )
--			WaitState(4)
		TestHeroRespawning (name, 2.5)
--		LuaHeroSetForbidRespawn( "local", false )
			LuaCameraObserveUnit ("local")
			WaitState(2)
		if Part2 then
			LuaHeroAIFollowHero (ALLY_HERO_1, "local")
			LuaDebugTrace( "DEBUG: �� ��������� �������� �� ����" )
		end	
	end
	return false
end

function AllyHeroDead(ALLY_HERO_1)
	dead, found = LuaUnitIsDead(ALLY_HERO_1)
	if dead and found and not RatKillingStart then
		LuaDebugTrace( "DEBUG: ������� ����� ����!" )
		LuaHeroSetForbidRespawn( ALLY_HERO_1, true )
		TestHeroRespawning (ALLY_HERO_1, 1)
		WaitState (2) -- ���� ���� ����� ����������
		LuaHeroAIFollowHero (ALLY_HERO_1, "local")
	end
	return false
end

function RatcatcherDead(name)	
	dead, found = LuaUnitIsDead(name)
	if dead and found and Part23 then
		LuaDebugTrace( "DEBUG: �������� ����" )
		TestHeroRespawning (name, 2.5)
		WaitState (2.5) -- ���� ���� ����� ����������
		LuaCreatureMoveTo( name, EnemyHeroMovePos.x, EnemyHeroMovePos.y, 3 )
	end
	return false
end

function TestHeroRespawning (name, wtime)
	if not LuaHeroIsRespawning (name) then
		WaitState (wtime) -- ���� �����-�� �����, ����� ������ ������� �� ����
		LuaHeroRespawn (name)
		LuaDebugTrace( "DEBUG: ������ �� ������ ����������� �� ����!" )
	end
end

function NeedUsePortal (nameHero, targetPoint) -- ������� ��� ��������
	x, y = LuaUnitGetPosition ( targetPoint )
	LuaHeroAIDisable( nameHero )
	LuaHeroUseConsumablePos (nameHero, "AllyTeleport", x+2, y+3)
	Wait (3) -- ���� ���� ������ ������� ���������� = (4.5)
	CameraReturn (2)
	LuaDebugTrace( "DEBUG: ���� ����� ���� �������� ����� � ������!" )
	WaitForHeroNearUnit( targetPoint, nameHero, 10 )
	LuaDebugTrace( "DEBUG: ���� ����� � ������!" )
	WaitState (0.5) -- �������� ��� ������ ���������
end
	
function Part30 ()
	LuaDebugTrace( "DEBUG: Part30 �������!" )
	while true do
		local hx, hy = LuaUnitGetPosition( "local" )
--		LuaDebugTrace( "DEBUG: ���� ����� ����� �������� � ������ �����!" )
		if ( DistanceSquared( hx, hy, enemyHeroMove.x, enemyHeroMove.y ) < 14 * 14 ) and not isCinematicCurrentlyPlayed then
			-- ������ � ������� 
				LuaDebugTrace( "DEBUG: ���! ����� ���!" )
				LuaSetCinematicPause (true)
				StartCinematic ( "TM2_D32" )
				LuaUnitClearStates ("local")
				LuaUnitClearStates (ENEMY_HERO_1)
--				LuaUnitClearStates (ENEMY_HERO_2)
				LuaUnitClearStates (ENEMY_HERO_3)
				CameraWaitPosition ( enemyHeroMove.x, enemyHeroMove.y, 3)
				CameraReturn (2)
				Wait (0.2)
				LuaDebugTrace( "DEBUG: ������ ���������." )
				LuaSetCinematicPause (false)
		        x, y = LuaUnitGetPosition (ENEMY_HERO_1)
				LuaCreatureMoveTo( ENEMY_HERO_1, x, y, 12 )				
--				LuaCreatureMoveTo( ENEMY_HERO_2, x, y, 12 )				
				LuaCreatureMoveTo( ENEMY_HERO_3, x, y, 12 )				
				LuaHeroAttackUnit (ENEMY_HERO_1, ALLY_HERO_1)
--				LuaHeroAttackUnit (ENEMY_HERO_2, ALLY_HERO_1)
				LuaHeroAttackUnit (ENEMY_HERO_3, ALLY_HERO_1)
			-- �����
			return true
		end
	SleepState()
	end
end

function AllyLevelUp(heroName, unitName, bonus, timeWait)	
	local herolvl = LuaHeroGetLevel(heroName)
	local unitlvl = LuaHeroGetLevel(unitName)
	if (herolvl+bonus)>unitlvl then -- bonus - ��� �� ������� ���� ������ ���� ���� �������, ��� ��������� �����
		WaitState (timeWait)
		for level = 0, 5 do
			for column = 0, 5 do
				if checkGender==true and level==genderLevel and column == genderColumn then
					return false
				elseif LuaHeroIsTalentActivated(unitName, level, column) == false then
					LuaHeroActivateTalent(unitName, level, column, false)
					return false
				end
			end
		end
	end
	return false
end

function HeroCanTakeTalent(heroName) -- ������� ������� �� ����� ������� ����	
	LuaDebugTrace( "DEBUG: �������, ����� ������������ ������ ��� ���?" )
	local maxLevel = LuaHeroGetTalentsLevel (heroName)
	for level = maxLevel, 0, -1 do
		for column = 0, 5 do
			canBuyTalent = LuaHeroCanActivateTalent (heroName, level, column)
			if canBuyTalent then
				LuaDebugTrace( "DEBUG: ��������� ����� �� ��� ����� level:" ..tonumber(level).. "column:" ..tonumber(column) )
				canBuyTalent = false
				LuaShowUIBlock( "ImpulseTalent", false )
				RemindTalentBuyTutorial(level, column)
				return true
			end
		end
	end
	return
end

function HeroCanTakeMoreTalent(heroName) -- � ����� ������� ������ �����
	LuaDebugTrace( "DEBUG: �������, ����� ������������ ������ ��� ���?" )
	local maxLevel = LuaHeroGetTalentsLevel (heroName)
	for level = maxLevel, 0, -1 do
		for column = 0, 5 do
			canBuyTalent = LuaHeroCanActivateTalent (heroName, level, column)
			if canBuyTalent then
				ShowBubble( "TM2_D41_2", "Talent", column, level)
				LuaDebugTrace( "DEBUG: �����, ��������� � ��������� �������" )
				CheckSuccessfulBuyTalent() -- ���� ������� �������
				HideLastBubble()
				canBuyTalent = false
				return true
			end
		end
	end
	return
end

function RemindTalentBuyTutorial(level, column)
	DrinkPotionEnd ()
	if LuaIsWindowVisible (WINDOW_INVENTORYBAR) then
		LuaShowUIBlock ("Inventory", false)
		windowInventarCloe = true
	end	
	if LuaIsWindowVisible (WINDOW_CHARSTATBAR) then 
		LuaShowUIBlock ("CharStats", false)
		windowCharStat = true
	end
	if LuaIsWindowVisible (WINDOW_SELECTIONCHARSTAT) then 
		LuaShowUIBlock ("SelectionCharStats", false)
		windowSelectCharStat = true
	end 
	if LuaIsWindowVisible (WINDOW_SELECTIONTALANTBAR) then
		LuaShowUIBlock ("SelectionTalents", false)
		windowSelectTalents = true
	end
		LuaUnitAddFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaUnitAddFlag( "local", ForbidTakeDamage )
	canBuyTalent = false
	LuaSetPause( true ) -- byGrey
	LuaUnitClearStates( "local" )
	LuaSetAdventureControlsEnabled( false, true )
	LuaAddSessionQuest( "TM2_Q40" )
	LuaBeginBlockSection() 
		LuaAddNonBlockedElement( "TalentsBar", true )
		LuaAddNonBlockedElement( "NaftaBottle", true )
		LuaAddNonBlockedElement( "Hintline", true )
		LuaAddNonBlockedElement("QuestTracker", true)
			-- ���� ��������� ������� � ���� ���������!!!
	LuaEndBlockSection( 0 )
	ShowBubble("TM2_D40_1", "PrimeBottle")
	WaitForOpenUI( WINDOW_TALENTSBAR )
	StartTrigger( DoNotCloseTalentUI ) -- ���� ����, ����� �� ������� ��������� �� �� ��������� ���������. 
	LuaDebugTrace( "DEBUG: ��������� ����� �� ��� ����� level:" ..tonumber(level).. "column:" ..tonumber(column) )
	local maxLevel = LuaHeroGetTalentsLevel ("local")
	for level = maxLevel, 0, -1 do
		for column = 0, 5 do
			canBuyTalent = LuaHeroCanActivateTalent ("local", level, column)
			if canBuyTalent then
				LuaDebugTrace( "DEBUG: ��������� ����� �� ��� ����� level:" ..tonumber(level).. "column:" ..tonumber(column) )
				canBuyTalent = false
				ShowBubble( "TM2_D41_1", "Talent", column, level)
				CheckSuccessfulBuyTalent() -- ���� ������� �������
				HideLastBubble()
				LuaDebugTrace( "DEBUG: ������� ����������" )
--				return
--			else 
--				return
				HeroCanTakeMoreTalent("local")
			end	
		end
	end
	ConstructWaitFalseConditionState (HeroCanTakeMoreTalent, "local") -- ������ ������������ ��� �����-������ ��������� ������
	if LuaIsWindowVisible ( WINDOW_TALENTSBAR ) then
		ShowBubble( "TM2_D40_4", "PrimeBottle")
		WaitForCloseUI ( WINDOW_TALENTSBAR ) -- ���� ���� ����� �� ������� ���� ���������
		HideLastBubble()
	end
	LuaShowUIBlock( "ImpulseTalent", true )
	LuaRemoveSessionQuest("TM2_Q40")
	
	LogSessionEvent ("Player bouth second part talents") -- ����������� � �����
	
	LuaClearBlocking( 0.8 )
	LuaSetPause( false ) -- byGrey
	LuaSetAdventureControlsEnabled( true, true )
		LuaUnitRemoveFlag( ALLY_HERO_1, ForbidTakeDamage )
		LuaUnitRemoveFlag( "local", ForbidTakeDamage )
	if LuaIsWindowVisible (WINDOW_INVENTORYBAR) then
		LuaShowUIBlock ("Inventory", false)
		windowInventarCloe = true
	end
	if windowCharStat then 
		LuaShowUIBlock ("CharStats", true)
		windowCharStat = false
	end
	if windowSelectCharStat then 
		LuaShowUIBlock ("SelectionCharStats", true)
		windowSelectCharStat = false
	end 
	if windowSelectTalents then
		LuaShowUIBlock ("SelectionTalents", true)
		windowSelectTalents = false
	end	
end

function HintBuyIt()	
	if LuaGetControlStyle() then   -- ���/��� ��������
		ShowHintline( "TM2_H01_LMC", true, "RightClick" )
--		LuaStartDialog( "TM1_D02_LMC" )
	else 
		ShowHintline( "TM2_H01_RMC", true, "LeftClick" )
	end
end

function HintTakeIt()	
	if LuaGetControlStyle() then   -- ���/��� ��������
		ShowHintline( "TM2_H02_RMC", true, "LeftClick" )
--		LuaStartDialog( "TM1_D02_LMC" )
	else 
		ShowHintline( "TM2_H02_LMC", true, "RightClick" )
	end
end

function ForbidZone( zoneName )
	if IsHeroInArea( "local", zoneName.x , zoneName.y, zoneName.radius ) then 
		LuaUnitClearStates( "local" )
--		return true
	end
	return false
end

function EnemyUnitsDead( firstNames, secondNames )
	while true do
		if not firstNamesDead then
			local dead, found = LuaUnitIsDead( firstNames )
			if dead and found then
				firstNamesDead=true
				MarkEnemy( firstNames, false )
				LuaHeroSetForbidRespawn (firstNames, true) 	
				LuaDebugTrace( "DEBUG: ���� firstNames!" )
				LuaRemoveSessionQuest( KillEnemyRatcatcher )
				if not secondNamesDead then
					MarkEnemy( secondNames, true )
					secondDeadLast = true
				end
			end
		end
		if not secondNamesDead then
			local dead, found = LuaUnitIsDead( secondNames )
			if dead and found then
				secondNamesDead=true
				MarkEnemy( secondNames, false)	
				LuaHeroSetForbidRespawn (secondNames, true)
				LuaDebugTrace( "DEBUG: ���� secondNames!" )	
				LuaRemoveSessionQuest( KillEnemyRockman )
				if not firstNamesDead then
					MarkEnemy( firstNames, true )
					firstDeadLast = true
				end		
		
			end
		end
		local dead, found = LuaUnitIsDead( ALLY_HERO_1 )
		if firstNamesDead==true and secondNamesDead==true then
			LuaDebugTrace( "DEBUG: ��� ��� ������!" )	
			return true
		elseif dead and found then
			LuaDebugTrace( "DEBUG: ������� ���� ���� ������!" )
			if not firstNamesDead then
				LuaDebugTrace( "DEBUG: ������ ���� �� ���� � ���� ������!" )
				LuaHeroAttackUnit (firstNames, "local")
			end
			if not secondNamesDead then
				LuaDebugTrace( "DEBUG: ������ ���� �� ���� � ���� ������!" )
				LuaHeroAttackUnit (secondNames, "local")
			end
			return false
		else
			return false
		end
--		SleepState()
	end
end

function EnemyUnitsWellDone()
	if firstNamesDead==true and secondNamesDead==true then
		LuaDebugTrace( "DEBUG: �����������, ��� ��� ��� ������!" )	
		if firstDeadLast then
			PlayCinematic ("TM2_D34") -- ���� ��������� ���� �������� (����������� � �����)
		else
			PlayCinematic ("TM2_D36") -- � ��������� ������� ������, ��� ��������� ���� ��(����������� � �����)		
		end
		return true
	else
		return false
	end
	LuaDebugTrace( "DEBUG: ��������� �� ��������" )
end

function NameAllLivingCreepsFromSpawner( spawnerName )
	local lastWaveNumb = LuaSpawnerGetLastWave( spawnerName )
	local arr = {}
	local ii = 1
	local creepsInWave = 10
	for i = 1, lastWaveNumb do
		for j = 1, creepsInWave do
			localName = spawnerName .. "_w" .. tostring(i) .. "_c" .. tostring(j)
			if not LuaUnitIsDead( localName ) then
--				local numberInArray = (i-1)*creepsInWave + j 
				arr[ ii ] = localName
				ii = ii +1
			end
		end
	end	
	return arr
end

function WaitHeroNearUnit( heroName, distance, unitCount)
	while true do
		if isCinematicCurrentlyPlayed == false then
			LuaDebugTrace( "DEBUG:WaitHeroNearUnit" )
			local creepTypeMask = BitMask( UnitTypeCreep, UnitTypeSiegeCreep )
			local factionMask = 2 ^ FACTION_ENEMY
			LuaDebugTrace( "DEBUG:WaitHeroNearUnit:" .. tostring( creepTypeMask ))
			LuaDebugTrace( "DEBUG:WaitHeroNearUnit:" .. tostring( factionMask ))
			while true do
				x, y = LuaUnitGetPosition ( heroName )
				local CreepsNumb = LuaGetUnitsInArea( factionMask, creepTypeMask, x, y, distance)
				LuaDebugTrace( "DEBUG:WaitHeroNearUnit:" .. tostring( CreepsNumb ) )
				LuaDebugTrace( "DEBUG:WaitHeroNearUnit:" .. tostring( x ) .. ":" .. tostring( y ) )
				if CreepsNumb >= unitCount then
					return
				end
				SleepState()
			end
		end
		SleepState()
	end
end

function GUITeamBlock()
--	LuaCameraLock( true )
	isCinematicCurrentlyPlayed = true
	Wait (1) -- ��������, ����� �� ���� ������� �������� � ����� ���������
	CheckWindowsOpen ()
	LuaSetPause (true)
	DrinkPotionEnd ()
	LuaSetAdventureControlsEnabled( false, true )
	LuaBeginBlockSection() 
		LuaAddNonBlockedElementHero( ENEMY_HERO_1, true )
		LuaAddNonBlockedElementHero( ENEMY_HERO_2, true )
		LuaAddNonBlockedElementHero( ENEMY_HERO_3, true )
		LuaAddNonBlockedElementHero( "local", true )
		LuaAddNonBlockedElementHero( ALLY_HERO_1, true )
		LuaAddNonBlockedElementHeroBubble (ENEMY_HERO_1, true)
		LuaAddNonBlockedElement ("QuestTracker", true)
		-- ���� ��������� ������� � ���� ���������!!!
	LuaEndBlockSection( 0 )
--		LuaShowTutorialHeroHighlight ( ENEMY_HERO_1, true )
		ShowBubbleButton( "TM2_D26_1", "Hero", ENEMY_HERO_1 ) -- ���������� ������� ������� ���������
		WaitForBubbleClick()
			LuaAddNonBlockedElementHeroBubble (ALLY_HERO_1, true)
			LuaAddNonBlockedElement ("QuestTracker", true)
--		LuaShowTutorialHeroHighlight ( ENEMY_HERO_1, false ) 
		ShowBubbleButton( "TM2_D26_2", "Hero", ALLY_HERO_1 ) -- �����, ���������� ������� ������ �����
		WaitForBubbleClick()
	LuaClearBlocking( 0 )
	LuaSetAdventureControlsEnabled( true, true )
	LuaSetPause (false)
	CheckWindowsEnd ()
	isCinematicCurrentlyPlayed = false
	-- ������ ������� � ����� ����� �������
end

function AllyHappyInTower (heroName1, heroName2, checkPoint, distance)
	LuaHeroAIDisable ( heroName1 )
	LuaUnitAddFlag( heroName1, ForbidAutoAttack )
	LuaCreatureMoveTo( heroName1, checkPoint.x, checkPoint.y, distance ) -- ���������� �����
	while not IsHeroInArea( heroName1, checkPoint.x, checkPoint.y, distance ) do
		SleepState()
	end
	WaitForUnitIdle( heroName1 )
	HeroTalking ( heroName2, heroName1 )
	Wait(rotateTime) --���� ��������� ��������
	LuaForceAnimation (heroName1, "happy", 3) -- ��������� �������� �����, ������ �������� :)
end

function AdvancedTalentBuyTutorial()
	if LuaIsWindowVisible (WINDOW_INVENTORYBAR) then
		LuaShowUIBlock ("Inventory", false)
		windowInventarCloe = true
	end
	if LuaIsWindowVisible (WINDOW_CHARSTATBAR) then 
		LuaShowUIBlock ("CharStats", false)
		windowCharStat = true
	end
	if LuaIsWindowVisible (WINDOW_SELECTIONCHARSTAT) then 
		LuaShowUIBlock ("SelectionCharStats", false)
		windowSelectCharStat = true
	end 
	if LuaIsWindowVisible (WINDOW_SELECTIONTALANTBAR) then
		LuaShowUIBlock ("SelectionTalents", false)
		windowSelectTalents = true
	end
	LuaShowUIBlock( "ImpulseTalent", false )
	talentTutorialOver = false
	LuaSetPause( true ) -- by Grey
	LuaUnitClearStates( "local" )
	LuaSetAdventureControlsEnabled( false, true )
	LuaAddSessionQuest( "TM2_Q40" ) -- ����������� � �����
	LuaBeginBlockSection() 
		LuaAddNonBlockedElement( "TalentsBar", true )
		LuaAddNonBlockedElement( "NaftaBottle", true )
		LuaAddNonBlockedElement( "Hintline", true )
		LuaAddNonBlockedElement("QuestTracker", true)
		-- ���� ��������� ������� � ���� ���������!!!
	LuaEndBlockSection( 0 )
	WaitState (0.6)
	HideLastBubble() -- ������ ���� ��� �������, ���� ����� �� ������� ��� ���
	AddSetPrime( "local", 300)
	AddSetPrime( ALLY_HERO_1, 0)
		Wait(0.1)	
	ShowBubble("TM2_D40_5", "PrimeBottle")
	WaitForOpenUI( WINDOW_TALENTSBAR )
	StartTrigger( DoNotCloseTalentUI ) -- ���� ����, ����� �� ������� ��������� �� �� ��������� ���������. 
	ShowBubble( "TM2_D40_2", "Talent", 1, 0) -- ����������� � �����
	CheckSuccessfulBuyTalent() -- ���� ������� �������
	talentTutorialOver = true
	Wait(0.1) -- �����, ����� ���� ����� ��������� ��� LuaGetTalentActionBarIndex
	firstTalent = LuaGetTalentActionBarIndex(1, 0) -- �������� ����� ����� � ActionBare
--	firstTalent = 2 -- ��������!
		LuaAddNonBlockedElementActionBar( firstTalent, true )
	LuaShowTutorialActionBarItemHighlight ( firstTalent, true )
	ShowBubbleButton( "TM2_D40_3", "ActionBar", firstTalent)
	WaitForBubbleClick()
	HideLastBubble()
	LuaShowTutorialActionBarItemHighlight ( firstTalent, false )
	if LuaIsWindowVisible ( WINDOW_TALENTSBAR ) then
		ShowBubble( "TM2_D40_4", "PrimeBottle")
		WaitForCloseUI ( WINDOW_TALENTSBAR ) -- ���� ���� ����� �� ������� ���� ���������
		HideLastBubble()
	end
	LuaClearBlocking( 0.8 )
	LuaRemoveSessionQuest("TM2_Q40")
	HideLastBubble()
	LuaSetAdventureControlsEnabled( true, true )
	LuaSetPause( false )
	LuaShowUIBlock( "ImpulseTalent", true )
	if windowInventarCloe then
		LuaShowUIBlock ("Inventory", true)
		windowInventarCloe = false
	end
	if windowCharStat then 
		LuaShowUIBlock ("CharStats", true)
		windowCharStat = false
	end
	if windowSelectCharStat then 
		LuaShowUIBlock ("SelectionCharStats", true)
		windowSelectCharStat = false
	end
	if windowSelectTalents then
		LuaShowUIBlock ("SelectionTalents", true)
		windowSelectTalents = false
	end	
end

function DoNotCloseTalentUI()
	if talentTutorialOver then return end
	if not LuaIsWindowVisible(WINDOW_TALENTSBAR) then
		LuaShowBubble( "PrimeBottle", true, "TM2_D40_5_Hint", "", 2) -- ���������� ����� ������ �������, � �� �������, �.�. ������� ����� ��������� � ��������������� ������ � ������� ������ �����
	else
		LuaShowBubble( "PrimeBottle", false, "TM2_D40_5_Hint", "", 2) -- ���������� ����� ������ �������, � �� �������, �.�. ������� ����� ��������� � ��������������� ������ � ������� ������ �����
	end
end

function DoNotCloseShopUI()
	if ShopTutorialOver then return true end
	if not LuaIsWindowVisible(WINDOW_SHOPBAR) and not showHintBuyIt then
		showHintBuyIt = true
		HintBuyIt ()
	elseif LuaIsWindowVisible(WINDOW_SHOPBAR) and showHintBuyIt then
		ShowHintline("")
		showHintBuyIt = false
	end
end

function BuyGender () -- Part 3: Buy Gender
	level, column = FindGender( "local" )
	if level >= 0 then
		LuaBeginBlockSection() 
			LuaAddNonBlockedElement( "TalentsBar", true )
			LuaAddNonBlockedElement( "NaftaBottle", true )
			LuaAddNonBlockedElement( "Hintline", true )
			LuaAddNonBlockedElement("QuestTracker", false)
			-- ���� ��������� ������� � ���� ���������!!!
		LuaEndBlockSection( 0 )
		WaitState (0.6)

		LuaSetAdventureControlsEnabled( false, true )
		LuaShowUIBlock( "ImpulseTalent", false )
		AddSetPrime( "local", 250)
		AddSetPrime( ALLY_HERO_1, 0)
		LuaSetPause (true)
		LuaAddSessionQuest( HeroGenderQuest )
		LuaDebugTrace( "DEBUG: ���� ��������� ������!" )
			ShowBubble( HeroGender, "PrimeBottle")
		WaitForOpenUI( WINDOW_TALENTSBAR )
		StartTrigger( DoNotCloseTalentUI )
			ShowBubble( HeroGenderHint, "Talent", column, level)
		ConstructWaitConditionState( CheckClickedTalent, level, column )
			HideLastBubble()
			talentTutorialOver = true	
		if LuaIsWindowVisible ( WINDOW_TALENTSBAR ) then
			ShowBubble( "TM2_D40_4", "PrimeBottle")
			WaitForCloseUI ( WINDOW_TALENTSBAR ) -- ���� ���� ����� �� ������� ���� ���������
			HideLastBubble()
		end
		LuaClearBlocking( 0 )
		WaitState (0.3)
		LuaSetPause (false)
		LuaSetAdventureControlsEnabled( true, true )
		LuaRemoveSessionQuest( HeroGenderQuest )
	end
end

function WaitCinematic ()
	local state = function (...)
		if func == nil then
			LuaDebugTrace( debug.traceback() )
		end
		while true do
		LuaDebugTrace( "DEBUG: ����, ���� ��������� ����������" )
			if not isCinematicCurrentlyPlayed then
				return
			end
			SleepState()
		end
		AddStateTop( state, ... )
		SleepState()
	end
end

function RemoveWarfogAll( warfogState ) -- ���� true - ��������� ������ �� ��� ����� ��� �������, ��� �� ��� ���� �� � ������ "MainA"
	if warfogState then
		LuaUnitApplyApplicatorFromUnit( ALLY_MAINBUILDING, "local", "RemoveWarfog")
	else
		LuaUnitRemoveApplicator( ALLY_MAINBUILDING, "RemoveWarfog")
	end
	
end

function RemoveWarfogTarget( targetName, warfogTargetState ) -- ���� true - ��������� ������ ��� ����� 
	if warfogTargetState then
		LuaUnitApplyApplicatorFromUnit( targetName, "local", "RemoveShortWarfog")
	else
		LuaUnitRemoveApplicator( targetName, "RemoveShortWarfog")
	end
	
end

function CreepControl2( spawnerName, creepCap )
	if endCreepControl then 
		LuaDebugTrace("DEBUG: ������� CreepContorl2 ���������� ���� ������ ")
		return true
	end
	local creepsArray = NameAllLivingCreepsFromSpawner( spawnerName )
	if # creepsArray > creepCap then 
		LuaDebugTrace("DEBUG: ������� CreepContorl2 ����� ������� � ����: " ..tostring(# creepsArray).." - ������� ����" )
		LuaKillUnit( creepsArray[1] )
	end
end

function UnitImmortalCheat(unitName, warnPercent) -- �������, ������� ������ ����� ����������
	--if not unicId then
	if heroesImmortal then
		local health, maxHealth = LuaUnitGetHealth( unitName )
		local bonusHealthRegen = 5
		local currentPercent = health / maxHealth
		local damageDecresePercent = (1 - currentPercent) * 100 - 20
		LuaSetUnitStat( unitName , 27, damageDecresePercent)
		LuaSetUnitStat( unitName , 28, damageDecresePercent)
		--LuaDebugTrace("DEBUG: ������� UnitImmortalCheat ��� ".. " ��������")
		if ( currentPercent <=  warnPercent / 100 ) then
			LuaSetUnitStat( unitName , 11, bonusHealthRegen)
		else 
			LuaSetUnitStat( unitName , 11, 2)	
		end
	else
		LuaDebugTrace("DEBUG: ������� UnitImmortalCheat ���������� ")
		return true
	end
end

function CheckWindowsOpen () -- ���� ������� ���� ��������, ������������� ��������� ���
	if LuaIsWindowVisible (WINDOW_TALENTSBAR) and LuaIsWindowVisible (WINDOW_INVENTORYBAR) then 
		LuaShowUIBlock ("Talents", false)
		LuaShowUIBlock ("Inventory", false)
		windowCloe = true
	elseif LuaIsWindowVisible (WINDOW_INVENTORYBAR) then
		LuaShowUIBlock ("Inventory", false)
		windowInventarCloe = true
	elseif LuaIsWindowVisible (WINDOW_TALENTSBAR) then 
		LuaShowUIBlock ("Talents", false)
		windowTalentsCloe = true
	end
	if LuaIsWindowVisible (WINDOW_CHARSTATBAR) then 
		LuaShowUIBlock ("CharStats", false)
		windowCharStat = true
	end
	if LuaIsWindowVisible (WINDOW_SELECTIONCHARSTAT) then 
		LuaShowUIBlock ("SelectionCharStats", false)
		windowSelectCharStat = true
	end 
	if LuaIsWindowVisible (WINDOW_SELECTIONTALANTBAR) then
		LuaShowUIBlock ("SelectionTalents", false)
		windowSelectTalents = true
	end
end

function CheckWindowsEnd () -- ���� ������� ���� ��������, ������������� ��������� ��� (���������� ��, ��� ���� ���������)
	if windowTalentsCloe then 
		LuaShowUIBlock ("Talents", true)
		windowTalentsCloe = false
	elseif windowInventarCloe then
		LuaShowUIBlock ("Inventory", true)
		windowInventarCloe = false
	elseif windowCloe then
		LuaShowUIBlock ("Talents", true)
		LuaShowUIBlock ("Inventory", true)
		windowCloe = false
	end	
	if windowCharStat then 
		LuaShowUIBlock ("CharStats", true)
		windowCharStat = false
	end
	if windowSelectCharStat then 
		LuaShowUIBlock ("SelectionCharStats", true)
		windowSelectCharStat = false
	end 
	if windowSelectTalents then
		LuaShowUIBlock ("SelectionTalents", true)
		windowSelectTalents = false
	end	
end

function FirstTerrainOnCinema (dialogName)
	LuaDebugTrace( "Debug: ������ �� ������������ ���������� "..tostring(dialogName))
	LuaSetAdventureControlsEnabled( false, false )
	isCinematicCurrentlyPlayed = true
	local hx, hy = LuaCameraGetPos ()
	local x, y = LuaUnitGetPosition ("local")
	if not ( DistanceSquared( hx, hy, x, y ) < 0.01 ) and cameraReturn then -- �� ������ ���� ����� ������� ������
		CameraReturn (0.4)
	end
	currentCinematicName = dialogName
	LuaStartCinematic ( currentCinematicName )
end