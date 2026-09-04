local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Interface principale
local gui = Instance.new("ScreenGui")
gui.Name = "RynLoading"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Cadre
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 150)
frame.Position = UDim2.new(0.5, -160, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Coins arrondis
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 35)
title.Position = UDim2.new(0, 15, 0, 20)
title.BackgroundTransparency = 1
title.Text = "Ryn Script Loading"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Texte de chargement
local loading = Instance.new("TextLabel")
loading.Size = UDim2.new(1, -30, 0, 25)
loading.Position = UDim2.new(0, 15, 0, 65)
loading.BackgroundTransparency = 1
loading.Text = "Loading"
loading.TextColor3 = Color3.fromRGB(170, 170, 180)
loading.TextSize = 15
loading.Font = Enum.Font.Gotham
loading.Parent = frame

-- Petit point animé
local dot = Instance.new("TextLabel")
dot.Size = UDim2.new(0, 20, 0, 20)
dot.Position = UDim2.new(0.5, 60, 0, 67)
dot.BackgroundTransparency = 1
dot.Text = "."
dot.TextColor3 = Color3.fromRGB(255, 255, 255)
dot.TextSize = 18
dot.Font = Enum.Font.GothamBold
dot.Parent = frame

-- Animation du cadre
frame.BackgroundTransparency = 1
title.TextTransparency = 1
loading.TextTransparency = 1
dot.TextTransparency = 1

TweenService:Create(
	frame,
	TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{BackgroundTransparency = 0}
):Play()

TweenService:Create(
	title,
	TweenInfo.new(0.5),
	{TextTransparency = 0}
):Play()

TweenService:Create(
	loading,
	TweenInfo.new(0.5),
	{TextTransparency = 0}
):Play()

TweenService:Create(
	dot,
	TweenInfo.new(0.5),
	{TextTransparency = 0}
):Play()

-- Animation des points
task.spawn(function()
	while gui.Parent do
		for i = 1, 3 do
			dot.Text = string.rep(".", i)
			task.wait(0.4)
		end
	end
end)
