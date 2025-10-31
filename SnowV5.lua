-- SnowV5: higher spawn rate and concurrency
local Snow = {}
Snow.instances = {}
Snow._running = false

local function overlay(darker)
    local sg = Instance.new("ScreenGui")
    sg.Name = "SnowOverlay"
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not ok then sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end
    local dim = Instance.new("Frame")
    dim.Size = UDim2.new(1,0,1,0)
    dim.BackgroundColor3 = Color3.fromRGB(8,8,9)
    dim.BackgroundTransparency = darker and 0.2 or 0.35
    dim.BorderSizePixel = 0
    dim.Parent = sg
    return sg
end

local function spawnFlake(root)
    local s = math.random(3,6)
    local startX = math.random(2,98)/100
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, s, 0, s)
    p.Position = UDim2.new(startX, 0, -0.08, 0)
    p.BackgroundColor3 = Color3.fromRGB(245,245,255)
    p.BackgroundTransparency = 0.15
    p.BorderSizePixel = 0
    p.Parent = root
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)

    local dur = math.random(6,10)
    local drift = (math.random(-7,7)/120)
    local t0 = tick()
    task.spawn(function()
        while Snow._running and tick()-t0 < dur and p.Parent do
            local progress = (tick()-t0)/dur
            local y = -0.08 + progress*1.15
            local x = startX + drift*progress
            p.Position = UDim2.new(x, 0, y, 0)
            task.wait(0.016)
        end
        if p and p.Parent then p:Destroy() end
    end)
end

function Snow.start(_, darker)
    Snow.stopAll()
    Snow._running = true
    local root = overlay(darker)
    table.insert(Snow.instances, root)

    -- main spawner: higher density
    task.spawn(function()
        while Snow._running and root.Parent do
            -- burst: 3-5 flakes at a time
            local burst = math.random(3,5)
            for i=1,burst do
                spawnFlake(root)
            end
            task.wait(0.05) -- very frequent bursts
        end
    end)

    return root
end

function Snow.stopAll()
    Snow._running = false
    for _, inst in ipairs(Snow.instances) do
        if inst and inst.Parent then inst:Destroy() end
    end
    Snow.instances = {}
end

return Snow