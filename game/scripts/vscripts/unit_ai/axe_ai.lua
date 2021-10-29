--[[
    Axe AI
]]

require("ai_core")
require("utils")

behaviorSystem = {}

function Spawn( entityKeyValues )
    thisEntity:SetContextThink("AIThink", AIThink, 0.25)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorAttack, BehaviorCall, BehaviorBlade})
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

--- Call
BehaviorCall = {
    name = "call"
}

function BehaviorCall:Evaluate()
    self.ability = thisEntity:FindAbilityByName("axe_berserkers_call")
    
    local desire = 0

    if self.ability and self.ability:IsFullyCastable() then
        local allEnemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, 19, 128, 0, false)
        -- print("Axe: Enemy spotted", #allEnemies)
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

function BehaviorCall:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorCall.Continue = BehaviorCall.Begin

function BehaviorCall:Think(dt)
end

--- Blade
BehaviorBlade = {
    name = "blade"
}

function BehaviorBlade:Evaluate()
    self.ability = thisEntity:FindAbilityByName("axe_culling_blade")
    
    local target
    local desire = 0

    if self.ability and self.ability:IsFullyCastable() then
        -- local allEnemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, 19, 128, 0, false)
        target = AICore:WeakestEnemyUnitInRange(thisEntity, 300)
        if target then
            -- print("Axe: Weakest Found", target:GetHealth())
        end
    end

    if target and target:GetHealth() < 250 then
        -- print("Axe: Weakest HP", target:GetHealth())
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

function BehaviorBlade:Begin()
    self.endTime = GameRules:GetGameTime() + 1
end

BehaviorBlade.Continue = BehaviorBlade.Begin

function BehaviorBlade:Think(dt)
end