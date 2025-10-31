-- Brand-new entry script that builds the new UI from scratch, binds Insert, and never references old Integration
-- One file to load: paste the loadstring below in your executor

local HttpGet = function(url)
    return game:HttpGet(url)
end

-- Load core modules
local UILibrary = loadstring(HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/UILibrary.lua"))()
local Keybinds  = loadstring(HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/KeybindManager.lua"))()
local Explorer  = loadstring(HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Explorer.lua"))()
local Snow      = loadstring(HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Snow.lua"))()
local Config    = loadstring(HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Config.lua"))()

local Theme = {
  Background = Color3.fromRGB(22,22,24), Panel = Color3.fromRGB(28,28,32), PanelDeep = Color3.fromRGB(18,18,20),
  Stroke = Color3.fromRGB(56,56,62), Accent = Color3.fromRGB(216,128,216), Text = Color3.fromRGB(235,235,238), TextDim = Color3.fromRGB(160,160,168)
}

-- Build the window (new UI)
local Window = UILibrary:CreateWindow("Matcha – mirko", { Size = { X = 520, Y = 560 } })

-- Start darker overlay + smooth circular snow (no :Stop calls anywhere)
Snow.stopAll()
Snow.start(game:GetService("CoreGui"), true)

-- Insert = global toggle that hides/shows entire UI + overlay + aux UIs
local function getUILibGui()
    local cg = game:GetService("CoreGui")
    local pg = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    return (cg and cg:FindFirstChild("UILibraryGUI")) or (pg and pg:FindFirstChild("UILibraryGUI"))
end

local function globalToggle()
    local ui = getUILibGui()
    if ui and ui.Enabled ~= false then
        ui.Enabled = false
        Snow.stopAll()
        Keybinds.closeAll()
        Explorer.closeAll()
    else
        if ui then ui.Enabled = true end
        Snow.stopAll()
        Snow.start(game:GetService("CoreGui"), true)
    end
end

local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode.Name == "Insert" then
        globalToggle()
    end
end)

-- Utility: quick openers you can map to your top bar or tabs
_G.MatchaUI = {
  Theme = Theme,
  Window = Window,
  OpenKeybinds = function() Keybinds.showList(Theme) end,
  OpenExplorer  = function() Explorer.show(Theme) end,
  SaveConfig    = function(name, data) return Config.save(name, data) end,
  LoadConfig    = function(name) return Config.load(name) end,
  KillAll       = function()
      local ui = getUILibGui()
      if ui then ui:Destroy() end
      Snow.stopAll(); Keybinds.closeAll(); Explorer.closeAll()
  end
}

print("[Matcha UI] New UI loaded. Press Insert to toggle globally. Use _G.MatchaUI helpers.")