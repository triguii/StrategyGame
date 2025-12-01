---@diagnostic disable: lowercase-global
_G.love = require("love")

local utils ={}

function utils:addToSet(set, key)
    set[key] = true
end

function utils:removeFromSet(set, key)
    set[key] = nil
end

function utils:setContains(set, key)
    return set[key] ~= nil
end

return utils