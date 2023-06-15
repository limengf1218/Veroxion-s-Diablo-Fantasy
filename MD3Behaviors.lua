MD3Behaviors = { };
self = MD3Behaviors;

local function getOrbViewModelShapeshiftInfos(orbViewModel)
    --double check that the orb is of type player
    if(orbViewModel.data.unit ~= "player") then
        return nil;
    end

    if(orbViewModel.shapeShiftInfos == nil) then
        local shapeshiftInfos = nil;
        local numShapeShiftForms = GetNumShapeshiftForms();
        if(numShapeShiftForms ~= nil and numShapeShiftForms > 0) then
            shapeshiftInfos = { count = 0, valueKeys = { } };
            for i = 1, numShapeShiftForms do
                local _, __, ___, spellId = GetShapeshiftFormInfo(i);
                local spellName, _, __, ___, ____, _____ = GetSpellInfo(spellId);
                shapeshiftInfos[spellName] = i;
                shapeShiftInfos.count = shapeShiftInfos.count + 1;
                shapeShiftInfos.valueKeys[i] = spellName;
            end
        end

        orbViewModel.shapeShiftInfos = shapeShiftInfos;
    end

    return orbViewModel.shapeshiftInfos;
end

local function getOrbViewModelSpecializationInfos(orbViewModel)
    if(orbViewModel.data.unit ~= "player") then
        return nil;
    end
    
    if(orbViewModel.specInfos == nil) then
        local specInfos = nil;
        local numSpecs = GetNumSpecializations();
        if(numSpecs ~= nil and numSpecs > 0) then
            specInfos = { count = 0, valueKeys = { } };
            for i = 1, numSpecs do
                local _, name, __, ___, ____, _____ = GetSpecializationInfo(i);
                specInfos[name] = i;
                specInfos.count = specInfos.count + 1;
                specInfos.valueKeys[i] = name;
            end
        end
        
        orbViewModel.specInfos = specInfos;
    end

    return orbViewModel.specInfos;
end

self.Triggers = {
    ["Default"] = {
        keyName = "Default",
        friendlyName = "Default/None",
        priority = 1,
        hasSecondaryOptions = false,
        hasUnitRestrictions = false,
        getSecondaryOptions = function(unit) 
            return nil;
        end,
        eval = function(orbViewModel)
            return true;
        end
    },
    ["SpecializationChanged"] = {
        keyName = "SpecializationChanged",
        friendlyName = "Specialization Changed",
        priority = 2,
        hasUnitWhitelist = true,
        whitelistedUnits = {
            "player"
        },
        hasSecondaryOptions = true,
        getSecondaryOptions = getOrbViewModelSpecializationInfos,
        eval = function(orbViewModel, expectedSpecializationName)
            local specInfos = getOrbViewModelSpecializationInfos(orbViewModel);
            if(specInfos[expectedSpecializationName] == GetSpecialization()) then
                return true;
            end

            return false;
        end
    },
    ["StanceChanged"] = {
        keyName = "StanceChanged",
        friendlyName = "Stance/Shapeshift Changed",
        priority = 3,
        hasUnitWhitelist = true,
        whitelistedUnits = {
            "player"
        },
        hasSecondaryOptions = true,
        getSecondaryOptions = getOrbViewModelShapeshiftInfos,
        eval = function(orbViewModel, expectedStanceSpellName)
            local shapeshiftInfos = getOrbViewModelShapeshiftInfos(orbViewModel);
            if(shapeshiftInfos[expectedStanceSpellName] == GetShapeshiftForm()) then
                return true;
            end

            return false;
        end
    },
    ["CombatStatusChanged"] = {
        keyName = "CombatStatusChanged",
        friendlyName = "Combat Status Changed",
        priority = 10,
        hasSecondaryOptions = false,
        getSecondaryOptions = function(orbViewModel)
            return nil;
        end,
        eval = function(orbViewModel)
            return UnitAffectingCombat(orbViewModel.data.unit);
        end
    }
}

self.SortedTriggers = {
    [1] = self.Triggers.Default,
    [2] = self.Triggers.CombatStatusChanged,
    [3] = self.Triggers.StanceChanged,
    [4] = self.Triggers.SpecializationChanged
}

