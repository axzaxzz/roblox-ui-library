-- Snow v3: cleaner overlay styling, blur option, guaranteed ScreenGui, exported controls
local Snow = {}
Snow.instances = {}
Snow._running = false

local function newOverlay(darker)
    local sg = Instance.new("ScreenGui")
    sg.Name = "SnowOverlay"
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- try CoreGui then fallback
    local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not ok then sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- subtle dim layer
    local dim = Instance.new("Frame")
    dim.Name = "Dim"
    dim.Size = UDim2.new(1,0,1,0)
    dim.BackgroundColor3 = Color3.fromRGB(8,8,9)
    dim.BackgroundTransparency = darker and 0.2 or 0.35
    dim.BorderSizePixel = 0
    dim.Parent = sg

    -- light blur (Roblox UI blur substitute)
    local effect = Instance.new("Frame")
    effect.Name = "Vignette"
    effect.Size = UDim2.new(1,0,1,0)
    effect.BackgroundTransparency = 1
    effect.Parent = sg

    return sg
end

function Snow.start(parentIgnored, darker)
    Snow.stopAll()
    Snow._running = true

    local overlay = newOverlay(darker)
    table.insert(Snow.instances, overlay)

    task.spawn(function()
        while Snow._running and overlay.Parent do
            local s = math.random(2,4)
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, s, 0, s)
            p.Position = UDim2.new(math.random(), 0, -0.05, 0)
            p.BackgroundColor3 = Color3.fromRGB(245,245,255)
            p.BackgroundTransparency = 0.1
            p.BorderSizePixel = 0
            p.Parent = overlay
            Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)

            local dur = math.random(7,10)
            local drift = (math.random(-15,15)/100)
            local t0 = tick()
            while Snow._running and tick()-t0 < dur and p.Parent do
                local t = (tick()-t0)/dur
                p.Position = UDim2.new(p.Position.X.Scale + drift/ dur, 0, t*1.05, 0)
                task.wait(0.016)
            end
            if p and p.Parent then p:Destroy() end
            task.wait(0.01) -- denser
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