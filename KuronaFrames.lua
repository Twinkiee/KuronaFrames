-----------------------------------------------------------------------------------------------
-- Client Lua Script for KuronaFrames
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------

require "Window"
require "GameLib"
require "Apollo"
require "HazardsLib"


-----------------------------------------------------------------------------------------------
-- KuronaFrames Module Definition
-----------------------------------------------------------------------------------------------
local KuronaFrames = {}
local Major, Minor, Patch, Suffix = 3, 6, 3, 2
local Version = tonumber(Major .. "." .. Minor .. Patch)
local KuronaFrames_CURRENT_VERSION = string.format("%d.%d.%d", Major, Minor, Patch)

local ChangeLog = [[
3.30.2016
Updated API
]]


local karClassToIcon =
{
  [GameLib.CodeEnumClass.Warrior] = "IconSprites:Icon_Windows_UI_CRB_Warrior",
  [GameLib.CodeEnumClass.Engineer] = "IconSprites:Icon_Windows_UI_CRB_Engineer",
  [GameLib.CodeEnumClass.Esper] = "IconSprites:Icon_Windows_UI_CRB_Esper",
  [GameLib.CodeEnumClass.Medic] = "IconSprites:Icon_Windows_UI_CRB_Medic",
  [GameLib.CodeEnumClass.Stalker] = "IconSprites:Icon_Windows_UI_CRB_Stalker",
  [GameLib.CodeEnumClass.Spellslinger] = "IconSprites:Icon_Windows_UI_CRB_Spellslinger",
}


local kstrRaidMarkerToSprite =
{
  "Icon_Windows_UI_CRB_Marker_Bomb",
  "Icon_Windows_UI_CRB_Marker_Ghost",
  "Icon_Windows_UI_CRB_Marker_Mask",
  "Icon_Windows_UI_CRB_Marker_Octopus",
  "Icon_Windows_UI_CRB_Marker_Pig",
  "Icon_Windows_UI_CRB_Marker_Chicken",
  "Icon_Windows_UI_CRB_Marker_Toaster",
  "Icon_Windows_UI_CRB_Marker_UFO",
}

local ktRankDescriptions =
{
  [Unit.CodeEnumRank.Fodder] = { Apollo.GetString("TargetFrame_Fodder"), Apollo.GetString("TargetFrame_VeryWeak") },
  [Unit.CodeEnumRank.Minion] = { Apollo.GetString("TargetFrame_Minion"), Apollo.GetString("TargetFrame_Weak") },
  [Unit.CodeEnumRank.Standard] = { Apollo.GetString("TargetFrame_Grunt"), Apollo.GetString("TargetFrame_EasyAppend") },
  [Unit.CodeEnumRank.Champion] = { Apollo.GetString("TargetFrame_Challenger"), Apollo.GetString("TargetFrame_AlmostEqual") },
  [Unit.CodeEnumRank.Superior] = { Apollo.GetString("TargetFrame_Superior"), Apollo.GetString("TargetFrame_Strong") },
  [Unit.CodeEnumRank.Elite] = { Apollo.GetString("TargetFrame_Prime"), Apollo.GetString("TargetFrame_VeryStrong") },
}

local kstrTooltipBodyColor = "ffc0c0c0"
local kstrTooltipTitleColor = "ffdadada"

-- Deadzone tables lifted from the Addon Perspective --
-- Lookup tables to save ourselves a lot of work and fake an oval dead zone around character
local DeadzoneAnglesLookup = {
  { Deg = -90, Rad = -1.5707963267949, NextRad = -1.48352986419518, Length = 250, WideLength = 250, DeltaRad = 0.0872664625997164, DeltaLength = -5, DeltaWideLength = -3 },
  { Deg = -85, Rad = -1.48352986419518, NextRad = -1.39626340159546, Length = 245, WideLength = 247, DeltaRad = 0.0872664625997166, DeltaLength = -13, DeltaWideLength = -2 },
  { Deg = -80, Rad = -1.39626340159546, NextRad = -1.30899693899575, Length = 232, WideLength = 245, DeltaRad = 0.0872664625997164, DeltaLength = -17, DeltaWideLength = -6 },
  { Deg = -75, Rad = -1.30899693899575, NextRad = -1.13446401379631, Length = 215, WideLength = 239, DeltaRad = 0.174532925199433, DeltaLength = -45, DeltaWideLength = -17 },
  { Deg = -65, Rad = -1.13446401379631, NextRad = -0.959931088596881, Length = 170, WideLength = 222, DeltaRad = 0.174532925199433, DeltaLength = -35, DeltaWideLength = -22 },
  { Deg = -55, Rad = -0.959931088596881, NextRad = -0.785398163397448, Length = 135, WideLength = 200, DeltaRad = 0.174532925199433, DeltaLength = -30, DeltaWideLength = -26 },
  { Deg = -45, Rad = -0.785398163397448, NextRad = -0.523598775598299, Length = 105, WideLength = 174, DeltaRad = 0.261799387799149, DeltaLength = -30, DeltaWideLength = -39 },
  { Deg = -30, Rad = -0.523598775598299, NextRad = 0, Length = 75, WideLength = 135, DeltaRad = 0.523598775598299, DeltaLength = -30, DeltaWideLength = -62 },
  { Deg = 0, Rad = 0, NextRad = 0.785398163397448, Length = 45, WideLength = 73, DeltaRad = 0.785398163397448, DeltaLength = -10, DeltaWideLength = -40 },
  { Deg = 45, Rad = 0.785398163397448, NextRad = 1.5707963267949, Length = 35, WideLength = 33, DeltaRad = 0.785398163397448, DeltaLength = 0, DeltaWideLength = -6 },
  { Deg = 90, Rad = 1.5707963267949, NextRad = 2.35619449019234, Length = 35, WideLength = 27, DeltaRad = 0.785398163397448, DeltaLength = 0, DeltaWideLength = 0 }
}
local DeadzoneRaceLookup = {
  [1] = { Race = "Exile Human", Scale = 1.1, Wide = 0 },
  [3] = { Race = "Granok", Scale = 1.0, Wide = 1 },
  [4] = { Race = "Aurin", Scale = 0.9, Wide = 0 },
  [13] = { Race = "Chua", Scale = 0.70, Wide = 0 },
  [16] = { Race = "Mordesh", Scale = 1.05, Wide = 0 }
}




-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function KuronaFrames:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  -- initialize variables here

  return o
end


function KuronaFrames:Init()
  local bHasConfigureFunction = true
  local strConfigureButtonText = "KuronaFrames"
  local tDependencies = {-- "UnitOrPackageName",
  }
  Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end


-----------------------------------------------------------------------------------------------
-- KuronaFrames OnLoad
-----------------------------------------------------------------------------------------------
function KuronaFrames:OnLoad()
  -- load our form file
  self.xmlDoc = XmlDoc.CreateFromFile("KuronaFrames.xml")
  self.BuffxmlDoc = XmlDoc.CreateFromFile("BlankBuffs.xml")
  self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end

-----------------------------------------------------------------------------------------------
-- KuronaFrames OnDocLoaded
-----------------------------------------------------------------------------------------------
function KuronaFrames:OnDocLoaded()

  if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
    Apollo.LoadSprites("KuronaSprites.xml");
    self.PopUp = Apollo.LoadForm(self.xmlDoc, "PopUp", "FixedHudStratumHigh", self)
    self.focusFrame = Apollo.LoadForm(self.xmlDoc, "NewFocusFrame", "FixedHudStratum", self)



    if self.tSettings and self.tSettings.bMirroredTargetFrame then
      self.targetFrame = Apollo.LoadForm(self.xmlDoc, "MirroredTargetFrame", "FixedHudStratumLow", self)
    else
      self.targetFrame = Apollo.LoadForm(self.xmlDoc, "MainPlayerFrame", "FixedHudStratumLow", self)
    end

    self.playerFrame = Apollo.LoadForm(self.xmlDoc, "MainPlayerFrame", "FixedHudStratumLow", self)
    self.HazardBar = Apollo.LoadForm(self.xmlDoc, "HazardWindow", "FixedHudStratumLow", self)
    --self.NewPopUp = Apollo.LoadForm(self.xmlDoc, "NewPopUp", "FixedHudStratumHigh",self)
    self.EditModeForm = Apollo.LoadForm(self.xmlDoc, "EditModeForm", "FixedHudStratum", self)
    self.Overlay = Apollo.LoadForm(self.xmlDoc, "Overlay", "InWorldHudStratum", self)
    --self.playerFrame:SetOpacity(0.8,25)
    self.ProximityCastForm = Apollo.LoadForm(self.xmlDoc, "ProximityCastForm", "FixedHudStratumLow", self)
    self.AlertWindow = Apollo.LoadForm(self.xmlDoc, "AlertWindow", "FixedHudStratumLow", self)

    if self.playerFrame == nil then
      Print("KuronaFrames Failed To Load. Try Reloading UI")
      Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
      return
    end
    GColor = Apollo.GetPackage("KF-GeminiColor").tPackage

    self.xmlDoc:RegisterCallback("OnDocumentReady", self)
  end

  Apollo.RegisterEventHandler("CharacterCreated", "OnCharacterCreated", self)
  Apollo.RegisterEventHandler("TargetUnitChanged", "OnTargetUnitChanged", self)
  Apollo.RegisterEventHandler("AlternateTargetUnitChanged", "OnAlternateTargetUnitChanged", self)
  Apollo.RegisterEventHandler("VarChange_FrameCount", "OnFrame", self)
  Apollo.RegisterSlashCommand("focus", "OnFocusSlashCommand", self)
  Apollo.RegisterSlashCommand("kframes", "OnOpenOptions", self)
  Apollo.RegisterEventHandler("InterfaceMenuListHasLoaded", "OnInterfaceMenuListHasLoaded", self)
  Apollo.RegisterEventHandler("KuronaFramesClick", "OnKuronaFramesMenuClick", self)
  Apollo.RegisterEventHandler("ChangeWorld", "OnWorldChange", self)
  Apollo.RegisterEventHandler("ChatZoneChange", "OnWorldChange", self)
  Apollo.RegisterEventHandler("StartSpellThreshold", "OnStartSpellThreshold", self)
  Apollo.RegisterEventHandler("ClearSpellThreshold", "OnClearSpellThreshold", self)
  Apollo.RegisterEventHandler("UpdateSpellThreshold", "OnUpdateSpellThreshold", self)
  Apollo.RegisterTimerHandler("AbilityBook_CacheTimer", "DelayedAbilityBookCheck", self)
  Apollo.RegisterTimerHandler("SprintMeterGracePeriod", "OnSprintMeterGracePeriod", self)
  Apollo.RegisterTimerHandler("AlertWindowGracePeriod", "OnAlertWindowGracePeriod", self)
  Apollo.RegisterEventHandler("UnitEnteredCombat", "OnEnteredCombat", self)
  Apollo.RegisterEventHandler("ApplyCCState", "OnCCApplied", self)
  Apollo.RegisterEventHandler("RemoveCCState", "OnCCRemove", self)

  --Hazards
  Apollo.RegisterEventHandler("HazardEnabled", "OnHazardEnable", self)
  Apollo.RegisterEventHandler("HazardRemoved", "OnHazardRemove", self)
  Apollo.RegisterEventHandler("HazardUpdated", "OnHazardsUpdated", self)
  Apollo.RegisterEventHandler("BreathChanged", "OnBreathChanged", self)


  self.HazardBar:Show(false, true)
  self.HazardBarMeter = self.HazardBar:FindChild("HazardBarMeter")

  self.infSymbol = self.targetFrame:FindChild("SpellIcon"):GetText()
  self.targetFrame:FindChild("SpellIcon"):SetText("")
  self.playerFrame:FindChild("SpellIcon"):SetText("")
  self.fOldVulnerable = {}
  self.fOldVulnerable[1] = 0
  self.fOldVulnerable[2] = 0
  self.fOldVulnerable[3] = 0

  self.fvulnerableMax = {}
  self.fvulnerableMax[1] = 0
  self.fvulnerableMax[2] = 0
  self.fvulnerableMax[3] = 0

  self.CurCastName = "p"
  self.FocCastName = "f"
  self.TarCastName = "t"
  self.bFramesCanFlash = true
  self.DecayTimerDone = true
  self.bSpecialCastName = ""
  self.Version = Version
  if self.tSettings == nil then
    self.tSettings = self:DefaultTable()
    self.tSettings.cPopL = 20
    self.tSettings.cPopT = 20
    self.PopUp:Invoke()
    self.backupSettings = {}
    for k, v in pairs(self.tSettings) do
      self.backupSettings[k] = v
    end
  end
  --temp fix
  --self.tSettings.bMirroredTargetFrame = false


  if self.tSettings.bShowCarbineResources then
    Apollo.SetConsoleVariable("hud.ResourceBarDisplay", 1)

  else
    Apollo.SetConsoleVariable("hud.ResourceBarDisplay", 2)
  end

  if self.tSettings.bVerticalSprint then
    self.sprint = Apollo.LoadForm(self.xmlDoc, "VerticalSprintForm", "FixedHudStratumLow", self)
  else
    self.sprint = Apollo.LoadForm(self.xmlDoc, "KuronaSprint", "FixedHudStratumLow", self)
  end

  if self.tSettings.bMatchFocus or self.tSettings.bLineToSubdue then
    Apollo.RemoveEventHandler("UnitCreated", self)
    Apollo.RegisterEventHandler("UnitCreated", "OnUnitCreated", self)
    --			Apollo.RegisterEventHandler("UnitDestoryed", "OnUnitDestroyed", self)
    Apollo.RegisterEventHandler("UnitDestroyed", "OnUnitDestroyed", self)
  end


  local nHeight = self.PopUp:GetHeight()
  local nWidth = self.PopUp:GetWidth()
  self.PopUp:SetAnchorOffsets(self.tSettings.cPopL, self.tSettings.cPopT, self.tSettings.cPopL + nWidth, self.tSettings.cPopT + nHeight)

  if self.tSettings.bShowThreatMeter then
    Apollo.RemoveEventHandler("TargetThreatListUpdated", self)
    Apollo.RegisterEventHandler("TargetThreatListUpdated", "OnThreatUpdated", self)
  end

  if self.tSettings.bSmoothCastBar then
    Apollo.RemoveEventHandler("NextFrame", self)
    Apollo.RegisterEventHandler("NextFrame", "OnNextFrame", self)
  end

  self.playerFrame:FindChild("ClassIcon"):Show(self.tSettings.bShowClassIcons)
  self.targetFrame:FindChild("ClassIcon"):Show(self.tSettings.bShowClassIcons)
  self.focusFrame:FindChild("ClassIcon"):Show(self.tSettings.bShowClassIcons)
  self.ComboBoxHide = false
  self.totUnit = nil
  self.newDamageTaken = 0
  self.DamageTaken = {}
  self.nBreath = 100
  self.TarCastName = ""
  self.FocCastName = ""
  self.ActiveCC = {}

  self:SetupFrameAlias()

  --Locale
  self.Locale = 1

  local strCancel = Apollo.GetString(1)
  if strCancel == "Abbrechen" then
    self.Locale = 2
  elseif strCancel == "Annuler" then
    self.Locale = 3
  else
    self.Locale = 1
  end


  self.karDispositionColors =
  {
    [Unit.CodeEnumDisposition.Neutral] = self.tSettings.NNameColor,
    [Unit.CodeEnumDisposition.Hostile] = self.tSettings.HNameColor,
    [Unit.CodeEnumDisposition.Friendly] = self.tSettings.FNameColor,
  }


  self.karCastbarDispositionColors =
  {
    [Unit.CodeEnumDisposition.Neutral] = self.tSettings.NCastColor,
    [Unit.CodeEnumDisposition.Hostile] = self.tSettings.HCastColor,
    [Unit.CodeEnumDisposition.Friendly] = self.tSettings.FCastColor,
  }

  self.fillSprites = {
    [1] = "KuronaSprites:FillingBar",
    [2] = "BasicSprites:WhiteFill",
    [3] = "KuronaSprites:TexBar",
  }

  self.fullSprites = {
    [1] = "KuronaSprites:Bar",
    [2] = "BasicSprites:WhiteFill",
    [3] = "KuronaSprites:TexBar",
  }

  self.emptySprites = {
    [1] = "KuronaSprites:Bar",
    [2] = "BasicSprites:WhiteFill",
    [3] = "KuronaSprites:TexBar",
  }

  if GameLib.GetPlayerUnit() ~= nil then
    self:OnCharacterCreated()
  end


  -- Print("one line\nnext line\n\"in quotes\", 'in quotes'")

  self.frameResizeNeeded = true

  JSON = Apollo.GetPackage("Lib:dkJSON-2.5").tPackage
  --One Version
  Event_FireGenericEvent("OneVersion_ReportAddonInfo", "KuronaFrames", Major, Minor, Patch)
end


function KuronaFrames:SetupFrameAlias()
  self.Frames = {}
  self.Frames[1] = self.playerFrame
  self.Frames[2] = self.targetFrame
  self.Frames[3] = self.focusFrame
  self.ClusterBarColor1 = 0
  self.ClusterBarColor2 = 0
  self.FrameAlias = {}
  for i = 1, #self.Frames do
    self.FrameAlias[i] = {
      UnitName = self.Frames[i]:FindChild("UnitName"),
      HealthProgressBar = self.Frames[i]:FindChild("HealthProgressBar"),
      ShieldProgressBar = self.Frames[i]:FindChild("ShieldProgressBar"),
      AbsorbProgressBar = self.Frames[i]:FindChild("AbsorbProgressBar"),
      HSAWindow = self.Frames[i]:FindChild("HSAWindow"),
      Markers = self.Frames[i]:FindChild("Markers"),
      ClassIconBase = self.Frames[i]:FindChild("ClassIconBase"),
      CCArmor = self.Frames[i]:FindChild("CCArmor"),
      Health = self.Frames[i]:FindChild("Health"),
      Absorb = self.Frames[i]:FindChild("Absorb"),
      Shield = self.Frames[i]:FindChild("Shield"),
      LargeFrame = self.Frames[i]:FindChild("LargeFrame"),
      Arrow = self.Frames[i]:FindChild("Arrow"),
      TargetName = self.Frames[i]:FindChild("TargetName"),
      HealthFrame = self.Frames[i]:FindChild("HealthFrame"),
      AbsorbFrame = self.Frames[i]:FindChild("AbsorbFrame"),
      ShieldFrame = self.Frames[i]:FindChild("ShieldFrame"),
      RaidMarkerIcon = self.Frames[i]:FindChild("RaidMarker"),
      RaidMarkerNum = 0,
      RecordedName = "",
      RecordedHealth = -1,
      RecordedShield = 0,
      RecordedAbsorb = 0,
      RecordedHealthMax = 0,
      RecordedShieldMax = 0,
      RecordedAbsorbMax = 0,
      RecordedMaxCC = 0,
      RecordedSpellTime = 999,
      RecordedCCSprite = "",
      CastFrame = self.Frames[i]:FindChild("CastFrame"),
      CastBarFrame = self.Frames[i]:FindChild("CastBarFrame"),
      CastBar = self.Frames[i]:FindChild("CastBar"),
      SpellTime = self.Frames[i]:FindChild("SpellTime"),
      SpellIcon = self.Frames[i]:FindChild("SpellIcon"),
      CastName = self.Frames[i]:FindChild("CastName"),
      TargetDisposition = 0,
      CCArmorValue = "",
      CCArmorMax = "",
      TargetUnit = nil,
      DamageTaken = self.Frames[i]:FindChild("DamageTaken"),
      ShieldDamageTaken = self.Frames[i]:FindChild("ShieldDamageTaken"),
      AbsorbDamageTaken = self.Frames[i]:FindChild("AbsorbDamageTaken"),
      DamageTakenFrame = self.Frames[i]:FindChild("DamageTakenFrame"),
      ShieldDamageTakenFrame = self.Frames[i]:FindChild("ShieldDamageTakenFrame"),
      AbsorbDamageTakenFrame = self.Frames[i]:FindChild("AbsorbDamageTakenFrame"),
      BeneBuffBar = self.Frames[i]:FindChild("BeneBuffBar"),
      HarmBuffBar = self.Frames[i]:FindChild("HarmBuffBar"),
      ClassIcon = self.Frames[i]:FindChild("ClassIcon"),
      MobRank = self.Frames[i]:FindChild("MobRank"),
    }
  end
  -- special alias' not shared by all
  self.FrameAlias[1].PetFrame = self.Frames[1]:FindChild("PetFrame")
  self.FrameAlias[2].ClusterFrame = self.Frames[2]:FindChild("PetFrame")
  self.FrameAlias[1].ChargeFrame = self.Frames[1]:FindChild("ChargeLevel")
  self.FrameAlias[1].ChargeBar = self.Frames[1]:FindChild("ChargeBar")
  self.FrameAlias[2].PlayerThreatProgressBar = self.Frames[2]:FindChild("PlayerThreatProgressBar")
  self.FrameAlias[2].Threat = self.targetFrame:FindChild("Threat")
  self.FrameAlias[2].TopThreat = self.targetFrame:FindChild("TopThreat")

  for i = 2, 3 do
    self.FrameAlias[i].ToTHarmBuffBar = self.Frames[i]:FindChild("ToTHarmBuffBar")
    self.FrameAlias[i].ToTWindow = self.Frames[i]:FindChild("ToTWindow")
    self.FrameAlias[i].MiniHealthProgressBar = self.Frames[i]:FindChild("MiniHealthProgressBar")
    self.FrameAlias[i].MiniShieldProgressBar = self.Frames[i]:FindChild("MiniShieldProgressBar")
    self.FrameAlias[i].MiniAbsorbProgressBar = self.Frames[i]:FindChild("MiniAbsorbProgressBar")
    self.FrameAlias[i].MiniHealthFrame = self.Frames[i]:FindChild("MiniHealthFrame")
    self.FrameAlias[i].MiniShieldFrame = self.Frames[i]:FindChild("MiniShieldFrame")
    self.FrameAlias[i].MiniAbsorbFrame = self.Frames[i]:FindChild("MiniAbsorbFrame")
  end
  self.dashes = self.sprint:FindChild("DashTokens")
  --Sprint meter
  self.SprintMeter = {
    DashProgressBar1 = self.dashes:FindChild("DashProgressBar1"),
    DashProgressBar2 = self.dashes:FindChild("DashProgressBar2"),
    ProgressBar = self.sprint:FindChild("ProgressBar"),
  }

  self.ProximityCast = {
    Bars = {},
    Windows = {},
    Names = {},
    Time = {},
    CastTime = {},
    CastName = {},
    MaxCC = {},
    CurrentCC = {},
    CCSprite = {},
    Icon = {}
  }

  for i = 1, 2 do
    self.ProximityCast.Bars[i] = self.ProximityCastForm:FindChild("ProximityCastBar" .. i)
    self.ProximityCast.Windows[i] = self.ProximityCastForm:FindChild("ProximityCastWindow" .. i)
    self.ProximityCast.Names[i] = ""
    self.ProximityCast.Time[i] = self.ProximityCastForm:FindChild("SpellTime" .. i)
    self.ProximityCast.CastName[i] = self.ProximityCastForm:FindChild("CastName" .. i)
    self.ProximityCast.Icon[i] = self.ProximityCastForm:FindChild("SpellIcon" .. i)
    self.ProximityCast.MaxCC[i] = 999
    self.ProximityCast.CCSprite[i] = "blank"
    self.ProximityCast.CastTime[i] = 999
  end

  --Hazard Meter
  self.HazardMeter = self.HazardBar:FindChild("HazardBarMeter")
  self.HazardLabel = self.HazardBar:FindChild("HazardLabel")

  self.ThreatWindow = self.targetFrame:FindChild("Threat")
