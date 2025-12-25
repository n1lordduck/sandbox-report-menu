include("autorun/server/sv_framework.lua")

local netMessages = {
    "ClaimCase", --// Staff se responsabeliza por um report
    "CloseCase", --// Staff fecha um report, providencia motivo
    "OpenReport", --// Usuário envia um report, providencia Table com STEAMID do denunciado e do denunciante, motivos e provas (string)
}

for _, netMessage in ipairs(netMessages) do
    util.AddNetworkString(netMessage)
end

net.Receive("OpenReport", function(len, ply)
    if not IsValid(ply) then return end

    ReportMenu:print("Received report from: "..ply:Nick())

    local reported_name = net.ReadString()
    local reported_sid  = net.ReadString()
    local reason        = net.ReadString()
    local proof         = net.ReadString()

    local info = {
        reported_name = reported_name,
        reported_sid  = reported_sid,
        reporter_sid  = ply:SteamID64(),
        reason        = reason,
        proof         = proof,
        created_at    = os.time(),
        status        = "open"
    }

    local reportObj = createReport(info)
    insertReportDB(reportObj)
end)

net.Receive("ClaimReport", function(len, ply)
    local staff = ply:Nick()
    local staffId64 = ply:SteamID64()


end)