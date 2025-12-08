---@diagnostic disable: lowercase-global
_G.love = require("love")

local utils = require('libraries/utils')

local pathfinder = {}

function pathfinder:getMovableTiles (unit, game)

    local movable_tiles = {}
    local tiles_to_check = {{x = unit.x, y = unit.y, cost = unit.speed}}
    local tiles_checked_set = {}
    local tile_type = ""
    local first_iter = true

    while next(tiles_to_check) ~= nil do

        local index, tile = next(tiles_to_check)

        --Esta comprobacion no hace falta pero si no sale raro en el vscode
        if tile ~= nil then

            local tile_checked = utils:setContains(tiles_checked_set, tile.x .. tile.y)

            if tile_checked == false then
                tile_type = game:checkTileType(tile.x, tile.y, first_iter)

                if tile.cost - tile_type.cost > 0  then

                    table.insert(movable_tiles, {x = tile.x, y = tile.y})
                    utils:addToSet(tiles_checked_set, tile.x .. tile.y)

                    table.insert(tiles_to_check, {x = tile.x + 1, y = tile.y, cost = tile.cost - tile_type.cost})
                    table.insert(tiles_to_check, {x = tile.x - 1, y = tile.y, cost = tile.cost - tile_type.cost})
                    table.insert(tiles_to_check, {x = tile.x, y = tile.y + 1, cost = tile.cost - tile_type.cost})
                    table.insert(tiles_to_check, {x = tile.x, y = tile.y - 1, cost = tile.cost - tile_type.cost})
                        
                    
                end          
                
            end
        end

        first_iter = false
        table.remove(tiles_to_check, index)

    end
    
    return movable_tiles
    
end

return pathfinder