end


function KuronaFrames:OnWorldChange()
  if GameLib.GetPlayerUnit() == nil then return end
  self.player = GameLib.GetPlayerUnit()
  self.Target = nil
  self.Focus = nil
  self.playerFrame:FindChild("BeneBuffBar"):SetUnit(GameLib.GetPlayerUnit())
  self.playerFrame:FindChild("HarmBuffBar"):SetUnit(GameLib.GetPlayerUnit())
  if self.player ~= nil then
    self.Focus = self.player:GetAlternateTarget()
    self:FillAllFrames()
    self:SetupPetFrame()
    self:SetupClusterFrame()
  end
end


function KuronaFrames:OnCharacterCreated()
  local unitPlayer = GameLib.GetPlayerUnit()
  if not unitPlayer then
    return
  end
  self:AssembleOptionsMenu()
  self:OnCharacterLoaded()
  self:OnHazardsUpdated()
  self:HideSprint()
end

function KuronaFrames:CreateResources(unitPlayer)
  if self.Resources == nil then
    -- Load Up Resource Forms
    local eClassId = unitPlayer:GetClassId()
    if eClassId == GameLib.CodeEnumClass.Esper then
      Apollo.RegisterEventHandler("BuffAdded", "OnBuffAdded", self)
      Apollo.RegisterEventHandler("BuffRemoved", "OnBuffRemoved", self)
      Apollo.RegisterEventHandler("BuffUpdated", "OnBuffUpdated", self)

      self.Resources = Apollo.LoadForm(self.xmlDoc, "EsperResourcesForm", self.playerFrame, self)
      self.PPList = {}
      self.PPList[1] = self.Resources:FindChild("PP1")
      self.PPList[2] = self.Resources:FindChild("PP2")
      self.PPList[3] = self.Resources:FindChild("PP3")
      self.PPList[4] = self.Resources:FindChild("PP4")
      self.PPList[5] = self.Resources:FindChild("PP5")

      self.EIcon = {}
      self.EIcon[1] = self.Resources:FindChild("Icon1")
      self.EIcon[2] = self.Resources:FindChild("Icon2")
      self.EIcon[3] = self.Resources:FindChild("Icon3")
      self.EIcon[4] = self.Resources:FindChild("Icon4")
      self.EIcon[5] = self.Resources:FindChild("Icon5")

      self.MiniCastBar = self.Resources:FindChild("MiniCastBar")
      self.FocusBar = Apollo.LoadForm(self.xmlDoc, "FocusMeter", self.Resources, self)
      self.FocusBarMeter = self.FocusBar:FindChild("FocusBarMeter")
      self.mindBurstColor = "ffffffff"
      self.EsperResources = 0
      local opac = 0.75
      self.Resources:SetOpacity(opac)
      if self.tSettings.bEsperTAOpacity == nil then self.tSettings.bEsperTAOpacity = 100 end
      --self.Overlay:SetOpacity(self.tSettings.bEsperTAOpacity/100,100)

      if self.HasMindBurst == nil or self.HasTKStorm == nil then
        self:OnAbilityBookChange()
      end

      local CheckBoxes = self.PopUp:FindChild("CheckBoxes")
      if self.PopUp:FindChild("EsperOptions") == nil then
        self:MakeCategory("Esper Options", "EsperOptions")
        self.CategoryList:ArrangeChildrenVert()
      end
      Apollo.RemoveEventHandler("AbilityBookChange", self)
      Apollo.RegisterEventHandler("AbilityBookChange", "OnAbilityBookChange", self)

      self.PsiPointDisplay = self.Resources:FindChild("PsiPointDisplay")
      if self.PsiPointDisplay then
        self.PsiPointDisplay:SetAnchorOffsets(self.tSettings.cPsiPointsL, self.tSettings.cPsiPointsT, self.tSettings.cPsiPointsR, self.tSettings.cPsiPointsB)
      end
      self.MiniCastBar:SetBarColor(self.tSettings.AuxCastColor)

    elseif eClassId == GameLib.CodeEnumClass.Spellslinger then
      self.Resources = Apollo.LoadForm(self.xmlDoc, "SpellslingerResourcesForm", self.playerFrame, self)
      self.SSList = {}
      self.SSList[1] = self.Resources:FindChild("ProgressBar1")
      self.SSList[2] = self.Resources:FindChild("ProgressBar2")
      self.SSList[3] = self.Resources:FindChild("ProgressBar3")
      self.SSList[4] = self.Resources:FindChild("ProgressBar4")
      self.CombatStatus = self.Resources:FindChild("CombatStatus")
      self.MiniCastBar = self.Resources:FindChild("MiniCastBar")
      self.FocusBar = Apollo.LoadForm(self.xmlDoc, "FocusMeter", self.Resources, self)
      self.FocusBarMeter = self.FocusBar:FindChild("FocusBarMeter")
      local CheckBoxes = self.PopUp:FindChild("CheckBoxes")
      if self.PopUp:FindChild("SpellslingerOptions") == nil then
        self:MakeCategory("Spellslinger Options", "SpellslingerOptions")
        self.CategoryList:ArrangeChildrenVert()
      end
      self.SpellPowerValue = self.Resources:FindChild("SpellPowerValue")
    elseif eClassId == GameLib.CodeEnumClass.Medic then
      self.Resources = Apollo.LoadForm(self.xmlDoc, "MedicResourcesForm", self.playerFrame, self)
      self.ActuatorList = {}
      self.ActuatorList[1] = self.Resources:FindChild("Actuator1")
      self.ActuatorList[2] = self.Resources:FindChild("Actuator2")
      self.ActuatorList[3] = self.Resources:FindChild("Actuator3")
      self.ActuatorList[4] = self.Resources:FindChild("Actuator4")
      for i = 1, 4 do
        self.ActuatorList[i]:SetSprite(self:GetBarType("normal"))
      end
      self.FocusBar = Apollo.LoadForm(self.xmlDoc, "FocusMeter", self.Resources, self)
      self.FocusBarMeter = self.FocusBar:FindChild("FocusBarMeter")


    elseif eClassId == GameLib.CodeEnumClass.Warrior then
      self.KineticRange = 1000
      self.Resources = Apollo.LoadForm(self.xmlDoc, "WarriorResourcesForm", self.playerFrame, self)
      self.kBar = self.Resources:FindChild("KineticEnergyBar")
      self.kBar:SetFullSprite(self:GetBarType("flashB"))
      self.kBar:SetFillSprite(self:GetBarType("normal"))
    elseif eClassId == GameLib.CodeEnumClass.Stalker then
      if self.HasImpale == nil then
        self:OnAbilityBookChange()
      end

      if self.PopUp:FindChild("StalkerOptions") == nil then
        self:MakeCategory("Stalker Options", "StalkerOptions")
        self.CategoryList:ArrangeChildrenVert()
      end

      self.Resources = Apollo.LoadForm(self.xmlDoc, "StalkerResourcesForm", self.playerFrame, self)
      Apollo.RemoveEventHandler("AbilityBookChange", self)
      Apollo.RegisterEventHandler("AbilityBookChange", "OnAbilityBookChange", self)
      self.sBar = self.Resources:FindChild("SuitPowerBar")
      self.sBar:SetFullSprite(self:GetBarType("normal"))
      self.sBar:SetFillSprite(self:GetBarType("normal"))
    elseif eClassId == GameLib.CodeEnumClass.Engineer then
      self.Resources = Apollo.LoadForm(self.xmlDoc, "EngineerResourcesForm", self.playerFrame, self)
      self.FrameAlias["vBar1"] = self.Resources:FindChild("VolatilityBar1")
      self.FrameAlias["vBar2"] = self.Resources:FindChild("VolatilityBar2")
      self.FrameAlias["vBar3"] = self.Resources:FindChild("VolatilityBar3")

      local CheckBoxes = self.PopUp:FindChild("CheckBoxes")
      if self.PopUp:FindChild("EngineerOptions") == nil then
        self:MakeCategory("Engineer Options", "EngineerOptions")
        self.CategoryList:ArrangeChildrenVert()
      end
    end



    self:MakeCategory("What's New", "WhatsNewOptions")
    self.CategoryList:ArrangeChildrenVert()

    self:FillWhatsNew()
  end


  if self.tSettings.bUseGenericResources then
    self.Resources:Destroy()
    self.Resources = Apollo.LoadForm(self.xmlDoc, "GenericResourcesForm", self.playerFrame, self)
    self.Resources:FindChild("GResourceBar"):SetBarColor(self.tSettings.BasicResourceColor)

    local eClassId = unitPlayer:GetClassId()
    if eClassId == GameLib.CodeEnumClass.Esper or eClassId == GameLib.CodeEnumClass.Medic or eClassId == GameLib.CodeEnumClass.Spellslinger then
      if self.FocusBar then
        self.FocusBar:Destroy()
        self.FocusBar = Apollo.LoadForm(self.xmlDoc, "FocusMeter", self.Resources, self)
        self.FocusBarMeter = self.FocusBar:FindChild("FocusBarMeter")
      end
    end

    self.FocusValue = 9999
  end

  if self.FocusBar then
    self.FocusBarMeter:SetStyleEx("UsePercent", self.tSettings.bFocusAsPercent)
    self.FocusBarMeter:SetStyleEx("UseValues", not self.tSettings.bFocusAsPercent)
    self.FocusBarMeter:SetFillSprite(self:GetBarType("normal"))
    self.FocusBarMeter:SetFullSprite(self:GetBarType("normal"))
    self.FocusBar:SetAnchorOffsets(self.tSettings.cFocusBarL, self.tSettings.cFocusBarT, self.tSettings.cFocusBarR, self.tSettings.cFocusBarB)
  end
end



-----------------------------------------------------------------------------------------------
-- KuronaFramesForm Functions
-----------------------------------------------------------------------------------------------
function KuronaFrames:SetBarAlpha(alpha, castalpha)
  local ratio = alpha / 1
  local ratioC = castalpha / 1
  for i = 1, 3 do
    self.FrameAlias[i].HealthProgressBar:SetOpacity(alpha, 100)
    self.FrameAlias[i].ShieldProgressBar:SetOpacity(alpha, 100)
    self.FrameAlias[i].AbsorbProgressBar:SetOpacity(alpha, 100)
    self.FrameAlias[i].HealthFrame:SetOpacity(2 / ratio, 100)
    self.FrameAlias[i].ShieldFrame:SetOpacity(2 / ratio, 100)
    self.FrameAlias[i].AbsorbFrame:SetOpacity(2 / ratio, 100)

    self.FrameAlias[i].CastBar:SetOpacity(castalpha, 100)
    self.FrameAlias[i].CastBarFrame:SetOpacity(2 / ratioC, 100)
  end

  for i = 2, 3 do
    self.FrameAlias[i].ToTWindow:FindChild("MiniHealthProgressBar"):SetOpacity(alpha, 100)
    self.FrameAlias[i]["MiniShieldProgressBar"]:SetOpacity(alpha, 100)
    self.FrameAlias[i]["MiniHealthFrame"]:SetOpacity(2 / ratio, 100)
    self.FrameAlias[i]["MiniShieldFrame"]:SetOpacity(2 / ratio, 100)
  end
  if self.FocusBar then
    self.FocusBarMeter:SetOpacity(castalpha, 100)
  end

  local petframe = self.FrameAlias[1].PetFrame
  for i = 1, 2 do
    local hbar = petframe:GetChildren()[i]:FindChild("MiniHealthProgressBar")
    hbar:SetOpacity(alpha, 100)
    hbar:GetChildren()[1]:SetOpacity(2 / ratio, 100)

    self.ProximityCast.Bars[i]:SetOpacity(castalpha, 100)


    local sbar = petframe:GetChildren()[i]:FindChild("MiniShieldProgressBar")
    sbar:SetOpacity(alpha, 100)
    sbar:GetChildren()[1]:SetOpacity(2 / ratio, 100)
  end
end

---------------------------------------------------------------------------------------------------
-- Form Functions
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- PopUp Functions
---------------------------------------------------------------------------------------------------
function KuronaFrames:PopUpMoved(wndHandler, wndControl, nOldLeft, nOldTop, nOldRight, nOldBottom)
  self:MoveColorPicker()
end

---------------------------------------------------------------------------------------------------
-- StyleOptions Functions
---------------------------------------------------------------------------------------------------
function KuronaFrames:SetStyle(wndHandler, wndControl, eMouseButton, nLastRelativeMouseX, nLastRelativeMouseY, bDoubleClick, bStopPropagation)
  if wndControl and wndControl:GetName() == "SquareStyleSelect" then
    self:ChangeFrameBorders(2)
    self:ChangeFrameBorders(2)
  elseif wndControl and wndControl:GetName() == "SquareStyleSelect3" then
    self:ChangeFrameBorders(3)
    self:ChangeFrameBorders(3)
  elseif wndControl and wndControl:GetName() == "SquareStyleSelect4" then
    self:ChangeFrameBorders(4)
    self:ChangeFrameBorders(4)
  elseif wndControl and wndControl:GetName() == "RoundStyleSelect" then
    self:ChangeFrameBorders(1)
    self:ChangeFrameBorders(1)
  end
end

---------------------------------------------------------------------------------------------------
-- EngineerPetButton Functions
---------------------------------------------------------------------------------------------------

--function KuronaFrames:OnEngineerPetBtnMouseExit( wndHandler, wndControl, x, y )
--end

--function KuronaFrames:OnEngineerPetBtnMouseEnter( wndHandler, wndControl, x, y )
--end

--function KuronaFrames:OnGeneratePetCommandTooltip( wndHandler, wndControl, eToolTipType, x, y )
--end

---------------------------------------------------------------------------------------------------
-- FontOptions Functions
---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------
-- EditMode Functions
---------------------------------------------------------------------------------------------------
function KuronaFrames:OnPrepCopy(wndHandler, wndControl, x, y)

  local SavedSettings = self:OnSave(GameLib.CodeEnumAddonSaveLevel.Character, true)

  --[[local strExport = ""

    for key,val in pairs(SavedSettings) do
		strExport = strExport .. key .." = "
		if type(val) == "boolean" then
			val = tostring(val)
		elseif type(val) == "string" then
			val = "\"" .. val .. "\""
		end
		strExport = strExport .. val .."\n"
	end

	--strExport = self.tSettings
]]
  local strExport = JSON.encode(SavedSettings)
  wndHandler:FindChild("ClipboardBtn"):SetActionData(GameLib.CodeEnumConfirmButtonType.CopyToClipboard, strExport)
end

function KuronaFrames:OnApplyImportSettings(wndHandler, wndControl, eMouseButton)
  local importData, pos, err = JSON.decode(wndHandler:GetParent():FindChild("ImportSettingsEditBox"):GetText())

  if not importData then
    Print("An Import Error Occured.  Error at pos: " .. pos .. " Error: " .. err)
    return
  end



  local defaultsettings = self:DefaultTable()

  for k, v in pairs(defaultsettings) do
    if importData[k] == nil then
      importData[k] = v
    end
  end

  self:RestoreSettings(importData)
  Print("Imported settings applied!")
  self.OptionsList:FindChild("ImportSettingsButton"):SetCheck(false)
  wndHandler:GetParent():FindChild("ImportSettingsEditBox"):SetText("")
end






-----------------------------------------------------------------------------------------------
-- KuronaFrames Instance
-----------------------------------------------------------------------------------------------
local KuronaFramesInst = KuronaFrames:new()
KuronaFramesInst:Init()


function KuronaFrames:NewBuffBars(frame, buffBar, alignRight, unit)
  if alignRight then
    alignRight = 1
  else
    alignRight = 0
  end

  local barname = buffBar
  local BGColor = "ffffffff"

  local buff = 0
  local debuff = 0
  if barname == "BeneBuffBar" then
    buff = 1
    BGColor = "800000ff"
  elseif barname == "HarmBuffBar" then
    debuff = 1
    BGColor = "80ff0000"
  end

  local xmlFramesXml = self.BuffxmlDoc
  local tTableData = xmlFramesXml:ToTable()
  for key, val in pairs(tTableData) do
    if val.Name == "Buffs" then
      val.AlignBuffsRight = alignRight

      if buff == 1 then
        --				val.BeneficialBuffs = "1"
        val.DebuffDispellable = "0"
        val.DebuffNonDispellable = "0"
        val.BuffDispellable = "1"
        val.BuffNonDispellable = "1"
        val.BuffNonDispelRightClickOk = "1"
      end
      if debuff == 1 then
        --val.HarmfulBuffs = "1"
        val.DebuffDispellable = "1"
        val.DebuffNonDispellable = "1"
        val.BuffDispellable = "0"
        val.BuffNonDispellable = "0"
        val.BuffNonDispelRightClickOk = "0"
      end
    end
  end
  local l, t, r, b = self.FrameAlias[frame][barname]:GetAnchorOffsets()
  self.FrameAlias[frame][barname]:Destroy()

  local newbuffbar = Apollo.LoadForm(XmlDoc.CreateFromTable(tTableData), "Buffs", self.Frames[frame], self)

  newbuffbar:SetName(barname)
  newbuffbar:SetBGColor(BGColor)
  newbuffbar:SetAnchorOffsets(l, t, r, b)
  newbuffbar:SetUnit(unit)
  self.FrameAlias[frame][barname] = newbuffbar

  xmlFramesXml = nil
  tTableData = nil
end




