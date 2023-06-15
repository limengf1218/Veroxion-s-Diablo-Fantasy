--Utils contains convenience functions for textures, scaling, moving things, etc

--assign to self
MD3Utils = {};
self = MD3Utils;

self.PowerTypeNames = {
	--0
	[Enum.PowerType.Mana] = {
		name = "Mana"
	},
	--1
	[Enum.PowerType.Rage] = {
		name = "Rage"
	},
	--2
	[Enum.PowerType.Focus] = {
		name = "Focus"
	},
	--3
	[Enum.PowerType.Energy] = {
		name = "Energy"
	},
	--4
	[Enum.PowerType.ComboPoints] = {
		name = "Combo Points"
	},
	--5
	[Enum.PowerType.Runes] = {
		name = "Runes"
	},
	--6
	[Enum.PowerType.RunicPower] = {
		name = "Runic Power"
	},
	--7
	[Enum.PowerType.SoulShards] = {
		name = "Soul Shards"
	},
	--8
	[Enum.PowerType.LunarPower] = {
		name = "Lunar Power"
	},
	--9
	[Enum.PowerType.HolyPower] = {
		name = "Holy Power"
	},
	--10
	[Enum.PowerType.Alternate] = {
		name = "Alternate"
	},
	--11
	[Enum.PowerType.Maelstrom] = {
		name = "Maelstrom"
	},
	--12
	[Enum.PowerType.Chi] = {
		name = "Chi"
	},
	--13
	[Enum.PowerType.Insanity] = {
		name = "Insanity"
	},
	--14
	[Enum.PowerType.Obsolete] = {
		name = "Obsolete"
	},
	--15
	[Enum.PowerType.Obsolete2] = {
		name = "Obsolete2"
	},
	--16
	[Enum.PowerType.ArcaneCharges] = {
		name = "Arcane Charges"
	},
	--17
	[Enum.PowerType.Fury] = {
		name = "Fury"
	},
	--18
	[Enum.PowerType.Pain] = {
		name = "Pain"
	}
}

self.ClassPowerTypes = {
	["WARRIOR"] = {
		Enum.PowerType.Rage
	},
	["PALADIN"] = {
		Enum.PowerType.Mana,
		Enum.PowerType.HolyPower
	},
	["HUNTER"] = {
		Enum.PowerType.Focus
	},
	["ROGUE"] = {
		Enum.PowerType.Energy,
		Enum.PowerType.ComboPoints
	},
	["PRIEST"] = {
		Enum.PowerType.Mana,
		Enum.PowerType.Insanity
	},
	["DEATHKNIGHT"] = {
		Enum.PowerType.RunicPower,
		Enum.PowerType.Runes
	},
	["SHAMAN"] = {
		Enum.PowerType.Mana,
		Enum.PowerType.Maelstrom
	},
	["MAGE"] = {
		Enum.PowerType.Mana,
		Enum.PowerType.ArcaneCharges
	},
	["WARLOCK"] = {
		Enum.PowerType.Mana,
		Enum.PowerType.SoulShards
	},
	["MONK"] = {
		Enum.PowerType.Mana,
		Enum.PowerType.Energy,
		Enum.PowerType.Chi
	},
	["DRUID"] = {
		Enum.PowerType.Mana,
		Enum.PowerType.Rage,
		Enum.PowerType.Energy,
		Enum.PowerType.ComboPoints
	},
	["DEMONHUNTER"] = {
		Enum.PowerType.Fury,
		Enum.PowerType.Pain
	}
}

function self:GetPlayerClassSpecializationName()
	local spec = GetSpecialization();
	--id, name, description, icon, background, role
	local specName = select(2, GetSpecializationInfo(1));

	return specName;
end

--unit color functions
function self:GetClassRGBColors(className)
	return
		MD3Config.MD3ClassColors[className].r,
		MD3Config.MD3ClassColors[className].g,
		MD3Config.MD3ClassColors[className].b
end

function self:GetPowerRGBColors(powerName)
	return
		MD3Config.MD3PowerColors[powerName].r,
		MD3Config.MD3PowerColors[powerName].g,
		MD3Config.Md3PowerColors[powerName].b
end

function self:SetTextureRGBOpaqueFloat(texture, r, g, b)
	texture:SetVertexColor(r, g, b, 1);
end

function self:SetTextureRGBAFloat(texture, r, g, b, a)
	texture:SetVertexColor(r, g, b, a);
end

function self:ConvertByteRGBToFloatRGB(r, g, b)
	return r / 255, g / 255, b / 255;
end

--this is breaking for some unknown reason
function self:SetFrameScale(frame, scale)
	frame:SetScale(scale);
end

function self:SetTextureVerticalFill(texture, texHeight, fillLevel)
	if not type(fillLevel) == "number" or fillLevel == math.huge then fillLevel = 0 end;
	local verticalTexHeight = math.min(1, math.abs(fillLevel - 1));
	texture:SetHeight(texHeight * fillLevel);
	texture:SetTexCoord(0, 1, verticalTexHeight, 1);
end

function self:SetTextureTexture(texture, textureFilePath)
	texture:SetTexture(textureFilePath);
end

function self:SetTextureSquareSize(texture, size)
	texture:SetHeight(size);
	texture:SetWidth(size);
end

function self:SetFrameMovableWithCustomLogic(frame, mouseButton, logicFunc)
	frame:SetClampedToScreen(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:RegisterForDrag(mouseButton);
	frame:SetScript("OnDragStart", function(self)
		if (logicFunc ~= nil and logicFunc()) then
			self:StartMoving();
		else
			self:StopMovingOrSizing();
		end
	 end);
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
	end)
end
