---@diagnostic disable: lowercase-global
_G.love = require("love")

tileDataTypes = {
    [1] = {name = 'forest', cost = 2},
    [2] =  {name = 'water', cost = math.huge},
    [0] =  {name = 'plains', cost = 1}

}


return tileDataTypes