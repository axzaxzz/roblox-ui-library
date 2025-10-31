-- Integrate KeybindManager, Explorer, Snow, and Config into UILibrary
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/UILibrary.lua"))()
local Theme = {
  Background = Color3.fromRGB(22,22,24), Panel = Color3.fromRGB(28,28,32), PanelDeep = Color3.fromRGB(18,18,20),
  Stroke = Color3.fromRGB(56,56,62), Accent = Color3.fromRGB(216,128,216), Text = Color3.fromRGB(235,235,238), TextDim = Color3.fromRGB(160,160,168)
}
local KM = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/KeybindManager.lua"))()
local Explorer = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Explorer.lua"))()
local Snow = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Snow.lua"))()
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Config.lua"))()

-- Wrapper exposing helpers
return {
  UILibrary = UILib,
  Theme = Theme,
  Keybinds = KM,
  Explorer = Explorer,
  Snow = Snow,
  Config = Config
}