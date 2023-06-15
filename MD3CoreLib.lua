--CoreLib is responsible for defining player hooks, interface functions, and other aggregate functions
--assign self to MD3CoreLib
MD3CoreLib = {};
self = MD3CoreLib;

self.MD3ResourceValueFunctions = {
	["test"] = {
		getMaxValue = function(unit, stateObj) return MD3CoreLib:GetStateObjectResourceMaxValue(stateObj) end,
		getCurrentValue = function(unit, stateObj) return MD3CoreLib:GetStateObjectResourceValue(stateObj) end
	},
	["health"] = {
		getMaxValue = function(unit) return UnitHealthMax(unit) end,
		getCurrentValue = function(unit) return UnitHealth(unit) end
	},
	["absorbs"] = {
		getMaxValue = function(unit) return UnitHealthMax(unit) end,
		getCurrentValue = function(unit) return UnitGetTotalAbsorbs(unit) end
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
	}
}

--- Hook Helpers ---
local function OnTargetChanged(orb)
	MD3CoreLib:SetOrbColorDefaults(orb);
	MD3Utils:ForEachSortedElementDo(orb.fills, function(_, fill)
		fill.CurrentValue = nil;
	end);
end

self.MD3SetFrameUnitHooks = {
	["target"] = function(orb)
		orb:RegisterEvent("PLAYER_TARGET_CHANGED");
		orb:SetScript("OnEvent", function(self, event)
			OnTargetChanged(orb);
		end);
	end,
	["targettarget"] = function(orb)
		orb:RegisterEvent("PLAYER_TARGET_CHANGED");
		orb:SetScript("OnEvent", function(self, event)
			OnTargetChanged(orb);
		end);
	end,
	["player"] = function(orb)

	end,
	["test"] = function(orb)

	end,
	["pet"] = function(orb)
		orb:RegisterEvent("UNIT_PET");
		orb:SetScript("OnEvent", function(self, event)
			MD3CoreLib:SetOrbColorDefaults(orb);
		end);
	end
}

function self:SetOrbUnit(orb, unit)
	orb.unit = unit;
end

function self:SetOrbUnitFunctions(orb, unit, unitWatchState)
	if not orb.unit then orb.unit = unit end;
	if unitWatchState == nil then unitWatchState = false end;

	--set the orb's unit attributes
	orb:SetAttribute("unit", unit);
	RegisterUnitWatch(orb, unitWatchState);
	--set the orb's click registrations
	orb:RegisterForClicks("AnyUp");
	orb:SetAttribute("type1", "target");
	orb:SetAttribute("type2", "togglemenu");
	orb:SetScript("OnEnter", function()
		GameTooltip_SetDefaultAnchor(GameTooltip,UIParent)
		GameTooltip:SetUnit(orb.unit);
		GameTooltip:Show();
	end);
	orb:SetScript("OnLeave", function()
		GameTooltip:Hide();
	end);
end

function self:SetOrbUnitAndUnitFunctions(orb, unit, unitWatchState)
	self:SetOrbUnit(orb, unit);
	self.MD3SetFrameUnitHooks[unit](orb);
	if(unit ~= "test") then
		self:SetOrbUnitFunctions(orb, unit, unitWatchState);
	end
end

--- You may optionally supply a state object to the fill's resource functions ---
function self:SetFillResourceType(fill, resourceType, stateObject)
	fill.resourceType = resourceType;
	fill.resourceMaxValueFunction = self.MD3ResourceValueFunctions[resourceType].getMaxValue;
	fill.resourceCurrentValueFunction = self.MD3ResourceValueFunctions[resourceType].getCurrentValue;
	if(stateObject ~= nil) then
		fill.resourceStateObject = stateObject;
	end
end

function self:GetFillResourceValues(fill)
	local curVal = fill.resourceCurrentValueFunction(fill.orbParent.unit, fill.resourceStateObject);
	local maxVal = fill.resourceMaxValueFunction(fill.orbParent.unit, fill.resourceStateObject);

	return curVal, maxVal
end

