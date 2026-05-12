-- Wait for game to load
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- WHITELIST (lowercase usernames)
-- =========================
local Whitelist = {
    ["lkzz011"] = true,
    ["liljaylookscool_9"] = true,
    ["staqi1984"] = true,
    ["imyourboy91"] = true,
    ["argofficiai"] = true,
    ["aka_boy29"] = true
}

-- =========================
-- CHECK
-- =========================
if not Whitelist[string.lower(LocalPlayer.Name)] then
    LocalPlayer:Kick("You are not whitelisted to use this script.")
end


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer

-- Cleanup previous
if _G.MergedSemiTPCleanup then pcall(_G.MergedSemiTPCleanup) end
_G.MergedSemiTPCleanup = function()
    if _G.MergedConnections then
        for _, conn in ipairs(_G.MergedConnections) do pcall(function() conn:Disconnect() end) end
        _G.MergedConnections = {}
    end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name:find("ESPBox_") or obj.Name:find("Cosmic") then
            pcall(function() obj:Destroy() end)
        end
    end
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        local g = pg:FindFirstChild("UGC_SemiTP")
        if g then pcall(function() g:Destroy() end) end
    end
    _G.MergedSemiTPActive = false
end
pcall(_G.MergedSemiTPCleanup)

local connections = {}
_G.MergedConnections = connections
_G.MergedSemiTPActive = true

-- =============================================
--   COLORS (PURPLE THEME)
-- =============================================
local NEON_PURPLE   = Color3.fromRGB(157, 78, 221)
local ACCENT_PURPLE = Color3.fromRGB(123, 44, 177)
local LIGHT_PURPLE  = Color3.fromRGB(200, 150, 255)
local BG_DARK       = Color3.fromRGB(12, 10, 18)
local BTN_DARK      = Color3.fromRGB(22, 18, 32)

-- =============================================
--   POSITIONS (from Cxrsxd)
-- =============================================
local pos1      = Vector3.new(-352.98, -7,    74.30)
local pos2      = Vector3.new(-352.98, -6.49, 45.76)
local standing1 = Vector3.new(-336.36, -4.59, 99.51)
local standing2 = Vector3.new(-334.81, -4.59, 18.90)

local spot1_sequence = {
    CFrame.new(-370.810913, -7.00000334, 41.2687263,  0.99984771,  1.22364419e-09,  0.0174523517, -6.54859778e-10, 1, -3.2596418e-08, -0.0174523517,  3.25800258e-08,  0.99984771),
    CFrame.new(-336.355286, -5.10107088, 17.2327671, -0.999883354, -2.76150569e-08,  0.0152716246, -2.88224964e-08, 1, -7.88441525e-08, -0.0152716246, -7.9275118e-08, -0.999883354)
}
local spot2_sequence = {
    CFrame.new(-354.782867, -7.00000334, 92.8209305, -0.999997616, -1.11891862e-09, -0.00218066527, -1.11958298e-09, 1, 3.03415071e-10, 0.00218066527, 3.05855785e-10, -0.999997616),
    CFrame.new(-336.942902, -5.10106993, 99.3276443,  0.999914348, -3.63984611e-08,  0.0130875716,  3.67094941e-08, 1, -2.35254749e-08, -0.0130875716,  2.40038975e-08,  0.999914348)
}

local autoSemiTpLeft  = CFrame.new(-349.325867, -7.00000238, 95.0031433, -0.999048233, -8.29406233e-09, -0.0436184891, -1.03892832e-08, 1, 4.78084594e-08,  0.0436184891, 4.82161227e-08, -0.999048233)
local autoSemiTpRight = CFrame.new(-349.560211, -7.00000238, 27.0543289, -0.999961913,  5.50995267e-08, -0.00872585084, 5.48100907e-08, 1, 3.34090586e-08,  0.00872585084, 3.29295204e-08, -0.999961913)

