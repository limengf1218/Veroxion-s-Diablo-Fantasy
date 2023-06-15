--identity
MD3Orbs = {};
self = MD3Orbs;

local fillName = "NormalGradient";
local containerName = "SharpLight";
local unitType = "player";
local resourceType = "defaultPower";
local scale = .5;
local moveButton = "LeftButton";
local moveLogic = IsShiftKeyDown;

-- local someHealthOrb = MD3CoreLib:CreateOrbWithSingleFillComplete(
-- 	"md3_test_orb",
-- 	containerName,
-- 	fillName,
-- 	unitType,
-- 	"health",
-- 	scale,
-- 	moveButton,
-- 	moveLogic);

-- local someOrb = MD3CoreLib:CreateOrbWithSingleFillComplete(
-- 	"md3_test_orb",
-- 	containerName,
-- 	fillName,
-- 	unitType,
-- 	resourceType,
-- 	scale,
-- 	moveButton,
-- 	moveLogic);

-- local soulShardsOrb = MD3CoreLib:CreateOrbWithSingleFillComplete(
-- 	"md3_test_orb",
-- 	containerName,
-- 	fillName,
-- 	unitType,
-- 	Enum.PowerType.SoulShards,
-- 	.2,
-- 	moveButton,
-- 	moveLogic);


-- function GetClassSpec()
-- 	print(MD3Utils:GetPlayerClassSpecializationName());
-- end