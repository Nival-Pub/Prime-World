
include ("GameLogic/Scripts/Debug.lua")
include ("GameLogic/Scripts/StatesManager.lua")
include ("GameLogic/Scripts/Common.lua")
include ("GameLogic/Scripts/Consts.lua")

local function DeferredInit()

	PlotObjectives ()
				
	StartTrigger( SecondaryQuestTracker )

	AddStateTop( PrimaryQuestTracker )
	
end

function Init()

	scriptWorkOn = true
	
	FACTION_DOCT = 1
	FACTION_ADORN = 2
	
	DOCT_HEROES = { }
	ADORN_HEROES = { }
	
	heroStartLevel = 36
	
	SetGlobalVar( "HeroAKills", 0)
	SetGlobalVar( "HeroBKills", 0)
	
	--LuaEnableEventLogging (true)	
	
	-- ���� ��������� ���������
		debugModeOn = false
	-- ����� ����� ���������
	
	if( scriptWorkOn ) then
	
		AddLocalStateTop(DeferredInit)
		
	end

end

-- ����� ��������� � ������ ������ ����� ������ 
function InitHeroes( factionID, heroList )

	for i = 0, 5 do
		table.insert( heroList, tostring(factionID)..tostring(i) )
	end

	LuaDebugTrace("Heroes: ".. #heroList )

end


function Reconnect() -- ����������� ��� ����������

	sideAKillCounter = GetGlobalVar( "HeroAKills" )
	sideBKillCounter = GetGlobalVar( "HeroBKills" )
	
	FlagsReconnect() -- ���� ��������� ��� ������
	
end

function PlotObjectives() -- �������� ������

	BOSS_CAT_HOME  = GetScriptArea("BossCat_Home")
	BOSS_DRAGON_HOME = GetScriptArea("BossDragon_Home")
	
	GlyphSpawners = { "LeftBothGlyph", "LeftTopGlyph", "RightTopGlyph", "RightBothGlyph" }
	DefaultGlyphSpawners = { "ScriptGlyphs" }
	
	-- ��������� ������ ������
	InitHeroes( FACTION_DOCT, DOCT_HEROES )
	InitHeroes( FACTION_ADORN, ADORN_HEROES )
	
	-- �������� �� ����������� �������
	table.foreach(DOCT_HEROES, 
		function(k, v) 
			LevelUpHero( v, heroStartLevel )
			PickUpGlyphStart ( v )
		end)
		
	table.foreach(ADORN_HEROES, 
		function(k, v) 
			LevelUpHero( v, heroStartLevel )
			PickUpGlyphStart ( v )
		end)

end

--[[
function PrimaryQuestTracker()

	LuaApplyPassiveAbility (ALLY_MAINBUILDING, "AbilityBuffHeroes")
	
	Wait (QuestTrackerTime) -- �������� �� �������� GUI �������

end


function SecondaryQuestTracker()
		
	while not DestroedMainBuilding do

		-- ����, ����� ����� �������� ����� ��������
		if (not debugModeOn or debugMiniGameOn) and not MiniGameOn then WaitToTheMinigame() end 

		SleepState()
	end
end
]]--


--[[
function TerrainUp()
	-- ��������� ����� �� ��� �������
	table.foreach(FLAGSPOLES_ADORN_SECOND, function(k,v) LuaCaptureTheFlag( v , 2, true) LuaDebugTrace("LuaCaptureTheFlag: " ..tostring(v)) end)
	table.foreach(FLAGSPOLES_DOCT_SECOND, function(k,v) LuaCaptureTheFlag( v , 1, true) LuaDebugTrace("LuaCaptureTheFlag: " ..tostring(v)) end)
	
	table.foreach(FLAGSPOLES_ADORN_FIRST, function(k,v) LuaCaptureTheFlag( v , 2, true) LuaDebugTrace("LuaCaptureTheFlag: " ..tostring(v)) end)
	table.foreach(FLAGSPOLES_DOCT_FIRST, function(k,v) LuaCaptureTheFlag( v , 1, true) LuaDebugTrace("LuaCaptureTheFlag: " ..tostring(v)) end)
	-- ��������� ��������� �����
end
]]--

function LogConverterStart(questID)
	local saveQuestID = "S" .. GetGlobalVar("currentPQ").. "_" .. questID
	local startQuestID = GetGlobalVar("currentPQ")
	LogSessionEvent ( saveQuestID ) -- ����������� � �����
	LuaDebugTrace( "LogEvent: saveQuestID: " ..saveQuestID.. ", startQuestID: "..startQuestID )
	SetGlobalVar("ForLog_".. questID, startQuestID)
end

function LogConverterEND(questID)
	local saveQuestID = "E" .. GetGlobalVar("currentPQ").. "_" ..questID .. "_S" ..GetGlobalVar("ForLog_" .. questID)
	LogSessionEvent ( saveQuestID ) -- ����������� � �����
	LuaDebugTrace( "LogEvent: saveQuestID: " .. saveQuestID )
end

function PickUpGlyphStart ( Player )

	LuaSubscribeUnitEvent( Player, EventPickup, "PickUpGlyph" )

end

function PickUpGlyph ()


end

function PickUpGlyphEND ( Player )

	LuaUnsubscribeUnitEvent (Player, EventPickup)

end

function EndQuest( questID, faction )

	local _questID = questID

	if faction == nil then faction = false end
	
	if faction == true then
		_questID = questID .. tostring(selectByFaction("_A", "_B"))
	end

	LuaRemoveSessionQuest( _questID )

	if CheckDialogFalse()  then
		if currentQuestDialog < GetTableSize(dialogQuestTable) then 
			currentQuestDialog = currentQuestDialog + 1
		else
			currentQuestDialog = 1
		end

		LuaStartDialog( dialogQuestTable[currentQuestDialog] )
		LuaDebugTrace( "StartQuest: " ..dialogQuestTable[currentQuestDialog])
	end
end

-- ��� ������� ���������� �������������, �� ������ � ������ ��������� �� �����
-- lastHitterId, deathParamsInfo - ������� ������, ��� �����, ��� ���������� ������ �������
local lastKillStep = nil

function EnemyHeroKilled()
	local kills = LuaStatisticsGetTotalNumHeroKills("local") -- ��� ���� ���������� �� ������� ������

	if kills <= lastKills then
		return
	end

	local step = GetGameStep()

	if lastKillStep == nil then
		lastKillStep = step
	end

	local delta = kills - lastKills
	local steps = step - lastKillStep

	lastKills = kills
	lastKillStep = step

end

function MainBuildingDestroyed () --��� ���� ��������, �������� ��� ������� ������ �� ������ ������������
	if AreUnitsDead( ALLY_MAINBUILDING ) then
	
		LuaDebugTrace( "Debug:  ������� ������ ���� ���������!" )
		LuaGameFinish( selectByFaction ( 1, 2) )

	else if  AreUnitsDead( ENEMY_MAINBUILDING ) then
	
		LuaGameFinish( selectByFaction ( 2, 1) )
		
	end
end

function LevelUpHero( heroName, level )

	if level > 36 then level = 36 end
	
	if level > LuaHeroGetLevel( heroName ) then
	
		local n = 0	
		
		for i = 0, 5 do
		
			for j = 0, 5 do
			
				if not LuaHeroIsTalentActivated( heroName, i, j ) then
					LuaHeroActivateTalent( heroName, i, j, false )					
				end
				
				n = n + 1
				
				if n == level then 
					return
				end
				
			end
		end
		
	else
	
		LuaDebugTrace("WARNING! [LevelUpHero] Hero "..heroName.." already has level greater than "..level)
	end
end