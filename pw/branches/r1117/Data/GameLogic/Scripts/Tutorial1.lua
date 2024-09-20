-- Tutorial Mission 1 script v.1.8 (by Grey)

include ("GameLogic/Scripts/Debug.lua")
include ("GameLogic/Scripts/StatesManager.lua")
include ("GameLogic/Scripts/Common.lua")
include ("GameLogic/Scripts/Consts.lua")

M_PI2 = 1.57

function Init()
	LuaGroupHide( "Mission2", true )
	LuaSetSpawnCreeps( false )
	AddStateEnd( PlotObjectives )
	
    rotateTime = 0.7
	rotateTimeTunder = 0.5 -- c���������� ����� ��������� �����, ���� ����� = ����
	creepCap = 14 -- ����� �� ���-�� ������ 
	
	debugModeOn = false

	debug1Intro = false
	debug2Jaba = false
	debug10FirstCreeps = false
--	debug3Prime = false
	debug4Warlord = false
	debug5Briefing = false
	debug6Enemy = false
	
	debug7TalentTutor1 = false
	debug8TalentTutor2 = true
	debugLastHits = false
	LuaEnableEventLogging (true)
	
end

function PlotObjectives()
	LuaDebugTrace ("   ------ ��� ������ ������ �������� �����  ----------------------------------------------------------------------")
	LuaSetAdventureControlsEnabled( true, true ) -- ��� ����� ��������, ���� ���� �� �������� ������ ����� ��������
if true then ------�������� ���� ����������
	LuaSetAchievmentsEnabled( false )
	
	if LuaIsHeroMale("local") then  -- ��������� ����������� ������ ���� ��� ���� ������ (�������� ��������� � �������)
		LuaLoadTalantSet( "local", "TM1_Tunder_Set" )
		LuaDebugTrace( "DEBUG: ����� = ���.") 
	else
		LuaLoadTalantSet( "local", "TM1_Firefox_Set" )
		LuaDebugTrace( "DEBUG: ����� = ���.") 
	end

	FACTION_PLAYER = LuaGetLocalFaction()
	FACTION_ENEMY = 3 - FACTION_PLAYER
	function selectByFaction( a, b ) 	-- select by player faction
		if ( FACTION_PLAYER == 1 ) then
			return a
		else
			return b
		end
	end

	ALLY_HERO = selectByFaction( "01", "11" )
	ALLY_HERO_FROG = selectByFaction( "02", "12" )
	ENEMY_HERO = selectByFaction( "10", "00" )
	ENEMY_HERO_USELESS_1 = selectByFaction( "11", "01" )
	ENEMY_HERO_USELESS_2 = selectByFaction( "12", "02" )	
	ENEMY_BARRACKS = selectByFaction( "BarracksB_m1", "BarracksA_m1" )
	ENEMY_MAINBUILDING = selectByFaction( "MainB", "MainA" )
	ENEMY_TOWER = selectByFaction( "TowerB1_m1", "TowerA1_m1" )
	ALLY_MAINBUILDING = selectByFaction( "MainA" , "MainB" )
	ALLY_MAIN_SPAWNER = selectByFaction( "TM1_MainSpawner_D", "TM1_MainSpawner_A" )
	ENEMY_MAIN_SPAWNER = selectByFaction( "TM1_MainSpawner_A", "TM1_MainSpawner_D" )	
	ENEMY_CREEP_MELEE = selectByFaction( "CreepMeleeB", "CreepMeleeA" )
	ENEMY_CREEP_RANGED = selectByFaction( "CreepRangeB", "CreepRangeA" )
	ALLY_CREEP_MELEE = selectByFaction( "CreepMeleeA", "CreepMeleeB" )
	ALLY_CREEP_RANGED = selectByFaction( "CreepRangeA", "CreepRangeB" )
	
	if ( FACTION_PLAYER == 1 ) then 	-- set sight ranges
		LuaSetUnitStat( "BarracksA_m1", 14, 6 )
		LuaSetUnitStat( "TowerA1_m1",   14, 10 )
		LuaSetUnitStat( "MainA",        14, 33 )
		LuaSetUnitStat( "FountainA",    14, 20 )
		LuaSetUnitStat( "local",        14, 15 )
	else
		LuaSetUnitStat( "BarracksB_m1", 14, 6 )
		LuaSetUnitStat( "TowerB1_m1",   14, 10 )
		LuaSetUnitStat( "MainB",        14, 33 )
		LuaSetUnitStat( "FountainB",    14, 20 )
		LuaSetUnitStat( "local",        14, 15 )
	end
	
	LuaSetUnitStat( "FountainA", 2, 0 )
	LuaSetUnitStat( "FountainB", 2, 0 )
	LuaSetUnitStat( "TowerA1_m1", 0, 1200 )
	LuaSetUnitStat( "TowerB1_m1", 0, 1200 )
	LuaSetUnitStat( "BarracksB_m1", 0, 1000 )
	LuaSetUnitStat( "BarracksA_m1", 0, 1000 )
	LuaSetUnitStat( "MainA", 0, 900 )
	LuaSetUnitStat( "MainB", 0, 900 )
	LuaSetUnitStat( "MainA", 15, 110 )
	LuaSetUnitStat( "MainB", 15, 110 )
	EnemyCreep1 = selectByFaction( "M1_EnemyCreepA1", "M1_EnemyCreepB1" )
	
	LuaCameraObserveUnit( "local" )
	LuaHeroAddFlag( "local", ForbidAutoAttack )
	LuaHeroAddFlag( "local", ForbidDeath )
	StartTrigger( HeroImmortalCheat )
	endCreepControl = false
		
	cinemaPos1 = GetScriptArea( selectByFaction( "FrogCinema1_A_m1", "FrogCinema1_B_m1" ) )
	cinemaPos2 = GetScriptArea( selectByFaction( "FrogCinema2_A_m1", "FrogCinema2_B_m1" ) )
	cinemaPos3 = GetScriptArea( selectByFaction( "FrogCinema3_A_m1", "FrogCinema3_B_m1" ) )
	cinemaPos4 = GetScriptArea( selectByFaction( "FrogCinema4_A_m1", "FrogCinema4_B_m1" ) )
	cinemaPos5 = GetScriptArea( selectByFaction( "FrogCinema5_A_m1", "FrogCinema5_B_m1" ) )
	cinemaPos6 = GetScriptArea( selectByFaction( "M1_FrogCinema6_D", "M1_FrogCinema6_A" ) )
	riverTalk1Pos = GetScriptArea( selectByFaction( "M1_FrogCinema7_D", "M1_FrogCinema7_A" ) )
	riverTalk2Pos = GetScriptArea( selectByFaction( "M1_FrogCinema8_D", "M1_FrogCinema8_A" ) )
	Obj1Pos = GetScriptArea( selectByFaction( "ObjectiveA1_m1", "ObjectiveB1_m1" ) )
	Obj3Pos = GetScriptArea( selectByFaction( "ObjectiveA3_m1", "ObjectiveB3_m1" ) ) -- ����� �������� �����-������. ������ ������������� � ������ ��� ���, ������ ������ � ���������� ��� ����������� ����
	lastCinemaPos0 = GetScriptArea( selectByFaction( "M1_EnemyCreepB1", "M1_EnemyCreepA1" ) )	
--	lastCinemaPos1 = GetScriptArea( selectByFaction( "FrogStartPlaceB_m1", "FrogStartPlaceA_m1" ) ) -- ����� �������� ��������� �������. ���������� � ������ ��� ����� �������. 
	lastCinemaPos1 = GetScriptArea( selectByFaction( "FrogCinema1_A_m1", "FrogCinema1_B_m1" ) )
	lastCinemaPos2 = GetScriptArea( selectByFaction( "ObjectiveB1_m1", "ObjectiveA1_m1" ) )
	
	eliteTeleportPoint = GetScriptArea( selectByFaction( "M1_ForbidZone1_A", "M1_ForbidZone1_D" ) )
	--commonTeleportPoint = GetScriptArea( selectByFaction( "M1_EnemyCreepA2", "M1_EnemyCreepB2" ) ) -- ���������� ����� ������ ��������� ������ ��� ������� ������ ����� ������ �� ����� ������ (����� ��� ����� ���� �� ������)
	commonTeleportPoint = GetScriptArea( selectByFaction( "M1_TeleportPointForCreeps_D", "M1_TeleportPointForCreeps_A" ) )
	
	blockZone1 = GetScriptArea( selectByFaction( "M1_ForbidZone1_D", "M1_ForbidZone1_A" ) )
	blockZone2 = GetScriptArea( selectByFaction( "M1_ForbidZone2_D", "M1_ForbidZone2_A" ) )	
	BLOCK_AREA_1 = selectByFaction( "TM1_BlockArea1_D", "TM1_BlockArea1_A" )
	BLOCK_AREA_2 = "TM1_BlockAreaCentral"
	BLOCK_AREA_3 = selectByFaction( "TM1_BlockArea1_A", "TM1_BlockArea1_D" )
	
