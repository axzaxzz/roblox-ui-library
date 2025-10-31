--[[
    Matcha UI Library - Clean & Professional
    No errors, exact Matcha styling, no cartoony elements
--]]

local UILibrary = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Matcha Theme - Exact Colors
local Theme = {
    Background = Color3.fromRGB(22, 22, 24),
    Panel = Color3.fromRGB(28, 28, 32),
    PanelDeep = Color3.fromRGB(18, 18, 20),
    Stroke = Color3.fromRGB(56, 56, 62),
    Accent = Color3.fromRGB(216, 128, 216),
    Text = Color3.fromRGB(235, 235, 238),
    TextDim = Color3.fromRGB(160, 160, 168)
}

-- Keybind System
local keybinds = {}
local mainScreenGui = nil

-- Simple Utility Functions
local function RoundCorners(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = frame
    return corner
end

local function AddStroke(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Stroke
    stroke.Thickness = thickness or 1
    stroke.Parent = frame
    return stroke
end

-- Simple Components
local Components = {}

function Components:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 24)
    button.BackgroundColor3 = Theme.Accent
    button.Text = text or "Button"
    button.TextColor3 = Theme.Text
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = parent
    
    RoundCorners(button, 6)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

function Components:CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundColor3 = Theme.Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    RoundCorners(frame, 6)
    AddStroke(frame, Theme.Stroke)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -44, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Toggle"
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 34, 0, 18)
    toggle.Position = UDim2.new(1, -38, 0.5, -9)
    toggle.BackgroundColor3 = default and Theme.Accent or Theme.PanelDeep
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    RoundCorners(toggle, 9)
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 12, 0, 12)
    indicator.Position = default and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    indicator.BackgroundColor3 = Theme.Text
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    
    RoundCorners(indicator, 6)
    
    local isToggled = default or false
    
    toggle.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggle.BackgroundColor3 = isToggled and Theme.Accent or Theme.PanelDeep
        indicator.Position = isToggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        
        if callback then
            callback(isToggled)
        end
    end)
    
    return frame
end

