SWEP.Base = "act3_base_thingy"


SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.PrintName = "Phone"
SWEP.Category = "ACT3 - Black Market"

SWEP.Desc_Country = "Finland"
SWEP.Desc_Manufacturer = "Nokia"
SWEP.Desc_Mechanism = "TI MAD2WD1"
SWEP.Desc_Year = 2000
SWEP.Desc_Weight = 0.133 -- kg
SWEP.ACT3Cat = ACT3_CAT_SPECIAL
SWEP.Sidearm = true

SWEP.Attachments = {
    ["hands"] = {
        Type = "any",
        PrintName = "Drop Attachments",
        Installed = nil,
        Required = false,
    },
}

SWEP.MagazineType = "hands"
SWEP.Magazine = nil
SWEP.InternalMag = false

SWEP.Slot = 0

SWEP.WorldModel = "models/freeman/3110.mdl"
SWEP.WorldModelBase = "models/freeman/3110.mdl" -- Worldmodel base of the weapon world model.
SWEP.WorldModelPos = Vector(3.173, 2.328, -1.981)
SWEP.WorldModelAng = Angle(180, 0, 0)

SWEP.CannotFiremodes = true

SWEP.CustomFiremode = "ON"

SWEP.DefaultToggleable = false

SWEP.Safe = true

SWEP.HoldtypePassive = "slam"
SWEP.HoldtypeHip = "pistol"
SWEP.HoldtypeSights = "pistol"

SWEP.SoundEnterAim = "act3/uni-draw.wav"
SWEP.SoundExitAim = "act3/uni-holster.wav"
SWEP.SoundDraw = ""

SWEP.ScrollFunc = ACT3_FUNC_ZERO

local nokia_image = Material("ui/nokia.png")

local mode = 0
-- modes:
-- 0: row mode. select from list of row entries.
-- 1: text mode. large text box with one option + back.
-- 2: image mode.
local entries = ACT3_BlackMarket.PhoneMenus
local index = 1
local offset = 0
local maxonscreen = 11
local back = {}
local nextpress = 0

function SWEP:OnThink()
   if SERVER then return end

   if nextpress > CurTime() then return end

   if self.Owner:KeyPressed(IN_ATTACK) then
      self:Next()
      nextpress = CurTime() + 0.1
   end

   if self.Owner:KeyPressed(IN_RELOAD) then
      self:Back()
      nextpress = CurTime() + 0.1
   end
end

function SWEP:Next()
   if SERVER then return end

   local selected

   if mode == 0 then
      selected = entries[index]
   elseif mode == 1 then
      selected = entries
   elseif mode == 2 then
      entries.Next(entries)
      return
   end

   if selected then
      if selected.endpoint then return end

      if !selected.enterfunc then return end

      newentries = selected.enterfunc()

      surface.PlaySound("ui/buttonclick.wav")

      if !newentries then return end

      table.insert(back, {entries, mode, index, offset})

      mode = selected.submode

      entries = newentries

      index = 1
      offset = 0
   end
end

function SWEP:Back()
   if SERVER then return end
   if table.Count(back) == 0 then return end

   newentries = table.remove(back)
   entries = newentries[1]
   mode = newentries[2]
   index = newentries[3]
   offset = newentries[4]

   surface.PlaySound("ui/buttonclick.wav")
end

function SWEP:Scroll(val)
   if mode == 0 then
      index = index + val

      index = math.Clamp(index, 1, table.Count(entries))
      if index - offset >= maxonscreen then
         offset = offset + 1
      elseif index - offset <= 0 then
         offset = offset - 1
      end
   elseif mode == 1 then
      offset = offset + val
      offset = math.Clamp(offset, 0, math.huge)
   elseif mode == 2 then
      entries.Scroll(entries, val)
   end
end

