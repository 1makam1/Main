local humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid
local normalspeed = game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed
local uis = game:GetService("UserInputService")
local cal = false
local hg = false
local ht = false
local hi = false
local li = false
local speedchange = false
local light = game:GetService("Lighting")
local character = game:GetService("Players").LocalPlayer.Character.Config.CharacterName.Value
local usertrinket1 = game:GetService("Players").LocalPlayer.Character.Trinkets.Trinket1.Value
local usertrinket2 = game:GetService("Players").LocalPlayer.Character.Trinkets.Trinket2.Value
local speeditem1 = false
local speeditem2 = false
local Floor = workspace.Info.Floor
local isClownHorn = nil
local isRibbonSpool = nil
local trinket = {
    PinkBow = 7.5,
    ClownHorn = 10,
	SpeedShoes = 5,
	RibbonSpool = 10,
}
local speedof = {
    Shrimpo = 20,--1
    Rodger = 22.5, --2
    Boxten = 25,--3
    Tisha = 27.5,--4
    Pebble = 30,--5
    Poppy = 25,
    Astro = 25,
    Brightney = 25,
    Connie = 20,
    Cosmo = 25,
    Finn = 25,
    Flutter = 27.5,
    Gigi = 25,
    Glisten = 25,
    Goob = 27.5,
    Looey = 25,
    RazzleDazzle = 25,
    Scraps = 22.5,
    Shelly = 25,
    Sprout = 27.5,
    Teagan = 25,
    Toodles = 25,
    Vee = 22.5,
    Yatta = 27.5,
}
for i,v in trinket do
    if usertrinket1 == i then
        if usertrinket1 == "ClownHorn" then
            isClownHorn = 1
		elseif usertrinket1 == "RibbonSpool" then
			isRibbonSpool = 1
        end
        speeditem1 = true
    end
    if usertrinket2 == i then
        if usertrinket2 == "ClownHorn" then
            isClownHorn = 2
		elseif usertrinket2 == "RibbonSpool" then
			isRibbonSpool = 2
        end
        speeditem2 = true
    end
end
local liftp = Instance.new("Part")
liftp.Name = "liftpart"
liftp.Anchored = true
liftp.Transparency = 1
liftp.Size = Vector3.new(1000,1,1000)
liftp.CanCollide = false
liftp.Parent = workspace
liftp.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.X,143, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.z,1, 0, 0,0, 1, 0,-0, -0, -1) - Vector3.new(0,3,0)
uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        if li then
            game:GetService("TweenService"):Create(liftp, TweenInfo.new(0.2), {CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.X,liftp.CFrame.Position.Y + 1, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Z, 1, 0, 0, 0, 1, 0,-0, -0, -1)}):Play()
        end
    elseif input.KeyCode == Enum.KeyCode.Q then
        if li then
            game:GetService("TweenService"):Create(liftp, TweenInfo.new(0.2), {CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.X,liftp.CFrame.Position.Y - 1, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Z, 1, 0, 0, 0, 1, 0,-0, -0, -1)}):Play()
        end
    end
