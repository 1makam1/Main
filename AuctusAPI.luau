local AuctusAPI = {}

local HttpService = game:GetService("HttpService")

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
-- 🪟 UI LIBRARY
-- ═══════════════════════════════════════════════════════════════
type Library = "Cassade" | "Fluent" | "WindUi"

-- cassade
local CascadeLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/1makam1/Main/refs/heads/main/Cassade.luau"))()

local Cassade = {}
Cassade.__index = Cassade

type property = {[string]: any}

function Cassade.new(title: string, collection: {any})
    --══════════════ cassade method ══════════════════════
    local self = setmetatable({}, Cassade)
    self.collection = collection
    self.cassade = CascadeLibrary

    self.Sections = {}
    self.Tabs = {}
    self.Forms = {}
    self.Rows = {}

    --══════════════ set up window ══════════════════════
    local userInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")

    collection.app = CascadeLibrary.New({WindowPill = true, Theme = CascadeLibrary.Themes.Dark})

    local window = collection.app:Window({Title = title, Subtitle = "Apex Hub", Size = userInputService.TouchEnabled and UDim2.fromOffset(550, 325) or UDim2.fromOffset(850, 530)})
    self.window = window

    --// minimize
    userInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == self.minimizeKeybind and not gameProcessedEvent then
            window.Minimized = not window.Minimized
        end
    end)

    collection.CloseConnect = window.Destroying:Connect(function() if getgenv().CleanUpApexHub then getgenv().CleanUpApexHub() end end)

    -- set sidebar size
    window.Sidebar.Size = UDim2.new(0, 215, 1, 0)
    window.Sidebar.Margins.Size = UDim2.new(1, 0, 1, 0)

    collection.PlayerDropdown = {}

    --══════════════ init settings ══════════════════════
    if not isfile("Apex Hub Script/CassadeSettings.txt") then
        writefile("Apex Hub Script/CassadeSettings.txt", "")
    end

    local settings = HttpService:JSONDecode(readfile("Apex Hub Script/CassadeSettings.txt")) or {}
    self.window.Searching = settings.Searching or true
    self.window.Draggable = settings.Draggable or true
    self.window.Resizable = settings.Resizable or true
    self.window.Dropshadow = settings.Dropshadow or true
    self.window.UIBlur = settings.UIBlur or true
    self.collection.app.Theme = settings.DarkTheme and self.cassade.Themes.Dark or self.cassade.Themes.Light
    self.minimizeKeybind = settings.minimizeKeybind or Enum.KeyCode.RightControl

    return self
end

function Cassade:CreateSetting(property: property)
    self:Section("Gui Appearance", property)
        self:Tab("GuiSettingsTab", "Gui Appearance", {Title = "GUI Setting", Icon = "http://www.roblox.com/asset/?id=70542492197391"})
            self:Form("AppearanceForm", "GuiSettingsTab", {Title = "Appearance"})
            self:Form("InputForm", "GuiSettingsTab", {Title = "Input"})
            self:Form("EffectsForm", "GuiSettingsTab", {Title = "Effects", Subtitle = "These effects may be resource intensive across different systems."})

    do -- Appearance

        do -- Dark mode
            local row = self:Row(
                "DarkModeRow",
                "AppearanceForm",
                "Dark mode",
                "An application appearance setting that uses a dark color palette to provide a comfortable viewing experience tailored for low-light environments."
            )

            row:Right():Toggle({
                Value = self.collection.app.Theme == self.cassade.Themes.Dark,
                ValueChanged = function(_self, value: boolean)
                    self.collection.app.Theme = value and self.cassade.Themes.Dark or self.cassade.Themes.Light
                    self:UpdateSetting()
                end,
            })
        end
    end

    do -- Input

        do -- Minimize shortcut
            local row = self:Row("MinimizeShortcutRow", "InputForm", "Minimize shortcut")

            row:Right():KeybindField({
                Value = self.minimizeKeybind,
                ValueChanged = function(_self, value: Enum.KeyCode)
                    self.minimizeKeybind = value
                    self:UpdateSetting()
                end,
            })
        end

        do -- Searching
            local row = self:Row(
                "SearchingRow",
                "InputForm",
                "Searchable",
                "Allows users to search for content in a page with a search-field in the titlebar."
            )

            row:Right():Toggle({
                Value = self.window.Searching,
                ValueChanged = function(_self, value: boolean)
                    self.window.Searching = value
                    self:UpdateSetting()
                end,
            })
        end

        do -- Draggable
            local row = self:Row("DraggableRow", "InputForm", "Draggable", "Allows users to move the window with a mouse or touch device.")

            row:Right():Toggle({
                Value = self.window.Draggable,
                ValueChanged = function(_self, value: boolean)
                    self.window.Draggable = value
                    self:UpdateSetting()
                end,
            })
        end

        do -- Resizable
            local row = self:Row("ResizableRow", "InputForm", "Resizable", "Allows users to resize the window with a mouse or touch device.")

            row:Right():Toggle({
                Value = self.window.Resizable,
                ValueChanged = function(_self, value: boolean)
                    self.window.Resizable = value
                    self:UpdateSetting()
                end,
            })
        end
    end

    do -- Effects

        do -- Dropshadow
            local row = self:Row("DropshadowRow", "EffectsForm", "Dropshadow", "Enables a dropshadow effect on the window.")

            row:Right():Toggle({
                Value = self.window.Dropshadow,
                ValueChanged = function(_self, value: boolean)
                    self.window.Dropshadow = value
                    self:UpdateSetting()
                end,
            })
        end

        do -- UI Blur
            local row = self:Row("UIBlurRow", "EffectsForm", "Background blur", "Enables a UI background blur effect on the window. This can be detectable in some games.")

            row:Right():Toggle({
                Value = self.window.UIBlur,
                ValueChanged = function(_self, value: boolean)
                    self.window.UIBlur = value
                    self:UpdateSetting()
                end,
            })
        end
    end
end

function Cassade:UpdateSetting()
    local settings = {}

    settings.Searching = self.window.Searching
    settings.Draggable = self.window.Draggable
    settings.Resizable = self.window.Resizable
    settings.Dropshadow = self.window.Dropshadow
    settings.UIBlur = self.window.UIBlur
    settings.DarkTheme = self.collection.app.Theme == self.cassade.Themes.Dark
    settings.minimizeKeybind = self.minimizeKeybind

    writefile("Apex Hub Script/CassadeSettings.txt", HttpService:JSONEncode(settings))
end

function Cassade:Section(sectionId: string, property: property?)
    self.Sections[sectionId] = self.window:Section(property)

    return self.Sections[sectionId]
end

function Cassade:Tab(tabId: string, sectionId: string, property: property?)
    self.Tabs[tabId] = self.Sections[sectionId]:Tab(property)

    return self.Tabs[tabId]
end

function Cassade:Form(formId: string, tabId: string, property: property?)
    self.Forms[formId] = self.Tabs[tabId]:PageSection(property):Form()

    return self.Forms[formId]
end

function Cassade:Row(rowId: string, formId: string, title: string, subtitle: string?)
    self.Rows[rowId] = self.Forms[formId]:Row({SearchIndex = title})

    self.Rows[rowId]:Left():TitleStack({Title = title, Subtitle = subtitle})

    return self.Rows[rowId]
end

-- fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local WindUi = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

function AuctusAPI.CreateApp(library: Library, title: string, collection: {any})
    if library == "Cassade" then
        return Cassade.new(title, collection)
    end
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
