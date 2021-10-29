-- Generated from template

require("precaches")
require("utils")
require("queue")

require("utils/timers")
require("utils/error_tracking")
require("utils/notifications")

heroPool = {
	axe=true,
	spirit_breaker=true,
	bane=true,
	life_stealer=true,
}

card_pool = {
	"axe",
	"bane",
	"chaos_knight",
	"life_stealer",
	"necrolyte",
	"phantom_assassin",
	"rattletrap",
	"spirit_breaker"
}

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

Precache = require "Precache"

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	-- SEEDING RNG IS VERY IMPORTANT
    math.randomseed(Time())

	self.started = false
	self.boosted = false

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 1)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 1)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(2200)

	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CAddonTemplateGameMode,"OnGameRulesStateChange"),self)
	ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(CAddonTemplateGameMode,"OnPlayerPickHero"),self)

	GameRules:GetGameModeEntity().all_cards = {
		DOTA_TEAM_GOODGUYS  = {},
		DOTA_TEAM_BADGUYS = {}
	}
	local card_pool_1 = shuffleTable(card_pool)
	GameRules:GetGameModeEntity().all_cards[DOTA_TEAM_GOODGUYS] = card_pool_1
	math.randomseed(Time())
	local card_pool_2 = shuffleTable(card_pool)
	GameRules:GetGameModeEntity().all_cards[DOTA_TEAM_BADGUYS] = card_pool_2
	print("All Cards", dump(GameRules:GetGameModeEntity().all_cards))
	GameRules:GetGameModeEntity().card_queue = {}
	GameRules:GetGameModeEntity().card_queue[DOTA_TEAM_GOODGUYS] = Queue.new()
	GameRules:GetGameModeEntity().card_queue[DOTA_TEAM_BADGUYS] = Queue.new()
	for i=1, 4 do
		Queue.pushright(GameRules:GetGameModeEntity().card_queue[DOTA_TEAM_GOODGUYS], GameRules:GetGameModeEntity().all_cards[DOTA_TEAM_GOODGUYS][i])
		Queue.pushright(GameRules:GetGameModeEntity().card_queue[DOTA_TEAM_BADGUYS], GameRules:GetGameModeEntity().all_cards[DOTA_TEAM_BADGUYS][i])
	end

	print("Card Queue", dump(GameRules:GetGameModeEntity().card_queue))
	-- print("Bing", GameRules:GetGameModeEntity().p1_queue.first, GameRules:GetGameModeEntity().p1_queue.last)

	print( "Loading AI Testing Game Mode." )

	-- ListenToGameEvent("entity_killed", handle_2, handle_3)

    -- Set up a table to hold all the units we want to spawn
	self.bad_base = Entities:FindByName(nil, "dota_badguys_fort")
	print("bad base:", self.bad_base:GetAbsOrigin())
    self.UnitThinkerList = {}
	ListenToGameEvent("player_chat", function (e)
		print(e)
		print(e.teamonly, e.userid, e.playerid, e.text)
		print(dump(heroPool))
		if heroPool[e.text] then
			SpawnAIUnitWanderer(e.playerid, "custom_"..e.text)
		end
	end, nil)
	self.created = false

    -- Set the unit thinker function
	print(GameRules)
    -- GameRules:GetGameModeEntity():SetThink( "OnUnitThink", self, "UnitThink", 1 )
	-- GameRules:GetGameModeEntity():SetThink(RandomHeroThink, "RAND")
	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
	GameRules:EnableCustomGameSetupAutoLaunch( true )
end

function CAddonTemplateGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		local player_count = 0
		for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
			if PlayerResource:IsValidPlayer(nPlayerID) then
				player_count = player_count + 1
			end
		end

		if player_count == 1 then
			CAddonTemplateGameMode:SetUpBots()
		end
	end
end

function CAddonTemplateGameMode:SetUpBots()
	if GameRules.bStartBot then
		return
	end
 
	GameRules.bStartBot = true

	CAddonTemplateGameMode.teamSet={}

    local nMaxTeamNumber,nMaxPerTeam = 2, 1
    local nBotCount = nMaxTeamNumber*nMaxPerTeam - PlayerResource:GetPlayerCount()
    print("nMaxTeamNumber"..nMaxTeamNumber)
    print("nMaxPerTeam"..nMaxPerTeam)
    print("nBotCount"..nBotCount)
    print("PlayerResource:GetPlayerCount()"..PlayerResource:GetPlayerCount())
    --GameRules:SetCustomGameTeamMaxPlayers( 2, nBotCount+ PlayerResource:GetPlayerCountForTeam(2) )

    for i=1,nBotCount do
      Tutorial:AddBot("npc_dota_hero_wisp", '', '', true)
    end
     
    for i=2,3 do
        -- local nTeamNumber = GameMode.vTeamList[i]
        local nCurrentPlayerNumber = PlayerResource:GetPlayerCountForTeam( i ) 
        for j=1,nMaxPerTeam-nCurrentPlayerNumber do
            CAddonTemplateGameMode:FillTeamWithBot(i)
        end
    end
end

--设置机器人
function CAddonTemplateGameMode:FillTeamWithBot(nTeamNumber)
    
    --寻找一个编号最大的Bot
    for nPlayerID = DOTA_MAX_TEAM_PLAYERS,0,-1 do
       if PlayerResource:IsFakeClient(nPlayerID) and CAddonTemplateGameMode.teamSet[nPlayerID]==nil then
		CAddonTemplateGameMode.teamSet[nPlayerID] = true
          PlayerResource:SetCustomTeamAssignment(nPlayerID,nTeamNumber)
          
          --延迟一小段时间 给英雄改队伍
          Timers:CreateTimer(0.05, function()
              local hHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
              if hHero ~= nil then
				print("Assigning playerid", nPlayerID, "to team", nTeamNumber)
                 hHero:SetTeam(nTeamNumber)
                 return nil
              end
              return 0.01
          end)

          break;
       end
    end
