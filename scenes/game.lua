
---@diagnostic disable: lowercase-global
---
_G.love = require("love")


local pathfinder = require('libraries/pathfinder')
local Player = require('objects/player')
local tileDataTypes = require "objects/tileDataTypes"

local UIMapElements = require('objects.UI.UIMapElements')

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

    mapW = self.map.width * self.map.tilewidth
    mapH = self.map.height * self.map.tileheight


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

    --Draw Cursor
    love.graphics.draw(self.cursor_image, current_tile_x_px, current_tile_y_px)


    
    for id, unit in pairs(self.active_units) do

        local x_unit_px, y_unit_px = self.map:convertTileToPixel (unit.x, unit.y)

        if unit.moved then
            love.graphics.setColor(0.6, 0.6, 0.6, 1)
        end

        love.graphics.draw(unit.sprite, x_unit_px, y_unit_px)

        love.graphics.setColor(1, 1, 1, 1)


    end

    if self.selected then

        if self.movable_tiles == nil then
            self.movable_tiles = pathfinder:getMovableTiles( self.selected, self )

        end
        love.graphics.setColor(0.5, 0.5, 0, 1)

        for i, tile in ipairs(self.movable_tiles) do
            local x_px, y_px = self.map:convertTileToPixel (tile.x, tile.y)
            love.graphics.setBlendMode("multiply", "premultiplied")
            love.graphics.rectangle('fill', x_px, y_px, SPRITE_SIZE, SPRITE_SIZE )

            love.graphics.setBlendMode("alpha")
            love.graphics.rectangle('line', x_px, y_px, SPRITE_SIZE, SPRITE_SIZE )


        end

        love.graphics.setColor(1, 1, 1, 1)
    end

    --Draw HoverTooltip
    
    if unit_hovered and self.selected == nil then
        UIMapElements.UnitHoverDraw(self.active_units[unit_hovered] , current_tile_x_px, current_tile_y_px)
    end

    
end

function Game:update(dt)
    self:camaraManagerUpdate(dt)

    self:manageHover(dt)
end

function Game:manageHover(dt)
    current_tile_x_px, current_tile_y_px = self:getCurrentTile()

    world_x_hovered, world_y_hovered = cam:worldCoords(current_tile_x_px, current_tile_y_px)

    world_x_hovered = world_x_hovered + 1
    world_y_hovered = world_y_hovered + 1

    current_tile_x_px = current_tile_x_px + 1
    current_tile_y_px = current_tile_y_px + 1

    unit_hovered = self:checkUnitPos(current_tile_x_px, current_tile_y_px)
    
end

function Game:getCurrentTile()

    local world_x, world_y =  cam:worldCoords(love.mouse.getPosition())
    local tile_x, tile_y = self.map:convertPixelToTile(world_x, world_y)
    local x_px, y_px = self.map:convertTileToPixel(math.floor(tile_x), math.floor(tile_y))

    return x_px, y_px
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

function Game:checkUnitPos (X, Y)
    for id, unit in pairs(self.active_units) do
        local x_unit_px, y_unit_px = self.map:convertTileToPixel(unit.x, unit.y)
    
        if (X > x_unit_px and X < (x_unit_px) + SPRITE_SIZE) and
            (Y > y_unit_px and Y < (y_unit_px) + SPRITE_SIZE) then
                return id
        end
        
    end

    return nil
end

function Game:handleLeftClick(x, y, button, istouch, presses)

    --local world_x, world_y = cam:worldCoords(x, y)
    
    if self.selected then

        local move_tile = self:checkUnitMove( current_tile_x_px, current_tile_y_px )

        if move_tile then
            self.selected:moveUnit( move_tile.x, move_tile.y )
        end
    
        self.selected = nil
        self.movable_tiles = nil

    else
        if unit_hovered then
            self.selected = self.active_units[unit_hovered]
        else
            self.selected = nil
            self.movable_tiles = nil
            self.menu_active = not self.menu_active
        end

    end
    
end

function Game:checkTileType(x_tl, y_tl, first_iter)
    local first_iter = first_iter or false

    if x_tl < 0 or x_tl > mapW or  y_tl < 0 or x_tl > mapH then
        return {name = 'oob', cost = math.huge}
    end

    local x_px, y_px = self.map:convertTileToPixel(x_tl, y_tl)

    local id_unit_clicked = self:checkUnitPos( x_px + 1, y_px + 1)

    if id_unit_clicked ~= nil and first_iter == false then
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