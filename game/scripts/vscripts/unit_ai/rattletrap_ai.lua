--[[
    rattletrap AI
]]

require("ai_core")
require("utils")

behaviorSystem = {}

function Spawn( entityKeyValues )
    thisEntity:SetContextThink("AIThink", AIThink, 0.25)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorAttack, BehaviorBatteryAssault, BehaviorPowerCogs, BehaviorRocketFlare, BehaviorOverclocking, BehaviorJetpack, BehaviorHookshot})
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


--- BatteryAssault
BehaviorBatteryAssault = {
    name="BatteryAssault"
}

function BehaviorBatteryAssault:Evaluate()
    self.ability = thisEntity:FindAbilityByName("rattletrap_battery_assault")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then
        local target = AICore:RandomEnemyHeroInRange(thisEntity, 275)
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

function BehaviorBatteryAssault:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorBatteryAssault.Continue = BehaviorBatteryAssault.Begin

function BehaviorBatteryAssault:Think(dt)
end

--- PowerCogs
BehaviorPowerCogs = {
    name="PowerCogs"
}

function BehaviorPowerCogs:Evaluate()
    self.ability = thisEntity:FindAbilityByName("rattletrap_power_cogs")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorPowerCogs:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorPowerCogs.Continue = BehaviorPowerCogs.Begin

function BehaviorPowerCogs:Think(dt)
end

--- RocketFlare
BehaviorRocketFlare = {
    name="RocketFlare"
}

function BehaviorRocketFlare:Evaluate()
    self.ability = thisEntity:FindAbilityByName("rattletrap_rocket_flare")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorRocketFlare:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorRocketFlare.Continue = BehaviorRocketFlare.Begin

function BehaviorRocketFlare:Think(dt)
end

--- Overclocking
BehaviorOverclocking = {
    name="Overclocking"
}

function BehaviorOverclocking:Evaluate()
    self.ability = thisEntity:FindAbilityByName("rattletrap_overclocking")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorOverclocking:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorOverclocking.Continue = BehaviorOverclocking.Begin

function BehaviorOverclocking:Think(dt)
end

--- Jetpack
BehaviorJetpack = {
    name="Jetpack"
}

function BehaviorJetpack:Evaluate()
    self.ability = thisEntity:FindAbilityByName("rattletrap_jetpack")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then

    end

    return desire
end

function BehaviorJetpack:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorJetpack.Continue = BehaviorJetpack.Begin

function BehaviorJetpack:Think(dt)
end

--- Hookshot
BehaviorHookshot = {
    name="Hookshot"
}

function BehaviorHookshot:Evaluate()
    self.ability = thisEntity:FindAbilityByName("rattletrap_hookshot")
    local desire = 0
    
    if self.ability and self.ability:IsFullyCastable() then
        local target = AICore:RandomEnemyHeroInRange(thisEntity, 2000)
        if target then
            desire = 6
            self.target = target
        end
    end

    return desire
end

function BehaviorHookshot:Begin()
    self.endTime = GameRules:GetGameTime() + 1

    local targetPoint = self.target:GetOrigin()

    self.order = {
        UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = self.ability:entindex(),
		Position = targetPoint
    }
end

BehaviorHookshot.Continue = BehaviorHookshot.Begin

function BehaviorHookshot:Think(dt)
end