function KuronaFrames:OnFrame()
  self.player = GameLib.GetPlayerUnit()
  if self.player == nil then return end

  self.Started = true

  local target = GameLib.GetTargetUnit()
  local focus = self.player:GetAlternateTarget()

  local target = self.Target
  local focus = self.FocusTarget
  self.bCombatState = self.player:IsInCombat()

  if self.bEditMode then
    self:UpdateFramesEditMode()
    return
  end
  if not self.tSettings.bAutoHideFrame and self.FrameHidden then
    self.FrameAlias[1]["LargeFrame"]:Show(true)
    self.FrameAlias[1]["BeneBuffBar"]:Show(self.tSettings.bShowBuffBars, true)
    self.FrameAlias[1]["HarmBuffBar"]:Show(self.tSettings.bShowBuffBars, true)
    self.FrameHidden = false
  end

  local unitPlayer = self.player
  if self.player:IsInVehicle() then
    unitPlayer = self.player:GetVehicle()
  end


  if self.tSettings.bAutoHideFrame then
    local strName = self:GetFirstName(self.player)

    if self.player:IsMounted() then
      if self.tSettings.bShowMountInfo then
        local mountName = self.player:GetUnitMount():GetName()
        --trim mount name
        if self.Locale == 1 then
          mountName = string.gsub(mountName, " Mount", "")
        end

        strName = strName .. " on " .. (mountName)
      end
    end
    if self.tSettings.bShowLevels then
      local level = self.player:GetLevel()
      if level ~= nil then
        strName = "[" .. level .. "] " .. strName
      end
    end
    if self.FrameAlias[1]["RecordedName"] ~= strName then
      self.FrameAlias[1]["UnitName"]:SetText(strName)
      self.FrameAlias[1]["RecordedName"] = strName
    end

    if unitPlayer:GetMaxHealth() ~= unitPlayer:GetHealth() then
      if self.tSettings.bAutoHideName and not self.Frames[1]:IsShown() then
        self.Frames[1]:Show(true)
      end
      if not self.FrameAlias[1]["LargeFrame"]:IsShown() then
        self.FrameAlias[1]["LargeFrame"]:Show(true)
        self.FrameAlias[1]["BeneBuffBar"]:Show(self.tSettings.bShowBuffBars, true)
        self.FrameAlias[1]["HarmBuffBar"]:Show(self.tSettings.bShowBuffBars, true)
        self:UpdateFrame(unitPlayer, 1)
      end
      self:UpdateFrame(unitPlayer, 1)
    elseif self.bCombatState then
      if self.tSettings.bAutoHideName and not self.Frames[1]:IsShown() then
        self.Frames[1]:Show(true)
      end
      if not self.FrameAlias[1]["LargeFrame"]:IsShown() then
        self.FrameAlias[1]["LargeFrame"]:Show(true)
        self.FrameAlias[1]["BeneBuffBar"]:Show(self.tSettings.bShowBuffBars, true)
        self.FrameAlias[1]["HarmBuffBar"]:Show(self.tSettings.bShowBuffBars, true)
        --self.FrameAlias[1]["CCArmor"]:Show(true)
        self:UpdateFrame(unitPlayer, 1)
      end
      if self.tSettings.bShowCastBar then
        self:PrepCastBars(unitPlayer, 1, unitPlayer:GetInterruptArmorValue(), unitPlayer:GetInterruptArmorMax())
        -- Doesn't seem to be required and wasn't really triggered anyway
        -- if frame == 1 then
        --   self:SpecialCastBarUpdate()
        -- end
        self:UpdateCastBar(unitPlayer, 1)
      end
    elseif unitPlayer:GetMaxHealth() == unitPlayer:GetHealth() and not self.bCombatState then
      if self.tSettings.bAutoHideName and self.Frames[1]:IsShown() then
        self.Frames[1]:Show(false)
      end
      if self.FrameAlias[1]["LargeFrame"]:IsShown() then
        self.FrameAlias[1]["LargeFrame"]:Show(false)
        self.FrameAlias[1]["BeneBuffBar"]:Show(false)
        self.FrameAlias[1]["HarmBuffBar"]:Show(false)
        self:UpdateFrame(unitPlayer, 1)
        self.FrameAlias[1]["CCArmor"]:Show(false)
      end
      if self.tSettings.bShowCastBar then
        self:PrepCastBars(unitPlayer, 1, unitPlayer:GetInterruptArmorValue(), unitPlayer:GetInterruptArmorMax())
        -- Doesn't seem to be required and wasn't really triggered anyway
        -- if frame == 1 then
        --   self:SpecialCastBarUpdate()
        -- end
        self:UpdateCastBar(unitPlayer, 1)
      end
    end
  else
    self:UpdateFrame(unitPlayer, 1)
  end

  -- Target Frame
  if target == nil then
    if self.targetFrame:IsShown() then
      self.targetFrame:Show(false)
    end
  else
    if not target:IsValid() then
      self.targetFrame:Show(true)
      self.FrameAlias[2]["UnitName"]:SetText("Out of Range")
      self.FrameAlias[2]["RecordedName"] = ""
    else
      if not self.targetFrame:IsShown() then
        self.targetFrame:Show(true)
        self.Frames[2]:FindChild("HSAWindow"):SetData(target)
      end
      self:UpdateFrame(target, 2)
    end
  end
  --- Focus Frame
  if focus == nil and self.FocusTarget == nil then
    if self.focusFrame:IsShown() then
      self.focusFrame:Show(false)
    end
  else
    if not focus:IsValid() then
      if self.FrameAlias[3]["RecordedName"] ~= "Invalid" then
        self.focusFrame:Show(true)
        self.FrameAlias[3]["UnitName"]:SetText("Out of Range")
        self.tSettings.LostFocusName = self.FrameAlias[3]["RecordedName"]
        self.FrameAlias[3]["UnitName"]:SetText("Out of Range")
        self.FrameAlias[3]["RecordedName"] = "Invalid"
        self.FrameAlias[3]["CastFrame"]:Show(false, true)
      end
    else
      if not self.focusFrame:IsShown() then
        self.focusFrame:Show(true)
        self.Frames[frame]:FindChild("HSAWindow"):SetData(focus)
      end
      self:UpdateFrame(focus, 3)
    end
  end
  if self.tSettings.bShowResources then
    self:UpdateResources(self.player)
  end
  self:UpdatePetFrame()
  self:UpdateClusterFrame()
  self:FlashBarFrame(self.playerFrame)
  if self.tSettings.bEnableSprint then
    self:Sprint()
  elseif self.sprint:IsShown() then
    self.sprint:Show(false)
  end


  --	self:BuffBarVisibility()
  if self.tSettings.bShowHazard then
    --		self:DoHazards()
  end


  self.frameResizeNeeded = false

  if self.player:IsDead() and not self.ThreatWindow:IsShown() then
    self.ThreatWindow:Show(false)
  end

  if self.bCombatState and self.tSettings.bProxmityCast then
    self:CheckProximityCasters()
  end
end


function KuronaFrames:CheckInvalidFocus(name)
end


function KuronaFrames:BuffBarVisibility()
  for i = 1, 3 do
    self.FrameAlias[i]["BeneBuffBar"]:Show(self.tSettings.bShowBuffBars, true)
    self.FrameAlias[i]["HarmBuffBar"]:Show(self.tSettings.bShowBuffBars, true)
  end
end

local ktCommonFirstNameTitles = { "Engineer", "Doctor", "Medic", "Spellslinger", "Warrior", "Esper", "Stalker", "Captain", "Hung", "Brother", "Mr", "Not", "Mister", "Miss" }


function KuronaFrames:GetFirstName(unit)
  local strName = unit:GetName()
  local loopnum = 0
  local invalidName = false
  local firstName = ""
  local secondName = ""

  if unit:GetType() == "Player" and self.tSettings.bFirstNamesOnly then
    if string.len(strName) > 12 then
      for i in string.gmatch(strName, "%S+") do
        loopnum = loopnum + 1
        if loopnum == 1 then
          firstName = i
        else
          secondName = i
        end
      end

      for t = 1, #ktCommonFirstNameTitles do
        if ktCommonFirstNameTitles[t] == firstName then
          invalidName = true
        end
      end

      if invalidName then
        return secondName
      else
        return firstName
      end
    end
  end


  return strName
end


function KuronaFrames:UpdateFrame(unit, frame)
  if unit == nil then return end
  local nHealth = unit:GetHealth() or 0
  local nHealthMax = unit:GetMaxHealth() or 0
  local nShield = unit:GetShieldCapacity() or 0
  local nShieldMax = unit:GetShieldCapacityMax() or 0
  local nAbsorb = unit:GetAbsorptionValue() or 0
  local nAbsorbMax = unit:GetAbsorptionMax() or 0
  local nCCArmorValue = unit:GetInterruptArmorValue() or 0
  local nCCArmorMax = unit:GetInterruptArmorMax() or 0
  local eDisposition = unit:GetDispositionTo(self.player)

  if unit:IsDead() then
    nHealth = 0
    --nHealthMax = unit:GetMaxHealth() or 0
    nShield = 0
    --nShieldMax = unit:GetShieldCapacityMax() or 0
    nAbsorb = 0
    nAbsorbMax = 0
    nCCArmorValue = 0
    nCCArmorMax = 0
  end

  local strName = self:GetFirstName(unit) or ""
  local fvulnerabletime = 0
  local newHealth = false
  local newShield = false
  local newAbsorb = false
  local frameResizeNeeded = false
  local SHwidth = 0.85
  local HPwidth = 0.55

  if frame ~= 1 then
    fvulnerabletime = unit:GetCCStateTimeRemaining(Unit.CodeEnumCCState.Vulnerability) or 0
  end
  --- Naming ----
  if unit:IsPvpFlagged() then
    strName = strName .. " (PVP)"
  end

  if unit:IsMounted() then
    if self.tSettings.bShowMountInfo then
      local mountName = unit:GetUnitMount():GetName()
      --trim mount name
      local name = string.gsub(mountName, " Mount", "")
      strName = strName .. " on " .. (name or mountName)
    end
    local mHealth = unit:GetUnitMount():GetHealth() or 0
    local mHealthMax = unit:GetUnitMount():GetMaxHealth() or 0
    nAbsorb = mHealth
    nAbsorbMax = mHealthMax
  end

  if self.tSettings.bShowLevels then
    local level = unit:GetLevel()
    if level ~= nil then
      strName = "[" .. level .. "] " .. strName
    end
  end

  if self.FrameAlias[frame]["TargetDisposition"] ~= eDisposition then
    self.FrameAlias[frame]["TargetDisposition"] = eDisposition
    if frame ~= 1 then
      self.FrameAlias[frame]["UnitName"]:SetTextColor(self.karDispositionColors[eDisposition])
      self.FrameAlias[frame]["CastBar"]:SetBarColor(self.karCastbarDispositionColors[eDisposition])
    end
  end
  if self.FrameAlias[frame]["RecordedName"] ~= strName then
    self.FrameAlias[frame]["UnitName"]:SetText(strName)
    self.FrameAlias[frame]["RecordedName"] = strName
  end

  --- UI Names	 ---
  wndHealth = self.FrameAlias[frame]["HealthProgressBar"]
  wndShieldBar = self.FrameAlias[frame]["ShieldProgressBar"]
  wndAbsorbBar = self.FrameAlias[frame]["AbsorbProgressBar"]
  wndCCArmor = self.FrameAlias[frame]["CCArmor"]


  local HPpercent = (nHealth / nHealthMax) * 100

  if fvulnerabletime > 0 and not self.FrameAlias[frame].BarColor ~= 1 then
    wndHealth:SetBarColor("ff800080")
    wndHealth:SetFillSprite(self:GetBarType("normal"))
    self.FrameAlias[frame].BarColor = 1
  elseif HPpercent <= 30 and not self.FrameAlias[frame].BarColor ~= 2 then
    wndHealth:SetBarColor(self.tSettings.criticalSquareColor)
    self.FrameAlias[frame].BarColor = 2
  elseif HPpercent <= 70 and not self.FrameAlias[frame].BarColor ~= 3 then
    wndHealth:SetBarColor(self.tSettings.woundSquareColor)
    self.FrameAlias[frame].BarColor = 3
  elseif self.FrameAlias[frame].BarColor ~= 4 then
    wndHealth:SetBarColor(self.tSettings.HCSquareColor)
    self.FrameAlias[frame].BarColor = 4
  end

  --- Health ---
  if nHealthMax ~= self.FrameAlias[frame]["RecordedHealthMax"] then
    wndHealth:SetMax(nHealthMax)
    self.FrameAlias[frame]["RecordedHealthMax"] = nHealthMax
  end
  if nHealth ~= self.FrameAlias[frame]["RecordedHealth"] then
    wndHealth:SetProgress(nHealth)
    if not self.tSettings.bDisableEatAway then
      if frame ~= 3 then
        if nHealth < self.FrameAlias[frame]["RecordedHealth"] then
          local parentwidth = wndHealth:GetWidth()
          local difference = self.FrameAlias[frame]["RecordedHealth"] / self.FrameAlias[frame]["RecordedHealthMax"]
          --[[
					if frame == 2 and self.tSettings.bMirroredTargetFrame then
						--	99 / 100				* 200
						start =	 parentwidth - ((nHealth / nHealthMax) * parentwidth)
						Print(start)
						--start = 0
					else
						start =	(nHealth / nHealthMax) * parentwidth
					end
					]]
          local start = (nHealth / nHealthMax) * parentwidth
          self:DoDamageTicks(frame, parentwidth, difference, start, self.FrameAlias[frame]["DamageTaken"], self.FrameAlias[frame]["DamageTakenFrame"])
        end
      end
    end
    self.FrameAlias[frame]["RecordedHealth"] = nHealth
    newHealth = true
  end

  --- Shields ----
  if nShieldMax > 0 then
    if nShieldMax ~= self.FrameAlias[frame]["RecordedShieldMax"] then
      wndShieldBar:SetMax(nShieldMax)
      self.FrameAlias[frame]["RecordedShieldMax"] = nShieldMax
    end
    if nShield ~= self.FrameAlias[frame]["RecordedShield"] then
      wndShieldBar:SetProgress(nShield)
      if not self.tSettings.bDisableEatAway then
        if frame ~= 3 then
          if nShield < self.FrameAlias[frame]["RecordedShield"] then
            local parentwidth = wndShieldBar:GetWidth()
            local difference = self.FrameAlias[frame]["RecordedShield"] / self.FrameAlias[frame]["RecordedShieldMax"]
            local start = (nShield / nShieldMax) * parentwidth
            self:DoDamageTicks(frame, parentwidth, difference, start, self.FrameAlias[frame]["ShieldDamageTaken"], self.FrameAlias[frame]["ShieldDamageTakenFrame"])
          end
        end
      end
      self.FrameAlias[frame]["RecordedShield"] = nShield
      newShield = true
    end
    if not self.FrameAlias[frame]["Shield"]:IsShown() then
      self.FrameAlias[frame]["Shield"]:Show(true)
      frameResizeNeeded = true
    end
  else
    self.FrameAlias[frame]["RecordedShield"] = 0
    if self.FrameAlias[frame]["Shield"]:IsShown() then
      self.FrameAlias[frame]["Shield"]:Show(false)
      frameResizeNeeded = true
    end
  end
  --- Absorb ---
  if nAbsorbMax > 0 then
    if nAbsorbMax ~= self.FrameAlias[frame]["RecordedAbsorbMax"] then
      wndAbsorbBar:SetMax(nAbsorbMax)
      self.FrameAlias[frame]["RecordedAbsorbMax"] = nAbsorbMax
    end
    if nAbsorb ~= self.FrameAlias[frame]["RecordedAbsorb"] then
      wndAbsorbBar:SetProgress(nAbsorb)
      if not self.tSettings.bDisableEatAway then
        if frame ~= 3 then
          if nAbsorb < self.FrameAlias[frame]["RecordedAbsorb"] then
            local parentwidth = wndAbsorbBar:GetWidth()
            local difference = self.FrameAlias[frame]["RecordedAbsorb"] / self.FrameAlias[frame]["RecordedAbsorbMax"]
            local start = (nAbsorb / nAbsorbMax) * parentwidth
            self:DoDamageTicks(frame, parentwidth, difference, start, self.FrameAlias[frame]["AbsorbDamageTaken"], self.FrameAlias[frame]["AbsorbDamageTakenFrame"])
          end
        end
      end
      self.FrameAlias[frame]["RecordedAbsorb"] = nAbsorb
      newAbsorb = true
    end

    if not self.FrameAlias[frame]["Absorb"]:IsShown() then
      self.FrameAlias[frame]["Absorb"]:Show(true)
      frameResizeNeeded = true
    end
  else
    self.FrameAlias[frame]["RecordedAbsorb"] = 0
    -- Hide absorb bar
    SHwidth = 1 -- No Absorb shown
    if self.FrameAlias[frame]["Absorb"]:IsShown() then
      self.FrameAlias[frame]["Absorb"]:Show(false)
      frameResizeNeeded = true
    end
  end


  HPwidth = 1
  SHwidth = 1


  if self.FrameAlias[frame]["Absorb"]:IsShown() and self.FrameAlias[frame]["Shield"]:IsShown() then
    SHwidth = 1 - self.tSettings.nAbsorbWidth
    HPwidth = 1 - (self.tSettings.nAbsorbWidth + self.tSettings.nShieldWidth)
  else
    if self.FrameAlias[frame]["Absorb"]:IsShown() then
      SHwidth = 1 - self.tSettings.nAbsorbWidth
      HPwidth = 1 - self.tSettings.nAbsorbWidth
    end
    if self.FrameAlias[frame]["Shield"]:IsShown() then
      HPwidth = 1 - self.tSettings.nShieldWidth
      SHwidth = 1
    end
  end

  if not self.FrameAlias[frame]["Shield"]:IsShown() and not self.FrameAlias[frame]["Absorb"]:IsShown() then
    HPwidth = 1
  end
  local mirrored = (frame == 2 and self.tSettings.bMirroredTargetFrame)


  if (frameResizeNeeded or self.frameResizeNeeded) and mirrored then
    self.FrameAlias[frame]["Health"]:SetAnchorPoints(1 - HPwidth, 0, 1, 1)
    self.FrameAlias[frame]["Health"]:SetAnchorOffsets(7, 5, 2, -5)
    self.FrameAlias[frame]["Shield"]:SetAnchorPoints(1 - SHwidth, 0, 1 - HPwidth, 1)
    self.FrameAlias[frame]["Shield"]:SetAnchorOffsets(7, 5, 12, -5)
    self.FrameAlias[frame]["Absorb"]:SetAnchorPoints(0, 0, 1 - SHwidth, 1)
    self.FrameAlias[frame]["Absorb"]:SetAnchorOffsets(6, 5, 12, -5)
  elseif frameResizeNeeded or self.frameResizeNeeded then
    self.FrameAlias[frame]["Health"]:SetAnchorPoints(0, 0, HPwidth, 1)
    self.FrameAlias[frame]["Health"]:SetAnchorOffsets(10, 5, 3, -5)
    self.FrameAlias[frame]["Shield"]:SetAnchorPoints(HPwidth, 0, SHwidth, 1)
    self.FrameAlias[frame]["Shield"]:SetAnchorOffsets(-2, 5, 2, -5)
    self.FrameAlias[frame]["Absorb"]:SetAnchorPoints(SHwidth, 0, 1, 1)
    self.FrameAlias[frame]["Absorb"]:SetAnchorOffsets(-2, 5, 2, -5)
  end





  --- Target of Target ---
  if self.tSettings.bShowToT and frame ~= 1 then
    local target = unit:GetTarget()
    if target ~= nil then
      local health = target:GetHealth() or 0
      local healthMax = target:GetMaxHealth() or 0
      local shield = target:GetShieldCapacity() or 0
      local shieldMax = target:GetShieldCapacityMax() or 0
      local absorb = target:GetAbsorptionValue() or 0
      local absorbMax = target:GetAbsorptionMax() or 0
      if target ~= self.FrameAlias[frame]["TargetUnit"] then --new target, need to setup buffs
      self.FrameAlias[frame]["ToTWindow"]:Show(true)
      if self.FrameAlias[frame].Targetminihp == nil then
        self.FrameAlias[frame]["Arrow"]:SetData(target)
        self.FrameAlias[frame]["TargetName"]:SetText(self:GetFirstName(target))
        self.FrameAlias[frame]["TargetName"]:SetData(target)
        local flag = shieldMax > 0
        self.FrameAlias[frame]["MiniShieldProgressBar"]:Show(flag)
        if not flag then
          --						local l,t,r,b = self.FrameAlias[frame]["ToTWindow"]:FindChild("MiniHealth"):GetAnchorPoints()
          self.FrameAlias[frame]["ToTWindow"]:FindChild("MiniHealth"):SetAnchorPoints(0, 0, 0.8, 1)
        else
          self.FrameAlias[frame]["ToTWindow"]:FindChild("MiniHealth"):SetAnchorPoints(0, 0, 0.5, 1)
        end
        self.FrameAlias[frame]["ToTWindow"]:FindChild("MiniHealth"):SetAnchorOffsets(15, 5, 0, -5)

        if self.tSettings.bShowToTDebuffs == 2 then
          self.FrameAlias[frame]["ToTHarmBuffBar"]:SetUnit(target)
        end
      end
      end

      self.FrameAlias[frame]["TargetUnit"] = target
      if health ~= self.FrameAlias[frame]["ToTRecordedHealth"] or 0 then
        self.FrameAlias[frame]["MiniHealthFrame"]:SetText(self:StrForNum(health, healthMax, false, false))
        self.FrameAlias[frame]["MiniHealthProgressBar"]:SetProgress(health / healthMax)
        self.FrameAlias[frame]["ToTRecordedHealth"] = health
      end
      if shield ~= self.FrameAlias[frame]["ToTRecordedShield"] or 0 then
        self.FrameAlias[frame]["MiniShieldFrame"]:SetText(self:StrForNum(shield, shieldMax, false, false))
        self.FrameAlias[frame]["MiniShieldProgressBar"]:SetProgress(shield / shieldMax)
        self.FrameAlias[frame]["ToTRecordedShield"] = shield
      end
      if absorb ~= self.FrameAlias[frame]["ToTRecordedAbsorb"] or 0 then
        local strAbsorb = self:StrForNum(absorb, absorbMax, true, true)
        self.FrameAlias[frame]["MiniAbsorbFrame"]:SetText(strAbsorb)
        self.FrameAlias[frame]["MiniAbsorbProgressBar"]:SetProgress(absorb / absorbMax)
        self.FrameAlias[frame]["ToTRecordedAbsorb"] = absorb
      end

      if absorb > 0 and not self.FrameAlias[frame]["MiniAbsorbProgressBar"]:GetParent():IsShown() then
        self.FrameAlias[frame]["MiniAbsorbProgressBar"]:GetParent():Show(true)
      elseif absorb <= 0 and self.FrameAlias[frame]["MiniAbsorbProgressBar"]:GetParent():IsShown() then
        self.FrameAlias[frame]["MiniAbsorbProgressBar"]:GetParent():Show(false)
      end



    elseif target == nil then
      if self.FrameAlias[frame]["ToTWindow"]:IsShown() then
        self.FrameAlias[frame]["ToTWindow"]:Show(false)
      end
      if self.FrameAlias[frame]["TargetUnit"] ~= nil then --new target, need to setup buffs
      if frame == 2 then
        self.FrameAlias[frame]["ToTHarmBuffBar"]:SetUnit(nil)
      end
      self.FrameAlias[frame]["TargetUnit"] = target
      self.FrameAlias[frame]["Arrow"]:SetData(target)
      self.FrameAlias[frame]["TargetName"]:SetData(target)
      end
    end
  end

  --- Bar Labeling ---

  if newHealth then
    local strHealth
    if nHealthMax > 0 then
      strHealth = self:StrForNum(nHealth, nHealthMax, true)
    else
      strHealth = ""
    end
    self.FrameAlias[frame]["HealthFrame"]:SetText(strHealth)
  end
  if newShield then
    local strShield = self:StrForNum(nShield, nShieldMax, true)
    self.FrameAlias[frame]["ShieldFrame"]:SetText(strShield)
  end
  if newAbsorb then
    local strAbsorb = self:StrForNum(nAbsorb, nAbsorbMax, true, true)
    self.FrameAlias[frame]["AbsorbFrame"]:SetText(strAbsorb)
  end
  --- Raid Marker ---
  local nMarkerId = unit:GetTargetMarker() or 0

  if self.FrameAlias[frame]["RaidMarker"] ~= nMarkerId then
    self.FrameAlias[frame]["RaidMarkerIcon"]:SetSprite(kstrRaidMarkerToSprite[nMarkerId])
    self.FrameAlias[frame]["RaidMarker"] = nMarkerId
  end
  -- Check for CC Armor
  local newCCArmor = false
  if nCCArmorValue ~= self.FrameAlias[frame]["CCArmorValue"] then
    self.FrameAlias[frame]["CCArmorValue"] = nCCArmorValue
    self:CCArmorCheck(frame, nCCArmorValue, nCCArmorMax)
  end
  if nCCArmorMax ~= self.FrameAlias[frame]["CCArmorMax"] then
    self.FrameAlias[frame]["CCArmorMax"] = nCCArmorMax
    self:CCArmorCheck(frame, nCCArmorValue, nCCArmorMax)
  end


  if self.tSettings.bShowCastBar then
    if self.Frames[frame] == self.targetFrame then
      if fvulnerabletime > 0 then
        self:UpdateVunerableTimes(fvulnerabletime, frame)
      else
        if self.fOldVulnerable[frame] > 0 then
          self.targetFrame:FindChild("CastBar"):SetBarColor(self:GetCastBarColor(unit))
          self.fOldVulnerable[frame] = 0
        end
        self.fvulnerableMax[frame] = 0
        self:PrepCastBars(unit, frame, nCCArmorValue, nCCArmorMax)
        if frame == 1 then self:SpecialCastBarUpdate() end
        self:UpdateCastBar(unit, frame)
      end
    else
      if frame == 1 then unit = self.player self:SpecialCastBarUpdate() end
      self:PrepCastBars(unit, frame, nCCArmorValue, nCCArmorMax)
      self:UpdateCastBar(unit, frame)
    end
  end
