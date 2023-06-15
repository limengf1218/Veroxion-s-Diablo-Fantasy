--Utils contains convenience functions for textures, scaling, moving things, etc

--assign to self
MD3Utils = {};
self = MD3Utils;
self.deltaTime = 0;

--I literally ripped this straight from here: https://www.lua.org/pil/19.3.html
--Custom iterator for iterating over tables in a sorted manner by key name.  There is no need to rewrite it or MD3-ify it.
function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

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

-- interpolation
--normal linear interpolation
function self:Lerpf(a, b, t)
	return a + ((b - a) * t);
end

--number formatting
function self:RoundNumber(number)
	if(number > 0) then
		math.floor(number + 0.5);
	end

	return math.ceil(number - 0.5);
end

--returns a string representation of the original number, truncated up to billions
function self:TruncateNumber(number)
	local newNumber = self:RoundNumber(number);
	if number > 999999999 then
		newNumber = (floor((number/1000000000)*10)/10).."b";
	elseif number > 999999 then
		newNumber = (floor((number/1000000)*10)/10) .."m";
	elseif number > 999 then
		newNumber = (floor((number/1000)*10)/10) .."k";
	end

	return newNumber;
end

--returns a string representation of the original number, comma separated.
function self:CommaSeparateNumber(number)
	--convert the value to a string, reverse the string, so we're starting at the back, find any numerical sequence of three numbers, replace the occurrence with the occurrence, plus a comma, reverse the string so the number is the proper direction again, then, capture any comma sitting by its lonesome, and remove it.  Primarily to fix the leading comma at the front of our big number
	local newNumber = self:RoundNumber(number);
	newNumber = tostring(newNumber):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "");
	return newNumber;
end

--unit color functions
function self:GetClassRGBColors(className)
	return
		MD3Config.MD3ClassColors[className].r,
		MD3Config.MD3ClassColors[className].g,
		MD3Config.MD3ClassColors[className].b
end

function self:GetPowerRGBColors(powerTypeInteger)
	return
		MD3Config.MD3PowerColors[powerTypeInteger].r,
		MD3Config.MD3PowerColors[powerTypeInteger].g,
		MD3Config.MD3PowerColors[powerTypeInteger].b
end

function self:SetTextureRGBOpaqueFloat(texture, r, g, b)
	texture:SetVertexColor(r, g, b, 1);
end

function self:SetTextureRGBAFloat(texture, r, g, b, a)
	-- print(r.." ".. g .." ".. b .." " .. a);
	texture:SetVertexColor(r, g, b, a);
end

function self:SetTextRGBAFloat(text, r, g, b, a)
	text:SetTextColor(r, g, b, a);
end

function self:ConvertByteRGBAToFloatRGBA(r, g, b, a)
	return r / 255, g / 255, b / 255, a / 255;
end

function self:ConvertFloatRGBAToByteRGBA(r, g, b, a)
	return 
		self:RoundNumber(r * 255), 
		self:RoundNumber(g * 255), 
		self:RoundNumber(b * 255), 
		self:RoundNumber(a * 255);
end

function self:SetTextureRGBAByte(texture, rB, gB, bB, aB)
	local r, g, b, a = self:ConvertByteRGBAToFloatRGBA(rB, gB, bB, aB);
	return self:SetTextureRGBAFloat(texture, r, g, b, a);
end

--this is breaking for some unknown reason
function self:SetFrameScale(frame, scale)
	frame:SetScale(scale);
end

function self:SetTextureVerticalFill(texture, texHeight, fillLevel)
	if not type(fillLevel) == "number" or fillLevel == math.huge then fillLevel = 0 end;
	local verticalTexHeight = math.min(1, math.abs(fillLevel - 1));
	--if texHeight is set to 0, it bugs out and is actually just texHeight.  Don't let it be zero.
	texture:SetHeight(math.max(texHeight * fillLevel, .001));
	texture:SetTexCoord(0, 1, verticalTexHeight, 1);
end

function self:SetTextureTexture(texture, textureFilePath)
	texture:SetTexture(textureFilePath);
end

function self:SetTextureSquareSize(texture, size)
	texture:SetHeight(size);
	texture:SetWidth(size);
