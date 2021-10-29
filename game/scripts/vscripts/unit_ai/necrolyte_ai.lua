--[[
    necrolyte AI
]]

require("ai_core")
require("utils")

behaviorSystem = {}

function Spawn( entityKeyValues )
    thisEntity:SetContextThink("AIThink", AIThink, 0.25)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorAttack, BehaviorDeathPulse, BehaviorSadist, BehaviorHeartstopperAura, BehaviorDeathSeeker, BehaviorReapersScythe})
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


--- DeathPulse
BehaviorDeathPulse = {
    name="DeathPulse"
}

function BehaviorDeathPulse:Evaluate()
    self.ability = thisEntity:FindAbilityByName("necrolyte_death_pulse")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then
        local target = AICore:WeakestEnemyUnitInRange(thisEntity, 500)
        if target then
            desire = 6
            self.order = {
                OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                UnitIndex = thisEntity:entindex(),
                AbilityIndex = self.ability:entindex()
            }
        end
    end

    return desire
end

function BehaviorDeathPulse:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorDeathPulse.Continue = BehaviorDeathPulse.Begin

function BehaviorDeathPulse:Think(dt)
end

--- Sadist
BehaviorSadist = {
    name="Sadist"
}

function BehaviorSadist:Evaluate()
    self.ability = thisEntity:FindAbilityByName("necrolyte_sadist")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorSadist:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorSadist.Continue = BehaviorSadist.Begin

function BehaviorSadist:Think(dt)
end

--- HeartstopperAura
BehaviorHeartstopperAura = {
    name="HeartstopperAura"
}

function BehaviorHeartstopperAura:Evaluate()
    self.ability = thisEntity:FindAbilityByName("necrolyte_heartstopper_aura")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorHeartstopperAura:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorHeartstopperAura.Continue = BehaviorHeartstopperAura.Begin

function BehaviorHeartstopperAura:Think(dt)
end

--- DeathSeeker
BehaviorDeathSeeker = {
    name="DeathSeeker"
}

function BehaviorDeathSeeker:Evaluate()
    self.ability = thisEntity:FindAbilityByName("necrolyte_death_seeker")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorDeathSeeker:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorDeathSeeker.Continue = BehaviorDeathSeeker.Begin

function BehaviorDeathSeeker:Think(dt)
end

--- ReapersScythe
BehaviorReapersScythe = {
    name="ReapersScythe"
}

function BehaviorReapersScythe:Evaluate()
    self.ability = thisEntity:FindAbilityByName("necrolyte_reapers_scythe")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorReapersScythe:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorReapersScythe.Continue = BehaviorReapersScythe.Begin

function BehaviorReapersScythe:Think(dt)
end
