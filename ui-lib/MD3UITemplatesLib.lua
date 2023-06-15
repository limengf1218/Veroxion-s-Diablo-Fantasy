--Contains template global functions and library functions for MD3 templates
MD3UITemplatesLib = { };
self = MD3UITemplatesLib;

--- MD3Button Functions ---
function MD3Button_SetText(button, text)
    button.text = text;
    button.internalText:SetText(text);
end

function MD3Button_SetDefaultTextColor(button, rgba)
    button.defaultTextColor = rgba;
end

function MD3Button_SetHoverTextColor(button, rgba)
    button.hoverTextColor = rgba;
end

function MD3Button_SetPressedTextColor(button, rgba)
    button.pressedTextColor = rgba;
end

function MD3Button_SetDefault(button)
    button.internalText:SetTextColor(       
        button.defaultTextColor.r, 
        button.defaultTextColor.g, 
        button.defaultTextColor.b, 
        button.defaultTextColor.a);
end

function MD3Button_SetHover(button)
    button.internalText:SetTextColor(       
        button.hoverTextColor.r, 
        button.hoverTextColor.g, 
        button.hoverTextColor.b, 
        button.hoverTextColor.a);
end

function MD3Button_SetPressed(button)
    button.internalText:SetTextColor(       
        button.pressedTextColor.r, 
        button.pressedTextColor.g, 
        button.pressedTextColor.b, 
        button.pressedTextColor.a);
end

function MD3Button_CreateDefault(frameName, parentFrame)
    return CreateFrame("Button", frameName, parentFrame, "MD3ButtonTemplate");
end

function MD3Button_CreateLeftTextAligned(frameName, parentFrame)
    return CreateFrame("Button", frameName, parentFrame, "MD3ButtonTemplate_LeftTextAlign");
end

function MD3Button_CreateWithBackground(frameName, parentFrame)
    return CreateFrame("Button", frameName, parentFrame, "MD3ButtonTemplate_BG");
end

function MD3OrbScrollBar_TryInit(scrollBar)
    --kind of a hack, it seems to take the scrollFrame a while to actually compute a height...
    if(not scrollBar.hasInitialized and scrollBar.scrollFrame:GetHeight() > 0) then
        --for now, all we do is set child nav
        scrollBar.scrollFrame.scrollBar = scrollBar;
        MD3OrbScrollBar_SetButtons(scrollBar);
        scrollBar.hasInitialized = true;

        --also kind of a hack, since we're waiting for the scrollFrame to initialize, we don't want to call update when we've actually initialized.
        scrollBar:SetScript("OnUpdate", nil);
    end
end

--- MD3OrbScrollbar Functions---
function MD3OrbScrollBar_SetButtons(scrollBar)
    --compare the height of the frame to the height of a normal MD3Button
    local md3Button = MD3Button_CreateLeftTextAligned("MD3OrbScrollbar_RootButton", scrollBar.scrollFrame);
    md3Button:SetText("BUTTON1");
    --set button anchoring
    local buttonOffsetX = -5;
    local buttonOffsetY = -12;
    md3Button:ClearAllPoints();
    md3Button:SetPoint("TOP", scrollBar, "TOP", buttonOffsetX, buttonOffsetY);

    --compute the number of buttons
    local buttonHeight = md3Button:GetHeight();
    local scrollFrameHeight = scrollBar.scrollFrame:GetHeight();
    local numButtons = math.floor(scrollFrameHeight / buttonHeight);
    local buttons = {};
    buttons[1] = md3Button;
    --create our buttons
    for i = 2, numButtons do
        --make a new button
        local nb = MD3Button_CreateLeftTextAligned("MD3OrbScrollbar_RootButton", scrollBar.scrollFrame);
        --assign to the buttons array
        buttons[i] = nb;

        --set button anchoring
        nb:ClearAllPoints();
        nb:SetPoint("TOP", buttons[i-1], "BOTTOM");
        nb:SetText("BUTTON"..i);
    end

    --set the buttons array on both the scrollFrame and scrollBar
    scrollBar.buttonCount = numButtons;
    scrollBar.buttons = buttons;
end
function MD3OrbScrollBar_SetButtonOrbData(scrollBar)

end
function MD3OrbScrollBar_Update(scrollFrame)
    local line;
    local linePlusOffset;
    local scrollBar = scrollFrame.scrollBar;
    -- 50 is max entries, 5 is number of lines, 16 is pixel height of each line
    FauxScrollFrame_Update(scrollFrame, 50, scrollBar.buttonCount, 16);
    for line = 1, scrollBar.buttonCount do
        linePlusOffset = line + FauxScrollFrame_GetOffset(scrollFrame);
        local modEntryButton = scrollBar.buttons[i];
        if(modEntryButton ~= nil) then
            if linePlusOffset <= 50 then
                modEntryButton:SetText("TEST " .. linePlusOffset);
                modEntryButton:Show();
            else
                modEntryButton:Hide();
            end
        end
    end
end

--- MD3OrbDropDownSelector Functions ---
function MD3OrbDropDownSelector_SetSelectedID(orbDropDownSelector, id)
    orbDropDownSelector.selectedID = id;
    local dataSelection = orbDropDownSelector.orbDataModels[id];
    UIDropDownMenu_SetSelectedID(orbDropDownSelector, id);
    MD3Messager:SendMessage(MD3MessageTypes.OrbEditorOrbDataSelectionChanged, dataSelection);
