------------------------------------------------------------------------------------------variable---------------------------------------------------------------------------------------------
local chestcf = {}
local islandcf = {}
local islandnm = {}
local islandnumber = 1
local cislandnumber = false
local onisland = false
local maxchest = 0
local checkchest = false
local cstage = 1
local maxisland = 0
local csplus = false
local collecting = false
local sea = nil
local ongostship = false
local connection
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
-----------------------------------------------------------------------------------part-chest/stage-plus---------------------------------------------------------------------------------------------------
local iscspart = false
for i,v in ipairs(game.workspace:GetDescendants()) do
	if v.Name == "part chest" then
		cspart = v
		iscspart = true
	end
end
if not iscspart then
	cspart = Instance.new("Part")
	cspart.Parent = game.workspace
	cspart.Name = "part chest"
	cspart.Anchored = true
	cspart.Transparency = 1
	cspart.CanCollide = false
end
cspart.Touched:Connect(function(part)
	local humanoid = part.Parent:FindFirstChild("Humanoid")
	if humanoid then
		if collecting and onisland and checkchest then
			csplus = true
		end
	end
end)
--------------------------------------------------------------------------------------part-island------------------------------------------------------------------------------------------------
local ispartis = false
for i,v in ipairs(game.workspace:GetDescendants()) do
	if v.Name == "part island" then
		partis = v
		ispartis = true
	end
end
if not ispartis then
	partis = Instance.new("Part")
	partis.Parent = game.workspace
	partis.Name = "part island"
	partis.Anchored = true
	partis.Transparency = 1
	partis.CanCollide = false
