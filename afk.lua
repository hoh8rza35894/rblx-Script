-- Tiny Anti-AFK Toggle (Draggable + Edge Snap)
-- LocalScript for StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- === UI ===
local gui = Instance.new("ScreenGui")
gui.Name = "TinyAntiAFK"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local btn = Instance.new("TextButton")
btn.Name = "AFKToggle"
btn.Size = UDim2.fromOffset(40, 40)
btn.Position = UDim2.new(1, -52, 0, 12) -- top-right by default
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "AFK"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 12
btn.AutoButtonColor = true
btn.BorderSizePixel = 0
btn.Active = true
btn.ZIndex = 10
btn.Parent = gui

-- round button
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = btn

-- subtle shadow
local shadow = Instance.new("UIStroke")
shadow.Thickness = 1
shadow.Color = Color3.fromRGB(0,0,0)
shadow.Transparency = 0.5
shadow.Parent = btn

-- === Anti-AFK logic ===
local active = false
local idledConn: RBXScriptConnection? = nil

local function setVisual(on: boolean)
	if on then
		btn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)  -- green-ish ON
		btn.Text = "ON"
	else
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  -- gray OFF
		btn.Text = "AFK"
	end
end

local function setActive(on: boolean)
	if active == on then return end
	active = on
	setVisual(active)

	if active then
		idledConn = LocalPlayer.Idled:Connect(function()
			local cam = workspace.CurrentCamera
			VirtualUser:Button2Down(Vector2.new(), cam and cam.CFrame or CFrame.new())
			task.wait(0.75)
			VirtualUser:Button2Up(Vector2.new(), cam and cam.CFrame or CFrame.new())
		end)
	else
		if idledConn then
			idledConn:Disconnect()
			idledConn = nil
		end
	end
end

btn.MouseButton1Click:Connect(function()
	setActive(not active)
end)

-- === Drag & Move (+ edge snap) ===
local dragging = false
local dragInput: InputObject? = nil
local dragStart: Vector2? = nil
local startPos: UDim2? = nil

local function clampToScreen(pos: UDim2): UDim2
	-- keep button inside viewport
	local screen = gui.AbsoluteSize
	local x = math.clamp(pos.X.Offset, 0, screen.X - btn.AbsoluteSize.X)
	local y = math.clamp(pos.Y.Offset, 0, screen.Y - btn.AbsoluteSize.Y)
	return UDim2.fromOffset(x, y)
end

local function snapToNearestEdge()
	local screen = gui.AbsoluteSize
	local btnPos = btn.AbsolutePosition
	local btnSize = btn.AbsoluteSize

	local leftDist = btnPos.X
	local rightDist = (screen.X - (btnPos.X + btnSize.X))
	local topDist = btnPos.Y
	local bottomDist = (screen.Y - (btnPos.Y + btnSize.Y))

	local minDist = math.min(leftDist, rightDist, topDist, bottomDist)

	if minDist == leftDist then
		btn.Position = UDim2.fromOffset(8, btn.AbsolutePosition.Y)         -- snap left
	elseif minDist == rightDist then
		btn.Position = UDim2.fromOffset(screen.X - btnSize.X - 8, btn.AbsolutePosition.Y) -- snap right
	elseif minDist == topDist then
		btn.Position = UDim2.fromOffset(btn.AbsolutePosition.X, 8)         -- snap top
	else
		btn.Position = UDim2.fromOffset(btn.AbsolutePosition.X, screen.Y - btnSize.Y - 8) -- snap bottom
	end
end

btn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = btn.Position
		dragInput = input
	end
end)

btn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput and dragStart and startPos then
		local delta = input.Position - dragStart
		local newPos = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
		btn.Position = clampToScreen(newPos)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input == dragInput then
		dragging = false
		dragInput = nil
		dragStart = nil
		startPos = nil
		snapToNearestEdge()
	end
end)

-- Clean up on removal
gui.AncestryChanged:Connect(function(_, parent)
	if not parent then
		setActive(false)
	end
end)

-- optional: start OFF
setActive(false)
