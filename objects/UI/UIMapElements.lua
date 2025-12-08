---@diagnostic disable: lowercase-global
_G.love = require("love")



function UnitHoverDraw(unit, x, y)


    local height = SPRITE_SIZE * 2
    local width = SPRITE_SIZE * 4
    local x_pos = x - (SPRITE_SIZE * 1)
    local y_pos = y - (SPRITE_SIZE * 2 + 10)
    local radius = 10

    if x_pos < 0 then
        x_pos = x
    elseif (x_pos + width) > mapW then
        x_pos = x - ((width + x)- mapW)
    end
    if y_pos < 0 then
        y_pos = y + (SPRITE_SIZE + 10)    
    end

    --Set Base

    love.graphics.setColor(0.1, 0.1, 1, 1)

    love.graphics.rectangle( 'line', x_pos, y_pos, width, height, radius, radius)

    love.graphics.setColor(0.1, 0.25, 1, 0.9)

    love.graphics.rectangle( 'fill', x_pos, y_pos, width, height, radius, radius)
    
    love.graphics.setColor(1, 1, 1, 1)

    --Avatar

    love.graphics.draw(unit.potrait, x_pos + 20, y_pos + 20, 0, 0.35, 0.35)

    --Text

    local text_offset = 125

    local name_text = love.graphics.newText( FONT, unit.name )

    local speed_text = love.graphics.newText( FONT, 'Speed: ' .. unit.speed )
    local dmg_text = love.graphics.newText( FONT, 'Dmg: ' .. unit.damage )
    local range_text = love.graphics.newText( FONT, 'Range: ' .. unit.range )
    local hp_text = love.graphics.newText( FONT, 'HP: ' .. unit.health .. '/100' )



    love.graphics.draw(name_text, x_pos + text_offset, y_pos + 20)
    love.graphics.draw(speed_text, x_pos + text_offset, y_pos + 40)
    love.graphics.draw(dmg_text, x_pos + text_offset, y_pos + 60)
    love.graphics.draw(range_text, x_pos + text_offset, y_pos + 80)

    if unit.health == 100 then

        love.graphics.setColor(0, 1, 0, 1)

    else
        love.graphics.setColor(1, 0.2, 0.2, 1)

    end
    love.graphics.draw(hp_text, x_pos + text_offset, y_pos + 100)
    
    love.graphics.setColor(1, 1, 1, 1)
end


UIMapElements = {
    UnitHoverDraw = UnitHoverDraw,
}

return UIMapElements