-- ����������� � ������ ��������� ������
	allyHeroPos = GetScriptArea( selectByFaction( "AllyHeroA_m1", "AllyHeroB_m1" ) )
	frogStartPos = GetScriptArea( selectByFaction( "FrogStartPlaceA_m1", "FrogStartPlaceB_m1" ) )
	LuaCreatureTeleportTo( ALLY_HERO, allyHeroPos.x, allyHeroPos.y ) -- objective 3
	LuaCreatureTeleportTo( ALLY_HERO_FROG, frogStartPos.x, frogStartPos.y )
	LuaSetUnitStat( ALLY_HERO_FROG, 0, 260 )
	LuaSetUnitStat( ALLY_HERO_FROG, 3, 50 )
	LuaHeroSetForbidRespawn( ALLY_HERO_FROG, true )
	LuaUnitApplyApplicatorFromUnit( ALLY_HERO_FROG, ENEMY_TOWER, "DamageOnlyFromSenderAppl" )	
	LuaSetUnitStat( "local", 15, 80 )
	LuaSetUnitStat( "local", 16, 70 )
	LuaSetUnitStat( "local", 10, 0 )
	LuaSetUnitStat( ALLY_HERO, 10, 0 )
	LuaSetUnitStat( ALLY_HERO, 12, 0 )
	LuaCreatureHide( ALLY_HERO, true ) -- ������ ������� �� ���� �� �������
	LuaCreatureHide( ENEMY_HERO_USELESS_1, true )
	LuaCreatureHide( ENEMY_HERO_USELESS_2, true )
	LuaSetUnitStat( ENEMY_MAINBUILDING, 2, 12 ) -- ��������� �� ��������� �������� ���� ��� ������
	
-- ������ ���� �� ����� ��������
	LuaShowAllUIBlocks( false )
	LuaShowUIBlock( "TalentsSetBlock", false )
	LuaShowUIBlock( "ActionBarEscBtn", true )
	LuaShowUIBlock( "PlayerHeroBlock", true )
	LuaShowUIBlock( "ActionBarTalentBtn", false ) -- �������� ����� ������� ������ ����� ����� ������
	LuaShowUIBlock( "SelectionBlock", false )
  LuaShowUIBlock( "ChatBlock", false )
  LuaShowUIBlock( "LockActionBar", false )
	
	LuaBlockActionBarChange(true) -- � ��������� �������� ������������ ������� �� ����-���� (��� ������� ��)
end -- ����� ����������

 --------------------------------------------------------------------------------------------------------------------------------------------------
 -- �������� ���� ---------------------------------------------------------------------------------------------------------------------------------

	LuaCameraObserveUnit( "local" )

	if not debugModeOn or debug1Intro then    -- ������ ���������. � ��������� �������
		RemoveWarfogAll( true ) 
		cameraName = selectByFaction( "/Maps/Tutorial/cameraA1.CSPL", "/Maps/Tutorial/cameraB1.CSPL" )
		cameraTime = selectByFaction( 44, 41 )
		StartCinematic ("TM1_D01")   -- ����������� � �����
			LuaSplineCameraTimed( cameraName, cameraTime)
		EndCinematic()
		RemoveWarfogAll( false )	
	end
	
	LuaAddSessionQuest( selectByFaction("TM1_Q01p_D", "TM1_Q01p_A" ) )
	LuaAddSessionQuest( "TM1_Q03s" )
 	HintArrow( Obj1Pos, selectByFaction(3.5 , 2) )
	PlaceObjectiveMarker( "obj1", Obj1Pos.x, Obj1Pos.y )
	GreyWait( 2, HintAboutMove )-- ���/��� �������� ��� ��������  
	
 ----objective: Move and reveal warfog ---------------------------------------	
	WaitForUnitInArea( "local", Obj1Pos )  -- ���� ������� ����� � ����� ����� ����
	GreyWaitEnd()
	LuaUnitClearStates( "local" )
	RemoveObjectiveMarker( "obj1" )
	HintArrow("")
	ShowHintline("")
	LuaRemoveSessionQuest( "TM1_Q03s" )
	LuaAddSessionQuest( "TM1_Q04s" ) -- ����������� � �����
	
	Obj2Pos = GetScriptArea( selectByFaction( "ObjectiveA2_m1", "ObjectiveB2_m1" ) )
	
  
	if not debugModeOn or debug10FirstCreeps then   --------------- ������� ��������� �����������	 --------------
		x, y = LuaGetScriptArea( EnemyCreep1 )
		LuaCreateCreep( "Creep1_1", ENEMY_CREEP_MELEE, x, y, FACTION_ENEMY, selectByFaction( -M_PI2, M_PI2 ) )
		LuaCreateCreep( "Creep1_2", ENEMY_CREEP_RANGED, x, y - 3, FACTION_ENEMY, selectByFaction( -M_PI2, M_PI2 ) )
		DecreaseUnitSight( "Creep1_1", true )
		DecreaseUnitSight( "Creep1_2", true )
		LuaUnitApplyApplicatorFromUnit( "Creep1_1", "local", "DamageOnlyFromSenderAppl" )
		LuaUnitApplyApplicatorFromUnit( "Creep1_2", "local", "DamageOnlyFromSenderAppl" )
	end
  
------- ������ � �����	 -----------
	if not debugModeOn or debug2Jaba then
		NeedToPauseAfterPhrases( "D03_EndConversation", "D03_HalfNarrator" )
		StartCinematic ("TM1_D03") 
			HeroTalking( "local", ALLY_HERO_FROG )
			
			WaitForPhraseEnd( "D03_EndConversation" )
			--LuaPauseDialog( true )
			RotateHeroTo( "local", Obj2Pos )
			RotateHeroTo( ALLY_HERO_FROG, Obj2Pos )
			Wait(rotateTime) --���� ��������� ��������
			WaitForMoveTo( ALLY_HERO_FROG, Obj2Pos, 11 )
			Wait(2)
			CameraMove( Obj2Pos.x, Obj2Pos.y, 2.5 )
			LuaPauseDialog( false )
			
			WaitForPhraseEnd( "D03_HalfNarrator" )
			--LuaPauseDialog( true )
			Wait(3.5)
			PlaceObjectiveMarker( "obj2", Obj2Pos.x, Obj2Pos.y )
			LuaPauseDialog( false )
	    EndCinematic()
		CameraReturn( 1 )
	else
		PlaceObjectiveMarker( "obj2", Obj2Pos.x, Obj2Pos.y )
	end
	HintArrow( Obj2Pos, 0 )
	
	LogSessionEvent ("Wait hero in the second point") -- ����������� � �����
	
	WaitForUnitInArea( "local", Obj2Pos ) -- ���� ���� ����� �������� � ������� �������
	LuaUnitClearStates( "local" )
	RemoveObjectiveMarker( "obj2" )
	HintArrow("")
	LuaRemoveSessionQuest( "TM1_Q04s" )
	--LuaStartDialog( "TM1_D04" )
	
		

    if not debugModeOn or debug10FirstCreeps then -- ��������� ����������. �������� �����. ---------------------------------------
		LuaAddSessionQuest( "TM1_Q05s" ) -- ����������� � �����
		MarkEnemy( "Creep1_1", true )
		MarkEnemy( "Creep1_2", true )
		StartTrigger( Kill2CreepsObjective )	
		HintAboutAttack()

		WaitForHeroDealedDamage( "local", 5 )
		--GreyWaitEnd()	 -- �� ������ ����� �� �����
		DecreaseUnitSight( "Creep1_1", false )
		DecreaseUnitSight( "Creep1_2", false )	
	--MarkEnemy( "Creep1_1", false )
	--MarkEnemy( "Creep1_2", false )
	--Wait ( 2 )
	--LuaStartDialog( "TM1_D04_3" )

-- �������� ��� ����� ������ ����		
		ShowHintline( "TM1_D04_4", false)
		LuaDebugTrace( "DEBUG: �������� �������� ��� ����� ��") 
		GreyWait( 6, ShowHintline, "")

		WaitForUnitsDead( { "Creep1_1", "Creep1_2" } )
