--[[
    life_stealer AI
]]

require("ai_core")
require("utils")

behaviorSystem = {}

function Spawn( entityKeyValues )
    thisEntity:SetContextThink("AIThink", AIThink, 0.25)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorAttack, BehaviorRage, BehaviorFeast, BehaviorGhoulFrenzy, BehaviorOpenWounds, BehaviorInfest})
end

function AIThink()
    if thisEntity:IsNull() or not thisEntity:IsAlive() then
        return nil -- deactivate this think function
    end
    return behaviorSystem:Think()
end

--- Attack
BehaviorAttack = {
    name = "attack",
    order = {
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
        Position = (thisEntity:GetTeamNumber() == 2 and Entities:FindByName(nil, "dota_badguys_fort"):GetAbsOrigin() or Entities:FindByName(nil, "dota_goodguys_fort"):GetAbsOrigin())
    }
}

function BehaviorAttack:Evaluate()
    return 1
end

function BehaviorAttack:Initialize()
end

function BehaviorAttack:Begin()
	self.endTime = GameRules:GetGameTime() + 1
end

function BehaviorAttack:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

function BehaviorAttack:Think(dt)
    -- print(self.order.Position)
end


--- Rage
BehaviorRage = {
    name="Rage"
}

function BehaviorRage:Evaluate()
    self.ability = thisEntity:FindAbilityByName("life_stealer_rage")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then
        local allEnemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, 19, 128, 0, false)
        print("Lifestealer: Enemy spotted", #allEnemies)
        if #allEnemies > 0 then
            desire = 5
            self.order = {
                OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                UnitIndex = thisEntity:entindex(),
                AbilityIndex = self.ability:entindex()
            }
        end
    end

    return desire
end

function BehaviorRage:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorRage.Continue = BehaviorRage.Begin

function BehaviorRage:Think(dt)
end

--- Feast
BehaviorFeast = {
    name="Feast"
}

function BehaviorFeast:Evaluate()
    self.ability = thisEntity:FindAbilityByName("life_stealer_feast")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorFeast:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorFeast.Continue = BehaviorFeast.Begin

function BehaviorFeast:Think(dt)
end

--- GhoulFrenzy
BehaviorGhoulFrenzy = {
    name="GhoulFrenzy"
}

function BehaviorGhoulFrenzy:Evaluate()
    self.ability = thisEntity:FindAbilityByName("life_stealer_ghoul_frenzy")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorGhoulFrenzy:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorGhoulFrenzy.Continue = BehaviorGhoulFrenzy.Begin

function BehaviorGhoulFrenzy:Think(dt)
end

--- OpenWounds
BehaviorOpenWounds = {
    name="OpenWounds"
}

function BehaviorOpenWounds:Evaluate()
    self.ability = thisEntity:FindAbilityByName("life_stealer_open_wounds")
    local desire = 0
    local target
    
    -- no shard ability yet
    -- if self.ability and self.ability:IsFullyCastable() then
    --     target = AICore:RandomEnemyHeroInRange(thisEntity, 300)
    -- end

    -- if target then
    --     desire = 6
    --     self.target = target
    --     self.order = {
    --         OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
    --         UnitIndex = thisEntity:entindex(),
    --         TargetIndex = self.target:entindex(),
    --         AbilityIndex = self.ability:entindex()
    --     }
    -- else
    --     desire = 1
    -- end

    return desire
end

function BehaviorOpenWounds:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorOpenWounds.Continue = BehaviorOpenWounds.Begin

function BehaviorOpenWounds:Think(dt)
end

--- Infest
BehaviorInfest = {
    name="Infest"
}

function BehaviorInfest:Evaluate()
    self.ability = thisEntity:FindAbilityByName("life_stealer_infest")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorInfest:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorInfest.Continue = BehaviorInfest.Begin

function BehaviorInfest:Think(dt)
end