--MonitorFill expects the orb frame to have undergone unit and resource setup in MD3CoreLib or elsewhere, prior to being able to monitor a resource
function self:MonitorFill(fill, unit)
	if (fill ~= nil and 
		fill.resourceCurrentValueFunction ~= nil 
		and fill.resourceMaxValueFunction ~= nil) then
		local actualCurrentValue, maxValue = self:GetFillResourceValues(fill);
		fill.MaxValue = maxValue;

		if(fill.CurrentValue == nil or fill.CurrentValue > fill.MaxValue) then
			fill.CurrentValue = actualCurrentValue;
		end
		---come back to this, fill velocity is meant to be modifiable
		local fillVelocity = 10;
		fill.CurrentValue = MD3Utils:Lerpf(fill.CurrentValue, actualCurrentValue, fillVelocity * MD3Utils.deltaTime);
		fill.CurrentValue = math.ceil(fill.CurrentValue);

		MD3Utils:SetTextureVerticalFill(
			fill, 
			fill.size, 
			fill.CurrentValue / fill.MaxValue);

		if fill.animationTextureMask ~= nil then
			MD3Utils:SetTextureVerticalFill(
			fill.animationTextureMask, 
			fill.size, 
			fill.CurrentValue / fill.MaxValue);
		end

		--update label values
		if(fill.valueLabels ~= nil) then
			for _, label in pairs(fill.valueLabels) do
				self:SetValueLabelResourceValues(label, fill.CurrentValue, fill.MaxValue);
			end
		end
	end
end

function self:SomeFunction(self)

end

--Makes informed decisions about how to set the text value of a fill's value label
function self:SetValueLabelResourceValues(valueLabel, resourceCurrentValue, resourceMaxValue)
	--this will switch and call different text functions, for now, show the resource's current value
	local labelValue = "";
	if(valueLabel.labelType == MD3Config.MD3LabelTypes.Percentage) then
		labelValue = tostring(MD3Utils:RoundNumber((resourceCurrentValue / resourceMaxValue) * 100));
	elseif(valueLabel.labelType == MD3Config.MD3LabelTypes.CommaSeparated) then
		labelValue = MD3Utils:CommaSeparateNumber(resourceCurrentValue);
	elseif(valueLabel.labelType == MD3Config.MD3LabelTypes.Truncated) then
		labelValue = MD3Utils:TruncateNumber(resourceCurrentValue);
	elseif(valueLabel.labelType == MD3Config.MD3LabelTypes.Raw) then
		labelValue = resourceCurrentValue;
	end

	--handle prefixes and postfixes.
	if(valueLabel.prefix ~= nil) then
		labelValue = valueLabel.prefix .. labelValue;
	end

	if(valueLabel.postfix ~= nil) then
		labelValue = labelValue .. valueLabel.postfix;
	end

	if(resourceCurrentValue == 0 and valueLabel.hideWhenZero) then
		labelValue = "";
	end

	if(labelValue ~= valueLabel:GetText()) then
		valueLabel:SetText(labelValue);
		valueLabel.previousRawValue = resourceCurrentValue;
	end
end

-------- Helpers --------
function self:ProfileExists(orb, profileName)
	local profileExists = false;
	MD3Utils:ForEachSortedElementDo(orb.data.profileNames, function(_, _pn)
		profileExists = (_pn == profileName);
	end);

	return profileExists;
end

--iterates through an orb and invokes a callback for each colorizable component
function self:ForEachOrbComponentDo(orb, callback)
	MD3Utils:ForEachSortedElementDo(orb.fills, function(_, fill)
		callback(fill);
		MD3Utils:ForEachSortedElementDo(fill.animationTextures, function(_, animationTexture)
			callback(animationTexture);
		end);
	end);
end

--attemps to create a new color profile
function self:CreateNewOrbProfile(orb, profileName)
	if(not self:ProfileExists(orb, profileName)) then
		table.insert(orb.data.profileNames, profileName);
		--create a default color state for all components with this profile name
		self:ForEachOrbComponentDo(orb, function(component)
			component.data.colorProfiles[profileName] = { };
			component.data.colorProfiles[profileName].color = {
				r = 1,
				g = 1,
				b = 1,
				a = 1
			};
		end);
	end
end

function self:SetComponentProfileColor(orbComponent, profileName)
	--if the color profile for this element has been set, set the color
	local cp = orbComponent.data.colorProfiles[profileName];
	if(cp ~= nil) then
		MD3Utils:SetTextureRGBAFloat(orbComponent, MD3CoreLib:GetColorDataModelRGBA(cp));
	end
end

function self:SetOrbActiveProfile(orb, profileName)
	--set the orb's active profile
	orb.activeProfile = profileName;
	self:ForEachOrbComponentDo(orb, function(component)
		--set the new profile for all components
		self:SetComponentProfileColor(component, profileName);
	end);
end

function self:GetColorDataModelRGBA(colorDataModel)
	if(colorDataModel.color ~= nil) then
		return 
			colorDataModel.color.r, 
			colorDataModel.color.g, 
			colorDataModel.color.b, 
			colorDataModel.color.a;
	end
	return nil;
