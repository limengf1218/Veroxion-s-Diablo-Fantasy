--CoreLib is responsible for defining player hooks, interface functions, and other aggregate functions
--assign self to MD3CoreLib
MD3CoreLib = {};
self = MD3CoreLib;

self.MD3ResourceValueFunctions = {
	["health"] = {
		getMaxValue = function(unit) return UnitHealthMax(unit) end,
		getCurrentValue = function(unit) return UnitHealth(unit) end
	},
	["defaultPower"] = {
		--there are tons and tons and tons and tons and tons of powers, so we'll get to that later
		getMaxValue = function(unit) return UnitPowerMax(unit) end,
		getCurrentValue = function(unit) return UnitPower(unit) end
	},
	[Enum.PowerType.Mana] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Mana) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Mana) end
	},
	[Enum.PowerType.Rage] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Rage) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Rage) end
	},
	[Enum.PowerType.Focus] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Focus) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Focus) end
	},
	[Enum.PowerType.Energy] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Energy) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Energy) end
	},
	[Enum.PowerType.ComboPoints] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.ComboPoints) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.ComboPoints) end
	},
	[Enum.PowerType.Runes] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Runes) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Runes) end
	},
	[Enum.PowerType.RunicPower] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.RunicPower) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.RunicPower) end
	},
	[Enum.PowerType.SoulShards] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.SoulShards) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.SoulShards) end
	},
	[Enum.PowerType.LunarPower] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.LunarPower) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.LunarPower) end
	},
	[Enum.PowerType.HolyPower] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.HolyPower) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.HolyPower) end
	},
	[Enum.PowerType.Maelstrom] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Maelstrom) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Maelstrom) end
	},
	[Enum.PowerType.Chi] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Chi) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Chi) end
	},
	[Enum.PowerType.Insanity] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Insanity) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Insanity) end
	},
	[Enum.PowerType.ArcaneCharges] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.ArcaneCharges) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.ArcaneCharges) end
	},
	[Enum.PowerType.Fury] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Fury) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Fury) end
	},
	[Enum.PowerType.Pain] = {
		getMaxValue = function(unit) return UnitPowerMax(unit, Enum.PowerType.Pain) end,
		getCurrentValue = function(unit) return UnitPower(unit, Enum.PowerType.Pain) end
	},
}

self.MD3SetFrameUnitHooks = {
	["target"] = function(orb)
		orb:RegisterEvent("PLAYER_TARGET_CHANGED");
		orb:SetScript("OnEvent", function(self, event)
			if(UnitExists(orb.unit)) then
				MD3Utils:SetTextureRGBOpaqueFloat(orb.fill, MD3Utils:GetClassRGBColors(MD3CoreLib:UnitClassWrapper(false,true,false,orb.unit)));
			end
		end);
	end,
	["targettarget"] = function(orb)
		orb:RegisterEvent("PLAYER_TARGET_CHANGED");
		orb:SetScript("OnEvent", function(self, event)
			if(UnitExists(orb.unit)) then
				MD3Utils:SetTextureRGBOpaqueFloata(orb.fill, MD3Utils:GetClassRGBColors(MD3CoreLib:UnitClassWrapper(false,true,false,orb.unit)), 1);
			end
		end);
	end,
	["player"] = function(orb)

	end,
	["pet"] = function(orb)

	end,
}

function self:SetOrbUnit(orb, unit)
	orb.unit = unit;
	orb:SetAttribute("unit", unit);
	RegisterUnitWatch(orb);
end

function self:SetOrbUnitFunctions(orb, unit)
	if not orb.unit then orb.unit = unit end;
	orb:RegisterForClicks("RightButtonUp");
	orb:SetAttribute("type1", "target");
	orb:SetAttribute("type2", "togglemenu");
	orb:SetAttribute("OnEnter", function()
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetUnit(orb.unit);
	end);
end

function self:SetOrbUnitAndUnitFunctions(orb, unit)
	self:SetOrbUnit(orb, unit);
	self:SetOrbUnitFunctions(orb);
	self.MD3SetFrameUnitHooks[unit](orb);
end

