local KuronaFrames = Apollo.GetAddon("KuronaFrames")
local self = KuronaFrames

local bars = {}
bars[1] = {
  [1] = {},
  [2] = {},
}
bars[2] = {
  [1] = {},
  [2] = {},
}
bars[3] = {
  [1] = {},
  [2] = {},
}
bars[4] = {
  [1] = {},
  [2] = {},
}

--style/icon/name
bars[1][1]["normal"] = "KuronaSprites:Bar"
bars[1][2]["normal"] = "KuronaSprites:Bar"
bars[2][1]["normal"] = "BasicSprites:WhiteFill"
bars[2][2]["normal"] = "BasicSprites:WhiteFill"
bars[3][1]["normal"] = "BasicSprites:TextBar3"
bars[3][2]["normal"] = "BasicSprites:TextBar3"
bars[4][1]["normal"] = "BasicSprites:TextBar4"
bars[4][2]["normal"] = "BasicSprites:TextBar4"

bars[1][1]["flash"] = "KuronaSprites:FlatBarFlash"
bars[1][2]["flash"] = "KuronaSprites:FlashBar2"
bars[2][1]["flash"] = "KuronaSprites:SquareFlashBar2"
bars[2][2]["flash"] = "KuronaSprites:SquareFlashBar2"
bars[3][1]["flash"] = "KuronaSprites:SquareFlashBar2"
bars[3][2]["flash"] = "KuronaSprites:SquareFlashBar2"
bars[4][1]["flash"] = "KuronaSprites:SquareFlashBar2"
bars[4][2]["flash"] = "KuronaSprites:SquareFlashBar2"

bars[1][1]["flashB"] = "KuronaSprites:FlashBar2"
bars[1][2]["flashB"] = "KuronaSprites:FlashBar2"
bars[2][1]["flashB"] = "KuronaSprites:SquareFlashBar2"
bars[2][2]["flashB"] = "KuronaSprites:SquareFlashBar2"
bars[3][1]["flashB"] = "KuronaSprites:SquareFlashBar2"
bars[3][2]["flashB"] = "KuronaSprites:SquareFlashBar2"
bars[4][1]["flashB"] = "KuronaSprites:SquareFlashBar2"
bars[4][2]["flashB"] = "KuronaSprites:SquareFlashBar2"


bars[1][1]["police"] = "KuronaSprites:PoliceFlashBar"
bars[1][2]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[2][1]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[2][2]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[3][1]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[3][2]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[4][1]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[4][2]["police"] = "KuronaSprites:SquarePoliceFlashBar"

bars[1][1]["police"] = "KuronaSprites:PoliceFlashBar"
bars[1][2]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[2][1]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[2][2]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[3][1]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[3][2]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[4][1]["police"] = "KuronaSprites:SquarePoliceFlashBar"
bars[4][2]["police"] = "KuronaSprites:SquarePoliceFlashBar"

local _taps = {
  -- Pzychic Frenzy
  -- Surged Rapid Fire
  [76834] = 3,
  [76849] = 3,
  [76850] = 3,
  [76851] = 3,
  [76854] = 3,
  [76855] = 3,
  [76856] = 3,
  [76857] = 3,
  [76858] = 4,
  -- Rapid Fire
  [35356] = 3,
  [51391] = 3,
  [51392] = 3,
  [51393] = 3,
  [51394] = 3,
  [51395] = 3,
  [51396] = 3,
  [51397] = 3,
  [51398] = 4,
  -- True Shot
  [36052] = 3,
  [49078] = 3,
  [49079] = 3,
  [49080] = 3,
  [49081] = 3,
  [49082] = 3,
  [49083] = 3,
  [49084] = 3,
  [49085] = 4,
  -- Surged True Shot
  [36085] = 3,
  [49114] = 3,
  [49115] = 3,
  [49116] = 3,
  [49117] = 3,
  [49118] = 3,
  [49119] = 3,
  [49121] = 3,
  [49122] = 4,
  -- Nano Field
  -- Rampage
  [58524] = 4,
  [58528] = 4,
  [58529] = 4,
  [58530] = 4,
  [58531] = 4,
  [58532] = 4,
  [58533] = 4,
  [58534] = 4,
  [58535] = 4,
}


