--[[
    phantom_assassin AI
]]

require("ai_core")
require("utils")

behaviorSystem = {}

function Spawn( entityKeyValues )
    thisEntity:SetContextThink("AIThink", AIThink, 0.25)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorAttack, BehaviorStiflingDagger, BehaviorPhantomStrike, BehaviorBlur, BehaviorFanOfKnives, BehaviorCoupDeGrace})
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


--- StiflingDagger
BehaviorStiflingDagger = {
    name="StiflingDagger"
}

function BehaviorStiflingDagger:Evaluate()
    self.ability = thisEntity:FindAbilityByName("phantom_assassin_stifling_dagger")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorStiflingDagger:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorStiflingDagger.Continue = BehaviorStiflingDagger.Begin

function BehaviorStiflingDagger:Think(dt)
end

--- PhantomStrike
BehaviorPhantomStrike = {
    name="PhantomStrike"
}

function BehaviorPhantomStrike:Evaluate()
    self.ability = thisEntity:FindAbilityByName("phantom_assassin_phantom_strike")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then
        target = AICore:WeakestEnemyUnitInRange(thisEntity, 1000)
        if target then
            desire = 6
            self.target = target
            self.order = {
                OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
                UnitIndex = thisEntity:entindex(),
                TargetIndex = self.target:entindex(),
                AbilityIndex = self.ability:entindex()
            }
        end
    end

    return desire
end

function BehaviorPhantomStrike:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorPhantomStrike.Continue = BehaviorPhantomStrike.Begin

function BehaviorPhantomStrike:Think(dt)
end

--- Blur
BehaviorBlur = {
    name="Blur"
}

function BehaviorBlur:Evaluate()
    self.ability = thisEntity:FindAbilityByName("phantom_assassin_blur")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorBlur:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorBlur.Continue = BehaviorBlur.Begin

function BehaviorBlur:Think(dt)
end

--- FanOfKnives
BehaviorFanOfKnives = {
    name="FanOfKnives"
}

function BehaviorFanOfKnives:Evaluate()
    self.ability = thisEntity:FindAbilityByName("phantom_assassin_fan_of_knives")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorFanOfKnives:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorFanOfKnives.Continue = BehaviorFanOfKnives.Begin

function BehaviorFanOfKnives:Think(dt)
end

--- CoupDeGrace
BehaviorCoupDeGrace = {
    name="CoupDeGrace"
}

function BehaviorCoupDeGrace:Evaluate()
    self.ability = thisEntity:FindAbilityByName("phantom_assassin_coup_de_grace")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorCoupDeGrace:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorCoupDeGrace.Continue = BehaviorCoupDeGrace.Begin

function BehaviorCoupDeGrace:Think(dt)
end
