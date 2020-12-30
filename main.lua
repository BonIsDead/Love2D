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

    -- Get level data
    l.identifier, l.uid = ld.__identifier, ld.uid
    l.worldX, l.worldY = ld.worldX, ld.worldY
    l.pxWid, l.pxHei = ld.pxWid, ld.pxHei
    l.bgColor = ld.__bgColor

    -- Get layer instances
    l.layerInstances = {}
    for i=1,#ld.layerInstances do
        l.layerInstances[i] = ld.layerInstances[i]
    end

    -- Add to the levels table
    table.insert(levels, l)
end

-- It can read the files! Hurray!
print(levels[1].layerInstances[1].gridTiles[1].px[1] )

-- tilesetPath = levels[1].layerInstances[1].__tilesetRelPath
-- tex = love.graphics.newImage(tilesetPath)

-- Just here so I don't forget how to do this!!!
-- tex = love.graphics.newImage("assets/spritesheets/FinalFantasy6Tileset.png")
-- tile = love.graphics.newQuad(16,16, 16,16, tex)

-- package.path = 

function love.load()
    print("PP - " .. package.path)
    print("Love Source - " .. love.filesystem.getSource() )
    tilesetPath = "../spritesheets/FinalFantasy6Tileset.png" --levels[1].layerInstances[1].__tilesetRelPath
    print(tilesetPath)
    if love.filesystem.getInfo(tilesetPath) then
        print("It worked!")
    else
        print("File not found!")
    end

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