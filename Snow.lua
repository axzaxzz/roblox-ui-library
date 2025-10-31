-- Snow: smooth circular particles; easy toggle & cleanup
local Snow = {}
Snow.instances = {}

function Snow.start(parent, darkerOverlay)
    local overlay = Instance.new("Frame")
    overlay.Name = "SnowOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = darkerOverlay and 0.4 or 0.6
    overlay.BorderSizePixel = 0
    overlay.Parent = parent
    table.insert(Snow.instances, overlay)

    local run = true

    task.spawn(function()
        while run and overlay.Parent do
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, math.random(2,5), 0, math.random(2,5))
            p.Position = UDim2.new(math.random(), 0, -0.05, 0)
            p.BackgroundColor3 = Color3.fromRGB(255,255,255)
            p.BackgroundTransparency = 0.2
            p.BorderSizePixel = 0
            p.Parent = overlay
            local c = Instance.new("UICorner", p)
            c.CornerRadius = UDim.new(1,0) -- perfect circle

            local dur = math.random(6,10)
            local endX = p.Position.X.Scale + (math.random(-20,20)/100)

            local start = tick()
            while tick()-start < dur and p.Parent do
                local t = (tick()-start)/dur
                p.Position = UDim2.new(endX, 0, t*1.1, 0)
                task.wait(0.016)
            end
            if p and p.Parent then p:Destroy() end
            task.wait(math.random(0,100)/500) -- more snow
        end
    end)

    function overlay:Stop()
        run = false
        overlay:Destroy()
    end

    return overlay
end

function Snow.stopAll()
    for _, inst in ipairs(Snow.instances) do
        if inst and inst.Parent then inst:Destroy() end
    end
    Snow.instances = {}
end

return Snow