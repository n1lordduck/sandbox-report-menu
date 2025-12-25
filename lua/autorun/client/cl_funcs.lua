-- @param reported_name string Nome do acusado
-- @param reported_sid  string SteamID 
-- @param reported_sid64 string SteamID64
-- @param reason        string Motivo do report
-- @param proof         string Prova (link ou texto)

function sendReport(reported_name, reported_sid, reported_sid64,reason, proof)
    net.Start("OpenReport")

    net.WriteString(reported_name or "")
    net.WriteString(reported_sid or "")
    net.WriteString(reported_sid64 or "")
    net.WriteString(reason or "")
    net.WriteString(proof or "")

    net.SendToServer()
end

concommand.Add("reportmenu_debug_examplereport", function()
    sendReport(
        "NoobPwner123",
        "STEAM_0:1:123456",
        "737372377812731231",
        "RDM",
        "https://placehold.co/"
    )
end)
