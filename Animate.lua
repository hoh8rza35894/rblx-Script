-- Emote Menu Script by DevNick
-- Features: Toggle menu, Hide/Show, Emote list with animations

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EmoteMenuGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Add corner radius to main frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BackgroundTransparency = 0.1
Title.BorderSizePixel = 0
Title.Text = "🎭 Emote Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Toggle Button (Top Right Corner)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -35, 0, 5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "👁"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = Title

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.2
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Hide Button (Bottom Right)
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 80, 0, 30)
HideButton.Position = UDim2.new(1, -85, 1, -35)
HideButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
HideButton.BackgroundTransparency = 0.2
HideButton.BorderSizePixel = 0
HideButton.Text = "ซ่อนเมนู"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 14
HideButton.Font = Enum.Font.SourceSansBold
HideButton.Parent = MainFrame

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 6)
HideCorner.Parent = HideButton

-- Show Button (Hidden initially)
local ShowButton = Instance.new("TextButton")
ShowButton.Name = "ShowButton"
ShowButton.Size = UDim2.new(0, 100, 0, 40)
ShowButton.Position = UDim2.new(0.5, -50, 0.1, 0)
ShowButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ShowButton.BackgroundTransparency = 0.1
ShowButton.BorderSizePixel = 0
ShowButton.Text = "🎭 แสดงเมนู"
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.TextSize = 16
ShowButton.Font = Enum.Font.SourceSansBold
ShowButton.Visible = false
ShowButton.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(0, 8)
ShowCorner.Parent = ShowButton

-- Scrolling Frame for Emotes
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, -20, 1, -120)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ScrollingFrame.BackgroundTransparency = 0.5
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollingFrame.Parent = MainFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 6)
ScrollCorner.Parent = ScrollingFrame

-- UIListLayout for buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Stop Emote Button
local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.Size = UDim2.new(0, 300, 0, 35)
StopButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
StopButton.BackgroundTransparency = 0.2
StopButton.BorderSizePixel = 0
StopButton.Text = "⏹ หยุดเอมโต"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 14
StopButton.Font = Enum.Font.SourceSansBold
StopButton.Parent = ScrollingFrame

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent = StopButton

-- Emote List (Animation IDs)
local Emotes = {
    {Name = "🎉 Party Dance", ID = "3333432454"},
    {Name = "💃 Floss", ID = "4555808220"},
    {Name = "🕺 Smooth Moves", ID = "4049037604"},
    {Name = "🤸 Break Dance", ID = "4555782893"},
    {Name = "🎪 Circus Dance", ID = "10214311282"},
    {Name = "🏃 Sprint Dance", ID = "10714010337"},
    {Name = "🤾 Volleyball", ID = "10713981723"},
    {Name = "🎨 Artistic Dance", ID = "10714372526"},
    {Name = "🚀 Rocket Dance", ID = "10714076981"},
    {Name = "🎵 DJ Dance", ID = "10714392151"},
    {Name = "🎭 Dramatic Pose", ID = "11444443576"},
    {Name = "👋 Wave", ID = "27789359"},
    {Name = "💪 Flex", ID = "30196114"},
    {Name = "🏃 Run Animation", ID = "248263260"},
    {Name = "🤸 Gymnastics", ID = "45834924"},
    {Name = "🎪 Cheer", ID = "33796059"},
    {Name = "🕺 Salsa", ID = "28488254"},
    {Name = "🎭 Pose", ID = "52155728"}
}

-- Movement Emotes (Walking, Running, Jumping)
local MovementEmotes = {
    {Name = "🚶 Cool Walk", ID = "913402848"},
    {Name = "👟 Fast Walk", ID = "913376220"},
    {Name = "🏃 Power Run", ID = "619521311"},
    {Name = "⚡ Sprint", ID = "507767714"},
    {Name = "🤸 Parkour Run", ID = "507767968"},
    {Name = "🦘 Kangaroo Jump", ID = "507765000"},
    {Name = "🤾 Long Jump", ID = "507765263"},
    {Name = "🤸 Flip Jump", ID = "619521311"},
    {Name = "🚀 Rocket Jump", ID = "1083213668"}
}