function KuronaFrames:UpdateVunerableTimes(fvulnerabletime, frame)
  -- new MoO event
  if fvulnerabletime > self.fOldVulnerable[frame] then
    self.fvulnerableMax[frame] = fvulnerabletime
    self.FrameAlias[frame]["CastFrame"]:Show(true, true)
    self.FrameAlias[frame]["CastBar"]:SetMax(fvulnerabletime)
    self.FrameAlias[frame]["CastBar"]:SetBarColor("ff800080")
    self.FrameAlias[frame]["SpellIcon"]:SetSprite("")
    self.FrameAlias[1]["CastBar"]:SetFillSprite(self:GetCastBarType("normal", frame))
    --self.FrameAlias[frame]["CastBar"]:SetFillSprite(self.fillSprites[self.tSettings.nStyle])
    self.FrameAlias[frame]["SpellIcon"]:SetText("")
    self.FrameAlias[frame]["CastName"]:SetText("Stunned!")
  end
  local strCastTime = string.format("%.1fs", fvulnerabletime)
  self.FrameAlias[frame]["SpellTime"]:SetText(strCastTime)

  self.FrameAlias[frame]["CastBar"]:SetProgress(fvulnerabletime)
  self.fOldVulnerable[frame] = fvulnerabletime
end


function KuronaFrames:CCArmorCheck(frame, nCCArmorValue, nCCArmorMax)
  --- CC Armor ---
  if nCCArmorMax == -1 then
    self.FrameAlias[frame]["CCArmor"]:Show(true)
    self.FrameAlias[frame]["CCArmor"]:SetText(self.infSymbol)
  elseif nCCArmorValue > 0 then
    self.FrameAlias[frame]["CCArmor"]:Show(true)
    self.FrameAlias[frame]["CCArmor"]:SetText(nCCArmorValue)
  else
    self.FrameAlias[frame]["CCArmor"]:Show(false)
  end
end


function KuronaFrames:PrepCastBars(unit, frame, nCCArmorValue, nCCArmorMax)
  local strSpellName = unit:GetCastName() or ""
  if frame == 1 then
    if self.CurCastName ~= strSpellName or self.FrameAlias[frame]["RecordedMaxCC"] ~= nCCArmorMax then
      self.FrameAlias[frame]["CastBar"]:SetBarColor(self:GetCastBarColor(unit))
      self.FrameAlias[frame]["CastName"]:SetText(strSpellName)
      self.CurCastName = strSpellName
      if self.tSettings.bShowSpellIcon then
        self.CurSpellIcon = self:GetSpellIconByName(strSpellName)
        self.SpecialCurSpellIcon = self:GetSpellIconByName(self.bSpecialCastName)

        self.FrameAlias[frame]["CastBar"]:SetFillSprite(self:GetCastBarType("normal", frame))
        self.FrameAlias[frame]["CastBar"]:SetFullSprite(self:GetCastBarType("flash", frame))
        if self.CurSpellIcon ~= nil then
          local l, t, r, b = self.FrameAlias[frame]["CastBar"]:GetAnchorOffsets()
          local nWidth = self.FrameAlias[frame]["SpellIcon"]:GetWidth()
          self.FrameAlias[frame]["SpellIcon"]:SetSprite(self.CurSpellIcon)
          self.FrameAlias[frame]["CastBar"]:SetAnchorOffsets(nWidth + 3, t, r, b)
          self.FrameAlias[frame]["CastBar"]:SetFillSprite(self:GetCastBarType("normal", frame))

        elseif self.SpecialCurSpellIcon ~= nil then
          local l, t, r, b = self.FrameAlias[frame]["CastBar"]:GetAnchorOffsets()
          local nWidth = self.FrameAlias[frame]["SpellIcon"]:GetWidth()
          self.FrameAlias[frame]["SpellIcon"]:SetSprite(self.SpecialCurSpellIcon)
          self.FrameAlias[frame]["CastBar"]:SetAnchorOffsets(nWidth + 3, t, r, b)
        elseif not self.bSpecialCasting and self.player:IsCasting() then
          local l, t, r, b = self.FrameAlias[frame]["CastBar"]:GetAnchorOffsets()
          local nWidth = self.FrameAlias[frame]["SpellIcon"]:GetWidth()
          self.FrameAlias[frame]["SpellIcon"]:SetSprite("")
          self.FrameAlias[frame]["CastBar"]:SetAnchorOffsets(3, t, r, b)
        end
      elseif not self.tSettings.bShowSpellIcon then
        local l, t, r, b = self.FrameAlias[frame]["CastBar"]:GetAnchorOffsets()
        self.FrameAlias[frame]["CastBar"]:SetAnchorOffsets(3, t, r, b)
        self.FrameAlias[frame]["CastBar"]:SetFillSprite(self:GetCastBarType("normal", frame))
      end
    end
    -- Setup CC Break Icons on Target cast bar
  else -- other bars
  if self.tSettings.bShowSpellIcon then
    local spellIcon = self.FrameAlias[frame]["SpellIcon"]
    if nCCArmorMax == -1 then
      if self.FrameAlias[frame]["RecordedCCSprite"] ~= "ShinyIA" then
        spellIcon:SetText(self.infSymbol)
        spellIcon:SetSprite("KuronaSprites:ShinyIA")
        self.FrameAlias[frame]["RecordedCCSprite"] = "ShinyIA"
      end
    elseif nCCArmorValue == 0 and nCCArmorMax > nCCArmorValue then
      if self.FrameAlias[frame]["RecordedCCSprite"] ~= "IABrokenAnim" then
        spellIcon:SetSprite("KuronaSprites:IABrokenAnim")
        spellIcon:SetText("")
        self.FrameAlias[frame]["RecordedCCSprite"] = "IABrokenAnim"
      end
    elseif nCCArmorValue > 0 then
      if self.FrameAlias[frame]["RecordedCCSprite"] ~= "IA" then
        spellIcon:SetSprite("KuronaSprites:IA")
        self.FrameAlias[frame]["RecordedCCSprite"] = "IA"
      end
      spellIcon:SetText(nCCArmorValue)
    else
      -- No CC Armor Found
      if self.FrameAlias[frame]["RecordedCCSprite"] ~= "" then
        spellIcon:SetSprite("")
      end
      spellIcon:SetText("")
      self.FrameAlias[frame]["RecordedCCSprite"] = ""
    end
  end
  end
  -- Set Target Cast Name
  if frame == 2 then
    if self.TarCastName ~= strSpellName or self.FrameAlias[frame]["RecordedMaxCC"] ~= nCCArmorMax then
      if self.tSettings.bAlertWindow then
        local cast = self:CompareCastNames(strSpellName, unit)
        if cast then self.AlertCastFrame = frame end
      end
      local eDisposition = self.player:GetDispositionTo(unit)
      if nCCArmorMax >= 0 and eDisposition ~= 2 then
        self.FrameAlias[frame]["CastBar"]:SetBarColor(self.tSettings.ICastColor)
        if self.tSettings.bFlashInterrupt then
          self.FrameAlias[frame]["CastBar"]:SetFillSprite(self:GetCastBarType("flash", frame))
        end
      else
        self.FrameAlias[frame]["CastBar"]:SetFillSprite(self:GetCastBarType("normal", frame))
        self.FrameAlias[frame]["CastBar"]:SetBarColor(self:GetCastBarColor(unit))
      end
      self.FrameAlias[frame]["CastName"]:SetText(strSpellName)
    end
    self.TarCastName = strSpellName
  elseif frame == 3 then
    if self.FocCastName ~= strSpellName or self.FrameAlias[frame]["RecordedMaxCC"] ~= nCCArmorMax then
      if self.tSettings.bAlertWindow then
        local cast = self:CompareCastNames(strSpellName, unit)
        if cast then self.AlertCastFrame = frame end
      end

      local eDisposition = self.player:GetDispositionTo(unit)
      if nCCArmorMax >= 0 and eDisposition ~= 2 then
        self.FrameAlias[frame]["CastBar"]:SetBarColor(self.tSettings.ICastColor)
        if self.tSettings.bFlashInterrupt then
          self.FrameAlias[frame]["CastBar"]:SetFillSprite(self:GetCastBarType("flash", frame))
        end
      else
        self.FrameAlias[frame]["CastBar"]:SetFillSprite(self:GetCastBarType("normal", frame))
        self.FrameAlias[frame]["CastBar"]:SetBarColor(self:GetCastBarColor(unit))
      end
      self.FrameAlias[frame]["CastName"]:SetText(strSpellName)
    end
    self.FocCastName = strSpellName
  end

  self.FrameAlias[frame]["RecordedMaxCC"] = nCCArmorMax
