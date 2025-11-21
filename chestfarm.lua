local AutoChest = {}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local sea

if game.PlaceId == 4442272183 then
    sea = 2
end

if not getgenv().ChestLocation then getgenv().ChestLocation = {} end

local Islands = {
    [2] = {
        {Name = "Dressrosa",        Position = Vector3.new(-381.31109619140625, 373.7752990722656, 712.6630859375)},
        {Name = "Mini2",            Position = Vector3.new(-5162.13720703125, 259.2460021972656, 2390.263671875)},
        {Name = "GraveIsland",      Position = Vector3.new(-5620.77587890625, 492.51043701171875, -778.916015625)},
        {Name = "GhostShipInterior",Position = Vector3.new(-6496.89794921875, 89.03500366210938, -116.50900268554688)},
        {Name = "GreenBit",         Position = Vector3.new(-2413.85693359375, 199.2963409423828, -3343.087158203125)},
        {Name = "CircleIsland",     Position = Vector3.new(-5688.5244140625, 161.68051147460938, -5059.83349609375)},
        {Name = "ForgottenIsland",  Position = Vector3.new(-3121.372802734375, 339.6866149902344, -10349.1767578125)},
        {Name = "IceCastle",        Position = Vector3.new(5598.82958984375, 362.0080261230469, -6688.6298828125)},
        {Name = "SnowMountain",     Position = Vector3.new(838.9915161132812, 492.3343505859375, -5379.8388671875)},
        {Name = "DarkbeardArena",   Position = Vector3.new(3664.618896484375, 137.927734375, -3665.089111328125)},
        {Name = "Mini1",            Position = Vector3.new(4791.00146484375, 253.58216857910156, 2851.848388671875)},
    }
}

function AutoChest:Fly(target)
    if self.FlyThread then self.FlyThread = task.cancel(self.FlyThread) end
    
    if not self.FlyVelocity then
        self.FlyVelocity = Instance.new("BodyVelocity")
    end

    if target then
        self.FlyThread = task.spawn(function()
            local startPos = Vector3.new()

            while task.wait() do
                local hum = Player.Character:FindFirstChildOfClass("Humanoid")

                if not hum or hum.Health <= 0 then
                    continue
                end

                pcall(function()
                    self.FlyVelocity.Parent = Player.Character.UpperTorso

                    local hrp = Player.Character.HumanoidRootPart

                    if (startPos - hrp.Position).Magnitude > 100 then
                        startPos = hrp.Position
                    end

                    local des = typeof(target) == "Instance" and target:GetPivot().Position or target
                    local dir = (des - startPos).Unit

                    local newPos = startPos + dir * 3
                    hrp.Parent:PivotTo(CFrame.new(newPos))
                    startPos = newPos
                end)
            end
        end)

    else
        self.FlyVelocity.Parent = nil
    end
end

function InsertIslandChestLoaction(island)
    if not getgenv().ChestLocation[island] then
        getgenv().ChestLocation[island] = {}

        for _, v in workspace:WaitForChild("Map")[island]:GetDescendants() do
            if string.find(v.Name, "Chest") and v:IsA("BasePart") then
                table.insert(getgenv().ChestLocation[island], v)
            end
        end
    end
end

function IsChestExist(chestLoaction)
    for _, v in workspace:WaitForChild("ChestModels"):GetChildren() do
        if (v:GetPivot().Position - chestLoaction.Position).Magnitude < 10 then
            return true
        end
    end
end