end

function MD3OrbDropDownSelector_TryGetSelectedOrbData(orbDropDownSelector)
    if(not orbDropDownSelector.hasInitialized or 
        orbDropDownSelector.selectedID == nil or
        orbDropDownSelector == nil or 
        orbDropDownSelector.orbDataModels == nil) then
        return nil;
    end

    local dataSelection = orbDropDownSelector.orbDataModels[orbDropDownSelector.selectedID];
    return dataSelection;
end

function MD3OrbDropDownSelector_Initialize(orbDropDownSelector)
    orbDropDownSelector.orbDataModels = { };

    --define the init function for this selector
    local function selectorInit(self, level)
        MD3Utils:ForEachSortedElementDo(MD3Orbs.liveOrbs, function(keyName, orb)
            local orbDataModel = orb.data;
            local ddInfo = UIDropDownMenu_CreateInfo();
            --set an info value for each orb's data model
            ddInfo.text = orbDataModel.name;
            ddInfo.value = orbDataModel.name;
            --add this to a lookup table of selected values
            table.insert(orbDropDownSelector.orbDataModels, orbDataModel);
            ddInfo.func = function(self)
               MD3OrbDropDownSelector_SetSelectedID(orbDropDownSelector, self:GetID());
            end;
            UIDropDownMenu_AddButton(ddInfo, level);
        end);
    end

    --initialize the dropdown
    UIDropDownMenu_Initialize(orbDropDownSelector, selectorInit);
    MD3OrbDropDownSelector_SetSelectedID(orbDropDownSelector, 1);
    UIDropDownMenu_JustifyText(orbDropDownSelector, "CENTER");

    orbDropDownSelector.hasInitialized = true;
end

--- MD3FillAnimationTextureDropDownSelector ---
--- 'fat' = fill animation texture ---
function MD3FillAnimationTextureDropDownSelector_SetSelectedID(fatDropDownSelector, id)
    fatDropDownSelector.selectedID = id;
    local dataSelection = fatDropDownSelector.fatDataModels[id];
    UIDropDownMenu_SetSelectedID(fatDropDownSelector, id);
    MD3Messager:SendMessage(MD3MessageTypes.FillAnimationTextureSelectionChanged, dataSelection);
end

function MD3FillAnimationTextureDropDownSelector_Initialize(fatDropDownSelector)
    --in order for this dropdown to initialize, we need it to have a fill data model.
    if(fatDropDownSelector.fillDataModel == nil) then
        return;
    end;

    fatDropDownSelector.fatDataModels = { };
    --define the init function for this selector
    local function selectorInit(self, level)
        --add the fill, as well as each animation texture
        local ddInfo = UIDropDownMenu_CreateInfo();
        ddInfo.text = "Fill";
        ddInfo.value = fatDropDownSelector.fillDataModel;
        table.insert(fatDropDownSelector.fatDataModels, fatDropDownSelector.fillDataModel);
        ddInfo.func = function(self)
            MD3FillAnimationTextureDropDownSelector_SetSelectedID(fatDropDownSelector, self:GetID());
        end;
        UIDropDownMenu_AddButton(ddInfo, level);

        MD3Utils:ForEachSortedElementDo(
            fatDropDownSelector.fillDataModel.animationTextures,
            function(keyName, animationTextureDataModel, index)
                local ddInfo = UIDropDownMenu_CreateInfo();
                --set an info value for each orb's data model
                ddInfo.text = "Animation " ..tostring(index);
                ddInfo.value = animationTextureDataModel;
                table.insert(fatDropDownSelector.fatDataModels, animationTextureDataModel);
                ddInfo.func = function(self)
                    MD3FillAnimationTextureDropDownSelector_SetSelectedID(fatDropDownSelector, self:GetID());
                end;
                UIDropDownMenu_AddButton(ddInfo, level);
            end);
    end

    --initialize the dropdown
    UIDropDownMenu_Initialize(fatDropDownSelector, selectorInit);
    MD3FillAnimationTextureDropDownSelector_SetSelectedID(fatDropDownSelector, 1);
    UIDropDownMenu_JustifyText(fatDropDownSelector, "CENTER");

    fatDropDownSelector.hasInitialized = true;
end

--- MD3FillAnimationTextureDataSelector ---
function MD3FillAnimationTextureDataDropDownSelector_SetSelectedID(fatdDropDownSelector, id)
    fatdDropDownSelector.selectedID = id;
    local dataSelection = fatdDropDownSelector.fatdDataModels[id];
    UIDropDownMenu_SetSelectedID(fatdDropDownSelector, id);
    return dataSelection;
end

function MD3FillAnimationTextureDataDropDownSelector_SetSelectedIDAndNotify(fatdDropDownSelector, id)
    local dataSelection = MD3FillAnimationTextureDataDropDownSelector_SetSelectedID(fatdDropDownSelector, id);
    MD3Messager:SendMessage(MD3MessageTypes.FillAnimationTextureDataSelectionChanged, dataSelection);
end

