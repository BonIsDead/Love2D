local ldtk = require"assets/scripts/ldtk-importer"
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

-- for i=1, #levelData do
--     local data = levelData[i]
--     local l = {}

--     -- Get level data
--     l.identifier, l.uid = data.__identifier, data.uid
--     l.worldX, l.worldY  = data.worldX, data.worldY
--     l.pxWid, l.pxHei    = data.pxWid, data.pxHei
--     l.bgColor           = data.__bgColor

--     -- Get layer instances
--     l.layerInstances = {}
--     l.entityInstances = {}
--     l.gridTiles = {}



    -- for i=1, #data.layerInstances do
    --     -- Get Entities
    --     if (data.layerInstances[i].__type == "Entities") then
    --         print("\tEntity layer found, but ignored for now.")
    --     end

    --     -- Get Tiles
    --     if (data.layerInstances[i].__type == "Tiles") then
    --         print("\tLayer: " .. data.layerInstances[i].__identifier) -- Debug

    --         l.gridSize = data.layerInstances[i].__gridSize

    --         -- Create the tileset texture, fixing file path
    --         local tilesetPath = assets .. string.sub(data.layerInstances[i].__tilesetRelPath, 3, -1)
    --         if love.filesystem.getInfo(tilesetPath) then
    --             l.tilesetTexture = love.graphics.newImage(tilesetPath)
    --         else
    --             print("Could not locate tileset texture!")
    --         end

    --         l.gridSize = data.layerInstances[i].__gridSize

    --         for ii=1,#data.layerInstances[i].gridTiles do
    --             -- Create tiles
    --             local gt = data.layerInstances[i].gridTiles[ii]

    --             -- Get tile variables
    --             local pos,src,f = { ["x"] = gt.px[1], ["y"] = gt.px[2] }, { ["x"] = gt.src[1], ["y"] = gt.src[2] }, gt.f

    --             -- Create tile
    --             local tile = {}
    --             tile.pos, tile.src, tile.f = pos, src, f
    --             tile.quad = love.graphics.newQuad(src.x, src.y, l.gridSize, l.gridSize, l.tilesetTexture)

    --             -- Add tile to the tiles table
    --             table.insert(l.gridTiles, tile)
    --         end
    --     end

    -- end

    -- Add to the levels table
    -- table.insert(levels, l)
-- end

function love.load()
    newMap = ldtk("assets/levels/test.ldtk")

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
    -- for i=1, #layerInstances do
    --     local gridTiles = layerInstances[i].gridTiles
    --     local gridSize = layerInstances[i].gridSize

    --     print(i)

    --     for ii=1, #gridTiles do
    --         -- ---------- Set up tile
    --         -- Tile flipping
    --         -- I'm positive this could be written better, but it works for now!
    --         local px,py, sx,sy, f = gridTiles[ii].pos.x, gridTiles[ii].pos.y, 1,1, 0

    --         if (gridTiles[ii].f == 1) then -- Flip horizontal
    --             px = px + gs
    --             sx = -1
    --         end
    --         if (gridTiles[ii].f == 3) then -- Flip vertical
    --             py = py + gs
    --             sy = -1
    --         end

    --         -- Draw the tile
    --         love.graphics.draw(levels[currentLevel].layerInstances.tilesetTexture, gridTiles[ii].quad, px,py, 0,sx,sy)
    --         love.graphics.circle("line", px,py, 4)
    --     end
    -- end

    newMap.drawMap()

    -- Draw entities
    for i, ent in ipairs(_entities) do
        if ent.draw then ent:draw() end
    end
end