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

function AuctusAPI.MakeKeyPopup()

    if not isfile("Apex Hub Script/Key.txt") then
        makefolder("Apex Hub Script")
        writefile("Apex Hub Script/Key.txt", "")
    end

    if AuctusAPI:ValidateKey(readfile("Apex Hub Script/Key.txt")) == true then
        return
    end

	local KeyPopup = Instance.new("ScreenGui")
	local Body = Instance.new("Frame")
	local ContentBody = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Toolbar = Instance.new("Frame")
	local WindowControls = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")
	local Exit = Instance.new("ImageButton")
	local Stroke = Instance.new("ImageLabel")
	local Icon = Instance.new("ImageLabel")
	local Form = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local TextBox = Instance.new("TextBox")
	local CheckKey = Instance.new("TextButton")
	local UICorner_3 = Instance.new("UICorner")
	local GetKey = Instance.new("TextButton")
	local UICorner_4 = Instance.new("UICorner")
	local Dropshadow = Instance.new("ImageLabel")

    do
        KeyPopup.Name = "KeyPopup"
        KeyPopup.Parent = game:GetService("CoreGui")
        KeyPopup.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        KeyPopup.DisplayOrder = 200
        KeyPopup.ResetOnSpawn = false

        Body.Name = "Body"
        Body.Parent = KeyPopup
        Body.AnchorPoint = Vector2.new(0.5, 0.5)
        Body.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
        Body.BackgroundTransparency = 1.000
        Body.BorderSizePixel = 0
        Body.Position = UDim2.new(0.499187052, 0, 0.498972088, 0)
        Body.Size = UDim2.new(0, 314, 0, 141)

        ContentBody.Name = "ContentBody"
        ContentBody.Parent = Body
        ContentBody.AnchorPoint = Vector2.new(0.5, 0.5)
        ContentBody.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        ContentBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentBody.BorderSizePixel = 0
        ContentBody.ClipsDescendants = true
        ContentBody.LayoutOrder = 2
        ContentBody.Position = UDim2.new(0.5, 0, 0.5, 0)
        ContentBody.Size = UDim2.new(1, 0, 1, 0)

        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = ContentBody

        Toolbar.Name = "Toolbar"
        Toolbar.Parent = ContentBody
        Toolbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Toolbar.BackgroundTransparency = 1.000
        Toolbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Toolbar.BorderSizePixel = 0
        Toolbar.Size = UDim2.new(1, 0, -0.160460994, 52)

        WindowControls.Name = "WindowControls"
        WindowControls.Parent = Toolbar
        WindowControls.AnchorPoint = Vector2.new(0, 0.5)
        WindowControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        WindowControls.BackgroundTransparency = 1.000
        WindowControls.BorderColor3 = Color3.fromRGB(0, 0, 0)
        WindowControls.BorderSizePixel = 0
        WindowControls.Position = UDim2.new(0, 0, 0.5, 0)
        WindowControls.Size = UDim2.new(0, 69, 0, 38)

        UIListLayout.Parent = WindowControls
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.Padding = UDim.new(0, 8)

        UIPadding.Parent = WindowControls
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 20)

        Exit.Name = "Exit"
        Exit.Parent = WindowControls
        Exit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Exit.BackgroundTransparency = 1.000
        Exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Exit.BorderSizePixel = 0
        Exit.Size = UDim2.new(0, 12, 0, 12)
        Exit.AutoButtonColor = false
        Exit.Image = "rbxassetid://132228700346004"
        Exit.ImageColor3 = Color3.fromRGB(255, 95, 87)

        Stroke.Name = "Stroke"
        Stroke.Parent = Exit
        Stroke.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Stroke.BackgroundTransparency = 1.000
        Stroke.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Stroke.BorderSizePixel = 0
        Stroke.Size = UDim2.new(1, 0, 1, 0)
        Stroke.Image = "rbxassetid://94763505860483"
        Stroke.ImageTransparency = 0.900

        Icon.Name = "Icon"
        Icon.Parent = Exit
        Icon.AnchorPoint = Vector2.new(0.5, 0.5)
        Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Icon.BackgroundTransparency = 1.000
        Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Icon.BorderSizePixel = 0
        Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        Icon.Size = UDim2.new(1, 0, 1, 0)
        Icon.Visible = false
        Icon.Image = "rbxassetid://94781753558308"
        Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
        Icon.ImageTransparency = 0.500

        Form.Name = "Form"
        Form.Parent = ContentBody
        Form.BackgroundColor3 = Color3.fromRGB(31, 31, 33)
        Form.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Form.BorderSizePixel = 0
        Form.Position = UDim2.new(0.0500000007, 0, 0.208333328, 0)
        Form.Size = UDim2.new(0.899999976, 0, 0.241134748, 0)
        Form.ZIndex = 0

        UICorner_2.CornerRadius = UDim.new(0, 6)
        UICorner_2.Parent = Form

        TextBox.Parent = Form
        TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.BackgroundTransparency = 1.000
        TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextBox.BorderSizePixel = 0
        TextBox.Position = UDim2.new(0.05, 0, 0.25, 0)
        TextBox.Size = UDim2.new(0.9, 0, 0.5, 0)
        TextBox.Font = Enum.Font.Unknown
        TextBox.PlaceholderColor3 = Color3.fromRGB(159, 159, 159)
        TextBox.PlaceholderText = "key..."
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.TextSize = 15.000
        TextBox.TextScaled = true

        CheckKey.Name = "CheckKey"
        CheckKey.Parent = ContentBody
        CheckKey.Active = false
        CheckKey.BackgroundColor3 = Color3.fromRGB(31, 31, 33)
        CheckKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CheckKey.BorderSizePixel = 0
        CheckKey.Position = UDim2.new(0.540012062, 0, 0.589538991, 0)
        CheckKey.Selectable = false
        CheckKey.Size = UDim2.new(0.407000005, 0, 0.298000008, 0)
        CheckKey.Font = Enum.Font.Unknown
        CheckKey.Text = "Submit"
        CheckKey.TextColor3 = Color3.fromRGB(255, 255, 255)
        CheckKey.TextSize = 15.000
        CheckKey.TextTransparency = 0.450

        UICorner_3.CornerRadius = UDim.new(0, 6)
        UICorner_3.Parent = CheckKey

        GetKey.Name = "GetKey"
        GetKey.Parent = ContentBody
        GetKey.Active = false
        GetKey.BackgroundColor3 = Color3.fromRGB(31, 31, 33)
        GetKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
        GetKey.BorderSizePixel = 0
        GetKey.Position = UDim2.new(0.0495661832, 0, 0.589538991, 0)
        GetKey.Selectable = false
        GetKey.Size = UDim2.new(0.407141238, 0, 0.297872335, 0)
        GetKey.Font = Enum.Font.Unknown
        GetKey.Text = "GetKey"
        GetKey.TextColor3 = Color3.fromRGB(255, 255, 255)
        GetKey.TextSize = 15.000
        GetKey.TextTransparency = 0.450

        UICorner_4.CornerRadius = UDim.new(0, 6)
        UICorner_4.Parent = GetKey

        Dropshadow.Name = "Dropshadow"
        Dropshadow.Parent = Body
        Dropshadow.AnchorPoint = Vector2.new(0.5, 0.5)
        Dropshadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dropshadow.BackgroundTransparency = 1.000
        Dropshadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Dropshadow.BorderSizePixel = 0
        Dropshadow.Position = UDim2.new(0.5, 0, 0.5, 3)
        Dropshadow.Size = UDim2.new(1, 24, 1, 24)
        Dropshadow.ZIndex = 0
        Dropshadow.Image = "rbxassetid://138260268144845"
        Dropshadow.ImageTransparency = 0.650
        Dropshadow.ScaleType = Enum.ScaleType.Slice
        Dropshadow.SliceCenter = Rect.new(28, 26, 96, 94)
    end

    local key_signal = Instance.new("BindableEvent")
	local connects = {}

	local function EndPopupKey()
        KeyPopup:Destroy()
        key_signal:Destroy()

		for _, v in connects do
			v:Disconnect()
		end
	end

	local getcon = GetKey.MouseButton1Click:Connect(function()
		local link = AuctusAPI:GetKeyLink()
		setclipboard(link)
	end)

	local checkcon = CheckKey.MouseButton1Click:Connect(function()
        local key = TextBox.Text
		local isValid = AuctusAPI:ValidateKey(key)

		if isValid == true then
            writefile("Apex Hub Script/Key.txt", key)
            key_signal:Fire(true)
            EndPopupKey()
        end
	end)

	local exitcon = Exit.MouseButton1Click:Connect(function()
		key_signal:Fire(false)
        EndPopupKey()
	end)

	table.insert(connects, getcon)
	table.insert(connects, checkcon)
	table.insert(connects, exitcon)

    return key_signal.Event:Wait()
