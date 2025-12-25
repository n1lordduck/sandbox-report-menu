---@class ReportMenu
---@field Version string
---@field sqlTable string
---@field archivedTable string
ReportMenu = ReportMenu or {}
ReportMenu.Version = "[ReportsMenu - 1.0.0]"
ReportMenu.sqlTable = "reports"
ReportMenu.archivedTable = "archivedreports"

ReportMenu.Colors = {
    ["Server"] = Color(97, 143, 189),
    ["Client"] = Color(55, 97, 138),
    ["Version"] = Color(255, 0, 0)
}

---@param arg any
---@return nil
function ReportMenu:print(arg)
    local msg = ""
    
    if IsValid(arg) and arg:IsPlayer() then
        msg = msg .. " [PLAYER] " .. arg:Nick()
    elseif IsValid(arg) then
        msg = msg .. " [ENTITY] " .. arg:GetClass()
    elseif isstring(arg) then
        msg = msg .. " " .. arg
    end
    
    if SERVER then
        MsgC(
            ReportMenu.Colors["Version"], self.Version,
            ReportMenu.Colors["Server"], " [SERVER]",
            color_white, msg, "\n"
        )
    end
    
    if CLIENT then
        MsgC(
            ReportMenu.Colors["Version"], self.Version,
            ReportMenu.Colors["Client"], " [CLIENT]",
            color_white, msg, "\n"
        )
    end
end

hook.Add("InitPostEntity", "ReportMenu.Framework.LOADED", function()
    hook.Run("ReportMenu.Framework.READY")
end)