end


function KuronaFrames:UpdateCastBar(unitCaster, frame)
  if self.bEditMode or unitCaster == nil then return end
  if self.fvulnerableMax[frame] > 0 and frame == self.targetFrame then return end
  local bNoCasting = true

  if frame == 1 and self.bSpecialCasting then bNoCasting = false end

  if bNoCasting and not unitCaster:IsCasting() and not unitCaster:ShouldShowCastBar() then
    if self.FrameAlias[frame]["CastFrame"]:IsShown() then
      local prog = self.FrameAlias[frame]["CastBar"]:GetProgress()
      local max = self.FrameAlias[frame]["CastBar"]:GetMax()
      local perc = prog / max
      if perc > 0.95 then
        self.FrameAlias[frame]["CastBar"]:SetProgress(max)
      end
      self.FrameAlias[frame]["SpellTime"]:SetText("")
      self.FrameAlias[frame]["CastFrame"]:Show(false)

      if not self:HasActiveCC() and self.AlertCastFrame == frame then
        self.AlertCasting = false
        self.AlertCastFrame = nil
        self.AlertWindow:Show(false, false)
      end
    end
    if self.MiniCastBar ~= nil and frame == 1 then
      if self.MiniCastBar:IsShown() then
        self:UpdateAuxCastBar(1, 0)
        self.MiniCastBar:Show(false)
      end
    end
    if frame == 1 and self.FrameAlias[1]["ChargeFrame"]:IsVisible() then
      self.FrameAlias[1]["ChargeFrame"]:Show(false)
    end
    return
  end

  local nDuration = unitCaster:GetCastDuration()
  local nElapsed = unitCaster:GetCastElapsed()
  local fTimeRemaining = (nDuration - nElapsed) / 1000

  if frame == 1 then -- special casting
  if self.bSpecialCasting and self.bSpecialCastName == self.CurCastName then
    nElapsed = GameLib.GetSpellThresholdTimePrcntDone(self.tCurrentOpSpell.id)
    nDuration = 1
    fTimeRemaining = 0
    if self.MultiTapCast then
      nElapsed = (1 - nElapsed)
    end
    if not self.FrameAlias[frame]["ChargeFrame"]:IsVisible() then
      self.FrameAlias[frame]["ChargeFrame"]:Show(true)
    end
    self.FrameAlias[frame]["ChargeBar"]:SetMax(self.tCurrentOpSpell.nMaxTier)
    self.FrameAlias[frame]["ChargeBar"]:SetProgress(self.tCurrentOpSpell.nCurrentTier)

    -- If we are not casting but we still have a special cast counting down....
  elseif self.bSpecialCasting and self.CurCastName == "" then
    nElapsed = GameLib.GetSpellThresholdTimePrcntDone(self.tCurrentOpSpell.id)
    nDuration = 1
    fTimeRemaining = 0

    if not self.FrameAlias[frame]["ChargeFrame"]:IsVisible() then
      self.FrameAlias[frame]["ChargeFrame"]:Show(true)
    end
    self.FrameAlias[frame]["ChargeBar"]:SetMax(self.tCurrentOpSpell.nMaxTier)
    self.FrameAlias[frame]["ChargeBar"]:SetProgress(self.tCurrentOpSpell.nCurrentTier)


    if self.MultiTapCast then
      nElapsed = (1 - nElapsed)
    end
    if self.FrameAlias[frame]["RecordedSpellTime"] ~= "" then
      self.FrameAlias[frame]["SpellTime"]:SetText("")
      self.FrameAlias[frame]["RecordedSpellTime"] = ""
    end
    -- Regular casting
  else
    if self.FrameAlias[frame]["ChargeFrame"]:IsVisible() then
      self.FrameAlias[frame]["ChargeFrame"]:Show(false)
    end
    if fTimeRemaining <= 0 then
      fTimeRemaining = 0
      if self.FrameAlias[frame]["RecordedSpellTime"] ~= "0.0s" then
        self.FrameAlias[frame]["SpellTime"]:SetText("0.0s")
        self.FrameAlias[frame]["RecordedSpellTime"] = "0.0s"
      end
      if self.tSettings.bShowSpellTimeIcon then
        self.FrameAlias[frame]["SpellIcon"]:SetText("0.0s")
      else
        self.FrameAlias[frame]["SpellIcon"]:SetText("")
      end
    elseif fTimeRemaining > 0 then
      local strCastTime = string.format("%.1fs", fTimeRemaining)
      if self.FrameAlias[frame]["RecordedSpellTime"] ~= strCastTime then
        self.FrameAlias[frame]["SpellTime"]:SetText("-" .. strCastTime)
        self.FrameAlias[frame]["RecordedSpellTime"] = strCastTime
      end
      if self.tSettings.bShowSpellTimeIcon then
        self.FrameAlias[frame]["SpellIcon"]:SetText("-" .. strCastTime)
      else
        if self.FrameAlias[frame]["RecordedSpellTime"] ~= "" then
          self.FrameAlias[frame]["SpellIcon"]:SetText("")
          self.FrameAlias[frame]["RecordedSpellTime"] = ""
        end
      end
    end
  end
  elseif frame ~= 1 then
    if fTimeRemaining <= 0 then
      fTimeRemaining = 0
      if self.FrameAlias[frame]["RecordedSpellTime"] ~= "0.0s" then
        self.FrameAlias[frame]["SpellTime"]:SetText("0.0s")
        self.FrameAlias[frame]["RecordedSpellTime"] = "0.0s"
      end
      if self.tSettings.bShowSpellTimeIcon then
        self.FrameAlias[frame]["SpellIcon"]:SetText("0.0s")
      end
      -- Special Cast can't get real cast info
      if nDuration == 0 and nElapsed > 0 and frame ~= 1 then
        nDuration = 1
        fTimeRemaining = 0
        if self.FrameAlias[frame]["RecordedSpellTime"] ~= "???" then
          self.FrameAlias[frame]["SpellTime"]:SetText("???")
          self.FrameAlias[frame]["RecordedSpellTime"] = "???"
        end
      end
    elseif fTimeRemaining > 0 then
      local strCastTime = string.format("%.1fs", fTimeRemaining)
      if self.FrameAlias[frame]["RecordedSpellTime"] ~= strCastTime then
        self.FrameAlias[frame]["SpellTime"]:SetText("-" .. strCastTime)
        self.FrameAlias[frame]["RecordedSpellTime"] = strCastTime
      end
      if self.tSettings.bShowSpellTimeIcon then
        self.FrameAlias[frame]["SpellIcon"]:SetText("-" .. strCastTime)
      end
    end
  end

  self.FrameAlias[frame]["CastBar"]:SetMax(nDuration)
  self.FrameAlias[frame]["CastBar"]:SetProgress(nElapsed)

  if fTimeRemaining <= 0 then
    local type = unitCaster:GetType()
    if type ~= "Player" then
      self.FrameAlias[frame]["CastFrame"]:Show(false)
      if self.MiniCastBar ~= nil and frame == 1 then
        self.MiniCastBar:Show(false)
      end
      return
    end
  end

  if not self.FrameAlias[frame]["CastFrame"]:IsShown() then
    self.FrameAlias[frame]["CastFrame"]:Show(true, true)
    if self.MiniCastBar ~= nil then
      self.MiniCastBar:Show(true)
    end
  end

  if self.MiniCastBar ~= nil and frame == 1 then
    self.MiniCastBar:Show(true)
    self:UpdateAuxCastBar(nDuration, nElapsed)
  end


  if fTimeRemaining <= 0 then
    local type = unitCaster:GetType()
    if type ~= "Player" then
      self.FrameAlias[frame]["CastFrame"]:Show(false)
    end
    if self.MiniCastBar ~= nil and frame == 1 then
      self.MiniCastBar:Show(false)
    end
    return
  end