function SWEP:OnDrawHUD()
   if self.State != ACT3_STATE_INSIGHTS then return end

   local delta = CurTime() - self.LastEnterSightsTime
   delta = delta / self.AimTime
   if delta > 1 then
      delta = 1
   elseif delta <= 0 then
      delta = 0
      lastang = ang
   end

   -- local delta = 1

   local h = ScreenScale(500)
   local w = h
   local x = (ScrW() - h) / 2
   local y = ScrH() - (h * delta)

   local screenpx = x + (w * 0.28)
   local screenpy = y + (h * 0.375)
   local screenw = w * 0.465
   local screenh = h * 0.36

   local col_s = Color(150, 157, 150)
   local col_b = Color(0, 0, 0)

   surface.SetDrawColor(col_s)
   surface.DrawRect(screenpx, screenpy, screenw, screenh)

   local f20 = "ACT3BM_LCD_10"

   if mode != 2 then

      local ts = os.time()
      local date = os.date("|  %H:%M", ts)

      surface.SetFont(f20)
      surface.SetTextColor(col_b)
      surface.SetTextPos(screenpx + screenw - ScreenScale(72), screenpy + ScreenScale(16))
      surface.DrawText(date)

      surface.SetTextPos(screenpx + ScreenScale(7), screenpy + ScreenScale(16))
      local batt = system.BatteryPower()
      local fill = math.Clamp(batt / 100, 0, 1)
      local bars = fill * 4
      local text = "["

      for i = 1, 4 do
         if i <= bars then
            text = text .. "|"
         else
            text = text .. " "
         end
      end

      text = text .. "] ATCOM"

      surface.DrawText(text)

   end

   local selected = entries

   if mode == 0 then
      local ly = screenpy + ScreenScale(28)
      selected = entries[index]
      for _, k in pairs(entries) do
         local colt = col_b
         if _ - offset < 1 then continue end
         if _ - offset > maxonscreen then continue end
         if _ == index then
            colt = col_s
            surface.SetDrawColor(col_b)
            surface.DrawRect(screenpx + ScreenScale(7), ly, screenw - ScreenScale(32), ScreenScale(10))
         end

         surface.SetFont(f20)
         surface.SetTextColor(colt)
         surface.SetTextPos(screenpx + ScreenScale(8), ly)

         local textt

         if isfunction(k.title) then
            textt = k.title()
         else
            textt = k.title
         end

         surface.DrawText(textt)
         ly = ly + ScreenScale(12)
      end

      local flen = table.Count(entries)
      local progress = math.Round((index / flen) * 18)

      local pby = screenpy + ScreenScale(28) + (progress * ScreenScale(6))

      surface.SetFont(f20)
      surface.SetTextColor(col_b)
      surface.SetTextPos(screenpx + screenw - ScreenScale(20), pby)
      surface.DrawText("|")

   elseif mode == 1 then
      local lx = screenpx + ScreenScale(7)
      local ly = screenpy + ScreenScale(28) - (ScreenScale(12) * offset)
      local limity = screenpy + screenh - ScreenScale(32)
      local offscreen = true
      selected = entries

      for _, line in pairs(entries.content) do
         if ly >= limity then continue end

         if isfunction(line) then
            line = line()
         end

         if ly >= screenpy + ScreenScale(28) then
            surface.SetFont(f20)
            surface.SetTextPos(lx, ly)
            surface.DrawText(line)

            offscreen = false
         end

         ly = ly + ScreenScale(12)
      end

      if offscreen then
         offset = offset - 1
      end

      local flen = table.Count(entries.content)
      local progress = math.Round((offset / (flen + 1)) * 18)

      local pby = screenpy + ScreenScale(28) + (progress * ScreenScale(6))

      surface.SetFont(f20)
      surface.SetTextColor(col_b)
      surface.SetTextPos(screenpx + screenw - ScreenScale(20), pby)
      surface.DrawText("|")
   elseif mode == 2 then
      entries.Draw(entries, screenpx, screenpy, screenw, screenh)
   end

   if selected and !selected.endpoint and selected.enterfunc then
      surface.SetFont(f20)
      surface.SetTextColor(col_b)
      surface.SetTextPos(screenpx + ScreenScale(7), screenpy + screenh - ScreenScale(24))
      surface.DrawText(selected.entertext or "Enter")
   end

   if table.Count(back) > 0 then
      surface.SetFont(f20)
      surface.SetTextColor(col_b)
      surface.SetTextPos(screenpx + screenw - ScreenScale(38), screenpy + screenh - ScreenScale(24))
      surface.DrawText("Back")
   end

   surface.SetDrawColor(255, 255, 255)
   surface.SetMaterial( nokia_image )
   surface.DrawTexturedRect( x, y, w, h )

end