json = require("assets/json")

local Map = {}
Map.__index = map

function Map:initialize(path)
    self.entities = {}
    self.tiles = {}
    self.tileInstances = {}
end

return Map