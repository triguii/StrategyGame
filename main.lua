---@diagnostic disable: lowercase-global
_G.love = require("love")

local sti = require "libraries/sti"
local Unit = require "objects/unit"
local Game = require "scenes/game"
local camera = require "libraries/camera"

SPRITE_SIZE = 64


function love.load()
    Map1 = sti('maps/map2.lua')

    cam = camera()

    game = Game:create(Map1, 2)
    
    love.window.setMode(640, 640, {resizable = true})


    unidadtest = Unit:new(3, 4, "unidadtest", game)
    unidadtest2 = Unit:new(7, 8, "unidadtest", game)
    
end

function love.update(dt)

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    game:update(dt)
        
end

function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 then

        game:handleLeftClick( x, y, button, istouch, presses )

    end
end



function love.draw()

    love.graphics.setColor(1, 1, 1)

    cam:attach()

    game:draw() 

    cam:detach()

    
    love.graphics.print(tostring(love.timer.getFPS( )), 10, 10)

end