end
partis.Touched:Connect(function(part)
	local humanoid = part.Parent:FindFirstChild("Humanoid")
	if humanoid then
		onisland = true
	end
end)
------------------------------------------------------------------------------------------TP------------------------------------------------------------------------------------------------------
function TP(Position)
	local distance = (Position.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	speed = 200
	game:GetService("TweenService"):Create(
	game.Players.LocalPlayer.Character.HumanoidRootPart, 
	TweenInfo.new(distance/speed, Enum.EasingStyle.Linear),
	{CFrame = Position}
	):Play()
end
-----------------------------------------------------------------------------------insert-island/sea-----------------------------------------------------------------------------------------------
for i,v in ipairs(game.workspace.Map:GetChildren()) do
	if v.Name == "Fishmen" or v.Name == "MiniSky" or v.Name == "RaidMap" or v.Name == "Temple of Time" or v.Name == "WaterBase-Plane" or v.Name == "GhostShip" or v.Name == "IndraIsland" or v.Name == "CandyCane" or v.Name == "FortBuilderPotentialSurfaces" or v.Name == "FortBuilderPlacedSurfaces" or v.Name == "StagePart" then
		if v.Name == "GhostShip" then
			sea = 2
		end
	else
		table.insert(islandcf, v.WorldPivot)
		table.insert(islandnm, v.Name)
		maxisland = maxisland + 1
		if v.Name == "Boat Castle" then
			sea = 3
		end
	end
end
----------------------------------------------------------------------------------anti-afk----------------------------------------------------------------------------------------------------------
local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)
---------------------------------------------------------------------------------check-island-----------------------------------------------------------------------------------------------------
function checkonisland()
	if collecting == true then
		if cislandnumber == true then
			islandnumber = islandnumber + 1
			checkchest = false
			--print("change island")
			if islandnumber > maxisland then
				islandnumber = 1
				checkchest = false
				--print("change island")
			end
			onisland = false
			cislandnumber = false
			--print("island",islandnumber)
		end
		if partis.CFrame ~= islandcf[islandnumber] then
			partis.CFrame = islandcf[islandnumber]
			--print("change part location")
		end
		if onisland == true then
			e.Text = "Island : " .. tostring(islandnm[islandnumber])
		elseif sea == 2 and islandnm[islandnumber] == "GhostShipInterior" and ongostship == false then
			game.workspace.Map.GhostShip.Teleport.CanTouch = true
			game.workspace.Map.GhostShip.Teleport.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			wait(0.1)
			game.workspace.Map.GhostShip.Teleport.CFrame = CFrame.new(-6496.89795, 89.034996, -116.50946, 0.819155693, 0, -0.573571265, 0, -1.00000024, -0, -0.573571265, 0, -0.819156051)
			wait(2)
			game.workspace.Map.GhostShip.Teleport.CanTouch = false
			TP(partis.CFrame)
			wait(2)
			ongostship = true
		elseif sea == 2 and ongostship == true then
			game.workspace.Map.GhostShipInterior.Teleport.CanTouch = true
			game.workspace.Map.GhostShipInterior.Teleport.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			wait(0.1)
			game.workspace.Map.GhostShipInterior.Teleport.CFrame = CFrame.new(920.477539, 154.901001, 32838.9648, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			wait(2)
			game.workspace.Map.GhostShipInterior.Teleport.CanTouch = false
			ongostship = false
		else
			csplus = false
			TP(partis.CFrame)
		end
	end
end
-------------------------------------------------------------------------------------collect-chest------------------------------------------------------------------------------------------------
function collectchest()
	if onisland then
		if not checkchest then
			for i,v in ipairs(game.workspace.Map[islandnm[islandnumber]]:GetDescendants())do
				if v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3" then
					table.insert(chestcf, v.CFrame)
					--print("insertchestcf")
					maxchest = maxchest + 1
				end
			end
			checkchest = true
			g.Text = "Collect " .. cstage - 1 .. " / " .. maxchest
			--print("maxchest", maxchest)
			--print("checked chest")
		end

		if csplus == true then
			cstage = cstage + 1
			if cstage >= maxchest + 1 then
				for k in pairs(chestcf) do
					chestcf[k] = nil
					--print("remove chestcf")
				end
				e.Text = "Island : " .. tostring(islandnm[islandnumber]) .. " (done)"
				g.Text = "Collect " .. cstage - 1 .. " / " .. maxchest .. " (done)"
				cislandnumber = true
				cstage = 1
				maxchest = 0
				checkchest = false
				--print("done island")
			else
				TP(chestcf[cstage])
				g.Text = "Collect " .. cstage - 1 .. " / " .. maxchest
				--print(cstage)
			end
			wait(0.5)
			csplus = false
		else
			cspart.CFrame = chestcf[cstage]
			TP(chestcf[cstage])
		end
	end
end
---------------------------------------------------------------------------------------------noclip---------------------------------------------------------------------------------------------
function toggleNoclip()
	if collecting then
		if connection then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		else
			connection = RunService.Stepped:Connect(function()
				for _, part in pairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end)
		end
	else 
		if connection then
			connection:Disconnect()
		end
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end
-----------------------------------------------------------------------------------------GUI----------------------------------------------------------------------------------------------------
function gui()
	for i,v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren())do
		if v.Name == "Chestfarmgui" then
			v:Destroy()
			wait(0.5)
		end
	end
	s = Instance.new("ScreenGui")
	s.Name = "Chestfarmgui"
	s.Parent = game:GetService("Players").LocalPlayer.PlayerGui
	f = Instance.new("Frame")
	f.Parent = s
	f.Size = UDim2.new(0, 300, 0, 200)
	f.Position = UDim2.new(0, 6, 0, 40)
	f.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
	f.Active = true
	-- f.Draggable = true
	-- f.Selectable = true
	local corner = Instance.new("UICorner")
	corner.Parent = f
	corner.CornerRadius = UDim.new(0, 10)
	b = Instance.new("TextButton")
	b.Parent = f
	b.BackgroundColor3 = Color3.fromRGB(168, 168, 19)
	b.BorderColor3 = Color3.fromRGB(225, 225, 225)
	b.Size = UDim2.new(0, 300, 0, 30)
	b.Position = UDim2.new(0, 0, 0, 60)
	b.Text = "toggle on/off"
	b.TextSize = 15
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	local c = Instance.new("TextLabel")
	c.Parent = f
	c.BackgroundTransparency = 1
	c.Size = UDim2.new(0, 300, 0, 30)
	c.Text = "Chest collecting"
	c.TextColor3 = Color3.fromRGB(255, 255, 255)
	c.TextSize = 20
	local d = Instance.new("TextLabel")
	d.Parent = f
	d.BackgroundTransparency = 1
	d.Position = UDim2.new(0, 0, 0, 33)
	d.Size = UDim2.new(0, 300, 0, 20)
	d.Text = "by น้องหมูสุดหล่อเท่ 🐷"
	d.TextColor3 = Color3.fromRGB(255, 255, 255)
	d.TextSize = 15
	e = Instance.new("TextLabel")
	e.Parent = f
	e.BackgroundTransparency = 1
	e.Position = UDim2.new(0, 0, 0, 140)
	e.Size = UDim2.new(0, 300, 0, 20)
	e.Text = "Island : " .. "nil"
	e.TextColor3 = Color3.fromRGB(255, 255, 255)
	e.TextSize = 15
	g = Instance.new("TextLabel")
	g.Parent = f
	g.BackgroundTransparency = 1
	g.Position = UDim2.new(0, 0, 0, 170)
	g.Size = UDim2.new(0, 300, 0, 20)
	g.Text = "Collect : " .. "nil"
	g.TextColor3 = Color3.fromRGB(255, 255, 255)
	g.TextSize = 15
	h = Instance.new("TextLabel")
	h.Parent = f
	h.BackgroundTransparency = 1
	h.Position = UDim2.new(0, 0, 0, 100)
	h.Size = UDim2.new(0, 300, 0, 20)
	h.Text = "Status : 🔴"
	h.TextColor3 = Color3.fromRGB(255, 255, 255)
	h.TextSize = 20
	x = Instance.new("TextButton")
	x.Parent = f
	x.BackgroundColor3 = Color3.fromRGB(165, 0, 0)
	x.Size = UDim2.new(0, 30, 0, 30)
	x.Position = UDim2.new(0, 270, 0, 0)
	x.Text = "X"
	x.TextSize = 15
	x.TextColor3 = Color3.fromRGB(0, 0, 0)
	local corner2 = Instance.new("UICorner")
	corner2.Parent = x
	corner2.CornerRadius = UDim.new(0, 5)
