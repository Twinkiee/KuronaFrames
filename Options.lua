
local KuronaFrames =  Apollo.GetAddon("KuronaFrames")
local self = KuronaFrames
local PTR = AccountItemLib.CodeEnumAccountCurrency.Omnibits

local sin = math.sin
local cos =  math.cos
local rad = math.rad

local kstrTooltipBodyColor = "ffc0c0c0"
local kstrTooltipTitleColor = "ffdadada"

	local playerResourceType = {
	[GameLib.CodeEnumClass.Medic] = 1,
	[GameLib.CodeEnumClass.Esper] = 1,
	[GameLib.CodeEnumClass.Stalker] = 3,
	[GameLib.CodeEnumClass.Warrior] = 1,
	[GameLib.CodeEnumClass.Spellslinger] = 4,
	[GameLib.CodeEnumClass.Engineer] = 1,
	}

function KuronaFrames:OnInterfaceMenuListHasLoaded()
	Event_FireGenericEvent("InterfaceMenuList_NewAddOn", "KuronaFrames", {"KuronaFramesClick", "", ""})
end


function KuronaFrames:OnKuronaFramesMenuClick()
	self:OnOpenOptions()
end


function KuronaFrames:OnSettingChange( wndHandler, wndControl, eMouseButton )
	--Assign settings Values 
	self.tSettings.bShowToT = self.PopUp:FindChild("ToTButton"):IsChecked()
	self.tSettings.bShowToTDebuffs = self.PopUp:FindChild("ToTDebuffsButton"):IsChecked()
	self.tSettings.bShowCastBar = self.PopUp:FindChild("CastBarButton"):IsChecked()
	self.tSettings.bShowClassIcons = self.PopUp:FindChild("ShowClassIconsButton"):IsChecked()
	self.tSettings.bUsePercentages = self.PopUp:FindChild("PercentagesButton"):IsChecked()
	self.tSettings.bAutoHideFrame = self.PopUp:FindChild("AutoHideFrameButton"):IsChecked()
	self.tSettings.bAutoHideName = self.PopUp:FindChild("AutoHideNameButton"):IsChecked()
	self.tSettings.bShowThreatMeter = self.PopUp:FindChild("ShowThreatMeterButton"):IsChecked()
	self.tSettings.bSmoothCastBar = self.PopUp:FindChild("SmoothCastBarButton"):IsChecked()
	self.tSettings.bShowFocusBuffs = self.PopUp:FindChild("ShowFocusBuffsButton"):IsChecked()
	self.tSettings.bShowSpellIcon = self.PopUp:FindChild("ShowSpellIcon"):IsChecked()
	self.tSettings.bShowResources = self.PopUp:FindChild("ShowResourcesButton"):IsChecked()
	self.tSettings.bShowCarbineResources = self.PopUp:FindChild("ShowCarbineResourcesButton"):IsChecked()
	self.tSettings.bDisplayFocus = self.PopUp:FindChild("DisplayFocusButton"):IsChecked()
	self.tSettings.bShowSpellTimeIcon =	self.PopUp:FindChild("ShowSpellTimeIcon"):IsChecked()
	self.tSettings.bShowLevels =	self.PopUp:FindChild("ShowLevels"):IsChecked()
	self.tSettings.nBarOpacity = self.PopUp:FindChild("BarAlphaSliderBar"):GetValue()
	self.tSettings.nCastbarOpacity = self.PopUp:FindChild("CastbarAlphaSliderBar"):GetValue()
	self.tSettings.bDisableEatAway = self.PopUp:FindChild("DisableEatAway"):IsChecked()
	self.tSettings.bShowMountInfo = self.PopUp:FindChild("ShowMountInfo"):IsChecked()
	self.tSettings.bValueAndPercentage = self.PopUp:FindChild("ValueAndPercentageButton"):IsChecked()
	self.tSettings.bEnableSprint = self.PopUp:FindChild("EnableSprintButton"):IsChecked()
	self.tSettings.bVerticalSprint = self.PopUp:FindChild("VerticalSprintButton"):IsChecked()
	self.tSettings.bAutoHideSprint = self.PopUp:FindChild("AutoHideSprintButton"):IsChecked()
	self.tSettings.bFlashInterrupt = self.PopUp:FindChild("InterruptableCastButton"):IsChecked()
	self.tSettings.bShowPetFrame = self.PopUp:FindChild("ShowPetFrameButton"):IsChecked()
	self.tSettings.bShowClusterFrame = self.PopUp:FindChild("ShowClusterFrameButton"):IsChecked()
	self.tSettings.bFirstNamesOnly = self.PopUp:FindChild("ShowFirstNames"):IsChecked()
	self.tSettings.bFirstNamesOnly = self.PopUp:FindChild("ShowFirstNames"):IsChecked()
	self.tSettings.bFocusAsPercent = self.PopUp:FindChild("FocusPercentageButton"):IsChecked()
	self.tSettings.bShowBuffBars = not self.PopUp:FindChild("DisableBuffBarsButton"):IsChecked()
	self.tSettings.bMatchFocus = self.PopUp:FindChild("RememberFocus"):IsChecked()
	self.tSettings.bAutoHideResources = self.PopUp:FindChild("AutoHideResourceButton"):IsChecked()
	self.tSettings.bUseGenericResources = self.PopUp:FindChild("UseGenericResources"):IsChecked()
	self.tSettings.bAlertWindow = self.PopUp:FindChild("AlertWindowButton"):IsChecked()
	self.tSettings.bCCAlertWindow = self.PopUp:FindChild("CCAlertWindowButton"):IsChecked()
	self.tSettings.bAlertSound = self.PopUp:FindChild("AlertSoundButton"):IsChecked()
	self.tSettings.bAlertNames = self.PopUp:FindChild("CCAlertNamesButton"):IsChecked()
	self.tSettings.bPercentDecimals = self.PopUp:FindChild("PercentDecimals"):IsChecked()
	self.tSettings.bShowHazard = self.PopUp:FindChild("HazardMeterButton"):IsChecked()
	self.tSettings.bProxmityCast = self.PopUp:FindChild("ProximityCastButton"):IsChecked()

	self.tSettings.bLineToTarget = self.PopUp:FindChild("TargetLineButton"):IsChecked()
	self.tSettings.bLineToFocus = self.PopUp:FindChild("FocusLineButton"):IsChecked()
	self.tSettings.bLineToSubdue = self.PopUp:FindChild("SubdueLineButton"):IsChecked()
	self.tSettings.bLineOutlines = self.PopUp:FindChild("EnableOutlineButton"):IsChecked()
	self.tSettings.bLineDistances = self.PopUp:FindChild("LineDistancesButton"):IsChecked()

	if self.tSettings.bLineToSubdue or self.tSettings.bLineToFocus or self.tSettings.bLineToTarget and not self.tSettings.bSmoothCastBar then
		self.tSettings.bSmoothCastBar = true
		self.PopUp:FindChild("SmoothCastBarButton"):SetCheck(self.tSettings.bSmoothCastBar)
	end
		
	if not self.tSettings.bShowHazard then
		self.HazardBar:Show(self.tSettings.bShowHazard,true)
	end
	
	self.tSettings.AlertList = self.AlertWindowEditBox:GetText()
	self.AlertListTable = self.tSettings.AlertList:split("\n")
	self.tSettings.ProximityIgnore = self.ProxIgnoreEditBox:GetText()
	self.ProximityIgnoreTable = self.tSettings.ProximityIgnore:split("\n")
	
	local oldFrame = self.tSettings.bShowFrameBorders
	self.tSettings.bShowFrameBorders = self.PopUp:FindChild("ShowFrameBorders"):IsChecked()

	if oldFrame ~= 	self.tSettings.bShowFrameBorders then
		self:HideFrameBorders(self.playerFrame,self.tSettings.bShowFrameBorders)
		self:HideFrameBorders(self.targetFrame,self.tSettings.bShowFrameBorders)
		self:HideFrameBorders(self.focusFrame,self.tSettings.bShowFrameBorders)
		self:HideFrameBorders(self.sprint,self.tSettings.bShowFrameBorders)
		self:HideFrameBorders(self.AlertWindow,self.tSettings.bShowFrameBorders)
		self:HideFrameBorders(self.HazardBar,self.tSettings.bShowFrameBorders)
		self:HideFrameBorders(self.ProximityCastForm,self.tSettings.bShowFrameBorders)
	end
	if self.FocusBar then
		self.tSettings.cFocusBarL, self.tSettings.cFocusBarT, self.tSettings.cFocusBarR, self.tSettings.cFocusBarB = self.FocusBar:GetAnchorOffsets()
	end		
	
	local rCheckA = not self.tSettings.bUseGenericResources and self.Resources:GetName() == "GenericResourcesForm"
	local rCheckB = self.tSettings.bUseGenericResources and self.Resources:GetName() ~= "GenericResourcesForm"
	
	if rCheckA or rCheckB then
		self.tSettings.cResourcesL,self.tSettings.cResourcesT,self.tSettings.cResourcesR,self.tSettings.cResourcesB = self.Resources:GetAnchorOffsets()
		
		if self.player:GetClassId() == 3 and self.PsiPointDisplay then
			self.tSettings.cPsiPointsL,self.tSettings.cPsiPointsT,self.tSettings.cPsiPointsR,self.tSettings.cPsiPointsB = self.PsiPointDisplay:GetAnchorOffsets()
		end
		
		self.Resources:Destroy()
		self.Resources = nil
		self:CreateResources(self.player)
		self.Resources:SetAnchorOffsets(self.tSettings.cResourcesL,self.tSettings.cResourcesT,self.tSettings.cResourcesR,self.tSettings.cResourcesB)
		self:ChangeFrameBorders(self.tSettings.nStyle)
	end

	self.tSettings.bMirroredTargetFrame = self.PopUp:FindChild("MirroredFrameButton"):IsChecked()
	
	local rCheckA = self.tSettings.bMirroredTargetFrame and self.targetFrame:GetName() == "MainPlayerFrame"
	local rCheckB = not self.tSettings.bMirroredTargetFrame and self.targetFrame:GetName() ~= "MainPlayerFrame"
	if rCheckA or rCheckB then
	
		self.tSettings.cTFrameL, self.tSettings.cTFrameT, self.tSettings.cTFrameR, self.tSettings.cTFrameB = self.targetFrame:GetAnchorOffsets()
		self.tSettings.cTCastL, self.tSettings.cTCastT, self.tSettings.cTCastR, self.tSettings.cTCastB =  self.targetFrame:FindChild("CastFrame"):GetAnchorOffsets()

		self.targetFrame:Destroy()

		if self.tSettings.bMirroredTargetFrame then
			self.targetFrame = Apollo.LoadForm(self.xmlDoc, "MirroredTargetFrame", "FixedHudStratumLow", self)
	
			self.tSettings.cHPFrameL = 33
			self.tSettings.cHPFrameT = 120
			self.tSettings.cHPFrameR = 320
			self.tSettings.cHPFrameB = 170
			
			--Target Buff Bar
			self.tSettings.cTBBarL = -40
			self.tSettings.cTBBarT = 95
			self.tSettings.cTBBarR = 315
			self.tSettings.cTBBarB = 130
			--Target DebufBar
			self.tSettings.cTDBarL = -40
			self.tSettings.cTDBarT = 60
			self.tSettings.cTDBarR = 315
			self.tSettings.cTDBarB = 95
			--marker
			self.tSettings.cTargetMarkerL = 305
			self.tSettings.cTargetMarkerT = 102
			self.tSettings.cTargetMarkerR = 357
			self.tSettings.cTargetMarkerB = 187
			--classicon
			self.tSettings.cTClassIconL = 14
			self.tSettings.cTClassIconT = 49
			self.tSettings.cTClassIconR = 45
			self.tSettings.cTClassIconB = 79
			--name
			self.tSettings.cTargetNameL = 54
			self.tSettings.cTargetNameT = 159
			self.tSettings.cTargetNameR = 315
			self.tSettings.cTargetNameB = 185
			
			self.tSettings.cTTotL = 345
			self.tSettings.cTTotT = 101
			self.tSettings.cTTotR = 527
			self.tSettings.cTTotB = 180
			

			
		else
			self.targetFrame = Apollo.LoadForm(self.xmlDoc, "MainPlayerFrame", "FixedHudStratumLow", self)
						
			self.tSettings.cHPFrameL = 33
			self.tSettings.cHPFrameT = 120
			self.tSettings.cHPFrameR = 320
			self.tSettings.cHPFrameB = 170
			
			
			--Target Buff Bar
			self.tSettings.cTBBarL = 45
			self.tSettings.cTBBarT = 95
			self.tSettings.cTBBarR = 400
			self.tSettings.cTBBarB = 130
			--Target DebufBar
			self.tSettings.cTDBarL = 45
			self.tSettings.cTDBarT = 60
			self.tSettings.cTDBarR = 400
			self.tSettings.cTDBarB = 95	
			--marker
			self.tSettings.cTargetMarkerL = -2
			self.tSettings.cTargetMarkerT = 102
			self.tSettings.cTargetMarkerR = 51
			self.tSettings.cTargetMarkerB = 187
			--classicon
			self.tSettings.cTClassIconL = 14
			self.tSettings.cTClassIconT = 49
			self.tSettings.cTClassIconR = 45
			self.tSettings.cTClassIconB = 79
			--name
			self.tSettings.cTargetNameL = 45
			self.tSettings.cTargetNameT = 159
			self.tSettings.cTargetNameR = 298
			self.tSettings.cTargetNameB = 185
			
			self.tSettings.cTTotL = 316
			self.tSettings.cTTotT = 101
			self.tSettings.cTTotR = 498
			self.tSettings.cTTotB = 180

	
			
		end
		
		self:SetupClusterFrame()
		self.frameResizeNeeded = true		
		self.FrameAlias[2]["RecordedName"] =""
		self.FrameAlias[2]["RecordedHealth"] =-9999
		self.FrameAlias[2]["RecordedShield"] =-9999
		self:SetupFrameAlias()
		--self.targetFrame:SetAnchorOffsets(self.tSettings.cTFrameL,self.tSettings.cTFrameT,self.tSettings.cTFrameR,self.tSettings.cTFrameB)
		self.targetFrame:FindChild("LargeFrame"):SetAnchorOffsets(self.defaultsettings.cTHPFrameL,self.defaultsettings.cTHPFrameT,self.defaultsettings.cTHPFrameR,self.defaultsettings.cTHPFrameB)
		self:ChangeFrameBorders(self.tSettings.nStyle)		
		self:SetFramePositions()
	end
	
	local rCheckA = not self.tSettings.bVerticalSprint and self.sprint:GetName() == "VerticalSprintForm"
	local rCheckB = self.tSettings.bVerticalSprint and self.sprint:GetName() ~= "VerticalSprintForm"
	
	if rCheckA or rCheckB then
		if self.tSettings.bVerticalSprint then
			if not self.SettingDefaults then
				self.tSettings.cSprintL, self.tSettings.cSprintT,self.tSettings.cSprintR,self.tSettings.cSprintB= self.sprint:GetAnchorOffsets()
				self.tSettings.cDashL, self.tSettings.cDashT,self.tSettings.cDashR,self.tSettings.cDashB= self.dashes:GetAnchorOffsets()
			end
			self.sprint:Destroy()
			self.sprint = nil
			self.dashes = nil
			
			self.sprint = Apollo.LoadForm(self.xmlDoc, "VerticalSprintForm", "FixedHudStratumLow",self)
			self.dashes = self.sprint:FindChild("DashTokens")
			self.sprint:SetAnchorOffsets(self.tSettings.cVSprintL, self.tSettings.cVSprintT,self.tSettings.cVSprintR,self.tSettings.cVSprintB)		
			self.dashes:SetAnchorOffsets(self.tSettings.cVDashL, self.tSettings.cVDashT,self.tSettings.cVDashR,self.tSettings.cVDashB)		
		else
			if not self.SettingDefaults then
				self.tSettings.cVSprintL, self.tSettings.cVSprintT,self.tSettings.cVSprintR,self.tSettings.cVSprintB= self.sprint:GetAnchorOffsets()
				self.tSettings.cVDashL, self.tSettings.cVDashT,self.tSettings.cVDashR,self.tSettings.cVDashB= self.dashes:GetAnchorOffsets()
			end				
			self.sprint:Destroy()
			self.sprint = nil
			self.dashes = nil
			self.sprint = Apollo.LoadForm(self.xmlDoc, "KuronaSprint", "FixedHudStratumLow",self)
			self.dashes = self.sprint:FindChild("DashTokens")
			self.sprint:SetAnchorOffsets(self.tSettings.cSprintL, self.tSettings.cSprintT,self.tSettings.cSprintR,self.tSettings.cSprintB)		
			self.dashes:SetAnchorOffsets(self.tSettings.cDashL, self.tSettings.cDashT,self.tSettings.cDashR,self.tSettings.cDashB)		
		end
		self.SprintMeter = nil
			self.SprintMeter = {
			DashProgressBar1 = self.dashes:FindChild("DashProgressBar1"),
			DashProgressBar2 = self.dashes:FindChild("DashProgressBar2"),
			ProgressBar = self.sprint:FindChild("ProgressBar"),
		}
		self.LastRun = ""
		self.LastEvade1 = ""
		self.LastEvade2 = ""

		self:ChangeFrameBorders(self.tSettings.nStyle)
	end	
		self.FocusValue = 99999
		
		
	if self.FocusBar then
		self.FocusBar:Show(self.tSettings.bDisplayFocus)
	end

	if self.FocusBar then
		self.FocusBarMeter:SetStyleEx("UsePercent",self.tSettings.bFocusAsPercent)
		self.FocusBarMeter:SetStyleEx("UseValues",not self.tSettings.bFocusAsPercent)
	end
	
	self.FrameAlias[1]["RecordedName"] =""
	self.FrameAlias[2]["RecordedName"] =""
	self.FrameAlias[3]["RecordedName"] =""
	
	if not self.tSettings.bShowResources then
		self.Resources:Show(self.tSettings.bShowResources)
	end

	if not self.tSettings.bShowSpellTimeIcon then
		for i=1,3 do
			self.FrameAlias[i]["SpellIcon"]:SetText("")
		end
	end
	if not self.tSettings.bShowFocusBuffs then
		self.focusFrame:FindChild("BeneBuffBar"):SetUnit(nil)
		self.focusFrame:FindChild("HarmBuffBar"):SetUnit(nil)
	else
		local focus = self.player:GetAlternateTarget()
		self.focusFrame:FindChild("BeneBuffBar"):SetUnit(focus)
		self.focusFrame:FindChild("HarmBuffBar"):SetUnit(focus)
	end

	if self.tSettings.bShowToTDebuffs then
			local focus = self.player:GetAlternateTarget()
			local target = self.player:GetTarget()
		if target ~= nil then
			self.targetFrame:FindChild("ToTHarmBuffBar"):SetUnit(target:GetTarget())
		end
		if focus ~= nil then
			self.focusFrame:FindChild("ToTHarmBuffBar"):SetUnit(focus:GetTarget())
		end
	else
		self.targetFrame:FindChild("ToTHarmBuffBar"):SetUnit(nil)
		self.focusFrame:FindChild("ToTHarmBuffBar"):SetUnit(nil)
	end		
			
	if self.tSettings.bShowCarbineResources then
		Apollo.SetConsoleVariable("hud.ResourceBarDisplay", 1)
		Event_FireGenericEvent("OptionsUpdated_HUDPreferences")

	else
		Apollo.SetConsoleVariable("hud.ResourceBarDisplay", 2)
		Event_FireGenericEvent("OptionsUpdated_HUDPreferences")
	end

	if self.tSettings.bShowSpellIcon then
	   	self.FrameAlias[1]["SpellIcon"]:Show(true)
	   	self.FrameAlias[2]["SpellIcon"]:Show(true)
	   	self.FrameAlias[3]["SpellIcon"]:Show(true)
		self.CurCastName = ""
	else
	   	self.FrameAlias[1]["SpellIcon"]:Show(false)
	   	self.FrameAlias[2]["SpellIcon"]:Show(false)
	   	self.FrameAlias[3]["SpellIcon"]:Show(false)
		self.CurCastName = ""
	end		

	
	if self.tSettings.bShowThreatMeter then
		Apollo.RemoveEventHandler("TargetThreatListUpdated",self)
		Apollo.RegisterEventHandler("TargetThreatListUpdated", "OnThreatUpdated", self)
	else
		self.targetFrame:FindChild("Threat"):Show(false)
		Apollo.RemoveEventHandler("TargetThreatListUpdated",self)
	end
	
	if not self.tSettings.bShowCastBar then
		self.FrameAlias[1]["CastFrame"]:Show(false)
		self.FrameAlias[2]["CastFrame"]:Show(false)
		self.FrameAlias[3]["CastFrame"]:Show(false)
	end
	
	for i=1, 3 do 	
		self.FrameAlias[i].RaidMarkerNum = 0
		self.FrameAlias[i].RecordedName = ""
		self.FrameAlias[i].RecordedHealth = 0
		self.FrameAlias[i].RecordedShield = 0
		self.FrameAlias[i].RecordedAbsorb = 0
		self.FrameAlias[i].RecordedHealthMax = 0
		self.FrameAlias[i].RecordedShieldMax = 0
		self.FrameAlias[i].RecordedAbsorbMax = 0
		self.FrameAlias[i]["ClassIcon"]:Show(self.tSettings.bShowClassIcons)
		self.FrameAlias[i]["MobRank"]:Show(self.tSettings.bShowClassIcons)
	end
	for i=2,3 do
		self.FrameAlias[i].ToTRecordedHealth = 0
		self.FrameAlias[i].ToTRecordedShield = 0
