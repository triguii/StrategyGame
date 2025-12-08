---@diagnostic disable: lowercase-global
_G.love = require("love")

local unit_stats = require "objects/unitStats"

local Unit = {}
Unit.__index = Unit


function Unit:new(x, y, id_unit, grid)

    local newUnit  = setmetatable({}, Unit)

    local unit_stats = unit_stats[id_unit]

    newUnit.name = unit_stats.name

    newUnit.x = x
    newUnit.y = y
    newUnit.speed = unit_stats.speed
    newUnit.health = 100
    newUnit.damage = unit_stats.damage
    newUnit.range = unit_stats.range

    newUnit.grid = grid
    newUnit.moved = false
    newUnit.sprite = love.graphics.newImage(unit_stats.sprite_path)
    newUnit.potrait = love.graphics.newImage(unit_stats.potrait_path)


    newUnit.id = newUnit.grid:addUnit(newUnit)

    return self
    
end

function Unit:moveUnit( x, y )

    self.x = x
    self.y = y
    self.moved = false
    
end

return Unit