-- =============================================
--   ESP BOXES (PURPLE)
-- =============================================
local function createESPBox(position, labelText)
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESPBox_" .. labelText
    espFolder.Parent = workspace

    local box = Instance.new("Part")
    box.Name = "ESPPart"
    box.Size = Vector3.new(5, 0.5, 5)
    box.Position = position
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = 0.65
    box.Material = Enum.Material.Neon
    box.Color = ACCENT_PURPLE
    box.Parent = espFolder

    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Adornee = box
    selectionBox.LineThickness = 0.04
    selectionBox.Color3 = NEON_PURPLE
    selectionBox.SurfaceColor3 = ACCENT_PURPLE
    selectionBox.Parent = box

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Adornee = box
    billboard.Size = UDim2.new(0, 160, 0, 32)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = box

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = labelText
    textLabel.TextColor3 = LIGHT_PURPLE
    textLabel.TextSize = 15
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.2
    textLabel.TextStrokeColor3 = ACCENT_PURPLE
    textLabel.Parent = billboard

    return espFolder
end

createESPBox(pos1,                      "Teleport Here")
createESPBox(pos2,                      "Teleport Here")
createESPBox(standing1,                 "Standing 1")
createESPBox(standing2,                 "Standing 2")
createESPBox(autoSemiTpLeft.Position,   "Auto tp Left")
createESPBox(autoSemiTpRight.Position,  "Auto tp Right")



-- =============================================
--   STATE
-- =============================================
local desyncActivated    = false
local halfTpEnabled      = false
local IsStealing         = false
local StealProgress      = 0
local CurrentStealTarget = nil
local CONFIG = { ANTI_STEAL_ACTIVE = false }

-- =============================================
--   HELPERS
-- =============================================
local function getHRP()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
end

local function equipCarpet()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    local carpet = char:FindFirstChild("Flying Carpet") or backpack:FindFirstChild("Flying Carpet")
    if carpet then hum:EquipTool(carpet) end
end

-- =============================================
--   FFLAGS (Cxrsxd)
-- =============================================
local function applyFFlags()
    local flags = {
        {"GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-5000"},
        {"LargeReplicatorWrite5", "true"},
        {"LargeReplicatorEnabled9", "true"},
        {"AngularVelociryLimit", "360"},
        {"TimestepArbiterVelocityCriteriaThresholdTwoDt", "2147483646"},
        {"S2PhysicsSenderRate", "15000"},
        {"DisableDPIScale", "true"},
        {"MaxDataPacketPerSend", "2147483647"},
        {"ServerMaxBandwith", "52"},
        {"PhysicsSenderMaxBandwidthBps", "20000"},
        {"MaxTimestepMultiplierBuoyancy", "2147483647"},
        {"SimOwnedNOUCountThresholdMillionth", "2147483647"},
        {"MaxMissedWorldStepsRemembered", "-2147483648"},
        {"CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth", "1"},
        {"StreamJobNOUVolumeLengthCap", "2147483647"},
        {"DebugSendDistInSteps", "-2147483648"},
        {"MaxTimestepMultiplierAcceleration", "2147483647"},
        {"LargeReplicatorRead5", "true"},
        {"SimExplicitlyCappedTimestepMultiplier", "2147483646"},
        {"GameNetDontSendRedundantNumTimes", "1"},
        {"CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent", "1"},
        {"CheckPVCachedRotVelThresholdPercent", "10"},
        {"LargeReplicatorSerializeRead3", "true"},
        {"ReplicationFocusNouExtentsSizeCutoffForPauseStuds", "2147483647"},
        {"NextGenReplicatorEnabledWrite4", "true"},
        {"CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth", "1"},
        {"GameNetDontSendRedundantDeltaPositionMillionth", "1"},
        {"InterpolationFrameVelocityThresholdMillionth", "5"},
        {"StreamJobNOUVolumeCap", "2147483647"},
        {"InterpolationFrameRotVelocityThresholdMillionth", "5"},
        {"WorldStepMax", "30"},
        {"TimestepArbiterHumanoidLinearVelThreshold", "1"},
        {"InterpolationFramePositionThresholdMillionth", "5"},
        {"TimestepArbiterHumanoidTurningVelThreshold", "1"},
        {"MaxTimestepMultiplierContstraint", "2147483647"},
        {"GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-5000"},
        {"CheckPVCachedVelThresholdPercent", "10"},
        {"TimestepArbiterOmegaThou", "1073741823"},
        {"MaxAcceptableUpdateDelay", "1"},
        {"LargeReplicatorSerializeWrite4", "true"},
    }
    for _, data in ipairs(flags) do
        pcall(function() if setfflag then setfflag(data[1], data[2]) end end)
    end
end

local function respawnPlayer()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
        char:ClearAllChildren()
        local f = Instance.new("Model", workspace)
        player.Character = f
        task.wait()
        player.Character = char
        f:Destroy()
    end