--		self.FrameAlias[i].RecordedAbsorb = 0
	end
	if not self.tSettings.bAutoHideFrame then
		self.FrameAlias[1]["LargeFrame"]:Show(true)	
		self.FrameAlias[1]["BeneBuffBar"]:Show(true)	
		self.FrameAlias[1]["HarmBuffBar"]:Show(true)	
	end
	self.FrameAlias[2]["ToTWindow"]:Show(self.tSettings.bShowToT)
	self.FrameAlias[3]["ToTWindow"]:Show(self.tSettings.bShowToT)
	self.FrameAlias[2]["TargetUnit"] = nil
	self.FrameAlias[3]["TargetUnit"] = nil
		
	self:ClassOptions(self.player:GetClassId())
	
	if self.tSettings.bSmoothCastBar then
		Apollo.RemoveEventHandler("NextFrame", self)
    	Apollo.RegisterEventHandler("NextFrame", "OnNextFrame", self)
	else
		Apollo.RemoveEventHandler("NextFrame", self)
	end		
	
	self:FillAllFrames()
	
	self.PlayerBuffRight = self.tSettings.PlayerBuffRight
	self.TargetBuffRight = self.tSettings.TargetBuffRight
	self.FocusBuffRight = self.tSettings.FocusBuffRight

	self.tSettings.PlayerBuffRight = self.PopUp:FindChild("PlayerBuffsAlignR"):IsChecked()
	self.tSettings.TargetBuffRight = self.PopUp:FindChild("TargetBuffsAlignR"):IsChecked()
	self.tSettings.FocusBuffRight = self.PopUp:FindChild("FocusBuffsAlignR"):IsChecked()

	self:ProcessBuffBarChanges()

--	self:ColorFrameObjects()

	self:BuffBarVisibility()
end



function KuronaFrames:ProcessBuffBarChanges()
	if self.tSettings.PlayerBuffRight ~= self.PlayerBuffRight  then
		self:NewBuffBars(1, "BeneBuffBar",self.tSettings.PlayerBuffRight,self.player)
		self:NewBuffBars(1, "HarmBuffBar",self.tSettings.PlayerBuffRight,self.player)
	end
	if self.tSettings.TargetBuffRight ~= self.TargetBuffRight  then
		self:NewBuffBars(2, "BeneBuffBar",self.tSettings.TargetBuffRight,self.player:GetTarget())
		self:NewBuffBars(2, "HarmBuffBar",self.tSettings.TargetBuffRight,self.player:GetTarget())
	end
	if self.tSettings.FocusBuffRight ~= self.FocusBuffRight  then
		local focus
		if self.tSettings.bShowFocusBuffs then 
			focus = self.player:GetAlternateTarget()
		else
			focus = nil
		end

		self:NewBuffBars(3, "BeneBuffBar",self.tSettings.FocusBuffRight, focus)
		self:NewBuffBars(3, "HarmBuffBar",self.tSettings.FocusBuffRight, focus)
	end
end


function KuronaFrames:CreateBuffBars()

	if self.tSettings.PlayerBuffRight then
		self:NewBuffBars(1, "BeneBuffBar",self.tSettings.PlayerBuffRight,self.player)
		self:NewBuffBars(1, "HarmBuffBar",self.tSettings.PlayerBuffRight,self.player)
	end
	
	if self.tSettings.TargetBuffRight then
		self:NewBuffBars(2, "BeneBuffBar",self.tSettings.TargetBuffRight, self.player:GetTarget())
		self:NewBuffBars(2, "HarmBuffBar",self.tSettings.TargetBuffRight, self.player:GetTarget())
	end
	if self.tSettings.FocusBuffRight then
		local focus
		if self.tSettings.bShowFocusBuffs then 
			focus = self.player:GetAlternateTarget()
		else
			focus = nil
		end
		self:NewBuffBars(3, "BeneBuffBar",self.tSettings.FocusBuffRight, focus)
		self:NewBuffBars(3, "HarmBuffBar",self.tSettings.FocusBuffRight, focus)
	end
	
	
	local bufftarget = {}
	bufftarget[1] = self.player
	bufftarget[2] = self.player:GetTarget()
	bufftarget[3] = self.player:GetAlternateTarget()
	
	for i = 1, 3 do
	-- Buff Bars
		self.FrameAlias[i]["BeneBuffBar"]:SetUnit(nil)
		self.FrameAlias[i]["HarmBuffBar"]:SetUnit(nil)
		if (i == 3 and self.tSettings.bShowFocusBuffs) or i ~= 3 then
			self.FrameAlias[i]["BeneBuffBar"]:SetUnit(bufftarget[i])
			self.FrameAlias[i]["HarmBuffBar"]:SetUnit(bufftarget[i])
		end
	end	
end


function KuronaFrames:ClassOptions(class)
	local needFlagSet = false
	if class == 3 then
		self.tSettings.bEsperTA = self.PopUp:FindChild("EsperTAButton"):IsChecked()
		self.Overlay:DestroyAllPixies()
		self.tSettings.bShowPsiPoints = self.PopUp:FindChild("EsperShowPsiPointsButton"):IsChecked()
		self.tSettings.bTrackCharges = self.PopUp:FindChild("EsperTrackChargesButton"):IsChecked()
		self.tSettings.bTrackMentalOverflow = self.PopUp:FindChild("EsperTrackMentalOverflowButton"):IsChecked()
		self.PsiChargeCount = 99 
		self.MentalOverflowCount = 0
		local ChargeBox = self.Resources:FindChild("PsiCharges")
		if ChargeBox then
			ChargeBox:GetChildren()[1]:Show(false,false)
			ChargeBox:GetChildren()[2]:Show(false,false)
		end
		if self.PsiPointDisplay then
			self.PsiPointDisplay:SetText("")
		end
		if self.tSettings.bEsperTA then needFlagSet = true end
	end
	if class == GameLib.CodeEnumClass.Spellslinger then
		self.tSettings.bShowSpellPower = self.PopUp:FindChild("SpellPowerButton"):IsChecked()
		self.SpellPowerValue:SetText("")
	end
	
	if class == GameLib.CodeEnumClass.Stalker then
		self.tSettings.bStalkerTA = self.PopUp:FindChild("StalkerTAButton"):IsChecked()
		self.Overlay:DestroyAllPixies()
		if self.tSettings.bStalkerTA then needFlagSet = true end
	end	
	
	if needFlagSet and not self.tSettings.bSmoothCastBar then
		self.tSettings.bSmoothCastBar = true
		self.PopUp:FindChild("SmoothCastBarButton"):SetCheck(self.tSettings.bSmoothCastBar)
	end
end


function KuronaFrames:StylesButtonClicked( wndHandler, wndControl, eMouseButton )
	wndControl:SetCheck(true)
	self.PopUp:FindChild("StylesWindow"):Show(true)
	self.PopUp:FindChild("OptionsWindow"):Show(false)
end


function KuronaFrames:EditButtonClicked( wndHandler, wndControl, eMouseButton )
	--wndControl:SetCheck(true)
--	self.PopUp:FindChild("EditWindow"):Show(true)
--	self.PopUp:FindChild("OptionsWindow"):Show(false)
	self.EditModeForm:Show(true,true)
	self.PopUp:Show(false)
	self.bEditMode = true
	if self.picker then
		self.picker:Destroy()
		self.picker = nil
	end
end


function KuronaFrames:ReturnToPopUp( wndHandler, wndControl, eMouseButton )
	if self.bEditMode then
		self.PopUp:Show(true)
		self:ExitEditMode()
		self.EditModeForm:Show(false,true)
	end
end


function KuronaFrames:OnSaveSlotPressed( wndHandler, wndControl, eMouseButton )
	local button = wndControl:GetName()

	if button  == "Restore1Button" then
		if self.SavedSettings1 ~= nil then
			self:RestoreSettings(self.SavedSettings1)
		else Print("No Save Found")
		end
	elseif button  == "Save1Button" then
		self.SavedSettings1 = self:OnSave(GameLib.CodeEnumAddonSaveLevel.Character,true)
		self.SavedSettings1.SavedSettings1 = nil
		self.SavedSettings1.SavedSettings2 = nil

		Print("Saved Settings in Slot 1")
	elseif button  == "Restore2Button" then
		if self.SavedSettings2 ~= nil then
			self:RestoreSettings(self.SavedSettings2)
			else Print("No Save Found")
		end
	elseif button  == "Save2Button" then
		self.SavedSettings2 = self:OnSave(GameLib.CodeEnumAddonSaveLevel.Character,true)
		self.SavedSettings2.SavedSettings1 = nil
		self.SavedSettings2.SavedSettings2 = nil
		Print("Saved Settings in Slot 2")
	elseif button == "UndoButton" then
		self:RestoreSettings(self.backupSettings)
	end
