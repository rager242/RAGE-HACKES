--// UNIVERSAL AIMBOT - SILENT AIM ON CLICK

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local silentAimEnabled = false
local teamCheck = true
local maxDistance = 500
local smoothness = 0.1

print("✓ Silent Aim script loaded!")

---------------------------------------------------------------------
-- MOBILE UI SETUP
---------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "AimbotUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 60, 0, 60)
button.Position = UDim2.new(1, -80, 0, 10)
button.Text = "◄"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
button.TextColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 0
button.ZIndex = 10
button.Font = Enum.Font.GothamBold

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 280, 0, 250)
panel.Position = UDim2.new(1, -300, 0, 10)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.BorderSizePixel = 2
panel.BorderColor3 = Color3.fromRGB(80, 80, 80)
panel.ZIndex = 9
panel.Visible = false

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "⚔️ SILENT AIM"
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.BorderSizePixel = 0
title.Font = Enum.Font.GothamBold

local statusLabel = Instance.new("TextLabel", panel)
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 60)
statusLabel.Text = "Status: OFF"
statusLabel.TextScaled = true
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
statusLabel.Font