--		ShowHintline( "" )
		LuaRemoveSessionQuest( "TM1_Q05s" )
	end
	Wait(0.3) 
	LuaGroupHide( BLOCK_AREA_1 , true ) -- ��������� ������ ������

-- �������� ������� ������� ---------------------------------------
if not debugModeOn or debug7TalentTutor1 then -- �������� ������� ������� -------		
	LuaSetPause( true ) 
	LuaSetAdventureControlsEnabled( false, true )
	LuaUnitClearStates( "local" )
 ----�������� ����������� ���������
	LuaShowUIBlock( "ActionBarBlock", true )
	LuaShowUIBlock( "MoneyBlock", true )
	--	LuaShowUIBlock( "ImpulseTalent", true )
	LuaAddSessionQuest( "TM1_Q11s" )  -- ����������� � �����
 ----������ �����, ���� �������������� ��� ��������� ������
	SetPrime( 315 )
	LuaBeginBlockSection()
		LuaAddNonBlockedElement( "NaftaBottle", true )
		LuaAddNonBlockedElement( "Hintline", true )
	LuaEndBlockSection( 0.5 )
	LuaDebugTrace( "DEBUG: 1" )
	ShowBubbleButton("TM1_D05_1", "PrimeBottle" )
	
 ----������ �����, "���� ���������� ������"
	WaitForBubbleClick()
	LuaDebugTrace( "DEBUG: 22" )
	LuaShowUIBlock( "ImpulseTalent", true )
	LuaClearBlocking( 0 )
	LuaBeginBlockSection()
		LuaAddNonBlockedElement( "ImpulseTalent", true )
		LuaAddNonBlockedElement( "Hintline", true )
	LuaEndBlockSection( 0 )	
	LuaDebugTrace( "DEBUG: 4444" )
	ShowBubble("TM1_D05_2", "ImpulseTalent" ) -- ����������� � �����
	LuaDebugTrace( "DEBUG: Activate talent 0,0" )
	
 ----������ �����, ����-���� �� ������� ��� ������ � ���� ����
	ConstructWaitConditionState( LuaHeroIsTalentActivated, "local", 0 , 0)
	
 	LuaUnitApplyApplicatorFromUnit( "local", ALLY_MAINBUILDING, "LockAbility1" ) -- ������ �� ������������� ������	
	
	LuaEndBlockSection( 0 )	
	LuaBeginBlockSection()
		LuaAddNonBlockedElement( "NaftaBottle", true )
		LuaAddNonBlockedElement( "Hintline", true )
		LuaAddNonBlockedElementActionBar( 0, true )
	LuaEndBlockSection( 0 )
	--ShowHintline( "TM1_D05" )
	--GreyWait( 4, ShowHintline, "" )
	LuaRemoveSessionQuest( "TM1_Q11s" )
	LuaAddSessionQuest( "TM1_Q06s" ) -- ����������� � �����
	HideLastBubble()
	ShowBubbleButton("TM1_D06", "ActionBar", 0 )
	
 ----��������� �����, ������� ����� ����� ������� 3�� � ��������� ����
	WaitForBubbleClick()
	LuaSetAdventureControlsEnabled( true, true )
	LuaSetPause( false )
	LuaClearBlocking( 0.5 ) --highlight
else
	SetPrime( 15 )
	LuaHeroActivateTalent( "local", 0, 0, false )
	LuaShowUIBlock( "ActionBarBlock", true )
	LuaShowUIBlock( "MoneyBlock", true )
	LuaShowUIBlock( "ImpulseTalent", true )
end	
-- cinematic and objective: Minimap and Warlord ---------------------------------------
 
 if true then ---- ���������� � ���������� ��� ������� � ����
	x, y = LuaGetScriptArea( selectByFaction( "M1_EnemyCreepA2", "M1_EnemyCreepB2" ) )
	xRanged, yRanged = LuaGetScriptArea( selectByFaction( "M1_EnemyCreepA2ranged", "M1_EnemyCreepB2ranged" ) )
	Soldiers2Names = { "Creep2_1", "Creep2_2", "Creep2_3", "Creep2_4" }
	LuaCreateCreep( Soldiers2Names[1], ENEMY_CREEP_MELEE, x, y, FACTION_ENEMY, 0 )
	LuaCreateCreep( Soldiers2Names[2], ENEMY_CREEP_MELEE, x, y - 4, FACTION_ENEMY, 0 )
	LuaCreateCreep( Soldiers2Names[3], ENEMY_CREEP_MELEE, x, y - 6, FACTION_ENEMY, 0 )
	if LuaIsHeroMale("local") then 
		LuaCreateCreep( Soldiers2Names[4], ENEMY_CREEP_RANGED, xRanged, yRanged, FACTION_ENEMY, 0 ) --������ ���� ������ ��� ���������
	else
		LuaCreateCreep( Soldiers2Names[4], ENEMY_CREEP_MELEE, x, y - 8, FACTION_ENEMY, 0 ) --� ���� �������� ������ ��� �������
	end 

	LuaCreatureHide( ALLY_HERO, false )
	LuaSetUnitHealth( ALLY_HERO, 505 )
	
	ForAll( Soldiers2Names, ReduceDmgAndOnlyPlayerCanKill  )
	ReduceDmgAndOnlyPlayerCanKill( ALLY_HERO )

	LuaSetUnitHealth( Soldiers2Names[1], 241 )
	LuaSetUnitHealth( Soldiers2Names[2], 203 )
	LuaSetUnitHealth( Soldiers2Names[3], 258 )
end  ---- ����� ����������

	if not debugModeOn or debug4Warlord then  -- ��������� ��� ������� � ����
		NeedToPauseAfterPhrases( "D07p_BeforeShowWarlord", "D07p_Warlord" )
		StartCinematic( "TM1_D07" ) -- ����������� � �����
			LuaPauseDialog( true )
			WaitForMoveTo( ALLY_HERO_FROG, "local" , 5 )
			RotateHeroTo( "local", ALLY_HERO_FROG )	
			Wait(rotateTime) --���� ��������� ��������
			LuaPauseDialog( false )
			
			WaitForPhraseEnd( "D07p_JabaTalk" )
			RotateHeroTo( "local", ALLY_HERO )
			Wait(rotateTime) --���� ��������� ��������
			
			WaitForPhraseEnd( "D07p_BeforeShowWarlord" )
			--LuaPauseDialog( true )
			--RotateHeroTo( "local", ALLY_HERO )
			--Wait(rotateTime) --���� ��������� ��������
			CameraMove( allyHeroPos.x, allyHeroPos.y , 3)
			LuaPauseDialog( false )
			
			WaitForPhraseEnd( "D07p_Warlord" )
			--LuaPauseDialog( true )
			CameraReturn( 3 )
			LuaPauseDialog( false )
		EndCinematic()
	end
	LuaAddSessionQuest( "TM1_Q07s" ) -- ����������� � �����
	HintArrow( allyHeroPos )
	LuaShowUIBlock( "MiniMapBlock", true )

--������� ��� ������� ������ � ������ �������
	LuaSetUnitStat( "local", 2, 1 ) -- ��������� ������ ����� �����, ����� �� �� ��� ����� ����� �� ����� � ���� ��������
	CameraBtnHint( )

	StartTrigger( CameraAwayWarning ) -- �������, ������� ������� ��������, ��� ������� ������ � �����

--������� ����� ������ �������� ������������� ��������	
	talentWasNotUsed = true  --����������� ����������, ���� ����� ������ ������ �� ���������, �������� �� ������������� �������� �� ���������
	StartTrigger( CheckTalentUse ) --��������, ����������� �� ����� ������
	if LuaIsHeroMale("local") then 
		practiceTarget = GetScriptArea( selectByFaction( "M1_EnemyCreepA2ranged", "M1_EnemyCreepB2ranged" ) )
	else
		practiceTarget = GetScriptArea( selectByFaction( "M1_EnemyCreepA2", "M1_EnemyCreepB2" ) )
	end
	WaitForUnitInArea( "local", practiceTarget ) -- ���� ���� ����� �� �������� � ������� ������������ ����� �� ������� ����� ����������� ���������
	HintArrow("")
	
