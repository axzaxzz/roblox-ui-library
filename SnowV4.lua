-- SnowV4.lua: perfect circles, vertical fall, edge cleanup, 60fps spawn
local Snow = {}
Snow.instances = {}
Snow._running = false

local function newOverlay(darker)
    local sg = Instance.new("ScreenGui")
    sg.Name = "SnowOverlay"
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not ok then sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    local dim = Instance.new("Frame")
    dim.Name = "Dim"
    dim.Size = UDim2.new(1,0,1,0)
    dim.BackgroundColor3 = Color3.fromRGB(8,8,9)
    dim.BackgroundTransparency = darker and 0.2 or 0.35
    dim.BorderSizePixel = 0
    dim.Parent = sg

    return sg
end

function Snow.start(_, darker)
    Snow.stopAll()
    Snow._running = true

    local overlay = newOverlay(darker)
    table.insert(Snow.instances, overlay)

    task.spawn(function()
        while Snow._running and overlay.Parent do
            local s = math.random(3,6)
            local startX = math.random(2,98)/100
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, s, 0, s)
            p.Position = UDim2.new(startX, 0, -0.08, 0)
            p.BackgroundColor3 = Color3.fromRGB(245,245,255)
            p.BackgroundTransparency = 0.15
            p.BorderSizePixel = 0
            p.Parent = overlay
            local c = Instance.new("UICorner", p)
            c.CornerRadius = UDim.new(1,0)
            local dur = math.random(6,10)
            local drift = (math.random(-7,7)/120)
            local t0 = tick()
            while Snow._running and tick()-t0 < dur and p.Parent do
                local progress = (tick()-t0)/dur
                local y = -0.08 + progress*1.15
                local x = startX + drift*progress
                p.Position = UDim2.new(x, 0, y, 0)
                task.wait(0.016)
            end
            if p and p.Parent then p:Destroy() end
            task.wait(0.008)
        end
    end)

    return overlay
end

function Snow.stopAll()
    Snow._running = false
    for _, inst in ipairs(Snow.instances) do
        if inst and inst.Parent then inst:Destroy() end
    end
    Snow.instances = {}
end

return Snow
