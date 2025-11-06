-- Best Teleport Script by DevNick
-- Features: Save/Load points, Teleport to players, Auto-refresh player list

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 700)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -350)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

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
Title.Text = "Best Teleport Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.2
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.SourceSansBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Teleport to Player Section
local PlayerSection = Instance.new("Frame")
PlayerSection.Name = "PlayerSection"
PlayerSection.Size = UDim2.new(1, -20, 0, 200)
PlayerSection.Position = UDim2.new(0, 10, 0, 50)
PlayerSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerSection.BackgroundTransparency = 0.2
PlayerSection.BorderSizePixel = 0

local PlayerCorner = Instance.new("UICorner")
PlayerCorner.CornerRadius = UDim.new(0, 6)
PlayerCorner.Parent = PlayerSection

local PlayerTitle = Instance.new("TextLabel")
PlayerTitle.Size = UDim2.new(1, 0, 0, 25)
PlayerTitle.BackgroundTransparency = 1
PlayerTitle.Text = "Teleport to Player"
PlayerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerTitle.TextSize = 14
PlayerTitle.Font = Enum.Font.SourceSansBold
PlayerTitle.Parent = PlayerSection

-- Search Box
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -10, 0, 30)
SearchFrame.Position = UDim2.new(0, 5, 0, 30)
SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SearchFrame.BackgroundTransparency = 0.3
SearchFrame.BorderSizePixel = 0

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 4)
SearchCorner.Parent = SearchFrame

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 25, 0, 25)
SearchIcon.Position = UDim2.new(0, 5, 0, 2.5)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 14
SearchIcon.Font = Enum.Font.SourceSans
SearchIcon.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -35, 0, 25)
SearchBox.Position = UDim2.new(0, 30, 0, 2.5)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = "Search players..."
SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.SourceSans
SearchBox.ClearTextOnFocus = true
SearchBox.Parent = SearchFrame

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(1, -10, 0, 105)
PlayerList.Position = UDim2.new(0, 5, 0, 65)
PlayerList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerList.BackgroundTransparency = 0.3
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 6
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)

local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 4)
PlayerListCorner.Parent = PlayerList

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 2)
PlayerListLayout.Parent = PlayerList

-- Save Point Section
local SaveSection = Instance.new("Frame")
SaveSection.Name = "SaveSection"
SaveSection.Size = UDim2.new(1, -20, 0, 200)
SaveSection.Position = UDim2.new(0, 10, 0, 260)
SaveSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SaveSection.BackgroundTransparency = 0.2
SaveSection.BorderSizePixel = 0

local SaveCorner = Instance.new("UICorner")
SaveCorner.CornerRadius = UDim.new(0, 6)
SaveCorner.Parent = SaveSection

local SaveTitle = Instance.new("TextLabel")
SaveTitle.Size = UDim2.new(1, 0, 0, 25)
SaveTitle.BackgroundTransparency = 1
SaveTitle.Text = "Save/Load Points"
SaveTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveTitle.TextSize = 14
SaveTitle.Font = Enum.Font.SourceSansBold
SaveTitle.Parent = SaveSection

-- Save Point Input
local SavePointFrame = Instance.new("Frame")
SavePointFrame.Size = UDim2.new(1, -10, 0, 35)
SavePointFrame.Position = UDim2.new(0, 5, 0, 30)
SavePointFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SavePointFrame.BackgroundTransparency = 0.3
SavePointFrame.BorderSizePixel = 0

local SavePointCorner = Instance.new("UICorner")
SavePointCorner.CornerRadius = UDim.new(0, 4)
SavePointCorner.Parent = SavePointFrame

local SaveInput = Instance.new("TextBox")
SaveInput.Size = UDim2.new(0, 200, 0, 25)
SaveInput.Position = UDim2.new(0, 5, 0, 5)
SaveInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SaveInput.BackgroundTransparency = 0.2
SaveInput.BorderSizePixel = 0
SaveInput.Text = "Point Name"
SaveInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveInput.TextSize = 12
SaveInput.Font = Enum.Font.SourceSans
SaveInput.ClearTextOnFocus = true

