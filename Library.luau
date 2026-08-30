local Library = {}
local Window = require(script.Core.Window)

function Library:CreateWindow(Config)
    return Window:CreateWindow(Config)
end

return Library
