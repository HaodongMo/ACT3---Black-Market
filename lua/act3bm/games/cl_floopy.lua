ACT3_BlackMarket.Floopy = function()
   local entries = {
      Next = function(self)
         if !self.Data.gamestarted then
            self.Data.gamestarted = true
            self.Data.points = 0
            self.Data.bird_y = 50
            self.Data.bird_dy = 0
            self.Data.barrier1_x = 0
            self.Data.barrier1_y = 0
            self.Data.barrier2_x = 0
            self.Data.barrier2_y = 0
            self.Data.gametime = 0
            self.Data.nextbarrtime = 0
            self.Data.barind = 1
         else
            self.Data.bird_dy = 65
         end
      end,
      Scroll = function(self, val) end,
      Draw = function(self, x, y, w, h)
         if self.Data.gamestarted then
            self.Data.gametime = self.Data.gametime + FrameTime()
            surface.SetFont("ACT3BM_LCD_10")
            surface.SetTextColor(Color(0, 0, 0))
            local by = y + h - ScreenScale(self.Data.bird_y)
            by = by / 10
            by = math.Round(by)
            by = by * 10
            surface.SetTextPos(x + ScreenScale(80), by)
            surface.DrawText("V")

            self.Data.bird_y = self.Data.bird_y + (FrameTime() * self.Data.bird_dy)
            self.Data.bird_dy = self.Data.bird_dy - (FrameTime() * 100)

            if self.Data.bird_y < 0 then
               self.Data.gamestarted = false
            elseif self.Data.bird_y > (h / ScreenScale(1)) then
               self.Data.bird_y = h / ScreenScale(1)
               self.Data.bird_dy = 0
            end

            if self.Data.nextbarrtime <= self.Data.gametime then
               if self.Data.barind == 1 then
                  self.Data.barind = 2
                  self.Data.barrier1_x = w / ScreenScale(1)
                  self.Data.barrier1_y = math.Rand(0, h / ScreenScale(1))
               else
                  self.Data.barind = 1
                  self.Data.barrier2_x = w / ScreenScale(1)
                  self.Data.barrier2_y = math.Rand(0, h / ScreenScale(1))
               end

               self.Data.nextbarrtime = self.Data.gametime + 2
            end

            self.Data.barrier1_x = self.Data.barrier1_x - (FrameTime() * 50)
            self.Data.barrier2_x = self.Data.barrier2_x - (FrameTime() * 50)

            if self.Data.barrier1_x > 75 and self.Data.barrier1_x < 80 then
               if self.Data.bird_y > self.Data.barrier1_y - 10 and self.Data.bird_y < self.Data.barrier1_y + 10 then
                  self.Data.gamestarted = false
               end
            end

            if self.Data.barrier2_x > 75 and self.Data.barrier2_x < 80 then
               if self.Data.bird_y > self.Data.barrier2_y - 10 and self.Data.bird_y < self.Data.barrier2_y + 10 then
                  self.Data.gamestarted = false
               end
            end

            if self.Data.barrier1_x > 0 then
               for i = 0, 6 do
                  surface.SetTextPos(x + ScreenScale(self.Data.barrier1_x), y + ScreenScale((i * 10) + self.Data.barrier1_y - 60) )
                  surface.DrawText("|")
               end
               for i = 0, 6 do
                  surface.SetTextPos(x + ScreenScale(self.Data.barrier1_x), y + ScreenScale((i * 10) + self.Data.barrier1_y + 10))
                  surface.DrawText("|")
               end
               surface.SetDrawColor(0, 0, 0)
               surface.DrawRect(x + ScreenScale(self.Data.barrier1_x), y + ScreenScale(self.Data.barrier1_y - 5), ScreenScale(5), ScreenScale(10))
            end

            if self.Data.barrier2_x > 0 then
               for i = 0, 6 do
                  surface.SetTextPos(x + ScreenScale(self.Data.barrier2_x), y + ScreenScale((i * 10) + self.Data.barrier2_y - 60) )
                  surface.DrawText("|")
               end
               for i = 0, 6 do
                  surface.SetTextPos(x + ScreenScale(self.Data.barrier2_x), y + ScreenScale((i * 10) + self.Data.barrier2_y + 10))
                  surface.DrawText("|")
               end
               surface.SetDrawColor(0, 0, 0)
               surface.DrawRect(x + ScreenScale(self.Data.barrier2_x), y + ScreenScale(self.Data.barrier2_y - 5), ScreenScale(5), ScreenScale(10))
            end
         else
            surface.SetFont("ACT3BM_LCD_10")
            surface.SetTextColor(Color(0, 0, 0))
            surface.SetTextPos(x + ScreenScale(8), y + ScreenScale(32))
            surface.DrawText("Floopy Birb")
            surface.SetTextPos(x + ScreenScale(8), y + ScreenScale(48))
            surface.DrawText("Press [NEXT] To Start")
            surface.SetTextPos(x + ScreenScale(8), y + ScreenScale(64))
            surface.DrawText("Points: " .. self.Data.points)
         end
      end,
      Data = {
         barrier1_x = 0,
         barrier1_y = 0,
         barrier2_x = 0,
         barrier2_y = 0,
         bird_y = 0,
         bird_dy = 0,
         points = 0,
         gamestarted = false,
         gametime = 0,
         nextbarrtime = 0,
         barind = 1,
      }
   }

   return entries
end