end


function KuronaFrames:UpdateAuxCastBar(nDuration, nElapsed)
  self.MiniCastBar:SetMax(nDuration)
  self.MiniCastBar:SetProgress(nElapsed)
end


-- also fires on tier change
function KuronaFrames:OnStartSpellThreshold(idSpell, nMaxThresholds, eCastMethod, nNewThreshold)
  -- Print("OnStartSpellThreshold; spell: " .. GameLib.GetSpell(idSpell):GetName() .. "; eCastMethod: " .. eCastMethod)

  if self.tCurrentOpSpell ~= nil and idSpell == self.tCurrentOpSpell.id then
    return
  end -- we're getting an update event, ignore this one

  self.tCurrentOpSpell = {}
  local splObject = GameLib.GetSpell(idSpell)

  self.tCurrentOpSpell.id = idSpell
  self.tCurrentOpSpell.nCurrentTier = nNewThreshold or 1
  self.tCurrentOpSpell.nMaxTier = nMaxThresholds
  self.tCurrentOpSpell.eCastMethod = eCastMethod
  self.tCurrentOpSpell.strName = splObject:GetName()
  self.bSpecialCasting = true
  self.bSpecialCastName = self.tCurrentOpSpell.strName
  self.MultiTapCast = false

  self:OnUpdateSpellThreshold(idSpell, self.tCurrentOpSpell.nCurrentTier)
