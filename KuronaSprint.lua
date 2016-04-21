
local KuronaFrames =  Apollo.GetAddon("KuronaFrames")
local self = KuronaFrames

local karHBarSprites =
{
	["default"]						= 		{strIcon = "IconSprites:Icon_Windows32_UI_Hazards_Generic", 		strFillColor = "SprintMeter:sprHazards_Fill", 	strEdgeColor = "SprintMeter:sprHazards_EdgeGlow"},
	[HazardsLib.HazardType_Radiation] = 	{strIcon = "IconSprites:Icon_Windows32_UI_Hazards_Radiation", 		strFillColor = "SprintMeter:sprHazards_Fill", 	strEdgeColor = "SprintMeter:sprHazards_EdgeGlow"},
	[HazardsLib.HazardType_Temperature] = 	{strIcon = "IconSprites:Icon_Windows32_UI_Hazards_Temperature", 	strFillColor = "SprintMeter:sprHazards_Fill", 	strEdgeColor = "SprintMeter:sprHazards_EdgeGlow"},
	[HazardsLib.HazardType_Proximity] = 	{strIcon = "IconSprites:Icon_Windows32_UI_Hazards_Proximity", 		strFillColor = "SprintMeter:sprHazards_Fill", 	strEdgeColor = "SprintMeter:sprHazards_EdgeGlow"},
	[HazardsLib.HazardType_Timer] = 		{strIcon = "IconSprites:Icon_Windows32_UI_Hazards_Proximity", 		strFillColor = "SprintMeter:sprHazards_Fill", 	strEdgeColor = "SprintMeter:sprHazards_EdgeGlow"},
	[HazardsLib.HazardType_Breath] = 		{strIcon = "IconSprites:Icon_Windows32_UI_Hazards_Water", 			strFillColor = "SprintMeter:sprHazards_Fill", 	strEdgeColor = "SprintMeter:sprHazards_EdgeGlow"},
}



function KuronaFrames:Sprint()
	local unitPlayer = self.player
	if not unitPlayer then
		return
	end
	if self.FrameAlias[1]["RecordedHealth"] == 0 and not self.bJustFilled then
		self.sprint:Show(false)
		self.dashes:Show(false)			
		return
	end
	
	self:HideSprint()

	
--	local bOptionsOpen = self.PopUp:IsShown()

	local nRunCurr = unitPlayer:GetResource(0) or 0
	local nRunMax = unitPlayer:GetMaxResource(0) or 0
	local nEvadeCurr = unitPlayer:GetResource(7) or 0
	local nEvadeMax = unitPlayer:GetMaxResource(7) or 0
	
	
	if self.tSettings.bAutoHideSprint and nRunCurr == nRunMax and nEvadeCurr == nEvadeMax and self.bNotActive then return end
	
	self.bNotActive = false
	
	local bWndVisible = self.sprint:IsVisible()
	local bRunAtMax = nRunCurr == nRunMax or unitPlayer:IsDead()
	local nRunPerc = math.floor((nRunCurr / nRunMax)*100)
	local nEvadeHalf = nEvadeMax / 2
	local bEvadeAtMax = nEvadeCurr == nEvadeMax or unitPlayer:IsDead()
	
	
	if bWndVisible and bRunAtMax and bEvadeAtMax and not self.bJustFilled and self.tSettings.bAutoHideSprint then
		self.bJustFilled = true
		Apollo.StopTimer("SprintMeterGracePeriod")
		Apollo.CreateTimer("SprintMeterGracePeriod", 0.75, false)
	end
		
	if not self.tSettings.bAutoHideSprint or not bRunAtMax or not bEvadeAtMax then
		self.bJustFilled = false
		Apollo.StopTimer("SprintMeterGracePeriod")
		self.sprint:Show(true)
		self.dashes:Show(true)			
	end
	if not self.sprint:IsShown() then
		self.sprint:Show(true)
		self.dashes:Show(true)
	end
		
	
	if self.LastRun ~= nRunCurr then
		self.SprintMeter.ProgressBar:SetMax(nRunMax)
		self.SprintMeter.ProgressBar:SetProgress(nRunCurr, bWndVisible and nRunMax or 0)
	end
	
	local evade1 = nEvadeCurr / nEvadeHalf
	local evade2 = (nEvadeCurr-nEvadeHalf) / nEvadeHalf
		
	if self.LastEvade1 ~= evade1 then
		self.SprintMeter.DashProgressBar1:SetProgress(evade1)
	end
		
	if self.LastEvade2 ~= evade1 then
		self.SprintMeter.DashProgressBar2:SetProgress(evade2)
	end

	self.LastRun = nRunCurr
	self.LastEvade1 = evade1
	self.LastEvade2 = evade2