end


function KuronaFrames:OnAbilityBookChange()
	self.HasMindBurst = false
	self.HasTKStorm = false
	self.HasImpale = false
	self.Overlay:DestroyAllPixies()
	self.abilityBookTimer = Apollo.CreateTimer("AbilityBook_CacheTimer", 3, false)
end


function KuronaFrames:DelayedAbilityBookCheck()
	if GameLib.GetPlayerUnit() == nil then return end
	if GameLib.GetPlayerUnit():GetClassId() == GameLib.CodeEnumClass.Esper then
		self.HasMindBurst = self:AbilityBookCheck(19019)
		self.HasTKStorm = self:AbilityBookCheck(19024)
	elseif GameLib.GetPlayerUnit():GetClassId() == GameLib.CodeEnumClass.Stalker then
		self.HasImpale = self:AbilityBookCheck(23161)
	end
end


function KuronaFrames:AbilityBookCheck(nId)
    local tCurrLAS = ActionSetLib.GetCurrentActionSet()
    if tCurrLAS then
        for nIndex, nAbilityId in ipairs(tCurrLAS) do
            if nAbilityId == nId then -- Match
				return true
            end
        end
    end
	return false
end


function KuronaFrames:ResizeCastBar(wndHandler)
	local nHeight =	wndHandler:FindChild("SpellIcon"):GetHeight()
	local nWidth =  wndHandler:FindChild("SpellIcon"):GetWidth()
	if nHeight ~= nWidth then
	
		local l,t,r,b = wndHandler:FindChild("CastBar"):GetAnchorOffsets()
		
		if wndHandler == self.playerFrame:FindChild("CastFrame") then
			wndHandler:FindChild("SpellIcon"):SetAnchorOffsets(3,3,nHeight+3,-3)
			wndHandler:FindChild("CastBar"):SetAnchorOffsets(nHeight+4,t,r,b)
--			wndHandler:FindChild("CastBarFrame"):SetAnchorOffsets(-nHeight-3,-2,3,2)
		else
			wndHandler:FindChild("SpellIcon"):SetAnchorOffsets(0,0,nHeight,0)
		end
	end
end


function KuronaFrames:OnWindowResize( wndHandler, wndControl )
end

---------------------------------------------------------------------------------------------------
-- OptionsExtras Functions
---------------------------------------------------------------------------------------------------
function KuronaFrames:OnSliderChanged( wndHandler, wndControl, fNewValue, fOldValue )
	local value = wndControl:GetValue()
	local class =  self.player:GetClassId()
	if class == 3 then
		self.tSettings.bEsperTAOpacity = self.PopUp:FindChild("TAOpacitySliderBar"):GetValue()
		self.PopUp:FindChild("TAOpacityValue"):SetText(self.tSettings.bEsperTAOpacity)
		self.MindBurstAlpha = string.format("%02x",self.tSettings.bEsperTAOpacity*2.55)
	end
	
	self.tSettings.nBarOpacity = self.PopUp:FindChild("BarAlphaSliderBar"):GetValue()
	self:SetBarAlpha(self.tSettings.nBarOpacity / 100,self.tSettings.nCastbarOpacity / 100)
	self.PopUp:FindChild("BAValue"):SetText(self.tSettings.nBarOpacity.."%")

	self.tSettings.nCastbarOpacity = self.PopUp:FindChild("CastbarAlphaSliderBar"):GetValue()
	self:SetBarAlpha(self.tSettings.nBarOpacity / 100,self.tSettings.nCastbarOpacity / 100)
	self.PopUp:FindChild("CastbAValue"):SetText(self.tSettings.nCastbarOpacity.."%")
	
	

	self.tSettings.nAbsorbWidth = self.PopUp:FindChild("AbsorbWidthSliderBar"):GetValue() / 100
	self.tSettings.nShieldWidth	= self.PopUp:FindChild("ShieldWidthSliderBar"):GetValue() / 100
	self.PopUp:FindChild("ShieldWidthValue"):SetText(self.tSettings.nShieldWidth * 100 .."%")
	self.PopUp:FindChild("AbsorbWidthValue"):SetText(self.tSettings.nAbsorbWidth * 100 .."%")
	self.frameResizeNeeded = true
	
	self.tSettings.nProxRangeGroup = self.PopUp:FindChild("ProxGroupRangeSliderBar"):GetValue()
	self.PopUp:FindChild("ProxGroupRangeValue"):SetText(self.tSettings.nProxRangeGroup.."m")

	self.tSettings.nProxRangeSolo = self.PopUp:FindChild("ProxSoloRangeSliderBar"):GetValue()
	self.PopUp:FindChild("ProxSoloRangeValue"):SetText(self.tSettings.nProxRangeSolo.."m")

	self.tSettings.nLineThickness = self.PopUp:FindChild("LineThicknessSliderBar"):GetValue()
	self.PopUp:FindChild("LineThicknessValue"):SetText(self.tSettings.nLineThickness.."px")
	
end		

-- when the OK button is clicked
function KuronaFrames:OnButtonClosed()
	self:ExitEditMode()
	self.EditModeForm:Show(false)
	self.PopUp:Close() -- hide the window
--	self.PopUp:FindChild("OptionsWindow"):Show(true)
--	self.PopUp:FindChild("EditWindow"):Show(false)
--	self.PopUp:FindChild("RightButton"):SetCheck(true)	
--	self.PopUp:FindChild("LeftButton"):SetCheck(false)
	if self.picker then
		self.picker:Destroy()
		self.picker = nil
	end
end

-- when the Cancel button is clicked
function KuronaFrames:SetDefaults()
	self.frameResizeNeeded= true
	self.SettingDefaults = true
	self.tSettings = self:DefaultTable()
	self:ProcessBuffBarChanges()
	self:SetFramePositions()

	--self:OnSettingChange()
	self:FillOptionsWindow()
	self:OnSettingChange()
	self:SetFonts()
	self:SaveBuffBarPositions()
	self:SetFramePositions()
	self:SaveBuffBarPositions()
	self:SetOptionColorPanel()
	self.bEditModeWindowFilled = false
	self.SettingDefaults = false
end


function KuronaFrames:OnOpenOptions()
	if not self.PopUp:IsVisible() then
		if self.bEditMode then self:ReturnToPopUp() return end
		self.OptionsList:FindChild("ImportSettingsButton"):SetCheck(false)
		self.PopUp:Invoke()
		self.PopUp:ToFront()
	else
		self:OnButtonClosed()
	end
end

function KuronaFrames:OnConfigure(sCommand, sArgs)
	if self.PopUp then
		self:OnOpenOptions()
	end
end


function KuronaFrames:OnStanceBtn(wndHandler, wndControl)
	Pet_SetStance(0, tonumber(wndHandler:GetData())) -- First arg is for the pet ID, 0 means all engineer pets
	self.playerFrame:FindChild("StanceMenuOpenerBtn"):SetCheck(false)
	self.playerFrame:FindChild("PetText"):SetText(wndHandler:GetText())
	self.playerFrame:FindChild("PetText"):SetData(wndHandler:GetText())
end


function KuronaFrames:OnPetBtn(wndHandler, wndControl)
	 local wndPetContainer = self.playerFrame:FindChild("PetBarContainer")
	 wndPetContainer:Show(not wndPetContainer:IsShown())
end


function KuronaFrames:OnEngineerPetBtnMouseEnter(wndHandler, wndControl)
	wndHandler:SetBGColor("white")
	local strHover = ""
	local strWindowName = wndHandler:GetName()
	if strWindowName == "ActionBarShortcut.12" then
		strHover = Apollo.GetString("ClassResources_Engineer_PetAttack")
	elseif strWindowName == "ActionBarShortcut.13" then
		strHover = Apollo.GetString("CRB_Stop")
	elseif strWindowName == "ActionBarShortcut.15" then
		strHover = Apollo.GetString("ClassResources_Engineer_GoTo")
	elseif strWindowName == "ActionBarShortcut.14" then
		strHover = "Dismiss Pets"
	end
	self.playerFrame:FindChild("PetText"):SetText(strHover)
end


function KuronaFrames:OnEngineerPetBtnMouseExit(wndHandler, wndControl)
	wndHandler:SetBGColor("UI_AlphaPercent50")
	self.playerFrame:FindChild("PetText"):SetText(self.playerFrame:FindChild("PetText"):GetData() or "")
end


function KuronaFrames:OnResizeCastBar( wndHandler, wndControl )
	self:ResizeCastBar( wndHandler, wndControl )
end


function KuronaFrames:EsperTelegraph()

	if self.EsperResources < 4 then	return end
	local unit = self.player
	
	local uface = unit:GetFacing()
	if not uface then return end
	local uangle = math.atan2(uface.x, uface.z)
	local tPos = unit:GetPosition()
	local nOffsetDegree = uangle+math.rad(180)
	
	local vec = tPos

	if self.Target then
		local pos = self.Target:GetPosition()
        vec = Vector3.New(pos.x, pos.y, pos.z)
	end

	
	local originPositionVector= { x = tPos.x+1*math.sin(nOffsetDegree) , y = tPos.y , z = tPos.z+1*math.cos(nOffsetDegree) }
	local dist = 27
	local firstVector= Vector3.New(originPositionVector.x+dist*sin(uangle),  vec.y, originPositionVector.z+dist*cos(uangle))
	local startPoint = GameLib.WorldLocToScreenPoint(firstVector)

	local rotation_point = uangle + rad(14.7)
	local currentVector = Vector3.New(originPositionVector.x+dist*sin(rotation_point),vec.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointA = GameLib.WorldLocToScreenPoint(currentVector)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = self.MindBurstAlpha .."000000", loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointA.x, endPointA.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointA.x, endPointA.y } }    } )

	local rotation_point = uangle + rad(-14.6)
	local currentVector = Vector3.New(originPositionVector.x+dist*sin(rotation_point), vec.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointB = GameLib.WorldLocToScreenPoint(currentVector)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = self.MindBurstAlpha .."000000", loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointB.x, endPointB.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointB.x, endPointB.y } }    } )

	local dist =-2
	local rotation_point = uangle + rad(171)
	local currentVector = Vector3.New(originPositionVector.x+dist*sin(rotation_point), originPositionVector.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointC = GameLib.WorldLocToScreenPoint(currentVector)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = self.MindBurstAlpha .."000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointB.x, endPointB.y, endPointC.x, endPointC.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointB.x, endPointB.y, endPointC.x, endPointC.y } }    } )
		
	local dist =-2
	local rotation_point = uangle + rad(-171)
	local currentVector = Vector3.New(originPositionVector.x+dist*sin(rotation_point), originPositionVector.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointD = GameLib.WorldLocToScreenPoint(currentVector)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = self.MindBurstAlpha .."000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointA.x, endPointA.y, endPointD.x, endPointD.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointA.x, endPointA.y, endPointD.x, endPointD.y } }    } )
	
	
	self.DrawnPixies = true
end

function KuronaFrames:EsperStormTelegraph()
	if self.EsperResources < 4 then	return end
	local unit = self.player
	
	local uface = unit:GetFacing()
	if not uface then return end
	local uangle = math.atan2(uface.x, uface.z)
	local tPos = unit:GetPosition()
	local nOffsetDegree = uangle+math.rad(180)
	
	local vec = tPos

	if self.Target then
		local pos = self.Target:GetPosition()
        vec = Vector3.New(pos.x, pos.y, pos.z)
	end
	
	local originPositionVector= { x = tPos.x+5*math.sin(nOffsetDegree) , y = tPos.y , z = tPos.z+5*math.cos(nOffsetDegree) }
	local dist = 6.2
	local firstVector= Vector3.New(originPositionVector.x+dist*sin(uangle),  tPos.y, originPositionVector.z+dist*cos(uangle))
	local startPoint = GameLib.WorldLocToScreenPoint(firstVector)

	local rotation_point = uangle + rad(14)
	local currentVector = Vector3.New(originPositionVector.x+dist*sin(rotation_point),tPos.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointA = GameLib.WorldLocToScreenPoint(currentVector)
	--self.Overlay:AddPixie( { bLine = true, fWidth = 2,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointA.x, endPointA.y } }    } )

	local rotation_point = uangle + rad(-14)
	local currentVector = Vector3.New(originPositionVector.x+dist*sin(rotation_point), tPos.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointB = GameLib.WorldLocToScreenPoint(currentVector)
	--self.Overlay:AddPixie( { bLine = true, fWidth = 2,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointB.x, endPointB.y } }    } )

	local dist =-40
	local rotation_point = uangle + rad(178)
	local currentVector = Vector3.New(originPositionVector.x+dist*sin(rotation_point), vec.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointC = GameLib.WorldLocToScreenPoint(currentVector)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = self.MindBurstAlpha .."000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointB.x, endPointB.y, endPointC.x, endPointC.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointB.x, endPointB.y, endPointC.x, endPointC.y } }    } )
		
	local dist =-40
	local rotation_point = uangle + rad(-178)
	local currentVector = Vector3.New(originPositionVector.x+dist*sin(rotation_point), vec.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointD = GameLib.WorldLocToScreenPoint(currentVector)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = self.MindBurstAlpha.."000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointA.x, endPointA.y, endPointD.x, endPointD.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointA.x, endPointA.y, endPointD.x, endPointD.y } }    } )
	
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = self.MindBurstAlpha.."000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointC.x, endPointC.y, endPointD.x, endPointD.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = self.mindBurstColor, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointC.x, endPointC.y, endPointD.x, endPointD.y } }    } )
	
	self.DrawnPixies = true
end


function KuronaFrames:StalkerTelegraph()

	if not self.player:IsInCombat() then return end

	local target = self.player:GetTarget()
	local length = 0
	local nResourceCurrent = self.player:GetResource(3)
	if nResourceCurrent  < 30 then return end
	local uface = self.player:GetFacing()
	if not uface then return end
	local uangle = math.atan2(uface.x, uface.z)
	local tPos = self.player:GetPosition()
	local nOffsetDegree = uangle+math.rad(180)
	local color = self.tSettings.ImpaleColor
	
	if target then
		local xPos = target:GetPosition()
		local tVec = Vector3.New(xPos.x, xPos.y, xPos.z)
		local uVec = Vector3.New(tPos.x, tPos.y, tPos.z)
		length	= (uVec - tVec):Length()
	end
	
	local originPositionVector= { x = tPos.x+0*math.sin(nOffsetDegree) , y = tPos.y , z = tPos.z+0*math.cos(nOffsetDegree) }
	local dist = 7
	local firstVector= Vector3.New(originPositionVector.x+dist*sin(uangle), originPositionVector.y, originPositionVector.z+dist*cos(uangle))
	local startPoint = GameLib.WorldLocToScreenPoint(firstVector)

	local rotation_point = uangle + rad(17.5)
	local currentVectorA = Vector3.New(originPositionVector.x+dist*sin(rotation_point), originPositionVector.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointA = GameLib.WorldLocToScreenPoint(currentVectorA)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = "ff000000", loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointA.x, endPointA.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = color, loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointA.x, endPointA.y } }    } )

	local rotation_point = uangle + rad(-17.5)
	local currentVectorAR = Vector3.New(originPositionVector.x+dist*sin(rotation_point), originPositionVector.y, originPositionVector.z+dist*cos(rotation_point))
	local endPointAR = GameLib.WorldLocToScreenPoint(currentVectorAR)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = "ff000000", loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointAR.x, endPointAR.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = color, loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPointAR.x, endPointAR.y } }    } )

	local dist = -2.1
	local rotation_point = uangle + rad(-64.5)
	local currentVectorB = Vector3.New(currentVectorA.x+dist*sin(rotation_point), currentVectorA.y, currentVectorA.z+dist*cos(rotation_point))
	local endPointAe = GameLib.WorldLocToScreenPoint(currentVectorB)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = "ff000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointAe.x, endPointAe.y, endPointA.x, endPointA.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = color, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointAe.x, endPointAe.y, endPointA.x, endPointA.y } }    } )

	
	local rotation_point = uangle + rad(64.5)
	local currentVectorBR = Vector3.New(currentVectorAR.x+dist*sin(rotation_point), currentVectorAR.y, currentVectorAR.z+dist*cos(rotation_point))
	local endPointAeR = GameLib.WorldLocToScreenPoint(currentVectorBR)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = "ff000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointAeR.x, endPointAeR.y, endPointAR.x, endPointAR.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = color, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointAeR.x, endPointAeR.y, endPointAR.x, endPointAR.y } }    } )

	local dist = -6
	local rotation_point = uangle + rad(35)
	local currentVectorG = Vector3.New(currentVectorB.x+dist*sin(rotation_point), currentVectorB.y, currentVectorB.z+dist*cos(rotation_point))
	local endPointC = GameLib.WorldLocToScreenPoint(currentVectorG)
	if self.tSettings.bLineOutlines then self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = "ff000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointAe.x, endPointAe.y, endPointC.x, endPointC.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = color, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointAe.x, endPointAe.y, endPointC.x, endPointC.y } }    } )

	
	local rotation_point = uangle + rad(-35)
	local currentVectorGR = Vector3.New(currentVectorBR.x+dist*sin(rotation_point), currentVectorBR.y, currentVectorBR.z+dist*cos(rotation_point))
	local endPointCR = GameLib.WorldLocToScreenPoint(currentVectorGR)
	if self.tSettings.bLineOutlines then 	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness+2,  cr = "ff000000", loc = { fPoints = {0,0,0,0}, nOffsets = { endPointAeR.x, endPointAeR.y, endPointCR.x, endPointCR.y } }    } ) end
	self.Overlay:AddPixie( { bLine = true, fWidth = self.tSettings.nLineThickness,  cr = color, loc = { fPoints = {0,0,0,0}, nOffsets = { endPointAeR.x, endPointAeR.y, endPointCR.x, endPointCR.y } }    } )
	self.DrawnPixies = true