end
function self:SetDataModelColor(colorDataModel, r, g, b, a)
	if(colorDataModel == nil) then
		colorDataModel = { };
	end
	colorDataModel.r = r;
	colorDataModel.g = g;
	colorDataModel.b = b;
	colorDataModel.a = a;

	return r, g, b, a;
end
function self:SetFillRGBA(fill, r, g, b, a)
	MD3Utils:SetTextureRGBAFloat(fill, r, g, b, a);
	if(fill.data ~= nil) then
		self:SetDataModelColor(fill.data.color, r, g, b, a);
	end
end

function self:SetAnimationTextureRGBA(animationTexture, r, g, b, a)
	MD3Utils:SetTextureRGBAFloat(animationTexture, r, g, b, a);
	if(animationTexture.data ~= nil) then
		self:SetDataModelColor(animationTexture.data.color, r, g, b, a);
	end
end

function self:SetFillAnimationTexturesRGBA(fill, r, g, b, a)
	MD3Utils:ForEachSortedElementDo(fill.animationTextures, 
		function(index, animationTexture)
			MD3CoreLib:SetAnimationTextureRGBA(animationTexture, r, g, b, a);
		end);
end

------- Color setting Aggregates --------
function self:SetFillDefaultColors(fill)
	local r, g, b;
	if(fill.resourceType == "health") then
		r, g, b = MD3Utils:GetClassRGBColors(
			MD3Utils:UnitClassWrapper(false,true,false,fill.orbParent.unit));
	elseif(fill.resourceType == "absorbs") then
		r, g, b = 1, 1, 1;
	else
		r,g,b =	MD3Utils:GetPowerRGBColors(
			MD3Utils:GetUnitPowerType(fill.orbParent.unit));
	end
	MD3CoreLib:SetFillRGBA(fill, r,g,b,1);
end

function self:SetFillAnimationTextureDefaultColors(fill)
	local r,g,b,a = fill:GetVertexColor();
	--pull this from an actual defaults table later...
	a = .5;
	self:SetFillAnimationTexturesRGBA(fill, r,g,b,a);
end

function self:SetOrbColorDefaults(orb)
	if(UnitExists(orb.unit)) then
		MD3Utils:ForEachSortedElementDo(orb.fills, 
			function(fillNumber, fill)
				MD3CoreLib:SetFillDefaultColors(fill);
				MD3CoreLib:SetFillAnimationTextureDefaultColors(fill);
			end);
	end
end

----------------Orb Update/Create Functions-----------------
function self:UpdateOrbAttributes(orb, fillType, scale)
	orb.fillType = fillType;
	orb:SetScale(scale);
end

function self:UpdateOrbTexture(orbTexture, containerData, customLayer, blendMode, rgba)
	--assume RGBA properties if none were supplied
	if(rgba == nil) then
		rgba = {r = 1, g = 1, b = 1, a = 1}
	end
	if(customLayer == nil) then
		customLayer = "OVERLAY";
	end
	if(blendMode == nil) then
		blendMode = "BLEND";
	end

	orbTexture:SetTexture(containerData.filePath);
	orbTexture.size = containerData.size;
	orbTexture:SetBlendMode(blendMode);
	MD3Utils:SetTextureSquareSize(orbTexture, orbTexture.size);
	MD3Utils:SetTextureRGBAFloat(orbTexture, rgba.r, rgba.g, rgba.b, rgba.a);
	--set the draw layer
	orbTexture:SetDrawLayer(customLayer);
end

function self:CreateOrb(frameName, containerData, fillType, scale, customLayer, blendMode, rgba)
	if(scale == nil) then
		scale = 1;
	end
	local orbFrame = CreateFrame("Button", frameName, UIParent, "SecureUnitButtonTemplate");
	orbFrame:SetHeight(containerData.size);
	orbFrame:SetWidth(containerData.size);
	orbFrame:SetFrameStrata("LOW");
	orbFrame:SetFrameLevel(0);
	orbFrame:ClearAllPoints();
	orbFrame:SetPoint("CENTER", 0, 0);
	--update orb attributes
	self:UpdateOrbAttributes(orbFrame, fillType, scale);

	orbFrame.overlay = orbFrame:CreateTexture();
	orbFrame.overlay:SetPoint("CENTER", 0, 0);
	self:UpdateOrbTexture(orbFrame.overlay, containerData, customLayer, blendMode, rgba);

	--setup orbData relationships
	orbFrame.fills = { };
	orbFrame.data = { };
	orbFrame.data.name = frameName;

	return orbFrame;
end

