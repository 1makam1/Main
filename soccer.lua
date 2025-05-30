local sizeofhitbox = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hitbox").Size
local sizeoftacklehitbox = game:GetService("Players").LocalPlayer.Character:FindFirstChild("TackleHitbox").Size
local sizex
local sizey
local sizez
local tran
local fov
local runspd
local onspace = false

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "League Soccer ",
    SubTitle = "by tungtungtung sahur",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Soccer script",
        Content = "Script Loaded success",
        SubContent = "Enjoy 😎", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })

	Tabs.Main:AddSection("Hitbox")
	local HideHitbox = Tabs.Main:AddToggle("HideHitbox", {Title = "Disable Hitbox When Got Ball", Default = false })
    local ChangeHitbox = Tabs.Main:AddToggle("ChangeHitbox", {Title = "Change Hitbox", Default = false })

	local HitboxSliderx = Tabs.Main:AddSlider("HitboxSliderx", {
        Title = "Hitbox X :",
        Default = 2,
        Min = 0,
        Max = 50,
        Rounding = 0,
        Callback = function(Value)
            sizex = Value
        end
    })

	local HitboxSlidery = Tabs.Main:AddSlider("HitboxSlidery", {
        Title = "Hitbox Y :",
        Default = 2,
        Min = 0,
        Max = 50,
        Rounding = 0,
        Callback = function(Value)
            sizey = Value
        end
    })

	local HitboxSliderz = Tabs.Main:AddSlider("HitboxSliderz", {
        Title = "Hitbox Z :",
        Default = 2,
        Min = 0,
        Max = 50,
        Rounding = 0,
        Callback = function(Value)
            sizez = Value
        end
    })

	local Transparency = Tabs.Main:AddSlider("Transparency", {
        Title = " Hitbox Transparency :",
        Default = 2,
        Min = 0,
        Max = 1,
        Rounding = 1,
        Callback = function(Value)
            tran = Value
        end
    })
    
	Tabs.Main:AddSection("Stamina")
    local DeleteStamina = Tabs.Main:AddToggle("DeleteStamina", {Title = "inf Stamina", Default = false })
	local runspeed = Tabs.Main:AddSlider("runspeed", {
        Title = "Run Speed :",
        Default = 2,
        Min = 27,
        Max = 40,
        Rounding = 0,
        Callback = function(Value)
			runspd = Value
        end
    })

	Tabs.Main:AddSection("etc")
    local fovTabs = Tabs.Main:AddToggle("fovTabs", {Title = "Change field of view", Default = false })
    fovTabs:OnChanged(function()
        if not Options.fovTabs.Value then
            workspace.Camera.FieldOfView = 70
        end
    end)
    
    local fovslider = Tabs.Main:AddSlider("fovslider", {
        Title = "Field of view :",
        Default = 2,
        Min = 10,
        Max = 120,
        Rounding = 0,
        Callback = function(Value)
            fov = Value
        end
    })
end
Window:SelectTab(1) -- select default tab
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("Soccer")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("Save-soccer")
SaveManager:BuildConfigSection(Tabs.Settings)
Fluent:Notify({
    Title = "Soccer script",
    Content = "The script has been loaded.",
    Duration = 5
})
SaveManager:LoadAutoloadConfig()

local uis = game:GetService("UserInputService")
local isshift = false
uis.InputBegan:Connect(function(input, chat)
	if not chat then
		if input.KeyCode == Enum.KeyCode.Space then
			onspace = true
		end
		if input.KeyCode == Enum.KeyCode.LeftShift then
			isshift = true
		end
	end
end)
uis.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space then
		onspace = false
	end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		isshift = false
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	local humanoid = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")
	local hitbox = game:GetService("Players").LocalPlayer.Character:WaitForChild("Hitbox")
	local tacklehitbox = game:GetService("Players").LocalPlayer.Character:WaitForChild("TackleHitbox")
	if Options.HideHitbox.Value then
		local isball = humanoid.Parent.Ball:FindFirstChild("Texture")
		if isball then
			hitbox.CanTouch = false
			tacklehitbox.CanTouch = false
		else
			hitbox.CanTouch = true
			tacklehitbox.CanTouch = true
		end
	end
	if onspace then
		if humanoid.FloorMaterial ~= Enum.Material.Air then
			if humanoid.WalkSpeed ~= 0 then
				local isball = humanoid.Parent.Ball:FindFirstChild("Texture")
				if not isball then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
		end
	end
	if Options.DeleteStamina.Value then
		if isshift then
			if humanoid.WalkSpeed ~= 0 then
				humanoid.WalkSpeed = runspd
			end
		end
		game:GetService("Players").LocalPlayer.PlayerGui.GameGui.MatchHUD.EnergyBars.Stamina.ProgressBar.Size = UDim2.new(1, 0, 1, 0)
	end
	if Options.ChangeHitbox.Value then
		hitbox.Size = Vector3.new(sizex, sizey, sizez)
		tacklehitbox.Size = Vector3.new(sizex, sizey, sizez)
		hitbox.Transparency = tran
		tacklehitbox.Transparency = tran
	else
		hitbox.Size = sizeofhitbox
		tacklehitbox.Size = sizeoftacklehitbox
		hitbox.Transparency = 1
		tacklehitbox.Transparency = 1
	end
	if Options.fovTabs.Value then
        workspace.Camera.FieldOfView = fov
    end
end)