function self:GetTriggerableViewModels(orbViewModel)
    local triggerableViewModels = { };
    MD3Utils:ForEachElementDo(orbViewModel.fills, function(fillKey, fillViewModel)
        table.insert(triggerableViewModels, fillViewModel);
        MD3Utils:ForEachElementDo(fillViewModel.animations, function(animationKey, animationViewModel)
            table.insert(triggerableViewModels, animationViewModel);
        end);

        MD3Utils:ForEachElementDo(fillViewModel.valueLabels, function(valueLabelKey, valueLabelViewModel)
            table.insert(triggerableViewModels, valueLabelViewModel);
        end);   
    end);

    return triggerableViewModels;
end

function self:SetViewModelTriggers(orbViewModel)
    --we are going to extract the trigger information out of the fill's data element, and make it easy to check
    local triggerableViewModels = self:GetTriggerableViewModels(orbViewModel);
    MD3Utils:ForEachElementDo(triggerableViewModels, function(tvmKey, tvm)
        tvm.triggers = { };
        local tvmData = tvm.data;
        --this process flattens trigger data onto the viewmodel, each trigger will be evaluated every frame.
        local iter = 0;
        MD3Utils:ForEachElementDo(tvmData.colorProfiles[orbViewModel.data.activeProfile].triggers, 
            function(triggerKeyName, triggerData)
                local trigger = self.Triggers[triggerKeyName];
                --set the trigger on the viewmodel
                iter = iter + 1;
                if(not trigger.hasSecondaryOptions) then
                    tvm.triggers[iter] = { }
                    tvm.triggers[iter].trigger = trigger;
                    tvm.triggers[iter].argument = nil;
                    tvm.triggers[iter].colorData = triggerData.color;
                else
                    --set the trigger on the viewModel
                    MD3Utils:ForEachElementDo(triggerData, 
                    function(triggerSecondaryKey, triggerSecondaryData)
                        tvm.triggers[iter] = { };
                        --now we set the secondary on there as arguments to check
                        tvm.triggers[iter].trigger = trigger;
                        tvm.triggers[iter].argument = triggerSecondaryKey;
                        tvm.triggers[iter].colorData = triggerSecondaryData.color;
                    end);
                end
            end);
    end);
    orbViewModel.triggerableViewModels = triggerableViewModels;
end;

function self:CheckOrbTriggerStatuses(orbViewModel)
    if(orbViewModel.triggerableViewModels == nil) then
        return;
    end

    for vmKey,vm in pairs(orbViewModel.triggerableViewModels) do
        vm.hasTriggerChanged = false;
        --if the active trigger is no longer active, de-set the active trigger, it will be replaced by Default, at a minimum, or another active trigger, if there is one.
        if(vm.activeTrigger ~= nil and not vm.activeTrigger.trigger.eval(orbViewModel, vm.activeTrigger.argument)) then
            vm.activeTrigger = nil;
        end
        for tKey, t in pairs(vm.triggers) do
            local evalResult = t.trigger.eval(orbViewModel, t.argument);
            if(evalResult == true) then
                if(vm.activeTrigger == nil) then
                    vm.activeTrigger = t;
                    vm.hasTriggerChanged = true;
                else
                    if(vm.activeTrigger.trigger ~= t and vm.activeTrigger.trigger.priority < t.trigger.priority) then
                        vm.activeTrigger = t;
                        vm.hasTriggerChanged = true;
                    end
                end
            end
        end

        if(vm.hasTriggerChanged) then
            print(vm.activeTrigger.trigger.friendlyName .. "(" .. tostring(vm.activeTrigger.argument) .. ")" .. " active.");
            vm.setColor(
                vm.activeTrigger.colorData.r,
                vm.activeTrigger.colorData.g,
                vm.activeTrigger.colorData.b,
                vm.activeTrigger.colorData.a);
        end
    end
end

function self:RegisterForBehaviorUpdates(orbViewModel)
    orbViewModel.behaviorFrame = CreateFrame("FRAME", nil, orbViewModel);
    orbViewModel.behaviorFrame.orbParent = orbViewModel;
    orbViewModel.behaviorFrame:SetScript("OnUpdate", function(bf)
        self:CheckOrbTriggerStatuses(bf.orbParent);
    end);

    self:SetViewModelTriggers(orbViewModel);
end;

function self:UnregisterForBehaviorUpdates(orbViewModel)
    orbViewModel.behaviorFrame:SetScript("OnUpdate", nil);
end