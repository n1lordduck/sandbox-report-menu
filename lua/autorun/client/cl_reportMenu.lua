include("autorun/client/cl_funcs.lua")

ReportMenu.Data = {
    selectedPlayer = nil,
    currentStep = 1,
    fontsRegistered = false
}

local function RegisterFonts()
    if ReportMenu.Data.fontsRegistered then return end
    
    surface.CreateFont("Reports.Title", {
        font = "Open Sans Bold",
        size = PIXEL.Scale(24),
        weight = 700
    })
    
    surface.CreateFont("Reports.Label", {
        font = "Open Sans SemiBold",
        size = PIXEL.Scale(20),
        weight = 600
    })
    
    surface.CreateFont("Reports.Button", {
        font = "Open Sans Bold",
        size = PIXEL.Scale(22),
        weight = 700
    })
    
    surface.CreateFont("Reports.PlayerName", {
        font = "Open Sans SemiBold",
        size = PIXEL.Scale(22),
        weight = 600
    })
    
    surface.CreateFont("Reports.StepTitle", {
        font = "Open Sans Bold",
        size = PIXEL.Scale(20),
        weight = 700
    })
    
    ReportMenu.Data.fontsRegistered = true
end

hook.Add("InitPostEntity", "ReportMenu.RegisterFonts", function()
    RegisterFonts()
    hook.Remove("InitPostEntity", "ReportMenu.RegisterFonts")
end)

RegisterFonts()

ReportMenu.Steps = {}

