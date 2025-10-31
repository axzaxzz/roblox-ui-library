-- Explorer: functional object browser (Workspace tree, select to print path)
local Explorer = {}
Explorer.guiInstances = {}

local function addGuiRef(g)
    table.insert(Explorer.guiInstances, g)
end

function Explorer.closeAll()
    for _, g in ipairs(Explorer.guiInstances) do
        if g and g.Parent then g:Destroy() end
    end
    Explorer.guiInstances = {}
end

local function pathOf(inst)
    local parts = {}
    while inst and inst ~= game do
        table.insert(parts, 1, inst.Name)
        inst = inst.Parent
    end
    return "/"..table.concat(parts, "/")
end

local function buildTree(parentFrame, root, theme)
    local function addNode(container, obj, depth)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 20)
        row.BackgroundColor3 = theme.Panel
        row.BorderSizePixel = 0
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.TextColor3 = theme.Text
        row.TextSize = 11
        row.Font = Enum.Font.Gotham
        row.Text = string.rep("  ", depth) .. obj.ClassName .. "  " .. obj.Name
        row.Parent = container
        local pad = Instance.new("UIPadding", row)
        pad.PaddingLeft = UDim.new(0, 8)

        row.MouseButton1Click:Connect(function()
            print("Explorer selected:", pathOf(obj))
        end)

        for _, child in ipairs(obj:GetChildren()) do
            addNode(container, child, depth + 1)
        end
    end

    addNode(parentFrame, root, 0)
end

function Explorer.show(theme)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ExplorerUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = (game:GetService("CoreGui"))
    addGuiRef(gui)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 520)
    frame.Position = UDim2.new(0.5, -210, 0.5, -260)
    frame.BackgroundColor3 = theme.Background
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Color = theme.Stroke

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = theme.Panel
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -36, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Explorer"
    title.TextColor3 = theme.Text
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -28, 0, 4)
    closeBtn.BackgroundColor3 = theme.Panel
    closeBtn.Text = "X"
    closeBtn.TextColor3 = theme.Text
    closeBtn.TextSize = 10
    closeBtn.Font = Enum.Font.GothamBold
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
    layout.Padding = UDim.new(0, 2)

    -- Build Workspace tree
    buildTree(content, workspace, theme)
end

return Explorer