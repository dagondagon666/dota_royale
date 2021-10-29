--[[
    bane AI
]]

require("ai_core")
require("utils")

behaviorSystem = {}

function Spawn( entityKeyValues )
    thisEntity:SetContextThink("AIThink", AIThink, 0.25)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorAttack, BehaviorEnfeeble, BehaviorBrainSap, BehaviorNightmare, BehaviorFiendsGrip})
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


--- Enfeeble
BehaviorEnfeeble = {
    name="Enfeeble"
}

function BehaviorEnfeeble:Evaluate()
    self.ability = thisEntity:FindAbilityByName("bane_enfeeble")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorEnfeeble:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorEnfeeble.Continue = BehaviorEnfeeble.Begin

function BehaviorEnfeeble:Think(dt)
end

--- BrainSap
BehaviorBrainSap = {
    name="BrainSap"
}

function BehaviorBrainSap:Evaluate()
    self.ability = thisEntity:FindAbilityByName("bane_brain_sap")
    local desire = 0
    local target
    
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
        desire = 1
    end

    return desire
end

function BehaviorBrainSap:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorBrainSap.Continue = BehaviorBrainSap.Begin

function BehaviorBrainSap:Think(dt)
end

--- Nightmare
BehaviorNightmare = {
    name="Nightmare"
}

function BehaviorNightmare:Evaluate()
    self.ability = thisEntity:FindAbilityByName("bane_nightmare")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorNightmare:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorNightmare.Continue = BehaviorNightmare.Begin

function BehaviorNightmare:Think(dt)
end

--- FiendsGrip
BehaviorFiendsGrip = {
    name="FiendsGrip"
}

function BehaviorFiendsGrip:Evaluate()
    self.ability = thisEntity:FindAbilityByName("bane_fiends_grip")
    local desire = 0
    local target

    if AICore.currentBehavior == self then return desire end
    
    if self.ability and self.ability:IsFullyCastable() then
        target = AICore:RandomEnemyHeroInRange(thisEntity, 625)
    end

    if target then
        -- print("Fiends Grip Target", target:GetUnitName())
        desire = 5
        self.order = {
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            UnitIndex = thisEntity:entindex(),
			TargetIndex = target:entindex(),
			AbilityIndex = self.ability:entindex()
        }
        self.target = target
    end

    return desire
end

function BehaviorFiendsGrip:Begin()
    self.endTime = GameRules:GetGameTime() + 6
end

BehaviorFiendsGrip.Continue = BehaviorFiendsGrip.Begin

function BehaviorFiendsGrip:Think(dt)
    if not self.target:IsAlive() then
		self.endTime = GameRules:GetGameTime()
		return
	end
end
