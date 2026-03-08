_G.love = require("love")
---@diagnostic disable: lowercase-global


function Button (func, x, y, width, height, text, text_color, button_color)

    local btn_text = {}

    func = func or function() print("This button has no function attached") end


    return {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text, 
        text_color = text_color,
        button_color = button_color,
        text_component = love.graphics.newText( FONT,  text),
        text_offset = 10,


        checkHover = function (self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.x) and (mouse_x - cursor_radius <= self.x + self.width) then
                if (mouse_y + cursor_radius >= self.y) and (mouse_y - cursor_radius <= self.y + self.height) then
                    return true
                end
            end

            return false
        end,

        setButtonColor = function (self, red, green, blue)
            self.button_color = { r = red, g = green, b = blue}
        end,

        click = function (self)
            self.func()
        end,

        draw = function (self)
            love.graphics.setColor(self.button_color["r"], self.button_color["g"], self.button_color["b"])
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)


            love.graphics.setColor(self.text_color["r"], self.text_color["g"], self.text_color["b"])
            love.graphics.draw(self.text_component, self.x + self.text_offset, self.y + (self.height/2) - 5)

        
            love.graphics.setColor(1, 1, 1)
        end,

    }

    
end


return Button
