local ldtk = {}
ldtk.__index = ldtk

local function createMap(LDtkPath)
    local map = {}

    -- Check file & create JSON
    filePath = love.filesystem.read(LDtkPath)
    if (love.filesystem.getInfo(filePath) ) then
        print("The LDtk file specified could not be found!")
        return
    else
        print("LDtk Map Loaded.")
        data = json.decode(filePath)
    end

    return map
end

function ldtk.drawMap()
    love.graphics.rectangle("line",16,16,32,32)
end

return setmetatable({createMap = createMap},
	{__call = function(_,...) return createMap(...) end})