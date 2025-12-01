---@diagnostic disable: lowercase-global
_G.love = require("love")

local Player = {}
Player.__index = Player

function Player:new(id_player)

    local newPlayer  = setmetatable({}, Player)

    newPlayer.id = id_player
    
    return self
    
end

return Player
