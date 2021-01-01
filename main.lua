local ldtk = require"assets/scripts/ldtk-importer"
json = require "lib/json"

-- Global variables
_gameWidth, _gameHeight, _gameScale = 256, 224, {2, 2}
_debug = true

_entities = {}
_entities.name = "_entities"

_currentLevel = 1

Player = require "assets/entities/player"

-- Temporary stuff!!!
Camera = require "lib/hump/camera"
function clamp(min, val, max) return math.max(min, math.min(val, max) ) end
vec2 = require("lib/hump/vector")

function love.load()
    -- Temp player creation
    player = Player(48, _gameHeight-48, _entities)

    -- Scale window properly
    love.graphics.setDefaultFilter("nearest")
    camPosition = vec2()

    -- Temporary background
    bgImage, bgQuad = {}, {}
    bgImage[1] = love.graphics.newImage("assets/spritesheets/CastlevaniaVI_Background1.png")
    bgImage[1]:setWrap("repeat", "clampzero")
    bgQuad[1] = love.graphics.newQuad(0,0, 512,224, 256,96)

    bgImage[2] = love.graphics.newImage("assets/spritesheets/CastlevaniaVI_Background2.png")
    bgImage[2]:setWrap("repeat", "clampzero")
    bgQuad[2] = love.graphics.newQuad(0,0, 512,224, 192,96)

    -- Create camera
    currentCamera = Camera(0,0)
    camPosition.x, camPosition.y = currentCamera:position()

    -- Create tilemap
    ldtkMap = ldtk:new("assets/levels/test.ldtk")
    -- love.graphics.setBackgroundColor(0.5,0.5,0.5, 0.5)

    -- Load entities
    for i, ent in ipairs(_entities) do
        if ent.start then ent:start() end
    end
end

local count = 1

function love.update(dt)
    -- Pan the camera for now
    -- Don't know how I want the camera to be controlled, yet!
    -- local camSpeed = 96
    -- if love.keyboard.isDown("up") then      camDy = (camDy - camSpeed * dt) end
    -- if love.keyboard.isDown("left") then    camDx = (camDx - camSpeed * dt) end
    -- if love.keyboard.isDown("down") then    camDy = (camDy + camSpeed * dt) end
    -- if love.keyboard.isDown("right") then      camDx = (camDx + camSpeed * dt) end
    -- camDx = clamp(0, camDx, 256)
    -- camDy = clamp(0, camDy, 256)
    -- camDx = _gameWidth*0.5 + math.sin(count * 0.02) * _gameWidth*0.5
    -- count = count + 1

    camPosition = camPosition:lerp(player.position - vec2(_gameWidth*0.5, _gameHeight*0.5), 4 * dt)
    camPosition = camPosition:clamped(0,256, 0,0)

    currentCamera:lookAt(math.floor(camPosition.x) + _gameWidth*0.5, math.floor(camPosition.y) + _gameHeight*0.5)

    -- Update entities
    for i, ent in ipairs(_entities) do
        if ent.update then ent:update(dt) end
    end
end

function love.draw()
    love.graphics.scale(_gameScale[1], _gameScale[2] )

    -- Temporary background
    love.graphics.draw(bgImage[1], bgQuad[1], -camPosition.x * 0.2,32)
    love.graphics.draw(bgImage[2], bgQuad[2], -camPosition.x * 0.4,32+96)

    -- Draw to camera
    currentCamera:attach(0,0, _gameWidth,_gameHeight, true)
        ldtkMap:draw(currentCamera)

        -- Draw entities
        for i, ent in ipairs(_entities) do
            if ent.draw then ent:draw() end

            if (_debug == true) then
                if ent.drawDebug then ent:drawDebug() end
            end
        end
    currentCamera:detach()

    -- Draw Hud
end