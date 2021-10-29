package.path = package.path .. ";../?.lua"
require("queue")
require("utils")

function SummonAxe(keys)
    Summon(keys.caster, "axe")
end

function SummonBane(keys)
    Summon(keys.caster, "bane")
end

function SummonLifeStealer(keys)
    Summon(keys.caster, "life_stealer")
end

function SummonSpiritBreaker(keys)
    Summon(keys.caster, "spirit_breaker")
end

function SummonPhantomAssassin(keys)
    Summon(keys.caster, "phantom_assassin")
end

function SummonRattleTrap(keys)
    Summon(keys.caster, "rattletrap")
end

function SummonNecrolyte(keys)
    Summon(keys.caster, "necrolyte")
end

function SummonChaosKnight(keys)
    Summon(keys.caster, "chaos_knight")
end

function Summon(caster, card)
    local unit = CreateUnitByName("custom_"..card, caster:GetAbsOrigin(), true, caster, caster:GetOwner(), caster:GetTeamNumber() )

    local next_card = Queue.popleft(GameRules:GetGameModeEntity().card_queue[caster:GetTeamNumber()])

    print("Swapping", card, next_card)
    caster:SwapAbilities("summon_"..card, "summon_"..next_card, false, true)
    
    Queue.pushright(GameRules:GetGameModeEntity().card_queue[caster:GetTeamNumber()], card)
end