end)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Dandy's World ",
    SubTitle = "free script",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Dandy's World",
        Content = "Script Loaded success",
        SubContent = "", 
        Duration = 5 
    })
    
    local BrightMode = Tabs.Main:AddToggle("BrightMode", {Title = "Bright Mode", Default = false })
    BrightMode:OnChanged(function()
        if Options.BrightMode.Value then
            light.GlobalShadows = false
            light.FogEnd = 999999
        	light.Ambient = Color3.fromRGB(255, 255, 255)
        else
            light.GlobalShadows = true
            light.FogEnd = 250
        	light.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end)
    
    
    local HighlightGenerator = Tabs.Main:AddToggle("HighlightGenerator", {Title = "Highlight Generator", Default = false })
    HighlightGenerator:OnChanged(function()
        if Options.HighlightGenerator.Value then
            hg = true
        else
            hg = false
        end
    end)
   
    
    local HighlightItems = Tabs.Main:AddToggle("HighlightItems", {Title = "Highlight Items", Default = false })
    HighlightItems:OnChanged(function()
        if Options.HighlightItems.Value then
            hi = true
        else
            hi = false
        end
    end)

    
    local HighlightPlayers = Tabs.Main:AddToggle("HighlightPlayers", {Title = "Highlight Players", Default = false })
    HighlightPlayers:OnChanged(function()
        if Options.HighlightPlayers.Value then
            for i, v in ipairs(game.workspace.InGamePlayers:GetChildren())do
        	    local ish = v:WaitForChildWhichIsA("Highlight")
        	    if not ish then
        	        local h = Instance.new("Highlight")
                	h.FillColor = Color3.fromRGB(0, 255, 0)
                	h.Parent = v
        	    end
            end
        else
            for i, v in ipairs(game.workspace.InGamePlayers:GetChildren())do
        	    local ish = v:WaitForChildWhichIsA("Highlight")
        	    if ish then
        	        ish:Destroy()
        	    end
            end
        end
    end)

    
    local HighlightTwisted = Tabs.Main:AddToggle("HighlightTwisted", {Title = "Highlight Twisted", Default = false })
    HighlightTwisted:OnChanged(function()
        if Options.HighlightTwisted.Value then
            ht = true
        else
            ht = false
        end
    end)
    
    local Lift = Tabs.Main:AddToggle("Lift", {Title = "Lift", Description = "Space : up | Q : down", Default = false })
    Lift:OnChanged(function()
        if Options.Lift.Value then
            li = true
            liftp.CanCollide = true
        else
            li = false
            liftp.CanCollide = false
            game:GetService("TweenService"):Create(liftp, TweenInfo.new(1), {CFrame = CFrame.new(liftp.CFrame.Position.X, 143, liftp.CFrame.Position.Z, 1, 0, 0, 0, 1, 0,-0, -0, -1)}):Play()
        end
    end)
    
    local ChangeSpeed = Tabs.Main:AddSlider("ChangeSpeed", {
        Title = "Change Speed",
        Description = "⭐ = 20 \n⭐⭐ = 22.5 \n⭐⭐⭐ = 25 \n⭐⭐⭐⭐ = 27.5 \n⭐⭐⭐⭐⭐= 30",
        Default = 20,
        Min = 20,
        Max = 35,
        Rounding = 0,
        Callback = function(Value)
        end
    })

    ChangeSpeed:OnChanged(function(Value)

    end)
    
    local UseChangeSpeed = Tabs.Main:AddToggle("UseChangeSpeed", {Title = "Use Change Speed", Default = false })
    UseChangeSpeed:OnChanged(function()
        if Options.UseChangeSpeed.Value then
            Options.AutoSpeedChange:SetValue(false)
            humanoid.WalkSpeed = Options.ChangeSpeed.Value
            speedchange = true
        else
            humanoid.WalkSpeed = normalspeed
            speedchange = false
        end
    end)
    
    local AutoSpeedChange = Tabs.Main:AddToggle("AutoSpeedChange", {Title = "Auto Change Speed To Run Speed", Default = false })
    AutoSpeedChange:OnChanged(function()
        if Options.AutoSpeedChange.Value then
            Options.UseChangeSpeed:SetValue(false)
            cal = true
        else
            cal = false
            humanoid.WalkSpeed = normalspeed
        end
    end)
end
Window:SelectTab(1)

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("dandy world free script")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

