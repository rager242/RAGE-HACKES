--// AIMBOT FOR RIVALS (R6 + R15 + MOBILE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local aimbotEnabled = false
local silentAimEnabled = false

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
panel.Size = UDim2.new(0, 280, 0, 320)
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
title.Text = "⚔️ RIVALS AIM"
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
statusLabel.Font = Enum.Font.Gotham

local toggleButton = Instance.new("TextButton", panel)
toggleButton.Size = UDim2.new(0.9, 0, 0, 55)
toggleButton.Position = UDim2.new(0.05, 0, 0, 110)
toggleButton.Text = "▶ AIMBOT ON"
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.BorderSizePixel = 0
toggleButton.Font = Enum.Font.GothamBold
toggleButton.ZIndex = 11

local silentStatusLabel = Instance.new("TextLabel", panel)
silentStatusLabel.Size = UDim2.new(1, -20, 0, 40)
silentStatusLabel.Position = UDim2.new(0, 10, 0, 175)
silentStatusLabel.Text = "Silent Aim: OFF"
silentStatusLabel.TextScaled = true
silentStatusLabel.BackgroundTransparency = 1
silentStatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
silentStatusLabel.Font = Enum.Font.Gotham

local silentToggleButton = Instance.new("TextButton", panel)
silentToggleButton.Size = UDim2.new(0.9, 0, 0, 55)
silentToggleButton.Position = UDim2.new(0.05, 0, 0, 225)
silentToggleButton.Text = "▶ SILENT ON"
silentToggleButton.TextScaled = true
silentToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
silentToggleButton.TextColor3 = Color3.new(0, 0, 0)
silentToggleButton.BorderSizePixel = 0
silentToggleButton.Font = Enum.Font.GothamBold
silentToggleButton.ZIndex = 11

---------------------------------------------------------------------
-- MOBILE UI FUNCTIONALITY
---------------------------------------------------------------------
local panelOpen = false

button.MouseButton1Click:Connect(function()
	panelOpen = not panelOpen
	panel.Visible = panelOpen
	button.Text = panelOpen and "►" or "◄"
end)

local function updateUI()
	if aimbotEnabled then
		statusLabel.Text = "Status: ON ✓"
		statusLabel.TextColor3 = Color3.fromRGB(60, 255, 60)
		toggleButton.Text = "⊗ AIMBOT OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		toggleButton.TextColor3 = Color3.new(1, 1, 1)
	else
		statusLabel.Text = "Status: OFF"
		statusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
		toggleButton.Text = "▶ AIMBOT ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
		toggleButton.TextColor3 = Color3.new(0, 0, 0)
	end
	
	if silentAimEnabled then
		silentStatusLabel.Text = "Silent Aim: ON ✓"
		silentStatusLabel.TextColor3 = Color3.fromRGB(60, 255, 60)
		silentToggleButton.Text = "⊗ SILENT OFF"
		silentToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		silentToggleButton.TextColor3 = Color3.new(1, 1, 1)
	else
		silentStatusLabel.Text = "Silent Aim: OFF"
		silentStatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
		silentToggleButton.Text = "▶ SILENT ON"
		silentToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
		silentToggleButton.TextColor3 = Color3.new(0, 0, 0)
	end
end

toggleButton.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	updateUI()
end)

silentToggleButton.MouseButton1Click:Connect(function()
	silentAimEnabled = not silentAimEnabled
	updateUI()
end)

-- Keyboard support (for PC testing)
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		aimbotEnabled = not aimbotEnabled
		updateUI()
	elseif input.KeyCode == Enum.KeyCode.L then
		silentAimEnabled = not silentAimEnabled
		updateUI()
	end
end)

---------------------------------------------------------------------
-- FIND CLOSEST ENEMY (Rivals)
---------------------------------------------------------------------
local function getClosestEnemy()
	local closest = nil
	local shortestDist = math.huge

	-- Find all other players
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local character = otherPlayer.Character
			local head = character:FindFirstChild("Head")
			
			if head then
				local screenPos, visible = camera:WorldToViewportPoint(head.Position)
				if visible then
					local dist = (head.Position - camera.CFrame.Position).Magnitude

					if dist < shortestDist then
						shortestDist = dist
						closest = head
					end
				end
			end
		end
	end

	return closest
end

---------------------------------------------------------------------
-- SILENT AIM LOCK (forces weapon to aim at target)
---------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	if not silentAimEnabled then return end
	
	local head = getClosestEnemy()
	if head then
		local character = player.Character
		if character then
			-- Find equipped weapon
			local tool = character:FindFirstChildOfClass("Tool")
			if tool and tool:FindFirstChild("Handle") then
				local handle = tool.Handle
				handle.CFrame = CFrame.new(handle.Position, head.Position)
			end
		end
	end
end)

---------------------------------------------------------------------
-- AIMBOT LOOP
---------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	if not aimbotEnabled then return end

	local head = getClosestEnemy()
	if head then
		camera.CFrame = camera.CFrame:Lerp(
			CFrame.new(camera.CFrame.Position, head.Position),
			0.25
		)
	end
end)
