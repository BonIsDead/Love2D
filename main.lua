local ldtk = require"assets/scripts/ldtk-importer"
json = require "lib/json"

-- Global variables
_gameWidth, _gameHeight, _gameScale = 256, 224, {2, 2}
_debug = false
print("Press 'Q' to enable Bump debug!")

-- Object tables
_entities = {}
_entities.name = "_entities"

_currentLevel = 1

-- ---------- Temporary things
-- Bump settings
local bump = require "lib/bump"
local world = bump.newWorld()

-- Player component
Player = require "assets/entities/player"

-- Camera
Camera = require "lib/hump/camera"
function clamp(min, val, max) return math.max(min, math.min(val, max) ) end
vec2 = require("lib/hump/vector")

function love.load()
    -- Temp player creation
    player = Player(world, 48,_gameHeight-48, _entities)
    -- local block = {x=128,y=128+32,w=64,h=64}
    -- world:add(block, block.x,block.y,block.w,block.h)

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
    ldtkMap = ldtk:new("assets/levels/test.ldtk", world)
    ldtkMap:addCollisions(_currentLevel, world)

    -- Load entities
    for i, ent in ipairs(_entities) do
        if ent.load then ent:load() end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "q" then
        _debug = not _debug
    end
end

function love.update(dt)
    -- Temporary camera movement
    camPosition = camPosition:lerp(player.position - vec2(_gameWidth*0.5, _gameHeight*0.5), 4 * dt)
    camPosition = camPosition:clamped(0,256, 0,0)
    currentCamera:lookAt(math.floor(camPosition.x) + _gameWidth*0.5, math.floor(camPosition.y) + _gameHeight*0.5)

    -- Update entities
    for i, ent in ipairs(_entities) do
        if ent.update then ent:update(dt) end
    end
end

local function drawAllBumpItems(world)
    -- Draw bump world debug
    local items = world:getItems()
    for _,item in ipairs(items) do
      local x,y,w,h = world:getRect(item)
      love.graphics.rectangle("line", x,y,w,h)
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
        
        if (_debug == true) then drawAllBumpItems(world) end
    currentCamera:detach()

    -- Draw Hud
end