function MD3FillAnimationTextureDataDropDownSelector_Initialize(fatdDropDownSelector)
    --in order for this dropdown to initialize, we need it to have a fill data model.
    if(fatdDropDownSelector.textureDataModel == nil) then
        return;
    end;

    fatdDropDownSelector.fatdDataModels = { };
    local selectedIndex = 1;
    --define the init function for this selector
    local function selectorInit(self, level)
        local tdm = fatdDropDownSelector.textureDataModel;
        local selectableElements = nil;

        --this decides which texture group to select from
        if(tdm.fillData ~= nil) then
            if(tdm.designation == "whole") then
                selectableElements = MD3Config.MD3Textures.fills[tdm.designation];
            else
                selectableElements = MD3Config.MD3Textures.fills.halves[tdm.designation];
            end
        elseif(tdm.animationData ~= nil) then
            selectableElements = MD3Config.MD3Textures.fillAnimations.whole;
        end
        MD3Utils:ForEachSortedElementDo(
            selectableElements,
            function(keyName, textureData, index)
                if(keyName == tdm.textureKey) then
                    selectedIndex = index;
                end
                local ddInfo = UIDropDownMenu_CreateInfo();
                --set an info value for each orb's data model
                ddInfo.text = keyName;
                ddInfo.value = textureData;
                table.insert(fatdDropDownSelector.fatdDataModels, textureData);
                ddInfo.func = function(self)
                    MD3FillAnimationTextureDataDropDownSelector_SetSelectedIDAndNotify(fatdDropDownSelector, self:GetID());
                end;
                UIDropDownMenu_AddButton(ddInfo, level);
            end);
    end

    --initialize the dropdown
    UIDropDownMenu_Initialize(fatdDropDownSelector, selectorInit);
    MD3FillAnimationTextureDataDropDownSelector_SetSelectedID(fatdDropDownSelector, selectedIndex);
    UIDropDownMenu_JustifyText(fatdDropDownSelector, "CENTER");
    fatdDropDownSelector.hasInitialized = true;
end

--- MD3FontSelectorDropDown ---
function MD3FontDropDownSelector_SetSelectedID(fontSelectorDropDown, id)
    fontSelectorDropDown.selectedID = id;
    local dataSelection = fontSelectorDropDown.fontDataModels[id];
    UIDropDownMenu_SetSelectedID(fontSelectorDropDown, id);
    return dataSelection;
end

function MD3FontDropDownSelector_SetSelectedIDAndNotify(fontSelectorDropDown, id)
    local dataSelection = MD3FontDropDownSelector_SetSelectedID(fontSelectorDropDown, id);
    MD3Messager:SendMessage(
        MD3MessageTypes.FontSelectionChanged, 
        dataSelection);
end

function MD3FontDropDownSelector_Initialize(fontSelectorDropDown)
    fontSelectorDropDown.fontDataModels = { };
    local selectedIndex = 1;
    --define the init function for this selector
    local function selectorInit(self, level)
        MD3Utils:ForEachSortedElementDo(
            MD3Config.MD3Fonts,
            function(keyName, fontData, index)
                local ddInfo = UIDropDownMenu_CreateInfo();
                --set an info value for each orb's data model
                ddInfo.text = fontData.friendlyName;
                ddInfo.value = fontData;
                table.insert(fontSelectorDropDown.fontDataModels, fontData);
                ddInfo.func = function(self)
                    MD3FontDropDownSelector_SetSelectedIDAndNotify(fontSelectorDropDown, self:GetID());
                end;
                UIDropDownMenu_AddButton(ddInfo, level);
            end);
    end

    --initialize the dropdown
    UIDropDownMenu_Initialize(fontSelectorDropDown, selectorInit);
    MD3FontDropDownSelector_SetSelectedID(fontSelectorDropDown, 1);
    UIDropDownMenu_JustifyText(fontSelectorDropDown, "CENTER");
    fontSelectorDropDown.hasInitialized = true;
end

--- MD3TriggerDropDownSelector ---
function MD3TriggerArgumentsDropDownSelector_SetSelectedID(triggerArgumentsDropDownSelector, id)
    triggerArgumentsDropDownSelector.selectedID = id;
    local dataSelection = triggerArgumentsDropDownSelector.argumentsDataModels[id];
    UIDropDownMenu_SetSelectedID(triggerArgumentsDropDownSelector, id);
    return dataSelection;
end

function MD3TriggerArgumentsDropDownSelector_SetSelectedIDAndNotify(triggerArgumentsDropDownSelector, id)
    local dataSelection = MD3TriggerArgumentsDropDownSelector_SetSelectedID(triggerArgumentsDropDownSelector, id);
    MD3Messager:SendMessage(
        MD3MessageTypes.TriggerArgumentSelectionChanged, 
        dataSelection);
end