end

-- Updates when P/H/R changes tier or RT tap is performed
function KuronaFrames:OnUpdateSpellThreshold(idSpell, nNewThreshold)

  -- Print("OnUpdateSpellThreshold; spell: " .. GameLib.GetSpell(idSpell):GetName() .. "; idSpell(): " .. tostring(idSpell) .. "; GameLib.GetSpell(idSpell):GetTier(): " .. tostring(GameLib.GetSpell(idSpell):GetTier())) --.. "; taps: " .. tostring(_taps[idSpell][GameLib.GetSpell(idSpell):GetTier()]))
  if self.tCurrentOpSpell == nil and GameLib.GetSpell(idSpell) ~= nil and (_taps[idSpell]) then
    self:OnStartSpellThreshold(idSpell, _taps[idSpell], GameLib.GetSpell(idSpell):GetCastMethod(), nNewThreshold)
  end

  if self.tCurrentOpSpell == nil or idSpell ~= self.tCurrentOpSpell.id then
    return
  end

  self.tCurrentOpSpell.nCurrentTier = nNewThreshold
  --self.FrameAlias[1]["SpellIcon"]:SetText(self.tCurrentOpSpell.nCurrentTier.. "/"..self.tCurrentOpSpell.nMaxTier)
  self.FrameAlias[1]["ChargeBar"]:SetMax(self.tCurrentOpSpell.nMaxTier)
  self.FrameAlias[1]["ChargeBar"]:SetProgress(self.tCurrentOpSpell.nCurrentTier)
  self.bSpecialCastName = self.tCurrentOpSpell.strName

  --	self.FrameAlias[frame]["CastBar"]:SetFillSprite(self:GetCastBarType("normal",frame))
  self.FrameAlias[1]["CastBar"]:SetFullSprite(self:GetCastBarType("flash"))
end

