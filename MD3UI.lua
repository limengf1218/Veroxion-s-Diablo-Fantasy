MD3UI = {};
self = MD3UI;
self.hasInitialized = false;

function self:SwapFrames(current, target)
    self:CloseFrame(current);
    self:OpenFrame(target);
end

function self:OpenFrame(frame)
    frame:Show();
end

function self:CloseFrame(frame)
    frame:Hide();
end

--slash command method
local function CommandFunc(cmd)
    MD3UIRoot:Show()
end

--setup the slash command stuff, hide the GUI
SlashCmdList["MD3"] = CommandFunc;
SLASH_MD31 = "/md3";















 



----- Event Handling -----
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent(MD3Constants.Events.AddonLoaded)

function eventFrame:OnEvent(event, argument1)
    --when everything is done loading, hide the UI Root.
    if event == MD3Constants.Events.AddonLoaded then
        MD3UI.hasInitialized = true;
    end
end

eventFrame:SetScript(MD3Constants.Events.OnEvent, eventFrame.OnEvent)