function MD3TriggerArgumentsDropDownSelector_Initialize(triggerArgumentsDropDownSelector)
    if(triggerArgumentsDropDownSelector.trigger == nil or triggerArgumentsDropDownSelector.orbViewModel == nil) then
        return;
    end;

    local triggerSecondaryOptions = nil;
    local trigger = triggerArgumentsDropDownSelector.trigger;
    local orbViewModel = triggerArgumentsDropDownSelector.orbViewModel;

    if(not triggerArgumentsDropDownSelector.trigger.hasSecondaryOptions) then
        triggerArgumentsDropDownSelector:Hide();
        return;
    else
        triggerSecondaryOptions = trigger.getSecondaryOptions(orbViewModel);
        if(triggerSecondaryOptions == nil or triggerSecondaryOptions.count == 0) then
            triggerArgumentsDropDownSelector:Hide();
        else
            triggerArgumentsDropDownSelector:Show();
        end
    end

    triggerArgumentsDropDownSelector.argumentsDataModels = { };
    local function triggerArgumentsDropDownSelectorInit(self, level)
        MD3Utils:ForEachSortedElementDo(
            triggerSecondaryOptions.valueKeys,
            function(sovKey, secondaryOptionValueKey, index)
                local ddInfo = UIDropDownMenu_CreateInfo();
                --set an info value for each orb's data model
                ddInfo.text = secondaryOptionValueKey;
                ddInfo.value = secondaryOptionValueKey;
                table.insert(triggerArgumentsDropDownSelector.argumentsDataModels, secondaryOptionValueKey);
                ddInfo.func = function(self)
                    MD3TriggerArgumentsDropDownSelector_SetSelectedIDAndNotify(triggerArgumentsDropDownSelector, self:GetID());
                end;
                UIDropDownMenu_AddButton(ddInfo, level);
            end);
    end

    --initialize the dropdown
    UIDropDownMenu_Initialize(triggerArgumentsDropDownSelector, triggerArgumentsDropDownSelectorInit);
    MD3TriggerArgumentsDropDownSelector_SetSelectedIDAndNotify(triggerArgumentsDropDownSelector, 1);
    UIDropDownMenu_JustifyText(triggerArgumentsDropDownSelector, "CENTER");
    triggerArgumentsDropDownSelector.hasInitialized = true;
end

function MD3TriggerDropDownSelector_SetSelectedID(triggerDropDownSelector, id)
    triggerDropDownSelector.selectedID = id;
    local dataSelection = triggerDropDownSelector.triggerDataModels[id];
    UIDropDownMenu_SetSelectedID(triggerDropDownSelector, id);
    triggerDropDownSelector.argumentsDropDown.trigger = dataSelection;
    triggerDropDownSelector.argumentsDropDown.orbViewModel = triggerDropDownSelector.orbViewModel;
    MD3TriggerArgumentsDropDownSelector_Initialize(triggerDropDownSelector.argumentsDropDown);
    return dataSelection;
end

function MD3TriggerDropDownSelector_SetSelectedIDAndNotify(triggerDropDownSelector, id)
    local dataSelection = MD3TriggerDropDownSelector_SetSelectedID(triggerDropDownSelector, id);
    MD3Messager:SendMessage(
        MD3MessageTypes.TriggerSelectionChanged, 
        dataSelection);
end

function MD3TriggerDropDownSelector_Initialize(triggerDropDownSelector)
    if(triggerDropDownSelector.orbViewModel == nil) then
        return;
    end;

    triggerDropDownSelector.triggerDataModels = { };
    local orbViewModel = triggerDropDownSelector.orbViewModel;
    local function triggerDropDownSelectorInit(self, level)
        MD3Utils:ForEachSortedElementDo(
            MD3Behaviors.SortedTriggers,
            function(tKey, triggerData, index)
                --if this orb is not whitelisted...don't show this trigger in the dropdown
                if(
                    triggerData.hasUnitWhitelist and not 
                    tContains(triggerData.whitelistedUnits, orbViewModel.data.unit)) then
                        return;
                end

                --if this trigger has secondary options, but they are blank for this view model's unit, do not offer this option.
                local triggerOptions = nil;
                if(triggerData.hasSecondaryOptions) then
                    triggerOptions = triggerData.getSecondaryOptions(orbViewModel);
                    if(triggerOptions == nil or triggerOptions.count == 0) then
                        return;
                    end
                end

                local ddInfo = UIDropDownMenu_CreateInfo();
                --set an info value for each orb's data model
                ddInfo.text = triggerData.friendlyName;
                ddInfo.value = triggerData;
                table.insert(triggerDropDownSelector.triggerDataModels, triggerData);
                ddInfo.func = function(self)
                    MD3TriggerDropDownSelector_SetSelectedIDAndNotify(triggerDropDownSelector, self:GetID());
                end;
                UIDropDownMenu_AddButton(ddInfo, level);
            end);
    end

    --initialize the dropdown
    UIDropDownMenu_Initialize(triggerDropDownSelector, triggerDropDownSelectorInit);
    MD3TriggerDropDownSelector_SetSelectedID(triggerDropDownSelector, 1);
    UIDropDownMenu_JustifyText(triggerDropDownSelector, "CENTER");
    triggerDropDownSelector.hasInitialized = true;
end

--- MD3FillTab Functions ---
function MD3FillTab_SetFillDataModel(fillTab, fillDataModel)
    fillTab.fillDataModel = fillDataModel;
    fillTab:SetText("Fill " .. fillTab.index .. " (" .. fillDataModel.resourceType ..")");
    PanelTemplates_TabResize(fillTab, 0);
end

--- MD3FillTabsContainer Functions ---
function MD3FillTabsContainer_Initialize(fillTabsContainer)
    fillTabsContainer.tabs = { };
    fillTabsContainer.tabs[1] = fillTabsContainer.tab1;
    fillTabsContainer.tab1.index = 1;

    fillTabsContainer.tabs[2] = fillTabsContainer.tab2;
    fillTabsContainer.tab2.index = 2;

    fillTabsContainer.tabs[3] = fillTabsContainer.tab3;
    fillTabsContainer.tab3.index = 3;

    fillTabsContainer.tabs[4] = fillTabsContainer.tab4;
    fillTabsContainer.tab4.index = 4;

    MD3Messager:Subscribe(
        MD3MessageTypes.OrbViewerOrbDataSet,
        function(orbViewerData)
            MD3FillTabsContainer_SetOrbDataModel(fillTabsContainer, orbViewerData);
        end);
