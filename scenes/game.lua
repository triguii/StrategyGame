
---@diagnostic disable: lowercase-global
---
_G.love = require("love")


local pathfinder = require('libraries/pathfinder')
local Player = require('objects/player')
local tileDataTypes = require "objects/tileDataTypes"

local Game = {}

function Game:create(map, num_players)

    self.active_units = {}
    self.players = {}
    self.map = map

    self.selected = nil
    self.movable_tiles = nil
    self.menu_active = false

    self.current_id = 0

    self.cursor_image = love.graphics.newImage('/sprites/ui/cursor.png')


    for i = 1, num_players, 1 do

        self.players[i] = Player:new(i)
        
    end

    return self

end

function Game:addUnit(unit)

    self.active_units[self.current_id] = unit
    self.current_id = self.current_id + 1

    return self.current_id - 1

end

function Game:draw()

    -- Hay que dibujar cada layer individualmente por la libreria de la camara

    self.map:drawLayer(self.map.layers['Base'])
    self.map:drawLayer(self.map.layers['Bioma'])

    self:highlightCurrentTile()

    for id, unit in pairs(self.active_units) do

        local x_unit_px, y_unit_px = self.map:convertTileToPixel (unit.x, unit.y)

        if unit.moved then
            love.graphics.setColor(0.6, 0.6, 0.6, 255)
        end

        love.graphics.draw(unit.sprite, x_unit_px, y_unit_px)

        love.graphics.setColor(255, 255, 255, 255)


    end

    if self.selected then

        if self.movable_tiles == nil then
            self.movable_tiles = pathfinder:getMovableTiles( self.selected, self )

        end
        love.graphics.setColor(0.5, 0.5, 0, 255)

        for i, tile in ipairs(self.movable_tiles) do
            local x_px, y_px = self.map:convertTileToPixel (tile.x, tile.y)
            love.graphics.setBlendMode("multiply", "premultiplied")
            love.graphics.rectangle('fill', x_px, y_px, SPRITE_SIZE, SPRITE_SIZE )

            love.graphics.setBlendMode("alpha")
            love.graphics.rectangle('line', x_px, y_px, SPRITE_SIZE, SPRITE_SIZE )


        end


        love.graphics.setColor(255, 255, 255, 255)
    end

    
end


function Game:update(dt)
    self:camaraManagerUpdate(dt)
end

function Game:highlightCurrentTile()

    local world_x, world_y =  cam:worldCoords(love.mouse.getPosition())
    local tile_x, tile_y = self.map:convertPixelToTile(world_x, world_y)
    local x_px, y_px = self.map:convertTileToPixel(math.floor(tile_x), math.floor(tile_y))


    love.graphics.draw(self.cursor_image, x_px, y_px)
end

function Game:checkUnitMove (X, Y)

    for id, tile in pairs(self.movable_tiles) do

        local x_tile_px, y_tile_px = self.map:convertTileToPixel(tile.x, tile.y)
    
        if (X > x_tile_px and X < (x_tile_px) + SPRITE_SIZE) and
            (Y > y_tile_px and Y < (y_tile_px) + SPRITE_SIZE) then
                return tile
        end
    end

    return nil
    
end

function Game:checkUnitClicked (X, Y)
    for id, unit in pairs(self.active_units) do
        if unit.moved == false then

            local x_unit_px, y_unit_px = self.map:convertTileToPixel(unit.x, unit.y)
        
            if (X > x_unit_px and X < (x_unit_px) + SPRITE_SIZE) and
                (Y > y_unit_px and Y < (y_unit_px) + SPRITE_SIZE) then
                    return id
            end
        end
    end

    return nil
end

function Game:handleLeftClick(x, y, button, istouch, presses)

    local world_x, world_y = cam:worldCoords(x, y)
    
    if self.selected then

        local move_tile = self:checkUnitMove( world_x, world_y )

        if move_tile then
            self.selected:moveUnit( move_tile.x, move_tile.y )
        end
    
        self.selected = nil
        self.movable_tiles = nil

    else
        local id_unit_clicked = self:checkUnitClicked( world_x, world_y )

        if id_unit_clicked then
            self.selected = self.active_units[id_unit_clicked]
        else
            self.selected = nil
            self.movable_tiles = nil
            self.menu_active = not self.menu_active
        end

    end
    
end

function Game:checkTileType(x_tl, y_tl)
    local mapW = self.map.width * self.map.tilewidth
    local mapH = self.map.height * self.map.tileheight

    if x_tl < 0 or x_tl > mapW or  y_tl < 0 or x_tl > mapH then
        return {name = 'oob', cost = math.huge}
    end

    local x_px, y_px = self.map:convertTileToPixel(x_tl, y_tl)

    local id_unit_clicked = self:checkUnitClicked( x_px, y_px )

    if id_unit_clicked then
        return {name = 'unit', cost = math.huge}
    end

    local layer = self.map.layers["Bioma"]

    local tile_data = layer.data[y_tl+1][x_tl+1]
    -- La coordenada y va primera porque asi lo hace la libreria

    if tile_data ~= nil then
  
        return tileDataTypes[tile_data.id]
        
    end
    
    return tileDataTypes[0]
    
end

function Game:camaraManagerUpdate(dt)

    if love.keyboard.isDown("w") then
        
        cam:move(0, dt - 5)
        
    end   
    
    if love.keyboard.isDown("s") then
        
        cam:move(0, dt + 5)
        
    end    
    
    if love.keyboard.isDown("a") then
        
        cam:move(dt - 5, 0)
        
    end    
    
    if love.keyboard.isDown("d") then
        
        cam:move(dt + 5, 0)
        
    end

    -- Left border
    if cam.x < screenWidth/2 then
        cam.x = screenWidth/2
    end

    -- Right border
    if cam.y < screenHeight/2 then
        cam.y = screenHeight/2
    end

    -- Get width/height of background
    local mapW = self.map.width * self.map.tilewidth
    local mapH = self.map.height * self.map.tileheight

    -- Right border
    if cam.x > (mapW - screenWidth/2) then
        cam.x = (mapW - screenWidth/2)
    end
    -- Bottom border
    if cam.y > (mapH - screenHeight/2) then
        cam.y = (mapH - screenHeight/2)
    end
    
end

return Game