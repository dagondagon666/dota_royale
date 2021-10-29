--[[
    Spirit Breaker AI
]]

require("ai_core")
require("utils")

behaviorSystem = {}

function Spawn( entityKeyValues )
    thisEntity:SetContextThink("AIThink", AIThink, 0.25)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorAttack, BehaviorCharge})
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

--- Charge
BehaviorCharge = {
    name="charge"
}

function BehaviorCharge:Evaluate()
    self.ability = thisEntity:FindAbilityByName("custom_spirit_breaker_charge_of_darkness")
    -- print("charge ability", self.ability:GetAbilityName(), self.ability:GetAbilityTargetType())
    local target
    local desire = 0

    if AICore.currentBehavior == self then return desire end

    if self.ability and self.ability:IsFullyCastable() then
        -- print("DOTA_UNIT_TARGET_TEAM_ENEMY", DOTA_UNIT_TARGET_TEAM_ENEMY)
        local allEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, self.ability:GetAbilityTargetType(), 128, 0, false)
        -- print("Available Enemies", dump(allEnemies))
        if #allEnemies > 0 then
            target = allEnemies[RandomInt(1, #allEnemies)]
            -- print("target", target:GetUnitName())
        end

    end

    if target then
        desire = 5
        self.order = {
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            UnitIndex = thisEntity:entindex(),
			TargetIndex = target:entindex(),
			AbilityIndex = self.ability:entindex()
        }
        self.target = target
    else
        -- print("Bing: No target?")
    end

    return desire
end

function BehaviorCharge:Begin()
    self.endTime = GameRules:GetGameTime() + 10
end

BehaviorCharge.Continue = BehaviorCharge.Begin

function BehaviorCharge:Think(dt)
    if not self.target:IsAlive() then
		self.endTime = GameRules:GetGameTime()
		return
	end
end