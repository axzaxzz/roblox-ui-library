--[[
    UI Library Example Script
    Showcases every feature of the premium UI library
    Load this script to see all components in action
--]]

-- Load the UI Library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/UILibrary.lua"))()

-- Create the main window
local Window = UILibrary:CreateWindow("🎆 Premium UI Showcase", {
    Size = {X = 750, Y = 550}
})

-- Variables for demonstration
local demoValues = {
    toggleState = false,
    sliderValue = 50,
    selectedOption = "None",
    textValue = "",
    keybindKey = "None"
}

-- ================== AIMBOT TAB ==================
local AimbotTab = Window:CreateTab("Aimbot", "🎯")

-- Aimbot Main Section
local AimbotMain = AimbotTab:CreateSection("Main Settings")

AimbotMain:AddToggle({
    Text = "Aimbot Enabled",
    Default = false,
    Callback = function(value)
        demoValues.toggleState = value
        print("Aimbot:", value and "Enabled" or "Disabled")
    end
})

AimbotMain:AddDropdown({
    Text = "Aim Type",
    List = {"Mouse", "Camera", "Silent", "Rage"},
    Callback = function(option, index)
        demoValues.selectedOption = option
        print("Aim Type changed to:", option)
    end
})

AimbotMain:AddSlider({
    Text = "FOV Circle",
    Min = 10,
    Max = 500,
    Default = 100,
    Callback = function(value)
        demoValues.sliderValue = value
        print("FOV Circle set to:", value)
    end
})

AimbotMain:AddKeybind({
    Text = "Aimbot Toggle",
    Default = "Q",
    Callback = function(key, keyCode)
        print("Aimbot keybind set to:", key)
    end
})

-- Aimbot Prediction Section
local AimbotPrediction = AimbotTab:CreateSection("Prediction")

AimbotPrediction:AddToggle({
    Text = "Prediction Enabled",
    Default = false,
    Callback = function(value)
        print("Prediction:", value and "Enabled" or "Disabled")
    end
})

AimbotPrediction:AddSlider({
    Text = "Prediction X",
    Min = 0,
    Max = 1,
    Default = 0.13,
    Callback = function(value)
        print("Prediction X:", value)
    end
})

AimbotPrediction:AddSlider({
    Text = "Prediction Y",
    Min = 0,
    Max = 1,
    Default = 0.13,
    Callback = function(value)
        print("Prediction Y:", value)
    end
})

-- Hit Detection Section
local HitDetection = AimbotTab:CreateSection("Hit Detection")

HitDetection:AddDropdown({
    Text = "Hit Part",
    List = {"Head", "Torso", "Random", "Closest"},
    Callback = function(option)
        print("Hit part changed to:", option)
    end
})

HitDetection:AddSlider({
    Text = "Hit Chance",
    Min = 0,
    Max = 100,
    Default = 85,
    Callback = function(value)
        print("Hit chance:", value .. "%")
    end
})

-- ================== SILENT AIM TAB ==================
local SilentTab = Window:CreateTab("Silent Aim", "🎮")

-- Silent Aim Main
local SilentMain = SilentTab:CreateSection("Silent Aim Settings")

SilentMain:AddToggle({
    Text = "Silent Aim Enabled",
    Default = false,
    Callback = function(value)
        print("Silent Aim:", value and "Enabled" or "Disabled")
    end
})

SilentMain:AddSlider({
    Text = "Silent FOV",
    Min = 50,
    Max = 1000,
    Default = 200,
    Callback = function(value)
        print("Silent FOV:", value)
    end
})

SilentMain:AddDropdown({
    Text = "Silent Method",
    List = {"Raycast", "Mouse", "Camera", "Hybrid"},
    Callback = function(option)
        print("Silent method:", option)
    end
})

-- Silent Aim Smoothing
local SilentSmoothing = SilentTab:CreateSection("Smoothing")