if talentWasNotUsed then-- �������� ������������� �������� ---------------------------------------
	LuaUnitRemoveApplicator ("local", "LockAbility1") -- ������� ������ �� ������������� ������
	isHintLineShow = true -- ����� �� ���������� �������������� �� ��������� ������
	LuaSetPause( true ) 
	--LuaSetAdventureControlsEnabled( false, true ) -- ������ ����� �������, �.�. ����� ������ �� ������ ��������������� ������� ��������
	LuaUnitClearStates( "local" )
	LuaSetUnitStat( "local", 3, 0 ) -- ������ ����� �������� = 0, ����� �� �� ��� ���� � �����
	LuaBeginBlockSection()
		LuaAddNonBlockedElement( "Hintline", true )
		LuaAddNonBlockedElementActionBar( 0, true )
	LuaEndBlockSection( 0.5 )
	HideLastBubble()
	Wait(0.3)
	ShowBubble("TM1_D08_1", "ActionBar", 0 ) -- ����������� � �����
	LuaShowTutorialActionBarItemHighlight( 0, true )
	LuaDebugTrace( "DEBUG: Use any talent" )
	LuaGetLastTalentClicked() -- ����� �����, ����� �������� ���������� ���� ��� ������� 1�� �������
	ConstructWaitConditionState( Check1stTalentClick )
	--LuaSetAdventureControlsEnabled( true, true ) -- ������ ����� �������, �.�. ����� ������ �� ������ ��������������� ������� ��������
	LuaSetPause( false ) 
	HideLastBubble()	
	ConstructWaitConditionState( CheckTalentUse ) -- ���� ���� ����� ������� ������
	LuaSetUnitStat( "local", 3, 50 ) -- ���������� ����� ��������
	LuaSetUnitStat( "local", 2, 14 ) --���������� ������ �����, ��� ���
	ShowBubble( "TM1_D08_3" , "ActionBar", 0 )
	Wait(6) -- ���� 12 ���, ������ � ��� ���� ������ ��� �����
	HideLastBubble() 
	ShowHintline( "TM1_D08_4", false)
else
	LuaSetUnitStat( "local", 2, 14 ) --���������� ������ �����, ��� ���
end 	
  
-- objective: Save Warlord ---------------------------------------
	WaitForUnitsDead( Soldiers2Names )
	ShowHintline( "" )
	isHintLineShow = false -- ����� ���������� �������������� �� ��������� ������
	LuaHeroRemoveFlag( "local", ForbidAutoAttack )	
	LuaRemoveSessionQuest( "TM1_Q07s" )
	LuaRemoveSessionQuest( selectByFaction("TM1_Q01p_D", "TM1_Q01p_A" ) )

  
--����� ��� ���� � ����� (BRIFING) ---------	
	LuaGroupHide( BLOCK_AREA_2 , true )
	if not debugModeOn or debug5Briefing then 
		NeedToPauseAfterPhrases( "D09_BeforeBriefing", "D9p_StartBriefing", "D9p_EnemyMB", "D9p_Arsenal", "D9p_Tower", "D9p_Death", "D9p_Potions" )
		StartCinematic ( "TM1_D09" ) -- ����������� � �����
			LuaPauseDialog( true )
				LuaCreatureHide( ENEMY_HERO, true )  -- ������ ��, ����� �� �������� � ������
				WaitForMoveTo("local", ALLY_HERO, 6 )
				RotateHeroTo( ALLY_HERO, "local" )
			LuaPauseDialog( false )
			
			WaitForPhraseEnd("D09_BeforeBriefing")	
			--LuaPauseDialog( true )
				RotateHeroTo( ALLY_HERO, riverTalk1Pos )
				Wait(rotateTime) --���� ��������� ��������
				LuaCameraObserveUnit( ALLY_HERO )
				MoveTo( ALLY_HERO, riverTalk1Pos, 0)
				Wait(1)
				WaitForMoveTo( "local", riverTalk2Pos, 0)
			LuaPauseDialog( false )
			
			WaitForPhraseEnd("D9p_StartBriefing")
			--LuaPauseDialog( true )
        LuaDebugTrace( "Debug: �������� �������" )
				LuaCameraObserveUnit( "" )
				RemoveWarfogAll( true ) 
        LuaDebugTrace( "Debug: ������ �������" )
				CameraMove( cinemaPos6.x , cinemaPos6.y , 3)
			LuaPauseDialog( false )
			
			WaitForPhraseEnd("D9p_EnemyMB")
			--LuaPauseDialog( true )
				LuaCreatureTeleportTo( ALLY_HERO_FROG, cinemaPos4.x, cinemaPos4.y )
				CameraMove(cinemaPos2.x , cinemaPos2.y , 3)
			LuaPauseDialog( false )
			
			WaitForPhraseEnd("D9p_Arsenal")
			--LuaPauseDialog( true )
				CameraMove(cinemaPos3.x , cinemaPos3.y , 4)
				LuaDebugTrace( "Debug: ������ �� �����" )
			LuaPauseDialog( false )
			
			WaitForPhraseEnd( "D9p_Tower" )
			--LuaPauseDialog( true )
				Wait( 3 )
				LuaCreatureMoveTo( ALLY_HERO_FROG, cinemaPos5.x, cinemaPos5.y, 15)
				WaitForUnitInArea( ALLY_HERO_FROG, cinemaPos5.x, cinemaPos5.y, 3) 
			LuaPauseDialog( false )
			WaitForPhraseEnd( "D9p_Death" )
			
			WaitForUnitsDead( ALLY_HERO_FROG )
			Wait(0.5)
			LuaPauseDialog( false )
					LuaSpawnerSpawnWave( ALLY_MAIN_SPAWNER )
					Wait(0.2)
					ForAll( NameAllLivingCreepsFromSpawner( ALLY_MAIN_SPAWNER ), CommonTeleport )
					PeriodicalSpawn( ALLY_MAIN_SPAWNER , 12.5, creepCap)
				RemoveWarfogAll( false )
				CameraReturn( 3 )
				HeroTalking( "local" , ALLY_HERO)
				LuaCreatureHide( ENEMY_HERO, false ) 
			
		EndCinematic()
	else
		PeriodicalSpawn( ALLY_MAIN_SPAWNER , 12.5, creepCap)
		LuaCreatureTeleportTo( ALLY_HERO_FROG, cinemaPos5.x, cinemaPos5.y )
	end -- ����� ������ ---
	
	--StartTrigger( CreepControl2, ALLY_MAIN_SPAWNER, 15 ) -- �������, ������� ����� ������� ������� ������, ���� �� ������������ ������ ����� �����
  ----������ ������� �������
	isHintLineShow = true -- ����� ���� �� ���������� ��������� �� ���������� ������
	LuaHeroTakeConsumable( "local", "HealingPotion" ) -- �������� � dictionary 
	LuaHeroTakeConsumable( "local", "HealingPotion" )
	LuaHeroTakeConsumable( "local", "HealingPotion" )
	Wait( 1 ) -- ����������� �������� ����� ���� �� ������ ��������
	ShowBubbleButton("TM1_D10_2", "ActionBar", 1 ) -- ����������� � �����
	StartTrigger( DrinkPotion, 50 )

	LuaAddSessionQuest( selectByFaction("TM1_Q02p_D", "TM1_Q02p_A" ) )
	LuaSessionQuestUpdateSignal( "TM1_Q02p", "Q02_s1", cinemaPos6.x, cinemaPos6.y)
	LuaAddSessionQuest( "TM1_Q08s" )	
	LuaSessionQuestUpdateSignal( "TM1_Q08s", "Q08_s1", cinemaPos5.x, cinemaPos5.y)
	HintArrow( ENEMY_TOWER )
	
	Wait( 1 ) 
	LuaCreatureMoveTo( ALLY_HERO, Obj1Pos.x, Obj1Pos.y , 100 ) -- ������� ���� �� ����	

-- ���� ���������� ��������� �����
	LuaUnitAddFlag( "local", ForbidTakeDamage) --������ ���� ���� �� �����, ����� ����� �� ���� �������� �� ������������
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_TOWER, 25 )
	x, y = LuaUnitGetPosition( ENEMY_TOWER )
	LuaDebugTrace( "Attack tower" )
	MarkEnemy( ENEMY_TOWER, true )
	LuaSpawnerSpawnWave( ENEMY_MAIN_SPAWNER ) --������� 1�� ����� ������, ����� ��� �������� � ������������ ������
	