-----------------------------------------------------------------------------------------GUI----------------------------------------------------------------------------------------------------
function gui()
	for i,v in game:GetService("CoreGui"):GetChildren() do
		if v.Name == "Chestfarmgui" then
			v:Destroy()
		end
	end

	local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local toggle = Instance.new("ImageButton")
    local UIGradient = Instance.new("UIGradient")
    local UISizeConstraint = Instance.new("UISizeConstraint")
    local header = Instance.new("TextLabel")
    local UIGradient_2 = Instance.new("UIGradient")
    local UISizeConstraint_2 = Instance.new("UISizeConstraint")
    local credit = Instance.new("TextLabel")
    local version = Instance.new("TextLabel")
    local UIScale = Instance.new("UIScale")
    local Menu = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local minimize = Instance.new("TextButton")
    local UICorner_2 = Instance.new("UICorner")
    local Close = Instance.new("TextButton")
    local UICorner_3 = Instance.new("UICorner")
    local ImageLabel = Instance.new("ImageLabel")

    ScreenGui.Name = "Chestfarmgui"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Position = UDim2.new(0.0451086722, 0, 0.165085033, 0)
    Frame.Size = UDim2.new(0, 360, 0, 144)

    UICorner.CornerRadius = UDim.new(0.100000001, 0)
    UICorner.Parent = Frame

    toggle.Name = "toggle"
    toggle.Parent = Frame
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.BackgroundColor3 = Color3.fromRGB(255, 247, 0)
    toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    toggle.BorderSizePixel = 0
    toggle.Position = UDim2.new(1, 0, 0, 70)
    toggle.Size = UDim2.new(0, 360, 0, 40)
    toggle.Image = "rbxassetid://119819533222441"
    toggle.ImageColor3 = Color3.fromRGB(17, 255, 0)
    toggle.ScaleType = Enum.ScaleType.Fit

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.93, Color3.fromRGB(147, 147, 147)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(117, 117, 117))}
    UIGradient.Rotation = 90
    UIGradient.Parent = toggle

    UISizeConstraint.Parent = toggle
    UISizeConstraint.MaxSize = Vector2.new(360, 40)
    UISizeConstraint.MinSize = Vector2.new(360, 40)

    header.Name = "header"
    header.Parent = Frame
    header.AnchorPoint = Vector2.new(1, 0)
    header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    header.BackgroundTransparency = 1.000
    header.BorderColor3 = Color3.fromRGB(0, 0, 0)
    header.BorderSizePixel = 0
    header.Position = UDim2.new(0.983333349, 0, 0, 4)
    header.Size = UDim2.new(0, 350, 0, 40)
    header.Font = Enum.Font.GothamBold
    header.Text = "AUTO CHEST"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextScaled = true
    header.TextSize = 14.000
    header.TextWrapped = true

    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(216, 216, 216)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
    UIGradient_2.Parent = header

    UISizeConstraint_2.Parent = header
    UISizeConstraint_2.MaxSize = Vector2.new(350, 40)
    UISizeConstraint_2.MinSize = Vector2.new(350, 40)

    credit.Name = "credit"
    credit.Parent = Frame
    credit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    credit.BackgroundTransparency = 1.000
    credit.BorderColor3 = Color3.fromRGB(0, 0, 0)
    credit.BorderSizePixel = 0
    credit.Position = UDim2.new(0, 5, 0, 121)
    credit.Size = UDim2.new(0, 162, 0, 21)
    credit.Font = Enum.Font.SourceSansBold
    credit.Text = "by ALUMILAI"
    credit.TextColor3 = Color3.fromRGB(221, 221, 221)
    credit.TextScaled = true
    credit.TextSize = 14.000
    credit.TextWrapped = true
    credit.TextXAlignment = Enum.TextXAlignment.Left

    version.Name = "version"
    version.Parent = Frame
    version.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    version.BackgroundTransparency = 1.000
    version.BorderColor3 = Color3.fromRGB(0, 0, 0)
    version.BorderSizePixel = 0
    version.Position = UDim2.new(0, 191, 0, 121)
    version.Size = UDim2.new(0, 162, 0, 21)
    version.Font = Enum.Font.SourceSansBold
    version.Text = "New version"
    version.TextColor3 = Color3.fromRGB(221, 221, 221)
    version.TextScaled = true
    version.TextSize = 14.000
    version.TextWrapped = true
    version.TextXAlignment = Enum.TextXAlignment.Right

    UIScale.Parent = Frame

    Menu.Name = "Menu"
    Menu.Parent = Frame
    Menu.AnchorPoint = Vector2.new(1, 0)
    Menu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Menu.BackgroundTransparency = 1.000
    Menu.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Menu.BorderSizePixel = 0
    Menu.Position = UDim2.new(1, 0, 0, 0)
    Menu.Size = UDim2.new(0.277777791, 0, 0.138888896, 0)

    UIListLayout.Parent = Menu
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    UIPadding.Parent = Menu
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 5)

    minimize.Name = "minimize"
    minimize.Parent = Menu
    minimize.Active = false
    minimize.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
    minimize.BorderSizePixel = 0
    minimize.Position = UDim2.new(0.938888907, -10, 0, 5)
    minimize.Selectable = false
    minimize.Size = UDim2.new(0, 15, 0, 15)
    minimize.Text = ""

    UICorner_2.CornerRadius = UDim.new(1, 0)
    UICorner_2.Parent = minimize

    Close.Name = "Close"
    Close.Parent = Menu
    Close.Active = false
    Close.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
    Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.LayoutOrder = 1
    Close.Position = UDim2.new(0.938888907, -10, 0, 5)
    Close.Selectable = false
    Close.Size = UDim2.new(0, 15, 0, 15)
    Close.Text = ""

    UICorner_3.CornerRadius = UDim.new(1, 0)
    UICorner_3.Parent = Close

    ImageLabel.Parent = Frame
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel.BackgroundTransparency = 1.000
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Position = UDim2.new(0.438888878, 0, 0, 96)
    ImageLabel.Size = UDim2.new(0, 40, 0, 40)
    ImageLabel.Image = "rbxassetid://6947202399"

    if game:GetService("UserInputService").TouchEnabled then
        UIScale.Scale = 0.5
    end

    return ScreenGui, Frame, toggle, minimize, Close
end

