modifier_summon1 = class({})

--------------------------------------------------------------------------------

function modifier_summon1:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_summon1:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_summon1:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_summon1:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill( false )
	end
end

--------------------------------------------------------------------------------

function modifier_summon1:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_LIFETIME_FRACTION
	}

	return funcs
end

--------------------------------------------------------------------------------

-- function modifier_summon1:GetUnitLifetimeFraction( params )
-- 	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
-- end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