end

function MD3FillTabsContainer_SetTab(fillTabsContainer, id)
    PanelTemplates_SetTab(fillTabsContainer, id);
    fillTabsContainer.activeFill = fillTabsContainer.tabs[id].fillDataModel;
    --send a message out to those who care.
    MD3Messager:SendMessage(
        MD3MessageTypes.OrbEditorFillSelectionChanged,
        fillTabsContainer.activeFill);
end

function MD3FillTabsContainer_SetOrbDataModel(fillTabsContainer, orbDataModel)
    --hide all tabs before we start
    MD3Utils:ForEachElementDo(fillTabsContainer.tabs, function(_, tab)
        tab:Hide();
    end);

    local i = 1;
    MD3Utils:ForEachSortedElementDo(orbDataModel.fills, function(keyName, fillDataModel)
        local tab = fillTabsContainer.tabs[i];
        MD3FillTab_SetFillDataModel(tab, fillDataModel);
        tab:Show();
        i = i + 1;
    end);

    --finally, reset the selected tab
    MD3FillTabsContainer_SetTab(fillTabsContainer, 1);
end

--- MD3 Fill Options Tab Container ---
function MD3FillOptionsTabsContainer_Initialize(fillOptionsTabsContainer)
    local tc = fillOptionsTabsContainer;
    tc.tabs = { };
    tc.tabs[1] = tc.tab1;
    tc.tab1.index = 1;

    tc.tabs[2] = tc.tab2;
    tc.tab2.index = 2;

    tc.tabs[3] = tc.tab3;
    tc.tab3.index = 3;

    tc.tabs[4] = tc.tab4;
    tc.tab4.index = 4;

    --pages
    tc.pages = { };
    tc.pages[1] = tc.page1;
    tc.pages[1].index = 1;

    tc.pages[2] = tc.page2;
    tc.pages[2].index = 2;

    tc.pages[3] = tc.page3;
    tc.pages[3].index = 3;

    tc.pages[4] = tc.page4;
    tc.pages[4].index = 4;

    PanelTemplates_SetNumTabs(fillOptionsTabsContainer, MD3Utils:GetTableElementCount(tc.tabs));

    --subscribe to changes the parent makes to fill selection
    MD3Messager:Subscribe(
        MD3MessageTypes.OrbEditorFillSelectionChanged,
        function(fillData)
            --reset the index every time the parent gets a new selection
            fillOptionsTabsContainer.activeFill = fillData;
            MD3FillOptionsTabsContainer_SetTab(fillOptionsTabsContainer, 1);
        end);

    --when any color picker changes some aspect of any colors, send out an update event on the selected fill
    MD3Messager:Subscribe(
        MD3MessageTypes.ColorDataModelUpdated,
        function(_)
            MD3Messager:SendMessage(MD3MessageTypes.FillDataModelUpdated, fillOptionsTabsContainer.activeFill);
        end);

    --when any data selection is updated, send out an updated event on the selected fill
    MD3Messager:Subscribe(
        MD3MessageTypes.FillAnimationTextureDataSelectionUpdated,
        function(_)
            MD3Messager:SendMessage(MD3MessageTypes.FillDataModelUpdated, fillOptionsTabsContainer.activeFill);
        end);
end

function MD3FillOptionsTabsContainer_SetTab(fillOptionsTabsContainer, id)
    PanelTemplates_SetTab(fillOptionsTabsContainer, id);
    MD3Utils:ForEachElementDo(fillOptionsTabsContainer.pages, function(key, page) 
        if(key == id) then
            page:Show();
        else
            page:Hide();
        end
    end);
end

--- MD3 Orb Viewer ---
function MD3OrbViewer_Initialize(md3OrbViewer)
    md3OrbViewer.orbs = { };
    md3OrbViewer.hasInitialized = true;
    MD3Messager:Subscribe(
        MD3MessageTypes.OrbEditorOrbDataSelectionChanged,
        function(dataSelection)
            MD3OrbViewer_SetOrbDataModel(md3OrbViewer, dataSelection);
        end);

    MD3Messager:Subscribe(
        MD3MessageTypes.SavePreviewedChangesRequested,
        function(_)
            local originalOrbDataName = md3OrbViewer.activeOrb.originalOrbData.name;
            local newDataClone = MD3Utils:ShallowCopyTable(md3OrbViewer.activeOrb.data);
            newDataClone.name = originalOrbDataName;
            MD3Messager:SendMessage(
                MD3MessageTypes.OrbDataSwapAndSaveRequested,
                { 
                    existingDataModel = md3OrbViewer.activeOrb.originalOrbData,
                    newDataModel = newDataClone
                });
            --after we let everyone know that a swap should be done, set the originalOrbData to be the newDataClone;
            md3OrbViewer.activeOrb.originalOrbData = newDataClone;
        end);
end

