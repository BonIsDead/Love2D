-- Class
local class = require "lib/middleclass"
Entity = class("Entity")
-- Components
local vec2 = require "lib/hump/vector"

function Entity:initialize(bumpWorld, x,y, t)
    self.world      = bumpWorld
    self.position   = vec2(x,y)
    self.velocity   = vec2()
    self.parent     = t
    self.collidable = true

    -- Add to table
    table.insert(t, self)
    self.index = #t
    -- Add to bump world
    bumpWorld:add(self, self.position.x,self.position.y, 16,16)
end

function Entity:move(dt)
    -- Move the entity, with "collisions"
    -- local ax,ay, colls, len = self.world:move()

    -- local nx = 0
    -- while (nx < math.abs(self.velocity.x) ) do
    --     if self.position.x <= _gameWidth*2 - 16 then
    --         fx = fx + self.velocity:normalized().x * dt
    --         nx = nx + 1
    --     else
    --         fx = _gameWidth*2 - 16
    --         self.velocity.x = 0
    --     end
    -- end

    -- local ny = 0
    -- while (ny < math.abs(self.velocity.y) ) do
    --     if fy <= _gameHeight-32 - 16 then
    --         fy = fy + self.velocity:normalized().y * dt
    --         ny = ny + 1
    --     else
    --         fy = _gameHeight-32 - 16
    --         self.velocity.y = 0
    --     end
    -- end

    local goalPosition = self.position + self.velocity * dt
    local realX,realY, colls, len = self.world:check(self, goalPosition.x,goalPosition.y)
    self.world:update(self, realX,realY)
    self.position = vec2(realX,realY)
end

-- Fix this later!!! It doesn't work!
function Entity:destroy()
    for key, value in ipairs(self.parent) do
        if (value.index == self.index) then
            -- self.world:remove(self)
            table.remove(self.parent, key)
        end
    end

end

function Entity:checkCollision(checkPosition)
    local ax,ay,cols,len = self.world:check(self, checkPosition.x,checkPosition.y)

    for i=1, len do
        local other = cols[i].other
    end
end

function Entity:draw() end

function Entity:drawDebug()
    -- love.graphics.print(self.index, self.position.x, self.position.y - 32)
end

return Entity