end


function KuronaFrames:OnSprintMeterGracePeriod()
	Apollo.StopTimer("SprintMeterGracePeriod")
	self.bJustFilled = false
	
	if self.sprint and self.sprint:IsValid() and not self.bEditMode then
		self.sprint:Show(false)
		self.dashes:Show(false)
		self.bNotActive = true
	end
end


function KuronaFrames:HideSprint()
	if not self.KillSprint  and self.tSettings.bEnableSprint then	
		local addonSprint = Apollo.GetAddon("SprintMeter")
		if addonSprint and addonSprint.wndMain then
			addonSprint.wndMain:FindChild("ProgBar"):SetStyle("IgnoreMouse",true)
			addonSprint.wndMain:SetOpacity(0,100)
			self.KillSprint = true
		end
	end

	if not self.KillHazards and self.tSettings.bShowHazard then	
		self.addonHazards = Apollo.GetAddon("Hazards")
		if self.addonHazards and not self.KillHazards then	
			self.addonHazards.OnBreathChanged = function(...) end
			self.addonHazards.OnBreath_FlashEvent = function(...) end
			self.addonHazards.OnHazardEnable = function(...) end
			self.addonHazards.OnHazardsUpdated = function(...)  end
			self.addonHazards.OnHazardUpdate = function(...) end
			self.addonHazards.OnHazardRemoved = function(...) end
			self.addonHazards:ClearInterface()
			self.KillHazards = true
		end
		
	end
end

--function KuronaFrames:OnHazardUpdate(idHazard, eHazardType, fMeterValue, fMaxValue, strTooltip)
--end

function KuronaFrames:OnHazardRemove(idHazard)
if self.tSettings.bShowHazard then
	self.HazardBar:Show(false,false)
	end
end

function KuronaFrames:OnHazardEnable(idHazard, strDisplayTxt)
if self.tSettings.bShowHazard then
	self.HazardMeter:SetFullSprite(self:GetBarType("normal"))
	self:OnHazardsUpdated()
	end
end