function MD3OrbViewer_CreateNewOrb(md3OrbViewer, orbDataModel)
    local originalUnit = orbDataModel.unit;
    local newOrb = MD3Utils:CloneOrbFromDataModelWithPostCopyCallback(orbDataModel, function(newDataModel)
        newDataModel.unit = "test";
    end);
    newOrb:SetParent(md3OrbViewer);
    newOrb:ClearAllPoints();
    newOrb:SetPoint("CENTER", md3OrbViewer);

    --set the new orb's data model unit back to what it was, we only want to falsify the viewModel
    newOrb.data.unit = originalUnit;
    MD3Behaviors:UnregisterForBehaviorUpdates(newOrb);

    --set the viewmodel's resource types to "test"
    MD3Utils:ForEachElementDo(newOrb.fills, function(_, fill)
        --resource types aren't type restricted to being strings, so we do a little magic to provide a custom resource per fill
        local resourceStateObject = { resourceCurrentValue = 10000, resourceMaxValue = 10000 };
        MD3CoreLib:SetFillResourceType(fill, "test", resourceStateObject);
    end);

    --you can't move this frame around, it's the editor frame, duh!
    MD3Utils:SetFrameImmovable(newOrb);

    return newOrb;
end

function MD3OrbViewer_SetActiveOrb(md3OrbViewer, activeOrbName)
    MD3Utils:ForEachElementDo(md3OrbViewer.orbs, function(keyName, orb)
        if(keyName == activeOrbName) then
            orb:Show();
            md3OrbViewer.activeOrb = orb;
            MD3Messager:SendMessage(MD3MessageTypes.OrbViewerActiveOrbViewModelChanged, orb);
        else
            orb:Hide();
        end
    end);
end

function MD3OrbViewer_SetOrbDataModel(md3OrbViewer, orbDataModel)
    --do nothing if the dataModel is nil
    if(orbDataModel == nil) then
        return;
    end

    --if the orbViewer has not initialized, initialize it
    if(not md3OrbViewer.hasInitialized) then
        MD3OrbViewer_Initialize(md3OrbViewer);
    end

    local orbClone = md3OrbViewer.orbs[orbDataModel.name];
    --if there is no clone of this orb already, create one
    if(orbClone == nil) then
        md3OrbViewer.orbs[orbDataModel.name] = MD3OrbViewer_CreateNewOrb(md3OrbViewer, orbDataModel);
        orbClone = md3OrbViewer.orbs[orbDataModel.name];
        orbClone.originalOrbData = orbDataModel;
    end

    MD3OrbViewer_SetActiveOrb(md3OrbViewer, orbDataModel.name);

    --send an event notifying listeners that the selected orb viewer data model has changed
    MD3Messager:SendMessage(MD3MessageTypes.OrbViewerOrbDataSet, md3OrbViewer.activeOrb.data);
end

-- Tabbing EditBox --
function MD3TabbingEditBox_AddEditBoxTabTargets(tabbingEditBox, tabEditBoxTarget, shiftTabEditBoxTarget)
    if(tabbingEditBox.tabTargets == nil) then
        tabbingEditBox.tabTargets = { };
    end
    --left
    tabbingEditBox.tabTargets[0] = shiftTabEditBoxTarget;

    --right
    tabbingEditBox.tabTargets[1] = tabEditBoxTarget;
end

function MD3TabbingEditBox_OnTabPressed(tabbingEditBox)
    if(tabbingEditBox.tabTargets == nil) then
        return;
    end

    local tabTarget = tabbingEditBox;
    if(IsShiftKeyDown()) then
        if(tabbingEditBox.tabTargets[0] ~= nil) then
            tabTarget = tabbingEditBox.tabTargets[0];
        end
    else
        tabTarget = tabbingEditBox.tabTargets[1];
    end

    tabTarget:SetFocus();
    tabTarget:HighlightText();
end

--- Color Panel ---
function MD3ColorPanel_Initialize(colorPanel)
    if(colorPanel.colorData == nil) then
        colorPanel.colorData = {r = 1, g = 1, b = 1, a = 1};
    end

    colorPanel.onColorPickerChange = function(previousColorValues)
        local r,g,b,a;
        r, g, b = ColorPickerFrame:GetColorRGB();
        a = OpacitySliderFrame:GetValue();
        if(previousColorValues ~= nil) then
            r,g,b,a = unpack(previousColorValues);
        end
        MD3ColorPanel_SetRGBA(colorPanel, r, g, b, a);
    end;

    colorPanel.colorPickerButton:SetScript("OnClick", function(self, _, _)
        if(colorPanel.colorData ~= nil) then
            local colorData = colorPanel.colorData;
            --fun, if we don't do this, then SetColorRGB will invoke the prior func with the prior alpha value.
            ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc =
                nil,
                nil,
                nil;
            ColorPickerFrame:SetColorRGB(colorData.r, colorData.g, colorData.b);
            ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = true, colorData.a;
            OpacitySliderFrame:SetValue(colorData.a);
            ColorPickerFrame.previousValues = {colorData.r, colorData.g, colorData.b, colorData.a};
            ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
                colorPanel.onColorPickerChange, 
                colorPanel.onColorPickerChange, 
                colorPanel.onColorPickerChange;

            ColorPickerFrame:EnableKeyboard(false);
            ColorPickerFrame:Show();
        end
    end);

    MD3Utils:SetFrameMovableWithCustomLogic(ColorPickerFrame, "LEFTBUTTON", function() 
        return IsShiftKeyDown();
    end);

    --handle tabbing for the value items
    MD3TabbingEditBox_AddEditBoxTabTargets(
        colorPanel.redValue, 
        colorPanel.greenValue,
        colorPanel.alphaValue);
    MD3TabbingEditBox_AddEditBoxTabTargets(
        colorPanel.greenValue,
        colorPanel.blueValue,
        colorPanel.redValue);
    MD3TabbingEditBox_AddEditBoxTabTargets(
        colorPanel.blueValue,
        colorPanel.alphaValue,
        colorPanel.greenValue);
    MD3TabbingEditBox_AddEditBoxTabTargets(
        colorPanel.alphaValue,
        colorPanel.redValue,
        colorPanel.blueValue);