end


function KuronaFrames:StrForNum(num, numMax, bigFrame, numsonly)
  if num == nil then return 0 end
  if not self.tSettings.bUsePercentages or numsonly then
    if num > 1000 then
      strNum = self:HelperFormatBigNumber(num)
    else
      strNum = num
    end
  elseif self.tSettings.bValueAndPercentage and bigFrame then
    if num > 1000 then
      strNum = self:HelperFormatBigNumber(num)
    else
      strNum = num
    end
    strNum = strNum .. " (" .. self:GetFPercentage(num, numMax) .. ")"
  else
    strNum = self:GetFPercentage(num, numMax)
  end
  return strNum
end


function KuronaFrames:SetupPetFrame()
  local petframe = self.FrameAlias[1]["PetFrame"]

  petframe:DestroyChildren()

  for i = 1, 2 do
    local petxml = Apollo.LoadForm(self.xmlDoc, "NewPetForm", petframe, self)
    self:HideFrameBorders(petxml, self.tSettings.bShowFrameBorders)
    petxml:FindChild("MiniHealthProgressBar"):SetFillSprite(self:GetBarType("normal"))
    petxml:FindChild("MiniHealthProgressBar"):SetFullSprite(self:GetBarType("normal"))
    petxml:FindChild("MiniShieldProgressBar"):SetFillSprite(self:GetBarType("normal"))
    petxml:FindChild("MiniShieldProgressBar"):SetFullSprite(self:GetBarType("normal"))
  end
  petframe:ArrangeChildrenVert()

  if GameLib.GetPlayerUnit():GetClassId() == GameLib.CodeEnumClass.Engineer then
    local petmenu = Apollo.LoadForm(self.xmlDoc, "EngineerPetButton", petframe, self)
    self.playerFrame:FindChild("PetBtn"):SetCheck(true)
    self.playerFrame:FindChild("StanceMenuOpenerBtn"):AttachWindow(self.playerFrame:FindChild("StanceMenuBG"))
    for idx = 1, 5 do
      self.playerFrame:FindChild("Stance" .. idx):SetData(idx)
    end
  end

  if self.player:GetClassId() == GameLib.CodeEnumClass.Engineer then
    local petbtn = petframe:FindChild("EngineerPetButton")
    petbtn:Show(true)
  end

  for i = 1, 2 do
    self["PetRecordedName" .. i] = nil
    self["PetRecordedHealth" .. i] = nil
    self["PetRecordedShield" .. i] = nil
  end
  self:SwapFrameBorders(petframe, self.tSettings.bShowFrameBorders, self.tSettings.nStyle)
end


function KuronaFrames:UpdatePetFrame()
  if not self.tSettings.bShowPetFrame then
    if self.FrameAlias[1].PetFrame:IsShown() then
      self.FrameAlias[1].PetFrame:Show(false)
    end
    return
  end

  local tPlayerPets = GameLib.GetPlayerPets()
  local petframe = self.FrameAlias[1].PetFrame

  local validPets = 0
  local PetTable = {}
  for k, pet in ipairs(tPlayerPets) do
    local healthMax = pet:GetMaxHealth() or 0
    if healthMax ~= 0 then
      table.insert(PetTable, pet)
    end
  end

  tPlayerPets = PetTable

  for k, pet in ipairs(tPlayerPets) do
    local pHealth = self:GetFPercentage(pet:GetHealth(), pet:GetMaxHealth())
    local frame = petframe:GetChildren()[k]

    local health = pet:GetHealth() or 0
    local healthMax = pet:GetMaxHealth() or 0
    local shield = pet:GetShieldCapacity() or 0
    local shieldMax = pet:GetShieldCapacityMax() or 0

    if pet:GetName() ~= self["PetRecordedName" .. k] then
      -- new pet
      frame:FindChild("PetName"):SetText(pet:GetName())
      frame:Show(true)
      frame:FindChild("PetName"):SetData(pet)
      frame:SetData(pet)
      self["PetRecordedName" .. k] = pet:GetName()

      local flag = shieldMax > 0
      local shieldbar = petframe:GetChildren()[k]:FindChild("MiniShieldProgressBar")

      shieldbar:Show(flag)
      if not flag then
        frame:FindChild("MiniHealth"):SetAnchorPoints(0, 0, 1, 1)
      else
        frame:FindChild("MiniHealth"):SetAnchorPoints(0, 0, 0.5, 1)
      end
      frame:FindChild("MiniHealth"):SetAnchorOffsets(0, 0, 3, 0)

      --frame:FindChild("MiniHSAWindow"):Show(healthMax ~= 0)
    end

    if health ~= self["PetRecordedHealth" .. k] then
      local healthbar = petframe:GetChildren()[k]:FindChild("MiniHealthProgressBar")
      healthbar:GetChildren()[1]:SetText(self:StrForNum(health, healthMax))
      healthbar:SetProgress(health / healthMax)
      self["PetRecordedHealth" .. k] = health
    end

    if shield ~= self["PetRecordedShield" .. k] then
      local shieldbar = petframe:GetChildren()[k]:FindChild("MiniShieldProgressBar")
      shieldbar:GetChildren()[1]:SetText(self:StrForNum(shield, shieldMax))
      shieldbar:SetProgress(shield / shieldMax)
      self["PetRecordedShield" .. k] = shield
    end

    if not petframe:GetChildren()[k]:IsShown() then
      petframe:GetChildren()[k]:Show(true)
    end

    if k == 2 then break end
  end

  if self.player:GetClassId() == GameLib.CodeEnumClass.Engineer then
    local petbtn = petframe:FindChild("EngineerPetButton")
    petbtn:Show(true)
  end

  if #tPlayerPets == 0 then
    if petframe:IsShown() then petframe:Show(false) end
    return
  elseif not petframe:IsShown() then petframe:Show(true)
  end

  if #tPlayerPets < 2 then
    if petframe:GetChildren()[2]:IsShown() then
      petframe:GetChildren()[2]:Show(false)
    end
  end
end


function KuronaFrames:OnGenerateBuffTooltip(wndHandler, wndControl, tType, splBuff)
  if wndHandler == wndControl or self.player == nil then
    return
  end
  if self.Started then
    Tooltip.GetBuffTooltipForm(self, wndControl, splBuff, { bFutureSpell = false })
  end
end


function KuronaFrames:OnSave(eLevel, backup)

  if eLevel ~= GameLib.CodeEnumAddonSaveLevel.Character then return end

  local tsave = {}
  --tsave = self.tSettings
  --Style
  tsave.nStyle = self.tSettings.nStyle
  tsave.bMirroredTargetFrame = self.tSettings.bMirroredTargetFrame
  -- Options Window
  tsave.cPopL, tsave.cPopT = self.PopUp:GetAnchorOffsets()
  -- Player Frame Position
  tsave.cFrameL, tsave.cFrameT, tsave.cFrameR, tsave.cFrameB = self.playerFrame:GetAnchorOffsets()
  tsave.cHPFrameL, tsave.cHPFrameT, tsave.cHPFrameR, tsave.cHPFrameB = self.FrameAlias[1]["LargeFrame"]:GetAnchorOffsets()
  -- Target Frame Position
  tsave.cTFrameL, tsave.cTFrameT, tsave.cTFrameR, tsave.cTFrameB = self.targetFrame:GetAnchorOffsets()
  tsave.cTHPFrameL, tsave.cTHPFrameT, tsave.cTHPFrameR, tsave.cTHPFrameB = self.FrameAlias[2]["LargeFrame"]:GetAnchorOffsets()
  -- Focus Frame Position
  tsave.cFFrameL, tsave.cFFrameT, tsave.cFFrameR, tsave.cFFrameB = self.focusFrame:GetAnchorOffsets()
  tsave.cFHPFrameL, tsave.cFHPFrameT, tsave.cFHPFrameR, tsave.cFHPFrameB = self.FrameAlias[3]["LargeFrame"]:GetAnchorOffsets()
  -- Pet Frame Position
  tsave.cPetFrameL, tsave.cPetFrameT, tsave.cPetFrameR, tsave.cPetFrameB = self.playerFrame:FindChild("PetFrame"):GetAnchorOffsets()
  -- Cluster Frame Position
  tsave.ClusterFrameL, tsave.ClusterFrameT, tsave.ClusterFrameR, tsave.ClusterFrameB = self.targetFrame:FindChild("PetFrame"):GetAnchorOffsets()

  -- Threat Frame Position
  tsave.cThreatFrameL, tsave.cThreatFrameT, tsave.cThreatFrameR, tsave.cThreatFrameB = self.targetFrame:FindChild("Threat"):GetAnchorOffsets()

  --Alert Window
  tsave.cAlertWinL, tsave.cAlertWinT, tsave.cAlertWinR, tsave.cAlertWinB = self.AlertWindow:GetAnchorOffsets()
  --ProximityCast
  tsave.cProxL, tsave.cProxT, tsave.cProxR, tsave.cProxB = self.ProximityCastForm:GetAnchorOffsets()
  --Focus Bar
  if self.FocusBar then
    tsave.cFocusBarL, tsave.cFocusBarT, tsave.cFocusBarR, tsave.cFocusBarB = self.FocusBar:GetAnchorOffsets()
  end
  if self.PsiPointDisplay then
    tsave.cPsiPointsL, tsave.cPsiPointsT, tsave.cPsiPointsR, tsave.cPsiPointsB = self.PsiPointDisplay:GetAnchorOffsets()
  end

  --Sprint meter
  if self.tSettings.bVerticalSprint then
    tsave.cVSprintL, tsave.cVSprintT, tsave.cVSprintR, tsave.cVSprintB = self.sprint:GetAnchorOffsets()
    tsave.cVDashL, tsave.cVDashT, tsave.cVDashR, tsave.cVDashB = self.dashes:GetAnchorOffsets()
    tsave.cSprintL = self.tSettings.cSprintL
    tsave.cSprintT = self.tSettings.cSprintT
    tsave.cSprintR = self.tSettings.cSprintR
    tsave.cSprintB = self.tSettings.cSprintB
    tsave.cDashL = self.tSettings.cDashL
    tsave.cDashT = self.tSettings.cDashT
    tsave.cDashR = self.tSettings.cDashR
    tsave.cDashB = self.tSettings.cDashB
  else
    tsave.cSprintL, tsave.cSprintT, tsave.cSprintR, tsave.cSprintB = self.sprint:GetAnchorOffsets()
    tsave.cDashL, tsave.cDashT, tsave.cDashR, tsave.cDashB = self.dashes:GetAnchorOffsets()

    tsave.cVSprintL = self.tSettings.cVSprintL
    tsave.cVSprintT = self.tSettings.cVSprintT
    tsave.cVSprintR = self.tSettings.cVSprintR
    tsave.cVSprintB = self.tSettings.cVSprintB
    tsave.cVDashL = self.tSettings.cVDashL
    tsave.cVDashT = self.tSettings.cVDashT
    tsave.cVDashR = self.tSettings.cVDashR
    tsave.cVDashB = self.tSettings.cVDashB
  end
  --Hazard meter
  tsave.cHazardL, tsave.cHazardT, tsave.cHazardR, tsave.cHazardB = self.HazardBar:GetAnchorOffsets()


  --CastBar Bar Offsets
  tsave.cPCastL, tsave.cPCastT, tsave.cPCastR, tsave.cPCastB = self.playerFrame:FindChild("CastFrame"):GetAnchorOffsets()
  tsave.cTCastL, tsave.cTCastT, tsave.cTCastR, tsave.cTCastB = self.targetFrame:FindChild("CastFrame"):GetAnchorOffsets()
  tsave.cFCastL, tsave.cFCastT, tsave.cFCastR, tsave.cFCastB = self.focusFrame:FindChild("CastFrame"):GetAnchorOffsets()
  --Player Buffs
  tsave.cPBBarL, tsave.cPBBarT, tsave.cPBBarR, tsave.cPBBarB = self.playerFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()
  tsave.cPDBarL, tsave.cPDBarT, tsave.cPDBarR, tsave.cPDBarB = self.playerFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()
  --Target Buffs
  tsave.cTBBarL, tsave.cTBBarT, tsave.cTBBarR, tsave.cTBBarB = self.targetFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()
  tsave.cTDBarL, tsave.cTDBarT, tsave.cTDBarR, tsave.cTDBarB = self.targetFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()
  --Focus Buffs
  tsave.cFBBarL, tsave.cFBBarT, tsave.cFBBarR, tsave.cFBBarB = self.focusFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()
  tsave.cFDBarL, tsave.cFDBarT, tsave.cFDBarR, tsave.cFDBarB = self.focusFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()

  --Player Resources
  tsave.cResourcesL, tsave.cResourcesT, tsave.cResourcesR, tsave.cResourcesB = self.Resources:GetAnchorOffsets()

  tsave.bUseGenericResources = self.tSettings.bUseGenericResources

  tsave.sAlertCast = self.tSettings.sAlertCast
  tsave.bPercentDecimals = self.tSettings.bPercentDecimals
  tsave.sAlertCC = self.tSettings.sAlertCC

  tsave.bShowSpellPower = self.tSettings.bShowSpellPower

  -- Newest Positions

  --Markers
  tsave.cPlayerMarkerL, tsave.cPlayerMarkerT, tsave.cPlayerMarkerR, tsave.cPlayerMarkerB = self.playerFrame:FindChild("Markers"):GetAnchorOffsets()
  tsave.cTargetMarkerL, tsave.cTargetMarkerT, tsave.cTargetMarkerR, tsave.cTargetMarkerB = self.targetFrame:FindChild("Markers"):GetAnchorOffsets()
  tsave.cFocusMarkerL, tsave.cFocusMarkerT, tsave.cFocusMarkerR, tsave.cFocusMarkerB = self.focusFrame:FindChild("Markers"):GetAnchorOffsets()

  tsave.cFClassIconL, tsave.cFClassIconT, tsave.cFClassIconR, tsave.cFClassIconB = self.focusFrame:FindChild("ClassIconBase"):GetAnchorOffsets()
  tsave.cTClassIconL, tsave.cTClassIconT, tsave.cTClassIconR, tsave.cTClassIconB = self.targetFrame:FindChild("ClassIconBase"):GetAnchorOffsets()
  tsave.cPClassIconL, tsave.cPClassIconT, tsave.cPClassIconR, tsave.cPClassIconB = self.playerFrame:FindChild("ClassIconBase"):GetAnchorOffsets()

  --Names
  tsave.cPlayerNameL, tsave.cPlayerNameT, tsave.cPlayerNameR, tsave.cPlayerNameB = self.playerFrame:FindChild("UnitName"):GetAnchorOffsets()
  tsave.cTargetNameL, tsave.cTargetNameT, tsave.cTargetNameR, tsave.cTargetNameB = self.targetFrame:FindChild("UnitName"):GetAnchorOffsets()
  tsave.cFocusNameL, tsave.cFocusNameT, tsave.cFocusNameR, tsave.cFocusNameB = self.focusFrame:FindChild("UnitName"):GetAnchorOffsets()

  --Target of Target
  tsave.cTTotL, tsave.cTTotT, tsave.cTTotR, tsave.cTTotB = self.FrameAlias[2]["ToTWindow"]:GetAnchorOffsets()
  tsave.cFTotL, tsave.cFTotT, tsave.cFTotR, tsave.cFTotB = self.FrameAlias[3]["ToTWindow"]:GetAnchorOffsets()

  -- Alert Window
  tsave.AlertList = self.AlertWindowEditBox:GetText()
  tsave.ProximityIgnore = self.ProxIgnoreEditBox:GetText()

  tsave.nProxRangeGroup = self.tSettings.nProxRangeGroup
  tsave.nProxRangeSolo = self.tSettings.nProxRangeSolo

  tsave.nLineThickness = self.tSettings.nLineThickness

  --Bar widths
  tsave.nShieldWidth = self.tSettings.nShieldWidth
  tsave.nAbsorbWidth = self.tSettings.nAbsorbWidth

  tsave.bAlertSound = self.tSettings.bAlertSound
  tsave.bAlertNames = self.tSettings.bAlertNames
  tsave.bAlertWindow = self.tSettings.bAlertWindow
  tsave.bCCAlertWindow = self.tSettings.bCCAlertWindow
  -- Booleans
  tsave.bShowToT = self.tSettings.bShowToT
  --	tsave.bShowToTHP =	self.tSettings.bShowToTHP
  tsave.bShowToTDebuffs = self.tSettings.bShowToTDebuffs
  tsave.bShowCastBar = self.tSettings.bShowCastBar
  tsave.bUsePercentages = self.tSettings.bUsePercentages
  tsave.bShowClassIcons = self.tSettings.bShowClassIcons
  tsave.bAutoHideFrame = self.tSettings.bAutoHideFrame
  tsave.bAutoHideName = self.tSettings.bAutoHideName
  tsave.bShowThreatMeter = self.tSettings.bShowThreatMeter
  tsave.bSmoothCastBar = self.tSettings.bSmoothCastBar
  tsave.bShowFocusBuffs = self.tSettings.bShowFocusBuffs
  tsave.bShowSpellIcon = self.tSettings.bShowSpellIcon
  tsave.bShowResources = self.tSettings.bShowResources
  tsave.bShowCarbineResources = self.tSettings.bShowCarbineResources
  tsave.bDisplayFocus = self.tSettings.bDisplayFocus
  tsave.bShowLevels = self.tSettings.bShowLevels
  tsave.bEnableSprint = self.tSettings.bEnableSprint
  tsave.bVerticalSprint = self.tSettings.bVerticalSprint
  tsave.bAutoHideSprint = self.tSettings.bAutoHideSprint
  tsave.bDisableEatAway = self.tSettings.bDisableEatAway
  tsave.bFlashInterrupt = self.tSettings.bFlashInterrupt
  tsave.bShowPetFrame = self.tSettings.bShowPetFrame
  tsave.bShowClusterFrame = self.tSettings.bShowClusterFrame
  tsave.bFirstNamesOnly = self.tSettings.bFirstNamesOnly
  tsave.bFocusAsPercent = self.tSettings.bFocusAsPercent
  tsave.bShowBuffBars = self.tSettings.bShowBuffBars
  tsave.bAutoHideResources = self.tSettings.bAutoHideResources
  tsave.bEsperTA = self.tSettings.bEsperTA
  tsave.bStalkerTA = self.tSettings.bStalkerTA
  tsave.bShowHazard = self.tSettings.bShowHazard
  tsave.bProxmityCast = self.tSettings.bProxmityCast
  tsave.bTrackCharges = self.tSettings.bTrackCharges
  tsave.bShowPsiPoints = self.tSettings.bShowPsiPoints
  tsave.bTrackMentalOverflow = self.tSettings.bTrackMentalOverflow

  tsave.bLineToTarget = self.tSettings.bLineToTarget
  tsave.bLineToFocus = self.tSettings.bLineToFocus
  tsave.bLineToSubdue = self.tSettings.bLineToSubdue
  tsave.TLineColor = self.tSettings.TLineColor
  tsave.FLineColor = self.tSettings.FLineColor
  tsave.SLineColor = self.tSettings.SLineColor
  tsave.AlertColor = self.tSettings.AlertColor
  tsave.bLineOutlines = self.tSettings.bLineOutlines
  tsave.bLineDistances = self.tSettings.bLineDistances
  tsave.BasicResourceColor = self.tSettings.BasicResourceColor
  tsave.bEsperTAOpacity = self.tSettings.bEsperTAOpacity
  tsave.bAlertWindow = self.tSettings.bAlertWindow
  tsave.InTheZoneColor = self.tSettings.InTheZoneColor
  tsave.AuxCastColor = self.tSettings.AuxCastColor
  tsave.ImpaleColor = self.tSettings.ImpaleColor

  tsave.nCastbarOpacity = self.tSettings.nCastbarOpacity
  tsave.nBarOpacity = self.tSettings.nBarOpacity or 90
  tsave.bShowMountInfo = self.tSettings.bShowMountInfo
  tsave.bValueAndPercentage = self.tSettings.bValueAndPercentage
  --colors
  tsave.FNameColor = self.tSettings.FNameColor
  tsave.HNameColor = self.tSettings.HNameColor
  tsave.NNameColor = self.tSettings.NNameColor

  tsave.FCastColor = self.tSettings.FCastColor
  tsave.HCastColor = self.tSettings.HCastColor
  tsave.NCastColor = self.tSettings.NCastColor
  tsave.sFrameColor = self.tSettings.sFrameColor
  tsave.ICastColor = self.tSettings.ICastColor

  tsave.DashSquareColor = self.tSettings.DashSquareColor
  tsave.SprintSquareColor = self.tSettings.SprintSquareColor

  tsave.HCSquareColor = self.tSettings.HCSquareColor
  tsave.SCSquareColor = self.tSettings.SCSquareColor
  tsave.ACSquareColor = self.tSettings.ACSquareColor
  tsave.woundSquareColor = self.tSettings.woundSquareColor
  tsave.criticalSquareColor = self.tSettings.criticalSquareColor

  tsave.bShowFrameBorders = self.tSettings.bShowFrameBorders
  tsave.BGSquareColor = self.tSettings.BGSquareColor

  --Buff Groups
  tsave.PlayerBuffRight = self.tSettings.PlayerBuffRight
  tsave.TargetBuffRight = self.tSettings.TargetBuffRight
  tsave.FocusBuffRight = self.tSettings.FocusBuffRight
  tsave.bMatchFocus = self.tSettings.bMatchFocus
  tsave.LostFocusName = self.tSettings.LostFocusName

  --Fonts
  tsave.BarFont = self.tSettings.BarFont
  tsave.CastBarFont = self.tSettings.CastBarFont
  tsave.NameFont = self.tSettings.NameFont
  tsave.ToTNameFont = self.tSettings.ToTNameFont
  tsave.MiniBarFont = self.tSettings.MiniBarFont

  --Fonts
  tsave.PlayerBarFont = self.tSettings.PlayerBarFont
  tsave.PlayerCastBarFont = self.tSettings.PlayerCastBarFont
  tsave.PlayerNameFont = self.tSettings.PlayerNameFont
  tsave.TargetBarFont = self.tSettings.TargetBarFont
  tsave.TargetCastBarFont = self.tSettings.TargetCastBarFont
  tsave.TargetNameFont = self.tSettings.TargetNameFont
  tsave.FocusBarFont = self.tSettings.FocusBarFont
  tsave.FocusCastBarFont = self.tSettings.FocusCastBarFont
  tsave.FocusNameFont = self.tSettings.FocusNameFont

  tsave.TargetToTNameFont = self.tSettings.TargetToTNameFont
  tsave.TargetMiniBarFont = self.tSettings.TargetMiniBarFont
  tsave.FocusToTNameFont = self.tSettings.FocusToTNameFont
  tsave.FocusMiniBarFont = self.tSettings.FocusMiniBarFont

  --Backup Settings
  if backup == nil then
    if self.SavedSettings1 ~= nil then
      tsave.SavedSettings1 = {}
      for k, v in pairs(self.SavedSettings1) do
        tsave.SavedSettings1[k] = v
      end
    end
    if self.SavedSettings2 ~= nil then
      tsave.SavedSettings2 = {}
      for k, v in pairs(self.SavedSettings2) do
        tsave.SavedSettings2[k] = v
      end
    end
    Apollo.SetConsoleVariable("hud.ResourceBarDisplay", 1)
  end
  return tsave
