-- DebugMenuMod for Drive Beyond Horizons

print("[DebugMenuMod] Loading debug menu mod...")

-- Track if the debug menu is open
local isDebugMenuOpen = false

-- toggle the debug menu
local function ToggleDebugMenu()
    -- Try to find debug menu component
    local debugMenuComponent = FindFirstOf("BP_DebugMenuComponent_C")
    if not debugMenuComponent then
        -- Try alternative class name
        debugMenuComponent = FindFirstOf("DebugMenuComponent_C")
    end

    if not debugMenuComponent then
        print("Error: Could not find debug menu component")
        return false
    end

    -- Toggle the menu state
    isDebugMenuOpen = not isDebugMenuOpen

    if isDebugMenuOpen then
        -- Open the menu
        if debugMenuComponent["Open Menu"] then
            debugMenuComponent["Open Menu"]()
            print("Debug menu opened")
            return true
        else
            print("Error: Could not find Open Menu function")
            isDebugMenuOpen = false  -- Reset state since we couldn't open it
            return false
        end
    else
        -- Close the menu
        if debugMenuComponent["Close Menu"] then
            debugMenuComponent["Close Menu"]()
            print("Debug menu closed")
            return true
        elseif debugMenuComponent["Toggle Menu"] then
            debugMenuComponent["Toggle Menu"]()
            print("Debug menu toggled (closed)")
            return true
        else
            -- Try to find a close button in the UI
            local closeButton = FindFirstOf("DebugMenuCloseButton")
            if closeButton and closeButton.OnClicked then
                closeButton.OnClicked()
                print("Debug menu closed via close button")
                return true
            else
                print("Error: Could not find a way to close the debug menu")
                isDebugMenuOpen = true  -- Reset state since we couldn't close it
                return false
            end
        end
    end
end

-- Register the toggle key to open/close the debug menu
RegisterKeyBind(Key.F4, function()
    print("F4 key detected. Toggling debug menu.")
    ToggleDebugMenu()
    return false
end)