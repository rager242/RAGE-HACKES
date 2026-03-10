--// UNIVERSAL AIMBOT (Works on ANY Roblox Game)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local aimbotEnabled = false
local silentAimEnabled = false
local teamCheck = true -- Ignore teammates
local maxDistance = 500 -- Max aimbot distance

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
panel.Size = UDim2.new(0, 280, 0, 400)
panel.Position = UDim2.new(1, -300, 0, 10)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.BorderSizePixel = 2
panel.BorderColor3 = Color3.fromRGB(80, 80, 80)
panel.ZIndex = 9
panel.Visible = false
panel.CanScroll = true
panel.ScrollingDirection = Enum.ScrollingDirection.Y

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "⚔️ UNIVERSAL AIM"
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
toggleButton.Size = UDim2.new(0.9, 0, 0, 50)
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
silentStatusLabel.Position = UDim2.new(0, 10, 0, 170)
silentStatusLabel.Text = "Silent Aim: OFF"
silentStatusLabel.TextScaled = true
silentStatusLabel.BackgroundTransparency = 1
silentStatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
silentStatusLabel.Font = Enum.Font.Gotham

local silentToggleButton = Instance.new("TextButton", panel)
silentToggleButton.Size = UDim2.new(0.9, 0, 0, 50)
silentToggleButton.Position = UDim2.new(0.05, 0, 0, 220)
silentToggleButton.Text = "▶ SILENT ON"
silentToggleButton.TextScaled = true
silentToggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
silentToggleButton.TextColor3 = Color3.new(0, 0, 0)
silentToggleButton.BorderSizePixel = 0
silentToggleButton.Font = Enum.Font.GothamBold
silentToggleButton.ZIndex = 11

local teamCheckLabel = Instance.new("TextLabel", panel)
teamCheckLabel.Size = UDim2.new(1, -20, 0, 35)
teamCheckLabel.Position = UDim2.new(0, 10, 0, 280)
teamCheckLabel.Text = "Team Check: ON ✓"
teamCheckLabel.TextScaled = true
teamCheckLabel.BackgroundTransparency = 1
teamCheckLabel.TextColor3 = Color3.fromRGB(60, 255, 60)
teamCheckLabel.Font = Enum.Font.Gotham

local teamCheckButton = Instance.new("TextButton", panel)
teamCheckButton.Size = UDim2.new(0.9, 0, 0, 50)
teamCheckButton.Position = UDim2.new(0.05, 0, 0, 320)
teamCheckButton.Text = "⊗ TEAM CHECK OFF"
teamCheckButton.TextScaled = true
teamCheckButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
teamCheckButton.TextColor3 = Color3.new(1, 1, 1)
teamCheckButton.BorderSizePixel = 0
teamCheckButton.Font = Enum.Font.GothamBold
teamCheckButton.ZIndex = 11

---------------------------------------------------------------------
-- UI FUNCTIONALITY
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
	
	if teamCheck then
		teamCheckLabel.Text = "Team Check: ON ✓"
		teamCheckLabel.TextColor3 = Color3.fromRGB(60, 255, 60)
		teamCheckButton.Text = "⊗ TEAM CHECK OFF"
		teamCheckButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		teamCheckButton.TextColor3 = Color3.new(1, 1, 1)
	else
		teamCheckLabel.Text = "Team Check: OFF"
		teamCheckLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
		teamCheckButton.Text = "▶ TEAM CHECK ON"
		teamCheckButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
		teamCheckButton.TextColor3 = Color3.new(0, 0, 0)
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

teamCheckButton.MouseButton1Click:Connect(function()
	teamCheck = not teamCheck
	updateUI()
end)

-- Keyboard support
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		aimbotEnabled = not aimbotEnabled
		updateUI()
	elseif input.KeyCode == Enum.KeyCode.L then
		silentAimEnabled = not silentAimEnabled
		updateUI()
	elseif input.KeyCode == Enum.KeyCode.T then
		teamCheck = not teamCheck
		updateUI()
	end
end)

---------------------------------------------------------------------
-- UNIVERSAL ENEMY DETECTION
---------------------------------------------------------------------
local function isEnemyTeam(otherPlayer)
	if not teamCheck then return true end
	
	-- Check if player has Team
	if player.Team == nil or otherPlayer.Team == nil then
		return true
	end
	
	-- Check if different teams
	return player.Team ~= otherPlayer.Team
end

local function getClosestEnemy()
	local closest = nil
	local shortestDist = math.huge

	-- Find all other players
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local character = otherPlayer.Character
			
			-- Skip if same team
			if not isEnemyTeam(otherPlayer) then
				continue
			end
			
			-- Find head or humanoid part
			local head = character:FindFirstChild("Head")
			if not head then
				head = character:FindFirstChildOfClass("Part")
			end
			
			if head and character:FindFirstChildOfClass("Humanoid") then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid.Health > 0 then
					local screenPos, visible = camera:WorldToViewportPoint(head.Position)
					if visible then
						local dist = (head.Position - camera.CFrame.Position).Magnitude

						if dist < shortestDist and dist < maxDistance then
							shortestDist = dist
							closest = head
						end
					end
				end
			end
		end
	end

	return closest
end

---------------------------------------------------------------------
-- SILENT AIM LOCK
---------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	if not silentAimEnabled then return end
	
	local head = getClosestEnemy()
	if head then
		local character = player.Character
		if character then
			-- Try to find and rotate weapon
			local tool = character:FindFirstChildOfClass("Tool")
			if tool then
				local handle = tool:FindFirstChild("Handle")
				if handle then
					handle.CFrame = CFrame.new(handle.Position, head.Position)
				end
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
