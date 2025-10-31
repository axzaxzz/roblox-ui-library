-- Apply patch to live UILibrary
local patch = loadstring(game:HttpGet("https://raw.githubusercontent.com/axzaxzz/roblox-ui-library/main/Patches/UILibrary_Patch.lua"))()

-- Compile the patched source into a module table
local function loadPatched()
    local libFactory = loadstring(patch)
    return libFactory()
end

-- Return the patched library table directly (not a function)
return loadPatched()