end




function KuronaFrames:UpdateResources(player)
	if self.tSettings.bUseGenericResources then
			self:UpdateGenericResources(player)
		return
	end

	if player:GetClassId() == GameLib.CodeEnumClass.Medic then
		self:UpdateMedicResources(player)
	elseif player:GetClassId() == GameLib.CodeEnumClass.Esper then
		self:UpdateEsperResources(player)
	elseif player:GetClassId() == GameLib.CodeEnumClass.Stalker then
		self:UpdateStalkerResources(player)
	elseif player:GetClassId() == GameLib.CodeEnumClass.Warrior then
		self:UpdateWarriorResources(player)
	elseif player:GetClassId() == GameLib.CodeEnumClass.Spellslinger then
		self:UpdateSpellslingerResources(player)
	elseif player:GetClassId() == GameLib.CodeEnumClass.Engineer then
		self:UpdateEngineerResources(player)
	end
end


function KuronaFrames:UpdateGenericResources(player)
local class = player:GetClassId()

	local nResourceMax = player:GetMaxResource(playerResourceType[class])
	local nResourceCurrent = player:GetResource(playerResourceType[class])
	local bManaFull = true
	if class == GameLib.CodeEnumClass.Medic or class == GameLib.CodeEnumClass.Esper or class == GameLib.CodeEnumClass.Spellslinger then
		if self.tSettings.bDisplayFocus then
			if not self.FocusBar:IsShown() then
				self.FocusBar:Show(true)
			end
		if not PTR then		
			nManaMax = math.floor(player:GetMaxMana())
			nManaCurrent = math.floor(player:GetMana())
		else
			nManaMax = math.floor(player:GetMaxFocus())
			nManaCurrent = math.floor(player:GetFocus())
		end
			local nManaPercent = math.floor((nManaCurrent/ nManaMax) * 100)	
			if nManaPercent ~= self.FocusValue then
				self.FocusBarMeter:SetMax(nManaMax)
				self.FocusBarMeter:SetProgress(nManaCurrent)
			end
			self.FocusValue = nManaPercent
			bManaFull = nManaCurrent >= nManaMax*0.95
		end
	end
	
	if class == GameLib.CodeEnumClass.Esper then
		self.EsperResources = nResourceCurrent
		local colorList = {}
		colorList[0] = "00000000"
		colorList[1] = "ff0000ff"
		colorList[2] = "ff0000ff"
		colorList[3] = "ff0000ff"
		colorList[4] = "ffffff00"
		colorList[5] = "ffff0000"
		if self.HasMindBurst or  self.HasTKStorm then
			self.mindBurstColor = self.MindBurstAlpha.. string.sub(colorList[nResourceCurrent],3,8)
		end
	end

	if self.tSettings.bAutoHideResources then
		if class == GameLib.CodeEnumClass.Medic or class == GameLib.CodeEnumClass.Stalker or class == GameLib.CodeEnumClass.Spellslinger then
			if not self.bCombatState and nResourceCurrent == nResourceMax and bManaFull then
				if self.Resources:IsShown() then
					self.Resources:Show(false)
				end
				return
			end
		elseif class == GameLib.CodeEnumClass.Esper or class == GameLib.CodeEnumClass.Warrior or class == GameLib.CodeEnumClass.Engineer then
			if not self.bCombatState and nResourceCurrent == 0 and bManaFull then
				if self.Resources:IsShown() then
					self.Resources:Show(false)
				end
			return
			end
		end
	end

	
	
	if not self.Resources:IsShown() then
		self.Resources:Show(true)
	end

	
	
	local bInnate = GameLib.IsCurrentInnateAbilityActive()
	
	if bInnate and not self.bInnateActive then
		local frame = self.Resources:FindChild("Frame")
		local IWindow = self.Resources:FindChild("InnateC")
		self.bInnateActive = true
		IWindow:Show(true)
		frame:SetSprite(self:GetFrameType("WarriorFlash"))
		frame:SetBGColor("ffffffff")
	elseif not bInnate and self.bInnateActive then
		local frame = self.Resources:FindChild("Frame")
		local IWindow = self.Resources:FindChild("InnateC")
		self.bInnateActive = false
		IWindow:Show(false)
		frame:SetSprite(self:GetFrameType("normal"))
		frame:SetBGColor(self.tSettings.sFrameColor)
	end
	
	local rBar = self.Resources:FindChild("GResourceBar")


	
	
	if class == GameLib.CodeEnumClass.Medic then
		nResourceMax = nResourceMax * 100
		nResourceCurrent = nResourceCurrent * 100

		local tBuffs = player:GetBuffs()
		for idx, tCurrBuffData in pairs(tBuffs.arBeneficial or {}) do
			if tCurrBuffData.splEffect:GetId() == 42569 then -- TODO replace with code enum
				nPartialCount = tCurrBuffData.nCount
				if nResourceCurrent < 400 then
					nResourceCurrent = nResourceCurrent +(nPartialCount*33)
				end
				break
			end
		end
		local outputString = nResourceCurrent / 100
		local len = string.len(tostring(outputString))
		if len == 1 then
			outputString = outputString ..".00"
		end
	
		rBar:SetMax(nResourceMax)
		rBar:SetProgress(nResourceCurrent)
		rBar:SetText(outputString)

	else
		rBar:SetMax(nResourceMax)
		rBar:SetProgress(nResourceCurrent)
	end
end


function KuronaFrames:UpdateMedicResources(player)
	local nResourceMax = player:GetMaxResource(1)
	local nResourceCurrent = player:GetResource(1)
	local bManaFull = true 
		
		if self.tSettings.bDisplayFocus then
			if not self.FocusBar:IsShown() then
				self.FocusBar:Show(true)
			end
		if not PTR then		
			nManaMax = math.floor(player:GetMaxMana())
			nManaCurrent = math.floor(player:GetMana())
		else
			nManaMax = math.floor(player:GetMaxFocus())
			nManaCurrent = math.floor(player:GetFocus())
		end
			local nManaPercent = math.floor((nManaCurrent/ nManaMax) * 100)	
			if nManaPercent ~= self.FocusValue then
				self.FocusBarMeter:SetMax(nManaMax)
				self.FocusBarMeter:SetProgress(nManaCurrent)
			end
			self.FocusValue = nManaPercent
			bManaFull = nManaCurrent >= nManaMax*0.95
		end
	
	if self.tSettings.bAutoHideResources then			
		if not self.bCombatState and nResourceCurrent == nResourceMax and bManaFull then
			for idx = 1, 4 do
				self.ActuatorList[idx]:SetBGColor("ff00ff00")
			end
			self.Resources:Show(false)
		return
		end
	end
	
	if not self.Resources:IsShown() then
		self.Resources:Show(true)
	end
	
	local nPartialCount = 0
	local tBuffs = player:GetBuffs()
	local red = "ffff0000"
	local yellow = "ffffff00"
	local green = "ff00ff00"
	
	for idx, tCurrBuffData in pairs(tBuffs.arBeneficial or {}) do
		if tCurrBuffData.splEffect:GetId() == 42569 then -- TODO replace with code enum
			nPartialCount = tCurrBuffData.nCount
			break
		end
	end
	
	local bFirstPartial = true
	for idx = 1, 4 do
		local color = "00000000"
		local bFull = nResourceCurrent >= idx
		local bShowPartial = bFirstPartial and nPartialCount > 0
	
		if bFull then
			color = green
		elseif not bFull and nPartialCount == 2 and bFirstPartial then
			color = yellow
			bFirstPartial = false
		elseif not bFull and nPartialCount == 1 and bFirstPartial then
			color = red
			bFirstPartial = false
		end
		self.ActuatorList[idx]:SetBGColor(color)
	end
	
	
	local bInnate = GameLib.IsCurrentInnateAbilityActive()
	
	if bInnate and not self.bInnateActive then
		local frame1 = self.Resources:FindChild("Frame1")
		local frame2 = self.Resources:FindChild("Frame2")
		local frame3 = self.Resources:FindChild("Frame3")
		local frame4 = self.Resources:FindChild("Frame4")

		local BaseWindow = self.Resources:FindChild("MedicInnate")
		self.bInnateActive = true
		BaseWindow:Show(true)
		local sprite = ""
		
		local sprite =self:GetFrameType("WarriorFlash")

		frame1:SetSprite(sprite)
		frame2:SetSprite(sprite)
		frame3:SetSprite(sprite)
		frame4:SetSprite(sprite)


	elseif not bInnate and self.bInnateActive then
		local frame1 = self.Resources:FindChild("Frame1")
		local frame2 = self.Resources:FindChild("Frame2")
		local frame3 = self.Resources:FindChild("Frame3")
		local frame4 = self.Resources:FindChild("Frame4")

		local BaseWindow = self.Resources:FindChild("MedicInnate")
		self.bInnateActive = false
		BaseWindow:Show(false)
		local sprite =self:GetFrameType("normal")
		frame1:SetSprite(sprite)
		frame2:SetSprite(sprite)
		frame3:SetSprite(sprite)
		frame4:SetSprite(sprite)
	end	
end


function KuronaFrames:UpdateEsperResources(player)
	local nPsiChargeBuffId = 51964
	local nMentalOverflowBuffId = 77116
	local nResourceMax = player:GetMaxResource(1)
	local nResourceCurrent = player:GetResource(1)
	self.EsperResources = nResourceCurrent
	local bManaFull = true 

		if self.tSettings.bDisplayFocus then
			if not self.FocusBar:IsShown() then
				self.FocusBar:Show(true)
			end

		if not PTR then		
			nManaMax = math.floor(player:GetMaxMana())
			nManaCurrent = math.floor(player:GetMana())
		else
			nManaMax = math.floor(player:GetMaxFocus())
			nManaCurrent = math.floor(player:GetFocus())
		end
			local nManaPercent = math.floor((nManaCurrent/ nManaMax) * 100)	
			if nManaPercent ~= self.FocusValue then
				self.FocusBarMeter:SetMax(nManaMax)
				self.FocusBarMeter:SetProgress(nManaCurrent)
			end
			self.FocusValue = nManaPercent
			bManaFull = nManaCurrent >= nManaMax*0.95
		end
	
	
	if self.tSettings.bAutoHideResources then			
		if not self.bCombatState and nResourceCurrent == 0 and bManaFull then
			if self.Resources:IsShown() then
				self.Resources:Show(false)
				self.playerFrame:FindChild("CastBarFrame"):SetBGColor(self.tSettings.sFrameColor)
			end
			return
		end
	end
	
	if not self.Resources:IsShown() then
		self.Resources:Show(true)
	end
	local colorList = {}
	colorList[0] = "ff0000ff"
	colorList[1] = "ff0000ff"
	colorList[2] = "ff0000ff"
	colorList[3] = "ff0000ff"
	colorList[4] = "ffffff00"
	colorList[5] = "ffff0000"
	
	if nResourceCurrent ~= self.PsiPoints then
		for idx = 1, 5 do
			if nResourceCurrent	== 0 then
				self.PPList[idx]:SetBGColor("0000ffff")
				for i=1,5 do
					self.EIcon[i]:Show(hide)
				end				
			else
				if idx <= nResourceCurrent  then
					self.PPList[idx]:SetBGColor(colorList[nResourceCurrent])
					self.EIcon[idx]:Show(true)
				else
					self.PPList[idx]:SetBGColor("0000ffff")
					self.EIcon[idx]:Show(false)
				end
			end
		end
		
		if nResourceCurrent > 3 then 
			self.playerFrame:FindChild("CastBarFrame"):SetBGColor(colorList[nResourceCurrent])
		else
			self.playerFrame:FindChild("CastBarFrame"):SetBGColor(self.tSettings.sFrameColor)
		end
	end
	
	if self.tSettings.bShowPsiPoints then
		if nResourceCurrent >= 5 then
			self.PsiPointDisplay:SetText(self.EsperResources+(self.MentalOverflowCount or 0))
		elseif nResourceCurrent == 0 then
			self.PsiPointDisplay:SetText("")
		else
			self.PsiPointDisplay:SetText(self.EsperResources)
		end
	end	
	
	local bInnate = GameLib.IsCurrentInnateAbilityActive()
	
	if bInnate and not self.bInnateActive then
		local frame = {}
		frame[1] = self.Resources:FindChild("Frame1")
		frame[2] = self.Resources:FindChild("Frame2")
		frame[3] = self.Resources:FindChild("Frame3")
		frame[4] = self.Resources:FindChild("Frame4")
		frame[5] = self.Resources:FindChild("Frame5")
		
		for i = 1,5 do
			if self.tSettings.nStyle == 1 then
				frame[i]:SetSprite("KuronaSprites:FlashFrame3")
			else
				frame[i]:SetSprite("KuronaSprites:SquareWarriorFlashFrame")
			end
		end	
		self.bInnateActive = true
	elseif not bInnate and self.bInnateActive then
		local frame = {}
		frame[1] = self.Resources:FindChild("Frame1")
		frame[2] = self.Resources:FindChild("Frame2")
		frame[3] = self.Resources:FindChild("Frame3")
		frame[4] = self.Resources:FindChild("Frame4")
		frame[5] = self.Resources:FindChild("Frame5")
		
		for i = 1,5 do
			if self.tSettings.nStyle == 1 then
				frame[i]:SetSprite("KuronaSprites:Frame2")
			else
				frame[i]:SetSprite("KuronaSprites:SquareFrame")
			end	
		end
		self.bInnateActive = false	
	end

	

	--PsiCharge
	if self.tSettings.bTrackCharges then
		local ChargeBox = self.Resources:FindChild("PsiCharges")
		ChargeBox:GetChildren()[1]:Show(self.PsiChargeCount==1,false)
		ChargeBox:GetChildren()[2]:Show(self.PsiChargeCount==2,false)
	end
	if self.tSettings.bTrackMentalOverflow then
	end
	
	self.PsiPoints = nResourceCurrent
	
	if self.HasMindBurst or self.HasTKStorm then
		self.mindBurstColor = self.MindBurstAlpha.. string.sub(colorList[nResourceCurrent],3,8)
	end
