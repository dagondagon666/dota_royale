summon_one = class({})
-- LinkLuaModifier("modifier_summon1", LUA_MODIFIER_MOTION_NONE)

function summon_one:OnSpellStart()
    print("trigger?")
    local caster = self:GetCaster()
    local unit = CreateUnitByName("custom_axe", caster:GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber() )
    if unit ~= nil then
        -- Do we need to provide control?
    end
end