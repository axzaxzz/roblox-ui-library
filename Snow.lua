-- Snow v2: no :Stop on overlay; use a flag and Snow.stopAll()
local Snow = {}
Snow.instances = {}
Snow._running = false

function Snow.start(parent, darkerOverlay)
    Snow.stopAll()
    Snow._running = true

    local overlay = Instance.new("ScreenGui")
    overlay.Name = "SnowOverlay"
    overlay.IgnoreGuiInset = true

    local ok = pcall(function() overlay.Parent = game:GetService("CoreGui") end)
    if not ok then overlay.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    local dark = Instance.new("Frame")
    dark.Size = UDim2.new(1,0,1,0)
    dark.BackgroundColor3 = Color3.fromRGB(0,0,0)
    dark.BackgroundTransparency = darkerOverlay and 0.4 or 0.6
    dark.BorderSizePixel = 0
    dark.Parent = overlay

    table.insert(Snow.instances, overlay)

    task.spawn(function()
        while Snow._running and overlay.Parent do
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, math.random(2,5), 0, math.random(2,5))
            p.Position = UDim2.new(math.random(), 0, -0.05, 0)
            p.BackgroundColor3 = Color3.fromRGB(255,255,255)
            p.BackgroundTransparency = 0.15
            p.BorderSizePixel = 0
            p.Parent = overlay
            local c = Instance.new("UICorner", p)
            c.CornerRadius = UDim.new(1,0)

            local dur = math.random(6,10)
            local endX = p.Position.X.Scale + (math.random(-20,20)/100)
            local t0 = tick()
            while Snow._running and tick()-t0 < dur and p.Parent do
                local t = (tick()-t0)/dur
                p.Position = UDim2.new(endX, 0, t*1.1, 0)
                task.wait(0.016)
            end
            if p and p.Parent then p:Destroy() end
            task.wait(math.random(0,100)/500)
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