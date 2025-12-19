---@diagnostic disable: lowercase-global
_G.love = require("love")

function GetUIProperties()

    local UIProperties = {
        height = SPRITE_SIZE * 3,
        width = screenWidth,
        x_pos = 0 + (cam.x - screenWidth/2),
        y_pos = (screenHeight - (SPRITE_SIZE * 2)) + (cam.y - screenHeight/2),
        radius = 10
    }

    return UIProperties
    
end



function MainUi(UIProperties)   
    --Set Base

    love.graphics.setColor(0, 0, 0, 1)

    love.graphics.rectangle( 'line', UIProperties.x_pos, UIProperties.y_pos, UIProperties.width, UIProperties.height, UIProperties.radius, UIProperties.radius)

    love.graphics.setColor(0.1, 0.1, 0.1, 1)

    love.graphics.rectangle( 'fill', UIProperties.x_pos, UIProperties.y_pos, UIProperties.width, UIProperties.height, UIProperties.radius, UIProperties.radius)
    
    love.graphics.setColor(1, 1, 1, 1)
    
end

function UnitHoverDraw(unit, UIProperties)
    --Avatar

    love.graphics.draw(unit.potrait, UIProperties.x_pos + 20, UIProperties.y_pos + 20, 0, 0.35, 0.35)

    --Text

    local text_offset = 125

    local name_text = love.graphics.newText( FONT, unit.name )

    local speed_text = love.graphics.newText( FONT, 'Speed: ' .. unit.speed )
    local dmg_text = love.graphics.newText( FONT, 'Dmg: ' .. unit.damage )
    local range_text = love.graphics.newText( FONT, 'Range: ' .. unit.range )
    local hp_text = love.graphics.newText( FONT, 'HP: ' .. unit.health .. '/100' )



    love.graphics.draw(name_text, UIProperties.x_pos + text_offset, UIProperties.y_pos + 20)
    love.graphics.draw(speed_text, UIProperties.x_pos + text_offset, UIProperties.y_pos + 40)
    love.graphics.draw(dmg_text, UIProperties.x_pos + text_offset, UIProperties.y_pos + 60)
    love.graphics.draw(range_text, UIProperties.x_pos + text_offset, UIProperties.y_pos + 80)

    if unit.health == 100 then

        love.graphics.setColor(0, 1, 0, 1)

    else
        love.graphics.setColor(1, 0.2, 0.2, 1)

    end
    love.graphics.draw(hp_text, UIProperties.x_pos + text_offset, UIProperties.y_pos + 100)
    
    love.graphics.setColor(1, 1, 1, 1)
end


local UIMapElements = {
    GetUIProperties = GetUIProperties,
    UnitHoverDraw = UnitHoverDraw,
    MainUi = MainUi,
}

return UIMapElements