function Components:CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Theme.Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    RoundCorners(frame, 6)
    AddStroke(frame, Theme.Stroke)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 16)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text or "Slider"
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, -8, 0, 16)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = Theme.TextDim
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -16, 0, 6)
    sliderBar.Position = UDim2.new(0, 8, 1, -12)
    sliderBar.BackgroundColor3 = Theme.PanelDeep
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame
    
    RoundCorners(sliderBar, 3)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    
    RoundCorners(fill, 3)
    
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    knob.BackgroundColor3 = Theme.Text
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = sliderBar
    
    RoundCorners(knob, 5)
    
    local currentValue = default or min
    local dragging = false
    
    local function updateSlider(x)
        local relativeX = math.clamp((x - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        currentValue = min + (max - min) * relativeX
        currentValue = math.floor(currentValue * 100) / 100
        
        knob.Position = UDim2.new(relativeX, -5, 0.5, -5)
        fill.Size = UDim2.new(relativeX, 0, 1, 0)
        valueLabel.Text = tostring(currentValue)
        
        if callback then
            callback(currentValue)
        end
    end
    
    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    
    sliderBar.MouseButton1Down:Connect(function()
        updateSlider(UserInputService:GetMouseLocation().X)
    end)
    
    return frame
end

function Components:CreateDropdown(parent, text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundColor3 = Theme.Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    RoundCorners(frame, 6)
    AddStroke(frame, Theme.Stroke)
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 1, 0)
    button.Position = UDim2.new(0, 8, 0, 0)
    button.BackgroundTransparency = 1
    button.Text = text or "Select"
    button.TextColor3 = Theme.Text
    button.TextSize = 12
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Font = Enum.Font.Gotham
    button.Parent = frame
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 16, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = Theme.TextDim
    arrow.TextSize = 10
    arrow.Font = Enum.Font.Gotham
    arrow.Parent = frame
    
    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 1, 2)
    list.BackgroundColor3 = Theme.Panel
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 10
    list.Parent = frame
    
    RoundCorners(list, 6)
    AddStroke(list, Theme.Stroke)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = list
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 22)
        optionButton.BackgroundColor3 = Theme.Panel
        optionButton.Text = option
        optionButton.TextColor3 = Theme.Text
        optionButton.TextSize = 11
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Font = Enum.Font.Gotham
        optionButton.BorderSizePixel = 0
        optionButton.Parent = list
        
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 8)
        optionPadding.Parent = optionButton
        
        optionButton.MouseButton1Click:Connect(function()
            button.Text = option
            list.Visible = false
            list.Size = UDim2.new(1, 0, 0, 0)
            
            if callback then
                callback(option, i)
            end
        end)
    end
    
    local isOpen = false
    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        list.Visible = isOpen
        if isOpen then
            list.Size = UDim2.new(1, 0, 0, #options * 22)
        else
            list.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
    
    return frame
end

function Components:CreateTextBox(parent, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundColor3 = Theme.Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    RoundCorners(frame, 6)
    AddStroke(frame, Theme.Stroke)
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -16, 1, 0)
    textBox.Position = UDim2.new(0, 8, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = placeholder or "Enter text"
    textBox.TextColor3 = Theme.Text
    textBox.PlaceholderColor3 = Theme.TextDim
    textBox.TextSize = 12
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame
    
    if callback then
        textBox.FocusLost:Connect(function()
            callback(textBox.Text)
        end)
    end
    
    return frame
end

function Components:CreateKeybind(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundColor3 = Theme.Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    RoundCorners(frame, 6)
    AddStroke(frame, Theme.Stroke)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Keybind"
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local keyButton = Instance.new("TextButton")
    keyButton.Size = UDim2.new(0, 50, 0, 16)
    keyButton.Position = UDim2.new(1, -54, 0.5, -8)
    keyButton.BackgroundColor3 = Theme.PanelDeep
    keyButton.Text = default or "None"
    keyButton.TextColor3 = Theme.Text
    keyButton.TextSize = 10
    keyButton.Font = Enum.Font.GothamBold
    keyButton.BorderSizePixel = 0
    keyButton.Parent = frame
    
    RoundCorners(keyButton, 4)
    AddStroke(keyButton, Theme.Stroke)
    
    local currentKey = default
    local binding = false
    
    keyButton.MouseButton1Click:Connect(function()
        if binding then return end
        binding = true
        keyButton.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            local keyName = input.KeyCode.Name
            if keyName ~= "Unknown" then
                currentKey = keyName
                keyButton.Text = keyName
                binding = false
                connection:Disconnect()
                
                if callback then
                    callback(keyName)
                end
                
                if text then
                    keybinds[keyName] = {callback = callback, description = text}
                end
            end
        end)
    end)
    
    return frame
end

function Components:CreateLabel(parent, text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text or "Label"
    label.TextColor3 = color or Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = parent
    
    return label
end

-- Snow System (Simple)
local function CreateSnowflake(parent)
    local snowflake = Instance.new("Frame")
    snowflake.Size = UDim2.new(0, 4, 0, 4)
    snowflake.Position = UDim2.new(math.random() * 1, 0, 0, -10)
    snowflake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    snowflake.BackgroundTransparency = 0.5
    snowflake.BorderSizePixel = 0
    snowflake.Parent = parent
    
    RoundCorners(snowflake, 2)
    
    spawn(function()
        local startPos = snowflake.Position
        local endPos = UDim2.new(startPos.X.Scale, startPos.X.Offset, 1.1, 0)
        
        for i = 1, 100 do
            local alpha = i / 100
            snowflake.Position = startPos:lerp(endPos, alpha)
            wait(0.1)
        end
        
        snowflake:Destroy()
    end)
end

local function StartSnow(parent)
    spawn(function()
        while parent.Parent do
            CreateSnowflake(parent)
            wait(math.random() * 2)
        end
    end)
end

-- Utility Functions
local function ShowKeybindList()
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeybindList"
    gui.ResetOnSpawn = false
    
    local success = pcall(function()
        gui.Parent = CoreGui
    end)
    if not success then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Theme.Background
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    RoundCorners(frame, 6)
    AddStroke(frame, Theme.Stroke)
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Theme.Panel
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    
    RoundCorners(titleBar, 6)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -32, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Keybinds"
    title.TextColor3 = Theme.Text
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -28, 0, 4)
    closeBtn.BackgroundColor3 = Theme.PanelDeep
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 10
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    RoundCorners(closeBtn, 4)
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -12, 1, -44)
    content.Position = UDim2.new(0, 6, 0, 38)
    content.BackgroundColor3 = Theme.PanelDeep
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Theme.Accent
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = frame
    
    RoundCorners(content, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = content
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.Parent = content
    
    for key, data in pairs(keybinds) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 24)
        item.BackgroundColor3 = Theme.Panel
        item.BorderSizePixel = 0
        item.Parent = content
        
        RoundCorners(item, 4)
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(0, 40, 1, 0)
        keyLabel.Position = UDim2.new(0, 6, 0, 0)
        keyLabel.BackgroundColor3 = Theme.Accent
        keyLabel.Text = key
        keyLabel.TextColor3 = Theme.Text
        keyLabel.TextSize = 10
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.BorderSizePixel = 0
        keyLabel.Parent = item
        
        RoundCorners(keyLabel, 3)
        
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -52, 1, 0)
        desc.Position = UDim2.new(0, 50, 0, 0)
        desc.BackgroundTransparency = 1
        desc.Text = data.description
        desc.TextColor3 = Theme.TextDim
        desc.TextSize = 11
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Font = Enum.Font.Gotham
        desc.Parent = item
    end
