--[[
PIXEL.RegisterFont("Reports.Title", "Open Sans Bold", 24)
PIXEL.RegisterFont("Reports.Label", "Open Sans SemiBold", 20)
PIXEL.RegisterFont("Reports.Button", "Open Sans Bold", 22)
PIXEL.RegisterFont("Reports.PlayerName", "Open Sans SemiBold", 22)
PIXEL.RegisterFont("Reports.StepTitle", "Open Sans Bold", 20)

function SeeReports()
    local frame = vgui.Create("PIXEL.Frame")
    frame:SetSize(PIXEL.Scale(800), PIXEL.Scale(550))
    frame:SetTitle("Denúncias feitas")
    frame:Center()
    frame:MakePopup()
    
    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)
    scroll:DockMargin(PIXEL.Scale(15), PIXEL.Scale(15), PIXEL.Scale(15), PIXEL.Scale(70))
    
    local sbar = scroll:GetVBar()
    function sbar:Paint(w, h)
        PIXEL.DrawRoundedBox(PIXEL.Scale(4), 0, 0, w, h, PIXEL.OffsetColor(PIXEL.Colors.Background, 10))
    end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        PIXEL.DrawRoundedBox(PIXEL.Scale(4), 0, 0, w, h, PIXEL.Colors.Scroller)
    end
    
    local reports = {
        ReportMenu:FetchReports()
    }
    
    local slotCol = PIXEL.OffsetColor(PIXEL.Colors.Background, 10)
    
    for k, report in ipairs(reports) do
        local card = vgui.Create("Panel", scroll)
        card:Dock(TOP)
        card:DockMargin(0, 0, 0, PIXEL.Scale(10))
        card:SetTall(PIXEL.Scale(120))
        
        function card:Paint(w, h)
            PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, slotCol)
            
            local pad = PIXEL.Scale(15)
            PIXEL.DrawSimpleText("Denúncia #" .. report.id, "Reports.Title", pad, pad, PIXEL.Colors.PrimaryText)
            
            PIXEL.DrawSimpleText("Denunciante: " .. report.reporter, "Reports.Label", pad, pad + PIXEL.Scale(35), PIXEL.Colors.SecondaryText)
            PIXEL.DrawSimpleText("Denunciado: " .. report.reported, "Reports.Label", pad, pad + PIXEL.Scale(58), PIXEL.Colors.SecondaryText)
            PIXEL.DrawSimpleText("Horário: " .. report.time, "Reports.Label", pad, pad + PIXEL.Scale(81), PIXEL.Colors.SecondaryText)
            
            local rightX = w * 0.45
            PIXEL.DrawSimpleText("Motivo:", "Reports.Label", rightX, pad + PIXEL.Scale(35), PIXEL.Colors.SecondaryText)
            PIXEL.DrawSimpleText(report.reason, "Reports.Label", rightX, pad + PIXEL.Scale(58), PIXEL.Colors.PrimaryText)
            
            local statusCol = PIXEL.Colors.Gold
            if report.status == "Resolvido" then
                statusCol = PIXEL.Colors.Positive
            elseif report.status == "Rejeitado" then
                statusCol = PIXEL.Colors.Negative
            end
            PIXEL.DrawSimpleText("Status: " .. report.status, "Reports.Label", rightX, pad + PIXEL.Scale(81), statusCol)
        end
        
        local viewBtn = vgui.Create("PIXEL.TextButton", card)
        viewBtn:SetPos(PIXEL.Scale(580), PIXEL.Scale(35))
        viewBtn:SetSize(PIXEL.Scale(90), PIXEL.Scale(35))
        viewBtn:SetText("Ver")
        viewBtn:SetFont("Reports.Button")
        function viewBtn:DoClick()
            chat.AddText(Color(100, 200, 255), "[Reports] ", Color(255, 255, 255), "Visualizando denúncia #" .. report.id)
        end
        
        local handleBtn = vgui.Create("PIXEL.TextButton", card)
        handleBtn:SetPos(PIXEL.Scale(680), PIXEL.Scale(35))
        handleBtn:SetSize(PIXEL.Scale(90), PIXEL.Scale(35))
        handleBtn:SetText("Tratar")
        handleBtn:SetFont("Reports.Button")
        function handleBtn:DoClick()
            chat.AddText(Color(100, 255, 100), "[Reports] ", Color(255, 255, 255), "Tratando denúncia #" .. report.id)
        end
    end
    
    local refreshBtn = vgui.Create("PIXEL.TextButton", frame)
    refreshBtn:SetText("Atualizar")
    refreshBtn:SetFont("Reports.Button")
    refreshBtn:SetSize(PIXEL.Scale(150), PIXEL.Scale(40))
    timer.Simple(0, function()
        if IsValid(refreshBtn) and IsValid(frame) then
            local frameW, frameH = frame:GetSize()
            refreshBtn:SetPos(PIXEL.Scale(15), frameH - PIXEL.Scale(55))
        end
    end)
    function refreshBtn:DoClick()
        chat.AddText(Color(100, 200, 255), "[Reports] ", Color(255, 255, 255), "Atualizando denúncias...")
    end
end

--]]
