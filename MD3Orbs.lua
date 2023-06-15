--identity
MD3Orbs = {};
self = MD3Orbs;
self.liveOrbs = { };

local fillName = "Fluid2";
local fillLeftName = "Fluid1Left";
local fillRightName = "Fluid1Right";
local containerName = "WholeGlass";
local unitType = "player";
local resourceType = "defaultPower";
local scale = .5;
local moveButton = "LeftButton";
local moveLogic = IsShiftKeyDown;

----------------API TESTING-------------
-- playerDoubleOrb = MD3CoreLib:CreateOrbWithDoubleFillComplete(
--     "test_orb",
--     "SplitGlass",
--     fillLeftName,
--     "Fluid3Right",
--     "player",
--     "health",
--     "defaultPower",
--     .6,
--     moveButton,
--     moveLogic);

-- playerSingleOrb = MD3CoreLib:CreateOrbWithSingleFillComplete(
--     "test_single_orb",
--     "WholeGlass",
--     "Fluid3",
--     "player",
--     "health",
--     .6,
--     moveButton,
--     moveLogic);

-- local animTest = MD3CoreLib:CreateSingleOrbFillRotationAnimation(
--     playerSingleOrb,
--     "Fluid3",
--     27,
--     1);
-- local animTest2 = MD3CoreLib:CreateSingleOrbFillRotationAnimation(
--     playerSingleOrb,
--     "Fluid3",
--     30,
--     -1);
-- MD3CoreLib:SetOrbColorDefaults(playerSingleOrb);

-- local testAbsorbFill = MD3CoreLib:CreateOrbFill(playerDoubleOrb, MD3Config.MD3Textures.fills.halves["Fluid1Left"], "BORDER");
-- MD3CoreLib:SetFillResourceType(testAbsorbFill, "absorbs");
-- local testAbsorbFillAnimationTexture = MD3CoreLib:CreateFillRotationAnimation(
--     testAbsorbFill,
--     MD3Config.MD3Textures.fillAnimations.whole["Fluid1"],
--     MD3Config.MD3Textures.masks.halves["Left"],
--     15,
--     -1,
--     "ARTWORK");
-- local testAbsorbFillAnimationTexture2 = MD3CoreLib:CreateFillRotationAnimation(
--     testAbsorbFill,
--     MD3Config.MD3Textures.fillAnimations.whole["Fluid1"],
--     MD3Config.MD3Textures.masks.halves["Left"],
--     15,
--     1,
--     "ARTWORK");

-- playerDoubleOrb:SetUserPlaced(true);

-- local doubleAnimTest1, doubleAnimTest2 = MD3CoreLib:CreateDoubleOrbFillRotationAnimation(
--     playerDoubleOrb,
--     "Fluid1",
--     "Fluid3",
--     60,
--     -1
-- );

-- local doubleAnimTest3, doubleAnimTest4 = MD3CoreLib:CreateDoubleOrbFillRotationAnimation(
--     playerDoubleOrb,
--     "Fluid1",
--     "Fluid3",
--     30,
--     1
-- );

-- MD3CoreLib:SetOrbColorDefaults(playerDoubleOrb);

-- -- MD3Utils:SetTextureRGBOpaqueFloat(doubleAnimTest1, 
-- --     MD3Utils:GetClassRGBColors(
-- --         MD3Utils:UnitClassWrapper(false,true,false,playerDoubleOrb.unit)));
-- -- doubleAnimTest1:SetAlpha(.7);
-- MD3Utils:SetTextureRGBOpaqueFloat(
--     doubleAnimTest2, 
--     MD3Utils:GetClassRGBColors(
--         MD3Utils:UnitClassWrapper(false,true,false,playerDoubleOrb.unit)));
-- doubleAnimTest4:SetAlpha(.3);
-- -- MD3Utils:SetTextureRGBOpaqueFloat(
-- --     doubleAnimTest4, 
-- --     MD3Utils:GetClassRGBColors(
-- --         MD3Utils:UnitClassWrapper(false,true,false,playerDoubleOrb.unit)));
-- -- doubleAnimTest4:SetAlpha(.1);

-- MD3Utils:SetTextureRGBOpaqueFloat(
--     testAbsorbFill, 
--     1, 0, 1);
-- doubleAnimTest4:SetAlpha(.5);

-- MD3Utils:SetTextureRGBAFloat(
--     testAbsorbFillAnimationTexture,
--     .3, 1, 1, 1);
-- MD3Utils:SetTextureRGBAFloat(
--     testAbsorbFillAnimationTexture2,
--     .3, 1, 1, 1);

-- local r,g,b,a = 1.0, 1.0, 0, 1;
-- local r2,g2,b2,a2 = 1.0, 0.4, 0.1, 1;
-- local r3, g3, b3, a3 = 0.0, 1.0, .3, 1;
-- playerDoubleOrb:RegisterEvent("PLAYER_REGEN_ENABLED");
-- playerDoubleOrb:RegisterEvent("PLAYER_REGEN_DISABLED");
-- playerDoubleOrb:HookScript("OnEvent", 
--     function(self, event)
--         if(event == "PLAYER_REGEN_DISABLED") then
--             MD3CoreLib:SetFillRGBA(self.fills[1], r, g, b, a);
--             MD3CoreLib:SetFillRGBA(self.fills[2], r2, g2, b2, a);
--             MD3CoreLib:SetFillAnimationTexturesRGBA(self.fills[1], r2, g2, b2, .7);
--             MD3CoreLib:SetFillAnimationTexturesRGBA(self.fills[2], r3, g3, b3, .4);
--         end
--         if(event == "PLAYER_REGEN_ENABLED") then
--             MD3CoreLib:SetOrbColorDefaults(self);
--         end
--     end);

-- MD3Utils:SaveOrb(playerDoubleOrb);
-- newSpawnedOrbs = MD3Utils:LoadOrbsFromData(MD3Config.MD3PlayerDefaults.orbs);
-- MD3Config:SaveOrb(newSpawnedOrbs[1]);
-----------------------API TESTING --------------------------^


-- function GetClassSpec()
-- 	print(MD3Utils:GetPlayerClassSpecializationName());
-- end

local hasLoaded = false;
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent(MD3Constants.Events.AddonLoaded)

function eventFrame:OnEvent(event, argument1)
    --when everything is done loading, hide the UI Root.
    if event == MD3Constants.Events.AddonLoaded then
        if(not hasLoaded) then
            MD3Orbs.liveOrbs = MD3Utils:LoadOrbsFromData(MD3PlayerData.orbs);
            if(table.getn(MD3Orbs.liveOrbs) == 0) then
                MD3Orbs.liveOrbs = MD3Utils:CreateNewPlayerProfile();
            end
            hasLoaded = true;
        end
    end
end

eventFrame:SetScript(MD3Constants.Events.OnEvent, eventFrame.OnEvent)