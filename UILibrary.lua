--[[
    Modern Roblox UI Library - Premium Edition
    Created by: axzaxzz
    Features: Snow background, keybind system, dex explorer, self-destruct, utility buttons
--]]

local UILibrary = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(25, 25, 30),
    Secondary = Color3.fromRGB(35, 35, 40),
    Tertiary = Color3.fromRGB(45, 45, 50),
    Accent = Color3.fromRGB(120, 120, 255),
    AccentHover = Color3.fromRGB(140, 140, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextDim = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(255, 200, 80),
    Error = Color3.fromRGB(255, 80, 80),
    Border = Color3.fromRGB(60, 60, 70)
}

-- Animation Configurations
local AnimationInfo = {
    Hover = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Click = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slide = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Pop = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}

-- Global Variables
local keybinds = {}
local isUIVisible = true
local snowflakes = {}
local utilities = {}
local mainScreenGui = nil

-- Utility Functions
local function CreateTween(object, info, properties)
    return TweenService:Create(object, info, properties)
end

local function RoundCorners(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = frame
    return corner
end

local function AddStroke(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = frame
    return stroke
end

local function CreateGradient(frame, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = frame
    return gradient
end

local function AddShadow(frame, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.6
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame.Parent
    
    RoundCorners(shadow, (size or 30) / 2)
    return shadow
end

-- Built-in Components (instead of external loading)
local Components = {}

-- Button Component
function Components:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Theme.Accent
    button.Text = text or "Button"
    button.TextColor3 = Theme.Text
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = parent
    
    RoundCorners(button, 8)
    local shadow = AddShadow(button, 15, 0.5)
    
    -- Hover Animation
    button.MouseEnter:Connect(function()
        CreateTween(button, AnimationInfo.Hover, {
            BackgroundColor3 = Theme.AccentHover,
            Size = UDim2.new(1, 2, 0, 37)
        }):Play()
        CreateTween(shadow, AnimationInfo.Hover, {
            ImageTransparency = 0.3
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, AnimationInfo.Hover, {
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(1, 0, 0, 35)
        }):Play()
        CreateTween(shadow, AnimationInfo.Hover, {
            ImageTransparency = 0.5
        }):Play()
    end)
    
    -- Click Animation
    button.MouseButton1Down:Connect(function()
        CreateTween(button, AnimationInfo.Click, {
            Size = UDim2.new(1, -2, 0, 33)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        CreateTween(button, AnimationInfo.Click, {
            Size = UDim2.new(1, 2, 0, 37)
        }):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- Toggle Component
function Components:CreateToggle(parent, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundColor3 = Theme.Secondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    RoundCorners(toggleFrame, 8)
    AddShadow(toggleFrame, 10, 0.8)
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text or "Toggle"
    toggleLabel.TextColor3 = Theme.Text
    toggleLabel.TextScaled = true
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 45, 0, 25)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggleButton.BackgroundColor3 = default and Theme.Success or Theme.Tertiary
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    RoundCorners(toggleButton, 12)
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "Indicator"
    toggleIndicator.Size = UDim2.new(0, 19, 0, 19)
    toggleIndicator.Position = default and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
    toggleIndicator.BackgroundColor3 = Theme.Text
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggleButton
    
    RoundCorners(toggleIndicator, 10)
    
    local isToggled = default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        local targetColor = isToggled and Theme.Success or Theme.Tertiary
        local targetPosition = isToggled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
        
        CreateTween(toggleButton, AnimationInfo.Slide, {
            BackgroundColor3 = targetColor
        }):Play()
        
        CreateTween(toggleIndicator, AnimationInfo.Slide, {
            Position = targetPosition
        }):Play()
        
        if callback then
            callback(isToggled)
        end
    end)
    
    -- Hover Effect
    toggleButton.MouseEnter:Connect(function()
        CreateTween(toggleButton, AnimationInfo.Hover, {
            Size = UDim2.new(0, 47, 0, 27)
        }):Play()
    end)
    
    toggleButton.MouseLeave:Connect(function()
        CreateTween(toggleButton, AnimationInfo.Hover, {
            Size = UDim2.new(0, 45, 0, 25)
        }):Play()
    end)
    
    return toggleFrame, function() return isToggled end
end

-- Slider Component
function Components:CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Theme.Secondary
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    RoundCorners(sliderFrame, 8)
    AddShadow(sliderFrame, 10, 0.8)
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Size = UDim2.new(0.6, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text or "Slider"
    sliderLabel.TextColor3 = Theme.Text
    sliderLabel.TextScaled = true
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.4, -10, 0, 20)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = Theme.Accent
    valueLabel.TextScaled = true
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 1, -15)
    sliderBar.BackgroundColor3 = Theme.Tertiary
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    RoundCorners(sliderBar, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    RoundCorners(sliderFill, 3)
    CreateGradient(sliderFill, {Theme.Accent, Theme.AccentHover}, 45)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Theme.Text
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderBar
    
    RoundCorners(sliderButton, 8)
    AddShadow(sliderButton, 8, 0.6)
    
    local currentValue = default or min
    local dragging = false
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        currentValue = min + (max - min) * relativeX
        currentValue = math.floor(currentValue * 100) / 100 -- Round to 2 decimal places
        
        CreateTween(sliderButton, AnimationInfo.Click, {
            Position = UDim2.new(relativeX, -8, 0.5, -8)
        }):Play()
        
        CreateTween(sliderFill, AnimationInfo.Click, {
            Size = UDim2.new(relativeX, 0, 1, 0)
        }):Play()
        
        valueLabel.Text = tostring(currentValue)
        
        if callback then
            callback(currentValue)
        end
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
        CreateTween(sliderButton, AnimationInfo.Click, {
            Size = UDim2.new(0, 20, 0, 20)
        }):Play()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            CreateTween(sliderButton, AnimationInfo.Click, {
                Size = UDim2.new(0, 16, 0, 16)
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    sliderBar.MouseButton1Down:Connect(function()
        updateSlider(UserInputService:GetMouseLocation())
    end)
    
    return sliderFrame, function() return currentValue end
end

-- Dropdown Component
function Components:CreateDropdown(parent, text, options, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "DropdownFrame"
    dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    dropdownFrame.BackgroundColor3 = Theme.Secondary
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = parent
    
    RoundCorners(dropdownFrame, 8)
    AddShadow(dropdownFrame, 10, 0.8)
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = text or "Select Option"
    dropdownButton.TextColor3 = Theme.Text
    dropdownButton.TextScaled = true
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    local dropdownPadding = Instance.new("UIPadding")
    dropdownPadding.PaddingLeft = UDim.new(0, 10)
    dropdownPadding.PaddingRight = UDim.new(0, 30)
    dropdownPadding.Parent = dropdownButton
    
    local dropdownArrow = Instance.new("TextLabel")
    dropdownArrow.Name = "Arrow"
    dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    dropdownArrow.Position = UDim2.new(1, -25, 0, 0)
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = Theme.TextSecondary
    dropdownArrow.TextScaled = true
    dropdownArrow.Font = Enum.Font.Gotham
    dropdownArrow.Parent = dropdownFrame
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Name = "DropdownList"
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.BackgroundColor3 = Theme.Tertiary
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ZIndex = 10
    dropdownList.Parent = dropdownFrame
    
    RoundCorners(dropdownList, 8)
    AddStroke(dropdownList, Theme.Border, 1)
    AddShadow(dropdownList, 15, 0.4)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = dropdownList
    
    local isOpen = false
    local selectedOption = nil
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. i
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = Theme.Tertiary
        optionButton.Text = option
        optionButton.TextColor3 = Theme.Text
        optionButton.TextScaled = true
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Font = Enum.Font.Gotham
        optionButton.BorderSizePixel = 0
        optionButton.Parent = dropdownList
        
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 10)
        optionPadding.Parent = optionButton
        
        optionButton.MouseEnter:Connect(function()
            CreateTween(optionButton, AnimationInfo.Hover, {
                BackgroundColor3 = Theme.Accent
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            CreateTween(optionButton, AnimationInfo.Hover, {
                BackgroundColor3 = Theme.Tertiary
            }):Play()
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdownButton.Text = option
            
            -- Close dropdown
            isOpen = false
            CreateTween(dropdownList, AnimationInfo.Slide, {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            CreateTween(dropdownArrow, AnimationInfo.Slide, {
                Rotation = 0
            }):Play()
            
            wait(0.3)
            dropdownList.Visible = false
            
            if callback then
                callback(option, i)
            end
        end)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            dropdownList.Visible = true
            CreateTween(dropdownList, AnimationInfo.Slide, {
                Size = UDim2.new(1, 0, 0, #options * 30)
            }):Play()
            CreateTween(dropdownArrow, AnimationInfo.Slide, {
                Rotation = 180
            }):Play()
        else
            CreateTween(dropdownList, AnimationInfo.Slide, {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            CreateTween(dropdownArrow, AnimationInfo.Slide, {
                Rotation = 0
            }):Play()
            
            wait(0.3)
            dropdownList.Visible = false
        end
    end)
    
    -- Hover Effect
    dropdownButton.MouseEnter:Connect(function()
        CreateTween(dropdownFrame, AnimationInfo.Hover, {
            BackgroundColor3 = Theme.Tertiary
        }):Play()
    end)
    
    dropdownButton.MouseLeave:Connect(function()
        CreateTween(dropdownFrame, AnimationInfo.Hover, {
            BackgroundColor3 = Theme.Secondary
        }):Play()
    end)
    
    return dropdownFrame, function() return selectedOption end
end

-- TextBox Component
function Components:CreateTextBox(parent, placeholder, callback)
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Name = "TextBoxFrame"
    textboxFrame.Size = UDim2.new(1, 0, 0, 35)
    textboxFrame.BackgroundColor3 = Theme.Secondary
    textboxFrame.BorderSizePixel = 0
    textboxFrame.Parent = parent
    
    RoundCorners(textboxFrame, 8)
    AddShadow(textboxFrame, 10, 0.8)
    AddStroke(textboxFrame, Theme.Border, 1)
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, -20, 1, 0)
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = placeholder or "Enter text..."
    textBox.TextColor3 = Theme.Text
    textBox.PlaceholderColor3 = Theme.TextDim
    textBox.TextScaled = true
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = textboxFrame
    
    -- Focus Effects
    textBox.Focused:Connect(function()
        CreateTween(textboxFrame.UIStroke, AnimationInfo.Hover, {
            Color = Theme.Accent,
            Thickness = 2
        }):Play()
        CreateTween(textboxFrame, AnimationInfo.Hover, {
            BackgroundColor3 = Theme.Tertiary
        }):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        CreateTween(textboxFrame.UIStroke, AnimationInfo.Hover, {
            Color = Theme.Border,
            Thickness = 1
        }):Play()
        CreateTween(textboxFrame, AnimationInfo.Hover, {
            BackgroundColor3 = Theme.Secondary
        }):Play()
        
        if callback then
            callback(textBox.Text)
        end
    end)
    
    return textboxFrame, textBox
end

-- Keybind Component
function Components:CreateKeybind(parent, text, default, callback)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = "KeybindFrame"
    keybindFrame.Size = UDim2.new(1, 0, 0, 35)
    keybindFrame.BackgroundColor3 = Theme.Secondary
    keybindFrame.BorderSizePixel = 0
    keybindFrame.Parent = parent
    
    RoundCorners(keybindFrame, 8)
    AddShadow(keybindFrame, 10, 0.8)
    
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Name = "Label"
    keybindLabel.Size = UDim2.new(1, -80, 1, 0)
    keybindLabel.Position = UDim2.new(0, 10, 0, 0)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Text = text or "Keybind"
    keybindLabel.TextColor3 = Theme.Text
    keybindLabel.TextScaled = true
    keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    keybindLabel.Font = Enum.Font.Gotham
    keybindLabel.Parent = keybindFrame
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Size = UDim2.new(0, 65, 0, 25)
    keybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
    keybindButton.BackgroundColor3 = Theme.Tertiary
    keybindButton.Text = default or "None"
    keybindButton.TextColor3 = Theme.Text
    keybindButton.TextScaled = true
    keybindButton.Font = Enum.Font.GothamBold
    keybindButton.BorderSizePixel = 0
    keybindButton.Parent = keybindFrame
    
    RoundCorners(keybindButton, 6)
    AddStroke(keybindButton, Theme.Border, 1)
    
    local currentKey = default
    local isBinding = false
    
    keybindButton.MouseButton1Click:Connect(function()
        if isBinding then return end
        
        isBinding = true
        keybindButton.Text = "..."
        keybindButton.BackgroundColor3 = Theme.Accent
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            local keyName = input.KeyCode.Name
            if keyName ~= "Unknown" then
                currentKey = keyName
                keybindButton.Text = keyName
                keybindButton.BackgroundColor3 = Theme.Tertiary
                isBinding = false
                connection:Disconnect()
                
                if callback then
                    callback(keyName, input.KeyCode)
                end
            end
        end)
    end)
    
    -- Hover Effect
    keybindButton.MouseEnter:Connect(function()
        if not isBinding then
            CreateTween(keybindButton, AnimationInfo.Hover, {
                BackgroundColor3 = Theme.Accent
            }):Play()
        end
    end)
    
    keybindButton.MouseLeave:Connect(function()
        if not isBinding then
            CreateTween(keybindButton, AnimationInfo.Hover, {
                BackgroundColor3 = Theme.Tertiary
            }):Play()
        end
    end)
    
    return keybindFrame, function() return currentKey end
end

-- Label Component
function Components:CreateLabel(parent, text, color)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text or "Label"
    label.TextColor3 = color or Theme.Text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = parent
    
    return label
end

-- Snow Animation System
local function CreateSnowflake(parent)
    local snowflake = Instance.new("Frame")
    snowflake.Name = "Snowflake"
    snowflake.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
    snowflake.Position = UDim2.new(math.random(0, 100) / 100, 0, 0, -10)
    snowflake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    snowflake.BackgroundTransparency = math.random(30, 70) / 100
    snowflake.BorderSizePixel = 0
    snowflake.ZIndex = 1
    snowflake.Parent = parent
    
    RoundCorners(snowflake, snowflake.Size.X.Offset / 2)
    
    local fallTime = math.random(8, 15)
    local sway = math.random(-50, 50)
    
    local fallTween = CreateTween(snowflake, 
        TweenInfo.new(fallTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), 
        {
            Position = UDim2.new(snowflake.Position.X.Scale + (sway / 1000), 0, 1, 10)
        }
    )
    
    fallTween:Play()
    fallTween.Completed:Connect(function()
        snowflake:Destroy()
    end)
    
    return snowflake
end

local function StartSnowAnimation(parent)
    spawn(function()
        while parent.Parent do
            CreateSnowflake(parent)
            wait(math.random(100, 500) / 1000) -- Random spawn rate
        end
    end)
end

-- Keybind System
local function RegisterKeybind(key, callback, description)
    keybinds[key] = {
        callback = callback,
        description = description or "No description"
    }
end

local function HandleKeybind(key)
    if keybinds[key] then
        keybinds[key].callback()
    end
end

-- DEX Explorer (Simplified Version)
local function CreateDexExplorer()
    local dexGui = Instance.new("ScreenGui")
    dexGui.Name = "DexExplorer"
    dexGui.ResetOnSpawn = false
    dexGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success = pcall(function()
        dexGui.Parent = CoreGui
    end)
    if not success then
        dexGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local dexFrame = Instance.new("Frame")
    dexFrame.Name = "DexFrame"
    dexFrame.Size = UDim2.new(0, 400, 0, 500)
    dexFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    dexFrame.BackgroundColor3 = Theme.Background
    dexFrame.BorderSizePixel = 0
    dexFrame.Active = true
    dexFrame.Draggable = true
    dexFrame.Parent = dexGui
    
    RoundCorners(dexFrame, 12)
    AddStroke(dexFrame, Theme.Border, 1)
    AddShadow(dexFrame, 25, 0.4)
    
    -- Dex Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = dexFrame
    
    RoundCorners(titleBar, 12)
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🔍 DEX Explorer"
    titleText.TextColor3 = Theme.Text
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Theme.Error
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    RoundCorners(closeBtn, 6)
    
    closeBtn.MouseButton1Click:Connect(function()
        dexGui:Destroy()
    end)
    
    -- Dex Content
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ExplorerContent"
    scrollFrame.Size = UDim2.new(1, -20, 1, -60)
    scrollFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollFrame.BackgroundColor3 = Theme.Tertiary
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = Theme.Accent
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = dexFrame
    
    RoundCorners(scrollFrame, 8)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.Name
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = scrollFrame
    
    -- Populate explorer with game services
    local services = {
        "Workspace", "Players", "Lighting", "ReplicatedStorage", 
        "StarterGui", "StarterPack", "StarterPlayer", "SoundService",
        "TweenService", "UserInputService", "RunService"
    }
    
    for _, serviceName in ipairs(services) do
        local serviceButton = Instance.new("TextButton")
        serviceButton.Name = serviceName
        serviceButton.Size = UDim2.new(1, 0, 0, 25)
        serviceButton.BackgroundColor3 = Theme.Secondary
        serviceButton.Text = "📁 " .. serviceName
        serviceButton.TextColor3 = Theme.Text
        serviceButton.TextScaled = true
        serviceButton.TextXAlignment = Enum.TextXAlignment.Left
        serviceButton.Font = Enum.Font.Gotham
        serviceButton.BorderSizePixel = 0
        serviceButton.Parent = scrollFrame
        
        RoundCorners(serviceButton, 4)
        
        local servicePadding = Instance.new("UIPadding")
        servicePadding.PaddingLeft = UDim.new(0, 10)
        servicePadding.Parent = serviceButton
        
        serviceButton.MouseEnter:Connect(function()
            CreateTween(serviceButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Accent
            }):Play()
        end)
        
        serviceButton.MouseLeave:Connect(function()
            CreateTween(serviceButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Secondary
            }):Play()
        end)
    end
    
    return dexGui
end

-- Self Destruct Function
local function SelfDestruct()
    local confirmGui = Instance.new("ScreenGui")
    confirmGui.Name = "SelfDestructConfirm"
    confirmGui.ResetOnSpawn = false
    confirmGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success = pcall(function()
        confirmGui.Parent = CoreGui
    end)
    if not success then
        confirmGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local backdrop = Instance.new("Frame")
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 0.5
    backdrop.BorderSizePixel = 0
    backdrop.Parent = confirmGui
    
    local confirmFrame = Instance.new("Frame")
    confirmFrame.Name = "ConfirmFrame"
    confirmFrame.Size = UDim2.new(0, 300, 0, 150)
    confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    confirmFrame.BackgroundColor3 = Theme.Background
    confirmFrame.BorderSizePixel = 0
    confirmFrame.Parent = confirmGui
    
    RoundCorners(confirmFrame, 12)
    AddStroke(confirmFrame, Theme.Error, 2)
    AddShadow(confirmFrame, 30, 0.3)
    
    local warningLabel = Instance.new("TextLabel")
    warningLabel.Size = UDim2.new(1, -20, 0, 60)
    warningLabel.Position = UDim2.new(0, 10, 0, 10)
    warningLabel.BackgroundTransparency = 1
    warningLabel.Text = "⚠️ SELF DESTRUCT\nThis will destroy the entire UI!"
    warningLabel.TextColor3 = Theme.Error
    warningLabel.TextScaled = true
    warningLabel.Font = Enum.Font.GothamBold
    warningLabel.Parent = confirmFrame
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -20, 0, 40)
    buttonFrame.Position = UDim2.new(0, 10, 1, -50)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = confirmFrame
    
    local confirmButton = Instance.new("TextButton")
    confirmButton.Size = UDim2.new(0.45, 0, 1, 0)
    confirmButton.Position = UDim2.new(0, 0, 0, 0)
    confirmButton.BackgroundColor3 = Theme.Error
    confirmButton.Text = "DESTROY"
    confirmButton.TextColor3 = Theme.Text
    confirmButton.TextScaled = true
    confirmButton.Font = Enum.Font.GothamBold
    confirmButton.BorderSizePixel = 0
    confirmButton.Parent = buttonFrame
    
    RoundCorners(confirmButton, 8)
    
    local cancelButton = Instance.new("TextButton")
    cancelButton.Size = UDim2.new(0.45, 0, 1, 0)
    cancelButton.Position = UDim2.new(0.55, 0, 0, 0)
    cancelButton.BackgroundColor3 = Theme.Secondary
    cancelButton.Text = "Cancel"
    cancelButton.TextColor3 = Theme.Text
    cancelButton.TextScaled = true
    cancelButton.Font = Enum.Font.Gotham
    cancelButton.BorderSizePixel = 0
    cancelButton.Parent = buttonFrame
    
    RoundCorners(cancelButton, 8)
    
    confirmButton.MouseButton1Click:Connect(function()
        if mainScreenGui then
            mainScreenGui:Destroy()
        end
        confirmGui:Destroy()
        
        -- Clear all references
        keybinds = {}
        snowflakes = {}
        utilities = {}
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        confirmGui:Destroy()
    end)
end

-- Utility Buttons System
local function CreateUtilityButtons(parent)
    local utilFrame = Instance.new("Frame")
    utilFrame.Name = "UtilityButtons"
    utilFrame.Size = UDim2.new(0, 350, 0, 50)
    utilFrame.Position = UDim2.new(0.5, -175, 0, 10)
    utilFrame.BackgroundColor3 = Theme.Background
    utilFrame.BorderSizePixel = 0
    utilFrame.Parent = parent
    
    RoundCorners(utilFrame, 25)
    AddStroke(utilFrame, Theme.Border, 1)
    AddShadow(utilFrame, 20, 0.5)
    
    local buttonList = Instance.new("UIListLayout")
    buttonList.FillDirection = Enum.FillDirection.Horizontal
    buttonList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonList.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonList.Padding = UDim.new(0, 10)
    buttonList.Parent = utilFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = utilFrame
    
    local buttons = {
        {"🔍", "DEX", function() CreateDexExplorer() end},
        {"⚙️", "Settings", function() print("Settings opened") end},
        {"🎹", "Keybinds", function() utilities.ShowKeybindList() end},
        {"📜", "Scripts", function() print("Script viewer opened") end},
        {"💥", "Destruct", SelfDestruct}
    }
    
    for i, buttonData in ipairs(buttons) do
        local button = Instance.new("TextButton")
        button.Name = buttonData[2]
        button.Size = UDim2.new(0, 60, 0, 30)
        button.BackgroundColor3 = Theme.Secondary
        button.Text = buttonData[1]
        button.TextColor3 = Theme.Text
        button.TextScaled = true
        button.Font = Enum.Font.GothamBold
        button.BorderSizePixel = 0
        button.Parent = utilFrame
        
        RoundCorners(button, 15)
        
        -- Tooltip
        local tooltip = Instance.new("TextLabel")
        tooltip.Name = "Tooltip"
        tooltip.Size = UDim2.new(0, 80, 0, 20)
        tooltip.Position = UDim2.new(0.5, -40, 0, -25)
        tooltip.BackgroundColor3 = Theme.Tertiary
        tooltip.Text = buttonData[2]
        tooltip.TextColor3 = Theme.Text
        tooltip.TextScaled = true
        tooltip.Font = Enum.Font.Gotham
        tooltip.BorderSizePixel = 0
        tooltip.Visible = false
        tooltip.ZIndex = 10
        tooltip.Parent = button
        
        RoundCorners(tooltip, 4)
        AddStroke(tooltip, Theme.Border, 1)
        
        button.MouseEnter:Connect(function()
            CreateTween(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new(0, 65, 0, 35)
            }):Play()
            tooltip.Visible = true
        end)
        
        button.MouseLeave:Connect(function()
            CreateTween(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(0, 60, 0, 30)
            }):Play()
            tooltip.Visible = false
        end)
        
        button.MouseButton1Click:Connect(buttonData[3])
    end
    
    return utilFrame
end

-- Keybind List GUI
local function ShowKeybindList()
    local keybindGui = Instance.new("ScreenGui")
    keybindGui.Name = "KeybindList"
    keybindGui.ResetOnSpawn = false
    keybindGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success = pcall(function()
        keybindGui.Parent = CoreGui
    end)
    if not success then
        keybindGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = "KeybindFrame"
    keybindFrame.Size = UDim2.new(0, 350, 0, 400)
    keybindFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    keybindFrame.BackgroundColor3 = Theme.Background
    keybindFrame.BorderSizePixel = 0
    keybindFrame.Active = true
    keybindFrame.Draggable = true
    keybindFrame.Parent = keybindGui
    
    RoundCorners(keybindFrame, 12)
    AddStroke(keybindFrame, Theme.Border, 1)
    AddShadow(keybindFrame, 25, 0.4)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = keybindFrame
    
    RoundCorners(titleBar, 12)
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🎹 Keybind List"
    titleText.TextColor3 = Theme.Text
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Theme.Error
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    RoundCorners(closeBtn, 6)
    
    closeBtn.MouseButton1Click:Connect(function()
        keybindGui:Destroy()
    end)
    
    -- Keybind List Content
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "KeybindContent"
    scrollFrame.Size = UDim2.new(1, -20, 1, -60)
    scrollFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollFrame.BackgroundColor3 = Theme.Tertiary
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = Theme.Accent
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = keybindFrame
    
    RoundCorners(scrollFrame, 8)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = scrollFrame
    
    -- Display keybinds
    for key, data in pairs(keybinds) do
        local keybindItem = Instance.new("Frame")
        keybindItem.Size = UDim2.new(1, 0, 0, 40)
        keybindItem.BackgroundColor3 = Theme.Secondary
        keybindItem.BorderSizePixel = 0
        keybindItem.Parent = scrollFrame
        
        RoundCorners(keybindItem, 6)
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(0, 60, 1, 0)
        keyLabel.Position = UDim2.new(0, 10, 0, 0)
        keyLabel.BackgroundColor3 = Theme.Accent
        keyLabel.Text = key
        keyLabel.TextColor3 = Theme.Text
        keyLabel.TextScaled = true
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.BorderSizePixel = 0
        keyLabel.Parent = keybindItem
        
        RoundCorners(keyLabel, 4)
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -80, 1, 0)
        descLabel.Position = UDim2.new(0, 75, 0, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = data.description
        descLabel.TextColor3 = Theme.Text
        descLabel.TextScaled = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Font = Enum.Font.Gotham
        descLabel.Parent = keybindItem
    end
    
    if next(keybinds) == nil then
        local noKeybinds = Instance.new("TextLabel")
        noKeybinds.Size = UDim2.new(1, 0, 0, 40)
        noKeybinds.BackgroundTransparency = 1
        noKeybinds.Text = "No keybinds registered"
        noKeybinds.TextColor3 = Theme.TextDim
        noKeybinds.TextScaled = true
        noKeybinds.Font = Enum.Font.Gotham
        noKeybinds.Parent = scrollFrame
    end
end

utilities.ShowKeybindList = ShowKeybindList

-- Main Library Object
function UILibrary:CreateWindow(title, options)
    options = options or {}
    local window = {}
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibraryGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true  -- This makes it fullscreen
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success = pcall(function()
        screenGui.Parent = CoreGui
    end)
    if not success then
        screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    mainScreenGui = screenGui
    
    -- Snow Background (Fixed to cover entire screen)
    local snowBackground = Instance.new("Frame")
    snowBackground.Name = "SnowBackground"
    snowBackground.Size = UDim2.new(1, 0, 1, 0)  -- Full screen size
    snowBackground.Position = UDim2.new(0, 0, 0, 0)  -- Top-left position
    snowBackground.BackgroundTransparency = 1
    snowBackground.BorderSizePixel = 0
    snowBackground.ZIndex = 1
    snowBackground.Parent = screenGui
    
    StartSnowAnimation(snowBackground)
    
    -- Utility Buttons
    CreateUtilityButtons(screenGui)
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, options.Size and options.Size.X or 700, 0, options.Size and options.Size.Y or 500)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -180)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ZIndex = 2
    mainFrame.Parent = screenGui
    
    RoundCorners(mainFrame, 15)
    AddStroke(mainFrame, Theme.Border, 1)
    AddShadow(mainFrame, 30, 0.4)
    
    -- Floating effect
    spawn(function()
        while mainFrame.Parent do
            CreateTween(mainFrame, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = mainFrame.Position + UDim2.new(0, 0, 0, -5)
            }):Play()
            wait(3)
            CreateTween(mainFrame, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = mainFrame.Position + UDim2.new(0, 0, 0, 5)
            }):Play()
            wait(3)
        end
    end)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    RoundCorners(titleBar, 15)
    CreateGradient(titleBar, {Theme.Secondary, Theme.Tertiary}, 45)
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -150, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "🌟 UI Library Premium"
    titleText.TextColor3 = Theme.Text
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    -- Window Controls
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -45, 0, 7.5)
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.Text = "✕"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    RoundCorners(closeButton, 8)
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 35, 0, 35)
    minimizeButton.Position = UDim2.new(1, -85, 0, 7.5)
    minimizeButton.BackgroundColor3 = Theme.Warning
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = Theme.Text
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Parent = titleBar
    
    RoundCorners(minimizeButton, 8)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 35, 0, 35)
    toggleButton.Position = UDim2.new(1, -125, 0, 7.5)
    toggleButton.BackgroundColor3 = Theme.Success
    toggleButton.Text = "👁️"
    toggleButton.TextColor3 = Theme.Text
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = titleBar
    
    RoundCorners(toggleButton, 8)
    
    -- Button Functions
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, originalSize.X.Offset, 0, 50) or originalSize
        CreateTween(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = targetSize
        }):Play()
    end)
    
    toggleButton.MouseButton1Click:Connect(function()
        isUIVisible = not isUIVisible
        local targetTransparency = isUIVisible and 0 or 0.9
        CreateTween(mainFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = targetTransparency
        }):Play()
    end)
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -30, 1, -80)
    contentFrame.Position = UDim2.new(0, 15, 0, 65)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 180, 1, 0)
    tabContainer.BackgroundColor3 = Theme.Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = contentFrame
    
    RoundCorners(tabContainer, 10)
    AddStroke(tabContainer, Theme.Border, 1)
    
    -- Tab Content
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -195, 1, 0)
    tabContent.Position = UDim2.new(0, 195, 0, 0)
    tabContent.BackgroundColor3 = Theme.Tertiary
    tabContent.BorderSizePixel = 0
    tabContent.Parent = contentFrame
    
    RoundCorners(tabContent, 10)
    AddStroke(tabContent, Theme.Border, 1)
    
    -- Tab List
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 8)
    tabList.Parent = tabContainer
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.Parent = tabContainer
    
    window.tabs = {}
    window.activeTab = nil
    
    -- Register default keybinds
    RegisterKeybind("LeftControl", function()
        isUIVisible = not isUIVisible
        local targetTransparency = isUIVisible and 0 or 0.9
        CreateTween(mainFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = targetTransparency
        }):Play()
    end, "Toggle UI Visibility")
    
    -- Tab Creation Method
    function window:CreateTab(name, icon)
        local tab = {}
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 45)
        tabButton.BackgroundColor3 = Theme.Tertiary
        tabButton.Text = (icon and icon .. " " or "📋 ") .. name
        tabButton.TextColor3 = Theme.TextSecondary
        tabButton.TextScaled = true
        tabButton.Font = Enum.Font.GothamBold
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabContainer
        
        RoundCorners(tabButton, 8)
        AddStroke(tabButton, Theme.Border, 1)
        
        -- Tab Content Frame
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = name .. "Content"
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 8
        tabFrame.ScrollBarImageColor3 = Theme.Accent
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = tabContent
        
        -- Tab Content List
        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 15)
        contentList.Parent = tabFrame
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 20)
        contentPadding.PaddingLeft = UDim.new(0, 20)
        contentPadding.PaddingRight = UDim.new(0, 20)
        contentPadding.PaddingBottom = UDim.new(0, 20)
        contentPadding.Parent = tabFrame
        
        -- Tab Button Click
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, otherTab in pairs(window.tabs) do
                otherTab.frame.Visible = false
                CreateTween(otherTab.button, TweenInfo.new(0.3), {
                    BackgroundColor3 = Theme.Tertiary,
                    TextColor3 = Theme.TextSecondary
                }):Play()
            end
            
            -- Show this tab
            tabFrame.Visible = true
            CreateTween(tabButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Theme.Accent,
                TextColor3 = Theme.Text
            }):Play()
            window.activeTab = tab
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if window.activeTab ~= tab then
                CreateTween(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Theme.AccentHover,
                    Size = UDim2.new(1, 5, 0, 47)
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.activeTab ~= tab then
                CreateTween(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Theme.Tertiary,
                    Size = UDim2.new(1, 0, 0, 45)
                }):Play()
            end
        end)
        
        tab.button = tabButton
        tab.frame = tabFrame
        tab.sections = {}
        
        -- Auto-select first tab
        if #window.tabs == 0 then
            tabFrame.Visible = true
            tabButton.BackgroundColor3 = Theme.Accent
            tabButton.TextColor3 = Theme.Text
            window.activeTab = tab
        end
        
        table.insert(window.tabs, tab)
        
        -- Add Components to Tab
        function tab:AddButton(options)
            return Components:CreateButton(self.frame, options.Text, options.Callback)
        end
        
        function tab:AddToggle(options)
            return Components:CreateToggle(self.frame, options.Text, options.Default, options.Callback)
        end
        
        function tab:AddSlider(options)
            return Components:CreateSlider(self.frame, options.Text, options.Min, options.Max, options.Default, options.Callback)
        end
        
        function tab:AddDropdown(options)
            return Components:CreateDropdown(self.frame, options.Text, options.List, options.Callback)
        end
        
        function tab:AddTextBox(options)
            return Components:CreateTextBox(self.frame, options.PlaceholderText, options.Callback)
        end
        
        function tab:AddKeybind(options)
            local keybindFrame, getKey = Components:CreateKeybind(self.frame, options.Text, options.Default, function(key, keyCode)
                if options.Callback then
                    options.Callback(key, keyCode)
                end
                if options.Text and key ~= "None" then
                    RegisterKeybind(key, options.Callback, options.Text)
                end
            end)
            return keybindFrame, getKey
        end
        
        function tab:AddLabel(text, color)
            return Components:CreateLabel(self.frame, text, color)
        end
        
        function tab:CreateSection(name)
            local section = {}
            
            -- Section Frame
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundColor3 = Theme.Background
            sectionFrame.BorderSizePixel = 0
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = self.frame
            
            RoundCorners(sectionFrame, 10)
            AddStroke(sectionFrame, Theme.Border, 1)
            AddShadow(sectionFrame, 15, 0.7)
            
            -- Section Title
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, -30, 0, 35)
            sectionTitle.Position = UDim2.new(0, 15, 0, 8)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = "🔸 " .. name
            sectionTitle.TextColor3 = Theme.Accent
            sectionTitle.TextScaled = true
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.Parent = sectionFrame
            
            -- Section Content
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.Size = UDim2.new(1, -30, 0, 0)
            sectionContent.Position = UDim2.new(0, 15, 0, 45)
            sectionContent.BackgroundTransparency = 1
            sectionContent.AutomaticSize = Enum.AutomaticSize.Y
            sectionContent.Parent = sectionFrame
            
            local sectionList = Instance.new("UIListLayout")
            sectionList.SortOrder = Enum.SortOrder.LayoutOrder
            sectionList.Padding = UDim.new(0, 10)
            sectionList.Parent = sectionContent
            
            local sectionPadding = Instance.new("UIPadding")
            sectionPadding.PaddingBottom = UDim.new(0, 15)
            sectionPadding.Parent = sectionContent
            
            section.frame = sectionFrame
            section.content = sectionContent
            table.insert(self.sections, section)
            
            -- Add Components to Section
            function section:AddButton(options)
                return Components:CreateButton(self.content, options.Text, options.Callback)
            end
            
            function section:AddToggle(options)
                return Components:CreateToggle(self.content, options.Text, options.Default, options.Callback)
            end
            
            function section:AddSlider(options)
                return Components:CreateSlider(self.content, options.Text, options.Min, options.Max, options.Default, options.Callback)
            end
            
            function section:AddDropdown(options)
                return Components:CreateDropdown(self.content, options.Text, options.List, options.Callback)
            end
            
            function section:AddTextBox(options)
                return Components:CreateTextBox(self.content, options.PlaceholderText, options.Callback)
            end
            
            function section:AddKeybind(options)
                local keybindFrame, getKey = Components:CreateKeybind(self.content, options.Text, options.Default, function(key, keyCode)
                    if options.Callback then
                        options.Callback(key, keyCode)
                    end
                    if options.Text and key ~= "None" then
                        RegisterKeybind(key, options.Callback, options.Text)
                    end
                end)
                return keybindFrame, getKey
            end
            
            function section:AddLabel(text, color)
                return Components:CreateLabel(self.content, text, color)
            end
            
            return section
        end
        
        return tab
    end
    
    -- Handle keybind input
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        HandleKeybind(input.KeyCode.Name)
    end)
    
    return window
end

-- Utility Functions for External Use
UILibrary.RegisterKeybind = RegisterKeybind
UILibrary.ShowKeybindList = ShowKeybindList
UILibrary.CreateDexExplorer = CreateDexExplorer
UILibrary.SelfDestruct = SelfDestruct

return UILibrary