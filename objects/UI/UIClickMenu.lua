---@diagnostic disable: lowercase-global
_G.love = require("love")

local Button = require('objects.UI.Button')


function UIClickMenu()
    local mouseCoordX, mouseCoordY = love.mouse.getPosition()
    mouseCoordX, mouseCoordY = cam:worldCoords(mouseCoordX, mouseCoordY)

    return {
        height = SPRITE_SIZE * 2,
        width = SPRITE_SIZE * 3,
        x_pos = mouseCoordX,
        y_pos = mouseCoordY,
        radius = 10,
        

        drawEmptyMenu = function (self)
            --Set Base

            love.graphics.setColor(0, 0, 0, 1)

            love.graphics.rectangle( 'line', self.x_pos, self.y_pos, self.width, self.height, self.radius, self.radius)

            love.graphics.setColor(0.1, 0.1, 0.1, 1)

            love.graphics.rectangle( 'fill', self.x_pos, self.y_pos, self.width, self.height, self.radius, self.radius)
            
            love.graphics.setColor(1, 1, 1, 1)

            --Set buttons

            local EndTurnButton = Button(nil, self.x_pos + 10, self.y_pos + 10, SPRITE_SIZE * 2, SPRITE_SIZE, "End Turn", {r = 0, g = 0, b = 0}, {r = 0.7, g = 0.7, b = 0.7})

            local mouseCoordX, mouseCoordY = love.mouse.getPosition()
            mouseCoordX, mouseCoordY = cam:worldCoords(mouseCoordX, mouseCoordY)

            if EndTurnButton:checkHover(mouseCoordX, mouseCoordY, 4) then
                EndTurnButton:setButtonColor(0.5, 0.5, 0.5)
            end

            EndTurnButton:draw()
            
            
        end
    }

end

return UIClickMenu
