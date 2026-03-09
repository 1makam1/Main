local SignalService = {}

-- =================================================
-- == INPUT SIGNALS
-- =================================================
local GuiService = game:GetService("GuiService")

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

-- =================================================
-- == KEY SYSTEM
-- =================================================
local JunkieKeySystem = loadstring(game:HttpGet("https://junkie-development.de/sdk/JunkieKeySystem.lua"))()
local API_KEY = "2383bf96-9085-4015-b6f9-476b19ffe24d"
local SERVICE = "Get Key!"
local PROVIDER = "Get Key!"

function SignalService:GetLink(): string
    return JunkieKeySystem.getLink(API_KEY, PROVIDER, SERVICE)
end

function SignalService:ValidateKey(key: string): boolean
    return JunkieKeySystem.verifyKey(API_KEY, key, SERVICE)
end

return SignalService