local SaveInputCorner = Instance.new("UICorner")
SaveInputCorner.CornerRadius = UDim.new(0, 4)
SaveInputCorner.Parent = SaveInput

local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(0, 80, 0, 25)
SaveButton.Position = UDim2.new(1, -170, 0, 5)
SaveButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
SaveButton.BackgroundTransparency = 0.2
SaveButton.BorderSizePixel = 0
SaveButton.Text = "Save"
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.TextSize = 12
SaveButton.Font = Enum.Font.SourceSansBold

local SaveButtonCorner = Instance.new("UICorner")
SaveButtonCorner.CornerRadius = UDim.new(0, 4)
SaveButtonCorner.Parent = SaveButton

-- Clear All Points Button
local ClearPointsButton = Instance.new("TextButton")
ClearPointsButton.Size = UDim2.new(0, 75, 0, 25)
ClearPointsButton.Position = UDim2.new(1, -80, 0, 5)
ClearPointsButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ClearPointsButton.BackgroundTransparency = 0.2
ClearPointsButton.BorderSizePixel = 0
ClearPointsButton.Text = "Clear All"
ClearPointsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearPointsButton.TextSize = 10
ClearPointsButton.Font = Enum.Font.SourceSansBold

local ClearPointsCorner = Instance.new("UICorner")
ClearPointsCorner.CornerRadius = UDim.new(0, 4)
ClearPointsCorner.Parent = ClearPointsButton

-- Load Points List
local LoadList = Instance.new("ScrollingFrame")
LoadList.Name = "LoadList"
LoadList.Size = UDim2.new(1, -10, 0, 130)
LoadList.Position = UDim2.new(0, 5, 0, 105)
LoadList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadList.BackgroundTransparency = 0.3
LoadList.BorderSizePixel = 0
LoadList.ScrollBarThickness = 6
LoadList.CanvasSize = UDim2.new(0, 0, 0, 0)

local LoadListCorner = Instance.new("UICorner")
LoadListCorner.CornerRadius = UDim.new(0, 4)
LoadListCorner.Parent = LoadList

local LoadListLayout = Instance.new("UIListLayout")
LoadListLayout.SortOrder = Enum.SortOrder.LayoutOrder
LoadListLayout.Padding = UDim.new(0, 2)
LoadListLayout.Parent = LoadList

-- Saved Points Search Box
local SavedSearchFrame = Instance.new("Frame")
SavedSearchFrame.Size = UDim2.new(1, -10, 0, 30)
SavedSearchFrame.Position = UDim2.new(0, 5, 0, 70)
SavedSearchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SavedSearchFrame.BackgroundTransparency = 0.3
SavedSearchFrame.BorderSizePixel = 0

local SavedSearchCorner = Instance.new("UICorner")
SavedSearchCorner.CornerRadius = UDim.new(0, 4)
SavedSearchCorner.Parent = SavedSearchFrame

local SavedSearchIcon = Instance.new("TextLabel")
SavedSearchIcon.Size = UDim2.new(0, 25, 0, 25)
SavedSearchIcon.Position = UDim2.new(0, 5, 0, 2.5)
SavedSearchIcon.BackgroundTransparency = 1
SavedSearchIcon.Text = "🔍"
SavedSearchIcon.TextSize = 14
SavedSearchIcon.Font = Enum.Font.SourceSans
SavedSearchIcon.Parent = SavedSearchFrame

local SavedSearchBox = Instance.new("TextBox")
SavedSearchBox.Size = UDim2.new(1, -35, 0, 25)
SavedSearchBox.Position = UDim2.new(0, 30, 0, 2.5)
SavedSearchBox.BackgroundTransparency = 1
SavedSearchBox.Text = "ค้นหาจุด..."
SavedSearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
SavedSearchBox.TextSize = 12
SavedSearchBox.Font = Enum.Font.SourceSans
SavedSearchBox.ClearTextOnFocus = true
SavedSearchBox.Parent = SavedSearchFrame

