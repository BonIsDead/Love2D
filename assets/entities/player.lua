-- Class
local class = require "lib/middleclass"
local Player = class("Player", require "lib/entity")
-- Components
local vec2 = require "lib/hump/vector"

function Player:load()
    -- Player variables
    self.type           = "player"
    self.isGrounded     = false
    self.zIndex         = 2
    self.isVisible      = true

    self.acceleration   = 8
    self.maxSpeed       = 128
    self.jumpForce      = 128 + 32
    self.airBoost       = 7
    self.airDrag        = 0.4
    self.gravity        = 12
    self.maxFallSpeed   = 8
    self.canJump        = false

    -- Set player on the floor
    self.position.y = self.position.y + 4

    -- Set graphics
    self.sprite = {}
    self.sprite.graphic = love.graphics.newImage("assets/sprites/Alfred.png")
    self.sprite.width   = self.sprite.graphic:getWidth()
    self.sprite.height  = self.sprite.graphic:getHeight()
    self.sprite.offset  = vec2(0,-10)

    -- Change collision shape
    self.aabb.width     = 8
    self.aabb.height    = 12
    self:UpdateBumpShape()
end

function Player:update(dt)
    -- -------------------- Check for Collisions
    self.isGrounded = self:checkGrounded()

    -- Gravity
    if self.isGrounded then
        -- Player is on the ground
        local ax,ay,cols,len = self.world:check(self, self.position.x,self.position.y + 1)

        for i=1, len do
            local other = cols[i].other

            if other.isSolid then
                if self.velocity.y > 0 then
                    self.position.y = cols[i].touch.y
                    self.velocity.y = 0
                end
            end
        end
    else
        -- Player is in the air
        local ax,ay,cols,len = self.world:check(self, self.position.x,self.position.y - 1)

        for i=1, len do
            local other = cols[i].other

            if other.isSolid then
                self.velocity.y = 0
            end
        end

        self.velocity.y = self.velocity.y + self.gravity
    end

    -- -------------------- Player Input
    -- Get input
    local direction = vec2()
    if love.keyboard.isDown("left") then
        direction.x = -1
    elseif love.keyboard.isDown("right") then
        direction.x = 1
    end

    -- Jumping
    if love.keyboard.isDown("z") and (self.isGrounded == true) then
        self.velocity.y = -self.jumpForce
    elseif love.keyboard.isDown("z") and (self.isGrounded == false) then
        if self.velocity.y < 0 then
            self.velocity.y = self.velocity.y - self.airBoost
        end
    end

    -- -------------------- Update Player Movement
    local accel = self.acceleration
    if self.isGrounded == false then accel = accel * self.airDrag end

    local goal = direction * self.maxSpeed
    local temp = self.velocity:clone()
    temp = temp:lerp(goal, accel * dt)
    self.velocity.x = temp.x

    self:movePlayer(dt)
end

function Player:movePlayer(dt)
    if (self.destroyed == true) then return end

    local filter = function(item, other)
        if other.isCollectible      then return "cross"
        elseif other.isSolid        then return "slide"
        end
    end

    local goalPosition      = self.position + self.velocity * dt
    local ax,ay,cols,len    = self.world:check(self, goalPosition.x,goalPosition.y, filter)
    self.world:update(self, ax,ay)
    self.position = vec2(ax,ay)

    for i=1, len do
        local other = cols[i].other

        if other.isCollectible then
            other:collect()
        end
    end
end

function Player:draw()
    if (self.isVisible == false) then return end

    local dx,dy = math.floor(self.position.x), math.floor(self.position.y)
    local ox    = self.sprite.width/2 - self.aabb.width/2 - self.sprite.offset.x
    local oy    = self.sprite.height/2 - self.aabb.height/2 - self.sprite.offset.y

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.sprite.graphic, dx, dy, 0, 1,1, ox,oy)
end

function Player:drawDebug()
    -- View player center(white), as well as player aabb center(green)
    love.graphics.circle("line", self.position.x,self.position.y, 3)
    love.graphics.setColor(0,1,0,1)
    local px,py = self.position.x + self.aabb.width/2, self.position.y + self.aabb.height/2
    love.graphics.circle("line", px,py, 3)

    -- Reset color
    love.graphics.setColor(1,1,1,1)
end

function Player:checkGrounded()
    local ax,ay,cols,len = self.world:check(self, self.position.x,self.position.y + 1)
    local ground = false

    for i=1, len do
        if cols[i].other.isSolid then
            ground = true
        end
    end

    if self.velocity.y < 0 then ground = false end
    return ground
end

return Player