end

-- ═══════════════════════════════════════════════════════════════
-- 🪟 UI LIBRARY
-- ═══════════════════════════════════════════════════════════════
type Library = "Cassade" | "Fluent" | "WindUi"

-- cassade
local CascadeLibrary = loadstring(game:HttpGet("https://github.com/biggaboy212/Cascade/releases/latest/download/dist.luau"))()

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

    collection.app = CascadeLibrary.New({WindowPill = true, Theme = CascadeLibrary.Themes.Dark, Accent = CascadeLibrary.Accents.Red})

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
    if not isfile("Apex Hub Script/CassadeSettings.json") then
        writefile("Apex Hub Script/CassadeSettings.json", "{}")
    end

    local String = readfile("Apex Hub Script/CassadeSettings.json")
    local settings = HttpService:JSONDecode(String:match("{") and String or "{}")
    self.window.Searching = if settings.Searching ~= nil then settings.Searching else true
    self.window.Draggable = if settings.Draggable ~= nil then settings.Draggable else true
    self.window.Resizable = if settings.Resizable ~= nil then settings.Resizable else true
    self.window.Dropshadow = if settings.Dropshadow ~= nil then settings.Dropshadow else true
    self.window.UIBlur = if settings.UIBlur ~= nil then settings.UIBlur else true
    self.collection.app.Theme = if settings.WhiteMode then self.cassade.Themes.Light else self.cassade.Themes.Dark
    self.minimizeKeybind = settings.minimizeKeybind and Enum.KeyCode[settings.minimizeKeybind] or Enum.KeyCode.RightControl
    self.WhiteMode = settings.WhiteMode

    return self
