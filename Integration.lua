-- Integration v3: enforce Insert as global toggle, never call overlay:Stop(), use Snow.stopAll
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

function Integration.startOverlay()
  Snow.stopAll()
  Snow.start(game:GetService("CoreGui"), true)
end

function Integration.stopOverlay()
  Snow.stopAll()
end

local function getUILibGui()
  local cg = game:GetService("CoreGui")
  local pg = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
  return (cg and cg:FindFirstChild("UILibraryGUI")) or (pg and pg:FindFirstChild("UILibraryGUI"))
end

function Integration.globalToggle()
  local ui = getUILibGui()
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
  local ui = getUILibGui()
  if ui then ui:Destroy() end
  Integration.stopOverlay()
  Keybinds.closeAll()
  Explorer.closeAll()
end

function Integration.bindInsert()
  local UIS = game:GetService("UserInputService")
  UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode.Name == "Insert" then
      Integration.globalToggle()
    end
  end)
end

function Integration.openExplorer() Explorer.show(Theme) end
function Integration.openKeybinds() Keybinds.showList(Theme) end
function Integration.saveConfig(name, data) return Config.save(name, data) end
function Integration.loadConfig(name) return Config.load(name) end

return Integration