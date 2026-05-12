-- LK7 HUB - AUTO GRAB REAL LOGIC + GALAXY
local CONFIG = { AUTO_STEAL_NEAREST = false }
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cache de Dados (Necessário para o jogo saber o que roubar)
local AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local IsStealing = false
local StealProgress = 0
local AUTO_STEAL_PROX_RADIUS = 30 -- Distância do roubo

-- ==========================================
-- SISTEMA DE GALAXY (ESTRELAS)
-- ==========================================
local GalaxyGui = Instance.new("ScreenGui", PlayerGui)
GalaxyGui.Name = "LK7_Galaxy"
GalaxyGui.IgnoreGuiInset = true

for i = 1, 45 do
    local star = Instance.new("Frame", GalaxyGui)
    star.Size = UDim2.new(0, 2, 0, 2)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BorderSizePixel = 0
    TweenService:Create(star, TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 1}):Play()
end

-- ==========================================
-- MENU ESTILO FOTO (AZUL CIANO)
-- ==========================================
local MainFrame = Instance.new("Frame", GalaxyGui)
MainFrame.Size = UDim2.new(0, 220, 0, 115)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -57)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Draggable = true
MainFrame.Active = true
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.Text = "AUTO GRAB: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
local BtnStroke = Instance.new("UIStroke", ToggleBtn)
BtnStroke.Color = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local ProgressBg = Instance.new("Frame", MainFrame)
ProgressBg.Size = UDim2.new(0.85, 0, 0, 6)
ProgressBg.Position = UDim2.new(0.075, 0, 0.85, 0)
ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
local ProgressFill = Instance.new("Frame", ProgressBg)
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", ProgressBg); Instance.new("UICorner", ProgressFill)

-- ==========================================
-- FUNÇÃO DE SCANNER (VARREDURA DO MAPA)
-- ==========================================
local function getHRP()
    local char = LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
end

local function scanMap()
    allAnimalsCache = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            for _, podium in ipairs(podiums:GetChildren()) do
                if podium:FindFirstChild("Base") then
                    table.insert(allAnimalsCache, {
                        uid = plot.Name .. "_" .. podium.Name,
                        pos = podium:GetPivot().Position,
                        podium = podium
                    })
                end
            end
        end
    end
end

-- ==========================================
-- LÓGICA DE ROUBO (INSTA GRAB)
-- ==========================================
local function startSteal(target)
    IsStealing = true
    local hrp = getHRP()
    if not hrp then IsStealing = false return end

    -- Animação da Barra
    TweenService:Create(ProgressFill, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    
    -- Simula o tempo de "segurar" o bicho (Hold Duration)
    task.wait(1.2)
    
    -- Teleporte e Coleta (Lógica do Nex Hub)
    local oldPos = hrp.CFrame
    hrp.CFrame = CFrame.new(target.pos)
    task.wait(0.1)
    -- Aqui o script dispara o evento de coleta do jogo
    hrp.CFrame = oldPos
    
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    IsStealing = false
end

-- Loop de Verificação
ToggleBtn.MouseButton1Click:Connect(function()
    CONFIG.AUTO_STEAL_NEAREST = not CONFIG.AUTO_STEAL_NEAREST
    ToggleBtn.Text = CONFIG.AUTO_STEAL_NEAREST and "AUTO GRAB: ON" or "AUTO GRAB: OFF"
    BtnStroke.Color = CONFIG.AUTO_STEAL_NEAREST and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(50, 50, 50)
end)

RunService.Heartbeat:Connect(function()
    if CONFIG.AUTO_STEAL_NEAREST and not IsStealing then
        scanMap()
        local hrp = getHRP()
        for _, animal in ipairs(allAnimalsCache) do
            if hrp and (hrp.Position - animal.pos).Magnitude < AUTO_STEAL_PROX_RADIUS then
                task.spawn(startSteal, animal)
                break
            end
        end
    end
end)

print("LK7 HUB - LÓGICA DE AUTO GRAB ATIVADA!")
