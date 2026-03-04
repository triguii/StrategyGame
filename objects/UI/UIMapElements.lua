---@diagnostic disable: lowercase-global
_G.love = require("love")


function UIMapElements ()

    return {

        height = SPRITE_SIZE * 3,
        width = screenWidth,
        x_pos = 0 + (cam.x - screenWidth/2),
        y_pos = (screenHeight - (SPRITE_SIZE * 2)) + (cam.y - screenHeight/2),
        radius = 10,

        UnitHoverDraw = function (self, unit)
            --Avatar

            love.graphics.draw(unit.potrait, self.x_pos + 20, self.y_pos + 20, 0, 0.35, 0.35)

            --Text

            local text_offset = 125

            local name_text = love.graphics.newText( FONT, unit.name )

            local speed_text = love.graphics.newText( FONT, 'Speed: ' .. unit.speed )
            local dmg_text = love.graphics.newText( FONT, 'Dmg: ' .. unit.damage )
            local range_text = love.graphics.newText( FONT, 'Range: ' .. unit.range )
            local hp_text = love.graphics.newText( FONT, 'HP: ' .. unit.health .. '/100' )



            love.graphics.draw(name_text, self.x_pos + text_offset, self.y_pos + 20)
            love.graphics.draw(speed_text, self.x_pos + text_offset, self.y_pos + 40)
            love.graphics.draw(dmg_text, self.x_pos + text_offset, self.y_pos + 60)
            love.graphics.draw(range_text, self.x_pos + text_offset, self.y_pos + 80)

            if unit.health == 100 then

                love.graphics.setColor(0, 1, 0, 1)

            else
                love.graphics.setColor(1, 0.2, 0.2, 1)

            end
            love.graphics.draw(hp_text, self.x_pos + text_offset, self.y_pos + 100)
            
            love.graphics.setColor(1, 1, 1, 1)
            
        end,


        MainUi = function (self)
            --Set Base

            love.graphics.setColor(0, 0, 0, 1)

            love.graphics.rectangle( 'line', self.x_pos, self.y_pos, self.width, self.height, self.radius, self.radius)

            love.graphics.setColor(0.1, 0.1, 0.1, 1)

            love.graphics.rectangle( 'fill', self.x_pos, self.y_pos, self.width, self.height, self.radius, self.radius)
            
            love.graphics.setColor(1, 1, 1, 1)
            
        end,
    }
end

return UIMapElements