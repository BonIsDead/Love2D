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
    self.position = self.position + self.velocity * dt
    self.position = self.position + self.velocity * dt
end

function Entity:draw()
    love.graphics.rectangle("line", self.position.x, self.position.y, 32, 32)
end

return Entity