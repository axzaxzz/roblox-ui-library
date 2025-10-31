-- Apply patch to live UILibrary
local src = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Patches/UILibrary_Patch.lua"))()

-- Write back not possible at runtime; return a patched module loader instead
local function requirePatched()
    local f = loadstring(src)
    return f()
end

return requirePatched