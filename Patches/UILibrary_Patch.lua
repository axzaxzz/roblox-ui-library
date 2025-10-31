-- Patch UILibrary CreateGradient to use ColorUtil.toColorSequence; tighten radii, remove floating, set height
local function fetch(path)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/"..path))()
end

local ColorUtil = fetch("ColorUtil.lua")
local Theme = fetch("MatchaTheme.lua")

local src = game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/UILibrary.lua")

-- Replace CreateGradient implementation safely
src = src:gsub(
    "function CreateGradient%(frame, colors, rotation%)%s*local gradient = Instance.new%\("UIGradient"%\)[%s%S]-return gradient%s*end",
    [[function CreateGradient(frame, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorUtil.toColorSequence(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = frame
    return gradient
end]]
)

-- Reduce corner radii to Matcha (6px)
src = src:gsub("CornerRadius = UDim.new%(%s*0%s*,%s*%d+%s*%))", "CornerRadius = UDim.new(0, "..Theme.Radius..")")

-- Remove floating animation (cartoony feel)
src = src:gsub("%-%- Floating effect[\n\r]+spawn%(%(function%)%)[%s%S]-end%)", "")

-- Make window taller per theme
src = src:gsub("Size = UDim2.new%(%s*0,%s*options.Size and options.Size.X or %d+,%s*0,%s*options.Size and options.Size.Y or %d+%s*%)",
               "Size = UDim2.new(0, options.Size and options.Size.X or "..Theme.Window.Width..", 0, options.Size and options.Size.Y or "..Theme.Window.Height..")")

return src