--[[
    Modern Roblox UI Library
    Created by: axzaxzz
    A comprehensive, dark-themed UI library with modern components
--]]

local UILibrary = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

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

-- Main Library Object
function UILibrary:CreateWindow(title, options)
    options = options or {}
    local window = {}
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibraryGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success = pcall(function()
        screenGui.Parent = CoreGui
    end)
    if not success then
        screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, options.Size and options.Size.X or 600, 0, options.Size and options.Size.Y or 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    RoundCorners(mainFrame, 12)
    AddStroke(mainFrame, Theme.Border, 1)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    RoundCorners(titleBar, 12)
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "UI Library"
    titleText.TextColor3 = Theme.Text
    titleText.TextScaled = true
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    RoundCorners(closeButton, 6)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    minimizeButton.BackgroundColor3 = Theme.Warning
    minimizeButton.Text = "_"
    minimizeButton.TextColor3 = Theme.Text
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Parent = titleBar
    
    RoundCorners(minimizeButton, 6)
    
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, originalSize.X.Offset, 0, 40) or originalSize
        CreateTween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = targetSize
        }):Play()
    end)
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, 0)
    tabContainer.BackgroundColor3 = Theme.Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = contentFrame
    
    RoundCorners(tabContainer, 8)
    
    -- Tab Content
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -160, 1, 0)
    tabContent.Position = UDim2.new(0, 160, 0, 0)
    tabContent.BackgroundColor3 = Theme.Tertiary
    tabContent.BorderSizePixel = 0
    tabContent.Parent = contentFrame
    
    RoundCorners(tabContent, 8)
    
    -- Tab List
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabContainer
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = tabContainer
    
    window.tabs = {}
    window.activeTab = nil
    
    function window:CreateTab(name, icon)
        local tab = {}
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.BackgroundColor3 = Theme.Tertiary
        tabButton.Text = (icon and icon .. " " or "") .. name
        tabButton.TextColor3 = Theme.TextSecondary
        tabButton.TextScaled = true
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabContainer
        
        RoundCorners(tabButton, 6)
        
        -- Tab Content Frame
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = name .. "Content"
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.ScrollBarThickness = 6
        tabFrame.ScrollBarImageColor3 = Theme.Accent
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Visible = false
        tabFrame.Parent = tabContent
        
        -- Tab Content List
        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 10)
        contentList.Parent = tabFrame
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingAll = UDim.new(0, 15)
        contentPadding.Parent = tabFrame
        
        -- Tab Button Click
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, otherTab in pairs(window.tabs) do
                otherTab.frame.Visible = false
                otherTab.button.BackgroundColor3 = Theme.Tertiary
                otherTab.button.TextColor3 = Theme.TextSecondary
            end
            
            -- Show this tab
            tabFrame.Visible = true
            tabButton.BackgroundColor3 = Theme.Accent
            tabButton.TextColor3 = Theme.Text
            window.activeTab = tab
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if window.activeTab ~= tab then
                CreateTween(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Theme.AccentHover
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.activeTab ~= tab then
                CreateTween(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Theme.Tertiary
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
        
        -- Tab Methods
        function tab:CreateSection(name)
            local section = {}
            
            -- Section Frame
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundColor3 = Theme.Background
            sectionFrame.BorderSizePixel = 0
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = tabFrame
            
            RoundCorners(sectionFrame, 8)
            AddStroke(sectionFrame, Theme.Border, 1)
            
            -- Section Title
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, -20, 0, 30)
            sectionTitle.Position = UDim2.new(0, 10, 0, 5)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = Theme.Text
            sectionTitle.TextScaled = true
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.Parent = sectionFrame
            
            -- Section Content
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.Size = UDim2.new(1, -20, 0, 0)
            sectionContent.Position = UDim2.new(0, 10, 0, 35)
            sectionContent.BackgroundTransparency = 1
            sectionContent.AutomaticSize = Enum.AutomaticSize.Y
            sectionContent.Parent = sectionFrame
            
            local sectionList = Instance.new("UIListLayout")
            sectionList.SortOrder = Enum.SortOrder.LayoutOrder
            sectionList.Padding = UDim.new(0, 8)
            sectionList.Parent = sectionContent
            
            local sectionPadding = Instance.new("UIPadding")
            sectionPadding.PaddingBottom = UDim.new(0, 10)
            sectionPadding.Parent = sectionContent
            
            section.frame = sectionFrame
            section.content = sectionContent
            table.insert(tab.sections, section)
            
            return section
        end
        
        return tab
    end
    
    return window
end

return UILibrary