function KuronaFrames:OnHazardsUpdated()
if not self.tSettings.bShowHazard then return end
	local hazardvalue = 0
	local strTooltip = ""
	for idx, tActiveHazard in ipairs(HazardsLib.GetHazardActiveList()) do
		--Sanity
		if tActiveHazard.eHazardType == 0 then
			if tActiveHazard.fMeterValue then
				strTooltip = tActiveHazard.strTooltip
				hazardvalue = tActiveHazard.fMeterValue
				self.HazardLabel:SetText(HazardsLib.GetHazardDisplayString(tActiveHazard.nId))
				self.HazardMeter:SetBarColor("yellow")
				self.HazardMeter:SetMax(tActiveHazard.fMaxValue)
				self.HazardMeter:SetProgress(tActiveHazard.fMeterValue)
			end
		elseif tActiveHazard.eHazardType == HazardsLib.HazardType_Radiation then
			if tActiveHazard.fMeterValue then
				local strTooltip = tActiveHazard.strTooltip
				hazardvalue = tActiveHazard.fMeterValue
				self.HazardLabel:SetText(HazardsLib.GetHazardDisplayString(tActiveHazard.nId))
				self.HazardBarMeter:SetBarColor("green")
				self.HazardBarMeter:SetMax(tActiveHazard.fMaxValue)
				self.HazardBarMeter:SetProgress(tActiveHazard.fMeterValue)
			end
			if hazardvalue > 79 then
				self.HazardMeter:SetFullSprite(self:GetBarType("flase"))		
			else
				self.HazardMeter:SetFullSprite(self:GetBarType("normal"))
			end
		elseif tActiveHazard.eHazardType == HazardsLib.HazardType_Temperature then
			if tActiveHazard.fMeterValue then
				strTooltip = tActiveHazard.strTooltip
				hazardvalue = tActiveHazard.fMeterValue
				self.HazardLabel:SetText(HazardsLib.GetHazardDisplayString(tActiveHazard.nId))
				self.HazardMeter:SetBarColor("red")
				self.HazardMeter:SetMax(tActiveHazard.fMaxValue)
				self.HazardMeter:SetProgress(tActiveHazard.fMeterValue)
			end

			if hazardvalue > 79 and tActiveHazard.nId ~= 88 then -- Chill
				self.HazardMeter:SetFullSprite(self:GetBarType("flash"))		
			else
				self.HazardMeter:SetFullSprite(self:GetBarType("normal"))		
			end
		elseif tActiveHazard.eHazardType == HazardsLib.HazardType_Proximity then
			if tActiveHazard.fMeterValue then
				strTooltip = tActiveHazard.strTooltip
				hazardvalue = tActiveHazard.fMeterValue
				self.HazardLabel:SetText(HazardsLib.GetHazardDisplayString(tActiveHazard.nId))
				self.HazardMeter:SetBarColor("green")
				self.HazardMeter:SetMax(tActiveHazard.fMaxValue)
				self.HazardMeter:SetProgress(tActiveHazard.fMeterValue)
			end
			if hazardvalue > 79 and tActiveHazard.nId ~= 88 then -- Chill
			
				self.HazardMeter:SetFullSprite(self:GetBarType("flash"))		
			else
				self.HazardMeter:SetFullSprite(self:GetBarType("normal"))		
			end
		elseif tActiveHazard then  --unknown hazard
			if tActiveHazard.fMeterValue then
				strTooltip = tActiveHazard.strTooltip
				hazardvalue = tActiveHazard.fMeterValue
				self.HazardLabel:SetText(HazardsLib.GetHazardDisplayString(tActiveHazard.nId))
				self.HazardMeter:SetBarColor("yellow")
				self.HazardMeter:SetMax(tActiveHazard.fMaxValue)
				self.HazardMeter:SetProgress(tActiveHazard.fMeterValue)
			end
		end

	end
	if self.nBreath < 100 then	
		hazardvalue = self.nBreath
		self.HazardLabel:SetText("Breath")
		self.HazardMeter:SetBarColor("blue")
		self.HazardMeter:SetMax(100)
		self.HazardMeter:SetProgress(self.nBreath)
		
		if self.nBreath < 20 then
			self.HazardMeter:SetFullSprite(self:GetBarType("flash"))
		else
			self.HazardMeter:SetFullSprite(self:GetBarType("normal"))
		end
		
		--self.HazardBarMeter:GetChildren()[1]:SetSprite(karHBarSprites[HazardsLib.HazardType_Breath].strIcon)

	end	
	
	if hazardvalue ~= 0 then
		if not self.HazardBar:IsVisible() then
			self.HazardBar:Show(true,false)
			self.HazardBar:SetTooltip(strTooltip)
			self.HazardMeter:SetTooltip(strTooltip)
		end
	else
		if self.HazardBar:IsVisible() then
			self.HazardBar:Show(false)
			self.HazardBar:SetTooltip("")
			self.HazardMeter:SetTooltip("")
		end
	end	
end


function KuronaFrames:OnBreathChanged(nBreath)
	if self.tSettings.bShowHazard then
	self.nBreath = nBreath
	self:OnHazardEnable()
	end
end






