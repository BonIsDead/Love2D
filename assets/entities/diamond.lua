-- CLass
local class     = require "lib/middleclass"
local Diamond   = class("Diamond", require "lib/entity")
-- Components

-- local variables

function Diamond:load()
    self.isCollectible      = true

    self.sprite = {}
    self.sprite.graphic     = love.graphics.newImage("assets/spritesheets/Collectibles.png")
    self.sprite.width       = self.sprite.graphic:getWidth()
    self.sprite.height      = self.sprite.graphic:getHeight()
    self.sprite.quad        = love.graphics.newQuad(0,0, 16,16, self.sprite.graphic)
    self.sprite.offset      = {0,0}

    self.aabb.width         = 8
    self.aabb.height        = 8
    self.aabb.offsetx       = 4
    self.aabb.offsety       = 4
    self:UpdateBumpShape()
end

function Diamond:update(dt) end

function Diamond:draw()
    love.graphics.draw(self.sprite.graphic, self.sprite.quad, self.position.x,self.position.y)
end

return Diamond