--Minimap stuff - will reorganize at a later time.
D32FramesUnlocked = false
D32MiniMapButtonPosition = {
	locationAngle = 45, --deg
	x = 52-(80*cos(45)),
	y = ((80*sin(45))-52)
}

function D32MiniMapButton_Reposition()
	D32MiniMapButtonPosition.x = 52-(80*cos(D32MiniMapButtonPosition.locationAngle))
	D32MiniMapButtonPosition.y = ((80*sin(D32MiniMapButtonPosition.locationAngle))-52)
	D32MiniMapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",D32MiniMapButtonPosition.x,D32MiniMapButtonPosition.y)
end

function D32MiniMapButtonPosition_LoadFromDefaults()
	D32MiniMapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",D32MiniMapButtonPosition.x,D32MiniMapButtonPosition.y)
end

function D32_Minimap_Update()
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
	ypos = ypos/UIParent:GetScale()-ymin-70

	D32MiniMapButtonPosition.locationAngle = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
	D32MiniMapButton_Reposition() -- move the button
end

function D32MiniMapButton_OnClick()
	Handle_D32GUI()
end

function Handle_D32GUI()
	if MD3UIRoot:IsVisible() then
		MD3UIRoot:Hide()
		PlaySound(SOUNDKIT.IG_SPELLBOOK_CLOSE, "master");
	else
		MD3UIRoot:Show()
		PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN, "master");
	end
end