end


function KuronaFrames:DefaultTable()
  local defaultsettings = {
    nStyle = 2,
    cPopL = 20,
    cPopT = 20,
    --Player Frame
    cFrameL = -425,
    cFrameT = -377,
    cFrameR = -15,
    cFrameB = -156,
    cHPFrameL = 33,
    cHPFrameT = 120,
    cHPFrameR = 320,
    cHPFrameB = 170,
    --Target Frame
    cTFrameL = 85,
    cTFrameT = -377,
    cTFrameR = 495,
    cTFrameB = -156,
    cTHPFrameL = 33,
    cTHPFrameT = 120,
    cTHPFrameR = 320,
    cTHPFrameB = 170,
    -- Focus Frame
    cFFrameL = -124,
    cFFrameT = -108,
    cFFrameR = 126,
    cFFrameB = 122,
    cFHPFrameL = 31,
    cFHPFrameT = 126,
    cFHPFrameR = 227,
    cFHPFrameB = 171,
    --Pet Frame
    cPetFrameL = 27,
    cPetFrameT = 205,
    cPetFrameR = 276,
    cPetFrameB = 280,
    --Cluster Frame
    ClusterFrameL = 167,
    ClusterFrameT = 205,
    ClusterFrameR = 416,
    ClusterFrameB = 280,

    -- Player Cast Bar
    cFocusBarL = -75,
    cFocusBarT = 0,
    cFocusBarR = 75,
    cFocusBarB = 40,

    -- ProximityCast
    cProxL = -150,
    cProxT = -390,
    cProxR = 150,
    cProxB = -320,


    -- Player Cast Bar
    cPCastL = 50,
    cPCastT = 181,
    cPCastR = 259,
    cPCastB = 204,
    -- Target Cast Bar
    cTCastL = 50,
    cTCastT = 181,
    cTCastR = 259,
    cTCastB = 204,
    -- Focus Cast Bar
    cFCastL = 50,
    cFCastT = 180,
    cFCastR = 215,
    cFCastB = 205,
    -- Threat Meter
    cThreatFrameL = 1,
    cThreatFrameT = 33,
    cThreatFrameR = 182,
    cThreatFrameB = 97,
    -- Sprint Meter
    cSprintL = -60,
    cSprintT = 255,
    cSprintR = 60,
    cSprintB = 290,
    cVSprintL = -100,
    cVSprintT = -75,
    cVSprintR = -40,
    cVSprintB = 75,
    -- Dash Tokens
    cDashL = -50,
    cDashT = 0,
    cDashR = 50,
    cDashB = 26,
    cVDashL = -5,
    cVDashT = -10,
    cVDashR = 35,
    cVDashB = 10,

    --Player Buff Bar
    cPBBarL = 45,
    cPBBarT = 95,
    cPBBarR = 400,
    cPBBarB = 130,
    --Player DebufBar
    cPDBarL = 45,
    cPDBarT = 60,
    cPDBarR = 400,
    cPDBarB = 95,
    --Target Buff Bar
    cTBBarL = 45,
    cTBBarT = 95,
    cTBBarR = 400,
    cTBBarB = 130,
    --Target DebufBar
    cTDBarL = 45,
    cTDBarT = 60,
    cTDBarR = 400,
    cTDBarB = 95,
    --Focus Buff Bar
    cFBBarL = 45,
    cFBBarT = 100,
    cFBBarR = 240,
    cFBBarB = 130,
    --Focus DebufBar
    cFDBarL = 45,
    cFDBarT = 70,
    cFDBarR = 240,
    cFDBarB = 100,
    -- Resources,
    cResourcesL = 320,
    cResourcesT = 185,
    cResourcesR = 520,
    cResourcesB = 235,
    --Esper Psi Points
    cPsiPointsL = -25,
    cPsiPointsT = -90,
    cPsiPointsR = 25,
    cPsiPointsB = -40,
    bUseGenericResources = false,
    -- Target line
    bLineToTarget = false,
    bLineToFocus = false,
    bLineToSubdue = false,
    --Markers
    cPlayerMarkerL = -2,
    cPlayerMarkerT = 102,
    cPlayerMarkerR = 51,
    cPlayerMarkerB = 187,
    cTargetMarkerL = -2,
    cTargetMarkerT = 102,
    cTargetMarkerR = 51,
    cTargetMarkerB = 187,
    cFocusMarkerL = -4,
    cFocusMarkerT = 103,
    cFocusMarkerR = 43,
    cFocusMarkerB = 188,

    --ClassIcon


    cPClassIconL = 14,
    cPClassIconT = 49,
    cPClassIconR = 45,
    cPClassIconB = 79,
    cTClassIconL = 14,
    cTClassIconT = 49,
    cTClassIconR = 45,
    cTClassIconB = 79,
    cFClassIconL = 14,
    cFClassIconT = 49,
    cFClassIconR = 45,
    cFClassIconB = 79,


    --Names
    cPlayerNameL = 45,
    cPlayerNameT = 159,
    cPlayerNameR = 298,
    cPlayerNameB = 185,
    cTargetNameL = 45,
    cTargetNameT = 159,
    cTargetNameR = 298,
    cTargetNameB = 185,
    cFocusNameL = 42,
    cFocusNameT = 159,
    cFocusNameR = 245,
    cFocusNameB = 185,

    --Target of Target
    cTTotL = 316,
    cTTotT = 101,
    cTTotR = 498,
    cTTotB = 180,
    cFTotL = 221,
    cFTotT = 104,
    cFTotR = 393,
    cFTotB = 183,

    --Alert
    bAlertWindow = true,
    bCCAlertWindow = true,
    bAlertSound = true,
    bAlertNames = false,
    cAlertWinL = -170,
    cAlertWinT = 45,
    cAlertWinR = 170,
    cAlertWinB = 100,
    sAlertCast = Sound.PlayUIQueuePopsAdventure,
    sAlertCC = Sound.PlayUICraftingOverchargeWarning,


    -- Hazard
    cHazardL = 0,
    cHazardT = 20,
    cHazardR = 200,
    cHazardB = 60,
    bPercentDecimals = false,
    nProxRangeGroup = 150,
    nProxRangeSolo = 30,

    -- Booleans
    bMirroredTargetFrame = false,
    bShowToT = true,
    --		bShowToTHP = true,
    bShowToTDebuffs = false,
    bShowCastBar = true,
    bShowClassIcons = true,
    bUsePercentages = false,
    bAutoHideFrame = false,
    bAutoHideName = false,
    bShowThreatMeter = false,
    bSmoothCastBar = true,
    bShowFocusBuffs = false,
    bShowSpellIcon = true,
    bShowResources = true,
    bShowCarbineResources = false,
    bDisplayFocus = true,
    bShowSpellTimeIcon = false,
    nBarOpacity = 90,
    nCastbarOpacity = 90,
    bDisableEatAway = false,
    bShowMountInfo = true,
    bEsperTA = true,
    bStalkerTA = false,
    bEsperTAOpacity = 80,
    bTrackCharges = false,
    bShowPsiPoints = true,
    bTrackMentalOverflow = false,
    bShowLevels = false,
    bShowFrameBorders = true,
    sFrameColor = "ff000000",
    bValueAndPercentages = false,
    bEnableSprint = true,
    bAutoHideSprint = true,
    bVerticalSprint = false,
    bShowPetFrame = true,
    bShowClusterFrame = false,
    bFirstNamesOnly = false,
    bFocusAsPercent = true,
    bShowBuffBars = true,
    bMatchFocus = true,
    LostFocusName = "ValidTarget",
    bAutoHideResources = true,
    bShowHazard = true,


    --- Colors
    FCastColor = "ff2956B2",
    NCastColor = ApolloColor.new("DispositionNeutral"),
    HCastColor = ApolloColor.new("DispositionHostile"),
    ICastColor = "Green",
    FNameColor = "ffffffff",
    NNameColor = ApolloColor.new("DispositionNeutral"),
    HNameColor = ApolloColor.new("DispositionHostile"),
    HCSquareColor = "ff00ffff",
    SCSquareColor = "ff0080ff",
    ACSquareColor = "xkcdAmber",
    SprintSquareColor = "Green",
    DashSquareColor = "xkcdOrange",
    BGSquareColor = "00000000",
    InTheZoneColor = "xkcdVividGreen",
    AuxCastColor = "ff00ffff",
    ImpaleColor = "ffff0000",
    woundSquareColor = "ffffff00",
    criticalSquareColor = "ffff0000",
    FLineColor = "ff00ff00",
    TLineColor = "ffff00ff",
    SLineColor = "ff0000ff",
    AlertColor = "ffff8040",
    BasicResourceColor = "xkcdOrange",
    nLineThickness = 2,
    PlayerBuffRight = false,
    TargetBuffRight = false,
    FocusBuffRight = false,
    bFlashInterrupt = true,
    bShowSpellPower = false,

    -- Alert Window
    AlertList = "Superquake\nRupture\nGenetic Torrent\n",
    ProximityIgnore = "",
    nAbsorbWidth = 0.10,
    nShieldWidth = 0.25,

    --Fonts
    PlayerBarFont = "CRB_InterfaceMedium_BBO",
    PlayerCastBarFont = "CRB_Interface10_O",
    PlayerNameFont = "CRB_Interface11_BBO",
    TargetBarFont = "CRB_InterfaceMedium_BBO",
    TargetCastBarFont = "CRB_Interface10_O",
    TargetNameFont = "CRB_Interface11_BBO",
    FocusBarFont = "CRB_InterfaceMedium_BBO",
    FocusCastBarFont = "CRB_Interface10_O",
    FocusNameFont = "CRB_Interface11_BBO",
    TargetToTNameFont = "Nameplates",
    TargetMiniBarFont = "CRB_InterfaceMedium_BBO",
    FocusToTNameFont = "Nameplates",
    FocusMiniBarFont = "CRB_InterfaceMedium_BBO"
  }



  self.DefaultBuffs = true


  if self.player ~= nil then
    eClassId = self.player:GetClassId()
    if eClassId == GameLib.CodeEnumClass.Spellslinger then
      defaultsettings.cResourcesB = 245
    elseif eClassId == GameLib.CodeEnumClass.Stalker then
      defaultsettings.cResourcesB = 230
    end
  end

  self.defaultsettings = defaultsettings

  return defaultsettings
end


function KuronaFrames:OnRestore(eLevel, saveData)
  if eLevel ~= GameLib.CodeEnumAddonSaveLevel.Character then return end

  self.tSettings = {}
  local defaultsettings = self:DefaultTable()

  for k, v in pairs(saveData) do
    self.tSettings[k] = v
  end

  for k, v in pairs(defaultsettings) do
    if self.tSettings[k] == nil then
      self.tSettings[k] = v
    end
  end

  self.backupSettings = {}
  for k, v in pairs(saveData) do
    self.backupSettings[k] = v
  end

  if self.tSettings.SavedSettings1 ~= nil then
    self.SavedSettings1 = {}
    for k, v in pairs(self.tSettings.SavedSettings1) do
      self.SavedSettings1[k] = v
    end
  end
  if self.tSettings.SavedSettings2 ~= nil then
    self.SavedSettings2 = {}
    for k, v in pairs(self.tSettings.SavedSettings2) do
      self.SavedSettings2[k] = v
    end
  end
end


function KuronaFrames:RestoreSettings(table)

  for k, v in pairs(table) do
    self.tSettings[k] = v
  end
  self.frameResizeNeeded = true
  self:SetFramePositions()
  self:ProcessBuffBarChanges()
  self:FillOptionsWindow()
  self:OnSettingChange()
  self:SetOptionColorPanel()
  self:SetFonts()
  if self.bEditMode then
    self:FillEditMode()
  end
end


function KuronaFrames:SaveRestoreSettings(table)
  for k, v in pairs(self.tSettings) do
    newtable[k] = v
  end

  self:SetFramePositions()
  self:FillOptionsWindow()
  self:OnSettingChange()
  self:SetFonts()

  if self.bEditMode then
    self:FillEditMode()
  end
end


function KuronaFrames:OnMouseButtonDown(wndHandler, wndControl, eMouseButton, x, y)
  if self.bEditMode then return end
  local control = wndHandler:GetName()
  local unit = wndHandler:GetData()
  if eMouseButton == GameLib.CodeEnumInputMouse.Left and unit ~= nil then
    if control == "HSAWindow" then return false end
    if control == "NewPetForm" then return false end
    GameLib.SetTargetUnit(unit)
    return false
  end
  if eMouseButton == GameLib.CodeEnumInputMouse.Right and unit ~= nil then
    Event_FireGenericEvent("GenericEvent_NewContextMenuPlayerDetailed", nil, unit:GetName(), unit)
    if not unit:IsValid() then
      self.player:SetAlternateTarget(unit)
      self.tSettings.LostFocusName = "NoTarget"
    end
    return true
  end
  return false
end


function KuronaFrames:OnFocusSlashCommand()
  local unitTarget = GameLib.GetTargetUnit()
  self.player:SetAlternateTarget(unitTarget)
  self.tSettings.LostFocusName = "ValidTarget"
end


function KuronaFrames:OnCharacterLoaded()
  self.frameResizeNeeded = true
  if GameLib.GetPlayerUnit() == nil then return end
  self.player = GameLib.GetPlayerUnit()
  self.playerRaceId = self.player:GetRaceId()

  self.playerFrame:FindChild("BeneBuffBar"):SetUnit(GameLib.GetPlayerUnit())
  self.playerFrame:FindChild("HarmBuffBar"):SetUnit(GameLib.GetPlayerUnit())
  if self.player ~= nil then
    self:CreateResources(self.player)

    self:SetupPetFrame()
    self:SetupClusterFrame()
    self:SetFramePositions()
    self:FillOptionsWindow()
    self:SetFonts()
    self:FillAllFrames()

    self:CreateBuffBars()
    self:ChangeFrameBorders(self.tSettings.nStyle)

    local s = Apollo.GetString(1)

    if s == "Annuler" then
      self.WeaponName = "Arme de (%S+)" .. self.player:GetName()
    elseif s == "Abbrechen" then
      self.WeaponName = "Waffe von " .. self.player:GetName()
    else
      self.WeaponName = self.player:GetName() .. "'s Weapon"
    end
    --		Print(self.WeaponName)
  end
end


function KuronaFrames:FillAllFrames()
  self:FillFrame(self.player, 1)
  self:OnTargetUnitChanged(GameLib.GetTargetUnit())
  if GameLib.GetPlayerUnit() ~= nil then
    self:OnAlternateTargetUnitChanged(self.player:GetAlternateTarget())
  end
end


function KuronaFrames:OnTargetUnitChanged(unitTarget)
  self.ThreatColor = nil
  self.ThreatLevel = nil

  self.Target = unitTarget
  self.FrameAlias[2]["CastFrame"]:Show(false)
  self.FrameAlias[2]["RecordedName"] = ""
  self.FrameAlias[2]["RecordedHealth"] = -9999
  self.FrameAlias[2]["RecordedShield"] = -9999
  self.frameResizeNeeded = true
  --	self.FrameAlias[frame]["RecordedHealth"]
  self.TarCastName = nil
  if unitTarget == nil then return end
  self:FillFrame(unitTarget, 2)
  self.targetFrame:FindChild("BeneBuffBar"):SetUnit(unitTarget)
  self.targetFrame:FindChild("HarmBuffBar"):SetUnit(unitTarget)
  if self.tSettings.bShowToTDebuffs then
    local totUnit = unitTarget:GetTarget()
    self.targetFrame:FindChild("ToTHarmBuffBar"):SetUnit(totUnit)
  else
    self.targetFrame:FindChild("ToTHarmBuffBar"):SetUnit(nil)
  end
end


function KuronaFrames:OnAlternateTargetUnitChanged(unitTarget)
  self.FocusTarget = unitTarget
  self.FocCastName = nil
  self.FrameAlias[3]["CastFrame"]:Show(false)
  self.FrameAlias[3]["RecordedName"] = ""
  self.FrameAlias[3]["RecordedHealth"] = -9999
  self.FrameAlias[3]["RecordedShield"] = -9999
  if unitTarget == nil then return end


  self:FillFrame(unitTarget, 3)
  self.focusFrame:Show(true)
  if self.tSettings.bShowFocusBuffs then
    self.focusFrame:FindChild("BeneBuffBar"):SetUnit(unitTarget)
    self.focusFrame:FindChild("HarmBuffBar"):SetUnit(unitTarget)
  else
    self.focusFrame:FindChild("BeneBuffBar"):SetUnit(nil)
    self.focusFrame:FindChild("HarmBuffBar"):SetUnit(nil)
  end

  if self.tSettings.bShowToTDebuffs then
    local totUnit = unitTarget:GetTarget()
    self.targetFrame:FindChild("ToTHarmBuffBar"):SetUnit(totUnit)
  else
    self.targetFrame:FindChild("ToTHarmBuffBar"):SetUnit(nil)
  end
end


function KuronaFrames:GetNamePlateColor(unitTarget)
  if unitTarget == nil then return end

  local eDisposition = unitTarget:GetDispositionTo(self.player)
  return self.karDispositionColors[eDisposition]
end


function KuronaFrames:GetCastBarColor(unitTarget)
  if unitTarget == nil then return end

  local eDisposition = unitTarget:GetDispositionTo(self.player)
  return self.karCastbarDispositionColors[eDisposition]
end


function KuronaFrames:FillFrame(unit, frame)
  if unit == nil then return end
  local eDisposition = unit:GetDispositionTo(self.player)
  local crColorToUse = self.karDispositionColors[eDisposition]

  self.Frames[frame]:Show(true)
  self.Frames[frame]:FindChild("HSAWindow"):SetData(unit)
  self.FrameAlias[frame]["UnitName"]:SetTextColor(crColorToUse)
  self.FrameAlias[frame]["UnitName"]:SetData(unit)
  self.FrameAlias[frame]["RecordedName"] = ""
  self.FrameAlias[frame]["UnitName"]:SetText(self:GetFirstName(unit))
  self.Frames[frame]:FindChild("ClassIcon"):SetData(unit)
  self.FrameAlias[frame]["CastBar"]:SetBarColor(self:GetCastBarColor(unit))
  self.FrameAlias[frame]["CastColor"] = self:GetCastBarColor(unit)
  if self.tSettings.bShowToTDebuffs and frame ~= 1 then
    local focus = self.player:GetAlternateTarget()
    local target = self.player:GetTarget()
    if target ~= nil then
      self.targetFrame:FindChild("ToTHarmBuffBar"):SetUnit(target:GetTarget())
    else
      self.targetFrame:FindChild("ToTHarmBuffBar"):SetUnit(nil)
    end
    if focus ~= nil then
      self.focusFrame:FindChild("ToTHarmBuffBar"):SetUnit(focus:GetTarget())
    else
      self.focusFrame:FindChild("ToTHarmBuffBar"):SetUnit(nil)
    end
  end


  -- Class Icon is based on player class or NPC rank
  if self.tSettings.bShowClassIcons then
    local strClassIconSprite = ""
    local strPlayerIconSprite = ""
    local eRank = unit:GetRank()
    if unit:GetType() == "Player" then
      strPlayerIconSprite = karClassToIcon[unit:GetClassId()]
      self.Frames[frame]:FindChild("ClassIcon"):SetSprite(strPlayerIconSprite)
      self.Frames[frame]:FindChild("MobRank"):Show(false)
    else
      self.Frames[frame]:FindChild("MobRank"):Show(true)
      if eRank == Unit.CodeEnumRank.Elite then
        strClassIconSprite = "spr_TargetFrame_ClassIcon_Elite"
      elseif eRank == Unit.CodeEnumRank.Superior then
        strClassIconSprite = "spr_TargetFrame_ClassIcon_Superior"
      elseif eRank == Unit.CodeEnumRank.Champion then
        strClassIconSprite = "spr_TargetFrame_ClassIcon_Champion"
      elseif eRank == Unit.CodeEnumRank.Standard then
        strClassIconSprite = "spr_TargetFrame_ClassIcon_Standard"
      elseif eRank == Unit.CodeEnumRank.Minion then
        strClassIconSprite = "spr_TargetFrame_ClassIcon_Minion"
      elseif eRank == Unit.CodeEnumRank.Fodder then
        strClassIconSprite = "spr_TargetFrame_ClassIcon_Fodder"
      end
      if eRank < 6 then
        local strRank = String_GetWeaselString(Apollo.GetString("TargetFrame_CreatureRank"), ktRankDescriptions[eRank][2])
        strTooltipRank = self:HelperBuildTooltip(strRank, ktRankDescriptions[eRank][1])
        self.Frames[frame]:FindChild("MobRank"):SetTooltip(strTooltipRank)
      end
      self.Frames[frame]:FindChild("ClassIcon"):SetSprite(strPlayerIconSprite)
      self.Frames[frame]:FindChild("MobRank"):SetSprite(strClassIconSprite)
    end
  end