SilentSmoothing:AddToggle({
    Text = "Smoothing Enabled",
    Default = true,
    Callback = function(value)
        print("Smoothing:", value and "Enabled" or "Disabled")
    end
})

SilentSmoothing:AddSlider({
    Text = "Smoothness X",
    Min = 1,
    Max = 50,
    Default = 15,
    Callback = function(value)
        print("Smoothness X:", value)
    end
})

SilentSmoothing:AddSlider({
    Text = "Smoothness Y",
    Min = 1,
    Max = 50,
    Default = 15,
    Callback = function(value)
        print("Smoothness Y:", value)
    end
})

-- Silent Aim Checks
local SilentChecks = SilentTab:CreateSection("Safety Checks")

SilentChecks:AddToggle({
    Text = "Wall Check",
    Default = true,
    Callback = function(value)
        print("Wall Check:", value and "Enabled" or "Disabled")
    end
})

SilentChecks:AddToggle({
    Text = "Alive Check",
    Default = true,
    Callback = function(value)
        print("Alive Check:", value and "Enabled" or "Disabled")
    end
})

SilentChecks:AddToggle({
    Text = "Team Check",
    Default = false,
    Callback = function(value)
        print("Team Check:", value and "Enabled" or "Disabled")
    end
})

-- ================== VISUALS TAB ==================
local VisualsTab = Window:CreateTab("Visuals", "🌈")

-- ESP Section
local ESPSection = VisualsTab:CreateSection("ESP Settings")

ESPSection:AddToggle({
    Text = "Player ESP",
    Default = false,
    Callback = function(value)
        print("Player ESP:", value and "Enabled" or "Disabled")
    end
})

ESPSection:AddToggle({
    Text = "Name Tags",
    Default = false,
    Callback = function(value)
        print("Name Tags:", value and "Enabled" or "Disabled")
    end
})

ESPSection:AddToggle({
    Text = "Health Bars",
    Default = false,
    Callback = function(value)
        print("Health Bars:", value and "Enabled" or "Disabled")
    end
})

ESPSection:AddToggle({
    Text = "Distance Display",
    Default = false,
    Callback = function(value)
        print("Distance Display:", value and "Enabled" or "Disabled")
    end
})

-- Chams Section
local ChamsSection = VisualsTab:CreateSection("Chams")

ChamsSection:AddToggle({
    Text = "Player Chams",
    Default = false,
    Callback = function(value)
        print("Player Chams:", value and "Enabled" or "Disabled")
    end
})

ChamsSection:AddSlider({
    Text = "Chams Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Callback = function(value)
        print("Chams Transparency:", value)
    end
})

ChamsSection:AddDropdown({
    Text = "Chams Material",
    List = {"ForceField", "Neon", "Glass", "Plastic"},
    Callback = function(option)
        print("Chams Material:", option)
    end
})

-- FOV Circle Section
local FOVSection = VisualsTab:CreateSection("FOV Circle")

FOVSection:AddToggle({
    Text = "Show FOV Circle",
    Default = false,
    Callback = function(value)
        print("FOV Circle:", value and "Enabled" or "Disabled")
    end
})

FOVSection:AddSlider({
    Text = "Circle Size",
    Min = 50,
    Max = 500,
    Default = 150,
    Callback = function(value)
        print("Circle Size:", value)
    end
})

FOVSection:AddSlider({
    Text = "Circle Thickness",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(value)
        print("Circle Thickness:", value)
    end
})

-- ================== MISC TAB ==================
local MiscTab = Window:CreateTab("Miscellaneous", "⚙️")

-- Movement Section
local MovementSection = MiscTab:CreateSection("Movement")

MovementSection:AddToggle({
    Text = "Speed Hack",
    Default = false,
    Callback = function(value)
        print("Speed Hack:", value and "Enabled" or "Disabled")
    end
})

MovementSection:AddSlider({
    Text = "Speed Multiplier",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        print("Speed Multiplier:", value)
    end
})