end

-- =============================================
--   ANIMAL SCANNER
-- =============================================
local allAnimalsCache    = {}
local PromptMemoryCache  = {}
local InternalStealCache = {}
local AUTO_STEAL_PROX_RADIUS = 200

local function isMyBase(plotName)
    local plot = workspace.Plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    return sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled
end

local function scanSinglePlot(plot)
    if not plot or not plot:IsA("Model") or isMyBase(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    for _, podium in ipairs(podiums:GetChildren()) do
        if podium:IsA("Model") and podium:FindFirstChild("Base") then
            table.insert(allAnimalsCache, {
                plot = plot.Name,
                slot = podium.Name,
                worldPosition = podium:GetPivot().Position,
                uid = plot.Name .. "_" .. podium.Name,
            })
        end
    end
end

local function initializeScanner()
    task.wait(2)
    local plots = workspace:WaitForChild("Plots", 10)
    for _, plot in ipairs(plots:GetChildren()) do scanSinglePlot(plot) end
    plots.ChildAdded:Connect(scanSinglePlot)
    task.spawn(function()
        while task.wait(5) do
            table.clear(allAnimalsCache)
            for _, plot in ipairs(plots:GetChildren()) do scanSinglePlot(plot) end
        end
    end)
end

local function findPrompt(animal)
    local cached = PromptMemoryCache[animal.uid]
    if cached and cached.Parent then return cached end
    local plot   = workspace.Plots:FindFirstChild(animal.plot)
    local podium = plot and plot.AnimalPodiums:FindFirstChild(animal.slot)
    local prompt = podium and podium.Base.Spawn.PromptAttachment:FindFirstChildOfClass("ProximityPrompt")
    if prompt then PromptMemoryCache[animal.uid] = prompt end
    return prompt
end

local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 then for _, c in ipairs(conns1) do table.insert(data.holdCallbacks, c.Function) end end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 then for _, c in ipairs(conns2) do table.insert(data.triggerCallbacks, c.Function) end end
    InternalStealCache[prompt] = data
end

local function getNearestAnimal()
    local hrp = getHRP()
    if not hrp then return nil end
    local nearest, dist = nil, math.huge
    for _, animal in ipairs(allAnimalsCache) do
        local d = (hrp.Position - animal.worldPosition).Magnitude
        if d < dist and d <= AUTO_STEAL_PROX_RADIUS then dist = d; nearest = animal end
    end
    return nearest
end

-- =============================================
--   STEAL EXECUTOR (Cxrsxd)
-- =============================================
local function executeSteal(sequence)
    if IsStealing then return end
    local animal = getNearestAnimal()
    if not animal then return end
    local prompt = findPrompt(animal)
    if not prompt then return end
    buildStealCallbacks(prompt)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then return end

    data.ready = false
    IsStealing = true
    StealProgress = 0
    CurrentStealTarget = animal
    CONFIG.ANTI_STEAL_ACTIVE = true

    local tpDone = false

    task.spawn(function()
        equipCarpet()
        task.wait(0.07)

        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end

        local startTime = tick()
        while tick() - startTime < 1.3 do
            StealProgress = (tick() - startTime) / 1.3

            if StealProgress >= 0.73 and not tpDone then
                tpDone = true
                local hrp = getHRP()
                if hrp then
                    hrp.CFrame = sequence[1]
                    task.wait(0.1)
                    hrp.CFrame = sequence[2]
                    task.wait(0.2)
                    local d1 = (hrp.Position - pos1).Magnitude
                    local d2 = (hrp.Position - pos2).Magnitude
                    hrp.CFrame = CFrame.new(d1 < d2 and pos1 or pos2)
                end
            end

            task.wait()
        end

        StealProgress = 1
        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
        task.wait(0.2)
        data.ready = true
        IsStealing = false
        StealProgress = 0
        CurrentStealTarget = nil
        CONFIG.ANTI_STEAL_ACTIVE = false
    end)
end

-- =============================================
--   HALF TP
-- =============================================
local currentEquipTask = nil
local isHolding = false

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, plr)
    if plr ~= player or not halfTpEnabled then return end
    isHolding = true
    if currentEquipTask then task.cancel(currentEquipTask) end
    currentEquipTask = task.spawn(function()
        task.wait(1)
        if isHolding and halfTpEnabled then equipCarpet() end
    end)
