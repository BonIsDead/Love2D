require "assets/entities/player"

-- Global variables
_gameWidth = love.graphics.getWidth()
_gameHeight = love.graphics.getHeight()

-- Temporary
_entities = {}
player = Player:new(32, 32)

tex = love.graphics.newImage("assets/spritesheets/FinalFantasy6Tileset.png")
tile = love.graphics.newQuad(16,16, 16,16, tex)

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
    for x=0,15 do
        for y=0,13 do
            love.graphics.draw(tex, tile, x*16,y*16)
        end
    end

    -- Draw entities
    for i, ent in ipairs(_entities) do
        if ent.draw then ent:draw() end
    end
end