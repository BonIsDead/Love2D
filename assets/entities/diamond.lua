-- CLass
local class     = require "lib/middleclass"
local Diamond   = class("Diamond", require "lib/entity")
-- Components

-- local variables

function Diamond:load()
    self.isCollectible      = true
    self.isVisible          = true
    self.zIndex             = 1

    self.collected          = false

    self.sprite = {}
    self.sprite.graphic     = love.graphics.newImage("assets/spritesheets/Collectibles.png")
    self.sprite.width       = self.sprite.graphic:getWidth()
    self.sprite.height      = self.sprite.graphic:getHeight()
    self.sprite.quad        = love.graphics.newQuad(0,0, 16,16, self.sprite.graphic)
    self.sprite.offset      = {0,0}

    self.aabb.width         = 12
    self.aabb.height        = 12
    self.aabb.offsetx       = 0
    self.aabb.offsety       = 0

    self.timer              = 0
    self.rotationOffset     = (self.position.x + self.position.y) * 0.04
    self.rotationSpeed      = 2
    self.floatDistance      = 1.5
    self.alpha              = 1
    self:UpdateBumpShape()
end

function Diamond:collect()
    if self.collected == false then
        self.collected = true
    end
end

function Diamond:update(dt)
    if (self.collected == true) then
        self.position.y     = self.position.y - 16 * dt
        self.rotationSpeed  = self.rotationSpeed + 0.2 * dt
        self.floatDistance  = self.floatDistance + 2 * dt
        self.alpha          = self.alpha - 0.5 * dt

        -- self.sprite.width   = self.sprite.width + 2 * dt

        if (self.alpha <= 0) then
            self:destroy()
        end
    end

end

function Diamond:draw()
    if (self.isVisible == false) then return end

    local delta = love.timer.getDelta()
    local angle = (self.timer * math.pi) + self.rotationOffset
    local dx    = self.position.x + (self.floatDistance * math.sin(self.rotationSpeed * angle) )
    local dy    = self.position.y + (self.floatDistance * math.cos(self.rotationSpeed * angle) )
    self.timer  = (self.timer + delta)

    love.graphics.setColor(1,1,1, math.floor(self.alpha * 8) / 8)
    love.graphics.draw(self.sprite.graphic, self.sprite.quad, math.floor(dx),math.floor(dy) )
    love.graphics.setColor(1,1,1, 1)
end

return Diamond