end


function KuronaFrames:UpdateStalkerResources(player)
	local nResourceMax = player:GetMaxResource(3)
	local nResourceCurrent = player:GetResource(3)
	local bInStealth = GameLib.IsCurrentInnateAbilityActive() 
	
	if self.tSettings.bAutoHideResources then			
		if not self.bCombatState and nResourceCurrent == 100 and not bInStealth then
			if self.Resources:IsShown() then
				self.Resources:Show(false)
				self.Resources:FindChild("StealthOverlay"):Show(false)
				end
			return
		end
	end
	if not self.Resources:IsShown() then
		self.Resources:Show(true)
	end
	
	if bInStealth then
		self.Resources:FindChild("Window"):SetOpacity(0.5,25)
		self.Resources:FindChild("StealthOverlay"):Show(true)
	else
		self.Resources:FindChild("Window"):SetOpacity(1,25)
		self.Resources:FindChild("StealthOverlay"):Show(false)
	end


	local sBar = self.sBar
	sBar:SetMax(nResourceMax)
	sBar:SetProgress(nResourceCurrent)
end


function KuronaFrames:UpdateWarriorResources(player)
	local nResourceMax = player:GetMaxResource(1)
	local nResourceCurrent = player:GetResource(1)
	local bOverdrive = GameLib.IsOverdriveActive()

	if self.tSettings.bAutoHideResources then	
		if not self.bCombatState and nResourceCurrent == 0 then
			if self.Resources:IsShown() then
				self.Resources:Show(false)
			end
			return
		end
	end

	if not self.Resources:IsShown() then
		self.Resources:Show(true)
	end

	local kBar = self.kBar
	local BaseWindow = self.Resources:FindChild("BaseWindow")
	
	if nResourceCurrent >= 750 and self.KineticRange~=750 then
		kBar:SetBarColor("95ff0000")
		self.KineticRange=750
	elseif nResourceCurrent >= 500 and nResourceCurrent < 750 and self.KineticRange~=500 then
		kBar:SetBarColor("90ff8000")
		self.KineticRange=500
	elseif nResourceCurrent >= 250 and nResourceCurrent < 500 and self.KineticRange~=250 then
		kBar:SetBarColor("90ffff00")
		self.KineticRange=250
	elseif nResourceCurrent < 250 and self.KineticRange~=0 then
		kBar:SetBarColor("90ffffff")
		self.KineticRange=0
	end

	
	
	if bOverdrive and not self.bOverDriveActive then
		local frame = self.Resources:FindChild("Frame")
		self.bOverDriveActive = true
		BaseWindow:SetStyle("Picture", true)
		frame:SetSprite(self:GetFrameType("WarriorFlash"))
		kBar:SetBarColor("95ff0000")
	elseif not bOverdrive and self.bOverDriveActive then
		local frame = self.Resources:FindChild("Frame")
		self.bOverDriveActive = false
		BaseWindow:SetStyle("Picture", false)
		frame:SetSprite(self:GetFrameType("normal"))
		self.KineticRange=999
	end
	
	
	kBar:SetMax(nResourceMax)
	kBar:SetProgress(nResourceCurrent)
	kBar:SetText(nResourceCurrent)
end

function KuronaFrames:UpdateSpellslingerResources(player)
	local nResourceMax = player:GetMaxResource(4)
	local nResourceCurrent = player:GetResource(4)
	local nResourceDiv4 = (nResourceCurrent / 25)
	local nResourceMaxDiv4 = nResourceMax / 4
	local bSurgeActive = GameLib.IsSpellSurgeActive()
	local nPartialSurge = (nResourceMax - nResourceCurrent) /4 
		
	local bManaFull = true 

	
		if self.tSettings.bDisplayFocus then
			if not self.FocusBar:IsShown() then
				self.FocusBar:Show(true)
			end
		if not PTR then		
			nManaMax = math.floor(player:GetMaxMana())
			nManaCurrent = math.floor(player:GetMana())
		else
			nManaMax = math.floor(player:GetMaxFocus())
			nManaCurrent = math.floor(player:GetFocus())
		end
			local nManaPercent = math.floor((nManaCurrent/ nManaMax) * 100)	
			if nManaPercent ~= self.FocusValue then
				self.FocusBarMeter:SetMax(nManaMax)
				self.FocusBarMeter:SetProgress(nManaCurrent)
			end
			self.FocusValue = nManaPercent
			bManaFull = nManaCurrent >= nManaMax*0.95
		end
	if self.tSettings.bAutoHideResources then			
		if not self.bCombatState and nResourceCurrent == nResourceMax and bManaFull then
			self.Resources:Show(false)
			self.CombatStatus:Show(false)
			return
		elseif self.bCombatState then
			self.CombatStatus:Show(true)
		end
	end
	
	if not self.Resources:IsShown() then
		self.Resources:Show(true)
	end
	
	
	for idx, wndBar in pairs({ self.SSList[1], self.SSList[2],self.SSList[3],self.SSList[4] }) do
		local nPartialProgress = nResourceCurrent - (nResourceMaxDiv4 * (idx - 1)) -- e.g. 250, 500, 750, 1000
		local bThisBubbleFilled = nPartialProgress >= nResourceMaxDiv4
		wndBar:SetMax(nResourceMaxDiv4)
		wndBar:SetProgress(nPartialProgress, 100)
		if bThisBubbleFilled then
			wndBar:FindChild("Sig"):Show(true)
		else
			wndBar:FindChild("Sig"):Show(false)
		end
		if bSurgeActive	then
			wndBar:SetBarColor("xkcdGoldenYellow")
		else
			wndBar:SetBarColor("xkcdAzure")
		end
	end
	
	if self.tSettings.bShowSpellPower then
		self.SpellPowerValue:SetText(nResourceCurrent)
	end
	
end


function KuronaFrames:UpdateEngineerResources(player)
	local nResourceCurrent = player:GetResource(1)
	local vBar1 = self.FrameAlias["vBar1"]
	local vBar2 = self.FrameAlias["vBar2"]
	local vBar3 = self.FrameAlias["vBar3"]
	
	if self.tSettings.bAutoHideResources then			
		if not self.bCombatState and nResourceCurrent == 0 then
			self.Resources:Show(false)
		return
		end
	end
	if not self.Resources:IsShown() then
		self.Resources:Show(true)
	end

	local bInnate = GameLib.IsCurrentInnateAbilityActive()
	if bInnate and not self.bInnateActive then
		local BaseWindow = self.Resources:FindChild("EngiInnate")
		self.bInnateActive = true
		BaseWindow:Show(true)

		for i = 1, 3 do
			local frame = self.Resources:FindChild("Frame"..i)
			frame:SetSprite(self:GetFrameType("WarriorFlash"))
		end
	elseif not bInnate and self.bInnateActive then
		local BaseWindow = self.Resources:FindChild("EngiInnate")
		self.bInnateActive = false
		BaseWindow:Show(false)
		for i = 1, 3 do
			local frame = self.Resources:FindChild("Frame"..i)
			frame:SetSprite(self:GetFrameType("normal"))
		end
	end

	if nResourceCurrent >= 30 and nResourceCurrent <= 70 then
		if not self.bInTheZone then
			vBar1:SetBarColor(self.tSettings.InTheZoneColor)
			vBar2:SetBarColor(self.tSettings.InTheZoneColor)
			vBar3:SetBarColor(self.tSettings.InTheZoneColor)
			self.bInTheZone = true
		end
	elseif self.bInTheZone then
		vBar1:SetBarColor("xkcdOrange")
		vBar2:SetBarColor("xkcdOrange")
		vBar3:SetBarColor("xkcdOrange")
		
		self.bInTheZone = false
		
	end
	
	local nResourceMax = player:GetMaxResource(1)
	
	vBar1:SetMax(nResourceMax * 0.3)
	vBar1:SetProgress(nResourceCurrent)
	
	vBar2:SetMax(nResourceMax * 0.4)
	if nResourceCurrent >= nResourceMax * 0.3 then
		vBar2:SetProgress(nResourceCurrent - (nResourceMax * 0.3))
	else
		vBar2:SetProgress(0)
	end
	
	vBar3:SetMax(nResourceMax * 0.3)
	if nResourceCurrent >= nResourceMax * 0.7 then
		vBar3:SetProgress(nResourceCurrent - (nResourceMax * 0.7))
	else
		vBar3:SetProgress(0)
	end
	
	vBar2:SetText(nResourceCurrent)
	
end


function KuronaFrames:FlashBarFrame(frame)
	if not self.bFramesAreFlashing and self.bCombatState and self.bFramesCanFlash then
		local sprite = self:GetFrameType("flashframe")
		frame:FindChild("HealthFrame"):SetSprite(sprite)
		frame:FindChild("ShieldFrame"):SetSprite(sprite)
		frame:FindChild("AbsorbFrame"):SetSprite(sprite)
		frame:FindChild("HealthFrame"):SetBGColor("ffffffff")
		frame:FindChild("ShieldFrame"):SetBGColor("ffffffff")
		frame:FindChild("AbsorbFrame"):SetBGColor("ffffffff")
		self.bFramesCanFlash = false
		self.bFramesAreFlashing = true 
	elseif 	self.bFramesAreFlashing and not self.bCombatState then
		local sprite = self:GetFrameType("normal")
		frame:FindChild("HealthFrame"):SetSprite(sprite)
		frame:FindChild("ShieldFrame"):SetSprite(sprite)
		frame:FindChild("AbsorbFrame"):SetSprite(sprite)
		frame:FindChild("HealthFrame"):SetBGColor(self.tSettings.sFrameColor)
		frame:FindChild("ShieldFrame"):SetBGColor(self.tSettings.sFrameColor)
		frame:FindChild("AbsorbFrame"):SetBGColor(self.tSettings.sFrameColor)

		self.bFramesCanFlash = true
		self.bFramesAreFlashing = false
	end
end


function KuronaFrames:DecayPlayerDamage()
	self:DecayDamage(1)
end


function KuronaFrames:DecayTargetDamage()
	self:DecayDamage(2)
end


function KuronaFrames:DecayDamage(frame)
	self.FrameAlias[frame]["DamageTaken"]:SetStyle("TransitionShowHide",true)
	self.FrameAlias[frame]["DamageTaken"]:Show(false)
	self.FrameAlias[frame]["ShieldDamageTaken"]:SetStyle("TransitionShowHide",true)
	self.FrameAlias[frame]["ShieldDamageTaken"]:Show(false)
	self.FrameAlias[frame]["AbsorbDamageTaken"]:SetStyle("TransitionShowHide",true)
	self.FrameAlias[frame]["AbsorbDamageTaken"]:Show(false)
end


function KuronaFrames:DoDamageTicks(frame,parentwidth,difference,start,DT, DTF,newnumber)
	if frame == 2 and self.tSettings.bMirroredTargetFrame then return end
	
	local newWidth = parentwidth - (difference * parentwidth)

	if newWidth < 1 and difference ~= 1 then return end

	DT:SetStyle("TransitionShowHide",false)

	if not DT:IsShown() then
		DT:Show(true)
	end

	local bars = {
	[1] = "KuronaSprites:DamagedBar",
	[2] = "KuronaSprites:AniDamaged",			
	[3] = "KuronaSprites:AniDamaged",			
	[4] = "KuronaSprites:AniDamaged",			
	}
	--Print(self.tSettings.nBarOpacity*0.01)
	DT:SetSprite(bars[self.tSettings.nStyle])
	DT:SetAnchorOffsets(-start,1,parentwidth+newWidth-3,-1)
	DTF:SetAnchorOffsets(start+3,3,(-newWidth)-4,-3)
	local Alpha = string.format("%02x",(self.tSettings.nBarOpacity)*2.55)
	DT:SetBGColor(Alpha.."ffffff")
	
	if frame == 1 then
		self.newtimer1 = ApolloTimer.Create(1, false, "DecayPlayerDamage", self)
	else
		self.newtimer2 = ApolloTimer.Create(0.50, false, "DecayTargetDamage", self)
	end
end


function KuronaFrames:FillOptionsWindow()
	self.PopUp:FindChild("Title"):SetText("KuronaFrames v" .. self.Version)
	self.PopUp:FindChild("ToTButton"):SetCheck(self.tSettings.bShowToT)
	self.PopUp:FindChild("MirroredFrameButton"):SetCheck(self.tSettings.bMirroredTargetFrame)
	self.PopUp:FindChild("ToTDebuffsButton"):SetCheck(self.tSettings.bShowToTDebuffs)