end


function KuronaFrames:Defaults()
end


function KuronaFrames:GetFPercentage(nArg1, nArg2)
  if nArg1 == nil or nArg2 == nil then
    local strError = ""
    return strError
  end
  if nArg2 == 0 then
    sResult = " "
    return sResult
  end

  local percentage = nArg1 / nArg2 * 100
  local nResult
  if self.tSettings.bPercentDecimals then


    local shift = 10 ^ 1
    nResult = math.floor(percentage * shift + 0.5) / shift
  else
    nResult = math.floor(percentage)
  end

  return nResult .. "%"
end


function KuronaFrames:HelperFormatBigNumber(nArg)
  local strResult = nArg
  if nArg < 1000 then
    strResult = nArg
  elseif nArg < 1000000 then
    strResult = tostring(math.floor(nArg / 100 + 0.5) * 0.1) .. "k"
  elseif nArg > 1000000 then
    strResult = tostring(math.floor(nArg / 100000 + 0.5) * 0.1) .. "m"
  else
    strResult = tostring(nArg)
  end
  return strResult
end


function KuronaFrames:onBuffWindowMove(wndHandler, wndControl)
  if wndHandler == self.playerFrame:FindChild("BeneBuffBar") then
    local l, t, r, b = self.playerFrame:FindChild("LargeFrame"):GetAnchorOffsets()
    local BenLeft, BenTop, BenRight, BenBot = self.playerFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()
    self.PlayerBBOffset = t - BenTop
    self.PlayerBLBOffset = l - BenLeft
  elseif wndHandler == self.playerFrame:FindChild("HarmBuffBar") then
    local l, t, r, b = self.targetFrame:FindChild("LargeFrame"):GetAnchorOffsets()
    local HarmLeft, HarmTop, HarmRight, HarmBot = self.playerFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()
    self.PlayerHBOffset = t - HarmTop
    self.PlayerHLBOffset = l - HarmLeft
  elseif wndHandler == self.targetFrame:FindChild("BeneBuffBar") then
    local l, t, r, b = self.targetFrame:FindChild("LargeFrame"):GetAnchorOffsets()
    local BenLeft, BenTop, BenRight, BenBot = self.targetFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()
    self.TargetBBOffset = t - BenTop
    self.TargetBLBOffset = l - BenLeft
  elseif wndHandler == self.targetFrame:FindChild("HarmBuffBar") then
    local l, t, r, b = self.targetFrame:FindChild("LargeFrame"):GetAnchorOffsets()
    local HarmLeft, HarmTop, HarmRight, HarmBot = self.targetFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()

    self.TargetHBOffset = t - HarmTop
    self.TargetHLBOffset = l - HarmLeft
  end
  self:SaveBuffBarPositions()
end


function KuronaFrames:OnLargeFrameResize(wndHandler, wndControl)

  if self.Frames[1] == nil then return end

  local tWindow = wndHandler:GetParent()
  local frame = 0
  if tWindow == self.playerFrame then
    local l, t, r, b = wndHandler:GetAnchorOffsets()
    local HarmLeft, HarmTop, HarmRight, HarmBot = self.playerFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()
    local BenLeft, BenTop, BenRight, BenBot = self.playerFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()

    local newHarmTop = t - self.PlayerHBOffset
    local newHarmBot = newHarmTop - (HarmTop - HarmBot)
    local newHarmLeft = l - self.PlayerHLBOffset
    local newHarmRight = newHarmLeft - (HarmLeft - HarmRight)

    local newBenTop = t - self.PlayerBBOffset
    local newBenBot = newBenTop - (BenTop - BenBot)
    local newBenLeft = l - self.PlayerBLBOffset
    local newBenRight = newBenLeft - (BenLeft - BenRight)

    self.playerFrame:FindChild("HarmBuffBar"):SetAnchorOffsets(newHarmLeft, newHarmTop, newHarmRight, newHarmBot)
    self.playerFrame:FindChild("BeneBuffBar"):SetAnchorOffsets(newBenLeft, newBenTop, newBenRight, newBenBot)


  elseif tWindow == self.targetFrame then
    local l, t, r, b = wndHandler:GetAnchorOffsets()
    local HarmLeft, HarmTop, HarmRight, HarmBot = self.targetFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()
    local BenLeft, BenTop, BenRight, BenBot = self.targetFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()

    local newHarmTop = t - self.TargetHBOffset
    local newHarmBot = newHarmTop - (HarmTop - HarmBot)
    local newHarmLeft = l - self.TargetHLBOffset
    local newHarmRight = newHarmLeft - (HarmLeft - HarmRight)

    local newBenTop = t - self.TargetBBOffset
    local newBenBot = newBenTop - (BenTop - BenBot)
    local newBenLeft = l - self.TargetBLBOffset
    local newBenRight = newBenLeft - (BenLeft - BenRight)

    self.targetFrame:FindChild("HarmBuffBar"):SetAnchorOffsets(newHarmLeft, newHarmTop, newHarmRight, newHarmBot)
    self.targetFrame:FindChild("BeneBuffBar"):SetAnchorOffsets(newBenLeft, newBenTop, newBenRight, newBenBot)
  end
  --	self:SaveBuffBarPositions()
end

function KuronaFrames:SaveBuffBarPositions()
  --Start by grabbing offsets for buff bars
  local l, t, r, b = self.playerFrame:FindChild("LargeFrame"):GetAnchorOffsets()
  local HarmLeft, HarmTop, HarmRight, HarmBot = self.playerFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()
  local BenLeft, BenTop, BenRight, BenBot = self.playerFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()

  self.PlayerHBOffset = t - HarmTop
  self.PlayerBBOffset = t - BenTop
  self.PlayerHLBOffset = l - HarmLeft
  self.PlayerBLBOffset = l - BenLeft

  local l, t, r, b = self.targetFrame:FindChild("LargeFrame"):GetAnchorOffsets()
  local HarmLeft, HarmTop, HarmRight, HarmBot = self.targetFrame:FindChild("HarmBuffBar"):GetAnchorOffsets()
  local BenLeft, BenTop, BenRight, BenBot = self.targetFrame:FindChild("BeneBuffBar"):GetAnchorOffsets()

  self.TargetHBOffset = t - HarmTop
  self.TargetBBOffset = t - BenTop
  self.TargetHLBOffset = l - HarmLeft
  self.TargetBLBOffset = l - BenLeft
end


function KuronaFrames:SetFramePositions()
  self:SaveBuffBarPositions()

  self.playerFrame:SetAnchorOffsets(self.tSettings.cFrameL, self.tSettings.cFrameT, self.tSettings.cFrameR, self.tSettings.cFrameB)
  self.playerFrame:FindChild("LargeFrame"):SetAnchorOffsets(self.tSettings.cHPFrameL, self.tSettings.cHPFrameT, self.tSettings.cHPFrameR, self.tSettings.cHPFrameB)
  self.targetFrame:SetAnchorOffsets(self.tSettings.cTFrameL, self.tSettings.cTFrameT, self.tSettings.cTFrameR, self.tSettings.cTFrameB)
  self.targetFrame:FindChild("LargeFrame"):SetAnchorOffsets(self.tSettings.cTHPFrameL, self.tSettings.cTHPFrameT, self.tSettings.cTHPFrameR, self.tSettings.cTHPFrameB)

  self.focusFrame:SetAnchorOffsets(self.tSettings.cFFrameL, self.tSettings.cFFrameT, self.tSettings.cFFrameR, self.tSettings.cFFrameB)
  self.focusFrame:FindChild("LargeFrame"):SetAnchorOffsets(self.tSettings.cFHPFrameL, self.tSettings.cFHPFrameT, self.tSettings.cFHPFrameR, self.tSettings.cFHPFrameB)

  if self.tSettings.bVerticalSprint then
    self.sprint:SetAnchorOffsets(self.tSettings.cVSprintL, self.tSettings.cVSprintT, self.tSettings.cVSprintR, self.tSettings.cVSprintB)
    self.dashes:SetAnchorOffsets(self.tSettings.cVDashL, self.tSettings.cVDashT, self.tSettings.cVDashR, self.tSettings.cVDashB)
  else
    self.sprint:SetAnchorOffsets(self.tSettings.cSprintL, self.tSettings.cSprintT, self.tSettings.cSprintR, self.tSettings.cSprintB)
    self.dashes:SetAnchorOffsets(self.tSettings.cDashL, self.tSettings.cDashT, self.tSettings.cDashR, self.tSettings.cDashB)
  end
  --	local nHeight = self.focusFrame:GetHeight()
  --	local nWidth = self.focusFrame:GetWidth()

  self.playerFrame:FindChild("PetFrame"):SetAnchorOffsets(self.tSettings.cPetFrameL, self.tSettings.cPetFrameT, self.tSettings.cPetFrameR, self.tSettings.cPetFrameB)

  self.FrameAlias[2].ClusterFrame:SetAnchorOffsets(self.tSettings.ClusterFrameL, self.tSettings.ClusterFrameT, self.tSettings.ClusterFrameR, self.tSettings.ClusterFrameB)



  self.targetFrame:FindChild("Threat"):SetAnchorOffsets(self.tSettings.cThreatFrameL, self.tSettings.cThreatFrameT, self.tSettings.cThreatFrameR, self.tSettings.cThreatFrameB)

  self.Resources:SetAnchorOffsets(self.tSettings.cResourcesL, self.tSettings.cResourcesT, self.tSettings.cResourcesR, self.tSettings.cResourcesB)

  self.HazardBar:SetAnchorOffsets(self.tSettings.cHazardL, self.tSettings.cHazardT, self.tSettings.cHazardR, self.tSettings.cHazardB)

  self.ProximityCastForm:SetAnchorOffsets(self.tSettings.cProxL, self.tSettings.cProxT, self.tSettings.cProxR, self.tSettings.cProxB)

  if self.FocusBar then
    self.FocusBar:SetAnchorOffsets(self.tSettings.cFocusBarL, self.tSettings.cFocusBarT, self.tSettings.cFocusBarR, self.tSettings.cFocusBarB)
  end
  -- Position Castbars
  self.playerFrame:FindChild("CastFrame"):SetAnchorOffsets(self.tSettings.cPCastL, self.tSettings.cPCastT, self.tSettings.cPCastR, self.tSettings.cPCastB)
  self.targetFrame:FindChild("CastFrame"):SetAnchorOffsets(self.tSettings.cTCastL, self.tSettings.cTCastT, self.tSettings.cTCastR, self.tSettings.cTCastB)
  self.focusFrame:FindChild("CastFrame"):SetAnchorOffsets(self.tSettings.cFCastL, self.tSettings.cFCastT, self.tSettings.cFCastR, self.tSettings.cFCastB)

  -- Position Buff Bars
  self.playerFrame:FindChild("BeneBuffBar"):SetAnchorOffsets(self.tSettings.cPBBarL, self.tSettings.cPBBarT, self.tSettings.cPBBarR, self.tSettings.cPBBarB)
  self.playerFrame:FindChild("HarmBuffBar"):SetAnchorOffsets(self.tSettings.cPDBarL, self.tSettings.cPDBarT, self.tSettings.cPDBarR, self.tSettings.cPDBarB)

  self.targetFrame:FindChild("BeneBuffBar"):SetAnchorOffsets(self.tSettings.cTBBarL, self.tSettings.cTBBarT, self.tSettings.cTBBarR, self.tSettings.cTBBarB)
  self.targetFrame:FindChild("HarmBuffBar"):SetAnchorOffsets(self.tSettings.cTDBarL, self.tSettings.cTDBarT, self.tSettings.cTDBarR, self.tSettings.cTDBarB)

  self.focusFrame:FindChild("BeneBuffBar"):SetAnchorOffsets(self.tSettings.cFBBarL, self.tSettings.cFBBarT, self.tSettings.cFBBarR, self.tSettings.cFBBarB)
  self.focusFrame:FindChild("HarmBuffBar"):SetAnchorOffsets(self.tSettings.cFDBarL, self.tSettings.cFDBarT, self.tSettings.cFDBarR, self.tSettings.cFDBarB)

  if self.tSettings.bShowSpellIcon then
    self.playerFrame:FindChild("SpellIcon"):Show(true)
    self.targetFrame:FindChild("SpellIcon"):Show(true)
    self.focusFrame:FindChild("SpellIcon"):Show(true)
  else
    self.playerFrame:FindChild("SpellIcon"):Show(false)
    self.targetFrame:FindChild("SpellIcon"):Show(false)
    self.focusFrame:FindChild("SpellIcon"):Show(false)
  end

  if self.tSettings.bShowCarbineResources then
    Apollo.SetConsoleVariable("hud.ResourceBarDisplay", 1)
  else
    Apollo.SetConsoleVariable("hud.ResourceBarDisplay", 2)
  end

  --Markers
  self.playerFrame:FindChild("Markers"):SetAnchorOffsets(self.tSettings.cPlayerMarkerL, self.tSettings.cPlayerMarkerT, self.tSettings.cPlayerMarkerR, self.tSettings.cPlayerMarkerB)
  self.targetFrame:FindChild("Markers"):SetAnchorOffsets(self.tSettings.cTargetMarkerL, self.tSettings.cTargetMarkerT, self.tSettings.cTargetMarkerR, self.tSettings.cTargetMarkerB)
  self.focusFrame:FindChild("Markers"):SetAnchorOffsets(self.tSettings.cFocusMarkerL, self.tSettings.cFocusMarkerT, self.tSettings.cFocusMarkerR, self.tSettings.cFocusMarkerB)
  --Icons
  self.focusFrame:FindChild("ClassIconBase"):SetAnchorOffsets(self.tSettings.cFClassIconL, self.tSettings.cFClassIconT, self.tSettings.cFClassIconR, self.tSettings.cFClassIconB)
  self.targetFrame:FindChild("ClassIconBase"):SetAnchorOffsets(self.tSettings.cTClassIconL, self.tSettings.cTClassIconT, self.tSettings.cTClassIconR, self.tSettings.cTClassIconB)
  self.playerFrame:FindChild("ClassIconBase"):SetAnchorOffsets(self.tSettings.cPClassIconL, self.tSettings.cPClassIconT, self.tSettings.cPClassIconR, self.tSettings.cPClassIconB)
  --Names
  self.playerFrame:FindChild("UnitName"):SetAnchorOffsets(self.tSettings.cPlayerNameL, self.tSettings.cPlayerNameT, self.tSettings.cPlayerNameR, self.tSettings.cPlayerNameB)
  self.targetFrame:FindChild("UnitName"):SetAnchorOffsets(self.tSettings.cTargetNameL, self.tSettings.cTargetNameT, self.tSettings.cTargetNameR, self.tSettings.cTargetNameB)
  self.focusFrame:FindChild("UnitName"):SetAnchorOffsets(self.tSettings.cFocusNameL, self.tSettings.cFocusNameT, self.tSettings.cFocusNameR, self.tSettings.cFocusNameB)

  --Target of Target
  self.FrameAlias[2]["ToTWindow"]:SetAnchorOffsets(self.tSettings.cTTotL, self.tSettings.cTTotT, self.tSettings.cTTotR, self.tSettings.cTTotB)
  self.FrameAlias[3]["ToTWindow"]:SetAnchorOffsets(self.tSettings.cFTotL, self.tSettings.cFTotT, self.tSettings.cFTotR, self.tSettings.cFTotB)

  --Alert Window
  self.AlertWindow:SetAnchorOffsets(self.tSettings.cAlertWinL, self.tSettings.cAlertWinT, self.tSettings.cAlertWinR, self.tSettings.cAlertWinB)


  -- Opacity
  self:SetBarAlpha(self.tSettings.nBarOpacity / 100, self.tSettings.nCastbarOpacity / 100)

  if self.PsiPointDisplay and self.player:GetClassId() == 3 then
    self.PsiPointDisplay:SetAnchorOffsets(self.tSettings.cPsiPointsL, self.tSettings.cPsiPointsT, self.tSettings.cPsiPointsR, self.tSettings.cPsiPointsB)
  end
end


function KuronaFrames:OnThreatUpdated(...)
  local bar1 = self.FrameAlias[2]["PlayerThreatProgressBar"]
  local barframe = self.FrameAlias[2]["Threat"]
  local tbarframe = self.FrameAlias[2]["TopThreat"]

  if select(1, ...) == nil then
    if select(1, ...) ~= self.ThreatLevel then
      bar1:SetProgress(0)
      self.ThreatLevel = 0
    end
    if barframe:IsShown() then
      barframe:Show(false)
    end
    return
  end
  if not self.ThreatWindow:IsShown() then
    self.ThreatWindow:Show(true)
  end

  local player = self.player
  local topThreatUnit = select(1, ...)
  local nTopThreat = select(2, ...)

  if topThreatUnit == player then --Player is highest Threat?
  if select(3, ...) ~= nil then -- Is there someone next on threat?
  local NextTopThreat = select(3, ...)
  local nSecondThreat = select(4, ...)
  local percentage = math.floor((nTopThreat / nSecondThreat) * 100)
  bar1:SetProgress(percentage)
  if percentage > 200 then
    --bar1:SetText(percentage.."%")
    bar1:SetText("UltraThreat")
  else
    bar1:SetText(percentage .. "%")
  end
  if percentage >= 100 and self.ThreatColor ~= "ffffffff" then
    bar1:SetBarColor("ffffffff")
    self.ThreatColor = "ffffffff"
  elseif percentage > 90 and self.ThreatColor ~= "ffff0000" then
    bar1:SetBarColor("ffff0000")
    self.ThreatColor = "ffff0000"
  elseif self.ThreatColor ~= "ffffff00" then
    bar1:SetBarColor("ffffff00")
    self.ThreatColor = "ffffff00"
  end

  tbarframe:SetText(self:GetFirstName(topThreatUnit) .. " has threat.")
  barframe:SetText(self:GetFirstName(NextTopThreat) .. " is next")
  barframe:Show(true)
  else -- no one else is engaged with the target
  barframe:Show(false)
  barframe:SetText("")
  tbarframe:SetText("")
  end
  else -- Ok, player is not tanking
  barframe:SetText("")
  tbarframe:SetText(self:GetFirstName(topThreatUnit) .. " has threat.")

  if select(3, ...) ~= nil then -- find out if we are 2nd in line
  if select(3, ...) == player then -- find out if we are 2nd in line
  local nSecondThreat = select(4, ...)
  local percentage = nSecondThreat / nTopThreat
  barframe:SetText("You are next!")
  if percentage > 0.90 and self.ThreatColor ~= "ffff0000" then
    bar1:SetBarColor("ffff0000")
    self.ThreatColor = "ffff0000"
  elseif self.ThreatColor ~= "ffffff00" then
    bar1:SetBarColor("ffffff00")
    self.ThreatColor = "ffffff00"
  end
  if self.ThreatLevel ~= percentage then
    bar1:SetProgress(percentage)
    self.ThreatLevel = percentage
  end
  if percentage < 0.01 then
    bar1:SetText("Low Threat")
  end
  if not barframe:IsShown() then
    barframe:Show(true)
  end
  else -- we are not 2nd in line either
  local nSecondThreat = select(3, ...)
  barframe:SetText(self:GetFirstName(nSecondThreat) .. " is next")

  for i = 3, select('#', ...), 2 do -- go thru each 2nd value to compare names
  local tUnit = select(i, ...)
  local nThreat = select(i + 1, ...)
  if tUnit == player then
    local percentage = nThreat / nTopThreat

    if percentage > 0.90 then
      bar1:SetBarColor("ffff0000")
    else
      bar1:SetBarColor("ffffff00")
    end
    if self.ThreatLevel ~= percentage then
      bar1:SetProgress(percentage)
    end
    if percentage < 0.01 then
      bar1:SetText("Low Threat")
    end
    barframe:SetText("")
    if not barframe:IsShown() then
      barframe:Show(true)
    end
  end
  end
  end
  end
  end
end


function KuronaFrames:OnNextFrame()
  local player = self.player
  if self.player == nil then return end
  local focus = self.FocusTarget
  local target = self.Target
  if self.tSettings.bShowCastBar then
    if player:IsInVehicle() then
      player = player:GetVehicle()
    end

    if player and player:IsCasting() then
      self:UpdateCastBar(player, 1)
    end

    if target and target:IsCasting() then
      self:UpdateCastBar(target, 2)
    end


    if target and target:IsValid() then
      --			Print(target:GetCCStateTimeRemaining(Unit.CodeEnumCCState.Disarm))
      fvulnerabletime = target:GetCCStateTimeRemaining(Unit.CodeEnumCCState.Vulnerability) or 0
      if fvulnerabletime > 0 then
        self:UpdateVunerableTimes(fvulnerabletime, 2)
      end
    end

    if focus and focus:IsCasting() then
      self:UpdateCastBar(focus, 3)
    end
  end

  if self.DrawnPixies then
    self.Overlay:DestroyAllPixies()
    self.DrawnPixies = false
  end
  if self.tSettings.bEsperTA and self.HasMindBurst then
    self:EsperTelegraph()
  elseif self.tSettings.bEsperTA and self.HasTKStorm then
    self:EsperStormTelegraph()
  end

  if self.tSettings.bStalkerTA and self.HasImpale then
    self:StalkerTelegraph()
  end

  if not self.bEditMode and self.tSettings.bProxmityCast and self.bCombatState then
    self:DoProximityCastbars()
  end

  if (self.tSettings.bLineToTarget and target and target:IsValid()) or (self.tSettings.bLineToFocus and focus and focus:IsValid()) or self.WeaponOnGround ~= nil then
    local pPos = GameLib.GetUnitScreenPosition(self.player)
    if pPos == nil then return end
    local anchor = self.player:GetOverheadAnchor()
    if anchor == nil then return end
    local deadzone = {
      ["feetY"] = pPos.nY or 0,
      ["raceScale"] = 1.0,
      ["scale"] = nil,
      ["nameplateY"] = 0,
    }
    if anchor ~= nil then
      deadzone.nameplateY = anchor.y or 0
    end

    deadzone.scale = (deadzone.feetY - deadzone.nameplateY) / 300 * deadzone.raceScale

    if self.WeaponOnGround ~= nil then
      self:DrawLineToTarget(self.WeaponOnGround, self.tSettings.SLineColor, pPos, deadzone, 15)
    end


    if self.tSettings.bLineToTarget and target and target ~= self.player then
      self:DrawLineToTarget(target, self.tSettings.TLineColor, pPos, deadzone, self.tSettings.nLineThickness)
    end

    if self.tSettings.bLineToFocus and focus and focus ~= self.player then
      self:DrawLineToTarget(focus, self.tSettings.FLineColor, pPos, deadzone, self.tSettings.nLineThickness)
    end
  end
