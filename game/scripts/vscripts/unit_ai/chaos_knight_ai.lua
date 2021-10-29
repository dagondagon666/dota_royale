--[[
    chaos_knight AI
]]

require("ai_core")
require("utils")

behaviorSystem = {}

function Spawn( entityKeyValues )
    thisEntity:SetContextThink("AIThink", AIThink, 0.25)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorAttack, BehaviorChaosBolt, BehaviorRealityRift, BehaviorChaosStrike, BehaviorPhantasm})
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


--- ChaosBolt
BehaviorChaosBolt = {
    name="ChaosBolt"
}

function BehaviorChaosBolt:Evaluate()
    self.ability = thisEntity:FindAbilityByName("chaos_knight_chaos_bolt")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorChaosBolt:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorChaosBolt.Continue = BehaviorChaosBolt.Begin

function BehaviorChaosBolt:Think(dt)
end

--- RealityRift
BehaviorRealityRift = {
    name="RealityRift"
}

function BehaviorRealityRift:Evaluate()
    self.ability = thisEntity:FindAbilityByName("chaos_knight_reality_rift")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then
        target = AICore:RandomEnemyHeroInRange(thisEntity, 625)
    end

    if target then
        desire = 6
        self.target = target
        self.order = {
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            UnitIndex = thisEntity:entindex(),
            TargetIndex = self.target:entindex(),
            AbilityIndex = self.ability:entindex()
        }
    else
        desire = 0
    end

    return desire
end

function BehaviorRealityRift:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorRealityRift.Continue = BehaviorRealityRift.Begin

function BehaviorRealityRift:Think(dt)
end

--- ChaosStrike
BehaviorChaosStrike = {
    name="ChaosStrike"
}

function BehaviorChaosStrike:Evaluate()
    self.ability = thisEntity:FindAbilityByName("chaos_knight_chaos_strike")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorChaosStrike:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorChaosStrike.Continue = BehaviorChaosStrike.Begin

function BehaviorChaosStrike:Think(dt)
end

--- Phantasm
BehaviorPhantasm = {
    name="Phantasm"
}

function BehaviorPhantasm:Evaluate()
    self.ability = thisEntity:FindAbilityByName("chaos_knight_phantasm")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorPhantasm:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorPhantasm.Continue = BehaviorPhantasm.Begin

function BehaviorPhantasm:Think(dt)
end
