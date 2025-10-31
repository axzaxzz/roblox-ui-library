-- KeybindManager: centralized storage + UI creation for setting keybinds
local KeybindManager = {}
local UserInputService = game:GetService("UserInputService")

KeybindManager.binds = {} -- [action] = {key="F", callback=function, description="..."}
KeybindManager.guiInstances = {} -- to close on self-destruct

function KeybindManager.register(action, key, description, callback)
    KeybindManager.binds[action] = {key = key, description = description or action, callback = callback}
end

function KeybindManager.unregister(action)
    KeybindManager.binds[action] = nil
end

function KeybindManager.get()
    return KeybindManager.binds
end

-- Runtime listener
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    local name = input.KeyCode.Name
    for _, data in pairs(KeybindManager.binds) do
        if data.key == name and data.callback then
            data.callback()
        end
    end
end)

function KeybindManager.showList(theme)
    -- Create a sharp, compact keybind list UI
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeybindListUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = (game:GetService("CoreGui"))

    table.insert(KeybindManager.guiInstances, gui)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 360, 0, 420)
    frame.Position = UDim2.new(0.5, -180, 0.5, -210)
    frame.BackgroundColor3 = theme.Background
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = theme.Stroke
    stroke.Thickness = 1

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = theme.Panel
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Keybinds"
    title.TextColor3 = theme.Text
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(0, 60, 0, 20)
    addBtn.Position = UDim2.new(1, -140, 0, 6)
    addBtn.BackgroundColor3 = theme.Panel
    addBtn.Text = "Add"
    addBtn.TextColor3 = theme.Text
    addBtn.TextSize = 11
    addBtn.Font = Enum.Font.Gotham
    addBtn.BorderSizePixel = 0
    addBtn.Parent = titleBar
    Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 4)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 60, 0, 20)
    closeBtn.Position = UDim2.new(1, -70, 0, 6)
    closeBtn.BackgroundColor3 = theme.Panel
    closeBtn.Text = "Close"
    closeBtn.TextColor3 = theme.Text
    closeBtn.TextSize = 11
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -12, 1, -44)
    content.Position = UDim2.new(0, 6, 0, 38)
    content.BackgroundColor3 = theme.Panel
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = theme.Accent
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = frame
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 4)

    local function addItem(action, key, description)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundColor3 = theme.Panel
        row.BorderSizePixel = 0
        row.Parent = content
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

        local actionLabel = Instance.new("TextLabel")
        actionLabel.Size = UDim2.new(0.5, -8, 1, 0)
        actionLabel.Position = UDim2.new(0, 8, 0, 0)
        actionLabel.BackgroundTransparency = 1
        actionLabel.Text = description or action
        actionLabel.TextColor3 = theme.Text
        actionLabel.TextSize = 12
        actionLabel.Font = Enum.Font.Gotham
        actionLabel.TextXAlignment = Enum.TextXAlignment.Left
        actionLabel.Parent = row

        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0, 64, 0, 18)
        keyBtn.Position = UDim2.new(0.6, 0, 0.5, -9)
        keyBtn.BackgroundColor3 = theme.Panel
        keyBtn.Text = key or "None"
        keyBtn.TextColor3 = theme.Text
        keyBtn.TextSize = 11
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.BorderSizePixel = 0
        keyBtn.Parent = row
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 4)

        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(0, 60, 0, 18)
        removeBtn.Position = UDim2.new(1, -68, 0.5, -9)
        removeBtn.BackgroundColor3 = theme.Panel
        removeBtn.Text = "Remove"
        removeBtn.TextColor3 = theme.Text
        removeBtn.TextSize = 11
        removeBtn.Font = Enum.Font.Gotham
        removeBtn.BorderSizePixel = 0
        removeBtn.Parent = row
        Instance.new("UICorner", removeBtn).CornerRadius = UDim.new(0, 4)

        keyBtn.MouseButton1Click:Connect(function()
            keyBtn.Text = "..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input, processed)
                if processed then return end
                local name = input.KeyCode.Name
                if name ~= "Unknown" then
                    KeybindManager.binds[action] = {key = name, description = description, callback = (KeybindManager.binds[action] and KeybindManager.binds[action].callback)}
                    keyBtn.Text = name
                    conn:Disconnect()
                end
            end)
        end)

        removeBtn.MouseButton1Click:Connect(function()
            KeybindManager.unregister(action)
            row:Destroy()
        end)
    end

    for action, data in pairs(KeybindManager.binds) do
        addItem(action, data.key, data.description)
    end

    addBtn.MouseButton1Click:Connect(function()
        local action = "Action_"..tostring(math.random(1000,9999))
        KeybindManager.register(action, "None", action, function() end)
        addItem(action, "None", action)
    end)

    return gui
end

function KeybindManager.closeAll()
    for _, g in ipairs(KeybindManager.guiInstances) do
        if g and g.Parent then g:Destroy() end
    end
    KeybindManager.guiInstances = {}
end

return KeybindManager