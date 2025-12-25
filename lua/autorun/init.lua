include("autorun/shared/sh_framework.lua")
AddCSLuaFile("autorun/shared/sh_framework.lua")

if SERVER then
    local files, dirs = file.Find("autorun/server/*.lua", "LUA")

    for _, f in ipairs(files) do
        include("autorun/server/" .. f)
    end

    local subdirs = { "db", "interfaces", "reports" }

    for _, dir in ipairs(subdirs) do
        local sfiles = file.Find("autorun/server/" .. dir .. "/*.lua", "LUA")
        for _, f in ipairs(sfiles) do
            include("autorun/server/" .. dir .. "/" .. f)
        end
    end

    local cfiles = file.Find("autorun/client/*.lua", "LUA")
    for _, f in ipairs(cfiles) do
        AddCSLuaFile("autorun/client/" .. f)
    end
end


if CLIENT then
    local function loadAddon()
        ReportMenu:print("Loading client interfaces")
        
        local files = file.Find("autorun/client/*.lua", "LUA")
        for _, f in ipairs(files) do
            include("autorun/client/" .. f)
        end

        ReportMenu:print("Loaded successfully!")
    end

    if PIXEL and PIXEL.UI then
        loadAddon()
    else
        hook.Add("PIXEL.UI.FullyLoaded", "ReportMenu.WaitForPIXELUI", function()
            loadAddon()
            hook.Remove("PIXEL.UI.FullyLoaded", "ReportMenu.WaitForPIXELUI")
        end)
    end
end