end

function self:SetFrameClampedToScreen(frame, clamp)
	frame:SetClampedToScreen(clamp);
end

function self:SetFrameMovable(frame, mouseButton)
	frame:SetClampedToScreen(true);
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:RegisterForDrag(mouseButton);
	frame:SetScript("OnDragStart", 
		function(self)
			self:StartMoving();
		end);
	frame:SetScript("OnDragStop", 
		function(self)
			self:StopMovingOrSizing();
		end);
end

function self:SetFrameMovableWithCustomLogic(frame, mouseButton, logicFunc)
	MD3Utils:SetFrameMovable(frame, mouseButton);
	frame:SetScript("OnDragStart", 
		function(self)
			if (logicFunc ~= nil and logicFunc()) then
				self:StartMoving();
			else
				self:StopMovingOrSizing();
			end
		end);
end

function self:SetFrameImmovable(frame)
	frame:SetMovable(false);
	frame:EnableMouse(false);
	frame:RegisterForDrag(nil);
	frame:SetScript("OnDragStart", nil);
	frame:SetScript("OnDragStop", nil);
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

function self:GetUnitPowerType(unit)
	local powerType = UnitPowerType(unit);
	return powerType;
end

-------Table functions--------
--performs a shallow copy of a table's data recursively - useful for serialization
function self:ShallowCopyTable(sourceTable, destinationTable)
	if(destinationTable == nil) then
		destinationTable = { };
	end

	for key, value in pairs(sourceTable) do
		if(type(value) == "table") then
			destinationTable[key] = { };
			self:ShallowCopyTable(sourceTable[key], destinationTable[key]);
		else
			destinationTable[key] = sourceTable[key];
		end
	end

	return destinationTable;
end

--wraps getn
function self:GetTableElementCount(sourceTable)
	return getn(sourceTable);
end

--gets a table's unique identifier as a string
function self:GetTableUID(sourceTable)
	local _, tableId = strsplit(":", tostring(sourceTable));
	tableId = strtrim(tableId);
	return tableId;
end

--will fill in missing data from one table to another, useful for setting new defaults over existing serialized data
function self:RecursiveIterateCompareAndAssignTableData(table1, table2)
	for key, value in pairs(table1) do
		--if table 2 is missing this value, set it, otherwise, iterate
		if table2[key] == nil then
			table2[key] = table1[key];
		end

		if type(value) == "table" then
			--if this is a table value, iterate through the table
			MD3Config:RecursiveIterateCompareAndAssignTableData(table1[key], table2[key]);
		end
	end
end

--useful for lambda-esque functionality when iterating over a known set of table data
function self:ForEachElementDo(sourceTable, callback, callbackContext)
	if(sourceTable == nil) then
		return
	end
	local index = 0;
	for key, value in pairs(sourceTable) do
		index = index + 1;
		callback(key, value, index, sourceTable, callbackContext);
	end
end

function self:ForEachSortedElementDo(sourceTable, callback, callbackContext)
	if(sourceTable == nil) then
		return
	end
	local index = 0;
	for key, value in pairsByKeys(sourceTable) do
		index = index + 1;
		callback(key, value, index, sourceTable, callbackContext);
	end
end

function self:DebugPrint(msg)
	if(MD3Config.MD3Environment == "dev") then
		print(msg);
	end
end

function self:TableContains(srcTable, comparisonValue)
	local result = false;
	local resultKey = nil;
	self:ForEachElementDo(srcTable, function(key, value)
		if(result == false and value == comparisonValue) then
			result = true;
			resultKey = key;
		end
	end);

	return result, resultKey;
end
--- Saving Helpers ---
--saving
function self:SaveOrb(orb)
	if(MD3PlayerData.orbs == nil) then
		MD3PlayerData.orbs = { };
	end
	MD3PlayerData.orbs[orb.data.name] = MD3Utils:ShallowCopyTable(orb.data, nil);
	table.sort(MD3PlayerData.orbs);
end

function self:SaveOrbs(orbs)
	MD3Utils:ForEachSortedElementDo(orbs, function (orbNum, orb)
		self:SaveOrb(orb);
	end);
end

