--[[
    UI Library Components
    Advanced components with smooth animations and modern styling
--]]

local Components = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Theme (imported from main library)
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

local function AddShadow(frame, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 3)
    shadow.Size = UDim2.new(1, size or 20, 1, size or 20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.7
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame.Parent
    
    RoundCorners(shadow, (size or 20) / 2)
    return shadow
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

return Components