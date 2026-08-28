-- NETRIX HUB | Universal & PVP (Versão PC & Mobile - Bordas Retas)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Links
local DiscordLink = "https://discord.gg/5TFHuucxgw"
local YoutubeLink = "https://www.youtube.com/@Netrixofc"

-- Estado Global de Configurações
local Settings = {
    -- Aimbot
    AimBotEnabled = false,
    ShowFOV = false,
    FOVRadius = 120,
    Smoothness = 1,
    MaxDistance = 1000,
    IgnoreDowned = false,
    TeamCheck = false,
    
    -- ESP
    ESPEnabled = true,
    ESPBoxEnabled = false,
    ESPSkeletonEnabled = false,
    ESPLineEnabled = false,
    ESPNameEnabled = false,
    ESPLineOrigin = "Baixo",
    
    -- Player & Visual
    SpinbotEnabled = false,
    SpinSpeed = 50,
    FullBright = false,
    RemoveFog = false,
    
    -- Keybinds (PC)
    ToggleKey = Enum.KeyCode.RightShift,
    AimbotKey = Enum.KeyCode.Unknown,
    ESPKey = Enum.KeyCode.Unknown
}

-- Guardar iluminação original
local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd
}

-- --- Interface Principal (ScreenGui) ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NetrixHubPC"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Notificação Toast (Quadrada)
local function ShowNotification(title, text)
    local notif = Instance.new("Frame", ScreenGui)
    notif.Size = UDim2.new(0, 210, 0, 48)
    notif.Position = UDim2.new(1, 20, 1, -65)
    notif.BackgroundColor3 = Color3.fromRGB(22, 20, 28)
    notif.BorderSizePixel = 0
    
    local stroke = Instance.new("UIStroke", notif)
    stroke.Color = Color3.fromRGB(138, 43, 226)
    stroke.Thickness = 1.2

    local tLabel = Instance.new("TextLabel", notif)
    tLabel.Text = title
    tLabel.Size = UDim2.new(1, -10, 0, 20)
    tLabel.Position = UDim2.new(0, 10, 0, 4)
    tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 11
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1

    local bLabel = Instance.new("TextLabel", notif)
    bLabel.Text = text
    bLabel.Size = UDim2.new(1, -10, 0, 18)
    bLabel.Position = UDim2.new(0, 10, 0, 22)
    bLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    bLabel.Font = Enum.Font.Gotham
    bLabel.TextSize = 10
    bLabel.TextXAlignment = Enum.TextXAlignment.Left
    bLabel.BackgroundTransparency = 1

    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -220, 1, -65)}):Play()
    task.delay(2.5, function()
        local tw = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -65)})
        tw:Play()
        tw.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- Janela Principal (Com ponta / quadrada)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 350)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.BorderSizePixel = 0

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 1.5

-- Top Bar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "NETRIX HUB | Universal"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 5)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 28, 45)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.BorderSizePixel = 0

-- Botão Flutuante (Mobile / Atalho)
local FloatingButton = Instance.new("
  
