local GuiService = game:GetService("GuiService")

local KeyService = {}

function KeyService:SendKey(key: Enum.KeyCode)
    local VIM = game:GetService("VirtualInputManager")
    
    VIM:SendKeyEvent(false, key, false, game)
    task.wait()
    VIM:SendKeyEvent(true, key, false, game)
end
function KeyService:ClickButton(btn: GuiButton)
    GuiService.SelectedObject = btn
    
    KeyService:SendKey(Enum.KeyCode.Return)
    KeyService:SendKey(Enum.KeyCode.Return)
    
    GuiService.SelectedObject = nil
end
function KeyService:ExitRobloxMenu(closingYield: number?)
    if GuiService.MenuIsOpen then
        KeyService:SendKey(Enum.KeyCode.Escape)
        
        if closingYield then
            task.wait(closingYield)
        end
    end
end