function self:SetOrbResourceType(orb, resourceType)
	orb.resourceType = resourceType;
	orb.resourceMaxValueFunction = self.MD3ResourceValueFunctions[resourceType].getMaxValue;
	orb.resourceCurrentValueFunction = self.MD3ResourceValueFunctions[resourceType].getCurrentValue;
end

--todo -> write some comments as to what this even does, it's confusing as shit
function self:UnitClassWrapper(returnFirst, returnSecond, returnThird, unit)
	local first, second, third = UnitClass(unit)

	if(returnFirst and not returnSecond and not returnThird) then
		return first;
	end
	if(returnSecond and not returnFirst and not returnThird) then
		return second;
	end
	if(returnThird and not returnSecond and not returnThird) then
		return third;
	end
	if(returnFirst and returnSecond and not returnThird) then
		return first, second;
	end
	if(returnFirst and returnThird and not returnSecond) then
		return first, third;
	end
	if(returnSecond and returnThird and not returnFirst) then
		return second, third;
	end
end

--MonitorFill expects the orb frame to have undergone unit and resource setup in MD3CoreLib or elsewhere, prior to being able to monitor a resource
function self:MonitorOrbFill(orbFrame)
	local fill = orbFrame.fill;
	if (orbFrame.fill ~= nil and 
		orbFrame.resourceCurrentValueFunction ~= nil 
		and orbFrame.resourceMaxValueFunction ~= nil) then
		MD3Utils:SetTextureVerticalFill(
			fill, 
			fill.size, 
			orbFrame.resourceCurrentValueFunction(orbFrame.unit) / orbFrame.resourceMaxValueFunction(orbFrame.unit));
	end
end



----------------Orb Creation Functions-----------------
function self:CreateOrbWithSingleFill(frameName, containerName, fillName)
	local container = MD3Config.MD3Textures.containers[containerName];
	local fill = MD3Config.MD3Textures.fills[fillName];

	local orbFrame = CreateFrame("Button", frameName, UIParent, "SecureUnitButtonTemplate");
	orbFrame:SetHeight(container.size);
	orbFrame:SetWidth(container.size);
	orbFrame:SetFrameStrata("BACKGROUND");

	orbFrame.overlay = orbFrame:CreateTexture(nil, "OVERLAY");
	orbFrame.overlay:SetTexture(container.filePath);
	orbFrame.overlay.size = container.size;
	orbFrame.overlay:SetPoint("CENTER", 0, 0);
	MD3Utils:SetTextureSquareSize(orbFrame.overlay, container.size);

	orbFrame.fill = orbFrame:CreateTexture(nil, "BACKGROUND");
	orbFrame.fill:SetTexture(fill.filePath, false, true);
	orbFrame.fill.size = fill.size;
	orbFrame.fill:SetVertexColor(0.41, 0.80, 0.94, 1);
	orbFrame.fill:SetPoint("BOTTOM", 0, 0);
	MD3Utils:SetTextureSquareSize(orbFrame.fill, container.size);
	orbFrame.fill.resourceCurrentValueFunction = nil;
	orbFrame.fill.resourceMaxValueFunction = nil;
	orbFrame.fill:SetAlpha(1);
	orbFrame:ClearAllPoints();
	orbFrame:SetPoint("CENTER", nil, "CENTER", 0, 0);
	orbFrame:SetScript("OnUpdate", function(orbFrame)
		MD3CoreLib:MonitorOrbFill(orbFrame);
	end);
	return orbFrame;
end

------------------- Aggregating Functions -------------------
function self:CreateOrbWithSingleFillComplete(orbName, containerName, fillName, unitType, resourceType, orbScale, moveButton, moveLogic)
	local newOrb = MD3CoreLib:CreateOrbWithSingleFill(orbname, containerName, fillName);
	MD3CoreLib:SetOrbUnitAndUnitFunctions(newOrb, unitType);
	MD3CoreLib:SetOrbResourceType(newOrb, resourceType);
	MD3Utils:SetFrameScale(newOrb, orbScale);
	MD3Utils:SetFrameMovableWithCustomLogic(newOrb, moveButton, moveLogic);

	return newOrb;
end

self.PlayerClass = self:UnitClassWrapper(false, true, false, "player");
