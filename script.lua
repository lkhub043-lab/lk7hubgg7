-- LK7 HUB - GALAXY EDITION (AUTO GRAB)
-- OWNER: lkzz011

local CONFIG = { AUTO_STEAL_NEAREST = false }
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [LÓGICA DO JOGO - MANTIDA DO ORIGINAL]
local AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local IsStealing = false
local StealProgress = 0

-- ==========================================
-- SISTEMA DE ESTRELAS (GALAXY RENDERER)
-- ==========================================
local GalaxyGui = Instance.new("ScreenGui")
GalaxyGui.Name = "LK7_Galaxy_Background"
GalaxyGui.IgnoreGuiInset = true
GalaxyGui.Parent = PlayerGui

local function CreateStar()
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BorderSizePixel = 0
    star.BackgroundTransparency = math.random(2, 5) / 10
    star.Parent = GalaxyGui
    
    local UICorner = Instance.new("UICorner", star)
    UICorner.CornerRadius = UDim.new(1, 0)
    
    task.spawn(function()
        while star.Parent do
            local tween = TweenService:Create(star, TweenInfo.new(math.random(1, 3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            })
            tween:Play()
            task.wait(math.random(5, 10))
        end
    end)
end

for i = 1, 60 do CreateStar() end

-- ==========================================
-- NOVO PAINEL DE CONTROLE (ESTILO FOTO)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 110)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -55)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = GalaxyGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 255, 255) -- Ciano da foto

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "LK7 HUB - AUTO GRAB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
ToggleBtn.Text = "AUTO GRAB: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13

local BtnCorner = Instance.new("UICorner", ToggleBtn)
local BtnStroke = Instance.new("UIStroke", ToggleBtn)
BtnStroke.Color = Color3.fromRGB(40, 40, 45)

-- Barra de Progresso embutida no fundo
local ProgressBg = Instance.new("Frame", MainFrame)
ProgressBg.Size = UDim2.new(1, 0, 0, 3)
ProgressBg.Position = UDim2.new(0, 0, 1, -3)
ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ProgressBg.BorderSizePixel = 0

local ProgressFill = Instance.new("Frame", ProgressBg)
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
ProgressFill.BorderSizePixel = 0

-- Lógica do Botão
ToggleBtn.MouseButton1Click:Connect(function()
    CONFIG.AUTO_STEAL_NEAREST = not CONFIG.AUTO_STEAL_NEAREST
    if CONFIG.AUTO_STEAL_NEAREST then
        ToggleBtn.Text = "AUTO GRAB: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        BtnStroke.Color = Color3.fromRGB(0, 255, 255)
    else
        ToggleBtn.Text = "AUTO GRAB: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        BtnStroke.Color = Color3.fromRGB(40, 40, 45)
    end
end)

-- [MANTENDO AS FUNÇÕES ORIGINAIS DE ROUBO PARA FUNCIONAR]
-- Coloque aqui o restante da lógica de getNearestAnimal(), scanSinglePlot(), etc.
-- que já estavam no seu código original para garantir que o auto-grab funcione.

print("LK7 HUB Galaxy Edition Carregado!")
