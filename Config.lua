-- Config system (in-memory) with save/load to syn/fluxus filesystem when available
local Config = {}
local HttpService = game:GetService("HttpService")

local function writefile_safe(path, data)
    if writefile then
        writefile(path, data)
        return true
    end
    return false
end

local function readfile_safe(path)
    if readfile then
        return readfile(path)
    end
    return nil
end

local DEFAULT_DIR = "matcha_ui/configs/"

function Config.save(name, tbl)
    local ok, json = pcall(function() return HttpService:JSONEncode(tbl) end)
    if not ok then return false, "encode_fail" end
    if not writefile_safe(DEFAULT_DIR..name..".json", json) then
        return true, "memory_only" -- silently succeed in memory-only envs
    end
    return true
end

function Config.load(name)
    local raw = readfile_safe(DEFAULT_DIR..name..".json")
    if not raw then return nil, "nofile" end
    local ok, tbl = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok then return nil, "decode_fail" end
    return tbl
end

return Config