require "assets/entities/player"
json = require "lib/json"

-- Global variables
_gameWidth = love.graphics.getWidth()
_gameHeight = love.graphics.getHeight()

-- Temporary
_entities = {}
player = Player:new(32, 32)

-- -------------------- Tiles
-- Path information
local assets = "assets"

path = love.filesystem.read("assets/levels/test.ldtk")
mapData = json.decode(path)

-- ---------- Populate layers
local layerData = mapData.defs.layers
local layers = {}

-- Fill the layers table
for v, i in ipairs(layerData) do
    i.identifier = layerData[v].identifier
    i.type = layerData[v].type
    i.uid = layerData[v].uid
    i.gridSize = layerData[v].gridSize
    i.displayOpacity = layerData[v].displayOpacity
    table.insert(layers, i)
end

-- ---------- Populate levels
local levelData = mapData.levels
local levels = {}

-- Fill the levels table
for i=1,#levelData do
    local ld = levelData[i]
    local l = {}
    l.tiles = {}

    -- Get level data
    l.identifier, l.uid = ld.__identifier, ld.uid
    l.worldX, l.worldY = ld.worldX, ld.worldY
    l.pxWid, l.pxHei = ld.pxWid, ld.pxHei
    l.bgColor = ld.__bgColor

    -- Get layer instances
    l.layerInstances = {}
    for i=1,#ld.layerInstances do
        l.layerInstances[i] = ld.layerInstances[i]

        -- Create the tileset texture, fixing file path
        local tilesetPath = assets .. string.sub(l.layerInstances[i].__tilesetRelPath, 3, -1)
        if love.filesystem.getInfo(tilesetPath) then
            l.tilesetTexture = love.graphics.newImage(tilesetPath)
        else
            print("Could not locate tileset texture!")
        end

        local gridSize = l.layerInstances[i].__gridSize

        for ii=1,#ld.layerInstances[i].gridTiles do
            -- Create tiles
            local gt = l.layerInstances[i].gridTiles[ii]

            -- Get tile variables
            local pos,src,f = { ["x"] = gt.px[1], ["y"] = gt.px[2] }, { ["x"] = gt.src[1], ["y"] = gt.src[2] }, gt.f

            -- Create tile
            local tile = {}
            tile.pos, tile.src, tile.f = pos, src, f
            tile.quad = love.graphics.newQuad(src.x, src.y, gridSize, gridSize, l.tilesetTexture)

            -- Add tile to the tiles table
            table.insert(l.tiles, tile)
        end
    end

    -- Add to the levels table
    table.insert(levels, l)
end

function love.load()
    -- Load entities
    for i, ent in ipairs(_entities) do
        if ent.start then ent:start() end
    end
end

function love.update(dt)
    -- Update entities
    for i, ent in ipairs(_entities) do
        if ent.update then ent:update(dt) end
    end
end

function love.draw()
    -- Draw tileset
    local l = levels[1]
    local t = l.tiles
    local gs = l.layerInstances[1].__gridSize

    for i=1, #t do
        -- ---------- Set up tile
        -- Tile flipping
        -- I'm positive this could be written better, but it works for now!
        local px,py, sx,sy, f = t[i].pos.x, t[i].pos.y, 1,1, 0

        if (t[i].f == 1) then -- Flip horizontal
            px = px + gs
            sx = -1
        end
        if (t[i].f == 3) then -- Flip vertical
            py = py + gs
            sy = -1
        end

        -- Draw the tile
        love.graphics.draw(l.tilesetTexture, t[i].quad, px,py, 0,sx,sy)
    end

    -- Draw entities
    for i, ent in ipairs(_entities) do
        if ent.draw then ent:draw() end
    end
end