--- Fill Texture Update/Create Functions ---
function self:UpdateFillTexture(fillTexture, fillData, customLayer, blendMode, rgba)
	--assume RGBA properties if none were supplied
	if(rgba == nil) then
		rgba = {r = 1, g = 1, b = 1, a = 1}
	end
	if(customLayer == nil) then
		customLayer = "BACKGROUND";
	end
	if(blendMode == nil) then
		blendMode = "BLEND";
	end

	fillTexture:SetTexture(fillData.filePath, false, true);
	fillTexture.size = fillData.size;
	fillTexture:SetBlendMode(blendMode);
	MD3Utils:SetTextureSquareSize(fillTexture, fillTexture.size);
	MD3Utils:SetTextureRGBAFloat(fillTexture, rgba.r, rgba.g, rgba.b, rgba.a);
	--set the draw layer
	fillTexture:SetDrawLayer(customLayer);
end

function self:CreateOrbFill(orbFrame, fillData, customLayer, blendMode, rgba)
	local fillTexture = orbFrame:CreateTexture();
	fillTexture:SetPoint("BOTTOM", 0, 0);
	self:UpdateFillTexture(fillTexture, fillData, customLayer, blendMode, rgba);

	--the fill will automatically listen for change on an update hook for the orb's unit
	orbFrame:HookScript("OnUpdate", function(orbFrame)
		MD3CoreLib:MonitorFill(fillTexture);
	end);

	--define, but set no value;
	fillTexture.resourceCurrentValueFunction = nil;
	fillTexture.resourceMaxValueFunction = nil;

	--fills can always refer back to their orbParent
	fillTexture.orbParent = orbFrame;
	table.insert(orbFrame.fills, fillTexture);

	--fills always have an animationTextures table
	fillTexture.animationTextures = { };

	--fills always have a valueLabels table
	fillTexture.valueLabels = { };
	return fillTexture;
end

--- Fill Mask Texture Update/Create Functions ---
function self:UpdateMaskTexture(maskTexture, maskData, customLayer)
	if(customLayer == nil) then
		customLayer = "BACKGROUND";
	end

	maskTexture:SetTexture(maskData.filePath, maskData.clampTypeX, maskData.clampTypeY);
	maskTexture:SetHeight(maskData.height);
	maskTexture:SetWidth(maskData.width);
	--set the draw layer
	maskTexture:SetDrawLayer(customLayer);
end

function self:CreateFillMask(fill, maskData, customLayer)
	if(fill.animationTextureMask == nil) then
		local newMask = fill.orbParent:CreateMaskTexture();
		newMask:SetPoint(maskData.attachPoint, maskData.offsetX, maskData.offsetY);
		self:UpdateMaskTexture(newMask, maskData, customLayer);

		--fills can always reference their animationTextureMask
		fill.animationTextureMask = newMask;
		
		--animationTextureMasks can always reference their parent fill
		newMask.fill = fill;
	end

	return fill.animationTextureMask;
end

--- Animation Texture Update/Create Functions ---
function self:UpdateAnimationTexture(animationTexture, animationData, customLayer, blendMode, rgba)
	--assume RGBA properties if none were supplied
	if(rgba == nil) then
		rgba = {r = 1, g = 1, b = 1, a = 1}
	end
	if(customLayer == nil) then
		customLayer = "BORDER"
	end
	if(blendMode == nil) then
		blendMode = "ADD"
	end
	--update according to the new animationData
	animationTexture:SetTexture(animationData.filePath);
	animationTexture.size = animationData.size;
	MD3Utils:SetTextureSquareSize(animationTexture, animationTexture.size);
	animationTexture:SetBlendMode(blendMode);
	MD3Utils:SetTextureRGBAFloat(animationTexture, rgba.r, rgba.g, rgba.b, rgba.a);
	--set the draw layer
	animationTexture:SetDrawLayer(customLayer);
end

function self:CreateFillAnimationTexture(fill, animationData, customLayer, blendMode, rgba)
	--create the new animation texture
	local animationTexture = fill.orbParent:CreateTexture();
	--animation textures for now, are hardcoded to have a center point with no offset, we may change this eventually to be more data driven, but I doubt it.
	animationTexture:SetPoint("CENTER", 0, 0);
	animationTexture.fill = fill;
	self:UpdateAnimationTexture(animationTexture, animationData, customLayer, blendMode, rgba);

	--add the animationTexture as a child of the fill
	table.insert(fill.animationTextures, animationTexture);
	return animationTexture;
end

