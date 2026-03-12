local AuctusAPI = {}

-- ═══════════════════════════════════════════════════════════════
-- ⌨️ INPUT SIMULATION
-- ═══════════════════════════════════════════════════════════════
local GuiService = game:GetService("GuiService")

function AuctusAPI:SendKey(key: Enum.KeyCode)
    local string_key = tostring(key)

    if not string_key or not string_key:match("Enum.KeyCode.") then
        warn("invalid argument Enum.KeyCode expected")

        return
    end

    local VIM = game:GetService("VirtualInputManager")

    VIM:SendKeyEvent(false, key, false, game)
    task.wait()
    VIM:SendKeyEvent(true, key, false, game)
    task.wait()
    VIM:SendKeyEvent(false, key, false, game)
end

function AuctusAPI:ClickButton(btn: GuiButton)
    local is_instance = typeof(btn) == "Instance"

    if not is_instance or not btn:IsA("GuiButton") then
        warn("invalid argument GuiButton expected, got "..(is_instance and btn.ClassName or typeof(btn)))

        return
    end

    GuiService.SelectedObject = btn

    AuctusAPI:SendKey(Enum.KeyCode.Return)
    AuctusAPI:SendKey(Enum.KeyCode.Return)

    GuiService.SelectedObject = nil
end

function AuctusAPI:ExitRobloxMenu(closingYield: number?)
    if GuiService.MenuIsOpen then
        AuctusAPI:SendKey(Enum.KeyCode.Escape)

        if type(closingYield) == "number" then
            task.wait(closingYield)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- 🗝️ KEY SYSTEM
-- ═══════════════════════════════════════════════════════════════
local JunkieKeySystem = loadstring(game:HttpGet("https://junkie-development.de/sdk/JunkieKeySystem.lua"))()
local API_KEY = "2383bf96-9085-4015-b6f9-476b19ffe24d"
local SERVICE = "Get Key!"
local PROVIDER = "Get Key!"

function AuctusAPI:GetKeyLink(): string
    return JunkieKeySystem.getLink(API_KEY, PROVIDER, SERVICE)
end

function AuctusAPI:ValidateKey(key: string): boolean
    return JunkieKeySystem.verifyKey(API_KEY, key, SERVICE)
end

-- ═══════════════════════════════════════════════════════════════
-- 🛠️ UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════
function AuctusAPI:DeepPrint(data: any)
    local function PrintTable(t: {any}, tab: number)
        local space = ""

        for i = 1, tab do
            space ..= "   "
        end

        for k, v in t do
            local key = `{space}{type(k) == "number" and `[{k}]` or k} = `

            if type(v) == "table" then

                print(key .. "{")
                PrintTable(v, tab + 1)
                print(space.."}")

            else
                print(key, type(v) == "string" and `"{v}"` or v)
            end
        end
    end

    local data_type = type(data)

    if data_type == "table" then

		print(data, "= {")
        PrintTable(data, 1)
		print("}\n")

    elseif data_type == "function" or data_type == "thread" then
        local s, n, l, a, variadic, f

        if data_type == "function" then
            s, n, l, a, variadic, f = debug.info(data, "snlaf")
        else
            s, n, l, a, variadic, f = debug.info(data, 1, "snlaf")
        end

        local info = string.format("name = %s, line = %s, args = %s, variadic = %s", n, l, a, tostring(variadic))

        print(info)
        print("source : "..s)

    else
        print(data)
	end
end

return AuctusAPI