function ReportMenu.Steps.BuildStep1(contentPanel, frame)
    local stepTitle = vgui.Create("Panel", contentPanel)
    stepTitle:Dock(TOP)
    stepTitle:SetTall(PIXEL.Scale(40))
    stepTitle:DockMargin(0, 0, 0, PIXEL.Scale(10))
    
    function stepTitle:Paint(w, h)
        PIXEL.DrawSimpleText("Passo 1: Selecione o jogador", "Reports.StepTitle", 0, h / 2, PIXEL.Colors.PrimaryText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local scroll = vgui.Create("DScrollPanel", contentPanel)
    scroll:Dock(FILL)
    scroll:DockMargin(0, 0, 0, PIXEL.Scale(10))
    
    local sbar = scroll:GetVBar()
    function sbar:Paint(w, h)
        PIXEL.DrawRoundedBox(PIXEL.Scale(4), 0, 0, w, h, PIXEL.OffsetColor(PIXEL.Colors.Background, 10))
    end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        PIXEL.DrawRoundedBox(PIXEL.Scale(4), 0, 0, w, h, PIXEL.Colors.Scroller)
    end
    
    local players = player.GetAll()
    
    for k, ply in ipairs(players) do
        local playerCard = vgui.Create("Panel", scroll)
        playerCard:Dock(TOP)
        playerCard:DockMargin(0, 0, 0, PIXEL.Scale(8))
        playerCard:SetTall(PIXEL.Scale(70))
        playerCard:SetCursor("hand")
        
        local isHovered = false
        local isSelected = ReportMenu.Data.selectedPlayer == ply
        
        function playerCard:Paint(w, h)
            isSelected = ReportMenu.Data.selectedPlayer == ply
            local col = PIXEL.OffsetColor(PIXEL.Colors.Background, 10)
            if isSelected then
                col = PIXEL.OffsetColor(PIXEL.Colors.Primary, -20)
            elseif isHovered then
                col = PIXEL.OffsetColor(PIXEL.Colors.Background, 15)
            end
            
            PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, col)
            
            local avatarSize = PIXEL.Scale(50)
            local avatarX = PIXEL.Scale(10)
            local avatarY = (h - avatarSize) / 2
            PIXEL.DrawRoundedBox(PIXEL.Scale(4), avatarX, avatarY, avatarSize, avatarSize, PIXEL.OffsetColor(PIXEL.Colors.Background, 5))
            
            local nameX = avatarX + avatarSize + PIXEL.Scale(15)
            local nameY = h / 2
            PIXEL.DrawSimpleText(ply:GetName(), "Reports.PlayerName", nameX, nameY, PIXEL.Colors.PrimaryText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        function playerCard:OnCursorEntered()
            isHovered = true
        end
        
        function playerCard:OnCursorExited()
            isHovered = false
        end
        
        function playerCard:OnMousePressed()
            ReportMenu.Data.selectedPlayer = ply
        end
        
        local avatar = vgui.Create("AvatarImage", playerCard)
        avatar:SetSize(PIXEL.Scale(50), PIXEL.Scale(50))
        avatar:SetPos(PIXEL.Scale(10), PIXEL.Scale(10))
        if not ply:IsBot() then
            avatar:SetPlayer(ply, 64)
        else
            avatar:SetVisible(false)
        end
    end
    
    local buttonPanel = vgui.Create("Panel", contentPanel)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(PIXEL.Scale(50))
    
    local nextBtn = vgui.Create("PIXEL.TextButton", buttonPanel)
    nextBtn:SetText("Próximo →")
    nextBtn:SetFont("Reports.Button")
    nextBtn:SetSize(PIXEL.Scale(150), PIXEL.Scale(40))
    nextBtn:SetPos(PIXEL.Scale(530), PIXEL.Scale(5))
    
    function nextBtn:DoClick()
        if ReportMenu.Data.selectedPlayer then
            ReportMenu.Data.currentStep = 2
            contentPanel:Clear()
            ReportMenu.Steps.BuildStep2(contentPanel, frame)
        else
            chat.AddText(Color(255, 100, 100), "[Reports] ", Color(255, 255, 255), "Selecione um jogador primeiro!")
        end
    end
end

function ReportMenu.Steps.BuildStep2(contentPanel, frame)
    local stepTitle = vgui.Create("Panel", contentPanel)
    stepTitle:Dock(TOP)
    stepTitle:SetTall(PIXEL.Scale(40))
    stepTitle:DockMargin(0, 0, 0, PIXEL.Scale(10))
    
    function stepTitle:Paint(w, h)
        PIXEL.DrawSimpleText("Passo 2: Motivo e provas", "Reports.StepTitle", 0, h / 2, PIXEL.Colors.PrimaryText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local selectedInfo = vgui.Create("Panel", contentPanel)
    selectedInfo:Dock(TOP)
    selectedInfo:SetTall(PIXEL.Scale(80))
    selectedInfo:DockMargin(0, 0, 0, PIXEL.Scale(15))
    
    function selectedInfo:Paint(w, h)
        if not IsValid(ReportMenu.Data.selectedPlayer) then return end
        
        PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, PIXEL.OffsetColor(PIXEL.Colors.Background, 10))
        
        local avatarSize = PIXEL.Scale(60)
        local avatarX = PIXEL.Scale(10)
        local avatarY = (h - avatarSize) / 2
        PIXEL.DrawRoundedBox(PIXEL.Scale(4), avatarX, avatarY, avatarSize, avatarSize, PIXEL.OffsetColor(PIXEL.Colors.Background, 5))
        
        local nameX = avatarX + avatarSize + PIXEL.Scale(15)
        PIXEL.DrawSimpleText("Denunciando:", "Reports.Label", nameX, PIXEL.Scale(20), PIXEL.Colors.SecondaryText, TEXT_ALIGN_LEFT)
        PIXEL.DrawSimpleText(ReportMenu.Data.selectedPlayer:GetName(), "Reports.PlayerName", nameX, PIXEL.Scale(45), PIXEL.Colors.PrimaryText, TEXT_ALIGN_LEFT)
    end
    
    if IsValid(ReportMenu.Data.selectedPlayer) then
        local avatar = vgui.Create("AvatarImage", selectedInfo)
        avatar:SetSize(PIXEL.Scale(60), PIXEL.Scale(60))
        avatar:SetPos(PIXEL.Scale(10), PIXEL.Scale(10))
        if not ReportMenu.Data.selectedPlayer:IsBot() then
            avatar:SetPlayer(ReportMenu.Data.selectedPlayer, 64)
        else
            avatar:SetVisible(false)
        end
    end
    
    local reasonLabel = vgui.Create("Panel", contentPanel)
    reasonLabel:Dock(TOP)
    reasonLabel:SetTall(PIXEL.Scale(30))
    reasonLabel:DockMargin(0, 0, 0, PIXEL.Scale(5))
    
    function reasonLabel:Paint(w, h)
        PIXEL.DrawSimpleText("Motivo da denúncia:", "Reports.Label", 0, h / 2, PIXEL.Colors.PrimaryText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local reasonBox = vgui.Create("DTextEntry", contentPanel)
    reasonBox:Dock(TOP)
    reasonBox:SetTall(PIXEL.Scale(120))
    reasonBox:DockMargin(0, 0, 0, PIXEL.Scale(20))
    reasonBox:SetMultiline(true)
    reasonBox:SetFont("Reports.Label")
    reasonBox:SetPlaceholderText("Descreva o motivo da denúncia...")
    
    function reasonBox:Paint(w, h)
        PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, PIXEL.OffsetColor(PIXEL.Colors.Background, 10))
        self:DrawTextEntryText(PIXEL.Colors.PrimaryText, PIXEL.Colors.Primary, PIXEL.Colors.PrimaryText)
    end
    
    local proofsLabel = vgui.Create("Panel", contentPanel)
    proofsLabel:Dock(TOP)
    proofsLabel:SetTall(PIXEL.Scale(30))
    proofsLabel:DockMargin(0, 0, 0, PIXEL.Scale(5))
    
    function proofsLabel:Paint(w, h)
        PIXEL.DrawSimpleText("Provas (opcional):", "Reports.Label", 0, h / 2, PIXEL.Colors.PrimaryText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    local proofsBox = vgui.Create("DTextEntry", contentPanel)
    proofsBox:Dock(TOP)
    proofsBox:SetTall(PIXEL.Scale(80))
    proofsBox:DockMargin(0, 0, 0, PIXEL.Scale(20))
    proofsBox:SetMultiline(true)
    proofsBox:SetFont("Reports.Label")
    proofsBox:SetPlaceholderText("Links de imagens, vídeos, etc...")
    
    function proofsBox:Paint(w, h)
        PIXEL.DrawRoundedBox(PIXEL.Scale(6), 0, 0, w, h, PIXEL.OffsetColor(PIXEL.Colors.Background, 10))
        self:DrawTextEntryText(PIXEL.Colors.PrimaryText, PIXEL.Colors.Primary, PIXEL.Colors.PrimaryText)
    end
    
    local buttonPanel = vgui.Create("Panel", contentPanel)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(PIXEL.Scale(50))
    
    local backBtn = vgui.Create("PIXEL.TextButton", buttonPanel)
    backBtn:SetText("← Voltar")
    backBtn:SetFont("Reports.Button")
    backBtn:SetSize(PIXEL.Scale(120), PIXEL.Scale(40))
    backBtn:SetPos(0, PIXEL.Scale(5))
    
    function backBtn:DoClick()
        ReportMenu.Data.currentStep = 1
        contentPanel:Clear()
        ReportMenu.Steps.BuildStep1(contentPanel, frame)
    end
    
    local submitBtn = vgui.Create("PIXEL.TextButton", buttonPanel)
    submitBtn:SetText("Enviar denúncia")
    submitBtn:SetFont("Reports.Button")
    submitBtn:SetSize(PIXEL.Scale(180), PIXEL.Scale(40))
    submitBtn:SetPos(PIXEL.Scale(500), PIXEL.Scale(5))
    
    function submitBtn:DoClick()
        if not IsValid(ReportMenu.Data.selectedPlayer) then return end

        local reason = reasonBox:GetValue()
        local proof  = proofsBox:GetValue()

        if reason == "" then
            chat.AddText(Color(255, 100, 100), "[Reports] ", color_white,
                "Preencha o motivo da denúncia!")
            return
        end

        local ply = ReportMenu.Data.selectedPlayer

        sendReport(
            ply:Nick(),
            ply:SteamID(),
            ply:SteamID64(),
            reason,
            proof
        )

        chat.AddText(Color(100, 255, 100), "[Reports] ", color_white,
            "Denúncia enviada com sucesso!")

        ReportMenu.Data.currentStep = 1
        ReportMenu.Data.selectedPlayer = nil
        frame:Close()
    end

end

function ReportMenu.Open()
    RegisterFonts()
    
    local frame = vgui.Create("PIXEL.Frame")
    frame:SetSize(PIXEL.Scale(730), PIXEL.Scale(550))
    frame:SetTitle("Fazer uma denúncia")
    frame:Center()
    frame:MakePopup()
    
    local contentPanel = vgui.Create("Panel", frame)
    contentPanel:Dock(FILL)
    contentPanel:DockMargin(PIXEL.Scale(15), PIXEL.Scale(15), PIXEL.Scale(15), PIXEL.Scale(15))
    
    if ReportMenu.Data.currentStep == 1 then
        ReportMenu.Steps.BuildStep1(contentPanel, frame)
    elseif ReportMenu.Data.currentStep == 2 then
        ReportMenu.Steps.BuildStep2(contentPanel, frame)
    end
end

concommand.Add("report_menu", ReportMenu.Open)