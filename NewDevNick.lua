local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Lighting = game:GetService("Lighting")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
for _, child in ipairs(Lighting:GetChildren()) do
    child:Destroy()
end
local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Scripts = Window:AddTab({ Title = "Scripts", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options



local scriptList = {"Infinit", "Build Island", "Ink Game by AlexScriptX", "Steal a Brainrot"}
local scriptDropdown = Tabs.Scripts:AddDropdown("ScriptSelector", {
    Title = "Select Script",
    Values = scriptList,
    Multi = false,
    Default = nil,
})
scriptDropdown:OnChanged(function(Value)
    print("Selected Player:", Value)
    if Value == "Infinit" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hoh8rza35894/rblx-Script/refs/heads/main/infinit_source.lua"))()
    elseif Value == "Build Island" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/buildanisland.lua"))()
    elseif Value == "Ink Game by AlexScriptX" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexScriptX/Ink-Game-Script/refs/heads/main/Ink%20Game%20by%20AlexScriptX.lua"))()
    elseif Value == "Steal a Brainrot" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Youifpg/Steal-a-Brainrot-op/refs/heads/main/Arbixhub-obfuscated.lua"))()
    end
end)

-- 💤 Toggle Switch AFK
local isAFK = false
local afkLoop = nil  -- 🌙 สำหรับหยุดลูปเมื่อปิด AFK
local function jump()
	local char = player.Character
	if char then
		local humanoid = char:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end

-- 🚶 เดิน 1 ก้าวแบบกำหนดทิศทาง
local function stepMove(direction , radius)
	local char = player.Character
	if not char then return end

	local humanoid = char:FindFirstChildWhichIsA("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end

	-- กำหนดทิศทาง
	local dirVector = Vector3.zero
	if direction == "forward" then
		dirVector = Vector3.new(0, 0, -1)
	elseif direction == "back" then
		dirVector = Vector3.new(0, 0, 1)
	elseif direction == "left" then
		dirVector = Vector3.new(-1, 0, 0)
	elseif direction == "right" then
		dirVector = Vector3.new(1, 0, 0)
	else
		warn("⚠️ ทิศทางไม่ถูกต้อง: " .. tostring(direction))
		return
	end

	local goalPos = root.Position + (dirVector * radius) -- ระยะก้าว

	-- เดินจริง
	humanoid:MoveTo(goalPos)
	humanoid.MoveToFinished:Wait(1)
end


Tabs.Main:AddButton({
    Title = "Move to top (หัวทะลุ)",
    Description = "ให้หัวทะลุเพดาน ส่วนขายังเหยียบแท่น",
    Callback = function()
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")

        -- 👤 หาความสูงจาก root ถึงหัว
        local head = char:FindFirstChild("Head")
        if not head then return end

        local heightOffset = (head.Position - root.Position).Y

        -- 🔍 ยิง ray หาเพดานจากเหนือหัวขึ้นไป
        local rayOrigin = head.Position
        local rayDirection = Vector3.new(0, 10, 0) -- ขึ้นไป 10 studs
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Blacklist

        local result = workspace:Raycast(rayOrigin, rayDirection, params)

        local maxLift = 100 -- fallback ถ้าไม่เจอเพดาน
        if result then
            local distToCeiling = (result.Position - root.Position).Y
            -- ลบ heightOffset เล็กน้อย เพื่อให้หัวทะลุ
            maxLift = distToCeiling - heightOffset + 0.5
        end

        -- 🧱 สร้างแท่นลอย
        local platform = Instance.new("Part")
        platform.Anchored = true
        platform.Size = Vector3.new(10, 1, 10)
        platform.Position = root.Position - Vector3.new(0, 3, 0)
        platform.Name = "SmartPlatform"
        platform.Parent = workspace

        -- 🪜 ยกแท่นขึ้นจนหัวจะชนเพดาน
        local step = 1.5
        local total = 0

        while total < maxLift do
            platform.Position += Vector3.new(0, step, 0)
            total += step
            task.wait(0.03)
        end

        -- (Optional) รอแล้วค่อยลบ
        task.wait(1)
        platform:Destroy()
    end
})


Tabs.Main:AddButton({
    Title = "💀 Respawn & Teleport (Delay)",
    Description = "ฆ่าตัวเองแล้ววาร์ปด้วย delay",
    Callback = function()
        local connection
        connection = player.CharacterAdded:Connect(function(char)
            local root = char:WaitForChild("HumanoidRootPart")

            -- รอ 0.2 วิ ก่อนวาร์ป
            task.delay(0.2, function()
                if root and root:IsDescendantOf(workspace) then
                    root.CFrame = CFrame.new(400, 30, 400)
                end
            end)

            connection:Disconnect()
        end)

        -- ฆ่าตัวเอง
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
})

-- Add toggle for auto-trade
local AFKToggle = Tabs.Main:AddToggle("AFKToggle", {Title = "Enable AFK", Default = false })
AFKToggle:OnChanged(function(value)
    isAFK = value  -- สลับสถานะตรงนี้
    print("AFK is now", isAFK and "enabled" or "disabled")

    if isAFK then
        -- 🔁 เริ่มลูป AFK
        afkLoop = coroutine.create(function()
            while isAFK do
                jump()
                wait(1)
                stepMove("forward", 3)
                wait(1)
                stepMove("back", 3)
                wait(1)
                stepMove("left", 3)
                wait(1)
                stepMove("right", 3)
                wait(5)
            end
        end)
        coroutine.resume(afkLoop)
    else
        -- 🛑 หยุดลูป AFK
        if afkLoop and coroutine.status(afkLoop) == "suspended" then
            coroutine.close(afkLoop)
        end
        afkLoop = nil
    end
end)

-- Dropdown to select target player for trade
local PlayerNames = {}
local DisplayToPlayerMap = {}

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        local displayName = plr.DisplayName .. " [" .. plr.Name .. "]"
        table.insert(PlayerNames, displayName)
        DisplayToPlayerMap[displayName] = plr.Name  -- map กลับไปยัง username
    end
end


local TargetDropdown = Tabs.Main:AddDropdown("TargetDropdown", {
    Title = "Select Player",
    Values = PlayerNames,
    Multi = false
})

TargetDropdown:OnChanged(function(Value)
    selectedTarget = Value
    print("Target selected:", selectedTarget)

    local myChar = player.Character or player.CharacterAdded:Wait()
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")

      local actualPlayerName = DisplayToPlayerMap[selectedTarget]
    local targetPlayer = Players:FindFirstChild(actualPlayerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = targetPlayer.Character.HumanoidRootPart
        myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0) -- วาร์ปไปด้านบนของเป้าหมาย
    end
end)

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        TargetDropdown:Add(player.Name)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    TargetDropdown:Remove(player.Name)
end)


local savedCFrame = nil

-- 📍 ปุ่ม Save จุดปัจจุบัน
Tabs.Main:AddButton({
    Title = "📌 Save ไ",
    Description = "บันทึกตำแหน่งที่คุณอยู่",
    Callback = function()
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            savedCFrame = root.CFrame
            print("📌 Saved position at:", savedCFrame.Position)
            Fluent:Notify({
                Title = "Position Saved",
                Content = "บันทึกตำแหน่งเรียบร้อยแล้ว!",
                Duration = 3
            })
        end
    end
})

-- 🔙 ปุ่ม Go Back
Tabs.Main:AddButton({
    Title = "🔙 กลับจุดที่ Save",
    Description = "วาร์ปกลับไปยังตำแหน่งที่บันทึกไว้",
    Callback = function()
        if savedCFrame then
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = savedCFrame
                Fluent:Notify({
                    Title = "Teleported Back",
                    Content = "วาร์ปกลับจุดที่บันทึกแล้ว!",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title = "ยังไม่ได้บันทึกจุด!",
                Content = "กดปุ่ม Save ก่อนนะ!",
                Duration = 3
            })
        end
    end
})


-- Initialize GUI
Window:SelectTab(1)
Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()
