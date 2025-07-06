---[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[--VARIABLES-&-COMPONENTS--]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local playersname = {}
_G.Connect = {
    ability = nil,
    AutoBuyTier = nil,
}
local fly
local setdropdown = false
local atkcd = false
---[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[--FUNCTIONS--]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
function TP(Position)
    local distance = (Position.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    speed = 200
    game:GetService("TweenService"):Create(
    game.Players.LocalPlayer.Character.HumanoidRootPart, 
    TweenInfo.new(distance/speed, Enum.EasingStyle.Linear),
    {CFrame = Position}
    ):Play()
end
local function Attack()
    if not atkcd then
        atkcd = true
        
        local Closetmon = {}
        local success = pcall(function()
            local closetrange = 60
            
            local enemy = {}
            for i,v in workspace.Enemies:GetChildren()do
                if v:FindFirstChild("HumanoidRootPart") then
                    table.insert(enemy, v)
                end
            end
            for i,v in workspace.Characters:GetChildren()do
                if v:FindFirstChild("HumanoidRootPart") then
                    table.insert(enemy, v)
                end
            end
            
            for i,v in enemy do
                local char = game:GetService("Players").LocalPlayer.Character
                if char and v ~= char then
                    local range = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                    if range < closetrange then
                        table.insert(Closetmon, v)
                    end
                end
            end
        end)
        
        if success and Closetmon[1] then
            
            local montable = {}
            for i, mon in Closetmon do
                montable[i] = {}
                table.insert(montable[i], mon)
                table.insert(montable[i], mon:FindFirstChildWhichIsA("BasePart"))
            end
            
            game:GetService("ReplicatedStorage").Modules.Net["RE/RegisterAttack"]:FireServer(0.3)
            game:GetService("ReplicatedStorage").Modules.Net["RE/RegisterHit"]:FireServer(Closetmon[1]:FindFirstChildWhichIsA("BasePart"), montable, nil, "41260b7d")
            game:GetService("ReplicatedStorage").Effect.Bindable:Fire("spawn", game:GetService("ReplicatedStorage").Effect.Container.Misc.Damage, {["Value"] = 0}, {})
        end
        
        task.spawn(function()
            task.wait(0.1)
            atkcd = false
        end)
    end
end
---[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[--UI--]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

if _G.Window then _G.Window:Destroy() end
_G.Window = Fluent:CreateWindow({
    Title = "Auto V4 Bloxfruit  | ",
    SubTitle = "by ALUMILAI",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.F
})
local Tabs = {
    Main = _G.Window:AddTab({ Title = "V4", Icon = "shield" }),
    PlayerTab = _G.Window:AddTab({ Title = "Players", Icon = "users" }),
    Other = _G.Window:AddTab({ Title = "Other", Icon = "list" }),
    Settings = _G.Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Options = Fluent.Options
do
	local PlayersSection = Tabs.PlayerTab:AddSection("Select Player")
	Playerselect = PlayersSection:AddInput("PlayersSection", {
        Title = "Selected Player",
        Description = "*Ignore this one",
        Default = "",
        Placeholder = "no player select",
        Numeric = false,
        Finished = false,
    })

	local PlayersDropdown = PlayersSection:AddDropdown("PlayersDropdown", {Title = "Select Player",Values = playersname, Multi = false, Default = nil,})
	PlayersDropdown:OnChanged(function(Value)
        if _G.Connect.ability then
            _G.Connect.ability:Disconnect()
            _G.Connect.ability = nil
        end
        
        Playerselect:SetValue(Value and Value or "")
	end)
	
    Playerselect:OnChanged(function()
        if not setdropdown and Playerselect.Value ~= "" then
            setdropdown = true
            if not table.find(Options.PlayersDropdown.Values, Playerselect.Value) then
                Options.PlayersDropdown.Values[#Options.PlayersDropdown.Values + 1] = Playerselect.Value
            end
            PlayersDropdown:SetValue(Playerselect.Value)
        else
            pcall(function()
                Playerselect:SetValue(Options.PlayersDropdown.Value and Options.PlayersDropdown.Value or "")
            end)
        end
    end)
    
    local ResetPlayer = PlayersSection:AddButton({Title = "Refresh Player",Callback = function()
        playersname = {}
        for i,v in ipairs(game:GetService("Players"):GetChildren())do
            if v ~= game.Players.LocalPlayer then
                table.insert(playersname, v.Name)
            end
        end
        
        Options.PlayersDropdown.Values = playersname
        PlayersDropdown:SetValue(playersname[1])
        
        if _G.Connect.ability then
            _G.Connect.ability:Disconnect()
            _G.Connect.ability = nil
        end
    end})
    
    
    
    local playerFunctionSection = Tabs.PlayerTab:AddSection("Player Functions")
    local FlyToPlayer = playerFunctionSection:AddToggle("FlyToPlayer", {Title = "Fly To Player", Default = false })
    FlyToPlayer:OnChanged(function()
        if Options.FlyToPlayer.Value then
            fly = true
        else
            fly = false
            pcall(function() TP(Player.Character.HumanoidRootPart.CFrame) end)
        end
    end)
    local AutoEnablePvp = playerFunctionSection:AddToggle("AutoEnablePvp", {Title = "Auto Enable Pvp", Default = false })
    
    
    
    local V4Section = Tabs.Main:AddSection("Trials")
    local AutoAbility = V4Section:AddToggle("AutoAbility", {Title = "Auto Ability", Description = "Activate ability when selected player use ability", Default = false })
    local AutoBuyTier = V4Section:AddToggle("AutoBuyTier", {Title = "Auto Buy Tier", Default = false })
    AutoBuyTier:OnChanged(function()
        if not _G.Connect.AutoBuyTier and Options.AutoBuyTier.Value then
            _G.Connect.AutoBuyTier = task.spawn(function()
                while task.wait(1) do
                    pcall(function()
                        local Require, current = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Check")
                        if Require == 7 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
                        end
                    end)
                end
            end)
        else
            if _G.Connect.AutoBuyTier then
                task.cancel(_G.Connect.AutoBuyTier)
                _G.Connect.AutoBuyTier = nil
            end
        end
    end)
    
    
    local RaceSection = Tabs.Main:AddSection("Races Functions")
    local AutoTranform = RaceSection:AddToggle("AutoTranform", {Title = "Auto V4 Tranform", Default = false })
    RaceSection:AddButton({Title = "Race Reroll",Callback = function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2") end})
    
    
    local ETCSection = Tabs.Other:AddSection("Other")
    local AutoAttack = ETCSection:AddToggle("AutoAttack", {Title = "Auto Attack", Default = false })
    local AutoBuso = ETCSection:AddToggle("AutoBuso", {Title = "Auto Buso Haki", Default = false })
    
    
    local TeamsSection = Tabs.Other:AddSection("Teams")
    TeamsSection:AddButton({Title = "Join Marines",Callback = function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines") end})
    TeamsSection:AddButton({Title = "Join Pirates",Callback = function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates") end})
    
end
_G.Window:SelectTab(1)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("Autov4byALUMILAI")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("ALUMILAI/Autov4")
SaveManager:Load("V4SctiptSettings")
---[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]


if _G.MainLoop then
    task.cancel(_G.MainLoop)
    if _G.Connect.ability then task.cancel(_G.Connect.ability) _G.Connect.ability = nil end
    if _G.fly_thread then task.cancel(_G.fly_thread) _G.fly_thread = nil end
    pcall(function() TP(Player.Character.HumanoidRootPart.CFrame) end)
end


_G.MainLoop = task.spawn(function()
    while task.wait(.1) do
        SaveManager:Save("V4SctiptSettings")
        if fly then
            if not _G.fly_thread then
                _G.fly_thread = task.spawn(function()
                    while task.wait() do
                        pcall(function()
                            Player.Character.UpperTorso.CanCollide = false
                            Player.Character.LowerTorso.CanCollide = false
                            Player.Character.HumanoidRootPart.CanCollide = false
                            Player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,2.1,0)
                        end)
                    end
                end)
            end
        else
            if _G.fly_thread then task.cancel(_G.fly_thread) _G.fly_thread = nil end
        end
        
        
        
        if Options.AutoAttack.Value then Attack() end
        
        if Options.AutoTranform.Value then
            pcall(function()
                if Player.Character.RaceEnergy.Value == 1 then
                    if not Player.Character.RaceTransformed.Value then
                        game:GetService("ReplicatedStorage").Events.ActivateRaceV4:Fire()
                        task.wait(1)
                    end
                end
            end)
        end
        
        if Options.FlyToPlayer.Value then
            pcall(function() TP(Players[Playerselect.Value].Character.HumanoidRootPart.CFrame) end)
        end
        
        if Options.AutoEnablePvp.Value then
            pcall(function()
                if Player:GetAttribute("PvpDisabled") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                    task.wait(.5)
                end
            end)
        end
        
        if Options.AutoBuso.Value then
            pcall(function()
                if not Player.Character:GetAttribute("BusoEnabled") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                    task.wait(.5)
                end
            end)
        end
        
        
        
        if Options.AutoAbility.Value then
            pcall(function()
                local Head = Playerselect.Value and Playerselect.Value or nil
                if Players[Head] then
                    local headchar = Players[Head].Character
                    if headchar then
                        if headchar:FindFirstChild("HumanoidRootPart") then
                            if headchar:FindFirstChild("Humanoid") then
                                if headchar:FindFirstChild("Humanoid").Health == 0 then
                                    if _G.Connect.ability then
                                        _G.Connect.ability:Disconnect()
                                        _G.Connect.ability = nil
                                    end
                                else
                                    if not _G.Connect.ability then
                                        _G.Connect.ability = headchar.HumanoidRootPart.ChildAdded:Connect(function(child)
                                            if child.Name == "Last Resort" or child.Name == "Agility" or child.Name == "Water Body" or child.Name == "Heavenly Blood" or child.Name == "Heightened Senses" or child.Name == "Energy Core" or child.Name == "Primordial Reign" then
                                                if Players[Head] and not Player.PlayerGui.Main.BottomHUDList.UniversalContextButtons.BoundActionRaceAbility.CooldownLabel.Visible then
                                                    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
                                                    print"asdasdadasd"
                                                    task.wait(1)
                                                end
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                else
                    if _G.Connect.ability then
                        _G.Connect.ability:Disconnect()
                        _G.Connect.ability = nil
                    end
                end
            end)
        else
            if _G.Connect.ability then
                _G.Connect.ability:Disconnect()
                _G.Connect.ability = nil
            end
        end
    end
end)
