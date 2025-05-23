print("[DebugMenuMod] Loading debug menu mod...")

local CONFIG = {
    ENABLE_CHAT_MESSAGES = true
}

local isDebugMenuOpen = false

local function ShowInGameChatMessage(message)
    if not CONFIG.ENABLE_CHAT_MESSAGES then return end

    local formattedMessage = "[DMM] " .. message

    print("[DebugMenuMod] " .. message)

    local pc = FindFirstOf("PlayerController")
    if not pc or not pc:IsValid() then return end

    pcall(function()
        local chatStruct = {}
        chatStruct.Time_8_DF6F279248745BE38C2E40835DE88631 = 0
        chatStruct.User_6_4A6B517E45F066403FD3C4B4AA7C0FA3 = "DebugMenuMod"
        chatStruct.Mesage_7_79981D7A424DFD8E6876D888E700B202 = formattedMessage
        chatStruct.IsInfoMessage_10_CD41743F409EA1DC4DD22CAC94591338 = true

        if pc.ServerSendChatMessage then
            pc:ServerSendChatMessage(chatStruct)
        end
    end)
end

local function ToggleDebugMenu()
    local debugMenuComponent = FindFirstOf("BP_DebugMenuComponent_C")
    if not debugMenuComponent then
        debugMenuComponent = FindFirstOf("DebugMenuComponent_C")
    end

    if not debugMenuComponent or not debugMenuComponent:IsValid() then
        print("[DebugMenuMod] Error: Could not find valid debug menu component")
        ShowInGameChatMessage("Error: Debug menu component not found")
        return false
    end

    isDebugMenuOpen = not isDebugMenuOpen

    if isDebugMenuOpen then
        local success = pcall(function()
            if debugMenuComponent["Open Menu"] then
                debugMenuComponent["Open Menu"]()
                print("[DebugMenuMod] Debug menu opened")
                ShowInGameChatMessage("Debug menu opened")
                return true
            elseif debugMenuComponent.OpenMenu then
                debugMenuComponent:OpenMenu()
                print("[DebugMenuMod] Debug menu opened (method call)")
                ShowInGameChatMessage("Debug menu opened")
                return true
            else
                error("No open menu function found")
            end
        end)
        
        if not success then
            print("[DebugMenuMod] Error: Could not open debug menu")
            ShowInGameChatMessage("Error: Could not open debug menu")
            isDebugMenuOpen = false
            return false
        end
    else
        local success = pcall(function()
            if debugMenuComponent["Close Menu"] then
                debugMenuComponent["Close Menu"]()
                print("[DebugMenuMod] Debug menu closed")
                ShowInGameChatMessage("Debug menu closed")
                return true
            elseif debugMenuComponent.CloseMenu then
                debugMenuComponent:CloseMenu()
                print("[DebugMenuMod] Debug menu closed (method call)")
                ShowInGameChatMessage("Debug menu closed")
                return true
            elseif debugMenuComponent["Toggle Menu"] then
                debugMenuComponent["Toggle Menu"]()
                print("[DebugMenuMod] Debug menu toggled (closed)")
                ShowInGameChatMessage("Debug menu closed")
                return true
            elseif debugMenuComponent.ToggleMenu then
                debugMenuComponent:ToggleMenu()
                print("[DebugMenuMod] Debug menu toggled (method call)")
                ShowInGameChatMessage("Debug menu closed")
                return true
            else
                local closeButton = FindFirstOf("DebugMenuCloseButton")
                if closeButton and closeButton:IsValid() and closeButton.OnClicked then
                    closeButton:OnClicked()
                    print("[DebugMenuMod] Debug menu closed via close button")
                    ShowInGameChatMessage("Debug menu closed")
                    return true
                else
                    error("No close menu function found")
                end
            end
        end)
        
        if not success then
            print("[DebugMenuMod] Error: Could not close debug menu")
            ShowInGameChatMessage("Error: Could not close debug menu")
            isDebugMenuOpen = true
            return false
        end
    end
    
    return true
end

RegisterKeyBind(Key.F4, function()
    print("[DebugMenuMod] F4 key detected. Toggling debug menu.")
    ToggleDebugMenu()
    return false
end) 