--	self.PopUp:FindChild("ToTHPButton"):SetCheck(self.tSettings.bShowToTHP)
	self.PopUp:FindChild("CastBarButton"):SetCheck(self.tSettings.bShowCastBar)
	self.PopUp:FindChild("ShowClassIconsButton"):SetCheck(self.tSettings.bShowClassIcons)
	self.PopUp:FindChild("PercentagesButton"):SetCheck(self.tSettings.bUsePercentages)
	self.PopUp:FindChild("AutoHideFrameButton"):SetCheck(self.tSettings.bAutoHideFrame)
	self.PopUp:FindChild("AutoHideNameButton"):SetCheck(self.tSettings.bAutoHideName)
	self.PopUp:FindChild("ShowThreatMeterButton"):SetCheck(self.tSettings.bShowThreatMeter)
	self.PopUp:FindChild("SmoothCastBarButton"):SetCheck(self.tSettings.bSmoothCastBar)
	self.PopUp:FindChild("ShowFocusBuffsButton"):SetCheck(self.tSettings.bShowFocusBuffs)
	self.PopUp:FindChild("ShowSpellIcon"):SetCheck(self.tSettings.bShowSpellIcon)
	self.PopUp:FindChild("ShowResourcesButton"):SetCheck(self.tSettings.bShowResources)
	self.PopUp:FindChild("ShowCarbineResourcesButton"):SetCheck(self.tSettings.bShowCarbineResources)
	self.PopUp:FindChild("DisplayFocusButton"):SetCheck(self.tSettings.bDisplayFocus)
	self.PopUp:FindChild("ShowSpellTimeIcon"):SetCheck(self.tSettings.bShowSpellTimeIcon)
	self.PopUp:FindChild("ShowLevels"):SetCheck(self.tSettings.bShowLevels)
	self.PopUp:FindChild("DisableEatAway"):SetCheck(self.tSettings.bDisableEatAway)
	self.PopUp:FindChild("ShowMountInfo"):SetCheck(self.tSettings.bShowMountInfo)
	self.PopUp:FindChild("BarAlphaSliderBar"):SetValue(self.tSettings.nBarOpacity)
	self.PopUp:FindChild("BAValue"):SetText(self.tSettings.nBarOpacity.."%")
	self.PopUp:FindChild("CastbarAlphaSliderBar"):SetValue(self.tSettings.nCastbarOpacity)
	self.PopUp:FindChild("CastbAValue"):SetText(self.tSettings.nCastbarOpacity.."%")
	self.PopUp:FindChild("ShowFrameBorders"):SetCheck(self.tSettings.bShowFrameBorders)
	self.PopUp:FindChild("ValueAndPercentageButton"):SetCheck(self.tSettings.bValueAndPercentage)
	self.PopUp:FindChild("EnableSprintButton"):SetCheck(self.tSettings.bEnableSprint)
	self.PopUp:FindChild("VerticalSprintButton"):SetCheck(self.tSettings.bVerticalSprint)
	self.PopUp:FindChild("AutoHideSprintButton"):SetCheck(self.tSettings.bAutoHideSprint)
	self.PopUp:FindChild("InterruptableCastButton"):SetCheck(self.tSettings.bFlashInterrupt)
	self.PopUp:FindChild("ShowPetFrameButton"):SetCheck(self.tSettings.bShowPetFrame)
	self.PopUp:FindChild("ShowClusterFrameButton"):SetCheck(self.tSettings.bShowClusterFrame)
	self.PopUp:FindChild("ShowFirstNames"):SetCheck(self.tSettings.bFirstNamesOnly)
	self.PopUp:FindChild("FocusPercentageButton"):SetCheck(self.tSettings.bFocusAsPercent)
	self.PopUp:FindChild("DisableBuffBarsButton"):SetCheck(not self.tSettings.bShowBuffBars)
	self.PopUp:FindChild("RememberFocus"):SetCheck(self.tSettings.bMatchFocus)
	self.PopUp:FindChild("AutoHideResourceButton"):SetCheck(self.tSettings.bAutoHideResources)
	self.PopUp:FindChild("UseGenericResources"):SetCheck(self.tSettings.bUseGenericResources)
	self.PopUp:FindChild("HazardMeterButton"):SetCheck(self.tSettings.bShowHazard)
	self.PopUp:FindChild("PercentDecimals"):SetCheck(self.tSettings.bPercentDecimals)
	
	self.PopUp:FindChild("TargetLineButton"):SetCheck(self.tSettings.bLineToTarget)
	self.PopUp:FindChild("FocusLineButton"):SetCheck(self.tSettings.bLineToFocus)
	self.PopUp:FindChild("SubdueLineButton"):SetCheck(self.tSettings.bLineToSubdue)
	self.PopUp:FindChild("EnableOutlineButton"):SetCheck(self.tSettings.bLineOutlines)
	self.PopUp:FindChild("LineDistancesButton"):SetCheck(self.tSettings.bLineDistances)
	--Line Thickness
	self.PopUp:FindChild("LineThicknessSliderBar"):SetValue(self.tSettings.nLineThickness)
	self.PopUp:FindChild("LineThicknessValue"):SetText(self.tSettings.nLineThickness.."px")

	
	--Alert Window
	self.PopUp:FindChild("AlertWindowButton"):SetCheck(self.tSettings.bAlertWindow)
	self.PopUp:FindChild("CCAlertWindowButton"):SetCheck(self.tSettings.bCCAlertWindow)
	self.PopUp:FindChild("AlertSoundButton"):SetCheck(self.tSettings.bAlertSound)
	self.PopUp:FindChild("CCAlertNamesButton"):SetCheck(self.tSettings.bAlertNames)

	self.AlertWindowEditBox:SetText(self.tSettings.AlertList)
	self.AlertWindowEditBox:SetSel(999999,999999)
	self.ProxIgnoreEditBox:SetText(self.tSettings.ProximityIgnore)
	self.ProxIgnoreEditBox:SetSel(999999,999999)

	self.AlertListTable = self.tSettings.AlertList:split("\n")
	self.ProximityIgnoreTable = self.tSettings.ProximityIgnore:split("\n")
	
	
	self.PopUp:FindChild("ProxGroupRangeSliderBar"):SetValue(self.tSettings.nProxRangeGroup)
	self.PopUp:FindChild("ProxGroupRangeValue"):SetText(self.tSettings.nProxRangeGroup.."m")

	self.PopUp:FindChild("ProxSoloRangeSliderBar"):SetValue(self.tSettings.nProxRangeSolo)
	self.PopUp:FindChild("ProxSoloRangeValue"):SetText(self.tSettings.nProxRangeSolo.."m")
	
	
	self.PopUp:FindChild("ProximityCastButton"):SetCheck(self.tSettings.bProxmityCast)
	
	--Buff toggle Groups
	self.PopUp:FindChild("PlayerBuffsAlignR"):SetCheck(self.tSettings.PlayerBuffRight)
	self.PopUp:FindChild("TargetBuffsAlignR"):SetCheck(self.tSettings.TargetBuffRight)
	self.PopUp:FindChild("FocusBuffsAlignR"):SetCheck(self.tSettings.FocusBuffRight)

		
	self.PopUp:FindChild("ShieldWidthSliderBar"):SetValue(self.tSettings.nShieldWidth*100)
	self.PopUp:FindChild("AbsorbWidthSliderBar"):SetValue(self.tSettings.nAbsorbWidth*100)
	self.PopUp:FindChild("ShieldWidthValue"):SetText(self.tSettings.nShieldWidth * 100 .."%")
	self.PopUp:FindChild("AbsorbWidthValue"):SetText(self.tSettings.nAbsorbWidth * 100 .."%")
	self.frameResizeNeeded = true
	
	
	
	if self.player:GetClassId() == 3 then
		self.PopUp:FindChild("TAOpacitySliderBar"):SetValue(self.tSettings.bEsperTAOpacity)
		self.MindBurstAlpha = string.format("%02x",self.tSettings.bEsperTAOpacity*2.55)
		self.PopUp:FindChild("EsperTAButton"):SetCheck(self.tSettings.bEsperTA or  false)
		self.PopUp:FindChild("EsperShowPsiPointsButton"):SetCheck(self.tSettings.bShowPsiPoints or true)
		self.PopUp:FindChild("EsperTrackChargesButton"):SetCheck(self.tSettings.bTrackCharges or  false)
		self.PopUp:FindChild("EsperTrackMentalOverflowButton"):SetCheck(self.tSettings.bTrackMentalOverflow or false)
		self.PopUp:FindChild("TAOpacityValue"):SetText(self.tSettings.bEsperTAOpacity)
	elseif self.player:GetClassId() == GameLib.CodeEnumClass.Spellslinger then
		self.PopUp:FindChild("SpellPowerButton"):SetCheck(self.tSettings.bShowSpellPower or  false)
	elseif self.player:GetClassId() == GameLib.CodeEnumClass.Stalker then
		self.PopUp:FindChild("StalkerTAButton"):SetCheck(self.tSettings.bStalkerTA or  false)
	end
	
	self:SetOptionColorPanel()
	self:BuffBarVisibility()
	self:SetupComboBoxes()
end


function KuronaFrames:HelperBuildTooltip(strBody, strTitle, crTitleColor)
	if strBody == nil then return end
	local strTooltip = string.format("<T Font=\"CRB_InterfaceMedium\" TextColor=\"%s\">%s</T>", kstrTooltipBodyColor, strBody)
	if strTitle ~= nil then -- if a title has been passed, add it (optional)
		strTooltip = string.format("<P>%s</P>", strTooltip)
		local strTitle = string.format("<P Font=\"CRB_InterfaceMedium_B\" TextColor=\"%s\">%s</P>", crTitleColor or kstrTooltipTitleColor, strTitle)
		strTooltip = strTitle .. strTooltip
	end
	return strTooltip
end


--- Color Picking Stuff
function KuronaFrames:OnColorPick( wndHandler, wndControl, eMouseButton, nLastRelativeMouseX, nLastRelativeMouseY, bDoubleClick, bStopPropagation )
	local defaultColor = self:ColorToStr(wndControl:GetBGColor())

	if self.picker then
		self.picker:Destroy()
		self.picker = nil
	end
	
	tCallback = {}
	tCallback.callback = "SetBGColor"
	tCallback.bAlpha = true
	tCallback.bCustomColor = true
	tCallback.strInitialColor = defaultColor
	if GColor == nil then
		GColor = Apollo.GetPackage("KF-GeminiColor").tPackage
	end

	self.picker = GColor:CreateColorPicker(self, tCallback, true, defaultColor,wndControl)
	self:MoveColorPicker()
end


function KuronaFrames:MoveColorPicker()
	if self.picker ~= nil then
		local pHeight = self.picker:GetHeight()
		local pWidth =self.picker:GetWidth()
		local l,t,r,b = self.PopUp:GetAnchorOffsets()
		local popWidth = self.PopUp:GetWidth()
		self.picker:SetAnchorPoints(0,0,0,0)
		self.picker:SetAnchorOffsets(r-30,t+120,r+pWidth-30,t+pHeight+120)
	end
end


function KuronaFrames:ColorToStr(ColorData)
	local crColor = ColorData:ToTable()
		if GColor == nil then
			GColor = Apollo.GetPackage("KF-GeminiColor").tPackage
		end
	
	local strColorCode = GColor:RGBAPercToHex(crColor.r, crColor.g, crColor.b, crColor.a)
	return strColorCode
end


function KuronaFrames:GetColorFromOptionPanel()
	local ColorOptions = self.PopUp:FindChild("ColorOptions")
	self.tSettings.FCastColor = self:ColorToStr(ColorOptions:FindChild("FriendlyCastbarColor"):GetBGColor())
	self.tSettings.NCastColor = self:ColorToStr(ColorOptions:FindChild("NeutralCastbarColor"):GetBGColor())
	self.tSettings.HCastColor = self:ColorToStr(ColorOptions:FindChild("HostileCastbarColor"):GetBGColor())
	self.tSettings.ICastColor = self:ColorToStr(ColorOptions:FindChild("InterruptableCastbarColor"):GetBGColor())
	self.tSettings.FNameColor = self:ColorToStr(ColorOptions:FindChild("FriendlyNametagColor"):GetBGColor())
	self.tSettings.NNameColor =self:ColorToStr(ColorOptions:FindChild("NeutralNametagColor"):GetBGColor())
	self.tSettings.HNameColor =self:ColorToStr(ColorOptions:FindChild("HostileNametagColor"):GetBGColor())
	self.tSettings.HCSquareColor = self:ColorToStr(ColorOptions:FindChild("HealthColorSquare"):GetBGColor())
	self.tSettings.SCSquareColor = self:ColorToStr(ColorOptions:FindChild("ShieldColorSquare"):GetBGColor())
	self.tSettings.ACSquareColor = self:ColorToStr(ColorOptions:FindChild("AbsorbColorSquare"):GetBGColor())
	self.tSettings.woundSquareColor = self:ColorToStr(ColorOptions:FindChild("WoundedColorSquare"):GetBGColor())
	self.tSettings.criticalSquareColor = self:ColorToStr(ColorOptions:FindChild("CriticalColorSquare"):GetBGColor())
	self.tSettings.BGSquareColor = self:ColorToStr(ColorOptions:FindChild("BGColorSquare"):GetBGColor())
	self.tSettings.sFrameColor = self:ColorToStr(ColorOptions:FindChild("FrameColorSquare"):GetBGColor())
	self.tSettings.DashSquareColor = self:ColorToStr(self.PopUp:FindChild("DashSquareColor"):GetBGColor())
	self.tSettings.SprintSquareColor = self:ColorToStr(self.PopUp:FindChild("SprintSquareColor"):GetBGColor())
	self.tSettings.FLineColor = self:ColorToStr(self.PopUp:FindChild("FocusLineColor"):GetBGColor())
	self.tSettings.TLineColor = self:ColorToStr(self.PopUp:FindChild("TargetLineColor"):GetBGColor())
	self.tSettings.SLineColor = self:ColorToStr(self.PopUp:FindChild("SubdueLineColor"):GetBGColor())
	self.tSettings.AlertColor = self:ColorToStr(self.PopUp:FindChild("AlertColor"):GetBGColor())
	self.tSettings.BasicResourceColor = self:ColorToStr(self.PopUp:FindChild("BasicResourceColor"):GetBGColor())
		
	
	if self.player:GetClassId() == GameLib.CodeEnumClass.Engineer then
		self.tSettings.InTheZoneColor = self:ColorToStr(self.PopUp:FindChild("InTheZoneColor"):GetBGColor())
	end
	if self.player:GetClassId() == GameLib.CodeEnumClass.Stalker then
		self.tSettings.ImpaleColor = self:ColorToStr(self.PopUp:FindChild("ImpaleColor"):GetBGColor())
	end
	if (self.player:GetClassId() == GameLib.CodeEnumClass.Esper or self.player:GetClassId() == GameLib.CodeEnumClass.Spellslinger) and not self.tSettings.bUseGenericResources then
		self.tSettings.AuxCastColor = self:ColorToStr(self.PopUp:FindChild("AuxCastColor"):GetBGColor())
	end
end


