-- Integration v2: Uses the new modules and wires global toggle, config UI, and full cleanup
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/UILibrary.lua"))()
local Keybinds = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/KeybindManager.lua"))()
local Explorer = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Explorer.lua"))()
local Snow = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Snow.lua"))()
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Config.lua"))()

local Theme = {
  Background = Color3.fromRGB(22,22,24), Panel = Color3.fromRGB(28,28,32), PanelDeep = Color3.fromRGB(18,18,20),
  Stroke = Color3.fromRGB(56,56,62), Accent = Color3.fromRGB(216,128,216), Text = Color3.fromRGB(235,235,238), TextDim = Color3.fromRGB(160,160,168)
}

local Integration = {}
Integration.theme = Theme
Integration.overlay = nil

function Integration.startOverlay()
  if Integration.overlay and Integration.overlay.Parent then return end
  Integration.overlay = Snow.start(game:GetService("CoreGui"), true)
end

function Integration.stopOverlay()
  -- overlay is a Frame; Snow.start returns overlay with :Stop() in module but Roblox objects can't hold methods; fall back to Snow.stopAll()
  Snow.stopAll()
  Integration.overlay = nil
end

function Integration.globalToggle()
  local cg = game:GetService("CoreGui")
  local pg = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
  local ui = (cg and cg:FindFirstChild("UILibraryGUI")) or (pg and pg:FindFirstChild("UILibraryGUI"))
  if ui and ui.Enabled ~= false then
    ui.Enabled = false
    Integration.stopOverlay()
    Keybinds.closeAll()
    Explorer.closeAll()
  else
    if ui then ui.Enabled = true end
    Integration.startOverlay()
  end
end

function Integration.killAll()
  local cg = game:GetService("CoreGui")
  local pg = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
  local ui = (cg and cg:FindFirstChild("UILibraryGUI")) or (pg and pg:FindFirstChild("UILibraryGUI"))
  if ui then ui:Destroy() end
  Integration.stopOverlay()
  Keybinds.closeAll()
  Explorer.closeAll()
end

function Integration.openExplorer()
  Explorer.show(Theme)
end

function Integration.openKeybinds()
  Keybinds.showList(Theme)
end

function Integration.saveConfig(name, data)
  return Config.save(name, data)
end

function Integration.loadConfig(name)
  return Config.load(name)
end

return Integration