--����������� �����
	LuaShowUIBlock( "ImpulseTalent", false ) -- ��������� �� ������� ������� �������, ����� ��� �� ������ ����� ������ �����
	WaitForUnitsDead( ENEMY_TOWER ) 
	isHintLineShow = false
	SetPrime( 200 )
	HintArrow( "" )
	LuaUnitRemoveFlag( "local", ForbidTakeDamage) --����� ������ � ������ ����� ����� ������
	LuaShowUIBlock( "ImpulseTalent", true ) -- ��������� ������ ����� ������ ���� "������� ������� �������"
	PeriodicalSpawn( ENEMY_MAIN_SPAWNER , 20, creepCap )
	EnemyHeroMovePos = GetScriptArea( selectByFaction( "EnemyHeroMoveB_m1", "EnemyHeroMoveA_m1" ) ) 
	MoveTo( ENEMY_HERO, EnemyHeroMovePos , 1) --��������� ���������� ����� �� ��������� �������
	HintArrow( ENEMY_BARRACKS, selectByFaction(1.5,0) )
	LuaUnitAddFlag( ENEMY_BARRACKS, ForbidTakeDamage) -- ���� ��� �����, ����� ������ ���������
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_BARRACKS, 25 )
	LuaGroupHide( BLOCK_AREA_3 , true ) -- ������� 3�� ������������ ����
	CreateAllyCreepsForEnemyMB() -- ������� ������ ����� ���������� ��, ����� �� ����� ����� � ������
	LuaRemoveSessionQuest( "TM1_Q08s" )
	LuaAddSessionQuest( "TM1_Q09s" )
	LuaSessionQuestUpdateSignal( "TM1_Q09s", "Q09_s1", cinemaPos2.x, cinemaPos2.y)

-- objective: TALENT SET BUY ----------------------------------------------------------------------------------------------------------
	Wait( selectByFaction( 1.8, 2.4 ) ) -- �����, ����� ���� ����������� �������� ���������� �����
	if not debugModeOn or debug8TalentTutor2 then 
		isHintLineShow = true
		AdvancedTalentBuyTutorial() -- ����� ������� � ���������� ��� ������� �� ������ ����
		isHintLineShow = false
	else
		LuaShowUIBlock( "TalentsSetBlock", true )
		LuaShowUIBlock( "ActionBarTalentBtn", true )
		LuaShowUIBlock( "ImpulseTalent", false )
		SetPrime( 1150 )
	end
	LuaRemoveSessionQuest( "TM1_Q12s" )

	CreepControl3() -- ������� ������ �� ���, ����� ���� ����� �� �������� ������ ������� ������
	creepControl5Stop = false -- ����������, ����� ����� ��������� �������� ������ ����� �� (��. ����. ������)
	StartTrigger( CreepControl5 ) -- � ��� ������� �����, ����� ������� ����� �� ����� ������ ������� ������������ � ���������� ��

-- �������� ���� ���� -------------------------------------------------------------------------------------------------------------------	
	Wait(2)
	if not debugModeOn or debugLastHits then LastHitTutorial() end  
		
--��������� �����  ----------------------------------------------------------------------------------------------------------------------
	LuaDebugTrace( "Debug: Enemy hero block" )
	NearArsenalPos = GetScriptArea( selectByFaction( "NearArsenalB_m1", "NearArsenalA_m1" ) ) -- enemy arsenal
	LuaSetUnitStat( ENEMY_HERO, 3, 0 )
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_HERO, 90 )	
	LuaHeroActivateTalent( ENEMY_HERO, 0, 0, false )
	
	WaitForUnitInArea( "local", NearArsenalPos )
	if not debugModeOn or debug6Enemy then 
		LuaHeroAddFlag( "local", ForbidAutoAttack ) 
		StartCinematic( "TM1_D15", true ) -- ����������� � �����
			HintArrow("")
			LuaSetUnitStat( ENEMY_HERO, 3, 45 )
			LuaHeroAddFlag( ENEMY_HERO, ForbidAutoAttack ) 
			LuaPauseDialog( true )
			LuaHeroAddFlag( "local", ForbidTakeDamage ) 
			LuaHeroAddFlag( ENEMY_HERO, ForbidTakeDamage ) 
			MoveTo( ENEMY_HERO, "local", 7 )
			LuaPauseDialog( false )
			RotateHeroTo( "local", ENEMY_HERO )
		EndCinematic()
		isHintLineShow = true -- ����� �� ���������� �������������� �� ��������� ������
		LuaHeroRemoveFlag( "local", ForbidAutoAttack )
		LuaHeroAddFlag( ENEMY_HERO, ForbidAutoAttack ) 
		LuaHeroRemoveFlag( "local", ForbidTakeDamage ) 
		LuaHeroRemoveFlag( ENEMY_HERO, ForbidTakeDamage ) 
		StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_HERO, 20 )
	else
		--LuaCreatureTeleportTo( ENEMY_HERO, EnemyHeroMovePos.x, EnemyHeroMovePos.y )
	end
	LuaHeroUseTalent( ENEMY_HERO, 0, 0 )
	StartTrigger( RepetableAttackPlayer, ENEMY_HERO )
	GreyWait ( 1.2, ShowHintline, "TM1_D15_2" )
	--ShowHintline( "TM1_D15_2" )
	LuaAddSessionQuest( "TM1_Q10s" )
	MarkEnemy( ENEMY_HERO, true )

--���� ������ ���������� ����� -------------------------------------------------------------------------------------------------------------
	LuaHeroSetForbidRespawn( ENEMY_HERO, true )
  WaitForUnitsDead( ENEMY_HERO )
  
	LogSessionEvent ("Enemy hero dead") -- ����������� � �����
  
	MarkEnemy( ENEMY_HERO, false )
	ShowHintline( "" )
	isHintLineShow = false -- ����� ����� ���������� �������������� �� ��������� ������
	HintArrow(ENEMY_BARRACKS, selectByFaction(3.5,1) )
	LuaUnitRemoveFlag( ENEMY_BARRACKS, ForbidTakeDamage)
	LuaRemoveSessionQuest( "TM1_Q10s" )
	
	MarkEnemy( ENEMY_HERO, false )	
	--	LuaStartDialog( "TM1_D16" )


-- objective: Barracks  ---------------------------------------
	MarkEnemy( ENEMY_BARRACKS, true )
	LuaUnitAddFlag( ENEMY_MAINBUILDING, ForbidTakeDamage )

	WaitForUnitsDead( ENEMY_BARRACKS ) -- ���� ���������� �������
	LuaDebugTrace( "Debug:  ����� ��������, ������� ��������� " )
	HintArrow("")
	LuaRemoveSessionQuest( "TM1_Q09s" )
	StopAllPeriodicalSpawn() -- ��������� ������� ������. ������� ����� ������� � "AfterBarrackCinema"
	LuaSetManualGameFinish (true)

	AfterBarrackCinema() 
	
	LogSessionEvent ("After barrack destroed cinema") -- ����������� � �����
	
	LuaUnitRemoveFlag ( ENEMY_MAINBUILDING, ForbidTakeDamage )
	LuaSetUnitStat( ENEMY_MAINBUILDING, 2, 26 )
	StartTrigger( OnlyPlayerCanKillAtThisPoint, ENEMY_MAINBUILDING, 35 ) -- ������ ����� ����� ������ ��
	HintArrow( ENEMY_MAINBUILDING )
	
-- objective: destroy MAIN BUILDING
	
	WaitForUnitsDead( ENEMY_MAINBUILDING )
	isHintLineShow = true -- ����� �� ���������� �������������� �� ��������� ������
	if LastHitTutorial then
		LuaRemoveSessionQuest( "TM1_Q13s" )
		LuaDebugTrace( "DEBUG: �������� �������� �����������" )
		LastHitTutorial = false
	end
	HintArrow("")
	RemoveWarfogAll( true ) 	
	 LuaDebugTrace( "Debug:  �� ���������, ��������� ����� " )	
	LuaRemoveSessionQuest( selectByFaction("TM1_Q02p_D", "TM1_Q02p_A" ) )
	StartCinematic ( "TM1_D21" ) -- ����������� � �����
		LuaCreatureTeleportTo( ALLY_HERO_FROG, lastCinemaPos0.x, lastCinemaPos0.y)		
		WaitForMoveTo( ALLY_HERO_FROG, "local", 6)
		RotateHeroTo( "local", ALLY_HERO_FROG )
	EndCinematic()
	isCinematicCurrentlyPlayed = true -- ����� �� ���������� ������� ����� ������� � ������
	ShowHintline( "" )
	Wait (1) --�������� ����� ������ ���� �����, ����� ����� �� ����������--
	LuaGameFinish( selectByFaction ( 2, 1) )	
end

------------------------------------------------------------------------------------------------------------------------------------------------
----- ����� ��������� ����� --------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