function KuronaFrames:SetOptionColorPanel()
	local ColorOptions = self.PopUp
	local colorBars = {
	FriendlyCastbarColor = self.tSettings.FCastColor,
	NeutralCastbarColor = self.tSettings.NCastColor,
	HostileCastbarColor = self.tSettings.HCastColor,
	InterruptableCastbarColor = self.tSettings.ICastColor,
	FriendlyNametagColor = self.tSettings.FNameColor,
	NeutralNametagColor = self.tSettings.NNameColor,
	HostileNametagColor = self.tSettings.HNameColor,

	HealthColorSquare = self.tSettings.HCSquareColor,
	ShieldColorSquare = self.tSettings.SCSquareColor,
	AbsorbColorSquare = self.tSettings.ACSquareColor,
	CriticalColorSquare = self.tSettings.criticalSquareColor,
	WoundedColorSquare = self.tSettings.woundSquareColor,
	FrameColorSquare = self.tSettings.sFrameColor,
	SprintSquareColor = self.tSettings.SprintSquareColor,
	DashSquareColor = self.tSettings.DashSquareColor,
	BGColorSquare = self.tSettings.BGSquareColor,
	TargetLineColor = self.tSettings.TLineColor,
	FocusLineColor = self.tSettings.FLineColor,
	SubdueLineColor = self.tSettings.SLineColor,
	AlertColor = self.tSettings.AlertColor,
	BasicResourceColor =  self.tSettings.BasicResourceColor
	}
	local class = self.player:GetClassId()
	if class == GameLib.CodeEnumClass.Engineer  and not self.tSettings.bUseGenericResources then
		colorBars["InTheZoneColor"] = self.tSettings.InTheZoneColor
	elseif  class == GameLib.CodeEnumClass.Stalker then
		colorBars["ImpaleColor"] = self.tSettings.ImpaleColor
	elseif (class == GameLib.CodeEnumClass.Esper or class == GameLib.CodeEnumClass.Spellslinger) and not self.tSettings.bUseGenericResources then
		colorBars["AuxCastColor"] = self.tSettings.AuxCastColor
		self.MiniCastBar:SetBarColor(self.tSettings.AuxCastColor)
	end
	
	for k,v in pairs(colorBars) do
		ColorOptions:FindChild(k):SetBGColor(v)
	end
	
	self:ColorFrameObjects()
	
end


function KuronaFrames:SetBGColor(strColor, ...)
	arg[3]:SetBGColor(strColor)
	self:ColorFrameObjects()
end


function KuronaFrames:SetBarColor(strColor, ...)
	arg[1]:SetBarColor(strColor)
end


function KuronaFrames:ColorFrameObjects()
	self:GetColorFromOptionPanel()
	for i = 1,3 do
		self.FrameAlias[i]["UnitName"]:SetTextColor(self.tSettings.FNameColor)
		self.FrameAlias[i]["HealthProgressBar"]:SetBarColor(self.tSettings.HCSquareColor)
		self.FrameAlias[i]["ShieldProgressBar"]:SetBarColor(self.tSettings.SCSquareColor)
		self.FrameAlias[i]["AbsorbProgressBar"]:SetBarColor(self.tSettings.ACSquareColor)
		self.FrameAlias[i]["HealthProgressBar"]:SetBGColor(self.tSettings.BGSquareColor)
		self.FrameAlias[i]["ShieldProgressBar"]:SetBGColor(self.tSettings.BGSquareColor)
		self.FrameAlias[i]["AbsorbProgressBar"]:SetBGColor(self.tSettings.BGSquareColor)
		self.FrameAlias[i]["CastBar"]:SetBGColor(self.tSettings.BGSquareColor)
	end
	--self.HazardMeter:SetBGColor(self.tSettings.BGSquareColor)
	self.FrameAlias[1].ChargeBar:SetBGColor(self.tSettings.BGSquareColor)
	self.FrameAlias[1].ChargeBar:SetBarColor(self.tSettings.FCastColor)
	local petframe = self.playerFrame:FindChild("PetFrame")
	for i = 1, 2 do
		petframe:GetChildren()[i]:FindChild("MiniHealthProgressBar"):SetBarColor(self.tSettings.HCSquareColor)
		petframe:GetChildren()[i]:FindChild("MiniShieldProgressBar"):SetBarColor(self.tSettings.SCSquareColor)
		petframe:GetChildren()[i]:FindChild("MiniHealthProgressBar"):SetBGColor(self.tSettings.BGSquareColor)
		petframe:GetChildren()[i]:FindChild("MiniShieldProgressBar"):SetBGColor(self.tSettings.BGSquareColor)
	end
	local clusterframe = self.targetFrame:FindChild("PetFrame")
	for i = 1, 2 do
		clusterframe:GetChildren()[i]:FindChild("MiniHealthProgressBar"):SetBarColor(self.tSettings.HCSquareColor)
		clusterframe:GetChildren()[i]:FindChild("MiniShieldProgressBar"):SetBarColor(self.tSettings.SCSquareColor)
		clusterframe:GetChildren()[i]:FindChild("MiniHealthProgressBar"):SetBGColor(self.tSettings.BGSquareColor)
		clusterframe:GetChildren()[i]:FindChild("MiniShieldProgressBar"):SetBGColor(self.tSettings.BGSquareColor)
	end
	
	for i = 2,3 do
		self.FrameAlias[i].MiniHealthProgressBar:SetBarColor(self.tSettings.HCSquareColor)
		self.FrameAlias[i].MiniShieldProgressBar:SetBarColor(self.tSettings.SCSquareColor)
		self.FrameAlias[i].MiniAbsorbProgressBar:SetBarColor(self.tSettings.ACSquareColor)
	end	
	
	self.AlertWindow:SetBGColor(self.tSettings.AlertColor)
	
	--Sprint meter
	self.SprintMeter.DashProgressBar1:SetBarColor(self.tSettings.DashSquareColor)
	self.SprintMeter.DashProgressBar2:SetBarColor(self.tSettings.DashSquareColor)
	self.SprintMeter.ProgressBar:SetBarColor(self.tSettings.SprintSquareColor)
	self.SprintMeter.DashProgressBar1:SetBGColor(self.tSettings.BGSquareColor)
	self.SprintMeter.DashProgressBar2:SetBGColor(self.tSettings.BGSquareColor)
	self.SprintMeter.ProgressBar:SetBGColor(self.tSettings.BGSquareColor)
	
	self.karDispositionColors =
	{
		[Unit.CodeEnumDisposition.Neutral]  = self.tSettings.NNameColor,
		[Unit.CodeEnumDisposition.Hostile]  = self.tSettings.HNameColor,
		[Unit.CodeEnumDisposition.Friendly] = self.tSettings.FNameColor,
	}

	self.karCastbarDispositionColors =
	{
		[Unit.CodeEnumDisposition.Neutral]  = self.tSettings.NCastColor,
		[Unit.CodeEnumDisposition.Hostile]  = self.tSettings.HCastColor,
		[Unit.CodeEnumDisposition.Friendly] = self.tSettings.FCastColor,
	}
		if (self.player:GetClassId() == GameLib.CodeEnumClass.Esper or self.player:GetClassId() == GameLib.CodeEnumClass.Spellslinger) and not self.tSettings.bUseGenericResources then
			self.MiniCastBar:SetBarColor(self.tSettings.AuxCastColor)
		end

	if self.player:GetClassId() == GameLib.CodeEnumClass.Spellslinger  and self.Resources:GetName() =="SpellslingerResourcesForm" then
		for i = 1, 4 do
			self.SSList[i]:FindChild("Frame"):SetBGColor(self.tSettings.sFrameColor)
			self.SSList[i]:FindChild("ProgressBar"..i):SetFillSprite(normal)
			self.SSList[i]:FindChild("ProgressBar"..i):SetFullSprite(normal)
		end		
	end
	
	if self.FocusBar then
		self.FocusBarMeter:SetFillSprite(normal)
		self.FocusBarMeter:SetBarColor(self.tSettings.SCSquareColor)
	end
	
	
	if 	self.tSettings.bUseGenericResources and self.Resources:GetName() == "GenericResourcesForm" then
		self.Resources:FindChild("GResourceBar"):SetBarColor(self.tSettings.BasicResourceColor)
	end

	self:FillAllFrames()
	self:HideFrameBorders(self.playerFrame,self.tSettings.bShowFrameBorders)
	self:HideFrameBorders(self.targetFrame,self.tSettings.bShowFrameBorders)
	self:HideFrameBorders(self.focusFrame,self.tSettings.bShowFrameBorders)
	self:HideFrameBorders(self.sprint,self.tSettings.bShowFrameBorders)
	
	self:HideFrameBorders(self.AlertWindow,self.tSettings.bShowFrameBorders)
	self:HideFrameBorders(self.HazardBar,self.tSettings.bShowFrameBorders)
	self:HideFrameBorders(self.ProximityCastForm,self.tSettings.bShowFrameBorders)
--	self:ChangeFrameBorders(2)	
end


function KuronaFrames:HideFrameBorders(parent,action)
	for nIndex, child in ipairs(parent:GetChildren()) do
		if #child:GetChildren() > 0 then 
			self:HideFrameBorders(child,action)
		end
		local sprite = child:GetSprite()
		if sprite == "Frame2" or sprite == "FlashFrame2" then
			child:SetStyle("Picture", action)
			child:SetBGColor(self.tSettings.sFrameColor)
		elseif sprite == "SquareFrame" then
			child:SetStyle("Picture", action)
			child:SetBGColor(self.tSettings.sFrameColor)
		elseif sprite == "SquareWarriorFlashFrame" then
			child:SetStyle("Picture", action)		
		end
	end
end

function KuronaFrames:ChangeFrameBorders(style)
	local normal = self:GetBarType("normal")
	self.tSettings.nStyle = style
	self:SwapFrameBorders(self.playerFrame,self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.targetFrame,self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.focusFrame,self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.sprint,self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.dashes,self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.HazardBar,self.tSettings.bShowFrameBorders,style)
--	self:SwapFrameBorders(self.Resources,self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.PopUp:FindChild("ColorOptions"),self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.FrameAlias[1].PetFrame,self.tSettings.bShowFrameBorders,self.tSettings.nStyle)
	self:SwapFrameBorders(self.FrameAlias[2].ClusterFrame,self.tSettings.bShowFrameBorders,self.tSettings.nStyle)
--	self:SwapFrameBorders(self.FrameAlias[2]["PlayerThreatProgressBar"],self.tSettings.bShowFrameBorders,self.tSettings.nStyle)
	

	self:SwapFrameBorders(self.ProximityCastForm,self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.AlertWindow,self.tSettings.bShowFrameBorders,style)
	self:SwapFrameBorders(self.HazardBar,self.tSettings.bShowFrameBorders,style)
	self.HazardMeter:SetFillSprite(normal)
	self.HazardMeter:SetEmptySprite(normal)
	--self.HazardMeter:SetFullSprite(normal)
	
	for i=1,3 do
		self.FrameAlias[i]["HealthProgressBar"]:SetFillSprite(normal)
		self.FrameAlias[i]["ShieldProgressBar"]:SetFillSprite(normal)
		self.FrameAlias[i]["AbsorbProgressBar"]:SetFillSprite(normal)
		self.FrameAlias[i]["HealthProgressBar"]:SetFullSprite(normal)
		self.FrameAlias[i]["ShieldProgressBar"]:SetFullSprite(normal)
		self.FrameAlias[i]["AbsorbProgressBar"]:SetFullSprite(normal)
		self.FrameAlias[i]["HealthProgressBar"]:SetEmptySprite(normal)
		self.FrameAlias[i]["ShieldProgressBar"]:SetEmptySprite(normal)
		self.FrameAlias[i]["AbsorbProgressBar"]:SetEmptySprite(normal)
		self.FrameAlias[i]["CastBar"]:SetEmptySprite(self:GetCastBarType("normal",i))
		self.FrameAlias[i]["CastBar"]:SetFillSprite(self:GetCastBarType("normal",i))		
		self.FrameAlias[i]["CastBar"]:SetFullSprite(self:GetCastBarType("normal",i))		
	end
	
	if self.MiniCastBar then
		self.MiniCastBar:SetFillSprite(normal)
	end
	self.FrameAlias[2]["PlayerThreatProgressBar"]:SetFillSprite(normal)
	self.FrameAlias[2]["PlayerThreatProgressBar"]:SetFullSprite(self:GetBarType("police"))
	
	for i =1, 2 do
	self.ProximityCast.Bars[i]:SetFullSprite(self:GetCastBarType("normal",frame))
	self.ProximityCast.Bars[i]:SetFillSprite(self:GetCastBarType("normal",frame))

	self.FrameAlias[1].PetFrame:GetChildren()[i]:FindChild("MiniHealthProgressBar"):SetFillSprite(normal)
	self.FrameAlias[1].PetFrame:GetChildren()[i]:FindChild("MiniShieldProgressBar"):SetFullSprite(normal)
	self.FrameAlias[1].PetFrame:GetChildren()[i]:FindChild("MiniShieldProgressBar"):SetFillSprite(normal)
	self.FrameAlias[1].PetFrame:GetChildren()[i]:FindChild("MiniHealthProgressBar"):SetFullSprite(normal)
	self.FrameAlias[2].ClusterFrame:GetChildren()[i]:FindChild("MiniHealthProgressBar"):SetFillSprite(normal)
	self.FrameAlias[2].ClusterFrame:GetChildren()[i]:FindChild("MiniShieldProgressBar"):SetFullSprite(normal)
	self.FrameAlias[2].ClusterFrame:GetChildren()[i]:FindChild("MiniShieldProgressBar"):SetFillSprite(normal)
	self.FrameAlias[2].ClusterFrame:GetChildren()[i]:FindChild("MiniHealthProgressBar"):SetFullSprite(normal)
	self.FrameAlias[i+1]["ToTWindow"]:FindChild("MiniHealthProgressBar"):SetFullSprite(normal)
	self.FrameAlias[i+1]["ToTWindow"]:FindChild("MiniShieldProgressBar"):SetFullSprite(normal)
	self.FrameAlias[i+1]["ToTWindow"]:FindChild("MiniAbsorbProgressBar"):SetFullSprite(normal)
	self.FrameAlias[i+1]["ToTWindow"]:FindChild("MiniHealthProgressBar"):SetFillSprite(normal)
	self.FrameAlias[i+1]["ToTWindow"]:FindChild("MiniShieldProgressBar"):SetFillSprite(normal)
	self.FrameAlias[i+1]["ToTWindow"]:FindChild("MiniAbsorbProgressBar"):SetFillSprite(normal)
	end
	
	--Charge Meter
	self.FrameAlias[1]["ChargeBar"]:SetEmptySprite(self:GetCastBarType("normal"))		
	self.FrameAlias[1]["ChargeBar"]:SetFullSprite(self:GetCastBarType("flash"))		
	self.FrameAlias[1]["ChargeBar"]:SetFillSprite(self:GetCastBarType("normal"))		
	

	--Threat
	self.FrameAlias[2]["PlayerThreatProgressBar"]:SetFullSprite(self:GetBarType("police"))
	--Resources	
