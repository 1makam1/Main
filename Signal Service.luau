local GuiService = game:GetService("GuiService")

local SignalService = {}

function SignalService:SendKey(key: Enum.KeyCode)
    local VIM = game:GetService("VirtualInputManager")
    
    VIM:SendKeyEvent(false, key, false, game)
    task.wait()
    VIM:SendKeyEvent(true, key, false, game)
end
function SignalService:ClickButton(btn: GuiButton)
    GuiService.SelectedObject = btn
    
    SignalService:SendKey(Enum.KeyCode.Return)
    SignalService:SendKey(Enum.KeyCode.Return)
    
    GuiService.SelectedObject = nil
end
function SignalService:ExitRobloxMenu(closingYield: number?)
    if GuiService.MenuIsOpen then
        SignalService:SendKey(Enum.KeyCode.Escape)
        
        if closingYield then
            task.wait(closingYield)
        end
    end
end

return SignalService
