-- Class
local class = require "lib/middleclass"
local Player = class("Player", require "lib/entity")
-- Components
local vec2 = require "lib/hump/vector"

-- Player variables
local acceleration = 16
local maxSpeed = 128
local jumpForce = 128+32
local airBoost = 7
local airDrag = 0.4
local gravity = 12
local maxFallSpeed = 8

local isGrounded = false
local canJump = false

function Player:load()
    self.aabb = vec2(16,16)
    self.aabbOffset = vec2(8,8)

    sprite = love.graphics.newImage("assets/sprites/Alfred.png")
    spriteWidth = sprite:getWidth()
    spriteHeight = sprite:getHeight()
    self:UpdateBumpShape()
end

function Player:update(dt)
    -- -------------------- Check for Collisions
    isGrounded = self:checkGrounded()

    -- Gravity
    if isGrounded then
        -- Player is on the ground
        local ax,ay,cols,len = self.world:check(self, self.position.x,self.position.y + 1)

        for i=1, len do
            local other = cols[i].other

            if other.isGround then
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

            if other.isGround then
                self.velocity.y = 0
            end
        end

        self.velocity.y = self.velocity.y + gravity
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
    if love.keyboard.isDown("z") and isGrounded == true then
        self.velocity.y = -jumpForce
    elseif love.keyboard.isDown("z") and isGrounded == false then
        if self.velocity.y < 0 then
            self.velocity.y = self.velocity.y - airBoost
        end
    end

    if love.keyboard.isDown("space") then
        -- self:destroy()
        print(self.aabb)
    end

    -- -------------------- Update Player Movement
    local accel = acceleration
    if isGrounded == false then accel = accel * airDrag end

    local goal = direction * maxSpeed
    local temp = self.velocity:clone()
    temp = temp:lerp(goal, accel * dt)
    self.velocity.x = temp.x

    self:move(dt)
end

function Player:draw()
    local dx, dy = math.floor(self.position.x), math.floor(self.position.y)

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(sprite, dx, dy, 0, 1,1, 8,spriteHeight/2)
end

function Player:drawDebug()
    if isGrounded == true then
        love.graphics.setColor(0,1,0,0.25)
        love.graphics.rectangle("fill", self.position.x,self.position.y, 16,16)
        love.graphics.setColor(1,1,1,1)
    end
end

function Player:checkGrounded()
    local ax,ay,cols,len = self.world:check(self, self.position.x,self.position.y + 4)
    local ground = false

    for i=1, len do
        if cols[i].other.isGround then
            ground = true
        end
    end

    if self.velocity.y < 0 then ground = false end
    return ground
end

return Player