end

function MD3ColorPanel_SetCustomColorData(colorPanel, colorData)
    colorPanel.colorData = colorData;
    MD3ColorPanel_SetRGBA(colorPanel, colorData.r, colorData.g, colorData.b, colorData.a);
end

function MD3ColorPanel_SetRGBA(colorPanel, r, g, b, a)
    colorPanel.colorData.r = r;
    colorPanel.colorData.g = g;
    colorPanel.colorData.b = b;
    colorPanel.colorData.a = a;
    --notify watchers that the color has changed
    MD3Messager:SendMessage(MD3MessageTypes.ColorDataModelUpdated, colorPanel.colorData);

    --set the color value of the color panel's button - don't honor opacity
    MD3Button_SetDefaultTextColor(
        colorPanel.colorPickerButton, 
        {
            r = colorPanel.colorData.r, 
            g = colorPanel.colorData.g, 
            b = colorPanel.colorData.b, 
            a = 1
        });
    MD3Button_SetDefault(colorPanel.colorPickerButton);

    local rB, gB, bB, aB = MD3Utils:ConvertFloatRGBAToByteRGBA(r, g, b, a);
    colorPanel.redValue:SetText(rB);
    colorPanel.greenValue:SetText(gB);
    colorPanel.blueValue:SetText(bB);
    colorPanel.alphaValue:SetText(aB);
end

function MD3ColorPanel_UpdateFromColorValues(colorPanel)
    local r, g, b, a;
    r = colorPanel.redValue:GetNumber();
    g = colorPanel.greenValue:GetNumber();
    b = colorPanel.blueValue:GetNumber();
    a = colorPanel.alphaValue:GetNumber();

    r, g, b, a = MD3Utils:ConvertByteRGBAToFloatRGBA(r, g, b, a);
    MD3ColorPanel_SetRGBA(colorPanel, r, g, b, a);
end

--- MD3FillColorTabPage ---
function MD3FillColorTabPage_Initialize(fillColorTabPage)
    MD3Messager:Subscribe(
        MD3MessageTypes.FillAnimationTextureSelectionChanged,
        function(fillAnimationTexture)
            fillColorTabPage.selectedFillAnimationTexture = fillAnimationTexture;
        end);

    MD3Messager:Subscribe(
        MD3MessageTypes.FillAnimationTextureDataSelectionChanged,
        function(fatdData)
            if(fillColorTabPage.selectedFillAnimationTexture == nil) then
                return;
            end
            if(fillColorTabPage.selectedFillAnimationTexture.fillData ~= nil) then
                fillColorTabPage.selectedFillAnimationTexture.fillData = fatdData
            else
                fillColorTabPage.selectedFillAnimationTexture.animationData = fatdData;
            end
            fillColorTabPage.selectedFillAnimationTexture.textureKey = fatdData.textureKey;
            MD3Messager:SendMessage(
                MD3MessageTypes.FillAnimationTextureDataSelectionUpdated,
                fillColorTabPage.selectedFillAnimationTexture);
        end);
end

--- MD3OrbScaleSlider ---
function MD3OrbScaleSlider_Initialize(orbScaleSlider)
    MD3Messager:Subscribe(
        MD3MessageTypes.OrbViewerActiveOrbViewModelChanged,
        function(orbViewModel)
            orbScaleSlider.activeOrbViewModel = orbViewModel;
            MD3OrbScaleSlider_UpdateValues(orbScaleSlider);
        end);

        orbScaleSlider:SetScript("OnValueChanged", function(self, value)
        if(self.activeOrbViewModel ~= nil) then
            self.activeOrbViewModel.data.scale = value;
            self.activeOrbViewModel:SetScale(value);
            self.Text:SetText(string.format("%.3f", value));
            self:SetValue(value);
        end
    end);
end

function MD3OrbScaleSlider_UpdateValues(orbScaleSlider)
    if(orbScaleSlider.activeOrbViewModel == nil) then
        return;
    end
    
    orbScaleSlider.Low:SetText(".25");
    orbScaleSlider.High:SetText("1.5");
    orbScaleSlider:SetMinMaxValues(.25, 1.5);
    orbScaleSlider:SetValue(orbScaleSlider.activeOrbViewModel.data.scale);
    orbScaleSlider.Text:SetText(string.format("%.3f", orbScaleSlider.activeOrbViewModel.data.scale));
    orbScaleSlider:SetValueStep(.001);
end

