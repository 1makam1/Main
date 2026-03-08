local studio = game:GetService("RunService"):IsStudio()
local path = studio and script.Parent or game:GetService("CoreGui")

if path:FindFirstChild("Apex Universal Script") then return end

local ScreenGui = Instance.new("ScreenGui", path)
local Container = Instance.new("Frame", ScreenGui)
local List = Instance.new("ScrollingFrame", Container)

local Colors = {
	Green = {R = 17, G = 53, B = 29},
	Yellow = {R = 53, G = 49, B = 16},
	Red = {R = 53, G = 15, B = 15}
}

local function InitContainer()
	local AspectRatio = Instance.new("UIAspectRatioConstraint", Container) 
	local UICorner = Instance.new("UICorner", List)
	local UIListLayout = Instance.new("UIListLayout", List)
	
	ScreenGui.Name = "Apex Universal Script"
	
	Container.Name = "Container"
	Container.BackgroundTransparency = 1
	Container.Position = UDim2.fromScale(0.089, 0.106)
	Container.Size = UDim2.fromScale(0.172, 0.297)
	AspectRatio.AspectRatio = 0.906

	List.Name = "List"
	List.BackgroundColor3 = Color3.fromRGB(9, 9, 11)
	List.Size = UDim2.fromScale(1, 1)
	List.AutomaticCanvasSize = Enum.AutomaticSize.Y
	List.CanvasSize = UDim2.new()
	List.ScrollingDirection = Enum.ScrollingDirection.Y
	List.ScrollBarThickness = 0
	UICorner.CornerRadius = UDim.new(0, 8)

	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local UIS = game:GetService("UserInputService")
	local dragging
	local offset
	
	local function ValidInput(input)
		local input_type = input.UserInputType
		
		return input_type == Enum.UserInputType.MouseButton1 or input_type == Enum.UserInputType.Touch
	end
	
	local function Drag()
		if not dragging then return end
		
		local newinput = UIS.InputChanged:Wait()
		local input_type = newinput.UserInputType
		
		if input_type == Enum.UserInputType.MouseMovement or input_type == Enum.UserInputType.Touch then
			Container.Position = UDim2.fromOffset(newinput.Position.X + offset.X, newinput.Position.Y + offset.Y)
		end
		
		Drag()
	end
	
	Container.InputBegan:Connect(function(input)
		if ValidInput(input) then
			dragging = true
			offset = Container.AbsolutePosition - Vector2.new(input.Position.X, input.Position.Y)
			Drag()
		end
	end)
	
	UIS.InputBegan:Connect(function(input, gpc)
		if gpc then return end
		
		if input == Enum.KeyCode.LeftAlt then
			ScreenGui.Enabled = not ScreenGui.Enabled
		end
	end)
	
	UIS.InputEnded:Connect(function(input)
		if ValidInput(input) then
			dragging = false
		end
	end)
end

local function InitAutoExecute()
	local queueteleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
	local Player = game:GetService("Players").LocalPlayer
	local TeleportCheck = false

	Player.OnTeleport:Connect(function(State)
		if (not TeleportCheck) and queueteleport then
			TeleportCheck = true
			queueteleport("https://raw.githubusercontent.com/1makam1/Main/refs/heads/main/Apex%20Universal%20Script/Init.luau")
		end
	end)
end

local function MakeSection(sectionName: string)
	local section = Instance.new("TextLabel", List)
	section.Name = sectionName
	section.Text = sectionName
	section.BackgroundTransparency = 1
	section.Size = UDim2.fromScale(0.9, 0.1)
	section.LayoutOrder = #List:GetChildren() - 3
	section.FontFace = Font.fromName("Nunito", Enum.FontWeight.Bold)
	section.TextColor3 = Color3.fromRGB(255, 130, 130)
	section.TextScaled = true
end

local function MakeDivider()
	local divider = Instance.new("Frame", List)
	divider.BackgroundTransparency = 1
	divider.LayoutOrder = #List:GetChildren() - 3
	divider.Size = UDim2.fromScale(1, divider.LayoutOrder ~= 0 and 0.085 or 0.038)
end

local function MakeButton(buttonName: string, color: "Green" | "Yellow" | "Red")
	color = Colors[color] or Colors.Green
	
	local button_frame = Instance.new("Frame", List)
	button_frame.Name = buttonName
	button_frame.BackgroundTransparency = 1
	button_frame.LayoutOrder = #List:GetChildren() - 3
	button_frame.Size = UDim2.fromScale(1, 0.191)
	
	local button = Instance.new("TextButton", button_frame)
	button.Text = buttonName
	button.BackgroundColor3 = Color3.fromRGB(color.R, color.G, color.B)
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.Position = UDim2.fromScale(0.5, 0.5)
	button.Size = UDim2.fromScale(0.911, 0.844)
	button.FontFace = Font.fromName("Nunito", Enum.FontWeight.Bold)
	button.TextColor3 = Color3.fromRGB(color.R*4.5, color.G*4.5, color.B*4.5)
	button.TextScaled = true
	
	local button_coner = Instance.new("UICorner", button)
	button_coner.CornerRadius = UDim.new(0.3, 0)
	
	local button_padding = Instance.new("UIPadding", button)
	button_padding.PaddingBottom = UDim.new(0.2, 0)
	button_padding.PaddingTop = UDim.new(0.2, 0)
	
	local button_stroke = Instance.new("UIStroke", button)
	button_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	button_stroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	button_stroke.Color = Color3.fromRGB(color.R*2, color.G*2, color.B*2)
	button_stroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	button_stroke.Thickness = 0.05

	button.MouseButton1Click:Connect(function()
		local file = "https://raw.githubusercontent.com/1makam1/Main/refs/heads/main/Apex%20Universal%20Script/"..buttonName:gsub(" ", "%%20")..".luau"

		loadstring(game:HttpGet(file))()
	end)
end

InitContainer()
InitAutoExecute()

MakeDivider()
MakeSection("——— Universal ———")
MakeButton("Infinite Yield")
MakeButton("REM")

MakeDivider()
MakeSection("— Explorer Debugger —")
MakeButton("Dark Dex")
MakeButton("Dark Dex ++")

MakeDivider()
MakeSection("——— Remote Spy ———")
MakeButton("Cobalt")
MakeButton("Hydroxide")
MakeButton("Simple Spy")
MakeButton("Sigma Spy")

MakeDivider()
MakeSection("———— Player ————")
MakeButton("Get CFrame")
MakeButton("Get Position")

MakeDivider()
MakeSection("———— Server ————")
MakeButton("Rejoin")
MakeButton("Server Hop")
MakeButton("Get PlaceId")
MakeButton("Get JobId")

MakeDivider()
MakeSection("——— Command ———")
MakeButton("Fly")
MakeButton("UNC Check")
