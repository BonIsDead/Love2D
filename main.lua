Camera = require "hump/camera"
require "assets/entities/player"

-- Why aren't you uploading???

_entities = {}
player = Player:new(32, 32)

function love.load()
    for i, ent in ipairs(_entities) do
        if ent.start then ent:start() end
    end
end

function love.update(dt)
    for i, ent in ipairs(_entities) do
        if ent.update then ent:update(dt) end
    end
end

function love.draw()
    for i, ent in ipairs(_entities) do
        if ent.draw then ent:draw() end
    end
end