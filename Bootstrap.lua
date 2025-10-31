-- Changelog: tighten styling to Matcha look
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/MatchaTheme.lua"))()
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Icons.lua"))()

local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/UILibrary.lua"))

return function()
    -- This bootstrapper is a thin layer to standardize default sizes/colors/icons
    local lib = UILibrary()
    return lib, Theme, Icons
end