-- Configuration Section
local ConfigSection = Instance.new("Frame")
ConfigSection.Name = "ConfigSection"
ConfigSection.Size = UDim2.new(1, -20, 0, 200)
ConfigSection.Position = UDim2.new(0, 10, 0, 470)
ConfigSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ConfigSection.BackgroundTransparency = 0.2
ConfigSection.BorderSizePixel = 0

local ConfigCorner = Instance.new("UICorner")
ConfigCorner.CornerRadius = UDim.new(0, 6)
ConfigCorner.Parent = ConfigSection

local ConfigTitle = Instance.new("TextLabel")
ConfigTitle.Size = UDim2.new(1, 0, 0, 25)
ConfigTitle.BackgroundTransparency = 1
ConfigTitle.Text = "Configurations"
ConfigTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigTitle.TextSize = 14
ConfigTitle.Font = Enum.Font.SourceSansBold
ConfigTitle.Parent = ConfigSection

-- Config Name Input
local ConfigNameFrame = Instance.new("Frame")
ConfigNameFrame.Size = UDim2.new(1, -10, 0, 35)
ConfigNameFrame.Position = UDim2.new(0, 5, 0, 30)
ConfigNameFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ConfigNameFrame.BackgroundTransparency = 0.3
ConfigNameFrame.BorderSizePixel = 0

local ConfigNameCorner = Instance.new("UICorner")
ConfigNameCorner.CornerRadius = UDim.new(0, 4)
ConfigNameCorner.Parent = ConfigNameFrame

local ConfigNameInput = Instance.new("TextBox")
ConfigNameInput.Size = UDim2.new(0, 200, 0, 25)
ConfigNameInput.Position = UDim2.new(0, 5, 0, 5)
ConfigNameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ConfigNameInput.BackgroundTransparency = 0.2
ConfigNameInput.BorderSizePixel = 0
ConfigNameInput.Text = "Config Name"
ConfigNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigNameInput.TextSize = 12
ConfigNameInput.Font = Enum.Font.SourceSans
ConfigNameInput.ClearTextOnFocus = true

local ConfigNameInputCorner = Instance.new("UICorner")
ConfigNameInputCorner.CornerRadius = UDim.new(0, 4)
ConfigNameInputCorner.Parent = ConfigNameInput

local SaveConfigButton = Instance.new("TextButton")
SaveConfigButton.Size = UDim2.new(0, 80, 0, 25)
SaveConfigButton.Position = UDim2.new(1, -170, 0, 5)
SaveConfigButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
SaveConfigButton.BackgroundTransparency = 0.2
SaveConfigButton.BorderSizePixel = 0
SaveConfigButton.Text = "Save Config"
SaveConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveConfigButton.TextSize = 10
SaveConfigButton.Font = Enum.Font.SourceSansBold

local SaveConfigButtonCorner = Instance.new("UICorner")
SaveConfigButtonCorner.CornerRadius = UDim.new(0, 4)
SaveConfigButtonCorner.Parent = SaveConfigButton

-- Clear All Configs Button
local ClearConfigsButton = Instance.new("TextButton")
ClearConfigsButton.Size = UDim2.new(0, 75, 0, 25)
ClearConfigsButton.Position = UDim2.new(1, -80, 0, 5)
ClearConfigsButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ClearConfigsButton.BackgroundTransparency = 0.2
ClearConfigsButton.BorderSizePixel = 0
ClearConfigsButton.Text = "Clear All"
ClearConfigsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearConfigsButton.TextSize = 10
ClearConfigsButton.Font = Enum.Font.SourceSansBold

local ClearConfigsCorner = Instance.new("UICorner")
ClearConfigsCorner.CornerRadius = UDim.new(0, 4)
ClearConfigsCorner.Parent = ClearConfigsButton

