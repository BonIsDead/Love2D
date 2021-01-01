-- Class
local class = require "lib/middleclass"
Entity = class("Entity")
-- Components
local vec2 = require "lib/hump/vector"

function Entity:initialize(x,y, t)
    self.position = vec2(x,y)
    self.velocity = vec2()
    self.parent = t

    -- Add to table
    table.insert(t, self)
    self.index = #t
end

function Entity:move(dt)
    -- Move the entity, with "collisions"
    local nx = 0
    while (nx < math.abs(self.velocity.x) ) do
        if self.position.x <= _gameWidth*2 - 16 then
            self.position.x = self.position.x + self.velocity:normalized().x * dt
            nx = nx + 1
        else
            self.position.x = _gameWidth*2 - 16
            self.velocity.x = 0
        end
    end

    local ny = 0
    while (ny < math.abs(self.velocity.y) ) do
        if self.position.y <= _gameHeight-32 - 16 then
            self.position.y = self.position.y + self.velocity:normalized().y * dt
            ny = ny + 1
        else
            self.position.y = _gameHeight-32 - 16
            self.velocity.y = 0
        end
    end

    -- The old, temporary way
    -- self.position = self.position + self.velocity * dt
end

-- Fix this later!!! It doesn't work!
function Entity:destroy()
    for key, value in ipairs(self.parent) do
        if (value.index == self.index) then
            table.remove(self.parent, key)
        end
    end

end

function Entity:draw() end

function Entity:drawDebug()
    -- love.graphics.print(self.index, self.position.x, self.position.y - 32)
end

return Entity