end

--Most of this function lifted from Perspective addon
function KuronaFrames:DrawLineToTarget(unit, color, pPos, deadzone, lineThick)
  if unit == nil then return end
  -- Get the unit's position and vector
  local pos = unit:GetPosition()
  if pos == nil then return end
  local vec = Vector3.New(pos.x, pos.y, pos.z)
  -- Get the screen position of the unit by it's vector
  local lPos = GameLib.WorldLocToScreenPoint(vec)
  local xOffset = 0
  local yOffset = 0
  local drawLine = 1
  -- Get the length of the vector
  local xDist = lPos.x - pPos.nX
  local yDist = lPos.y - pPos.nY
  local xyDist = xDist * xDist + yDist * yDist
  local vectorLength = (xyDist ^ (-0.5)) * xyDist

  -- Get line distance offset based on angle, scale for camera position
  local lineOffsetFromCenter = self:GetLineOffsetFromCenter(yDist, vectorLength)
  if (deadzone ~= nil) then lineOffsetFromCenter = lineOffsetFromCenter * deadzone.scale end
  -- Don't draw "outside-in" lines or if the result will be less than 10 pixels long
  if (lineOffsetFromCenter + 5 < vectorLength) then
    -- Get the ratio of the line distance from the center of the screen to the vector length
    local lengthRatio = lineOffsetFromCenter / vectorLength

    -- Get the x and y offsets for the line starting point
    xOffset = lengthRatio * xDist
    yOffset = lengthRatio * yDist

    if self.tSettings.bLineOutlines then
      self.Overlay:AddPixie({
        bLine = true,
        fWidth = lineThick + 2,
        cr = "ff000000",
        loc = { fPoints = { 0, 0, 0, 0 }, nOffsets = { lPos.x, lPos.y, pPos.nX + xOffset, pPos.nY + yOffset } }
      })
    end
    self.Overlay:AddPixie({
      bLine = true,
      fWidth = lineThick,
      cr = color,
      loc = { fPoints = { 0, 0, 0, 0 }, nOffsets = { lPos.x, lPos.y, pPos.nX + xOffset, pPos.nY + yOffset } }
    })
    self.DrawnPixies = true
  end

  if self.tSettings.bLineDistances then
    local playerpos = self.player:GetPosition()
    local pvec = Vector3.New(playerpos.x, playerpos.y, playerpos.z)
    local distance = math.floor((vec - pvec):Length())
    local text = tostring(distance)
    self.Overlay:AddPixie({
      strText = text,
      strFont = "Nameplates",
      crText = "ffffffff",
      loc = { fPoints = { 0, 0, 0, 0 }, nOffsets = { lPos.x - 100, lPos.y - 80, lPos.x + 100, lPos.y + 60 } },
      flagsText = { DT_VCENTER = true, DT_CENTER = true, DT_WORDBREAK = true }
    })
    self.DrawnPixies = true
  end
end

--Whole function lifted from Perspective addon
function KuronaFrames:GetLineOffsetFromCenter(yDist, vectorLength)
  -- Avoid divide by 0
  if (vectorLength == 0) then return 0 end

  -- Get angle in radians: arcsin of opposite(yDist) / hypothenuse(vectorLength)
  local angle = math.asin(yDist / vectorLength)

  for index, item in pairs(DeadzoneAnglesLookup) do
    if (angle >= item.Rad and angle < item.NextRad) then
      local DeltaRatio = (angle - item.Rad) / item.DeltaRad
      return item.WideLength + (item.DeltaWideLength * DeltaRatio)
    end
  end

  return 0
end


function KuronaFrames:GetSpellIconByName(strSpellName)
  local tAbilities = self:GetAbilitiesList()
  if tAbilities ~= nil then
    for _, ability in pairs(tAbilities) do
      if ability.strName == strSpellName then
        return ability.tTiers[1].splObject:GetIcon()
      end
    end
  end
  return nil
end


function KuronaFrames:GetAbilitiesList()
  if self.tAbilitiesList == nil then
    self.tAbilitiesList = AbilityBook.GetAbilitiesList()
  end
  return self.tAbilitiesList
end


function KuronaFrames:UpdateFramesEditMode()
  if not self.bEditModeWindowFilled then
    self.playerFrame:Show(true)
    self:UpdateFrame(self.player, 1)
    if GameLib.GetPlayerUnit():GetTarget() == nil then
      self.targetFrame:Show(true)
      self:FillFrame(self.player, 2)
      self:UpdateFrame(GameLib.GetPlayerUnit(), 2)
    end
    if self.player:GetAlternateTarget() == nil then
      self.focusFrame:Show(true)
      self:FillFrame(self.player, 3)
      self:UpdateFrame(self.player, 3)
    end
    self:SetupPetFrame()
    self:UpdatePetFrame()
    self:FillEditMode()
  end
end


function KuronaFrames:FillEditMode()
  self:SaveBuffBarPositions()
  if self.tSettings.bAutoHideFrame then
    self.FrameAlias[1]["LargeFrame"]:Show(true)
    self.FrameAlias[1]["BeneBuffBar"]:Show(true)
    self.FrameAlias[1]["HarmBuffBar"]:Show(true)
  end
  if self.PsiPointDisplay and self.player:GetClassId() == 3 then
    self.PsiPointDisplay:Show(true)
    self.PsiPointDisplay:SetText("5")
    self.PsiPointDisplay:SetStyle("IgnoreMouse", false)
    self.PsiPointDisplay:SetStyle("Moveable", true)
    self.PsiPointDisplay:SetTooltip("PsiPoint Display - Moveable")
    self.PsiPointDisplay:SetStyle("Picture", true)
  end


  -- Threat meter
  self.targetFrame:FindChild("Threat"):Show(true)
  self.targetFrame:FindChild("Threat"):SetStyle("IgnoreMouse", false)
  self.targetFrame:FindChild("Threat"):SetStyle("Sizable", true)
  self.targetFrame:FindChild("Threat"):SetStyle("Moveable", true)
  self.targetFrame:FindChild("Threat"):SetTooltip("Threat Meter - Moveable : Sizable")
  self.targetFrame:FindChild("Threat"):SetStyle("Picture", true)
  self.targetFrame:FindChild("PlayerThreatProgressBar"):SetProgress(1)
  self.targetFrame:FindChild("PlayerThreatProgressBar"):SetBarColor("ffffffff")

  --Hazard meter
  self.HazardBar:Show(true)
  self.HazardBar:SetStyle("IgnoreMouse", false)
  self.HazardBar:SetStyle("Picture", true)
  self.HazardBar:SetStyle("Moveable", true)
  self.HazardBar:SetTooltip("Hazard Meter")
  self.HazardBar:SetStyle("Sizable", true)



  local bar = {} bar[1] = "Player" bar[2] = "Target" bar[3] = "Focus"

  for i = 1, 3 do
    -- Cast Bars
    self.FrameAlias[i]["CastFrame"]:Show(true)
    self.FrameAlias[i]["CastBar"]:SetMax(100)
    self.FrameAlias[i]["CastBar"]:SetProgress(75)
    self.FrameAlias[i]["CastName"]:SetText(bar[i] .. " Cast Spell")
    self.FrameAlias[i]["SpellTime"]:SetText("-3.2s")
    self.FrameAlias[i]["CastFrame"]:SetStyle("Sizable", true)
    self.FrameAlias[i]["CastFrame"]:SetStyle("IgnoreMouse", false)
    self.FrameAlias[i]["CastFrame"]:SetStyle("Moveable", true)
    self.FrameAlias[i]["CastFrame"]:SetTooltip(bar[i] .. " Castbar - Moveable : Sizable")
    self.FrameAlias[i]["CastFrame"]:SetStyle("Picture", true)

    -- Unit Frames
    self.Frames[i]:SetStyle("Moveable", true)
    self.Frames[i]:SetStyle("IgnoreMouse", false)
    self.Frames[i]:SetStyle("Picture", true)
    self.Frames[i]:SetTooltip(bar[i] .. " Frame - Moveable")
    self.FrameAlias[i]["UnitName"]:SetStyle("IgnoreMouse", true)

    -- Large Frame
    self.FrameAlias[i]["LargeFrame"]:SetStyle("Moveable", true)
    self.FrameAlias[i]["LargeFrame"]:SetStyle("IgnoreMouse", false)
    self.FrameAlias[i]["LargeFrame"]:SetStyle("Picture", true)
    self.FrameAlias[i]["LargeFrame"]:SetTooltip(bar[i] .. " HP - Moveable : Sizable")
    self.FrameAlias[i]["LargeFrame"]:SetStyle("Sizable", true)
  end

  for i = 1, 3 do
    -- Buff Bars
    self.FrameAlias[i]["BeneBuffBar"]:SetStyle("Picture", true)
    self.FrameAlias[i]["HarmBuffBar"]:SetStyle("Picture", true)
    self.FrameAlias[i]["BeneBuffBar"]:SetStyle("Moveable", true)
    self.FrameAlias[i]["HarmBuffBar"]:SetStyle("Moveable", true)
    self.FrameAlias[i]["BeneBuffBar"]:SetStyle("Sizable", true)
    self.FrameAlias[i]["HarmBuffBar"]:SetStyle("Sizable", true)
    self.FrameAlias[i]["BeneBuffBar"]:SetStyle("IgnoreMouse", false)
    self.FrameAlias[i]["HarmBuffBar"]:SetStyle("IgnoreMouse", false)
    self.FrameAlias[i]["BeneBuffBar"]:SetUnit(nil)
    self.FrameAlias[i]["HarmBuffBar"]:SetUnit(nil)
    self.FrameAlias[i]["HarmBuffBar"]:SetTooltip(bar[i] .. " Debuffs - Moveable : Sizable")
    self.FrameAlias[i]["BeneBuffBar"]:SetTooltip(bar[i] .. " Buffs - Moveable : Sizable")
    self.FrameAlias[i]["Arrow"]:SetStyle("IgnoreMouse", true)

    -- Markers
    self.FrameAlias[i]["Markers"]:SetStyle("IgnoreMouse", false)
    self.FrameAlias[i]["Markers"]:SetTooltip(" IA / Rank Makers - Moveable")
    self.FrameAlias[i]["Markers"]:SetStyle("Picture", true)
    self.FrameAlias[i]["Markers"]:SetStyle("Moveable", true)
    self.FrameAlias[i]["CCArmor"]:Show(true)
    -- ClassIcon
    self.FrameAlias[i]["ClassIconBase"]:SetStyle("IgnoreMouse", false)
    self.FrameAlias[i]["ClassIconBase"]:SetTooltip(" Class Icon -  Moveable : Sizable")
    self.FrameAlias[i]["ClassIconBase"]:SetStyle("Picture", true)
    self.FrameAlias[i]["ClassIconBase"]:SetStyle("Moveable", true)
    self.FrameAlias[i]["ClassIconBase"]:SetStyle("Sizable", true)

    --Names
    self.FrameAlias[i]["UnitName"]:SetStyle("IgnoreMouse", false)
    self.FrameAlias[i]["UnitName"]:SetStyle("Sizable", true)
    self.FrameAlias[i]["UnitName"]:SetTooltip("Unit Name - Moveable")
    self.FrameAlias[i]["UnitName"]:SetStyle("Moveable", true)
    self.FrameAlias[i]["UnitName"]:SetStyle("Picture", true)
  end
  --Target of Target
  for i = 2, 3 do
    self.FrameAlias[i]["ToTWindow"]:SetStyle("Moveable", true)
    self.FrameAlias[i]["ToTWindow"]:SetStyle("IgnoreMouse", false)
    self.FrameAlias[i]["ToTWindow"]:SetStyle("Picture", true)
    self.FrameAlias[i]["ToTWindow"]:SetTooltip(" Target of Target - Moveable : Sizable")
    self.FrameAlias[i]["ToTWindow"]:SetStyle("Sizable", true)
    self.FrameAlias[i]["TargetName"]:SetStyle("IgnoreMouse", true)
  end

  --Alert Window
  if self.tSettings.bAlertWindow then

    self.AlertWindow:Show(true)
    self.AlertWindow:SetStyle("IgnoreMouse", false)
    self.AlertWindow:SetStyle("Moveable", true)
    self.AlertWindow:SetTooltip("Alert Window - Moveable : Sizable")
    self.AlertWindow:SetStyle("Sizable", true)
    self.AlertWindow:FindChild("AlertWindowText"):SetText("Alert Messages")
  end

  --ProximityCast
  if self.tSettings.bProxmityCast then
    --self.ProximityCastForm:Show(true,true)
    self.ProximityCastForm:SetStyle("Picture", true)
    self.ProximityCastForm:SetStyle("IgnoreMouse", false)
    self.ProximityCastForm:SetStyle("Moveable", true)
    self.ProximityCastForm:SetTooltip("Proximity Castbars - Moveable : Sizable")
    self.ProximityCastForm:SetStyle("Sizable", true)

    for i = 1, 2 do
      self.ProximityCast.Windows[i]:Show(true, true)
      self.ProximityCast.Bars[i]:SetMax(100)
      self.ProximityCast.Bars[i]:SetProgress(75)
      self.ProximityCast.CastName[i]:SetText("Enemy Spell " .. i)
      self.ProximityCast.Icon[i]:SetText("")
      self.ProximityCast.Bars[i]:SetFillSprite(self:GetCastBarType("normal", frame))
      self.ProximityCast.Bars[i]:SetBarColor(self.tSettings.HCastColor)

      if self.tSettings.bShowSpellIcon then
        self.ProximityCast.Icon[i]:SetSprite("KuronaSprites:IABrokenAnim")
      end
    end
  end

  --Focus Meter
  if self.FocusBar and self.tSettings.bDisplayFocus then
    self.FocusBar:Show(true)
    self.FocusBar:SetStyle("IgnoreMouse", false)
    self.FocusBar:SetStyle("Picture", true)
    self.FocusBar:SetStyle("Moveable", true)
    self.FocusBar:SetTooltip("Focus Meter - Moveable : Sizable")
    self.FocusBar:SetStyle("Sizable", true)
    self.FocusBarMeter:SetText("Focus")
  end

  --Pet Frame
  self.playerFrame:FindChild("PetFrame"):Show(true)
  self.playerFrame:FindChild("PetFrame"):SetStyle("Moveable", true)
  self.playerFrame:FindChild("PetFrame"):SetStyle("Picture", true)
  self.playerFrame:FindChild("PetFrame"):SetStyle("Sizable", true)
  self.playerFrame:FindChild("PetFrame"):SetStyle("IgnoreMouse", false)
  self.playerFrame:FindChild("PetFrame"):SetTooltip("PetBar - Moveable, Sizable")
  self.playerFrame:FindChild("PetFrame"):GetChildren()[1]:FindChild("PetName"):SetStyle("IgnoreMouse", true)
  self.playerFrame:FindChild("PetFrame"):GetChildren()[2]:FindChild("PetName"):SetStyle("IgnoreMouse", true)

  --Cluster Frame
  self.FrameAlias[2].ClusterFrame:Show(true)
  self.FrameAlias[2].ClusterFrame:SetStyle("Moveable", true)
  self.FrameAlias[2].ClusterFrame:SetStyle("Picture", true)
  self.FrameAlias[2].ClusterFrame:SetStyle("Sizable", true)
  self.FrameAlias[2].ClusterFrame:SetStyle("IgnoreMouse", false)
  self.FrameAlias[2].ClusterFrame:SetTooltip("ClusterUnits - Moveable, Sizable")
  self.FrameAlias[2].ClusterFrame:GetChildren()[1]:FindChild("PetName"):SetStyle("IgnoreMouse", true)
  self.FrameAlias[2].ClusterFrame:GetChildren()[2]:FindChild("PetName"):SetStyle("IgnoreMouse", true)


  -- Show Spell Icons
  if self.tSettings.bShowSpellIcon then
    self.targetFrame:FindChild("SpellIcon"):SetSprite("KuronaSprites:IABrokenAnim")
    self.playerFrame:FindChild("SpellIcon"):SetSprite("IconSprites:Icon_SkillMind_UI_espr_crush")
    self.focusFrame:FindChild("SpellIcon"):SetSprite("KuronaSprites:IABrokenAnim")
    self.playerFrame:FindChild("SpellIcon"):Show(true)
    local l, t, r, b = self.playerFrame:FindChild("CastBar"):GetAnchorOffsets()
    local nWidth = self.playerFrame:FindChild("SpellIcon"):GetWidth()
  end


  self.Resources:SetStyle("Picture", true)
  self.Resources:SetStyle("Moveable", true)
  self.Resources:SetStyle("Sizable", true)
  self.Resources:SetStyle("IgnoreMouse", false)
  self.Resources:Show(true)
  self.Resources:SetTooltip("Player Resources - Moveable : Sizable")

  -- Resources
  local ResourceText = {}
  ResourceText[GameLib.CodeEnumClass.Warrior] = "Kinetic Energy"
  ResourceText[GameLib.CodeEnumClass.Engineer] = "Volatility"
  ResourceText[GameLib.CodeEnumClass.Esper] = "Psi Points w/ Extra Castbar"
  ResourceText[GameLib.CodeEnumClass.Medic] = "Actuators"
  ResourceText[GameLib.CodeEnumClass.Stalker] = "Suit Power"
  ResourceText[GameLib.CodeEnumClass.Spellslinger] = "Spellsurge"
  local classid = self.player:GetClassId()
  self.Resources:SetText(ResourceText[classid])

  self.sprint:Show(true)
  self.sprint:SetTooltip("Sprint Meter - Moveable : Sizable")
  self.sprint:SetStyle("Picture", true)
  self.sprint:SetStyle("Moveable", true)
  self.sprint:SetStyle("Sizable", true)
  self.sprint:SetStyle("IgnoreMouse", false)
  -- Dash Tokens
  self.dashes:Show(true)
  self.dashes:SetTooltip("Dash Tokens - Moveable : Sizable")
  self.dashes:SetStyle("Picture", true)
  self.dashes:SetStyle("Moveable", true)
  self.dashes:SetStyle("Sizable", true)
  self.dashes:SetStyle("IgnoreMouse", false)
  self.bEditModeWindowFilled = true
end