end

function RandomHeroThink()
	for i= 1, 2, 1
	do
		local player = PlayerResource:GetPlayer(i)
		if player then
			player:SetSelectedHero("npc_dota_hero_io")
		end
	end
	-- local  player0 = PlayerResource:GetPlayer(0)
	-- if player0 then
	-- 	-- PlayerResource:SetHasRepicked(0)
	-- 	-- player0:MakeRandomHeroSelection()
	-- 	local hHero = CreateHeroForPlayer("npc_dota_hero_io", handle_2)
	-- 	player0:SetAssignedHeroEntity(hHero)
	-- else
	-- 	return 0.5
	-- end
end

function CAddonTemplateGameMode:OnPlayerPickHero(keys)
	local player = EntIndexToHScript(keys.player)
	local hero = EntIndexToHScript(keys.heroindex)

	-- remove old abilities
	-- for i=

	-- add abilities
	for i=1,8 do
		local ability = hero:AddAbility("summon_"..GameRules:GetGameModeEntity().all_cards[player:GetTeamNumber()][i])
		ability:SetLevel(1)
		if i < 5 then
			ability:SetHidden(true)
		else
			ability:SetHidden(false)
		end
	end
	local ability = hero:AddAbility("riki_permanent_invisibility")
	ability:SetLevel(1)

	-- hero:SetAbilityPoints(8)
	-- for i=0, 9, 1 do
	-- 	hero:GetAbilityByIndex(i):SetLevel(1)
	-- end
end

function SpawnAIUnitWanderer(player_id, unit_name)
	-- print("Bing: Spawning a ", unit_name)
	local spawn_point_name = "good_spawn_point"
	local spawn_team = DOTA_TEAM_GOODGUYS
	local enemy_base
	if player_id < 5 then
		enemy_base = Entities:FindByName(nil, "dota_badguys_fort")
	else
		spawn_point_name = "bad_spawn_point"
		spawn_team = DOTA_TEAM_BADGUYS
		enemy_base = Entities:FindByName(nil, "dota_goodguys_fort")
	end
	local spawnVectorEnt = Entities:FindByName(nil, spawn_point_name)
	local spawnVector = spawnVectorEnt:GetAbsOrigin()
	
	local spawnedUnit = CreateUnitByName(unit_name, spawnVector, true, nil, nil, spawn_team)

	-- make this unit passive
    spawnedUnit:SetIdleAcquire(false)

    -- Add some variables to the spawned unit so we know its intended behaviour
    -- You can store anything here, and any time you get this entity the information will be intact
    spawnedUnit.ThinkerType = "wander"
    spawnedUnit.wanderBounds = {}
    spawnedUnit.wanderBounds.XMin = -768
    spawnedUnit.wanderBounds.XMax = 768
    spawnedUnit.wanderBounds.YMin = -64
    spawnedUnit.wanderBounds.YMax = 768

	spawnedUnit:SetContextThink("OnUnitThink",
		function()
			if GameRules:State_Get() > 6 then
				-- if GameRules:GetGameTime() < 30 then
				-- 	-- print("Moving?")
				-- 	spawnedUnit:SetControllableByPlayer( 0, false )
				-- 	-- print(spawnedUnit:IsControllableByAnyPlayer())
				-- 	local dest = spawnedUnit:GetAbsOrigin() + Vector(RandomInt(-200,200),RandomInt(-200,200))
				-- 	-- print(dest)
				-- 	spawnedUnit:MoveToPosition(dest)
				-- 	return 5
				-- else
					spawnedUnit:MoveToPositionAggressive(enemy_base:GetAbsOrigin())
					return 5
				-- end
			end
			return 0;
		end, 0)

end

function SpawnUnit()

end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	-- print(math.floor(GameRules:GetGameTime()), GameRules:State_Get())
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		if not self.started then
			GameRules:ForceGameStart()
			self.started = true
		end
		-- for i=0, 1, 1
		-- do
		-- 	local player = PlayerResource:GetPlayer(i)
		-- 	if player then
		-- 		player:
		-- end
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print("Selecting hero...")
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- print( "Template addon script is running." )
		if math.floor(GameRules:GetGameTime()) % 10 == 0 then
			-- SpawnAIUnitWanderer(10, "npc_dota_creature_gnoll_assassin")
		end
		if math.floor(GameRules:GetDOTATime(false, false)) % 60 == 0 then
			print("Boosted!")
			-- Notifications:TopToAll({text="Boosted! Double Mana Regen!", duration=5.0}) -- doesn't work for now :/
			for i=2, 3 do
				local player = PlayerResource:GetPlayer(PlayerResource:GetNthPlayerIDOnTeam(i, 1))
				local hero = player:GetAssignedHero()
				hero:SetBaseManaRegen(hero:GetManaRegen()*2)
				-- self.boosted = true
			end
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME and math.floor(GameRules:GetGameTime()) % 10 == 0 then
		-- if not self.created then
		-- SpawnAIUnitWanderer(10, "npc_dota_creature_gnoll_assassin")
		-- SpawnAIUnitWanderer(1, "npc_dota_creature_gnoll_assassin")
		-- self.created = true
		-- end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end