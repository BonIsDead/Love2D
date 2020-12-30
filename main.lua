require "assets/entities/player"
json = require "lib/json"

-- Global variables
_gameWidth = love.graphics.getWidth()
_gameHeight = love.graphics.getHeight()

-- Temporary
_entities = {}
player = Player:new(32, 32)

-- -------------------- Tiles
path = love.filesystem.read("assets/levels/test.ldtk")
mapData = json.decode(path)

-- Populate layers
local layerData = mapData.defs.layers
local layers = {}

for v, i in ipairs(layerData) do
    i.identifier = layerData[v].identifier
    i.type = layerData[v].type
    i.uid = layerData[v].uid
    i.gridSize = layerData[v].gridSize
    i.displayOpacity = layerData[v].displayOpacity
    table.insert(layers, i)
end

local levelData = mapData.defs.levels
local levels = {}

-- TODO LIST
-- [ ] Dump data into tables
-- [ ] Read data from tables
-- [ ] Visualize table data

-- for v, i in ipairs(levelData) do
--     local ld = levelData[v]
--     i.identifier = ld.identifier
--     i.uid = ld.uid
--     i.worldX, i.worldY = ld.worldX, ld.worldY
--     i.pxWid, i.pxHei = ld.pxWid, ld.pxHei
--     i.bgColor = ld.bgColor

--     i.layerInstances = {}
    
--     for v, i in ipairs(i.layerInstances.gridTiles) do
--         table.insert(i.layerInstances, i.layerInstances.gridTiles[v] )
--     end
-- end

-- tex = love.graphics.newImage("assets/spritesheets/FinalFantasy6Tileset.png")
-- tile = love.graphics.newQuad(16,16, 16,16, tex)

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
    -- for x=0,15 do
    --     for y=0,13 do
    --         love.graphics.draw(tex, tile, x*16,y*16)
    --     end
    -- end

    -- Draw entities
    for i, ent in ipairs(_entities) do
        if ent.draw then ent:draw() end
    end
end