end)

ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, plr)
    if plr ~= player then return end
    isHolding = false
    if currentEquipTask then task.cancel(currentEquipTask) end
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt, plr)
    if plr ~= player or not halfTpEnabled then return end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local d1 = (root.Position - pos1).Magnitude
        local d2 = (root.Position - pos2).Magnitude
        root.CFrame = CFrame.new(d1 < d2 and pos1 or pos2)
    end
    isHolding = false
end)

-- =============================================
--   GUI
-- =============================================
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "FLUX_SemiTP"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 380)
main.Position = UDim2.new(0.5, -140, 0.5, -190)
main.BackgroundColor3 = BG_DARK
main.BackgroundTransparency = 0.12
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = NEON_PURPLE
mainStroke.Thickness = 2

local titleLabel = Instance.new("TextLabel", main)
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Text = "FLUX SCRIPTS SEMI INSTA STEAL"
titleLabel.TextColor3 = NEON_PURPLE
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 17
titleLabel.BackgroundTransparency = 1

local divider = Instance.new("Frame", main)
divider.Size = UDim2.new(0.85, 0, 0, 1)
divider.Position = UDim2.new(0.075, 0, 0, 50)
divider.BackgroundColor3 = NEON_PURPLE
divider.BackgroundTransparency = 0.4
divider.BorderSizePixel = 0

-- =============================================
--   BUTTON FACTORY
-- =============================================
local function createBtn(y, btnText, defaultColor)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = defaultColor or BTN_DARK
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = btnText
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(60, 30, 90)
    stroke.Thickness = 1.2

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = ACCENT_PURPLE}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.18), {Color = NEON_PURPLE}):Play()
    end)
    btn.MouseLeave:Connect(function()
        local activeCol = btn:GetAttribute("ActiveColor")
        TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = activeCol or defaultColor or BTN_DARK}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.18), {Color = Color3.fromRGB(60, 30, 90)}):Play()
    end)

    return btn, stroke
end

-- =============================================
--   ACTIVATE
-- =============================================
local bActivate, sActivate = createBtn(60, "ACTIVATE", BTN_DARK)

bActivate.MouseButton1Click:Connect(function()
    if desyncActivated then return end
    bActivate.Active = false
    bActivate.Text = "PREPARING..."
    bActivate:SetAttribute("ActiveColor", ACCENT_PURPLE)
    task.spawn(function()
        applyFFlags()
        respawnPlayer()
        task.wait(1.5)
        bActivate.Text = "ALMOST DONE..."
        task.wait(1.5)
        bActivate.Text = "DONE! ✓"
        desyncActivated = true
        TweenService:Create(bActivate, TweenInfo.new(0.3), {BackgroundColor3 = ACCENT_PURPLE}):Play()
    end)
end)

-- =============================================
--   HALF TP TOGGLE
-- =============================================
local halfTpContainer = Instance.new("Frame", main)
halfTpContainer.Size = UDim2.new(0.9, 0, 0, 40)
halfTpContainer.Position = UDim2.new(0.05, 0, 0, 120)
halfTpContainer.BackgroundTransparency = 1

local halfTpLabel = Instance.new("TextLabel", halfTpContainer)
halfTpLabel.Size = UDim2.new(1, -50, 1, 0)
halfTpLabel.BackgroundTransparency = 1
halfTpLabel.Text = "Half TP"
halfTpLabel.TextColor3 = LIGHT_PURPLE
halfTpLabel.TextSize = 13
halfTpLabel.Font = Enum.Font.GothamMedium
halfTpLabel.TextXAlignment = Enum.TextXAlignment.Left

local halfTpToggleBtn = Instance.new("TextButton", halfTpContainer)
halfTpToggleBtn.Size = UDim2.new(0, 44, 0, 22)
halfTpToggleBtn.Position = UDim2.new(1, -44, 0.5, -11)
halfTpToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
halfTpToggleBtn.Text = ""
halfTpToggleBtn.AutoButtonColor = false
Instance.new("UICorner", halfTpToggleBtn).CornerRadius = UDim.new(1, 0)

local halfTpDot = Instance.new("Frame", halfTpToggleBtn)
halfTpDot.Size = UDim2.new(0, 15, 0, 15)
halfTpDot.Position = UDim2.new(0, 3, 0.5, -7.5)
halfTpDot.BackgroundColor3 = Color3.fromRGB(90, 50, 140)
Instance.new("UICorner", halfTpDot).CornerRadius = UDim.new(1, 0)