--- Updating an orb ViewModel from an orb DataModel ---
function self:UpdateFillViewModelFromDataModel(fillViewModel)
	local data = fillViewModel.data;
	MD3CoreLib:UpdateFillTexture(
		fillViewModel,
		data.fillData,
		data.renderLayer,
		data.blendMode,
		data.colorProfiles.default.triggers.Default.color);

	if(fillViewModel.animationTextureMask ~= nil) then
		MD3CoreLib:UpdateMaskTexture(
			fillViewModel.animationTextureMask,
			data.maskData
		);
	end
end

function self:UpdateAnimationTextureFromDataModel(animationTextureViewModel)
	local data = animationTextureViewModel.data;
	MD3CoreLib:UpdateAnimationTexture(
		animationTextureViewModel, 
		data.animationData, 
		data.renderLayer, 
		data.blendMode,
		data.colorProfiles.default.triggers.Default.color);
end

function self:UpdateValueLabelFromDataModel(valueLabelViewModel)
	local data = valueLabelViewModel.data;
	MD3CoreLib:UpdateValueLabel(
		valueLabelViewModel,
		data.fontData,
		data.fontSize,
		data.labelType,
		data.offsets,
		data.outlineType,
		data.renderLayer,
		data.colorProfiles.default.triggers.Default.color,
		data.prefix,
		data.postfix,
		data.hideWhenZero);
end

function self:UpdateOrbViewModelFromOrbDataModel(orb)
	--first update the orb's stuff first
	MD3CoreLib:UpdateOrbAttributes(orb, orb.data.fillType, orb.data.scale);
	MD3CoreLib:UpdateOrbTexture(orb.overlay, orb.data.containerData);
	--update orb fills
	MD3Utils:ForEachSortedElementDo(orb.data.fills, function(fillKeyName, fill)
		--update the fillViewModel and the mask texture if it exists
		local fillViewModel = orb.fills[fillKeyName];
		fillViewModel.data = fill;
		MD3Utils:UpdateFillViewModelFromDataModel(fillViewModel);
		--update animation textures
		MD3Utils:ForEachSortedElementDo(fill.animationTextures, 
			function(animationTextureKeyName, animationTexture)
				local animationTextureViewModel = fillViewModel.animationTextures[animationTextureKeyName];
				animationTextureViewModel.data = animationTexture;
				MD3Utils:UpdateAnimationTextureFromDataModel(animationTextureViewModel);
			end);

		--value labels
		MD3Utils:ForEachSortedElementDo(fill.valueLabels, 
			function(valueLabelKey, valueLabel)
				local valueLabelViewModel = fillViewModel.valueLabels[valueLabelKey];
				valueLabelViewModel.data = valueLabel;
				MD3Utils:UpdateValueLabelFromDataModel(valueLabelViewModel);
			end);
	end);
end

