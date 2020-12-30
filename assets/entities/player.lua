-- Class
local class = require "lib/middleclass"
Player = class("Player", require "lib/entity")
-- Components
local vec2 = require "hump/vector"

-- Player variables
local acceleration = 16
local maxSpeed = 128
local jumpForce = 128 + 64
local airBoost = 6
local airDrag = 0.4
local gravity = 12
local maxFallSpeed = 8

local isGrounded = false
local canJump = false

function Player:start()
    sprite = love.graphics.newImage("assets/sprites/Alfred.png")
    spriteWidth = sprite:getWidth()
    spriteHeight = sprite:getHeight()
end

function Player:update(dt)
    -- Gravity
    if isGrounded == false then
        self.velocity.y = self.velocity.y + gravity
    end

    if self.position.y >= _gameHeight - 16 then
        self.position.y = _gameHeight - 16
        self.velocity.y = 0
        isGrounded = true
    elseif self.position.y < _gameHeight - 16 then
        isGrounded = false
    end

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

    -- Smooth out horizontal velocity
    local accel = acceleration
    if isGrounded == false then accel = accel * airDrag end

    local goal = direction * maxSpeed
    local temp = self.velocity:clone()
    temp = temp:lerp(goal, accel * dt)
    self.velocity.x = temp.x

    self:move(dt)
end

function Player:draw()
    local dx = math.floor(self.position.x)
    local dy = math.floor(self.position.y)

    if isGrounded == true then
        love.graphics.setColor(0,1,0,0.2)
        love.graphics.rectangle("fill", dx-spriteWidth/2, dy-spriteHeight/2, 32, 32)
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(sprite, dx, dy, 0, 1,1, spriteWidth/2, spriteHeight/2)
end

return Player