function self:TrySetFillAnimationMasks(fill)
	--for each animation that's part of the fill, if the fill has a mask texture, and the animation hasn't already set one, then add the mask texture to the animation
	MD3Utils:ForEachSortedElementDo(fill.animationTextures, 
		function(animationNumber, animationTexture)
			if(not animationTexture.isMaskSet and fill.animationTextureMask ~= nil) then
				animationTexture:AddMaskTexture(fill.animationTextureMask);
				animationTexture.isMaskSet = true;
			end
		end);
end

function self:CreateAnimationTextureRotationAnimation(animationTexture, animationDuration, degreeMultiplier)
	if(animationTexture.animationGroup == nil) then
		local animationGroup = animationTexture:CreateAnimationGroup();
		local rotationAnimation = animationGroup:CreateAnimation("Rotation");
		rotationAnimation:SetDegrees(360 * degreeMultiplier);
		rotationAnimation:SetDuration(animationDuration);
		animationGroup:Play();
		animationGroup:SetLooping("REPEAT");

		--nav
		animationTexture.animationGroup = animationGroup;
		animationGroup.animations = { };

		--self explanatory, array linking to all of the animations affected by this group
		table.insert(animationGroup.animations, rotationAnimation);
		return animation;
	end

	return nil;
end

function self:UpdateValueLabel(valueLabel, fontData, fontSize, labelType, offsets, customOutlineType, customLayer, rgba, labelPrefix, labelPostfix, hideWhenZero)
	if(offsets == nil) then
		offsets = {x = 0, y = 0};
	end
	if(rgba == nil) then
		rgba = {r = 1, g = 1, b = 1, a = 1}
	end
	if(customLayer == nil) then
		customLayer = "OVERLAY";
	end
	if(customOutlineType == nil) then
		customOutlineType = "THINOUTLINE";
	end
	valueLabel:SetFont(fontData.filePath, fontSize, customOutlineType);
	valueLabel:SetPoint("CENTER", offsets.x, offsets.y);
	valueLabel:SetTextColor(rgba.r, rgba.g, rgba.b, rgba.a);
	valueLabel:SetText("100"); --probably not needed, a fill will update this text component's value
	valueLabel:SetDrawLayer(customLayer);
	valueLabel.labelType = labelType;
	valueLabel.prefix = labelPrefix;
	valueLabel.postfix = labelPostfix;
	valueLabel.hideWhenZero = hideWhenZero;
	valueLabel.offsets = offsets;
end

--- Fill Label Create / Update Functions ---
function self:CreateValueLabel(fill, fontData, fontSize, labelType, offsets, customOutlineType, customLayer, rgba, labelPrefix, labelPostfix, hideWhenZero)
	local newLabel = fill.orbParent:CreateFontString();
	newLabel.fill = fill;
	self:UpdateValueLabel(newLabel, fontData, fontSize, labelType, offsets, customOutlineType, customLayer, rgba, labelPrefix, labelPostfix, hideWhenZero);
	table.insert(fill.valueLabels, newLabel);

	return newLabel;
end

---------------- Decorations ----------------
function self:CreateDecoration(frameName, decorationName, scale, moveButton, moveLogic, customFrameStrata)
	local decorationData = MD3Config.MD3Textures.decorations[decorationName];
	local decorationFrame = CreateFrame("Frame", decorationName, UIParent);

	if(customFrameStrata == nil) then
		customFrameStrata = "BACKGROUND"
	end

	decorationFrame:SetHeight(decorationData.size);
	decorationFrame:SetWidth(decorationData.size);
	decorationFrame:SetFrameStrata(customFrameStrata);

	decorationFrame.decorationTexture = decorationFrame:CreateTexture(nil, "BACKGROUND");
	decorationFrame.decorationTexture:SetTexture(decorationData.filePath);
	decorationFrame.decorationTexture.size = decorationData.size;
	decorationFrame.decorationTexture:SetPoint("BOTTOM", 0, 0);

	decorationFrame:ClearAllPoints();
	decorationFrame:SetPoint("CENTER", 0, 0);

	--set size and movability
	MD3Utils:SetTextureSquareSize(decorationFrame.decorationTexture, decorationFrame.decorationTexture.size);
	MD3Utils:SetFrameMovableWithCustomLogic(decorationFrame, moveButton, moveLogic);
	MD3Utils:SetFrameScale(decorationFrame, scale);

	return decorationFrame;
end

------------------- Custom State Functions -------------------
function self:GetStateObjectResourceValue(stateObject)
	return stateObject.resourceCurrentValue;
end

function self:GetStateObjectResourceMaxValue(stateObject)
	return stateObject.resourceMaxValue;
end

--doesn't go here, but we'll move it another time
self.PlayerClass = MD3Utils:UnitClassWrapper(false, true, false, "player");