while true do
    if speedchange then
        humanoid.WalkSpeed = Options.ChangeSpeed.Value
    end
    if cal then
        if isClownHorn == 1 or isClownHorn == 2 then
            if tonumber(Floor.Value) % 2 == 0 then
                if isClownHorn == 1 then
                    speeditem1 = false
                elseif isClownHorn == 2 then
                    speeditem2 = false
                end
    			if isRibbonSpool == 1 then
    				speeditem1 = true
    			elseif isRibbonSpool == 2 then
    				speeditem2 = true
    			end
            else
    			if isRibbonSpool == 1 then
    				speeditem1 = false
    			elseif isRibbonSpool == 2 then
    				speeditem2 = false
    			end
                if isClownHorn == 1 then
                    speeditem1 = true
                elseif isClownHorn == 2 then
                    speeditem2 = true
                end
            end
        end
        if humanoid.WalkSpeed ~= 0 then
            if speeditem1 == true and speeditem2 == true then
                humanoid.WalkSpeed = (speedof[character] + ((speedof[character] * trinket[usertrinket1]) / 100)) + ((speedof[character] + ((speedof[character] * trinket[usertrinket1]) / 100)) * trinket[usertrinket2] / 100)
            elseif speeditem1 == true and speeditem2 == false then
                humanoid.WalkSpeed = speedof[character] + ((speedof[character] * trinket[usertrinket1]) / 100)
            elseif speeditem1 == false and speeditem2 == true then
                humanoid.WalkSpeed = speedof[character] + ((speedof[character] * trinket[usertrinket2]) / 100)
            end
        end
    end
	for i,v in ipairs(game.workspace.CurrentRoom:GetChildren())do
		for a,b in ipairs(v:GetChildren())do
			if b.Name == "Monsters" then
				for x,y in ipairs(b:GetChildren())do
					if ht then
					    local ish = y:WaitForChildWhichIsA("Highlight")
					    if not ish then
        					local h = Instance.new("Highlight")
        					h.Parent = y
    					end
    				else
    				    local ish = y:WaitForChildWhichIsA("Highlight")
					    if ish then
					        ish:Destroy()
					    end
				    end
				end
			end
			if b.Name == "Generators"then
				for x,y in ipairs(b:GetChildren())do
					if hg then
					    local ish = y:WaitForChildWhichIsA("Highlight")
					    if not ish then
					        local h = Instance.new("Highlight")
					        h.Parent = y
					    else
					        local h = y:WaitForChildWhichIsA("Highlight")
					        if y.Stats.Completed.Value == true then
        						h.FillColor = Color3.fromRGB(0, 0, 255)
        					else
        						h.FillColor = Color3.fromRGB(255, 0, 255)
        					end
    					end
					
    					if y.Stats.Connie.Value == true then
    						local isb = y:WaitForChild("Light"):WaitForChildWhichIsA("BillboardGui")
    						if not isb then
    							local b = Instance.new("BillboardGui")
    							b.Parent = y.Light
    							b.AlwaysOnTop = true
    							b.ExtentsOffset = Vector3.new(0, 1, 0)
    							b.Size = UDim2.new(0, 10, 0, 10)
    							local t = Instance.new("TextLabel")
    							t.Parent = b
    							t.Position = UDim2.new(0, 10, 0, 10)
    							t.Text = "Ghosted"
    							t.TextSize = 15
    							t.TextColor3 = Color3.fromRGB(255, 255, 255)
    							t.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    							t.TextStrokeTransparency = 0
    						end
    					else
    					    local isb = y:WaitForChild("Light"):WaitForChildWhichIsA("BillboardGui")
    					    if isb then
    					        isb:Destroy()
    					    end
    					end
					else
					    local ish = y:WaitForChildWhichIsA("Highlight")
					    if ish then
					        ish:Destroy()
					    end
						local isb = y:WaitForChild("Light"):WaitForChildWhichIsA("BillboardGui")
						if isb then
							isb:Destroy()
						end
					end
				end
			end
			if b.Name == "Items" then
				for x,y in ipairs(b:GetChildren())do
					if hi then
					    local isb = y:WaitForChildWhichIsA("BillboardGui")
					    if not isb then
        					local b = Instance.new("BillboardGui")
        					b.Parent = y
        					b.AlwaysOnTop = true
        					b.ExtentsOffset = Vector3.new(0, 1, 0)
        					b.Size = UDim2.new(0, 10, 0, 10)
        					local t = Instance.new("TextLabel")
        					t.Parent = b
        					t.Position = UDim2.new(0, 10, 0, 10)
        					t.Text = tostring(y)
        					t.TextSize = 10
        					t.TextColor3 = Color3.fromRGB(255, 255, 255)
        					if y.Name == "FakeCapsule" then
        						t.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
        						t.TextStrokeTransparency = 0 
        					elseif y.Name == "Bandage" or y.Name == "HealthKit" then
        						t.TextStrokeColor3 = Color3.fromRGB(0, 255, 0)
        						t.TextStrokeTransparency = 0 
        					end
    					end
    				else
    				    local isb = y:WaitForChildWhichIsA("BillboardGui")
						if isb then
							isb:Destroy()
						end
					end
				end
			end
		end
	end
	wait(0.5)
end