MovementSection:AddToggle({
    Text = "Jump Power",
    Default = false,
    Callback = function(value)
        print("Jump Power:", value and "Enabled" or "Disabled")
    end
})

MovementSection:AddSlider({
    Text = "Jump Height",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(value)
        print("Jump Height:", value)
    end
})

-- Exploits Section
local ExploitsSection = MiscTab:CreateSection("Exploits")

ExploitsSection:AddToggle({
    Text = "Infinite Ammo",
    Default = false,
    Callback = function(value)
        print("Infinite Ammo:", value and "Enabled" or "Disabled")
    end
})

ExploitsSection:AddToggle({
    Text = "No Recoil",
    Default = false,
    Callback = function(value)
        print("No Recoil:", value and "Enabled" or "Disabled")
    end
})

ExploitsSection:AddToggle({
    Text = "No Spread",
    Default = false,
    Callback = function(value)
        print("No Spread:", value and "Enabled" or "Disabled")
    end
})

ExploitsSection:AddButton({
    Text = "Teleport to Spawn",
    Callback = function()
        print("Teleported to spawn!")
    end
})

-- Automation Section
local AutoSection = MiscTab:CreateSection("Automation")

AutoSection:AddToggle({
    Text = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value and "Enabled" or "Disabled")
    end
})

AutoSection:AddDropdown({
    Text = "Farm Target",
    List = {"Cash", "XP", "Items", "Kills"},
    Callback = function(option)
        print("Farm Target:", option)
    end
})

AutoSection:AddSlider({
    Text = "Farm Delay (seconds)",
    Min = 0.1,
    Max = 5,
    Default = 1,
    Callback = function(value)
        print("Farm Delay:", value .. "s")
    end
})

-- ================== SETTINGS TAB ==================
local SettingsTab = Window:CreateTab("Settings", "🔧")

-- UI Settings Section
local UISection = SettingsTab:CreateSection("UI Settings")

UISection:AddLabel("Theme Settings", Color3.fromRGB(120, 120, 255))

UISection:AddDropdown({
    Text = "UI Theme",
    List = {"Dark", "Light", "Blue", "Purple", "Green"},
    Callback = function(option)
        print("Theme changed to:", option)
    end
})

UISection:AddSlider({
    Text = "UI Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Callback = function(value)
        print("UI Transparency:", value)
    end
})

UISection:AddToggle({
    Text = "Snow Animation",
    Default = true,
    Callback = function(value)
        print("Snow Animation:", value and "Enabled" or "Disabled")
    end
})

-- Keybind Settings Section
local KeybindSection = SettingsTab:CreateSection("Keybind Settings")

KeybindSection:AddLabel("Global Keybinds", Color3.fromRGB(255, 200, 80))

KeybindSection:AddKeybind({
    Text = "Toggle UI",
    Default = "LeftControl",
    Callback = function(key)
        print("UI Toggle keybind:", key)
    end
})

KeybindSection:AddKeybind({
    Text = "Panic Key",
    Default = "Delete",
    Callback = function(key)
        print("Panic key set to:", key)
        -- This would trigger self-destruct
    end
})

KeybindSection:AddButton({
    Text = "Show Keybind List",
    Callback = function()
        UILibrary.ShowKeybindList()
    end
})

-- Config Section
local ConfigSection = SettingsTab:CreateSection("Configuration")

ConfigSection:AddTextBox({
    PlaceholderText = "Config Name",
    Callback = function(text)
        print("Config name:", text)
    end
})

ConfigSection:AddButton({
    Text = "Save Config",
    Callback = function()
        print("Configuration saved!")
    end
})

ConfigSection:AddButton({
    Text = "Load Config",
    Callback = function()
        print("Configuration loaded!")
    end
})

ConfigSection:AddDropdown({
    Text = "Auto-Save",
    List = {"Disabled", "On Exit", "Every 5min", "Every 10min"},
    Callback = function(option)
        print("Auto-save:", option)
    end
})