function HintAboutMove()   -- ���/��� �������� ��� ��������	
	if LuaGetControlStyle() then   
		LuaDebugTrace( "DEBUG: �������� �������� ��� ��� ����") 
		ShowHintline( "TM1_D02_LMC", true, "LeftClick")
	else
		LuaDebugTrace( "DEBUG: �������� �������� ��� ��� ����") 
		ShowHintline( "TM1_D02_RMC", true, "RightClick")
	end
end

function HintAboutAttack()	-- ���/��� �������� ��� ����� 
	if LuaGetControlStyle() then   
		ShowHintline( "TM1_D04_2_LMC", true, "LeftClick")
		LuaDebugTrace( "DEBUG: �������� �������� ��� ��� �����") 
	else
		ShowHintline( "TM1_D04_2_RMC", true, "RightClick")
		LuaDebugTrace( "DEBUG: �������� �������� ��� ��� �����") 
	end
end

function CheckTalentUse() -- ������������ ��� �������� ������������ ��������
	if ( GetGameStep() - LuaHeroGetLastTalentUseStep( "local" ) <= 1 * GetStepsCountInSecond() ) then
		LuaRemoveSessionQuest( "TM1_Q06s" )
		ShowHintline( "" )
		LuaShowTutorialActionBarItemHighlight( 0, false )
		talentWasNotUsed = false
		return true
	end
	return false
end

function Check1stTalentClick() -- ��������� ��� �������� ������ 0 0, ������������ ��� �������� ������������ ��������
	local levelClick, columnClick = LuaGetLastTalentClicked()
--	LuaDebugTrace( "DEBUG: ����� ���������" ..tostring(levelClick).." "..tostring(columnClick))
	local function MarkCreepForHint( creepName )
		if not LuaUnitIsDead( creepName ) then
			MarkEnemy( creepName , true)
		end		
	end
	if levelClick==0 and columnClick==0 then
		LuaDebugTrace( "DEBUG: �� �������� �� �������" ..tostring(levelClick).." "..tostring(columnClick))
		if LuaIsHeroMale("local") then MarkCreepForHint( "Creep2_4" ) 
		else ForAll( Soldiers2Names, MarkCreepForHint )	end
		ShowHintline( "TM1_D08_2", false) -- ����� �������� hint_beep, ����� ������ ����� ������.
		LuaClearBlocking( 0.5 ) --������� ����������
		return true
	end
	return false
end

function Kill2CreepsObjective()
	if LuaUnitIsDead( "Creep1_1" ) then 
		LuaUpdateSessionQuest( "TM1_Q05s", 1 )
	end
	if LuaUnitIsDead( "Creep1_2" ) then 
		LuaUpdateSessionQuest( "TM1_Q05s", 1 )
	end
end

function DrinkPotionTutorial()  -- ������ �� ������������, �.�. ���������� ��� ������ ��������� ��������� �������
	potionSlotNumber = 1
	--LuaSetPause( true ) 
	LuaDebugTrace( "DEBUG: 55555555555" )
	LuaDebugTrace( "Debug: ������ ��������� ��� ����" )	
	LuaShowTutorialActionBarItemHighlight( potionSlotNumber , true)	
	ShowBubble("TM1_D17_1", "ActionBar", 1)
	--ShowHintline( "TM1_D17_1" )	
		LuaDebugTrace( "DEBUG: 66666666666666666666666666666" )
--	WaitForHeroUseAnyConsumable( "local" )
			LuaDebugTrace( "DEBUG: 7777777777777777777777777777777777777" )
	--LuaSetPause( true ) 
	--ShowHintline( "" )
	--LuaShowActionBarButtonBubble( 1, false, "TM1_D14" )
	HideLastBubble()
	LuaDebugTrace( "Debug: ������ ��������� ��� ����" )
		LuaDebugTrace( "DEBUG: 88888888888888888888888888888888888888888888888888888888" )	
	--	LuaShowTutorialElementHighlight( "HealthBar" , false ) -- ���� ����� ������ ���������, ��� ���� ����� �� ���������
end
 
 function CreepControl( creepTypeMaskString , factionMaskString)
	local creepTypeMask = tonumber( creepTypeMaskString )
	local factionMask = tonumber( factionMaskString )
	--local factionMask = 2 ^ FACTION_PLAYER -- ����� ��� ������.
	local enemyCreepsNumb = LuaGetUnitsInArea( factionMask, creepTypeMask, NearArsenalPos.x, NearArsenalPos.y, 130)
	local allyCreepsNumb = LuaGetUnitsInArea( factionMask, creepTypeMask, NearArsenalPos.x, NearArsenalPos.y, 130)
	LuaDebugTrace( "Debug: ����� ������� ������:"..tostring( enemyCreepsNumb) )
	LuaDebugTrace( "Debug: ����� ������� ������:"..tostring( allyCreepsNumb ) )
	if enemyCreepsNumb > allyCreepsNumb + 2 then 
		-- ���-������ �������� ������
	end
	if enemyCreepsNumb + 2 < allyCreepsNumb then 
		-- ���-������ �������� ������
	end
end