function KuronaFrames:OnClearSpellThreshold(idSpell)
  if self.tCurrentOpSpell ~= nil and idSpell ~= self.tCurrentOpSpell.id then return end -- different spell got loaded up before the previous was cleared. this is valid.
  self.bSpecialCasting = false
  self.bSpecialCastName = ""
  self.tCurrentOpSpell = nil
  self.bSpecialCastName = ""

  self.MultiTapCast = false

  self.FrameAlias[1]["CastBar"]:SetFullSprite(self:GetCastBarType("normal", frame))

  self.FrameAlias[1]["CastBar"]:SetProgress(0)
end


function KuronaFrames:SpecialCastBarUpdate()
  local unitPlayer = self.player
  if not unitPlayer then return end
  self.FrameAlias[1]["CastBar"]:SetFullSprite(self:GetCastBarType("normal", frame))
  if self.tCurrentOpSpell ~= nil then
    if self.tCurrentOpSpell.eCastMethod == Spell.CodeEnumCastMethod.RapidTap then
      self.MultiTapCast = true
    elseif self.tCurrentOpSpell.eCastMethod == Spell.CodeEnumCastMethod.PressHold then
      --
    elseif self.tCurrentOpSpell.eCastMethod == Spell.CodeEnumCastMethod.ChargeRelease then
      self:DrawSingleBarFrameTiered(self.wndOppBarTiered)
    end
  end
end


function KuronaFrames:DrawSingleBarFrameTiered(wnd)
  local fPercentDone = GameLib.GetSpellThresholdTimePrcntDone(self.tCurrentOpSpell.id)
  if self.tCurrentOpSpell.nCurrentTier == self.tCurrentOpSpell.nMaxTier then
    self.FrameAlias[1]["CastBar"]:SetProgress(1)
    self.FrameAlias[1]["CastBar"]:SetFullSprite(self:GetCastBarType("flash", frame))
  end
end

function KuronaFrames:GetBarType(barType)
  local icon = 2
  if self.tSettings.bShowSpellIcon then icon = 1 end
  local result = bars[self.tSettings.nStyle][icon][barType]
  if result == nil then
  end
  return bars[self.tSettings.nStyle][icon][barType]
end



function KuronaFrames:GetCastBarType(barType, frame)
  local icon = 2
  local type = frame

  if self.tSettings.bShowSpellIcon then icon = 1 end

  if self.tSettings.nStyle == 1 and frame ~= 1 then
    icon = 2
  end
  return bars[self.tSettings.nStyle][icon][barType]
end



function KuronaFrames:GetFrameType(frameType)
  if frameType == "WarriorFlash" then
    if self.tSettings.nStyle == 1 then
      return "KuronaSprites:WarriorFlashFrame"
    else
      return "KuronaSprites:SquareWarriorFlashFrame"
    end
  elseif frameType == "flashframe" then
    if self.tSettings.nStyle == 1 then
      return "KuronaSprites:FlashFrame2"
    else
      return "KuronaSprites:SquareFlashFrame2"
    end
  elseif frameType == "normal" then
    if self.tSettings.nStyle == 1 then
      return "KuronaSprites:Frame2"
    else
      return "KuronaSprites:SquareFrame"
    end
  end
end

--Proximity Based Castbar

function KuronaFrames:OnEnteredCombat(unit, bInCombat)
  local eDisposition = self.player:GetDispositionTo(unit)

  if unit == self.player then
    if not bInCombat then
      self.ProximityCast.Windows[1]:Show(false)
      self.ProximityCast.Windows[2]:Show(false)
    else
      if self.Target then
        --Smart Target Drop only drop friendly NPCs and objects that have no HP
        local targetDisposition = self.player:GetDispositionTo(self.Target)
        local NPC = (targetDisposition == 2 and not self.Target:IsACharacter())
        local alive = self.Target:GetHealth() or 0
        if (alive == 0 or NPC) then GameLib.SetTargetUnit(nil) end
      end
    end
  end

  if not self.tSettings.bProxmityCast then return end

  if self.ProximityCasters == nil then self.ProximityCasters = {} end


  local count = 0
  for x in pairs(self.ProximityCasters) do count = count + 1
  if not self.ProximityCasters[x].unit:IsValid() then self.ProximityCasters[x] = nil end
  end

  self.bCombatState = self.player:IsInCombat()
  --if eDisposition ~= Unit.CodeEnumDisposition.Hostile then return end
  if bInCombat and not self.ProximityCasters[unit:GetId()] and ((eDisposition == Unit.CodeEnumDisposition.Hostile and unit:GetType() == "NonPlayer")) then
    self.ProximityCasters[unit:GetId()] = {
      ["unit"] = unit,
      ["vLength"] = 99,
      ["vuln"] = 0
    }
  end

  if not bInCombat and self.ProximityCasters[unit:GetId()] then
    if self.ProximityCasters[unit:GetId()].casting then

      self.ProximityCast.Windows[self.ProximityCasters[unit:GetId()].casting]:Show(false)
    end
    self.ProximityCasters[unit:GetId()] = nil
  end