-- Load Configs List
local ConfigList = Instance.new("ScrollingFrame")
ConfigList.Name = "ConfigList"
ConfigList.Size = UDim2.new(1, -10, 0, 130)
ConfigList.Position = UDim2.new(0, 5, 0, 70)
ConfigList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ConfigList.BackgroundTransparency = 0.3
ConfigList.BorderSizePixel = 0
ConfigList.ScrollBarThickness = 6
ConfigList.CanvasSize = UDim2.new(0, 0, 0, 0)

local ConfigListCorner = Instance.new("UICorner")
ConfigListCorner.CornerRadius = UDim.new(0, 4)
ConfigListCorner.Parent = ConfigList

local ConfigListLayout = Instance.new("UIListLayout")
ConfigListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ConfigListLayout.Padding = UDim.new(0, 2)
ConfigListLayout.Parent = ConfigList

-- Settings Section
local SettingsSection = Instance.new("Frame")
SettingsSection.Name = "SettingsSection"
SettingsSection.Size = UDim2.new(1, -20, 0, 30)
SettingsSection.Position = UDim2.new(0, 10, 0, 670)
SettingsSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SettingsSection.BackgroundTransparency = 0.2
SettingsSection.BorderSizePixel = 0

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 6)
SettingsCorner.Parent = SettingsSection

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 20)
ToggleButton.Position = UDim2.new(0, 5, 0, 5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "Hide GUI (F)"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.SourceSansBold

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 4)
ToggleCorner.Parent = ToggleButton

-- Parent all elements
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Parent = ScreenGui
Title.Parent = MainFrame
CloseButton.Parent = Title

PlayerSection.Parent = MainFrame
SearchFrame.Parent = PlayerSection
PlayerList.Parent = PlayerSection

SaveSection.Parent = MainFrame
SavePointFrame.Parent = SaveSection
SaveInput.Parent = SavePointFrame
SaveButton.Parent = SavePointFrame
ClearPointsButton.Parent = SavePointFrame
SavedSearchFrame.Parent = SaveSection
LoadList.Parent = SaveSection

ConfigSection.Parent = MainFrame
ConfigNameFrame.Parent = ConfigSection
ConfigNameInput.Parent = ConfigNameFrame
SaveConfigButton.Parent = ConfigNameFrame
ClearConfigsButton.Parent = ConfigNameFrame
ConfigList.Parent = ConfigSection

SettingsSection.Parent = MainFrame
ToggleButton.Parent = SettingsSection

-- Variables
local SavedPoints = {}
local PlayerButtons = {}
local LoadButtons = {}
local ConfigButtons = {}
local Configurations = {}
local CurrentConfig = nil
local IsVisible = true
local LastRefresh = 0
local ConfigFilePath = "TeleportConfigs.json"
local CurrentSavedSearchFilter = ""

