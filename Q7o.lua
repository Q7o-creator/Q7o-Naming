local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")

local selectedPlayer = nil
local talbiqLoop = false 

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Q7oClancsGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- MainFrame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 340)
frame.Position = UDim2.new(0.5, -225, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Visible = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

-- MiniFrame
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.new(0,50,0,50)
miniFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
miniFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Parent = screenGui
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(0,10)
miniFrame.BorderColor3 = Color3.fromRGB(255,0,0)
miniFrame.BorderSizePixel = 3

local miniText = Instance.new("TextLabel")
miniText.Size = UDim2.new(1,0,1,0)
miniText.BackgroundTransparency = 1
miniText.Text = "Q7o"
miniText.TextColor3 = Color3.fromRGB(0,0,0)
miniText.Font = Enum.Font.Bangers
miniText.TextScaled = true
miniText.Parent = miniFrame

local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(1,0,1,0)
miniButton.BackgroundTransparency = 1
miniButton.Text = ""
miniButton.Parent = miniFrame

-- [ وظيفة السحب ]
local function makeDraggable(gui, dragPart)
    local dragging, dragInput, dragStart, startPos
    dragPart = dragPart or gui
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(frame)
makeDraggable(miniFrame, miniButton)

miniButton.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    frame.Visible = true
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,40,0,30)
minimizeBtn.Position = UDim2.new(1,-50,0,10)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,5)
minimizeBtn.Parent = frame
minimizeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	miniFrame.Position = frame.Position
	miniFrame.Visible = true
end)

-- Tabs Setup
local tabButtons = Instance.new("Frame")
tabButtons.Size = UDim2.new(1,-30,0,50); tabButtons.Position = UDim2.new(0,15,0,70); tabButtons.BackgroundTransparency = 1; tabButtons.Parent = frame

local function createTabButton(name,posX)
	local btn = Instance.new("TextButton")
	btn.Text = name; btn.Size = UDim2.new(0,100,0,40); btn.Position = UDim2.new(0,posX,0,0)
	btn.BackgroundColor3 = Color3.fromRGB(80,80,80); btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Parent = tabButtons; Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
	return btn
end

local combatBtn = createTabButton("قتال",0); local playerBtn = createTabButton("لاعب",105)
local visualBtn = createTabButton("عرض",210); local sabotageBtnTab = createTabButton("تخريب",315)

local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1,-30,1,-130); tabs.Position = UDim2.new(0,15,0,130); tabs.BackgroundTransparency = 1; tabs.Parent = frame

local function createTab(name, color)
	local t = Instance.new("Frame"); t.Name = name.."Tab"; t.Size = UDim2.new(1,0,1,0); t.BackgroundColor3 = color; t.Visible = false; t.Parent = tabs
	Instance.new("UICorner", t).CornerRadius = UDim.new(0,12)
	return t
end

local combatTab = createTab("قتال", Color3.fromRGB(200,50,50)); local playerTab = createTab("لاعب", Color3.fromRGB(50,200,50))
local visualTab = createTab("عرض", Color3.fromRGB(50,50,200)); local sabotageTab = createTab("تخريب", Color3.fromRGB(200,200,50))
combatTab.Visible = true

local function switchTab(name) for _,t in pairs(tabs:GetChildren()) do if t:IsA("Frame") then t.Visible = (t.Name == name.."Tab") end end end
combatBtn.MouseButton1Click:Connect(function() switchTab("قتال") end); playerBtn.MouseButton1Click:Connect(function() switchTab("لاعب") end)
visualBtn.MouseButton1Click:Connect(function() switchTab("عرض") end); sabotageBtnTab.MouseButton1Click:Connect(function() switchTab("تخريب") end)

-- [ الميزات الأساسية ]
local function createValueToggle(tab,name,yPos,callback)
	local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0,120,0,35); btn.Position = UDim2.new(0,10,0,yPos); btn.Text = name; btn.Parent = tab
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
	local box = Instance.new("TextBox"); box.Size = UDim2.new(0,50,0,30); box.Position = UDim2.new(0,140,0,yPos); box.PlaceholderText = "0"; box.Parent = tab
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)
	local active = false
	btn.MouseButton1Click:Connect(function()
		local value = tonumber(box.Text)
		if value then active = not active; btn.BackgroundColor3 = active and Color3.fromRGB(0,180,0) or Color3.fromRGB(70,70,70); callback(value, active) end
	end)
