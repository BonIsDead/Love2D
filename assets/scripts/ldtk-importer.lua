-- Class
local class = require "lib/middleclass"
LDtk = class("LDtk")
-- References
local assets = "assets"

local LDtkWorld = {}

function LDtk:initialize(LDtkPath)
    local map = {}

    -- Check file & create JSON
    filePath = love.filesystem.read(LDtkPath)
    if (love.filesystem.getInfo(filePath) ) then
        print("The LDtk file specified could not be found!")
        return
    else
        print("LDtk Map Loaded.")
        data = json.decode(filePath)
    end

    -- Setup world information
    map.bgColor = data.bgColor
    map.defs = data.defs
    map.levels = data.levels
    map.totalLevels = #map.levels
    print(map.totalLevels)

    -- Populate layers
    for i=1, #map.levels do
        for j=1, #map.levels[i].layerInstances do
            local l = map.levels[i].layerInstances[j]

            -- Create tile quads table
            map.levels[i].layerInstances[j].quadTiles = {}

            -- Check for entity layers
            if (l.__type == "Entity") then
                -- blah
            end

            -- Check for tile layers
            if (l.__type == "Tiles") then
                local tilesetPath   = assets .. string.sub(l.__tilesetRelPath, 3, -1)
                l.tilesetImage  = love.graphics.newImage(tilesetPath)

                for k=1, #l.gridTiles do
                    local gt = l.gridTiles[k]
                    local tile = {}

                    tile.pos    = { ["x"] = gt.px[1], ["y"] = gt.px[2] }
                    tile.src    = { ["x"] = gt.src[1], ["y"] = gt.src[2] }
                    tile.f      = gt.f
                    tile.quad   = love.graphics.newQuad(tile.src.x, tile.src.y, 16, 16, l.tilesetImage)
                    
                    -- Add tile to tiles table
                    table.insert(map.levels[i].layerInstances[j].quadTiles, tile)
                end
            end

            -- End of loops
        end
    end

    LDtkWorld = map
end

function LDtk:getLevel(lvl)
end

function LDtk:draw(camera) -- Takes a camera to know what to ignore, for now!
    local camX, camY = camera:position()

    local currentLevel = 1

    -- Iterate through level
    for i=1, #LDtkWorld.levels[currentLevel].layerInstances do
        local size = (#LDtkWorld.levels[currentLevel].layerInstances + 1) - i
        local li = LDtkWorld.levels[currentLevel].layerInstances[size]

        local margin = 16
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