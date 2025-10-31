-- Patch: use MatchaTheme and Icons for sizes/colors and remove emojis
local HttpService = game:GetService("HttpService")
local function fetch(path)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/"..path))()
end

local Theme = fetch("MatchaTheme.lua")
local Icons = fetch("Icons.lua")

local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/UILibrary.lua"))()

-- Expose a factory that applies theme metrics to created windows/tabs
local API = {}

function API.CreateWindow(title)
    local win = UILibrary:CreateWindow(title, {Size = {X = Theme.Window.Width, Y = Theme.Window.Height}})
    return win
end

return {API = API, Theme = Theme, Icons = Icons}