local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup if the script is loaded again
local oldGui = playerGui:FindFirstChild("RynScript")
if oldGui then
	oldGui:Destroy()
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "RynScript"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--------------------------------------------------
-- LOADING SCREEN
--------------------------------------------------

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.fromOffset(360, 180)
loadingFrame.Position = UDim2.fromScale(0.5, 0.5)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = gui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 14)
loadingCorner.Parent = loadingFrame

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Size = UDim2.new(1, -40, 0, 35)
loadingTitle.Position = UDim2.fromOffset(20, 25)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "Ryn Script"
loadingTitle.TextColor3 = Color3.new(1, 1, 1)
loadingTitle.TextSize = 25
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -40, 0, 25)
loadingText.Position = UDim2.fromOffset(20, 65)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(170, 170, 180)
loadingText.TextSize = 14
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = loadingFrame

local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(1, -40, 0, 8)
barBackground.Position = UDim2.new(0, 20, 1, -35)
barBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
barBackground.BorderSizePixel = 0
barBackground.Parent = loadingFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBackground

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bar.BorderSizePixel = 0
bar.Parent = barBackground

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = bar

-- Animate loading bar
for i = 0, 100 do
	bar.Size = UDim2.new(i / 100, 0, 1, 0)
	loadingText.Text = "Loading... " .. i .. "%"
	task.wait(0.025)
end

task.wait(0.3)

--------------------------------------------------
-- MAIN WINDOW
--------------------------------------------------

loadingFrame:Destroy()

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(430, 300)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 45)
title.Position = UDim2.fromOffset(15, 12)
title.BackgroundTransparency = 1
title.Text = "Ryn Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -30, 0, 25)
subtitle.Position = UDim2.fromOffset(15, 50)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Local test interface"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 160)
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

--------------------------------------------------
-- BUTTON CREATOR
--------------------------------------------------

local function createButton(text, y)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -30, 0, 45)
	button.Position = UDim2.fromOffset(15, y)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 15
	button.Font = Enum.Font.GothamMedium
	button.AutoButtonColor = false
	button.Parent = main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = button

	button.MouseEnter:Connect(function()
		TweenService:Create(
			button,
			TweenInfo.new(0.15),
			{BackgroundColor3 = Color3.fromRGB(45, 45, 52)}
		):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(
			button,
			TweenInfo.new(0.15),
			{BackgroundColor3 = Color3.fromRGB(30, 30, 36)}
		):Play()
	end)

	return button
end

local espButton = createButton("ESP : OFF", 90)
local flyButton = createButton("Fly : OFF", 145)
local closeButton = createButton("Close", 200)

--------------------------------------------------
-- ESP
--------------------------------------------------

local espEnabled = false
local espObjects = {}

local function removeESP(target)
	local highlight = espObjects[target]

	if highlight then
		highlight:Destroy()
		espObjects[target] = nil
	end
end

local function addESP(target)
	if target == player then
		return
	end

	if not target.Character then
		return
	end

	if espObjects[target] then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "RynESP"
	highlight.FillTransparency = 0.65
	highlight.OutlineTransparency = 0
	highlight.Parent = target.Character

	espObjects[target] = highlight
end

local function updateESP()
	for _, target in ipairs(Players:GetPlayers()) do
		if target ~= player then
			if espEnabled then
				addESP(target)
			else
				removeESP(target)
			end
		end
	end
end

espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled

	if espEnabled then
		espButton.Text = "ESP : ON"
	else
		espButton.Text = "ESP : OFF"
	end

	updateESP()
end)

Players.PlayerAdded:Connect(function(target)
	target.CharacterAdded:Connect(function()
		task.wait(1)

		if espEnabled then
			addESP(target)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(target)
	removeESP(target)
end)

--------------------------------------------------
-- FLY
--------------------------------------------------

local flyEnabled = false
local flyConnection
local bodyVelocity
local bodyGyro

local function stopFly()
	flyEnabled = false

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end

	if bodyGyro then
		bodyGyro:Destroy()
		bodyGyro = nil
	end
end

local function startFly()
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		return
	end

	flyEnabled = true

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = root

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.P = 10000
	bodyGyro.Parent = root

	flyConnection = RunService.RenderStepped:Connect(function()
		if not flyEnabled or not root.Parent then
			return
		end

		local camera = workspace.CurrentCamera
		local direction = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			direction += camera.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			direction -= camera.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			direction -= camera.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			direction += camera.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			direction += Vector3.new(0, 1, 0)
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			direction -= Vector3.new(0, 1, 0)
		end

		if direction.Magnitude > 0 then
			direction = direction.Unit
		end

		bodyVelocity.Velocity = direction * 60
		bodyGyro.CFrame = camera.CFrame
	end)
end

flyButton.MouseButton1Click:Connect(function()
	if flyEnabled then
		stopFly()
		flyButton.Text = "Fly : OFF"
	else
		startFly()
		flyButton.Text = "Fly : ON"
	end
end)

--------------------------------------------------
-- CLOSE
--------------------------------------------------

closeButton.MouseButton1Click:Connect(function()
	stopFly()

	for target, highlight in pairs(espObjects) do
		if highlight then
			highlight:Destroy()
		end
	end

	gui:Destroy()
end)

--------------------------------------------------
-- CHARACTER RESPAWN
--------------------------------------------------

player.CharacterAdded:Connect(function()
	if flyEnabled then
		stopFly()
		flyButton.Text = "Fly : OFF"
	end
end)