-- Utilities Section
local UtilitiesSection = SettingsTab:CreateSection("Utilities")

UtilitiesSection:AddButton({
    Text = "Open DEX Explorer",
    Callback = function()
        UILibrary.CreateDexExplorer()
    end
})

UtilitiesSection:AddButton({
    Text = "Script Console",
    Callback = function()
        print("Script console opened!")
    end
})

UtilitiesSection:AddButton({
    Text = "Performance Monitor",
    Callback = function()
        print("Performance monitor opened!")
    end
})

UtilitiesSection:AddButton({
    Text = "Self Destruct",
    Callback = function()
        UILibrary.SelfDestruct()
    end
})

-- ================== INFO TAB ==================
local InfoTab = Window:CreateTab("Information", "📊")

-- Library Info Section
local LibraryInfo = InfoTab:CreateSection("Library Information")

LibraryInfo:AddLabel("UI Library Version: v2.1.0", Color3.fromRGB(80, 200, 120))
LibraryInfo:AddLabel("Created by: axzaxzz", Color3.fromRGB(255, 255, 255))
LibraryInfo:AddLabel("Last Updated: " .. os.date("%m/%d/%Y"), Color3.fromRGB(200, 200, 200))

LibraryInfo:AddButton({
    Text = "GitHub Repository",
    Callback = function()
        print("GitHub: https://github.com/axzaxzz/roblox-ui-library")
    end
})

-- Features Section
local FeaturesInfo = InfoTab:CreateSection("Features")

FeaturesInfo:AddLabel("✓ Modern Dark Theme", Color3.fromRGB(80, 200, 120))
FeaturesInfo:AddLabel("✓ Smooth Animations", Color3.fromRGB(80, 200, 120))
FeaturesInfo:AddLabel("✓ Snow Background", Color3.fromRGB(80, 200, 120))
FeaturesInfo:AddLabel("✓ Keybind System", Color3.fromRGB(80, 200, 120))
FeaturesInfo:AddLabel("✓ DEX Explorer", Color3.fromRGB(80, 200, 120))
FeaturesInfo:AddLabel("✓ Self Destruct", Color3.fromRGB(80, 200, 120))
FeaturesInfo:AddLabel("✓ Utility Buttons", Color3.fromRGB(80, 200, 120))
FeaturesInfo:AddLabel("✓ Floating Effects", Color3.fromRGB(80, 200, 120))
FeaturesInfo:AddLabel("✓ Professional Shadows", Color3.fromRGB(80, 200, 120))

-- Statistics Section
local StatsInfo = InfoTab:CreateSection("Statistics")

StatsInfo:AddLabel("Components: 15+", Color3.fromRGB(255, 200, 80))
StatsInfo:AddLabel("Lines of Code: 1500+", Color3.fromRGB(255, 200, 80))
StatsInfo:AddLabel("Performance: Optimized", Color3.fromRGB(255, 200, 80))
StatsInfo:AddLabel("Memory Usage: Low", Color3.fromRGB(255, 200, 80))

-- Usage Section
local UsageInfo = InfoTab:CreateSection("Usage Instructions")

UsageInfo:AddLabel("1. Left Control - Toggle UI", Color3.fromRGB(200, 200, 200))
UsageInfo:AddLabel("2. Use utility buttons at top", Color3.fromRGB(200, 200, 200))
UsageInfo:AddLabel("3. Drag window to move", Color3.fromRGB(200, 200, 200))
UsageInfo:AddLabel("4. Hover for animations", Color3.fromRGB(200, 200, 200))
UsageInfo:AddLabel("5. Check Settings for options", Color3.fromRGB(200, 200, 200))

-- Final notification
print("🎆 Premium UI Library loaded successfully!")
print("🔑 Press Left Control to toggle UI visibility")
print("⚙️ Check the utility buttons at the top of the screen")
print("🌨️ Enjoy the snow animation in the background!")