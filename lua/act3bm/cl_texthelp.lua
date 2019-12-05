if CLIENT then

function ACT3_BlackMarket:LineTextBlock(text, font, limitx)
   local content = {}
   local line = ""
   local x = 0
   surface.SetFont(font)

   local space_len = surface.GetTextSize(" ")

   for _, word in pairs(string.Split(text, " ")) do
      if word == "\n" then
         table.insert(content, line)
         line = ""
         x = 0
      else
         x = x + surface.GetTextSize(word)

         if x >= limitx then
            table.insert(content, line)
            line = ""
            x = 0
            x = x + surface.GetTextSize(word)
         end

         line = line .. word .. " "

         x = x + space_len

         -- print(word .. " at " .. tostring(x))
      end
   end

   table.insert(content, line)

   return content
end

function ACT3_BlackMarket:LineTextMultiBlock(text, font, limitx)
   local content = {}

   for _, k in pairs(text) do
      table.Add(content, ACT3_BlackMarket:LineTextBlock(k, font, limitx))
   end

   return content
end

end