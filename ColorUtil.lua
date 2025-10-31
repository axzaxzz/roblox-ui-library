-- Utility: safe ColorSequence from either array of Color3 or ColorSequenceKeypoint
local function toColorSequence(input)
    if typeof(input) == "ColorSequence" then return input end
    if typeof(input) == "table" then
        -- if it's an array of Color3s, convert to keypoints 0..1
        local keypoints = {}
        local n = #input
        if n > 0 and typeof(input[1]) == "Color3" then
            for i,c in ipairs(input) do
                local t = (i-1)/math.max(n-1,1)
                table.insert(keypoints, ColorSequenceKeypoint.new(t, c))
            end
            return ColorSequence.new(keypoints)
        elseif n > 0 and typeof(input[1]) == "ColorSequenceKeypoint" then
            return ColorSequence.new(input)
        end
    end
    -- fallback single color (neutral)
    return ColorSequence.new(Color3.fromRGB(28,28,32))
end

return {toColorSequence = toColorSequence}