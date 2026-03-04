_G.love = require("love")
---@diagnostic disable: lowercase-global


function Button (func, x, y, width, height, text, text_color, botton_color)

    local btn_text = {}

    func = func or function() print("This button has no function attached") end


    return {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text, 
        text_color = text_color,
        botton_color = botton_color,

        checkHover = function (self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.x) and (mouse_x - cursor_radius <= self.x + self.width) then
                if (mouse_y + cursor_radius >= self.y) and (mouse_y - cursor_radius <= self.y + self.height) then
                    return true
                end
            end

            return false
        end,

        click = function (self)
            self.func()
        end,

        draw = function (self)
            love.graphics.setColor(self.button_color["r"], self.button_color["g"], self.button_color["b"])
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        
            self.text_component:setColor(self.text_color["r"], self.text_color["g"], self.text_color["b"])
            self.text_component:draw()
        
            love.graphics.setColor(1, 1, 1)
        end,

    }

    
end


return Button