end

local function CreateDexExplorer()
    local gui = Instance.new("ScreenGui")
    gui.Name = "DexExplorer"
    gui.ResetOnSpawn = false
    
    local success = pcall(function()
        gui.Parent = CoreGui
    end)
    if not success then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 450)
    frame.Position = UDim2.new(0.5, -175, 0.5, -225)
    frame.BackgroundColor3 = Theme.Background
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    RoundCorners(frame, 6)
    AddStroke(frame, Theme.Stroke)
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Theme.Panel
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    
    RoundCorners(titleBar, 6)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -32, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Explorer"
    title.TextColor3 = Theme.Text
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -28, 0, 4)
    closeBtn.BackgroundColor3 = Theme.PanelDeep
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 10
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    RoundCorners(closeBtn, 4)
    
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -12, 1, -44)
    content.Position = UDim2.new(0, 6, 0, 38)
    content.BackgroundColor3 = Theme.PanelDeep
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Theme.Accent
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = frame
    
    RoundCorners(content, 6)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 1)
    layout.Parent = content
    
    local services = {"Workspace", "Players", "Lighting", "ReplicatedStorage", "StarterGui"}
    
    for _, service in ipairs(services) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, 0, 0, 22)
        item.BackgroundColor3 = Theme.Panel
        item.Text = service
        item.TextColor3 = Theme.Text
        item.TextSize = 11
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.Font = Enum.Font.Gotham
        item.BorderSizePixel = 0
        item.Parent = content
        
        local itemPadding = Instance.new("UIPadding")
        itemPadding.PaddingLeft = UDim.new(0, 8)
        itemPadding.Parent = item
    end
end

local function SelfDestruct()
    if mainScreenGui then
        mainScreenGui:Destroy()
    end
end