end

function Cassade:CreateSetting(sectionId: string)
    self:Tab("GuiSettingsTab", sectionId, {Title = "Gui Appearance", Icon = "http://www.roblox.com/asset/?id=70542492197391"})
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
                Value = not self.WhiteMode,
                ValueChanged = function(_self, value: boolean)
                    self.collection.app.Theme = value and self.cassade.Themes.Dark or self.cassade.Themes.Light
                    self.WhiteMode = not value
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
    settings.WhiteMode = self.WhiteMode
    settings.minimizeKeybind = tostring(self.minimizeKeybind):sub(14)

    writefile("Apex Hub Script/CassadeSettings.json", HttpService:JSONEncode(settings))
end

function Cassade:Section(sectionId: string, property: property?)
    self.Sections[sectionId] = self.window:Section(property)

    return self.Sections[sectionId]
end

function Cassade:Tab(tabId: string, sectionId: string, property: property?)
    self.Tabs[tabId] = {ID = tabId, Title = property.Title, Object = self.Sections[sectionId]:Tab(property), Parent = self.Sections[sectionId]}

    return self.Tabs[tabId]
end

function Cassade:Form(formId: string, tabId: string, property: property?)
    self.Forms[formId] = {ID = formId, Title = property.Title, Object = self.Tabs[tabId].Object:PageSection(property):Form(), Parent = self.Tabs[tabId]}

    return self.Forms[formId]
end

function Cassade:Row(rowId: string, formId: string, title: string, subtitle: string?)
    self.Rows[rowId] = {ID = rowId, Title = title, Object = self.Forms[formId].Object:Row({SearchIndex = title}), Parent = self.Forms[formId]}

    self.Rows[rowId].Object:Left():TitleStack({Title = title, Subtitle = subtitle})

    return self.Rows[rowId].Object
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