halfTpToggleBtn.MouseButton1Click:Connect(function()
    if not desyncActivated then return end
    halfTpEnabled = not halfTpEnabled
    local goal   = halfTpEnabled and UDim2.new(1, -18, 0.5, -7.5) or UDim2.new(0, 3, 0.5, -7.5)
    local col    = halfTpEnabled and NEON_PURPLE or Color3.fromRGB(40, 25, 60)
    local dotCol = halfTpEnabled and LIGHT_PURPLE or Color3.fromRGB(90, 50, 140)
    TweenService:Create(halfTpDot,      TweenInfo.new(0.14), {Position = goal, BackgroundColor3 = dotCol}):Play()
    TweenService:Create(halfTpToggleBtn, TweenInfo.new(0.14), {BackgroundColor3 = col}):Play()
end)

-- =============================================
--   AUTO TP LEFT
-- =============================================
local bLeft, sLeft = createBtn(173, "AUTO TP LEFT", BTN_DARK)

bLeft.MouseButton1Click:Connect(function()
    if not desyncActivated then
        bLeft.Text = "ACTIVATE FIRST !"
        task.delay(1.5, function() bLeft.Text = "AUTO TP LEFT" end)
        return
    end
    if IsStealing then return end
    executeSteal(spot1_sequence)
end)

-- =============================================
--   AUTO TP RIGHT
-- =============================================
local bRight, sRight = createBtn(233, "AUTO TP RIGHT", BTN_DARK)

bRight.MouseButton1Click:Connect(function()
    if not desyncActivated then
        bRight.Text = "ACTIVATE FIRST !"
        task.delay(1.5, function() bRight.Text = "AUTO TP RIGHT" end)
        return
    end
    if IsStealing then return end
    executeSteal(spot2_sequence)
end)

-- =============================================
--   PROGRESS BAR
-- =============================================
local barLabel = Instance.new("TextLabel", main)
barLabel.Size = UDim2.new(0.9, 0, 0, 16)
barLabel.Position = UDim2.new(0.05, 0, 0, 295)
barLabel.BackgroundTransparency = 1
barLabel.Text = "Steal Progress"
barLabel.TextColor3 = Color3.fromRGB(160, 120, 220)
barLabel.TextSize = 10
barLabel.Font = Enum.Font.GothamMedium
barLabel.TextXAlignment = Enum.TextXAlignment.Left

local barBg = Instance.new("Frame", main)
barBg.Size = UDim2.new(0.9, 0, 0, 12)
barBg.Position = UDim2.new(0.05, 0, 0, 312)
barBg.BackgroundColor3 = Color3.fromRGB(28, 18, 45)
barBg.BorderSizePixel = 0
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame", barBg)
barFill.BackgroundColor3 = NEON_PURPLE
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BorderSizePixel = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local percentLabel = Instance.new("TextLabel", barBg)
percentLabel.Size = UDim2.new(1, -4, 1, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = LIGHT_PURPLE
percentLabel.TextSize = 9
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextXAlignment = Enum.TextXAlignment.Right

task.spawn(function()
    while true do
        local p = math.clamp(StealProgress, 0, 1)
        barFill.Size = UDim2.new(p, 0, 1, 0)
        percentLabel.Text = math.floor(p * 100 + 0.5) .. "%"
        task.wait(0.02)
    end
end)

-- =============================================
--   FOOTER
-- =============================================
local footer = Instance.new("Frame", main)
footer.Size = UDim2.new(1, 0, 0, 35)
footer.Position = UDim2.new(0, 0, 1, -35)
footer.BackgroundTransparency = 1

local footerLabel = Instance.new("TextLabel", footer)
footerLabel.Size = UDim2.new(1, 0, 1, 0)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "Made By Nyx(aka flux) @.y2z_ on discord"
footerLabel.Font = Enum.Font.GothamBold
footerLabel.TextSize = 11
footerLabel.TextColor3 = Color3.fromRGB(120, 80, 180)

-- =============================================
--   SMOOTH DRAGGING
-- =============================================
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local target = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        main.Position = main.Position:Lerp(target, 0.18)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- =============================================
--   INIT
-- =============================================
initializeScanner()