end


function KuronaFrames:CheckProximityCasters()
  if self.ProximityCasters == nil then return end
  local pPos = self.player:GetPosition()
  local pVec = Vector3.New(pPos.x, pPos.y, pPos.z)

  for x, y in pairs(self.ProximityCasters) do
    if self.ProximityCasters[x].unit:IsValid() then
      local uPos = self.ProximityCasters[x].unit:GetPosition()
      local uVec = Vector3.New(uPos.x, uPos.y, uPos.z)

      local length = (pVec - uVec):Length()
      self.ProximityCasters[x].casting = nil
      self.ProximityCasters[x].vLength = length
    end
  end
  table.sort(self.ProximityCasters, function(a, b) return (a.vLength or 0) < (b.vLength or 0) end)
end

function KuronaFrames:DoProximityCastbars()
  if self.ProximityCasters == nil then return end
  self.ProximityCasting = 0
  for x, y in pairs(self.ProximityCasters) do

    local unit = self.ProximityCasters[x].unit
    local range = self.tSettings.nProxRangeSolo
    if GroupLib.InRaid() then range = self.tSettings.nProxRangeGroup end
    local fvulnerabletime = unit:GetCCStateTimeRemaining(Unit.CodeEnumCCState.Vulnerability) or 0
    if fvulnerabletime > 0 then
      self.ProximityCasting = self.ProximityCasting + 1

      --New Moo
      if fvulnerabletime > self.ProximityCasters[x].vuln then
        self.ProximityCast.Bars[self.ProximityCasting]:SetMax(fvulnerabletime)
        self.ProximityCast.Bars[self.ProximityCasting]:SetBarColor(("ff800080"))
        self.ProximityCast.Bars[self.ProximityCasting]:SetFillSprite(self:GetCastBarType("normal", frame))
        self.ProximityCasters[x].vuln = fvulnerabletime
        self.ProximityCast.CastName[self.ProximityCasting]:SetText("Stunned")
        if self.ProximityCast.CCSprite[self.ProximityCasting] ~= "" then
          local spellIcon = self.ProximityCast.Icon[self.ProximityCasting]
          spellIcon:SetSprite("")
          spellIcon:SetText("")
          self.ProximityCast.CCSprite[self.ProximityCasting] = ""
        end
      end

      local strCastTime = string.format("-%.1fs", fvulnerabletime)
      if self.ProximityCast.CastTime[self.ProximityCasting] ~= strCastTime then
        self.ProximityCast.Time[self.ProximityCasting]:SetText(strCastTime)
        self.ProximityCast.CastTime[self.ProximityCasting] = strCastTime
      end

      self.ProximityCast.Bars[self.ProximityCasting]:SetProgress(fvulnerabletime)

      if self.ProximityCasting == 2 then break end
    elseif self.ProximityCasters[x].vLength < range and unit and unit:IsCasting() and unit:ShouldShowCastBar() then
      local castName = unit:GetCastName()
      local validCast = true
      self.ProximityCasters[x].vuln = 0
      for j = 1, #self.ProximityIgnoreTable do
        if self.ProximityIgnoreTable[j] == castName then
          validCast = false
        end
      end
      if validCast then
        self.ProximityCasting = self.ProximityCasting + 1
        self.ProximityCasters[x].casting = self.ProximityCasting
        local castDuration = unit:GetCastDuration()
        local castTime = unit:GetCastElapsed()
        local nCCArmorValue = unit:GetInterruptArmorValue() or 0
        local nCCArmorMax = unit:GetInterruptArmorMax() or 0

        -- New proximity cast
        if self.ProximityCast.Names[self.ProximityCasting] ~= castName or self.ProximityCast.MaxCC[self.ProximityCasting] ~= nCCArmorMax then
          self.ProximityCast.CastName[self.ProximityCasting]:SetText(castName)
          self.ProximityCast.Bars[self.ProximityCasting]:SetMax(castDuration)
          if self.tSettings.bAlertNames then
            self.ProximityCast.CastName[self.ProximityCasting]:GetParent():SetText(unit:GetName() .. "  ")
          else
            self.ProximityCast.CastName[self.ProximityCasting]:GetParent():SetText("")
          end


          if self.tSettings.bAlertWindow then
            local cast = self:CompareCastNames(castName, unit)
            if cast then self.AlertCastFrame = "prox" .. x end
          end
          local eDisposition = self.player:GetDispositionTo(unit)

          if nCCArmorMax >= 0 then
            if self.tSettings.bFlashInterrupt then
              self.ProximityCast.Bars[self.ProximityCasting]:SetBarColor(self.tSettings.ICastColor)
              self.ProximityCast.Bars[self.ProximityCasting]:SetFillSprite(self:GetCastBarType("flash", frame))
            end
          elseif nCCArmorMax == -1 then
            self.ProximityCast.Bars[self.ProximityCasting]:SetFillSprite(self:GetCastBarType("normal", frame))
            self.ProximityCast.Bars[self.ProximityCasting]:SetBarColor(self.tSettings.HCastColor)
          end

          self.ProximityCast.Windows[self.ProximityCasting]:Show(true, true)
        end

        if self.tSettings.bShowSpellIcon then
          local spellIcon = self.ProximityCast.Icon[self.ProximityCasting]
          if nCCArmorMax == -1 then
            if self.ProximityCast.CCSprite[self.ProximityCasting] ~= "ShinyIA" then
              spellIcon:SetText(self.infSymbol)
              spellIcon:SetSprite("KuronaSprites:ShinyIA")
              self.ProximityCast.CCSprite[self.ProximityCasting] = "ShinyIA"
            end
          elseif nCCArmorValue == 0 and nCCArmorMax > nCCArmorValue then
            if self.ProximityCast.CCSprite[self.ProximityCasting] ~= "IABrokenAnim" then
              spellIcon:SetSprite("KuronaSprites:IABrokenAnim")
              spellIcon:SetText("")
              self.ProximityCast.CCSprite[self.ProximityCasting] = "IABrokenAnim"
            end
          elseif nCCArmorValue > 0 then
            if self.ProximityCast.CCSprite[self.ProximityCasting] ~= "IA" then
              spellIcon:SetSprite("KuronaSprites:IA")
              self.ProximityCast.CCSprite[self.ProximityCasting] = "IA"
            end
            if self.ProximityCast.CurrentCC[self.ProximityCasting] ~= nCCArmorValue then
              spellIcon:SetText(nCCArmorValue)
            end
          else
            -- No CC Armor Found
            if self.ProximityCast.CCSprite[self.ProximityCasting] ~= "" then
              spellIcon:SetSprite("")
              spellIcon:SetText("")
              self.ProximityCast.CCSprite[self.ProximityCasting] = ""
            end
          end
        end



        self.ProximityCast.CurrentCC[self.ProximityCasting] = nCCArmorValue
        self.ProximityCast.Names[self.ProximityCasting] = castName
        self.ProximityCast.MaxCC[self.ProximityCasting] = nCCArmorMax
        self.ProximityCast.Bars[self.ProximityCasting]:SetProgress(castTime)

        local fTimeRemaining = (castDuration - castTime) / 1000
        local strCastTime = string.format("-%.1fs", fTimeRemaining)
        if self.ProximityCast.CastTime[self.ProximityCasting] ~= strCastTime then
          self.ProximityCast.Time[self.ProximityCasting]:SetText(strCastTime)
          self.ProximityCast.CastTime[self.ProximityCasting] = strCastTime
        end
        if self.ProximityCasting == 2 then break end
      end
    end
  end



  if self.ProximityCasting == 0 then
    if self.ProximityCast.Windows[1]:IsShown() then
      self.ProximityCast.Windows[1]:Show(false, true)
    end
    if self.ProximityCast.Windows[2]:IsShown() then
      self.ProximityCast.Windows[2]:Show(false, true)
    end
    self.ProximityCast.Names[1] = ""
    self.ProximityCast.Names[2] = ""
    self.ProximityCast.CCSprite[1] = "blank"
    self.ProximityCast.CCSprite[2] = "blank"
    self.ProximityCast.MaxCC[1] = ""
    self.ProximityCast.MaxCC[2] = ""
    --self.ProximityCast[1].vuln = 0
    --self.ProximityCast[2].vuln = 0
    if not self:HasActiveCC() and (self.AlertCastFrame == "prox1" or self.AlertCastFrame == "prox2") then
      self.AlertCasting = false
      self.AlertCastFrame = nil
      self.AlertWindow:Show(false, false)
    end
  elseif self.ProximityCasting == 1 and self.ProximityCast.Windows[2]:IsShown() then
    self.ProximityCast.Windows[2]:Show(false, true)
    self.ProximityCast.Names[1] = ""
    self.ProximityCast.Names[2] = ""
    self.ProximityCast.CCSprite[1] = "blank"
    self.ProximityCast.CCSprite[2] = "blank"
    self.ProximityCast.MaxCC[1] = ""
    self.ProximityCast.MaxCC[2] = ""
    --self.ProximityCast[1].vuln=0
    --self.ProximityCast[2].vuln=0

    if not self:HasActiveCC() and (self.AlertCastFrame == "prox1" or self.AlertCastFrame == "prox2") then
      self.AlertCasting = false
      self.AlertCastFrame = nil
      self.AlertWindow:Show(false, false)
    end
  end
end