local ScreenGui, Frame, toggle, minimize, Close = gui()
local uis = game:GetService("UserInputService")
local dargging
local draginput
local dragstart
local startpos
local function update(input)
	local delta = input.Position - dragstart
	Frame.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
end
Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragstart = input.Position
		startpos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touce then
		draginput = input
	end
end)
uis.InputChanged:Connect(function(input)
	if input == draginput and dragging then
		if Frame.Visible then
			update(input)
		end
	end
end)
--------------------------------------------------------------------------------------close-gui-----------------------------------------------------------------------------------------------------
Close.MouseButton1Click:Connect(function()
	closeall = true
	AutoChest:Clear()
end)
------------------------------------------------------------------------------------toggle-on/off-----------------------------------------------------------------------------------------------------
toggle.MouseButton1Click:Connect(function()
    AutoChest.Status = not AutoChest.Status

    toggle.ImageColor3 = AutoChest.Status and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

local mini = false
minimize.MouseButton1Click:Connect(function()
    mini = not mini

    if mini then
        game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(0, 359, 0, 47)}):Play()
    else
        game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(0, 359, 0, 144)}):Play()
    end
end)

function AutoChest:Clear()
    if AutoChest.MainLoop then task.cancel(AutoChest.MainLoop) end
    if AutoChest.FlyThread then task.cancel(AutoChest.FlyThread) end
    if AutoChest.SitHandler then task.cancel(AutoChest.SitHandler) end
    if self.FlyVelocity then self.FlyVelocity:Destroy() end
    if ScreenGui then ScreenGui:Destroy() end
end

AutoChest.MainLoop = task.spawn(function()
    AutoChest.Status = true
    
    while task.wait() do
        for _, islandInfo in Islands[sea] do
            local island = islandInfo.Name
            local islandPos = islandInfo.Position

            if not getgenv().ChestLocation[island] then
                AutoChest:Fly(islandPos)

                if island == "GhostShipInterior" then
                    AutoChest:Fly()

                    firetouchinterest(workspace.Map.GhostShip.Teleport, Player.Character.UpperTorso, 1)
                    firetouchinterest(workspace.Map.GhostShip.Teleport, Player.Character.UpperTorso, 0)
                else
                    repeat
                        task.wait(0.1)
                        if not AutoChest.Status and AutoChest.FlyThread then
                            AutoChest:Fly()
                        elseif AutoChest.Status and not AutoChest.FlyThread then
                            AutoChest:Fly(islandPos)
                        end
                    until (Player.Character.HumanoidRootPart.Position - islandPos).Magnitude < 10 and AutoChest.Status
                end
                InsertIslandChestLoaction(island)
            end

            if island == "GhostShipInterior" then
                AutoChest:Fly()

                firetouchinterest(workspace.Map.GhostShip.Teleport, Player.Character.UpperTorso, 1)
                firetouchinterest(workspace.Map.GhostShip.Teleport, Player.Character.UpperTorso, 0)

                task.wait(2)
            end

            for _, chestLoacte in getgenv().ChestLocation[island] do
                local chestPos = chestLoacte.Position

                AutoChest:Fly(chestPos)

                repeat task.wait(0.1)
                    if not AutoChest.Status and AutoChest.FlyThread then
                        AutoChest:Fly()
                    elseif AutoChest.Status and not AutoChest.FlyThread then
                        AutoChest:Fly(chestPos)
                    end
                until (Player.Character.HumanoidRootPart.Position - chestPos).Magnitude < 1300 and AutoChest.Status

                if IsChestExist(chestLoacte) then
                    repeat task.wait(0.1)
                        if not AutoChest.Status and AutoChest.FlyThread then
                            AutoChest:Fly()
                        elseif AutoChest.Status and not AutoChest.FlyThread then
                            AutoChest:Fly(chestPos)
                        end
                    until (Player.Character.HumanoidRootPart.Position - chestPos).Magnitude < 20 and AutoChest.Status
                
                    firetouchinterest(chestLoacte, Player.Character.UpperTorso, 1)
                    firetouchinterest(chestLoacte, Player.Character.UpperTorso, 0)
                end
            end

            if island == "GhostShipInterior" then
                firetouchinterest(workspace.Map.GhostShipInterior.Teleport, Player.Character.UpperTorso, 1)
                firetouchinterest(workspace.Map.GhostShipInterior.Teleport, Player.Character.UpperTorso, 0)

                task.wait(2)
            end
        end
    end
end)

AutoChest.SitHandler = task.spawn(function()
    local function onSit()
        if Player.Character.Humanoid.Sit then
            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    if Player.Character then
        Player.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Sit"):Connect(onSit)
    end

    Player.CharacterAdded:Connect(function(char) char:WaitForChild("Humanoid"):GetPropertyChangedSignal("Sit"):Connect(onSit) end)
end)

if _G.AutoChestEnv then print("clear") _G.AutoChestEnv:Clear() end

_G.AutoChestEnv = AutoChest