end
gui()
local uis = game:GetService("UserInputService")
local dargging
local draginput
local dragstart
local startpos
local function update(input)
	local delta = input.Position - dragstart
	f.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
end
f.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragstart = input.Position
		startpos = f.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
f.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touce then
		draginput = input
	end
end)
uis.InputChanged:Connect(function(input)
	if input == draginput and dragging then
		if f.Visible then
			update(input)
		end
	end
end)
--------------------------------------------------------------------------------------close-gui-----------------------------------------------------------------------------------------------------
x.Activated:Connect(function()
	closeall = true
	s:Destroy()
end)
------------------------------------------------------------------------------------toggle-on/off-----------------------------------------------------------------------------------------------------
b.Activated:Connect(function()
	if collecting == true then
		collecting = false
		toggleNoclip()
		h.Text = "Status : 🔴"
		--print(collecting)
		csplus = false
		if sea == 3 then
			game.workspace.Map["Boat Castle"].MapTeleportB.Hitbox.CanTouch = true
			game.workspace.Map["Boat Castle"].MapTeleportA.Hitbox.CanTouch = true
		elseif sea == 2 then
			game.workspace.Map.GhostShip.Teleport.CanTouch = true
			game.workspace.Map.GhostShipInterior.Teleport.CanTouch = true
			for i,v in ipairs(workspace:GetDescendants())do
				if v:IsA("Seat") then
				    v.CanTouch = true
				end
			end
		end
	else
		collecting = true
		toggleNoclip()
		h.Text = "Status : 🟢"
		--print(collecting)
		csplus = false
		if sea == 3 then
			game.workspace.Map["Boat Castle"].MapTeleportB.Hitbox.CanTouch = false
			game.workspace.Map["Boat Castle"].MapTeleportA.Hitbox.CanTouch = false
		elseif sea == 2 then
			game.workspace.Map.GhostShip.Teleport.CanTouch = false
			game.workspace.Map.GhostShipInterior.Teleport.CanTouch = false
			for i,v in ipairs(workspace:GetDescendants())do
				if v:IsA("Seat") then
				    v.CanTouch = false
				end
			end
		end
	end
	pcall(function()
		while collecting == true do
			local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
			bv = hrp:FindFirstChildWhichIsA("BodyVelocity")
			if not bv then
				bv = Instance.new("BodyVelocity")
				bv.Parent = hrp
				bv.MaxForce = Vector3.new(0,math.huge,0)
				bv.Velocity = hrp.CFrame.Position * 0
				wait(0.2)
			end

			if not closeall then
				wait(0.1)
				toggleNoclip()
				checkonisland()
				collectchest()
				bv.MaxForce = Vector3.new(0,math.huge,0)
			else
				collecting = false
				bv:Destroy()
			end
		end
		if bv then
			bv.MaxForce = Vector3.new(0,0,0)
		end
		TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
	end)
end)
