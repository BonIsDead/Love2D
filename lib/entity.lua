-- Class
local class = require "lib/middleclass"
Entity = class("Entity")
-- Components
local vec2 = require "lib/hump/vector"

function Entity:initialize(bumpWorld, x,y, t)
    -- ---------- Initializing an entity
    self.world      = bumpWorld
    self.position   = vec2(x,y)
    self.velocity   = vec2()
    -- Collision shape
    self.aabb       = vec2(16,16)
    self.aabbOffset = vec2(8,8)
    -- Other Information
    self.parent     = t
    self.index      = #t
    self.destroyed  = false

    -- ---------- Add to parent table and collision world
    table.insert(t, self)
    self:UpdateBumpShape()
end

function Entity:UpdateBumpShape()
    -- Remove self from bump world
    if self.world:hasItem(self) then self.world:remove(self) end
    -- Change and update shape
    local dx,dy = (self.position.x - self.aabbOffset.x), (self.position.y - self.aabbOffset.y)
    self.world:add(self, dx,dy, self.aabb.x,self.aabb.y)
end

function Entity:move(dt)
    -- Make sure the entity exists
    if self.destroyed == true then return end

    -- Move the entity, with "collisions
    local goalPosition = self.position + self.velocity * dt
    local realX,realY, colls, len = self.world:check(self, goalPosition.x,goalPosition.y)
    self.world:update(self, realX,realY)
    self.position = vec2(realX,realY)
end

-- Fix this later!!! It doesn't work!
function Entity:destroy()
    for key, value in ipairs(self.parent) do
        if (value.index == self.index) then
            self.destroyed = true
            self.world:remove(self)
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
function Entity:drawDebug() end

return Entity