--- Loading from Configuration ---
function self:LoadOrbFromData(orbDataEntry)
	--create the orb
	local newOrb = MD3CoreLib:CreateOrb(
		orbDataEntry.name,
		orbDataEntry.containerData,
		orbDataEntry.fillType,
		orbDataEntry.scale);

	--set the orb's unit type
	MD3CoreLib:SetOrbUnitAndUnitFunctions(newOrb, orbDataEntry.unit);

	--assign the orb's data, this will be used for configuration
	newOrb.data = orbDataEntry;

	--setup fills
	MD3Utils:ForEachSortedElementDo(orbDataEntry.fills, 
		function(fillNumber, fillDataEntry)
			--create the new fill
			local newFill = MD3Utils:LoadFillFromData(newOrb, fillDataEntry);

			--setup animationTextures and their animations
			MD3Utils:ForEachSortedElementDo(fillDataEntry.animationTextures,
				function(animationTextureNumber, animationTextureDataEntry)
					MD3Utils:LoadAnimationTextureFromData(newFill, animationTextureDataEntry);
				end);
			
			--set the mask for all animationLayers created
			MD3CoreLib:TrySetFillAnimationMasks(newFill);

			--create any fill labels
			MD3Utils:ForEachSortedElementDo(fillDataEntry.valueLabels,
				function(valueLabelNumber, valueLabelDataEntry)
					MD3Utils:LoadValueLabelFromData(newFill, valueLabelDataEntry);
				end);
		end);

	--once done, make the orb movable again...
	local moveFunction = MD3Config.MD3UserInteraction.DefaultMoveFunction;
	if(orbDataEntry.isPositionLocked) then
		moveFunctino = MD3Config.MD3UserInteraction.LockedMoveFunction;
	end
	MD3Utils:SetFrameMovableWithCustomLogic(
		newOrb, 
		MD3Config.MD3UserInteraction.DefaultMoveButton,
		moveFunction);

	--set the orb's active profile
	MD3CoreLib:SetOrbActiveProfile(newOrb, newOrb.activeProfile);
		
	--set update this model when an event is fired
	MD3Messager:Subscribe(
		MD3MessageTypes.OrbDataModelUpdated,
		function(updatedOrbDataModel)
			if(updatedOrbDataModel == newOrb.data) then
				self:UpdateOrbViewModelFromOrbDataModel(newOrb);	
			end
		end);
	
	MD3Messager:Subscribe(
		MD3MessageTypes.OrbDataSwapAndSaveRequested,
		function(updateRequest)
			if(newOrb.data == updateRequest.existingDataModel) then
				newOrb.data = updateRequest.newDataModel;
				self:UpdateOrbViewModelFromOrbDataModel(newOrb);
				MD3Behaviors:SetViewModelTriggers(newOrb);
				self:SaveOrb(newOrb);
			end
		end);

	--all orbs will have behavior hooks, this is done after the orb has been created.
	MD3Behaviors:RegisterForBehaviorUpdates(newOrb);

	return newOrb;
end

function self:LoadFillFromData(orb, fillDataEntry)
	local newFill = MD3CoreLib:CreateOrbFill(
		orb,
		fillDataEntry.fillData,
		fillDataEntry.renderLayer,
		fillDataEntry.blendMode,
		fillDataEntry.colorProfiles.default.triggers.Default.color);

	--create the fill mask
	local fillMask = MD3CoreLib:CreateFillMask(
		newFill, 
		fillDataEntry.maskData);

	--set the fill resourceType
	MD3CoreLib:SetFillResourceType(
		newFill,
		fillDataEntry.resourceType);

	--set the fill's data model
	newFill.data = fillDataEntry;

	--set update this model when an event is fired
	MD3Messager:Subscribe(
		MD3MessageTypes.FillDataModelUpdated,
		function(updatedFillDataModel)
			if(updatedFillDataModel == newFill.data) then
				MD3Utils:UpdateFillViewModelFromDataModel(newFill);
				MD3Utils:ForEachElementDo(newFill.animationTextures, function(k, at)
					MD3Utils:UpdateAnimationTextureFromDataModel(at);
				end);
			end
		end);
	
	newFill.setColor = function(r, g, b, a)
		MD3Utils:SetTextureRGBAFloat(newFill, r, g, b, a);
	end;

	return newFill;
end

function self:LoadAnimationTextureFromData(fill, animationTextureDataEntry)
	local newAnimationTexture = MD3CoreLib:CreateFillAnimationTexture(
		fill,
		animationTextureDataEntry.animationData,
		animationTextureDataEntry.renderLayer,
		animationTextureDataEntry.blendMode,
		animationTextureDataEntry.colorProfiles.default.triggers.Default.color);

	--set the animationTexture's animation
	MD3CoreLib:CreateAnimationTextureRotationAnimation(
		newAnimationTexture,
		animationTextureDataEntry.animation.animationDuration,
		animationTextureDataEntry.animation.degreeMultiplier);

	newAnimationTexture.data = animationTextureDataEntry;

	MD3Messager:Subscribe(
		MD3MessageTypes.AnimationDataModelUpdated,
		function(updatedAnimationDataModel)
			if(updatedAnimationDataModel == newAnimationTexture.data) then
				MD3Utils:UpdateAnimationTextureFromDataModel(newAnimationTexture);
			end
		end);
	
	newAnimationTexture.setColor = function(r, g, b, a)
		MD3Utils:SetTextureRGBAFloat(newAnimationTexture, r, g, b, a);
	end;

	return newAnimationTexture;
end

