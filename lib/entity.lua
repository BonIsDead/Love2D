-- Class
local class = require "lib/middleclass"
Entity = class("Entity")
-- Components
local vec2 = require "hump/vector"

function Entity:initialize(x,y, w,h)
    self.position = vec2(x,y)
    self.velocity = vec2()

    table.insert(_entities, self)
end

function Entity:move(dt)
    -- Move the entity, with "collisions"
    local nx = 0
    while (nx < math.abs(self.velocity.x) ) do
        if self.position.x <= _gameWidth - 16 then
            self.position.x = self.position.x + self.velocity:normalized().x * dt
            nx = nx + 1
        else
            self.position.x = _gameWidth - 16
            self.velocity.x = 0
        end
    end

    local ny = 0
    while (ny < math.abs(self.velocity.y) ) do
        if self.position.y <= _gameHeight - 16 then
            self.position.y = self.position.y + self.velocity:normalized().y * dt
            ny = ny + 1
        else
            self.position.y = _gameHeight - 16
            self.velocity.y = 0
        end
    end

    -- The old, temporary way
    -- self.position = self.position + self.velocity * dt
end

function Entity:draw()
    love.graphics.rectangle("line", self.position.x, self.position.y, 32, 32)
end

return Entity