--- MD3FillValueSlider ---
function MD3FillValueSlider_Initialize(fillValueSlider)
    if(fillValueSlider.orbViewModels == nil) then
        fillValueSlider.orbViewModels = { };
    end

    MD3Messager:Subscribe(
        MD3MessageTypes.OrbViewerActiveOrbViewModelChanged,
        function(orbViewModel)
            if (not MD3Utils:TableContains(fillValueSlider.orbViewModels, orbViewModel)) then
                table.insert(fillValueSlider.orbViewModels, orbViewModel);
            end
        end);

    MD3Messager:Subscribe(
        MD3MessageTypes.OrbEditorFillSelectionChanged,
        function(fillData)
            MD3Utils:ForEachElementDo(fillValueSlider.orbViewModels, function(key, ovm)
                MD3Utils:ForEachElementDo(ovm.fills, function(fillKey, fvm)
                    if(fvm.data == fillData) then
                        fillValueSlider.fillResourceStateObject = fvm.resourceStateObject;
                        MD3FillValueSlider_UpdateValues(fillValueSlider);
                    end
                end);
            end);
        end);

    fillValueSlider:SetScript("OnValueChanged", function(self, value)
        if(self.fillResourceStateObject ~= nil) then
            self.fillResourceStateObject.resourceCurrentValue = value;
            self:SetValue(value);
        end
    end);
end

function MD3FillValueSlider_UpdateValues(fillValueSlider)
    if(fillValueSlider.fillResourceStateObject == nil) then
        return;
    end
    
    fillValueSlider.Low:SetText("0");
    fillValueSlider.High:SetText(tostring(fillValueSlider.fillResourceStateObject.resourceMaxValue));
    fillValueSlider:SetMinMaxValues(
        0,
        fillValueSlider.fillResourceStateObject.resourceMaxValue);
    fillValueSlider:SetValue(fillValueSlider.fillResourceStateObject.resourceCurrentValue);
    fillValueSlider:SetValueStep(1);
end

--- MD3OffsetSlider ---
function MD3OffsetSlider_UpdateValues(offsetSlider)
    if(
        offsetSlider.offsetsDataModel ~= nil and 
        offsetSlider.sideKey ~= nil and
        offsetSlider.offsetMin ~= nil and
        offsetSlider.offsetMax ~= nil) then
        return;
    end

    local offsetMin = offsetSlider.offsetMin;
    local offsetMax = offsetSlider.offsetMax;
    
    fillValueSlider.Low:SetText(tostring(offsetMin));
    fillValueSlider.High:SetText(tostring(offsetMax));
    fillValueSlider:SetMinMaxValues(offsetMin, offsetMax);
    fillValueSlider:SetValue(offsetSlider.offsetsDataModel[sideKey]);
    fillValueSlider:SetValueStep(1);
end

function MD3OffsetSlider_Initialize(offsetSlider, offsetsDataModel, sideKey, offsetMin, offsetMax)
    offsetSlider.sideKey = sideKey;
    offsetSlider.offsetsDataModel = offsetsDataModel;
    offsetSlider.offsetMin = offsetMin;
    offsetSlider.offsetMax = offsetMax;

    offsetSlider:SetScript("OnValueChanged", function(self, value)
        if(self.offsetsDataModel ~= nil and self.sideKey ~= nil) then
            if(self.offsetsDataModel[sideKey] ~= nil) then
                self.offsetsDataModel[sideKey] = value;
                self:SetValue(value);
                MD3Messager:SendMessage(
                    MD3MessageTypes.OffsetValueChanged,
                    self.offsetsDataModel);
            end
        end
    end);

    MD3OffsetSlider_UpdateValues(offsetSlider);
end

function MD3FillAnimationTextureColorPanel_Initialize(fatColorPanel)
    MD3Messager:Subscribe(
        MD3MessageTypes.FillAnimationTextureSelectionChanged,
        function(textureData)
            fatColorPanel.textureData = textureData;
            MD3ColorPanel_SetCustomColorData(fatColorPanel, textureData.colorProfiles.default.triggers.Default.color)
        end);

    MD3Messager:Subscribe(
        MD3MessageTypes.TriggerSelectionChanged,
        function(selectedTrigger)
            fatColorPanel.selectedTrigger = selectedTrigger;
            local triggerName = fatColorPanel.selectedTrigger.keyName;
            if(
                fatColorPanel.textureData == nil or
                fatColorPanel.textureData.colorProfiles.default.triggers[triggerName] == nil or
                fatColorPanel.textureData.colorProfiles.default.triggers[triggerName].color == nil) then
                return;
            end

            MD3ColorPanel_SetCustomColorData(
                fatColorPanel,
                fatColorPanel.textureData.colorProfiles.default.triggers[triggerName].color);
        end);

    MD3Messager:Subscribe(
        MD3MessageTypes.TriggerArgumentSelectionChanged,
        function(selectedSecondaryOption)
            if(fatColorPanel.textureData == nil or fatColorPanel.selectedTrigger == nil) then
                return;
            end
            local triggerName = fatColorPanel.selectedTrigger.keyName;
            if(
                fatColorPanel.textureData.colorProfiles.default.triggers[triggerName] == nil or
                fatColorPanel.textureData.colorProfiles.default.triggers[triggerName][selectedSecondaryOption] == nil or
                fatColorPanel.textureData.colorProfiles.default.triggers[triggerName][selectedSecondaryOption].color == nil) then
                    
                return;
            end

            MD3ColorPanel_SetCustomColorData(
                fatColorPanel,
                fatColorPanel.textureData.colorProfiles.default.triggers[triggerName][selectedSecondaryOption].color);
        end);
end