end

createValueToggle(combatTab,"سرعة",10,function(v,a) humanoid.WalkSpeed = a and v or 16 end)
createValueToggle(combatTab,"قفز",55,function(v,a) humanoid.JumpPower = a and v or 50 end)

-- ميزة الطيران (Fly)
local flying = false
createValueToggle(combatTab,"طيران",100,function(v,a)
	flying = a; if a then local bv = Instance.new("BodyVelocity", rootPart); bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	task.spawn(function() while flying do local dir = Vector3.zero
	if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
	bv.Velocity = dir.Magnitude > 0 and dir.Unit * v or Vector3.zero; task.wait() end; bv:Destroy() end) end
end)

-- ميزة تخطي الجدران (Noclip)
local noclip = false; local nBtn = Instance.new("TextButton")
nBtn.Size = UDim2.new(0,150,0,35); nBtn.Position = UDim2.new(0,10,0,10); nBtn.Text = "تخطي"; nBtn.Parent = playerTab
Instance.new("UICorner", nBtn); nBtn.MouseButton1Click:Connect(function() noclip = not noclip; nBtn.BackgroundColor3 = noclip and Color3.fromRGB(0,180,0) or Color3.fromRGB(70,70,70) end)
RunService.Stepped:Connect(function() if noclip then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

-- ميزة ESP
local espEnabled = false; local espFolder = Instance.new("Folder", workspace); local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0,150,0,40); espBtn.Position = UDim2.new(0,10,0,10); espBtn.Text = "ESP اللاعبين"; espBtn.Parent = visualTab
Instance.new("UICorner", espBtn); espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled; espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0,180,0) or Color3.fromRGB(70,70,70)
	if espEnabled then for _,plr in pairs(Players:GetPlayers()) do if plr ~= player and plr.Character then local h = Instance.new("Highlight", espFolder); h.Adornee = plr.Character end end else espFolder:ClearAllChildren() end
end)

-- [ قسم التخريب الكامل ]
local selectPlayerBtn = Instance.new("TextButton"); selectPlayerBtn.Size = UDim2.new(1,-20,0,35); selectPlayerBtn.Position = UDim2.new(0,10,0,10); selectPlayerBtn.Text = "تحديد لاعب باللمس 🎯"; selectPlayerBtn.Parent = sabotageTab
Instance.new("UICorner", selectPlayerBtn)
local function createSaboAction(name, yPos, callback)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,-20,0,30); btn.Position = UDim2.new(0,10,0,yPos); btn.Text = name; btn.Parent = sabotageTab
    Instance.new("UICorner", btn); btn.MouseButton1Click:Connect(callback)
end
createSaboAction("1- تلبيق (تشغيل/إيقاف)", 55, function()
    if not selectedPlayer then return end; talbiqLoop = not talbiqLoop
    if talbiqLoop then task.spawn(function() for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end
    while talbiqLoop do if not selectedPlayer or not selectedPlayer.Character then break end
    rootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.4); humanoid:ChangeState(Enum.HumanoidStateType.Swimming); rootPart.Velocity = rootPart.CFrame.LookVector * 8; task.wait(0.01) end
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp); for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = true end end end) end
end)
createSaboAction("2- يمص", 95, function() if selectedPlayer and selectedPlayer.Character then local b = Instance.new("BodyAngularVelocity", rootPart); b.AngularVelocity = Vector3.new(0,9999,0); b.MaxTorque = Vector3.new(0,math.huge,0); rootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame; task.wait(0.2); b:Destroy() end end)
createSaboAction("3- مشاهدة", 135, function() if selectedPlayer then workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid end end)
createSaboAction("4- تنقل", 175, function() if selectedPlayer then rootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame end end)

selectPlayerBtn.MouseButton1Click:Connect(function()
	local tool = Instance.new("Tool"); tool.RequiresHandle = false; tool.Parent = player.Backpack
	tool.Activated:Connect(function()
		local t = player:GetMouse().Target
		if t and t.Parent and Players:GetPlayerFromCharacter(t.Parent) then selectedPlayer = Players:GetPlayerFromCharacter(t.Parent); selectPlayerBtn.Text = "المحدد: "..selectedPlayer.Name; tool:Destroy() end
	end)
end)