--	self.Resources.ProgressBar:SetFillSprite(normal)
--	self.SprintMeter.ProgressBar:SetFullSprite(normal)

	if 	self.tSettings.bUseGenericResources  then
		self.Resources:FindChild("GResourceBar"):SetFillSprite(normal)
		self.Resources:FindChild("GResourceBar"):SetFullSprite(normal)
	end
	if self.player:GetClassId() == GameLib.CodeEnumClass.Spellslinger  and self.Resources:GetName() =="SpellslingerResourcesForm" then
		for i = 1, 4 do
			self.SSList[i]:FindChild("Frame"):SetBGColor(self.tSettings.sFrameColor)
			self.SSList[i]:FindChild("ProgressBar"..i):SetFillSprite(normal)
			self.SSList[i]:FindChild("ProgressBar"..i):SetFullSprite(normal)
		end		
	elseif self.player:GetClassId() == GameLib.CodeEnumClass.Engineer  and self.Resources:GetName() =="EngineerResourcesForm" then
		self.FrameAlias["vBar1"] = self.Resources:FindChild("VolatilityBar1")
		self.FrameAlias["vBar2"] = self.Resources:FindChild("VolatilityBar2")
		self.FrameAlias["vBar3"] = self.Resources:FindChild("VolatilityBar3")
	
		for i = 1, 3 do
			self.FrameAlias["vBar"..i]:SetFillSprite(normal)
			self.FrameAlias["vBar"..i]:SetFullSprite(normal)
		end		
	elseif self.player:GetClassId() == GameLib.CodeEnumClass.Esper  and self.Resources:GetName() =="EsperResourcesForm" then
		for i = 1, 5 do
			self.PPList[i]:SetSprite(normal)
		end		
	elseif self.player:GetClassId() == GameLib.CodeEnumClass.Warrior  and self.Resources:GetName() =="WarriorResourcesForm" then
		self.kBar:SetFullSprite(self:GetBarType("flashB"))
		self.kBar:SetFillSprite(normal)
	elseif self.player:GetClassId() == GameLib.CodeEnumClass.Stalker  and self.Resources:GetName() =="StalkerResourcesForm" then
		self.sBar:SetFullSprite(normal)
		self.sBar:SetFillSprite(normal)
	elseif self.player:GetClassId() == GameLib.CodeEnumClass.Medic  and self.Resources:GetName() =="MedicResourcesForm" then
		for i = 1, 4 do 
			self.ActuatorList[i]:SetSprite(normal)
		end
	end
	if self.FocusBar then
		self.FocusBarMeter:SetFillSprite(normal)
		self.FocusBarMeter:SetFullSprite(normal)
	end

	--Sprint
	self.SprintMeter.ProgressBar:SetFillSprite(self:GetCastBarType("normal"))
	self.SprintMeter.ProgressBar:SetFullSprite(self:GetCastBarType("normal"))
	self.SprintMeter.ProgressBar:SetEmptySprite(self:GetCastBarType("normal"))
	self.SprintMeter.DashProgressBar1:SetEmptySprite(self:GetCastBarType("normal"))
	self.SprintMeter.DashProgressBar1:SetFullSprite(self:GetCastBarType("normal"))
	self.SprintMeter.DashProgressBar1:SetFillSprite(self:GetCastBarType("normal"))
	self.SprintMeter.DashProgressBar2:SetEmptySprite(self:GetCastBarType("normal"))
	self.SprintMeter.DashProgressBar2:SetFullSprite(self:GetCastBarType("normal"))
	self.SprintMeter.DashProgressBar2:SetFillSprite(self:GetCastBarType("normal"))
	-- Pet Frame
	for i=1,2 do
		local hbar = self.FrameAlias[1].PetFrame:GetChildren()[i]:FindChild("MiniHealthProgressBar")
		local sbar = self.FrameAlias[1].PetFrame:GetChildren()[i]:FindChild("MiniShieldProgressBar")
		
		hbar:SetEmptySprite(normal)
		hbar:SetFillSprite(normal)
		hbar:SetFullSprite(normal)

		sbar:SetEmptySprite(normal)
		sbar:SetFillSprite(normal)
		sbar:SetFullSprite(normal)
		
		local hbar = self.FrameAlias[2].ClusterFrame:GetChildren()[i]:FindChild("MiniHealthProgressBar")
		local sbar = self.FrameAlias[2].ClusterFrame:GetChildren()[i]:FindChild("MiniShieldProgressBar")
		hbar:SetEmptySprite(normal)
		hbar:SetFillSprite(normal)
		hbar:SetFullSprite(normal)

		sbar:SetEmptySprite(normal)
		sbar:SetFillSprite(normal)
		sbar:SetFullSprite(normal)
	end
end

function KuronaFrames:SwapFrameBorders(parent,action,style)
	for nIndex, child in ipairs(parent:GetChildren()) do
		if #child:GetChildren() > 0 then
			self:SwapFrameBorders(child,action,style)
		end
		local sprite = child:GetSprite()
		if style == 1 then
			if sprite == "SquareFrame" then
				child:SetSprite("KuronaSprites:Frame2", action)
				child:SetBGColor(self.tSettings.sFrameColor)
			end
		elseif style >= 2 then
			if sprite == "Frame2" or sprite == "FlashFrame2" then
				child:SetSprite("KuronaSprites:SquareFrame", action)
				child:SetBGColor(self.tSettings.sFrameColor)
			end
		end
	end
	
end


function KuronaFrames:FilterBuffbar(wndBuffBar)
	wndBuffBar:ArrangeChildrenHorz(0, 
		function(a, b) 
			local strTooltipA = a:GetBuffTooltip()
			local strTooltipB = b:GetBuffTooltip()
			
			-- Tooltip-less buffs encountered. Buff with tooltip wins the priority-check.
			if strTooltipA == nil or strTooltipA:len() <= 1 or strTooltipB == nil or strTooltipB:len() <= 1 then
				return strTooltipA ~= nil and strTooltipA:len() >= 1
			end
			
			local tStatusA = BuffFilter.tBuffStatusByTooltip[strTooltipA]
			local tStatusB = BuffFilter.tBuffStatusByTooltip[strTooltipB]
		
			local nPrioA = tStatusA and tStatusA.nPriority or ePriority.Unset
			local nPrioB = tStatusB and tStatusB.nPriority or ePriority.Unset

			return nPrioA < nPrioB
		end
	)
end

function KuronaFrames:OnComboBoxChanged( wndHandler, wndControl )
	local ptf = {
	[1] = "Player",
	[2] = "Target",
	[3] = "Focus"
	}
	for i = 1, 3 do
		self.tSettings[ptf[i].."BarFont"] = self.PopUp:FindChild(ptf[i].."BarComboBox"):GetSelectedText()
		self.tSettings[ptf[i].."CastBarFont"] = self.PopUp:FindChild(ptf[i].."CastBarComboBox"):GetSelectedText()
		self.tSettings[ptf[i].."NameFont"] = self.PopUp:FindChild(ptf[i].."NameComboBox"):GetSelectedText()
	end
	
	
	for i = 2, 3 do
		self.tSettings[ptf[i].."ToTNameFont"] = self.PopUp:FindChild(ptf[i].."ToTNameComboBox"):GetSelectedText()
		self.tSettings[ptf[i].."MiniBarFont"] = self.PopUp:FindChild(ptf[i].."ToTBarComboBox"):GetSelectedText()
	end
	self:HideComboBoxes(true)
	self.ComboBoxHide = false
	self:SetFonts()
end
function KuronaFrames:OnComboBoxClick( wndHandler, wndControl, eMouseButton, nLastRelativeMouseX, nLastRelativeMouseY, bDoubleClick, bStopPropagation )
	self:HideComboBoxes(self.ComboBoxHide)
	wndHandler:GetParent():Show(true,true)
	self.ComboBoxHide = not self.ComboBoxHide
end

function KuronaFrames:HideComboBoxes(state)
self.PopUp:FindChild("PlayerBarComboBox"):Show(state,true)
self.PopUp:FindChild("PlayerCastBarComboBox"):Show(state,true)
self.PopUp:FindChild("PlayerNameComboBox"):Show(state,true)
self.PopUp:FindChild("TargetBarComboBox"):Show(state,true)
self.PopUp:FindChild("TargetCastBarComboBox"):Show(state,true)
self.PopUp:FindChild("TargetNameComboBox"):Show(state,true)
self.PopUp:FindChild("FocusBarComboBox"):Show(state,true)
self.PopUp:FindChild("FocusCastBarComboBox"):Show(state,true)
self.PopUp:FindChild("FocusNameComboBox"):Show(state,true)
self.PopUp:FindChild("TargetToTNameComboBox"):Show(state,true)
self.PopUp:FindChild("TargetToTBarComboBox"):Show(state,true)
self.PopUp:FindChild("FocusToTNameComboBox"):Show(state,true)
self.PopUp:FindChild("FocusToTBarComboBox"):Show(state,true)
end

function KuronaFrames:SetupComboBoxes()
local PlayerBarComboBox = self.PopUp:FindChild("PlayerBarComboBox")
local PlayerCastBarComboBox = self.PopUp:FindChild("PlayerCastBarComboBox")
local PlayerNameComboBox = self.PopUp:FindChild("PlayerNameComboBox")
local TargetBarComboBox = self.PopUp:FindChild("TargetBarComboBox")
local TargetCastBarComboBox = self.PopUp:FindChild("TargetCastBarComboBox")
local TargetNameComboBox = self.PopUp:FindChild("TargetNameComboBox")
local FocusBarComboBox = self.PopUp:FindChild("FocusBarComboBox")
local FocusCastBarComboBox = self.PopUp:FindChild("FocusCastBarComboBox")
local FocusNameComboBox = self.PopUp:FindChild("FocusNameComboBox")
local TargetToTNameComboBox = self.PopUp:FindChild("TargetToTNameComboBox")
local TargetToTBarComboBox = self.PopUp:FindChild("TargetToTBarComboBox")
local FocusToTNameComboBox = self.PopUp:FindChild("FocusToTNameComboBox")
local FocusToTBarComboBox = self.PopUp:FindChild("FocusToTBarComboBox")

	--Missing Fonts
	
	local fontList = Apollo.GetGameFonts()
	local newfont = {}
	newfont.name = "CRB_InterfaceMedium_BBO"
	table.insert(fontList,1,newfont)
	local newfont = {}
	newfont.name = "Nameplates"
	table.insert(fontList,2,newfont)
	
	for _, font in pairs(fontList) do
		local x, j = string.find(font.name,"Alien")
		if x == nil then
			PlayerBarComboBox:AddItem(font.name)
			PlayerCastBarComboBox:AddItem(font.name)
			PlayerNameComboBox:AddItem(font.name)
			TargetBarComboBox:AddItem(font.name)
			TargetCastBarComboBox:AddItem(font.name)
			TargetNameComboBox:AddItem(font.name)
			FocusBarComboBox:AddItem(font.name)
			FocusCastBarComboBox:AddItem(font.name)
			FocusNameComboBox:AddItem(font.name)
			TargetToTNameComboBox:AddItem(font.name)
			TargetToTBarComboBox:AddItem(font.name)
			FocusToTNameComboBox:AddItem(font.name)
			FocusToTBarComboBox:AddItem(font.name)
		end
	end
	
	
		PlayerBarComboBox:SelectItemByText(self.tSettings.PlayerBarFont)
		PlayerCastBarComboBox:SelectItemByText(self.tSettings.PlayerCastBarFont)
		PlayerNameComboBox:SelectItemByText(self.tSettings.PlayerNameFont)
		TargetBarComboBox:SelectItemByText(self.tSettings.TargetBarFont)
		TargetCastBarComboBox:SelectItemByText(self.tSettings.TargetCastBarFont)
		TargetNameComboBox:SelectItemByText(self.tSettings.TargetNameFont)
		FocusBarComboBox:SelectItemByText(self.tSettings.FocusBarFont)
		FocusCastBarComboBox:SelectItemByText(self.tSettings.FocusCastBarFont)
		FocusNameComboBox:SelectItemByText(self.tSettings.FocusNameFont)
		TargetToTNameComboBox:SelectItemByText(self.tSettings.TargetToTNameFont)
		TargetToTBarComboBox:SelectItemByText(self.tSettings.TargetMiniBarFont)
		FocusToTNameComboBox:SelectItemByText(self.tSettings.FocusToTNameFont)
		FocusToTBarComboBox:SelectItemByText(self.tSettings.FocusMiniBarFont)
end

function KuronaFrames:SetFonts()
--[[
	self.PopUp:FindChild("BarFontExample"):SetFont(self.tSettings.BarFont)
	self.PopUp:FindChild("CastBarFontExample"):SetFont(self.tSettings.CastBarFont)
	self.PopUp:FindChild("NameFontExample"):SetFont(self.tSettings.NameFont)
	self.PopUp:FindChild("ToTNameFontExample"):SetFont(self.tSettings.ToTNameFont)
	self.PopUp:FindChild("ToTBarFontExample"):SetFont(self.tSettings.MiniBarFont)
]]
	local ptf = {
	[1] = "Player",
	[2] = "Target",
	[3] = "Focus"
	}

	for i = 1, 3 do
		self.FrameAlias[i]["HealthFrame"]:SetFont(self.tSettings[ptf[i].."BarFont"])
		self.FrameAlias[i]["ShieldFrame"]:SetFont(self.tSettings[ptf[i].."BarFont"])
		self.FrameAlias[i]["AbsorbFrame"]:SetFont(self.tSettings[ptf[i].."BarFont"])
		self.FrameAlias[i]["CastName"]:SetFont(self.tSettings[ptf[i].."CastBarFont"])
		self.FrameAlias[i]["UnitName"]:SetFont(self.tSettings[ptf[i].."NameFont"])
		self.FrameAlias[i]["SpellTime"]:SetFont(self.tSettings[ptf[i].."CastBarFont"])
	end

	for i = 2,3 do
		self.FrameAlias[i]["TargetName"]:SetFont(self.tSettings[ptf[i].."ToTNameFont"])
		self.FrameAlias[i]["MiniHealthFrame"]:SetFont(self.tSettings[ptf[i].."MiniBarFont"])
		self.FrameAlias[i]["MiniShieldFrame"]:SetFont(self.tSettings[ptf[i].."MiniBarFont"])
		self.FrameAlias[i]["MiniAbsorbFrame"]:SetFont(self.tSettings[ptf[i].."MiniBarFont"])
	end	
end

function KuronaFrames:ShowSoundPicker(name)

	if self.SoundPicker == nil then
		self:SetupSoundPicker(name)
	end
	
	if self.SoundPicker ~= nil then
		local pHeight = self.SoundPicker:GetHeight()
		local pWidth = self.SoundPicker:GetWidth()
		local l,t,r,b = self.PopUp:GetAnchorOffsets()
		local popWidth = self.PopUp:GetWidth()
		self.SoundPicker:SetAnchorPoints(0,0,0,0)
		self.SoundPicker:SetAnchorOffsets(r-30,t+120,r+pWidth-30,t+pHeight+120)
		self.SoundPicker:SetData(name)
	end
end

function KuronaFrames:CloseSoundPicker()
	local name = self.SoundPicker:GetData()
	if self.tSettings[name] then
		self.tSettings[name] = tonumber(self.SelectedSound:FindChild("Id"):GetText())
	end

	self.SoundPicker:Destroy()
	self.SoundPicker = nil
end

function KuronaFrames:ChooseNewSound( wndHandler, wndControl, eMouseButton )
	local name = wndHandler:GetName()
	
	if self.tSettings[name] then
		self:ShowSoundPicker(name)
	end
end