-- Combine all emotes
local AllEmotes = {}
for _, emote in ipairs(Emotes) do
    table.insert(AllEmotes, emote)
end

-- Add separator
table.insert(AllEmotes, {Name = "───────────── ท่าเดินวิ่งกระโดด ─────────────", ID = "separator"})

for _, emote in ipairs(MovementEmotes) do
    table.insert(AllEmotes, emote)
end

-- Replace Emotes with AllEmotes
Emotes = AllEmotes

-- Create Emote Buttons
local emoteButtons = {}
for i, emote in ipairs(Emotes) do
    if emote.ID == "separator" then
        -- Create separator text label
        local Separator = Instance.new("TextLabel")
        Separator.Name = "Separator_" .. i
        Separator.Size = UDim2.new(0, 300, 0, 25)
        Separator.BackgroundTransparency = 1
        Separator.BorderSizePixel = 0
        Separator.Text = emote.Name
        Separator.TextColor3 = Color3.fromRGB(150, 150, 150)
        Separator.TextSize = 12
        Separator.Font = Enum.Font.SourceSans
        Separator.TextXAlignment = Enum.TextXAlignment.Center
        Separator.Parent = ScrollingFrame
    else
        -- Create emote button
        local EmoteButton = Instance.new("TextButton")
        EmoteButton.Name = "EmoteButton_" .. i
        EmoteButton.Size = UDim2.new(0, 300, 0, 35)
        EmoteButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        EmoteButton.BackgroundTransparency = 0.3
        EmoteButton.BorderSizePixel = 0
        EmoteButton.Text = emote.Name
        EmoteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        EmoteButton.TextSize = 14
        EmoteButton.Font = Enum.Font.SourceSansBold
        EmoteButton.Parent = ScrollingFrame

        local EmoteCorner = Instance.new("UICorner")
        EmoteCorner.CornerRadius = UDim.new(0, 6)
        EmoteCorner.Parent = EmoteButton

        emoteButtons[i] = EmoteButton
    end
end

-- Update ScrollingFrame CanvasSize
-- Calculate total height: buttons (35px) + separator (25px) + padding (50px)
local totalHeight = (#Emotes - 1) * 35 + 25 + 50  -- -1 for separator, +25 for separator height
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

-- Variables
local currentAnimation = nil
local isMenuVisible = true

-- Functions
local function PlayAnimation(animationId)
    -- Stop current animation
    if currentAnimation then
        currentAnimation:Stop()
        currentAnimation:Destroy()
        currentAnimation = nil
    end

    -- Play new animation
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId

    currentAnimation = humanoid:LoadAnimation(animation)
    currentAnimation.Looped = true
    currentAnimation:Play()
end

local function StopAnimation()
    if currentAnimation then
        currentAnimation:Stop()
        currentAnimation:Destroy()
        currentAnimation = nil
    end
end

local function ToggleMenuVisibility()
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    ShowButton.Visible = not isMenuVisible
    HideButton.Text = isMenuVisible and "ซ่อนเมนู" or "แสดงเมนู"
end

local function CloseMenu()
    MainFrame.Visible = false
    ShowButton.Visible = true
    isMenuVisible = false
end

local function ShowMenu()
    MainFrame.Visible = true
    ShowButton.Visible = false
    isMenuVisible = true
end

-- Connect Button Events
ToggleButton.MouseButton1Click:Connect(ToggleMenuVisibility)
CloseButton.MouseButton1Click:Connect(CloseMenu)
HideButton.MouseButton1Click:Connect(ToggleMenuVisibility)
ShowButton.MouseButton1Click:Connect(ShowMenu)

StopButton.MouseButton1Click:Connect(StopAnimation)

-- Connect Emote Buttons
for i, button in ipairs(emoteButtons) do
    if button then -- Only connect if it's a button (not separator)
        button.MouseButton1Click:Connect(function()
            PlayAnimation(Emotes[i].ID)
        end)
    end
end

-- Keyboard shortcut (Press E to toggle menu)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        ToggleMenuVisibility()
    end
end)

-- Initial setup
MainFrame.Visible = true
ShowButton.Visible = false
