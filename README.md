# 🌟 Premium Roblox UI Library

A full-featured, modern UI library for Roblox with advanced animations, professional styling, and premium features.

![UI Library Preview](https://img.shields.io/badge/Version-v2.1.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Roblox](https://img.shields.io/badge/Platform-Roblox-red?style=for-the-badge)

## ✨ Features

### 🎨 Visual Features
- **Modern Dark Theme** - Professional dark UI with smooth gradients
- **Snow Animation** - Animated snowflakes in the background
- **Floating Effects** - GUI gently floats with breathing animation
- **Professional Shadows** - Drop shadows for depth and premium feel
- **Smooth Animations** - Buttery smooth transitions and hover effects
- **Gradient Elements** - Beautiful gradients throughout the interface

### 🛠️ Components
- **Buttons** - Animated buttons with hover effects
- **Toggles** - Smooth sliding toggles with color transitions
- **Sliders** - Interactive sliders with real-time value updates
- **Dropdowns** - Expandable dropdown menus with smooth animations
- **TextBoxes** - Styled input fields with focus effects
- **Keybinds** - Interactive keybind capture system
- **Labels** - Customizable text labels with color options
- **Sections** - Organized content sections with shadows

### 🔧 Advanced Features
- **Keybind System** - Global keybind registration and management
- **DEX Explorer** - Built-in game explorer for debugging
- **Self Destruct** - Emergency UI destruction with confirmation
- **Utility Buttons** - Quick access toolbar at the top
- **Config System** - Save and load configurations
- **Performance Optimized** - Lightweight and efficient code

### 🎮 Utility Tools
- **Script Viewer** - View and manage loaded scripts
- **Keybind List** - Display all registered keybinds
- **Settings Panel** - Comprehensive settings management
- **Performance Monitor** - Track UI performance metrics
- **Theme Customization** - Multiple theme options

## 🚀 Quick Start

### Basic Usage

```lua
-- Load the UI Library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/UILibrary.lua"))()

-- Create a window
local Window = UILibrary:CreateWindow("My Script", {
    Size = {X = 600, Y = 400}
})

-- Create a tab
local MainTab = Window:CreateTab("Main", "🏠")

-- Add components
MainTab:AddButton({
    Text = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})

MainTab:AddToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
```

### Component Examples

#### Toggle
```lua
MainTab:AddToggle({
    Text = "Aimbot Enabled",
    Default = false,
    Callback = function(value)
        print("Aimbot:", value and "On" or "Off")
    end
})
```

#### Slider
```lua
MainTab:AddSlider({
    Text = "FOV Circle",
    Min = 50,
    Max = 500,
    Default = 150,
    Callback = function(value)
        print("FOV:", value)
    end
})
```

#### Dropdown
```lua
MainTab:AddDropdown({
    Text = "Aim Part",
    List = {"Head", "Torso", "Random"},
    Callback = function(option, index)
        print("Selected:", option)
    end
})
```

#### Keybind
```lua
MainTab:AddKeybind({
    Text = "Aimbot Toggle",
    Default = "Q",
    Callback = function(key, keyCode)
        print("Keybind set to:", key)
    end
})
```

#### TextBox
```lua
MainTab:AddTextBox({
    PlaceholderText = "Enter username...",
    Callback = function(text)
        print("Input:", text)
    end
})
```

## 📋 Complete Example

Run this script to see all features in action:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Example.lua"))()
```

## 🎯 Advanced Features

### Sections

Organize your components into sections:

```lua
local MainSection = MainTab:CreateSection("Main Settings")

MainSection:AddToggle({
    Text = "Feature 1",
    Default = false,
    Callback = function(value)
        print("Feature 1:", value)
    end
})
```

### Keybind System

Register global keybinds:

```lua
-- Register a keybind manually
UILibrary.RegisterKeybind("F1", function()
    print("F1 pressed!")
end, "Help Menu")

-- Show keybind list
UILibrary.ShowKeybindList()
```

### Utility Functions

```lua
-- Open DEX Explorer
UILibrary.CreateDexExplorer()

-- Self destruct (with confirmation)
UILibrary.SelfDestruct()
```

## 🎨 Customization

### Theme Colors

The library uses a modern dark theme by default:

```lua
local Theme = {
    Background = Color3.fromRGB(25, 25, 30),
    Secondary = Color3.fromRGB(35, 35, 40),
    Tertiary = Color3.fromRGB(45, 45, 50),
    Accent = Color3.fromRGB(120, 120, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(255, 200, 80),
    Error = Color3.fromRGB(255, 80, 80)
}
```

### Window Options

```lua
local Window = UILibrary:CreateWindow("Title", {
    Size = {X = 700, Y = 500}  -- Custom size
})
```

## 🔧 Built-in Utilities

### Utility Buttons (Top Bar)

- **🔍 DEX** - Opens DEX Explorer
- **⚙️ Settings** - Opens settings panel
- **🎹 Keybinds** - Shows keybind list
- **📜 Scripts** - Script management
- **💥 Destruct** - Self destruct button

### Default Keybinds

- **Left Control** - Toggle UI visibility
- **Custom keybinds** - Set through components

## 📱 Mobile Support

The library is optimized for both PC and mobile devices with:
- Touch-friendly button sizes
- Responsive scaling
- Mobile-optimized interactions

## 🔒 Security Features

- **Safe loading** - Handles CoreGui/PlayerGui fallback
- **Error handling** - Robust error management
- **Memory management** - Proper cleanup on destruction
- **Input validation** - Validates all user inputs

## 🎪 Animation System

The library features a comprehensive animation system:

- **Hover Effects** - Smooth color and size transitions
- **Click Animations** - Visual feedback on interactions
- **Sliding Animations** - Smooth component movements
- **Pop Effects** - Satisfying popup animations
- **Floating Effect** - Gentle window breathing animation
- **Snow Animation** - Ambient background effects

## 🔧 Technical Details

### Performance
- **Optimized rendering** - Efficient UI updates
- **Lightweight code** - Minimal memory footprint
- **Smooth 60fps** - Optimized animations
- **Event-driven** - Efficient event handling

### Compatibility
- **All executors** - Works with popular executors
- **CoreGui support** - Falls back to PlayerGui if needed
- **Cross-platform** - PC and mobile compatible

## 📚 API Reference

### Window Methods
```lua
Window:CreateTab(name, icon) -- Creates a new tab
```

### Tab Methods
```lua
Tab:CreateSection(name) -- Creates a section
Tab:AddButton(options) -- Adds a button
Tab:AddToggle(options) -- Adds a toggle
Tab:AddSlider(options) -- Adds a slider
Tab:AddDropdown(options) -- Adds a dropdown
Tab:AddTextBox(options) -- Adds a textbox
Tab:AddKeybind(options) -- Adds a keybind
Tab:AddLabel(text, color) -- Adds a label
```

### Section Methods
```lua
Section:AddButton(options)
Section:AddToggle(options)
Section:AddSlider(options)
Section:AddDropdown(options)
Section:AddTextBox(options)
Section:AddKeybind(options)
Section:AddLabel(text, color)
```

## 🐛 Known Issues

- None currently! Report issues on GitHub.

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **GitHub Issues** - Report bugs and request features
- **Discord** - Join our community server
- **Documentation** - Check the wiki for detailed guides

## 🌟 Showcase

Your script using this library? Let us know!

---

**Created with ❤️ by axzaxzz**

*"Making Roblox UIs beautiful, one script at a time."*