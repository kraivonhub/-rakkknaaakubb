local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Fly = false,
    FlySpeed = 50
}

local gui = Instance.new("ScreenGui")
gui.Name = "BRMOD_V1"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- // LOGIN FRAME
local codeFrame = Instance.new("Frame")
codeFrame.Parent = gui
codeFrame.Size = UDim2.new(0, 300, 0, 180)
codeFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
codeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local codeCorner = Instance.new("UICorner", codeFrame)
codeCorner.CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", codeFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "ENTER CODE"
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)

local textBox = Instance.new("TextBox", codeFrame)
textBox.Size = UDim2.new(0, 220, 0, 45)
textBox.Position = UDim2.new(0.5, -110, 0, 60)
textBox.PlaceholderText = "ENTER KEY..."
textBox.Text = ""
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 10)

local enterButton = Instance.new("TextButton", codeFrame)
enterButton.Size = UDim2.new(0, 220, 0, 40)
enterButton.Position = UDim2.new(0.5, -110, 0, 120)
enterButton.Text = "ENTER"
enterButton.TextScaled = true
enterButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
enterButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", enterButton).CornerRadius = UDim.new(0, 10)

-- // MAIN MENU FRAME
local menuFrame = Instance.new("Frame", gui)
menuFrame.Size = UDim2.new(0, 250, 0, 300)
menuFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuFrame.Visible = false
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 15)

local function CreateBtn(text, pos, callback)
    local btn = Instance.new("TextButton", menuFrame)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0.5, -100, 0, pos)
    btn.Text = text
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- // BUTTON FUNCTIONS
CreateBtn("SPEED (TOGGLE)", 20, function()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = (hum.WalkSpeed == 16) and 50 or 16 end
end)

CreateBtn("INVISIBLE", 75, function()
    if player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
        end
    end
end)

CreateBtn("TINY MODE", 130, function()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then
        local vars = {"HeadScale", "BodyDepthScale", "BodyWidthScale", "BodyHeightScale"}
        for _, v in pairs(vars) do
            if hum:FindFirstChild(v) then hum[v].Value = 0.2 end
        end
    end
end)

CreateBtn("FLY & NOCLIP", 185, function()
    Settings.Fly = not Settings.Fly
end)

-- // LOGIN LOGIC
enterButton.MouseButton1Click:Connect(function()
    if textBox.Text == "raknaja" then
        codeFrame.Visible = false
        menuFrame.Visible = true
    else
        textBox.Text = ""
        textBox.PlaceholderText = "WRONG CODE"
    end
end)

-- // CORE FLY & NOCLIP LOOP
RunService.Stepped:Connect(function()
    if Settings.Fly and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
        local HRP = player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local BV = HRP:FindFirstChild("RUOT_Fly") or Instance.new("BodyVelocity", HRP)
            BV.Name = "RUOT_Fly"
            BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local Vel = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then Vel = Camera.CFrame.LookVector * Settings.FlySpeed
            elseif UIS:IsKeyDown(Enum.KeyCode.S) then Vel = Camera.CFrame.LookVector * -Settings.FlySpeed end
            BV.Velocity = Vel
        end
    else
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local f = player.Character.HumanoidRootPart:FindFirstChild("RUOT_Fly")
            if f then f:Destroy() end
        end
    end
end)