--[[ function CreepControl2( spawnerName, creepsCap )
	if endCreepControl then 
		LuaDebugTrace("DEBUG: ������� CreepContorl2 ���������� ���� ������ ")
		return true
	end
	local creepsArray = NameAllLivingCreepsFromSpawner( spawnerName )
	if # creeps�rray > creepsCap then 
		LuaDebugTrace("DEBUG: ������� CreepContorl2 ����� ������� � ����: " ..tostring(# creepsArray).." - ������� ����" )
		LuaKillUnit( creepsArray[1] )
	end
end
]] --
function CreepControl3 ()
	-- StartTrigger( CreepControl2, ALLY_MAIN_SPAWNER, 14 )
	-- StartTrigger( CreepControl2, ENEMY_MAIN_SPAWNER, 9 )
	--creepsArray = NameAllLivingCreepsFromSpawner( ENEMY_MAIN_SPAWNER )
	--StartTrigger( function(creepsArray) if # creepsArray < 2 then LuaSpawnerSpawnWave( ENEMY_MAIN_SPAWNER ) end;  end) -- ��� ����� �������� � ������ ��� �� ����� -����� ����� ������� ������ ����������
end

function CreepControl4( unitName)
	local x, y = LuaUnitGetPosition( ENEMY_MAINBUILDING )
	if IsUnitInArea(unitName, x, y, 26 ) then 
		LuaDebugTrace("DEBUG: ���� ���� ������� ������� ������ � ���������� ��! Tresspasser will be shot! " )
		LuaKillUnit( unitName ) 
	end
end

function CreepControl5()
	local creepsArray = NameAllLivingCreepsFromSpawner( ALLY_MAIN_SPAWNER )
	if creepControl5Stop then return end
	--	LuaDebugTrace("DEBUG: �� ��������� �������� ������ ����� � �� - 11" )
	ForAll( creepsArray, CreepControl4 )
--	LuaDebugTrace("DEBUG: �� ��������� �������� ������ ����� � �� - 22" )
end

function DisableMove( unitName )
	LuaSetUnitStat( unitName , 3, 0)
end 

function EliteCreepNames()
	local lastWaveNumb = LuaSpawnerGetLastWave( ALLY_MAIN_SPAWNER )
	local arr = {}
	local creepsInWave = 4
	for i = 1, creepsInWave do
		localName = ALLY_MAIN_SPAWNER .. "_w" .. tostring( lastWaveNumb ) .. "_c" .. tostring(i)
		arr[ i ] = localName
	end
	return arr	
end

function ForbidZone( zoneName )
--	LuaMessageToChat( "������ ��������, ���������� "..tostring(zoneName.x).." "..tostring(zoneName.y).." "..tostring(zoneName.radius).." " )
	if IsHeroInArea( "local", zoneName.x , zoneName.y, zoneName.radius ) then 
		LuaUnitClearStates( "local" )
		LuaMessageToChat( "��� ���� ���� ����, ��������� ������� �������" )
--		return true
	end
	return false
end

function HeroImmortalCheat()
	local warnPercent_2 = 30
	local health, maxHealth = LuaUnitGetHealth( "local" )
	local bonusHealthRegen = 18
	local currentPercent = health / maxHealth
	local damageDecresePercent = (1 - currentPercent) * 100
	LuaSetUnitStat( "local" , 27, damageDecresePercent)
	LuaSetUnitStat( "local" , 28, damageDecresePercent)
	if ( currentPercent <=  warnPercent_2 / 100 ) then
		LuaSetUnitStat( "local" , 11, bonusHealthRegen)
	else 
		LuaSetUnitStat( "local" , 11, 0)	
	end
end

function RepetableAttackPlayer( heroName )
	if LuaUnitIsDead( heroName) then
		return
	else
		LuaHeroAttackUnit( heroName, "local" )
	--	LuaHeroUseTalent( heroName, 0, 0 )
	end
end

function AfterBarrackCinema()
	LuaDebugTrace( "Debug: ������ ���������� ��, ��������� � ����������� ���� " )
	-- �������� ���������� �� ����� ���� ������� ������
	NeedToPauseAfterPhrases( "D19p_EliteSpawn", "D19p_WarlordPunish")
	StartCinematic ( "TM1_D19" ) -- ����������� � �����
	    LuaHeroAddFlag( "local", ForbidTakeDamage ) -- �� ����� ���������� �� �� �������� �����
		LuaHeroAddFlag( "local", ForbidAutoAttack )  -- � �� �������
	  -- WaitForPhraseEnd( "D19p_HeroComment" )
	  ---����� ��������� ��� �������	
		--LuaPauseDialog( true )
		LuaCameraObserveUnit( "" )
		cameraMoveTime =4
		RemoveWarfogAll( true )
		LuaCameraMoveToPosTimed( Obj1Pos.x, Obj1Pos.y, cameraMoveTime)
		Wait(0.7) -- ���� ���� ������ ����� ��������� �� ������
		ForAll( NameAllLivingCreepsFromSpawner( ALLY_MAIN_SPAWNER ) , function( unitName ) LuaCreatureHide( unitName, true ); end ) -- ������ ������� ������
		ForAll( NameAllLivingCreepsFromSpawner( ENEMY_MAIN_SPAWNER ) , function( unitName ) LuaKillUnit( unitName ); end ) -- ������� ��������� ������
		creepControl5Stop = true
		endCreepControl = true
		Wait( cameraMoveTime - 0.5) -- ���� ���� ������ ����� �������� �� �����
		RemoveWarfogAll( false )
		LuaSpawnerSpawnWave( ALLY_MAIN_SPAWNER )
		eliteCreepNamesArray = EliteCreepNames()
		Wait( 1 )
		--StartTrigger( CreepControl2, ALLY_MAIN_SPAWNER, 18 )
	--	LuaPauseDialog( false )
	   WaitForPhraseEnd( "D19p_EliteSpawn" )
	  ---����� ������� ��� �������
		--LuaPauseDialog( true )
		Wait( 2 )
		CameraMove(Obj3Pos.x, Obj3Pos.y, 1.5)
		LuaHeroRespawn( ALLY_HERO_FROG )
		Wait(1.5) --����, ���� ����������� �������� �����������--
		LuaPauseDialog( false )
	  ---����� ������� ��� ����
	  
	  --- WaitForPhraseEnd( "D19p_FrogRessurect" )
	  ---����� ����	  
		--LuaPauseDialog( true )
		ForAll( NameAllLivingCreepsFromSpawner( ALLY_MAIN_SPAWNER ) , function( unitName ) 	LuaSetUnitStat( unitName, 3, 0 ); end )
		--HeroTalking( ALLY_HERO_FROG, ALLY_HERO )
		Wait(rotateTime) --����, ���� ���������� �������� ��������--
		WaitForMoveTo( ALLY_HERO, ALLY_HERO_FROG, 7)
		HeroTalking( ALLY_HERO_FROG, ALLY_HERO )
 	--	LuaPauseDialog( false )
	   WaitForPhraseEnd( "D19p_Frog" )
	  ---����� ������� ��� ���������

	   WaitForPhraseEnd( "D19p_WarlordPunish" )
		--LuaPauseDialog( true )		
		RemoveWarfogAll( true ) 	
		cameraMoveTime =3
		LuaCameraMoveToPosTimed( cinemaPos1.x , cinemaPos1.y , cameraMoveTime)
		Wait( 2 ) -- ������� ����, ����� ����� ����� ���������
		x, y = LuaUnitGetPosition( ENEMY_MAINBUILDING )
		ForAll( Soldiers3Names, function( unitName) LuaCreatureHide( unitName, false ) ; end) --- ��������� ���� ������� ��������� ������ � ���������� �� �� ��������� ��
		ForAll( Soldiers3Names, function( unitName) if not LuaUnitIsDead(unitName) then LuaCreatureMoveTo( unitName, x, y , 2 ) end ; end) -- ����� ����� ������������ "LuaCreatureMoveTo", ����� �������� ��������� ��������� � "MoveTo" �� �������� ������
		Wait( cameraMoveTime)
		RemoveWarfogAll( false )	
		PeriodicalSpawn( ALLY_MAIN_SPAWNER , 14, creepCap)
		WaitForUnitsDead( Soldiers3Names ) -- ���� ���� ����� �� �������
		Wait(1) --� ��� ���� ������� ��� �������
	   LuaPauseDialog( false )
		
	   WaitForPhraseEnd( "D19p_GZAoE" )
		--ForAll( eliteCreepNamesArray , function( unitName ) LuaCreatureTeleportTo( unitName, eliteTeleportPoint.x, eliteTeleportPoint.y ) end )
		ForAll( eliteCreepNamesArray , EliteTeleport )
		ForAll( eliteCreepNamesArray, function( unitName) if not LuaUnitIsDead(unitName) then LuaCreatureMoveTo( unitName, x, y , 2 ) end ; end)
	 	ForAll( NameAllLivingCreepsFromSpawner( ALLY_MAIN_SPAWNER ) , function( unitName ) 	LuaSetUnitStat( unitName, 3, 40 ); end )  
		CameraReturn( 2 )
		LuaHeroRemoveFlag( "local", ForbidTakeDamage ) 
		LuaHeroRemoveFlag( "local", ForbidAutoAttack ) 
		LuaDebugTrace( "Debug: ����� ���������� ��� ����� ������" )	
	EndCinematic()
end 

eliteTelMod = 0
function EliteTeleport( unitName )
	LuaCreatureTeleportTo( unitName, eliteTeleportPoint.x + eliteTelMod, eliteTeleportPoint.y )
	eliteTelMod = eliteTelMod + 2
end

commonTelMod = 0
function CommonTeleport( unitName )
	LuaCreatureTeleportTo( unitName, commonTeleportPoint.x + commonTelMod, commonTeleportPoint.y )
	commonTelMod = commonTelMod + 2
end
 
function G5( t )
	RemoveWarfogAll( true )	
	cameraName = selectByFaction( "/Maps/Tutorial/cameraA1.CSPL", "/Maps/Tutorial/cameraB1.CSPL" )
--	LuaSetCameraFree( cameraName, 0)
--	Wait( 3 )
	LuaSplineCameraTimed( cameraName, tonumber(t))
	LuaStartCinematic ("TM1_D01") 
end

function G7( ID, modeIndex )
	LuaShowAllUIBlocks( true )
	if tonumber(modeIndex) > 0 then 
		modeOn = true
	else 
		modeOn = false
	end
	LuaShowTutorialHeroHighlight( ID, modeOn )
end

function ReduceDmgAndOnlyPlayerCanKill( unitName ) 
	LuaUnitApplyApplicatorFromUnit( unitName, "local", "DamageReducer" )
	StartTrigger(OnlyPlayerCanKillAtThisPoint, unitName, 25 )
end		

function CreateAllyCreepsForEnemyMB()
	--������� ������ ������� ������ ����� ���������� ��, ����� ��� �� ����� ������� ����� � ������� AfterBarrackCinema	
		x, y = LuaGetScriptArea( selectByFaction( "M1_SpawnCreepForMainBuilding_D", "M1_SpawnCreepForMainBuilding_A" ) )
		LuaDebugTrace( "DEBUG: ���������� ��� ������:"..tostring(x).. " & "..tostring(y) )
		Soldiers3Names = { "Creep3_1", "Creep3_2", "Creep3_3", "Creep3_4", "Creep3_5", "Creep3_6" }
		LuaCreateCreep( Soldiers3Names[1], ALLY_CREEP_MELEE, x + 3, y, FACTION_PLAYER, 0 )
		LuaCreateCreep( Soldiers3Names[2], ALLY_CREEP_RANGED, x, y, FACTION_PLAYER, 0 )
		LuaCreateCreep( Soldiers3Names[3], ALLY_CREEP_MELEE, x, y - 4, FACTION_PLAYER, 0 )
		LuaCreateCreep( Soldiers3Names[4], ALLY_CREEP_RANGED, x, y - 6, FACTION_PLAYER, 0 )
		LuaCreateCreep( Soldiers3Names[5], ALLY_CREEP_MELEE, x, y - 8, FACTION_PLAYER, 0 )
		LuaCreateCreep( Soldiers3Names[6], ALLY_CREEP_MELEE, x+4, y - 4, FACTION_PLAYER, 0 )
		LuaSetUnitStat( Soldiers3Names[2], 2, 8 )
		LuaSetUnitStat( Soldiers3Names[4], 2, 8 )
		ForAll( Soldiers3Names, function( unitName) LuaCreatureHide( unitName, true ) ; end)
	--����� �������� ������ ������� ������
end

function AdvancedTalentBuyTutorial()
	LuaSetPause( true )
	LuaSetAdventureControlsEnabled( false, true )
	LuaAddSessionQuest( "TM1_Q12s" )
	HideLastBubble() -- ������ ���� ��� �������, ���� ����� �� ������� ��� ���
--������ ����: �������� �2 �� ������ �������	
	SetPrime( 375 )
		Wait(0.1)	
  	LuaBeginBlockSection() 
		LuaAddNonBlockedElement( "ImpulseTalent", true )
		LuaAddNonBlockedElement( "Hintline", true )
	LuaEndBlockSection( 0.5 )
	ShowBubble("TM1_D12_1", "ImpulseTalent") -- ����������� � �����
	
	ConstructWaitConditionState( LuaHeroIsTalentActivated, "local", 0 , 1)  ----���� ������� ������� �� �������
	HideLastBubble()
	ShowBubbleButton("TM1_D12_4", "NaftaBottle") -- ����������� � �����
	WaitForBubbleClick() 

--������ ����: ������� ������� ���� ��������, ���� ���� ����� ��� �������
	HideLastBubble()
	LuaClearBlocking( 0 )
	SetPrime( 375 )
	LuaShowUIBlock( "TalentsSetBlock", true )
	LuaShowUIBlock( "ActionBarTalentBtn", true )
	LuaShowUIBlock( "ImpulseTalent", false )
	LuaBeginBlockSection() 
		LuaAddNonBlockedElement( "TalentsBar", true )
		LuaAddNonBlockedElement( "NaftaBottle", true )
		LuaAddNonBlockedElement( "Hintline", true )
	LuaEndBlockSection( 0 )	
	ShowBubble( "TM1_D12_2", "PrimeBottle")
	Wait(0.1)	

	WaitForOpenUI( WINDOW_TALENTSBAR ) -- ���� �������� ��
	StartTrigger( DoNotCloseTalentUI ) -- ���� ����, ����� �� ������� ��������� �� �� ��������� ���������. 
	talentTutorialOver = false
	HideLastBubble()
	ShowBubble( "TM1_D12_3", "Talent", 2, 0)  -- ����������� � �����
	 
	CheckSuccessfulBuyTalent() -- ������� � �������
	HideLastBubble()
	LuaShowTutorialElementHighlight( "TalentSetSecondLevel" , true ) 
	ShowBubbleButton( "TM1_D12_5", "TalentSetSecondLevel")  -- ����������� � �����
	
	WaitForBubbleClick() 
	LuaShowTutorialElementHighlight( "TalentSetSecondLevel" , false ) 
	ShowBubbleButton( "TM1_D12_6", "Talent", 2, 1)  -- ����������� � ����� (���� ��� ��������� �������)
	
	WaitForBubbleClick()
	ShowBubbleButton( "TM1_D12_7", "Talent", 4, 1) -- ����������� � ����� (���� ��� ��������� �������)
	
	WaitForBubbleClick()  
	ShowBubble( "TM1_D12_8", "TalentSetSecondLevel") -- ����������� � �����
	SetPrime( 500 )
	--Wait(0.1)	
	CheckSuccessfulBuyTalent()
	HideLastBubble()
	--LuaShowTutorialElementHighlight( "TalentSetSecondLevel" , false ) 
	

	talentTutorialOver = true --������ �� �� ����� �������� ����, ������� �������, ��� �������� ���� ��������
--	if LuaIsWindowVisible ( WINDOW_TALENTSBAR ) then 
	ShowBubble( "TM1_D12_10", "PrimeBottle") -- ����������� � ����� (����, ����� ����� ������ ���� ��������)
	WaitForCloseUI ( WINDOW_TALENTSBAR ) 
	HideLastBubble()
--	end
	LuaSetAdventureControlsEnabled( true, true )
	LuaSetPause( false ) 
	LuaClearBlocking( 0 )
	LuaShowUIBlock( "ImpulseTalent", true )
	StartTrigger( HowToCloseTalentUI )
end

function HowToCloseTalentUI()
	if LuaIsWindowVisible(WINDOW_TALENTSBAR) then
		LuaShowBubble( "PrimeBottle", true, "TM1_D13_Hint", "", 2) -- ���������� ����� ������ �������, � �� �������, �.�. ������� ����� ��������� � ��������������� ������ � ������� ������ �����
	else
		LuaShowBubble( "PrimeBottle", false, "TM1_D13_Hint", "", 2) -- ���������� ����� ������ �������, � �� �������, �.�. ������� ����� ��������� � ��������������� ������ � ������� ������ �����
	end
end

function DoNotCloseTalentUI()
	if talentTutorialOver then return end
	if not LuaIsWindowVisible(WINDOW_TALENTSBAR) then
		LuaShowBubble( "PrimeBottle", true, "TM1_D12_9_Hint", "", 2) -- ���������� ����� ������ �������, � �� �������, �.�. ������� ����� ��������� � ��������������� ������ � ������� ������ �����
	else
		LuaShowBubble( "PrimeBottle", false, "TM1_D12_9_Hint", "", 2) -- ���������� ����� ������ �������, � �� �������, �.�. ������� ����� ��������� � ��������������� ������ � ������� ������ �����
	end
end

function RemoveWarfogAll( warfogState ) -- ���� true - ��������� ������ �� ���� �����
	if warfogState then
		LuaUnitApplyApplicatorFromUnit( ALLY_MAINBUILDING, "local", "RemoveWarfog")
	else
		LuaUnitRemoveApplicator( ALLY_MAINBUILDING, "RemoveWarfog")
	end
	
end

function LastHitTutorial()
	StartCinematic("TM1_D23") -- ����������� � �����
	EndCinematic()
	LuaAddSessionQuest( "TM1_Q13s" )
	LuaDebugTrace( "DEBUG: �������� �������� - �� ��� ��� ����� ����:"..tostring(LuaHeroGetKillsTotal( "local") ) )
	counterKills = 0
	StartTrigger( KillsCount, 5, LuaHeroGetKillsTotal( "local") )
end

function KillsCount( totalKillsNeeded, killsBeforeCount)
	if (LuaHeroGetKillsTotal( "local") - killsBeforeCount) > counterKills then
		counterKills = counterKills+1
		LuaUpdateSessionQuest ("TM1_Q13s", counterKills)	
		LuaDebugTrace( "DEBUG: �������� ��������, ������� ������� ���������� � ���� = "..tostring(counterKills))
		LastHitTutorial = true
	end
	if counterKills >= totalKillsNeeded then
		LuaRemoveSessionQuest( "TM1_Q13s" )
		LuaDebugTrace( "DEBUG: �������� �������� �����������" )
		LastHitTutorial = false
		return true
	end
end

function CameraAwayWarning()
	distanceAway = 300
	if not isCinematicCurrentlyPlayed and not isHintLineShow then
		local xCam,yCam = LuaCameraGetPos()
		local xHero,yHero = LuaUnitGetPosition( "local" )
		if ( DistanceSquared( xCam, yCam, xHero, yHero ) >= distanceAway ) and cameraAwayHintOff and not isCinematicCurrentlyPlayed and not isHintLineShow then
			LuaDebugTrace( "DEBUG: ������ ��������� ������� ������ �� ������, ��������� ����� ����:"..tostring(DistanceSquared( xCam, yCam, xHero, yHero )))
			ShowHintline( "TM1_D07_2", false ) -- � ����� ��������� �������� ���, ����� ������ �� ��������
			cameraAwayHintOff = false
		elseif ( DistanceSquared( xCam, yCam, xHero, yHero ) < distanceAway ) and not cameraAwayHintOff then
			ShowHintline("")
			cameraAwayHintOff = true
		end
	else
		--ShowHintline("")
		--cameraAwayHintOff = true	
	end
	return false
end

function CameraBtnHint()
	LuaShowTutorialElementHighlight("CameraBtn", true)
	ShowHintline("TM1_D07_3", false)
	Wait(5)
	ShowHintline("")
	LuaShowTutorialElementHighlight("CameraBtn", false)
	return true
end
