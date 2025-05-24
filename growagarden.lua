local playerfarm
for i,v in ipairs(workspace.Farm:GetChildren())do
    local owner = v:FindFirstChild("Important"):FindFirstChild("Data"):FindFirstChild("Owner").Value
    if owner == game:GetService("Players").LocalPlayer.Name then
        playerfarm = v:FindFirstChild("Important"):FindFirstChild("Plant_Locations")
    end
end
local port = {playerfarm:GetChildren()[1], playerfarm:GetChildren()[2]}
local plantremote = game.ReplicatedStorage.GameEvents.Plant_RE
local sellremote = game.ReplicatedStorage.GameEvents.Sell_Inventory
---[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "grow a garden | ",
    SubTitle = "by ALUMILAI",
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
---[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]--------------------------------------[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
do
    local Autobuy = Tabs.Main:AddToggle("Autobuy", {Title = "Auto Buy Seed", Default = false })
    local Seed = Tabs.Main:AddDropdown("Seed", {
        Title = "Seed",
        Values = {"Carrot", "Strawberry", "Blueberry"},
        Multi = false,
        Default = 1,
    })
    
    local Autoplant = Tabs.Main:AddToggle("Autoplant", {Title = "Auto Plant", Default = false })
    local Autocollect = Tabs.Main:AddToggle("Autocollect", {Title = "Auto Collect Grow Plant", Default = false })
    local Autosell = Tabs.Main:AddToggle("Autosell", {Title = "Auto Sell", Default = false })
end
Window:SelectTab(1)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("growagarden")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("ALUMILAI/growagarden")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
---[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
local pointport = 1
local selling = false

local function collect()
    for i,v in ipairs(port[1].Parent.Parent:FindFirstChild("Plants_Physical"):GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if v.Enabled then
                fireproximityprompt(v)
            end
        end
    end
end
function TP(Position)
    local distance = (Position.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    speed = 200
    game:GetService("TweenService"):Create(
    game.Players.LocalPlayer.Character.HumanoidRootPart, 
    TweenInfo.new(distance/speed, Enum.EasingStyle.Linear),
    {CFrame = Position}
    ):Play()
    if pointport == 6 then
        pointport = 1
    else
        pointport += 1
    end
    wait(distance/speed + .3)
end

_G.a = true
while _G.a do wait()
    if Options.Autobuy.Value then
        game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(Options.Seed.Value)
    end
    if Options.Autoplant.Value then
        local plrseed = {}
        for i,v in ipairs(game.Players.LocalPlayer.Backpack:GetChildren())do
            if v:GetAttribute("Seed") then
                table.insert(plrseed, v)
            end
        end
        local isequip
        local seedequip
        for i,v in ipairs(game.Players.LocalPlayer.Character:GetChildren())do
            if v:GetAttribute("Seed") then
                isequip = true
                seedequip = v
            end
        end
        if isequip then
           plantremote:FireServer(port[math.random(1,2)].Position + Vector3.new(math.random(-10,10),10,math.random(-20,20)), seedequip:GetAttribute("Seed"))
        else
            for i,v in plrseed do
                local character = game:GetService("Players").LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    humanoid:EquipTool(v)
                    plantremote:FireServer(port[math.random(1,2)].Position + Vector3.new(math.random(-10,10),10,math.random(-20,20)), v:GetAttribute("Seed"))
                end
            end
        end
        isequip = false
        plrseed = {}
    end
    if Options.Autocollect.Value then
        if not selling then
            if pointport == 1 then
                TP(CFrame.new(port[1].Position + Vector3.new(0,3,20)))
            elseif pointport == 2 then
                TP(CFrame.new(port[1].Position))
            elseif pointport == 3 then
                TP(CFrame.new(port[1].Position + Vector3.new(0,3,-20)))
            elseif pointport == 4 then
                TP(CFrame.new(port[2].Position + Vector3.new(0,3,20)))
            elseif pointport == 5 then
                TP(CFrame.new(port[2].Position))
            elseif pointport == 6 then
                TP(CFrame.new(port[2].Position + Vector3.new(0,3,-20)))
            end
            collect()
        end
    end
    if Options.Autosell.Value then
        local hasfruit = false
        for i,v in ipairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren())do
            for a,b in v:GetAttributes()do
                if a == "Favorite" then
                   hasfruit = true
                end
            end
        end
        if hasfruit then
            selling = true
            TP(CFrame.new(61.5893021, 2.99999976, 0.426788121, -0.00246635987, 6.65097133e-08, -0.99999696, -1.50533871e-12, 1, 6.65099193e-08, 0.99999696, 1.65542732e-10, -0.00246635987))
            sellremote:FireServer() 
            selling = false
        end
        hasfruit = false
    end
end
















