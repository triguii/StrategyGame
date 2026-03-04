---@diagnostic disable: lowercase-global
_G.love = require("love")

function UIClickMenu()
    local mouseCoordX, mouseCoordY = love.mouse.getPosition()

    return {
        height = SPRITE_SIZE * 3,
        width = SPRITE_SIZE * 5,
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
            
        end
    }

end

return UIClickMenu