function self:LoadValueLabelFromData(fill, valueLabelDataEntry)
	local newValueLabel = MD3CoreLib:CreateValueLabel(
		fill,
		valueLabelDataEntry.fontData,
		valueLabelDataEntry.fontSize,
		valueLabelDataEntry.labelType,
		valueLabelDataEntry.offsets,
		valueLabelDataEntry.outlineType,
		valueLabelDataEntry.renderLayer,
		valueLabelDataEntry.colorProfiles.default.triggers.Default.color,
		valueLabelDataEntry.prefix,
		valueLabelDataEntry.postfix,
		valueLabelDataEntry.hideWhenZero);

	newValueLabel.data = valueLabelDataEntry;

	MD3Messager:Subscribe(
		MD3MessageTypes.ValueLabelDataModelUpdated,
		function(updatedValueLabelDataModel)
			if(updatedValueLabelDataModel == newValueLabel.data) then
				MD3Utils:UpdateValueLabelFromDataModel(newValueLabel);
			end
		end);
	
	newValueLabel.setColor = function(r, g, b, a)
		MD3Utils:SetTextRGBAFloat(newValueLabel, r, g, b, a);
	end;
	
	return newValueLabel;
end

function self:LoadOrbsFromData(orbData)
	local spawnedOrbs = { };
	MD3Utils:ForEachSortedElementDo(orbData, 
		--orb parent
		function(orbNumber, orbDataEntry)
			local newOrb = MD3Utils:LoadOrbFromData(orbDataEntry);
			table.insert(spawnedOrbs, newOrb);
		end);
	return spawnedOrbs;
end

function self:CreateNewPlayerProfile()
	local spawnedOrbs = self:LoadOrbsFromData(MD3Config.MD3PlayerDefaults.orbs);
	--save the data
	self:SaveOrbs(spawnedOrbs);
	return spawnedOrbs;
end

--- Orb Cloning ---
function self:CreateOrbDataCopy(orbDataModel)
	local orbDataCopy = self:ShallowCopyTable(orbDataModel);
	orbDataCopy.isClone = true;
	if(orbDataCopy.cloneIndex == nil) then
		orbDataCopy.cloneIndex = 1;
	else
		orbDataCopy.cloneIndex = orbDataCopy.cloneIndex + 1;
	end

	orbDataCopy.name = orbDataModel.name .. "-clone-"..orbDataCopy.cloneIndex;
	return orbDataCopy;
end

function self:CloneOrbFromDataModelWithPostCopyCallback(orbDataModel, postCopyCallback)
	local orbDataCopy = self:CreateOrbDataCopy(orbDataModel);
	postCopyCallback(orbDataCopy);
	local orbClone = self:LoadOrbFromData(orbDataCopy);
	orbClone:Show();

	return orbClone;
end

function self:CloneOrbFromDataModel(orbDataModel)
	local orbDataCopy = self:CreateOrbDataCopy(orbDataModel);
	local orbClone = self:LoadOrbFromData(orbDataCopy);
	orbClone:Show();

	return orbClone;
end

function self:CloneToExistingOrbFromDataModel(orbDataModel, targetOrb)
	local orbDataCopy = self:CreateOrbDataCopy(orbDataModel);
	targetOrb.data = orbDataCopy;
	self:UpdateOrbViewModelFromOrbDataModel(targetOrb);
end

function self:CloneOrb(orb)
	local orbDataModel = orb.Data;
	local orbClone = self:CloneOrbFromDataModel(orbDataModel);

	return orbClone;
end

--clones an orb's data to an existing orb
function self:CloneToExisting(orb, targetOrb)
	local orbDataModel = orb.Data;
	self:CloneToExistingOrbFromDataModel(orbDataModel, targetOrb);
end

--- Delta Time tracker for custom animations ---
local deltaTimeTrackerFrame = CreateFrame("Frame");
deltaTimeTrackerFrame.lastTime = nil;
deltaTimeTrackerFrame:SetScript("OnUpdate", function(self)
	local curTime = GetTime();
	if(self.lastTime == nil) then
		self.lastTime = curTime;
	end
	MD3Utils.deltaTime = curTime - self.lastTime;
	self.lastTime = curTime;
end);