-- Functions
local function Tween(Object, Properties, Duration)
    local TweenInfo = TweenInfo.new(Duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Tween = TweenService:Create(Object, TweenInfo, Properties)
    Tween:Play()
    return Tween
end

local function CreateNotification(Text, Duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 250, 0, 50)
    Notification.Position = UDim2.new(0.5, -125, 0, -60)
    Notification.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Notification.BackgroundTransparency = 0.1
    Notification.BorderSizePixel = 0

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 6)
    NotifCorner.Parent = Notification

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -10, 1, 0)
    NotifText.Position = UDim2.new(0, 5, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = Text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 14
    NotifText.Font = Enum.Font.SourceSans
    NotifText.TextWrapped = true
    NotifText.Parent = Notification

    Notification.Parent = ScreenGui

    Tween(Notification, {Position = UDim2.new(0.5, -125, 0, 10)}, 0.5)

    wait(Duration or 3)

    Tween(Notification, {Position = UDim2.new(0.5, -125, 0, -60)}, 0.5)
    wait(0.5)
    Notification:Destroy()
end

local function TeleportTo(Position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        -- Check if character is seated
        local Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid and Humanoid.SeatPart then
            Humanoid.Sit = false
            wait(0.1)
        end

        -- Instant warp teleport
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.CFrame = CFrame.new(Position)
        CreateNotification("Teleported successfully!", 2)
    else
        CreateNotification("Character not found!", 2)
    end
end

local function RefreshPlayers(SearchFilter)
    SearchFilter = SearchFilter or ""
    SearchFilter = string.lower(SearchFilter)

    -- Clear existing buttons
    for _, Button in pairs(PlayerButtons) do
        Button:Destroy()
    end
    PlayerButtons = {}

    -- Get all players
    local AllPlayers = Players:GetPlayers()
    table.sort(AllPlayers, function(a, b) return a.Name < b.Name end)

    -- Create buttons for each player (with search filter)
    for _, Player in ipairs(AllPlayers) do
        if Player ~= LocalPlayer then
            local PlayerName = string.lower(Player.Name)
            local DisplayName = string.lower(Player.DisplayName)

            -- Check if player matches search filter
            if SearchFilter == "" or string.find(PlayerName, SearchFilter, 1, true) or string.find(DisplayName, SearchFilter, 1, true) then
                local PlayerButton = Instance.new("TextButton")
                PlayerButton.Size = UDim2.new(1, -10, 0, 30)
                PlayerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                PlayerButton.BackgroundTransparency = 0.2
                PlayerButton.BorderSizePixel = 0
                PlayerButton.Text = Player.Name .. " (" .. Player.DisplayName .. ")"
                PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                PlayerButton.TextSize = 12
                PlayerButton.Font = Enum.Font.SourceSans

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = PlayerButton

                -- Hover effects
                PlayerButton.MouseEnter:Connect(function()
                    Tween(PlayerButton, {BackgroundTransparency = 0})
                end)

                PlayerButton.MouseLeave:Connect(function()
                    Tween(PlayerButton, {BackgroundTransparency = 0.2})
                end)

                -- Click to teleport
                PlayerButton.MouseButton1Click:Connect(function()
                    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        TeleportTo(Player.Character.HumanoidRootPart.Position)
                    else
                        CreateNotification("Player not found or not loaded!", 2)
                    end
                end)

                PlayerButton.Parent = PlayerList
                table.insert(PlayerButtons, PlayerButton)
            end
        end
    end

    -- Update canvas size
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, #PlayerButtons * 32)
end

local function RefreshSavedPoints(SearchFilter)
    SearchFilter = SearchFilter or ""
    local loweredFilter = string.lower(SearchFilter)
    -- Clear existing buttons
    for _, Button in pairs(LoadButtons) do
        Button:Destroy()
    end
    LoadButtons = {}

    -- Create buttons for each saved point (with search filter)
    for Name, Position in pairs(SavedPoints) do
        local lowerName = string.lower(tostring(Name))
        if loweredFilter == "" or string.find(lowerName, loweredFilter, 1, true) then
        local PointFrame = Instance.new("Frame")
        PointFrame.Size = UDim2.new(1, -10, 0, 30)
        PointFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        PointFrame.BackgroundTransparency = 0.2
        PointFrame.BorderSizePixel = 0

        local FrameCorner = Instance.new("UICorner")
        FrameCorner.CornerRadius = UDim.new(0, 4)
        FrameCorner.Parent = PointFrame

        -- Point name label (clickable)
        local PointLabel = Instance.new("TextButton")
        PointLabel.Size = UDim2.new(1, -70, 1, 0)
        PointLabel.Position = UDim2.new(0, 5, 0, 0)
        PointLabel.BackgroundTransparency = 1
        PointLabel.Text = Name
        PointLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        PointLabel.TextSize = 12
        PointLabel.Font = Enum.Font.SourceSans
        PointLabel.TextXAlignment = Enum.TextXAlignment.Left
        PointLabel.Parent = PointFrame

        -- Delete button
        local DeleteButton = Instance.new("TextButton")
        DeleteButton.Size = UDim2.new(0, 60, 0, 25)
        DeleteButton.Position = UDim2.new(1, -65, 0, 2.5)
        DeleteButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        DeleteButton.BackgroundTransparency = 0.2
        DeleteButton.BorderSizePixel = 0
        DeleteButton.Text = "ลบ"
        DeleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DeleteButton.TextSize = 10
        DeleteButton.Font = Enum.Font.SourceSansBold
        DeleteButton.Parent = PointFrame

        local DeleteCorner = Instance.new("UICorner")
        DeleteCorner.CornerRadius = UDim.new(0, 4)
        DeleteCorner.Parent = DeleteButton

        -- Hover effects for frame
        PointFrame.MouseEnter:Connect(function()
            Tween(PointFrame, {BackgroundTransparency = 0})
        end)

        PointFrame.MouseLeave:Connect(function()
            Tween(PointFrame, {BackgroundTransparency = 0.2})
        end)

        -- Click point name to teleport
        PointLabel.MouseButton1Click:Connect(function()
            TeleportTo(Position)
        end)

        -- Click delete button to delete
        DeleteButton.MouseButton1Click:Connect(function()
            SavedPoints[Name] = nil
            -- Update current configuration if one is loaded
            if CurrentConfig and Configurations[CurrentConfig] then
                Configurations[CurrentConfig].Points[Name] = nil
                Configurations[CurrentConfig].PointCount = Configurations[CurrentConfig].PointCount - 1
                SaveConfigurations()
                RefreshConfigurations()
            end
            RefreshSavedPoints()
            CreateNotification("Point '" .. Name .. "' ถูกลบแล้ว!", 2)
        end)

        PointFrame.Parent = LoadList
        table.insert(LoadButtons, PointFrame)
        end
    end

    -- Update canvas size
    LoadList.CanvasSize = UDim2.new(0, 0, 0, #LoadButtons * 32)
end

local function SaveConfigurations(showNotification)
    local success, result = pcall(function()
        local configData = HttpService:JSONEncode(Configurations)
        writefile(ConfigFilePath, configData)
    end)
    if success then
        if showNotification then
            CreateNotification("บันทึกการตั้งค่าแล้ว! 💾", 2)
        end
    else
        warn("Failed to save configurations: " .. tostring(result))
        CreateNotification("❌ บันทึกการตั้งค่าไม่สำเร็จ!", 3)
    end
    return success
end

local function LoadConfigurations()
    local success, result = pcall(function()
        if isfile(ConfigFilePath) then
            local configData = readfile(ConfigFilePath)
            Configurations = HttpService:JSONDecode(configData) or {}
            return true
        else
            Configurations = {}
            return false
        end
    end)
    if not success then
        warn("Failed to load configurations: " .. tostring(result))
        Configurations = {}
        CreateNotification("❌ โหลดการตั้งค่าไม่สำเร็จ!", 3)
        return false
    end
    return result
end

local function RefreshConfigurations()
    -- Clear existing buttons
    for _, Button in pairs(ConfigButtons) do
        Button:Destroy()
    end
    ConfigButtons = {}

    -- Create buttons for each configuration
    for ConfigName, ConfigData in pairs(Configurations) do
        local ConfigFrame = Instance.new("Frame")
        ConfigFrame.Size = UDim2.new(1, -10, 0, 30)
        ConfigFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ConfigFrame.BackgroundTransparency = 0.2
        ConfigFrame.BorderSizePixel = 0

        local FrameCorner = Instance.new("UICorner")
        FrameCorner.CornerRadius = UDim.new(0, 4)
        FrameCorner.Parent = ConfigFrame

        -- Config name label (clickable)
        local ConfigLabel = Instance.new("TextButton")
        ConfigLabel.Size = UDim2.new(1, -70, 1, 0)
        ConfigLabel.Position = UDim2.new(0, 5, 0, 0)
        ConfigLabel.BackgroundTransparency = 1
        ConfigLabel.Text = ConfigName .. " (" .. (ConfigData.PointCount or 0) .. " จุด)"
        ConfigLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ConfigLabel.TextSize = 12
        ConfigLabel.Font = Enum.Font.SourceSans
        ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
        ConfigLabel.Parent = ConfigFrame

        -- Delete button
        local DeleteButton = Instance.new("TextButton")
        DeleteButton.Size = UDim2.new(0, 60, 0, 25)
        DeleteButton.Position = UDim2.new(1, -65, 0, 2.5)
        DeleteButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        DeleteButton.BackgroundTransparency = 0.2
        DeleteButton.BorderSizePixel = 0
        DeleteButton.Text = "ลบ"
        DeleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DeleteButton.TextSize = 10
        DeleteButton.Font = Enum.Font.SourceSansBold
        DeleteButton.Parent = ConfigFrame

        local DeleteCorner = Instance.new("UICorner")
        DeleteCorner.CornerRadius = UDim.new(0, 4)
        DeleteCorner.Parent = DeleteButton

        -- Hover effects for frame
        ConfigFrame.MouseEnter:Connect(function()
            Tween(ConfigFrame, {BackgroundTransparency = 0})
        end)

        ConfigFrame.MouseLeave:Connect(function()
            Tween(ConfigFrame, {BackgroundTransparency = 0.2})
        end)

        -- Click config name to load configuration
        ConfigLabel.MouseButton1Click:Connect(function()
            CurrentConfig = ConfigName
            SavedPoints = {}
            for pointName, position in pairs(ConfigData.Points or {}) do
                SavedPoints[pointName] = Vector3.new(position.X, position.Y, position.Z)
            end
            RefreshSavedPoints()
            CreateNotification("Configuration '" .. ConfigName .. "' ถูกโหลดแล้ว!", 2)
        end)

        -- Click delete button to delete configuration
        DeleteButton.MouseButton1Click:Connect(function()
            Configurations[ConfigName] = nil
            SaveConfigurations(true)
            RefreshConfigurations()
            if CurrentConfig == ConfigName then
                CurrentConfig = nil
                SavedPoints = {}
                RefreshSavedPoints()
            end
            CreateNotification("Configuration '" .. ConfigName .. "' ถูกลบแล้ว!", 2)
        end)

        ConfigFrame.Parent = ConfigList
        table.insert(ConfigButtons, ConfigFrame)
    end

    -- Update canvas size
    ConfigList.CanvasSize = UDim2.new(0, 0, 0, #ConfigButtons * 32)
end

-- Event handlers
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

SaveButton.MouseButton1Click:Connect(function()
    local PointName = SaveInput.Text
    if PointName ~= "" and PointName ~= "Point Name" then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Position = LocalPlayer.Character.HumanoidRootPart.Position
            SavedPoints[PointName] = Position
            -- Update current configuration if one is loaded
            if CurrentConfig and Configurations[CurrentConfig] then
                Configurations[CurrentConfig].Points[PointName] = {
                    X = Position.X,
                    Y = Position.Y,
                    Z = Position.Z
                }
                Configurations[CurrentConfig].PointCount = Configurations[CurrentConfig].PointCount + 1
                SaveConfigurations()
                RefreshConfigurations()
            end
            SaveInput.Text = "Point Name"
            RefreshSavedPoints(CurrentSavedSearchFilter)
            CreateNotification("Point '" .. PointName .. "' saved!", 2)
        else
            CreateNotification("Character not found!", 2)
        end
    else
        CreateNotification("Please enter a valid point name!", 2)
    end
end)

SaveConfigButton.MouseButton1Click:Connect(function()
    local ConfigName = ConfigNameInput.Text
    if ConfigName ~= "" and ConfigName ~= "Config Name" then
        if next(SavedPoints) then  -- Check if there are any saved points
            Configurations[ConfigName] = {
                Points = {},
                PointCount = 0
            }
            for pointName, position in pairs(SavedPoints) do
                Configurations[ConfigName].Points[pointName] = {
                    X = position.X,
                    Y = position.Y,
                    Z = position.Z
                }
                Configurations[ConfigName].PointCount = Configurations[ConfigName].PointCount + 1
            end
            SaveConfigurations(true)
            ConfigNameInput.Text = "Config Name"
            RefreshConfigurations()
        else
            CreateNotification("ไม่มีจุดให้บันทึก! สร้างจุดก่อน", 2)
        end
    else
        CreateNotification("กรุณาใส่ชื่อการตั้งค่าที่ถูกต้อง!", 2)
    end
end)

ClearPointsButton.MouseButton1Click:Connect(function()
    if next(SavedPoints) then
        SavedPoints = {}
        -- Clear current config points if loaded
        if CurrentConfig and Configurations[CurrentConfig] then
            Configurations[CurrentConfig].Points = {}
            Configurations[CurrentConfig].PointCount = 0
            SaveConfigurations()
        end
        RefreshSavedPoints(CurrentSavedSearchFilter)
            CreateNotification("ลบจุดทั้งหมดแล้ว!", 2)
    else
        CreateNotification("ไม่มีจุดให้ลบ!", 2)
    end
end)

ClearConfigsButton.MouseButton1Click:Connect(function()
    if next(Configurations) then
        Configurations = {}
        SaveConfigurations(true)
        CurrentConfig = nil
        SavedPoints = {}
        RefreshConfigurations()
        RefreshSavedPoints(CurrentSavedSearchFilter)
        CreateNotification("ลบการตั้งค่าทั้งหมดแล้ว!", 2)
    else
        CreateNotification("ไม่มีการตั้งค่าให้ลบ!", 2)
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    IsVisible = not IsVisible
    if IsVisible then
        MainFrame.Visible = true
        ToggleButton.Text = "Hide GUI (F)"
        CreateNotification("แสดง GUI แล้ว", 1)
    else
        MainFrame.Visible = false
        ToggleButton.Text = "Show GUI (F)"
        CreateNotification("ซ่อน GUI แล้ว - กด F เพื่อแสดง", 1)
    end
end)

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.F then
        IsVisible = not IsVisible
        if IsVisible then
            MainFrame.Visible = true
            ToggleButton.Text = "Hide GUI (F)"
        else
            MainFrame.Visible = false
            ToggleButton.Text = "Show GUI (F)"
        end
    end
end)

-- Search functionality
local CurrentSearchFilter = ""
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    CurrentSearchFilter = SearchBox.Text
    RefreshPlayers(CurrentSearchFilter)
end)

SearchBox.Focused:Connect(function()
    if SearchBox.Text == "Search players..." then
        SearchBox.Text = ""
        SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

SearchBox.FocusLost:Connect(function(enterPressed)
    if SearchBox.Text == "" then
        SearchBox.Text = "Search players..."
        SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        CurrentSearchFilter = ""
        RefreshPlayers()
    end
end)

-- Saved points search functionality
SavedSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    CurrentSavedSearchFilter = SavedSearchBox.Text or ""
    if CurrentSavedSearchFilter == "ค้นหาจุด..." then
        CurrentSavedSearchFilter = ""
    end
    RefreshSavedPoints(CurrentSavedSearchFilter)
end)

SavedSearchBox.Focused:Connect(function()
    if SavedSearchBox.Text == "ค้นหาจุด..." then
        SavedSearchBox.Text = ""
        SavedSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

SavedSearchBox.FocusLost:Connect(function()
    if SavedSearchBox.Text == "" then
        SavedSearchBox.Text = "ค้นหาจุด..."
        SavedSearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        CurrentSavedSearchFilter = ""
        RefreshSavedPoints()
    end
end)

-- Auto refresh players every 3 seconds
while true do
    wait(3)
    if ScreenGui.Parent then
        RefreshPlayers(CurrentSearchFilter)
    else
        break
    end
end

-- Initial setup
local configsLoaded = LoadConfigurations()
RefreshPlayers()
RefreshConfigurations()
RefreshSavedPoints()
if configsLoaded then
    local configCount = 0
    for _ in pairs(Configurations) do
        configCount = configCount + 1
    end
    if configCount > 0 then
        CreateNotification("โหลดการตั้งค่าแล้ว! 📂 (" .. configCount .. " configs)", 3)
    end
end
CreateNotification("Best Teleport Script Loaded! Press F to toggle GUI.", 3)
