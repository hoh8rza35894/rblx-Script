local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SidebarUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 🌑 พื้นหลัง Frame หลัก
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true 
mainFrame.Draggable = true  

-- 💠 Sidebar ด้านซ้าย
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sidebar.Parent = mainFrame

-- 📁 พื้นที่เนื้อหาหลัก
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -100, 1, 0)
contentFrame.Position = UDim2.new(0, 100, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.Parent = mainFrame

-- ✨ สร้างหน้าแต่ละแท็บ
local tabs = {
    User = "ข้อมูลผู้ใช้",
    Map = "ข้อมูลแผนที่",
    Setting = "ตั้งค่า"
}

local tabContent = {}
for tabName, displayText in pairs(tabs) do
    local tab = Instance.new("TextLabel")
    tab.Name = tabName
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.TextScaled = true
    tab.Text = displayText
    tab.Visible = false
    tab.Parent = contentFrame
    tabContent[tabName] = tab
end

-- 🧠 ฟังก์ชันสลับแท็บ
local function switchTab(tabName)
    for name, tab in pairs(tabContent) do
        tab.Visible = (name == tabName)
    end
end

-- 🎛️ ปุ่มใน Sidebar
local y = 20
for tabName, _ in pairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = tabName
    btn.Parent = sidebar

    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)

    y = y + 40
end

-- 🔘 ปุ่มปิดทั้งหมด
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 60, 0, 25)
closeBtn.Position = UDim2.new(1, -70, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Text = "ปิด"
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- 🌟 ปุ่มซ่อนหน้าต่าง (อยู่ใน mainFrame)
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 60, 0, 25)
hideBtn.Position = UDim2.new(1, -70, 0, 40)
hideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.Text = "ซ่อน"
hideBtn.Parent = mainFrame

local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.new(0, 100, 0, 30)
miniIcon.Position = UDim2.new(0, 10, 0, 10)
miniIcon.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
miniIcon.TextColor3 = Color3.new(1, 1, 1)
miniIcon.Text = "🔲 เปิดหน้าต่าง"
miniIcon.Visible = false
miniIcon.Parent = screenGui
miniIcon.Active = true
miniIcon.Draggable = true -- ✅ ให้ลาก icon ได้

-- 💡 เมื่อกดปุ่มซ่อน
hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniIcon.Visible = true
end)
-- 💡 เมื่อกด icon เพื่อเปิดกลับ
miniIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniIcon.Visible = false
end)

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end  -- อย่าทำงานถ้า UI อื่นจับอยู่

	if input.KeyCode == Enum.KeyCode.X then
		screenGui.Enabled = false
	elseif input.KeyCode == Enum.KeyCode.Z then
		if mainFrame.Visible then
			mainFrame.Visible = false
			miniIcon.Visible = true
		else
			mainFrame.Visible = true
			miniIcon.Visible = false
		end
	end
end)



-- แสดงแท็บแรก
switchTab("User")