function KuronaFrames:ExitEditMode()
  self.EditModeForm:Show(false)

  if self.PsiPointDisplay and self.player:GetClassId() == 3 then
    self.PsiPointDisplay:SetText("")
    self.PsiPointDisplay:SetStyle("IgnoreMouse", true)
    self.PsiPointDisplay:SetStyle("Moveable", false)
    self.PsiPointDisplay:SetTooltip("")
    self.PsiPointDisplay:SetStyle("Picture", false)
  end

  --Threat meter
  self.targetFrame:FindChild("Threat"):Show(false)
  self.targetFrame:FindChild("Threat"):SetStyle("IgnoreMouse", true)
  self.targetFrame:FindChild("Threat"):SetStyle("Picture", false)
  self.targetFrame:FindChild("Threat"):SetStyle("Moveable", false)
  self.targetFrame:FindChild("Threat"):SetTooltip("")
  self.targetFrame:FindChild("Threat"):SetStyle("Sizable", false)

  --Hazard meter
  self.HazardBar:Show(false)
  self.HazardBar:SetStyle("IgnoreMouse", true)
  self.HazardBar:SetStyle("Picture", false)
  self.HazardBar:SetStyle("Moveable", false)
  self.HazardBar:SetTooltip("")
  self.HazardBar:SetStyle("Sizable", false)


  --Pet Frame
  self.playerFrame:FindChild("PetFrame"):Show(false)
  self.playerFrame:FindChild("PetFrame"):SetStyle("Picture", false)
  self.playerFrame:FindChild("PetFrame"):SetStyle("Moveable", false)
  self.playerFrame:FindChild("PetFrame"):SetStyle("Sizable", false)
  self.playerFrame:FindChild("PetFrame"):SetStyle("IgnoreMouse", true)
  self.targetFrame:FindChild("PetFrame"):SetTooltip("")
  self.playerFrame:FindChild("PetFrame"):GetChildren()[1]:FindChild("PetName"):SetStyle("IgnoreMouse", false)
  self.playerFrame:FindChild("PetFrame"):GetChildren()[2]:FindChild("PetName"):SetStyle("IgnoreMouse", false)

  --Clusters
  self.FrameAlias[2].ClusterFrame:Show(false)
  self.FrameAlias[2].ClusterFrame:SetStyle("Picture", false)
  self.FrameAlias[2].ClusterFrame:SetStyle("Moveable", false)
  self.FrameAlias[2].ClusterFrame:SetStyle("IgnoreMouse", true)
  self.FrameAlias[2].ClusterFrame:SetStyle("Sizable", false)
  self.FrameAlias[2].ClusterFrame:SetTooltip("")
  self.FrameAlias[2].ClusterFrame:GetChildren()[1]:FindChild("PetName"):SetStyle("IgnoreMouse", false)
  self.FrameAlias[2].ClusterFrame:GetChildren()[2]:FindChild("PetName"):SetStyle("IgnoreMouse", false)


  for i = 1, 3 do
    -- Cast Bars
    self.FrameAlias[i]["CastFrame"]:Show(false)
    self.FrameAlias[i]["CastName"]:SetText("")
    self.FrameAlias[i]["SpellTime"]:SetText("")
    self.FrameAlias[i]["CastFrame"]:SetStyle("Sizable", false)
    self.FrameAlias[i]["CastFrame"]:SetStyle("IgnoreMouse", true)
    self.FrameAlias[i]["CastFrame"]:SetStyle("Moveable", false)
    self.FrameAlias[i]["CastFrame"]:SetTooltip("")
    self.FrameAlias[i]["CastFrame"]:SetStyle("Picture", false)

    -- Unit Frames
    self.Frames[i]:SetStyle("Moveable", false)
    self.Frames[i]:SetStyle("IgnoreMouse", true)
    self.Frames[i]:SetStyle("Picture", false)
    self.Frames[i]:SetTooltip("")
    self.FrameAlias[i]["UnitName"]:SetStyle("IgnoreMouse", false)

    -- Large Frame
    self.FrameAlias[i]["LargeFrame"]:SetStyle("Moveable", false)
    self.FrameAlias[i]["LargeFrame"]:SetStyle("IgnoreMouse", true)
    self.FrameAlias[i]["LargeFrame"]:SetStyle("Picture", false)


    -- Markers
    self.FrameAlias[i]["Markers"]:SetStyle("IgnoreMouse", true)
    self.FrameAlias[i]["Markers"]:SetTooltip("")
    self.FrameAlias[i]["Markers"]:SetStyle("Picture", false)
    self.FrameAlias[i]["Markers"]:SetStyle("Moveable", false)
    self.FrameAlias[i]["CCArmor"]:Show(false)

    -- ClassIcon
    self.FrameAlias[i]["ClassIconBase"]:SetStyle("IgnoreMouse", true)
    self.FrameAlias[i]["ClassIconBase"]:SetTooltip("")
    self.FrameAlias[i]["ClassIconBase"]:SetStyle("Picture", false)
    self.FrameAlias[i]["ClassIconBase"]:SetStyle("Moveable", false)
    self.FrameAlias[i]["ClassIconBase"]:SetStyle("Sizable", false)


    --Names
    self.FrameAlias[i]["UnitName"]:SetTooltip("")
    self.FrameAlias[i]["UnitName"]:SetStyle("Picture", false)
    self.FrameAlias[i]["UnitName"]:SetStyle("Moveable", false)
    self.FrameAlias[i]["UnitName"]:SetStyle("Sizable", false)
  end
  --Target of Target
  for i = 2, 3 do
    self.FrameAlias[i]["ToTWindow"]:SetStyle("Moveable", false)
    self.FrameAlias[i]["ToTWindow"]:SetStyle("IgnoreMouse", true)
    self.FrameAlias[i]["ToTWindow"]:SetStyle("Picture", false)
    self.FrameAlias[i]["ToTWindow"]:SetTooltip("")
    self.FrameAlias[i]["ToTWindow"]:SetStyle("Sizable", false)
    self.FrameAlias[i]["TargetName"]:SetStyle("IgnoreMouse", false)
  end

  --Alert Window
  if self.tSettings.bAlertWindow then
    self.AlertWindow:Show(false)
    self.AlertWindow:SetStyle("IgnoreMouse", true)
    self.AlertWindow:SetStyle("Moveable", false)
    self.AlertWindow:SetTooltip("")
    self.AlertWindow:SetStyle("Sizable", false)
  end
  --ProximityCast
  if self.tSettings.bProxmityCast then
    --self.ProximityCastForm:Show(false)
    self.ProximityCastForm:SetStyle("Picture", false)
    self.ProximityCastForm:SetStyle("IgnoreMouse", true)
    self.ProximityCastForm:SetStyle("Moveable", false)
    self.ProximityCastForm:SetTooltip("")
    self.ProximityCastForm:SetStyle("Sizable", false)

    for i = 1, 2 do
      self.ProximityCast.Windows[i]:Show(false, false)
      self.ProximityCast.Icon[i]:SetText("")
    end
  end


  --Focus Meter
  if self.FocusBar and self.tSettings.bDisplayFocus then
    self.FocusBar:Show(false)
    self.FocusBar:SetStyle("IgnoreMouse", true)
    self.FocusBar:SetStyle("Picture", false)
    self.FocusBar:SetStyle("Moveable", false)
    self.FocusBar:SetTooltip("")
    self.FocusBar:SetStyle("Sizable", false)
  end


  local bufftarget = {}
  bufftarget[1] = self.player
  bufftarget[2] = self.player:GetTarget()

  for i = 1, 3 do
    -- Buff Bars
    self.FrameAlias[i]["BeneBuffBar"]:SetStyle("Picture", false)
    self.FrameAlias[i]["HarmBuffBar"]:SetStyle("Picture", false)
    self.FrameAlias[i]["BeneBuffBar"]:SetStyle("Moveable", false)
    self.FrameAlias[i]["HarmBuffBar"]:SetStyle("Moveable", false)
    self.FrameAlias[i]["BeneBuffBar"]:SetStyle("Sizable", false)
    self.FrameAlias[i]["HarmBuffBar"]:SetStyle("Sizable", false)
    self.FrameAlias[i]["BeneBuffBar"]:SetStyle("IgnoreMouse", true)
    self.FrameAlias[i]["HarmBuffBar"]:SetStyle("IgnoreMouse", true)
    self.FrameAlias[i]["BeneBuffBar"]:SetUnit(bufftarget[i])
    self.FrameAlias[i]["HarmBuffBar"]:SetUnit(bufftarget[i])
    self.FrameAlias[i]["HarmBuffBar"]:SetTooltip("")
    self.FrameAlias[i]["BeneBuffBar"]:SetTooltip("")
    self.FrameAlias[i]["Arrow"]:SetStyle("IgnoreMouse", false)
    --Large Frame
    self.FrameAlias[i]["LargeFrame"]:SetTooltip("")
    self.FrameAlias[i]["LargeFrame"]:SetStyle("Sizable", false)
  end


  -- Show Spell Icons
  if self.tSettings.bShowSpellIcon then
    self.targetFrame:FindChild("SpellIcon"):SetSprite("")
    self.playerFrame:FindChild("SpellIcon"):SetSprite("")
    self.focusFrame:FindChild("SpellIcon"):SetSprite("")
  end

  -- Resources
  self.Resources:SetStyle("Picture", false)
  self.Resources:SetStyle("Moveable", false)
  self.Resources:SetStyle("Sizable", false)
  self.Resources:SetStyle("IgnoreMouse", true)
  self.Resources:Show(false)
  self.Resources:SetTooltip("")

  --Misc Settings
  self.bEditModeWindowFilled = false
  self.bEditMode = false
  self.CurCastName = ""
  self.Resources:SetText("")

  self.sprint:Show(false)
  self.sprint:SetTooltip("")
  self.sprint:SetStyle("Picture", false)
  self.sprint:SetStyle("Moveable", false)
  self.sprint:SetStyle("Sizable", false)
  self.sprint:SetStyle("IgnoreMouse", true)
  --Dash Tokens
  self.dashes:Show(false)
  self.dashes:SetTooltip("")
  self.dashes:SetStyle("Picture", false)
  self.dashes:SetStyle("Moveable", false)
  self.dashes:SetStyle("Sizable", false)
  self.dashes:SetStyle("IgnoreMouse", true)
  self.FocusValue = 9999
end


function KuronaFrames:CompareCastNames(name, data)
  local strName = name:lower()
  local castTargs = {
    [1] = self.TarCastName,
    [2] = self.FocCastName,
    [3] = self.ProximityCast.Names[1],
    [4] = self.ProximityCast.Names[2],
  }

  for x = 1, #self.AlertListTable do
    if self.AlertListTable[x] ~= "" and strName == self.AlertListTable[x]:lower() then
      if not self.AlertWindow:IsShown() then
        self.AlertWindow:Show(true, false)
        self.AlertWindow:SetData(data)
        self.AlertWindow:FindChild("AlertWindowText"):SetText(name)
        if self.tSettings.bAlertSound then
          Sound.Play(self.tSettings.sAlertCast)
        end
        self.AlertCasting = true
        Apollo.StopTimer("AlertWindowGracePeriod")
        Apollo.CreateTimer("AlertWindowGracePeriod", 4, false)
        return true
      end
    end
  end
  -- This should only happen when none of the cast names match, in this case, hide the window
  --	if self.AlertWindow:IsShown() and not self:HasActiveCC() and not self.AlertCasting then
  self:EvalAlertWindow(data)
  return false
end

function KuronaFrames:EvalAlertWindow(unit)
  if self.AlertWindow:IsShown() and self.AlertWindow:GetData() == unit then
    Apollo.StopTimer("AlertWindowGracePeriod")
    Apollo.CreateTimer("AlertWindowGracePeriod", 2, false)
    self.AlertWindow:Show(false, false)
  end
end


function KuronaFrames:OnAlertWindowGracePeriod()
  self.AlertCastFrame = nil
  self.AlertCasting = false
  Apollo.StopTimer("AlertWindowGracePeriod")
  self.AlertWindow:Show(false, false)
end


function string:split(inSplitPattern, outResults)
  if not outResults then
    outResults = {}
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
  while theSplitStart do
    table.insert(outResults, string.sub(self, theStart, theSplitStart - 1))
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
  end
  table.insert(outResults, string.sub(self, theStart))
  return outResults
end

function KuronaFrames:GetPsiCharges()
  return self.PsiChargeCount
end

function KuronaFrames:AssembleOptionsMenu()
  self.CategoryList = self.PopUp:FindChild("CategoryList")
  self.OptionsList = self.PopUp:FindChild("Options")
  self:MakeCategory("Frame Styles", "StyleOptions")
  self:MakeCategory("Color Options", "ColorOptions")
  self:MakeCategory("CastBar Options", "CastBarOptions")
  self:MakeCategory("Bar Widths", "BarPositions")
  self:MakeCategory("Extra Bars", "OptionsBars")
  self:MakeCategory("Tweaks", "OptionsExtras")
  self:MakeCategory("Buff Options", "BuffOptions")
  self:MakeCategory("Sprint Options", "SprintOptions")
  self:MakeCategory("Resources", "OptionsResources")
  self:MakeCategory("Alert Window", "AlertWindowOptions")
  self:MakeCategory("Target Lines", "TargetLineOptions")
  self:MakeCategory("Font Settings", "FontOptions")
  self:MakeCategory("Save/ Load/ Export", "EditMode")
  self.OptionsList:FindChild("ImportSettingsButton"):AttachWindow(self.OptionsList:FindChild("ImportSettingsWindow"))

  self.CategoryList:ArrangeChildrenVert()
  self.CategoryList:SetRadioSel("KBCategories", 1)

  self.AlertWindowEditBox = self.PopUp:FindChild("AlertWindowEditBox")
  self.ProxIgnoreEditBox = self.PopUp:FindChild("ProxIgnoreEditBox")
end

function KuronaFrames:MakeCategory(lable, form)
  local button = Apollo.LoadForm(self.xmlDoc, "CategoryButton", self.CategoryList, self)
  local menu = Apollo.LoadForm(self.xmlDoc, form, self.OptionsList, self)
  button:GetChildren()[1]:AttachWindow(menu)
  button:GetChildren()[1]:SetText(lable)
  button:GetChildren()[1]:SetCheck(false)
end


function KuronaFrames:OnUnitCreated(unit)
  if self.tSettings.bMatchFocus and unit and unit:GetName() == self.tSettings.LostFocusName then
    if self.player then
      self.player:SetAlternateTarget(unit)
      self.tSettings.LostFocusName = "ValidTarget"
    end
  end
  if self.tSettings.bLineToSubdue and unit:GetType() == "Pickup" then
    if unit:GetName() == self.WeaponName then
      self.WeaponOnGround = unit
    end
  end
  --	Print("Created "..unit:GetName())
end


function KuronaFrames:OnUnitDestroyed(unit)
  if unit == self.WeaponOnGround then
    self.WeaponOnGround = nil
  end
  --Print("Destoryed "..unit:GetName())
end

function KuronaFrames:FillWhatsNew()
  self.PopUp:FindChild("WhatsNewEditBox"):SetText(ChangeLog)
end

--CC Alert stuffs
function KuronaFrames:OnCCApplied(code, unit)
  if not self.tSettings.bCCAlertWindow then return end

  local effects = {
    [Unit.CodeEnumCCState.Stun] = "Stunned", --0
    [Unit.CodeEnumCCState.Daze] = "Dazed", --23
    [Unit.CodeEnumCCState.Blind] = "Blinded", --15
    [Unit.CodeEnumCCState.Root] = "Rooted", --2
    [Unit.CodeEnumCCState.Disarm] = "Disarmed", -- 3
    [Unit.CodeEnumCCState.Knockdown] = "Knockdown", --8
    [Unit.CodeEnumCCState.Disorient] = "Disorient", --11
    [Unit.CodeEnumCCState.Tether] = "Tethered", --20
    [Unit.CodeEnumCCState.Subdue] = "Disarmed", --24
  }

  if unit == self.player and effects[code] then
    self.ActiveCC[code] = true
    self.AlertWindow:FindChild("AlertWindowText"):SetText(effects[code])
    self.AlertWindow:Show(true, true)
    if self.tSettings.bAlertSound then
      Sound.Play(self.tSettings.sAlertCC)
    end
  end
end

function KuronaFrames:HasActiveCC()
  for k, v in pairs(self.ActiveCC) do
    return true
  end
  --[[[
	if self.AlertCasting then
		return true
	end
	]]
  return false
end

function KuronaFrames:OnCCRemove(code, unit)
  if not self.tSettings.bCCAlertWindow then return end

  local effects = {
    [Unit.CodeEnumCCState.Knockdown] = "Knockdown",
    [Unit.CodeEnumCCState.Disorient] = "Disorient",
    [Unit.CodeEnumCCState.Subdue] = "Disarmed",
    [Unit.CodeEnumCCState.Disarm] = "Disarmed",
    [Unit.CodeEnumCCState.Tether] = "Tethered",
    [Unit.CodeEnumCCState.Root] = "Rooted",
  }

  if unit == self.player then
    self.ActiveCC[code] = nil
    if not self:HasActiveCC() then
      self.AlertWindow:Show(false, true)
    end
  end
end

-- Mostly lifted from AuraMastery
function KuronaFrames:SetupSoundPicker(name)
  self.SoundPicker = Apollo.LoadForm(self.xmlDoc, "SoundPicker", "FixedHudStratumHigh", self)
  local container = self.SoundPicker:FindChild("WindowList")
  local soundItemA = Apollo.LoadForm(self.xmlDoc, "SoundPickerItem", container, self)
  soundItemA:FindChild("Id"):SetText(-1)
  soundItemA:FindChild("Label"):SetText("None")
  soundItemA:SetBGColor("xkcdBabyBlue")
  self.SelectedSound = soundItemA

  for sound, soundNo in pairs(Sound) do
    if type(soundNo) == "number" then
      local soundItem = Apollo.LoadForm(self.xmlDoc, "SoundPickerItem", container, self)
      soundItem:FindChild("Id"):SetText(soundNo)
      soundItem:FindChild("Label"):SetText(sound)
      if soundNo == self.tSettings[name] then
        soundItemA:SetBGColor("00000000")
        soundItem:SetBGColor("xkcdBabyBlue")
        self.SelectedSound = soundItem
      end
    end
  end
  container:ArrangeChildrenVert()
  local nNewPosL, nNewPos = self.SelectedSound:GetAnchorOffsets()
  --highlight the current sound
  container:SetVScrollPos(nNewPos - (container:GetHeight() / 2))
end

function KuronaFrames:OnSoundSelected(wndHandler, wndControl, eMouseButton, nLastRelativeMouseX, nLastRelativeMouseY)
  self.SelectedSound:SetBGColor("00000000")
  self.SelectedSound = wndHandler
  self.SelectedSound:SetBGColor("xkcdBabyBlue")

  local soundId = tonumber(wndHandler:FindChild("Id"):GetText())
  Sound.Play(soundId)
end

--Buffs
function KuronaFrames:OnBuffUpdated(unit, buff, test)
  if not unit or unit ~= self.player or not buff then return end
  if buff.splEffect:GetId() == 77116 then
    self.MentalOverflowCount = buff.nCount
  elseif buff.splEffect:GetId() == 51964 then
    self.PsiChargeCount = buff.nCount
  elseif buff.splEffect:GetId() == 42569 then -- Medic Bit
  end
end

function KuronaFrames:OnBuffAdded(unit, buff)
  if not unit or unit ~= self.player or not buff then return end
  if buff.splEffect:GetId() == 77116 then
    self.MentalOverflowCount = buff.nCount
  elseif buff.splEffect:GetId() == 51964 then
    self.PsiChargeCount = buff.nCount
  elseif buff.splEffect:GetId() == 42569 then -- Medic Bit
  end
end

function KuronaFrames:OnBuffRemoved(unit, buff)
  if not unit or unit ~= self.player or not buff then return end
  if buff.splEffect:GetId() == 77116 then --Mental Overflow
  self.MentalOverflowCount = 0
  elseif buff.splEffect:GetId() == 51964 then -- PsiCharges
  self.PsiChargeCount = 0
  elseif buff.splEffect:GetId() == 42569 then -- Medic Bit
  end
end

--Cluster Targets
function KuronaFrames:SetupClusterFrame()
  self.FrameAlias[2].ClusterFrame = self.targetFrame:FindChild("PetFrame")
  local clusterframe = self.FrameAlias[2]["ClusterFrame"]

  clusterframe:DestroyChildren()

  for i = 1, 2 do
    local petxml = Apollo.LoadForm(self.xmlDoc, "NewPetForm", clusterframe, self)
    self:HideFrameBorders(petxml, self.tSettings.bShowFrameBorders)
    petxml:FindChild("MiniHealthProgressBar"):SetFillSprite(self:GetBarType("normal"))
    petxml:FindChild("MiniHealthProgressBar"):SetFullSprite(self:GetBarType("normal"))
    petxml:FindChild("MiniShieldProgressBar"):SetFillSprite(self:GetBarType("normal"))
    petxml:FindChild("MiniShieldProgressBar"):SetFullSprite(self:GetBarType("normal"))
  end
  clusterframe:ArrangeChildrenVert()


  for i = 1, 2 do
    self["ClusterRecordedName" .. i] = nil
    self["ClusterRecordedHealth" .. i] = nil
    self["ClusterRecordedShield" .. i] = nil
  end
  self:SwapFrameBorders(clusterframe, self.tSettings.bShowFrameBorders, self.tSettings.nStyle)
end


function KuronaFrames:UpdateClusterFrame()
  if self.Target == nil then return end

  local tClusters = self.Target:GetClusterUnits()
  if not self.tSettings.bShowClusterFrame then
    if self.FrameAlias[2].ClusterFrame:IsShown() then
      self.FrameAlias[2].ClusterFrame:Show(false)
    end
    return
  end

  local clusterframe = self.FrameAlias[2].ClusterFrame

  for k, unit in ipairs(tClusters) do
    local pHealth = self:GetFPercentage(unit:GetHealth(), unit:GetMaxHealth())
    local frame = clusterframe:GetChildren()[k]

    local health = unit:GetHealth() or 0
    local healthMax = unit:GetMaxHealth() or 0
    local shield = unit:GetShieldCapacity() or 0
    local shieldMax = unit:GetShieldCapacityMax() or 0

    if unit:GetName() ~= self["ClusterRecordedName" .. k] then
      -- new unit
      frame:FindChild("PetName"):SetText(unit:GetName())
      frame:Show(true)
      frame:FindChild("PetName"):SetData(unit)
      frame:SetData(unit)
      self["ClusterRecordedName" .. k] = unit:GetName()

      local flag = shieldMax > 0
      local shieldbar = clusterframe:GetChildren()[k]:FindChild("MiniShieldProgressBar")

      shieldbar:Show(flag)
      if not flag then
        frame:FindChild("MiniHealth"):SetAnchorPoints(0, 0, 1, 1)
      else
        frame:FindChild("MiniHealth"):SetAnchorPoints(0, 0, 0.5, 1)
      end
      frame:FindChild("MiniHealth"):SetAnchorOffsets(0, 0, 3, 0)

      --frame:FindChild("MiniHSAWindow"):Show(healthMax ~= 0)
    end

    if health ~= self["ClusterRecordedHealth" .. k] then
      local healthbar = clusterframe:GetChildren()[k]:FindChild("MiniHealthProgressBar")
      healthbar:GetChildren()[1]:SetText(self:StrForNum(health, healthMax))
      healthbar:SetProgress(health / healthMax)
      self["ClusterRecordedHealth" .. k] = health

      local HPpercent = (health / healthMax) * 100
      if HPpercent <= 30 and not self["ClusterBarColor" .. k] ~= 2 then
        healthbar:SetBarColor(self.tSettings.criticalSquareColor)
        self["ClusterBarColor" .. k] = 2
      elseif HPpercent <= 70 and not self["ClusterBarColor" .. k] ~= 3 then
        healthbar:SetBarColor(self.tSettings.woundSquareColor)
        self["ClusterBarColor" .. k] = 3
      elseif self["ClusterBarColor" .. k] ~= 4 then
        healthbar:SetBarColor(self.tSettings.HCSquareColor)
        self["ClusterBarColor" .. k] = 4
      end
    end

    if shield ~= self["ClusterRecordedShield" .. k] then
      local shieldbar = clusterframe:GetChildren()[k]:FindChild("MiniShieldProgressBar")
      shieldbar:GetChildren()[1]:SetText(self:StrForNum(shield, shieldMax))
      shieldbar:SetProgress(shield / shieldMax)
      self["ClusterRecordedShield" .. k] = shield
    end

    if not clusterframe:GetChildren()[k]:IsShown() then
      clusterframe:GetChildren()[k]:Show(true)
    end

    if k == 2 then break end
  end

  if #tClusters == 0 then
    if clusterframe:IsShown() then clusterframe:Show(false) end
    return
  elseif not clusterframe:IsShown() then clusterframe:Show(true)
  end

  if #tClusters < 2 then
    if clusterframe:GetChildren()[2]:IsShown() then
      clusterframe:GetChildren()[2]:Show(false)
    end
  end
end
