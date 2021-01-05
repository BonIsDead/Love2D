-- Class
local class = require "lib/middleclass"
LDtk = class("LDtk")
-- References
local assets = "assets"

-- Tilemap settings
local LDtkWorld = {}

function LDtk:initialize(LDtkPath, bumpWorld)
    local map = {}

    -- Check file & create JSON
    filePath = love.filesystem.read(LDtkPath)
    if (love.filesystem.getInfo(filePath) ) then
        print("The LDtk file specified could not be found!")
        return
    else
        data = json.decode(filePath)
    end

    -- Setup world information
    map.bgColor = data.bgColor
    map.defs = data.defs
    map.levels = data.levels
    map.totalLevels = #map.levels

    -- Populate layers
    for i=1, #map.levels do
        for j=1, #map.levels[i].layerInstances do
            local l = map.levels[i].layerInstances[j]

            -- ---------- Populate entities
            map.levels[i].layerInstances[j].entities = {}
            -- Check for entity layers
            if (l.__type == "Entities") then
                -- Create the entities
                for m=1, #l.entityInstances do
                    -- Get field instances
                    for f=1, #l.entityInstances[m].fieldInstances do
                        local ent       = l.entityInstances[m]
                        local entField  = ent.fieldInstances[f]

                        if entField.__identifier == "entityPath" then
                            local entInstance = require(entField.__value)
                            local e = entInstance(bumpWorld, ent.px[1],ent.px[2], _entities)
                        end
                    end
                end
            end

            -- ---------- Populate grid tiles
            map.levels[i].layerInstances[j].quadTiles = {}
            -- Check for tile layers
            if (l.__type == "Tiles") then
                local tilesetPath   = assets .. string.sub(l.__tilesetRelPath, 3, -1)
                l.tilesetImage  = love.graphics.newImage(tilesetPath)

                for k=1, #l.gridTiles do
                    local gt = l.gridTiles[k]
                    local tile = {}

                    tile.pos        = { ["x"] = gt.px[1], ["y"] = gt.px[2] }
                    tile.src        = { ["x"] = gt.src[1], ["y"] = gt.src[2] }
                    tile.f          = gt.f
                    tile.quad       = love.graphics.newQuad(tile.src.x, tile.src.y, l.__gridSize, l.__gridSize, l.tilesetImage)
                    tile.isSolid    = true
                    
                    -- Add tile to tiles table
                    table.insert(map.levels[i].layerInstances[j].quadTiles, tile)
                end
            end

            -- End of loops
        end
    end

    LDtkWorld = map
end

function LDtk:addCollisions(level, world)
    -- Add tile to bump world
    -- for i=1, #LDtkWorld.levels[level].layerInstances do
    --     for j=1, #LDtkWorld.levels[level].layerInstances[j].quadTiles do
    --         bumpWorld:add(tile, tile.pos.x,tile.pos.y, l.__gridSize,l.__gridSize)
    --     end
    -- end

    local layerInstances = LDtkWorld.levels[level].layerInstances

    -- Iterate through layers
    for i=1, #layerInstances do
        if layerInstances[i].__identifier == "Collisions" then
            for j=1, #layerInstances[i].quadTiles do
                local tile = layerInstances[i].quadTiles[j]
                local gridSize = layerInstances[i].__gridSize

                world:add(tile, tile.pos.x,tile.pos.y, gridSize,gridSize)
            end
        end
    end
     
end

function LDtk:draw(camera) -- Takes a camera to know what to ignore, for now!
    local camX, camY = camera:position()

    local currentLevel = 1

    -- Iterate through level
    for i=1, #LDtkWorld.levels[currentLevel].layerInstances do
        local size = (#LDtkWorld.levels[currentLevel].layerInstances + 1) - i
        local li = LDtkWorld.levels[currentLevel].layerInstances[size]

        local margin = -16
        local left, right = (camX - _gameWidth/2) + margin, (camX + _gameWidth/2) - margin
        local up, down = (camY - _gameHeight/2) + margin, (camY + _gameWidth/2) - margin

        for j=1, #li.quadTiles do
            local tile = li.quadTiles[j]

            -- Flip and adjust tiles... probably could be better!
            local sx,sy, ox,oy = 1,1, 0,0
            if (tile.f == 1) or (tile.f == 3) then  -- Horizontal flip and offset
                ox = li.__gridSize
                sx = -1
            end
            if (tile.f == 2) or (tile.f == 3) then  -- Vertical flip and offset
                oy = li.__gridSize
                sy = -1
            end

            if (tile.pos.x >= left) and (tile.pos.x <= right) and (tile.pos.y >= up) and (tile.pos.y <= down) then
                love.graphics.draw(li.tilesetImage, tile.quad, tile.pos.x, tile.pos.y, 0, sx, sy, ox, oy)
            end
        end
    end

end

return LDtk