-- Main Library
function UILibrary:CreateWindow(title, options)
    options = options or {}
    local window = {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibraryGUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    
    local success = pcall(function()
        screenGui.Parent = CoreGui
    end)
    if not success then
        screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    mainScreenGui = screenGui
    
    -- Snow Background
    local snowBg = Instance.new("Frame")
    snowBg.Size = UDim2.new(1, 0, 1, 0)
    snowBg.BackgroundTransparency = 1
    snowBg.Parent = screenGui
    
    StartSnow(snowBg)
    
    -- Utility Bar
    local utilBar = Instance.new("Frame")
    utilBar.Size = UDim2.new(0, 260, 0, 20)
    utilBar.Position = UDim2.new(0.5, -130, 0, 10)
    utilBar.BackgroundColor3 = Theme.Panel
    utilBar.BorderSizePixel = 0
    utilBar.Parent = screenGui
    
    RoundCorners(utilBar, 6)
    AddStroke(utilBar, Theme.Stroke)
    
    local utilLayout = Instance.new("UIListLayout")
    utilLayout.FillDirection = Enum.FillDirection.Horizontal
    utilLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    utilLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    utilLayout.Padding = UDim.new(0, 8)
    utilLayout.Parent = utilBar
    
    local utilButtons = {
        {"SEARCH", CreateDexExplorer},
        {"BIND", ShowKeybindList},
        {"SCRIPT", function() print("Scripts") end},
        {"CONFIG", function() print("Config") end},
        {"KILL", SelfDestruct}
    }
    
    for _, btnData in ipairs(utilButtons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 44, 0, 14)
        btn.BackgroundColor3 = Theme.PanelDeep
        btn.Text = btnData[1]
        btn.TextColor3 = Theme.TextDim
        btn.TextSize = 8
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = utilBar
        
        RoundCorners(btn, 3)
        
        btn.MouseButton1Click:Connect(btnData[2])
    end
    
    -- Main Window
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, options.Size and options.Size.X or 520, 0, options.Size and options.Size.Y or 560)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -280)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ZIndex = 2
    mainFrame.Parent = screenGui
    
    RoundCorners(mainFrame, 6)
    AddStroke(mainFrame, Theme.Stroke)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Theme.Panel
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    RoundCorners(titleBar, 6)
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "Matcha - mirko"
    titleText.TextColor3 = Theme.Text
    titleText.TextSize = 13
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -28, 0, 4)
    closeButton.BackgroundColor3 = Theme.PanelDeep
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 10
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    RoundCorners(closeButton, 4)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Content Area
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -12, 1, -44)
    content.Position = UDim2.new(0, 6, 0, 38)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 110, 1, 0)
    sidebar.BackgroundColor3 = Theme.Panel
    sidebar.BorderSizePixel = 0
    sidebar.Parent = content
    
    RoundCorners(sidebar, 6)
    AddStroke(sidebar, Theme.Stroke)
    
    -- Tab Content
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, -118, 1, 0)
    tabContent.Position = UDim2.new(0, 118, 0, 0)
    tabContent.BackgroundColor3 = Theme.PanelDeep
    tabContent.BorderSizePixel = 0
    tabContent.Parent = content
    
    RoundCorners(tabContent, 6)
    AddStroke(tabContent, Theme.Stroke)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 8)
    sidebarPadding.PaddingLeft = UDim.new(0, 8)
    sidebarPadding.PaddingRight = UDim.new(0, 8)
    sidebarPadding.PaddingBottom = UDim.new(0, 8)
    sidebarPadding.Parent = sidebar
    
    window.tabs = {}
    window.activeTab = nil
    
    -- Register toggle keybind
    keybinds["LeftControl"] = {
        callback = function()
            mainFrame.Visible = not mainFrame.Visible
        end,
        description = "Toggle UI"
    }
    
    function window:CreateTab(name)
        local tab = {}
        
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 20)
        tabButton.BackgroundColor3 = Theme.PanelDeep
        tabButton.Text = name
        tabButton.TextColor3 = Theme.TextDim
        tabButton.TextSize = 11
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = sidebar
        
        RoundCorners(tabButton, 4)
        
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 4
        tabFrame.ScrollBarImageColor3 = Theme.Accent
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = tabContent
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabFrame
        
        local tabPadding = Instance.new("UIPadding")
        tabPadding.PaddingTop = UDim.new(0, 12)
        tabPadding.PaddingLeft = UDim.new(0, 12)
        tabPadding.PaddingRight = UDim.new(0, 12)
        tabPadding.PaddingBottom = UDim.new(0, 12)
        tabPadding.Parent = tabFrame
        
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, otherTab in pairs(window.tabs) do
                otherTab.frame.Visible = false
                otherTab.button.BackgroundColor3 = Theme.PanelDeep
                otherTab.button.TextColor3 = Theme.TextDim
            end
            
            -- Show this tab
            tabFrame.Visible = true
            tabButton.BackgroundColor3 = Theme.Accent
            tabButton.TextColor3 = Theme.Text
            window.activeTab = tab
        end)
        
        tab.button = tabButton
        tab.frame = tabFrame
        
        -- Auto-select first tab
        if #window.tabs == 0 then
            tabFrame.Visible = true
            tabButton.BackgroundColor3 = Theme.Accent
            tabButton.TextColor3 = Theme.Text
            window.activeTab = tab
        end
        
        table.insert(window.tabs, tab)
        
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
            return Components:CreateKeybind(self.frame, options.Text, options.Default, options.Callback)
        end
        
        function tab:AddLabel(text, color)
            return Components:CreateLabel(self.frame, text, color)
        end
        
        function tab:CreateSection(name)
            local section = {}
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundColor3 = Theme.Panel
            sectionFrame.BorderSizePixel = 0
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = self.frame
            
            RoundCorners(sectionFrame, 6)
            AddStroke(sectionFrame, Theme.Stroke)
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Size = UDim2.new(1, -16, 0, 24)
            sectionTitle.Position = UDim2.new(0, 8, 0, 4)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = Theme.Accent
            sectionTitle.TextSize = 12
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.Parent = sectionFrame
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Size = UDim2.new(1, -16, 0, 0)
            sectionContent.Position = UDim2.new(0, 8, 0, 28)
            sectionContent.BackgroundTransparency = 1
            sectionContent.AutomaticSize = Enum.AutomaticSize.Y
            sectionContent.Parent = sectionFrame
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Padding = UDim.new(0, 6)
            sectionLayout.Parent = sectionContent
            
            local sectionPadding = Instance.new("UIPadding")
            sectionPadding.PaddingBottom = UDim.new(0, 8)
            sectionPadding.Parent = sectionContent
            
            section.content = sectionContent
            
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
                return Components:CreateKeybind(self.content, options.Text, options.Default, options.Callback)
            end
            
            function section:AddLabel(text, color)
                return Components:CreateLabel(self.content, text, color)
            end
            
            return section
        end
        
        return tab
    end
    
    -- Handle keybinds
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local key = input.KeyCode.Name
        if keybinds[key] then
            keybinds[key].callback()
        end
    end)
    
    return window
end

-- Expose utilities
UILibrary.ShowKeybindList = ShowKeybindList
UILibrary.CreateDexExplorer = CreateDexExplorer
UILibrary.SelfDestruct = SelfDestruct

return UILibrary