-- AEZY HUB RAZ (Paid) - LK7 EDIT
-- Gold Theme Edition | Optimized Graphics | FPS & Ping Display | Minimize System
-- Integrated with Anti-Ragdoll, Effects Logic & Auto X-Ray (No X-Ray GUI)

-- WHITELIST
local whitelist = {
    "lkzz011",
}

local function isWhitelisted(name)
    for _, v in ipairs(whitelist) do
        if v:lower() == name:lower() then
            return true
        end
    end
    return false
end

-- SERVICES
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StatsService = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

if not isWhitelisted(LocalPlayer.Name) then
    LocalPlayer:Kick("LK7 HUB: Nick não autorizado na Whitelist.")
    return
end

if _G.RyxxInstantStealLoaded then return end
_G.RyxxInstantStealLoaded = true

-- ================================
-- ANTI-RAGDOLL & EFFECTS LOGIC
-- ================================
local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()
local ENABLE_ANTI_RAGDOLL = true
local ENABLE_ANTI_ITEM = true
local Frozen = false
local DisabledRemotes = {}
local BlockedStates = {
	[Enum.HumanoidStateType.Ragdoll] = true,
	[Enum.HumanoidStateType.FallingDown] = true,
	[Enum.HumanoidStateType.Physics] = true,
	[Enum.HumanoidStateType.Dead] = true
}
local RemoteKeywords = { "useitem", "combatservice", "ragdoll" }

local function ForceNormal(character)
	local hum = character:FindFirstChildOfClass("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	hum.Health = hum.MaxHealth
	hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	if not Frozen then
		Frozen = true
		hrp.Anchored = true
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero
		hrp.CFrame += Vector3.new(0, 1.5, 0)
	end
end

local function Release(character)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp and Frozen then
		hrp.Anchored = false
		Frozen = false
	end
end

local function RestoreMotors(character)
	for _, v in ipairs(character:GetDescendants()) do
		if v:IsA("Motor6D") then
			v.Enabled = true
		elseif v:IsA("Constraint") then
			v.Enabled = false
		end
	end
end

local function InitAntiRagdoll(character)
	local hum = character:WaitForChild("Humanoid", 10)
	if not hum then return end
	for state in pairs(BlockedStates) do
		hum:SetStateEnabled(state, false)
	end
	hum.StateChanged:Connect(function(_, new)
		if ENABLE_ANTI_RAGDOLL and BlockedStates[new] then
			ForceNormal(character)
			RestoreMotors(character)
		end
	end)
	RunService.Stepped:Connect(function()
		if not ENABLE_ANTI_RAGDOLL then
			Release(character)
			return
		end
		if BlockedStates[hum:GetState()] then
			ForceNormal(character)
		else
			Release(character)
		end
		hum.Health = hum.MaxHealth
	end)
end

local function KillRemote(remote)
	if not getconnections or not remote:IsA("RemoteEvent") then return end
	if DisabledRemotes[remote] then return end
	local name = remote.Name:lower()
	for _, key in ipairs(RemoteKeywords) do
		if name:find(key) then
			DisabledRemotes[remote] = {}
			for _, c in ipairs(getconnections(remote.OnClientEvent)) do
				if c.Disable then
					c:Disable()
					table.insert(DisabledRemotes[remote], c)
				end
			end
			break
		end
	end
end

local function InitAntiItem()
	Controls:Enable()
	for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
		KillRemote(obj)
	end
	ReplicatedStorage.DescendantAdded:Connect(KillRemote)
end

-- ================================
-- FPS & PING DISPLAY (GOLD)
-- ================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StatsDisplay"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0, 300, 0, 70)
StatsLabel.Position = UDim2.new(0.5, -150, 0.1, -35)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Font = Enum.Font.FredokaOne
StatsLabel.TextSize = 30
StatsLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
StatsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
StatsLabel.TextStrokeTransparency = 0
StatsLabel.Text = "0 | 0"
StatsLabel.Parent = ScreenGui

RunService.Heartbeat:Connect(function()
    local ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    StatsLabel.Text = ping .. " | " .. fps
end)

-- ================================
-- AUTO X-RAY LOGIC
-- ================================
local function autoXRay()
    RunService.Heartbeat:Connect(function()
        local Plots = Workspace:FindFirstChild("Plots")
        if Plots then
            for _, Plot in ipairs(Plots:GetChildren()) do
                if Plot:IsA("Model") and Plot:FindFirstChild("Decorations") then
                    for _, Part in ipairs(Plot.Decorations:GetDescendants()) do
                        if Part:IsA("BasePart") then Part.Transparency = 0.8 end
                    end
                end
            end
        end
    end)
end

-- ================================
-- GOLD ESP LOGIC
-- ================================
local Plots = Workspace:WaitForChild("Plots")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ownBasePos
local GOLD_COLOR = Color3.fromRGB(255, 215, 0)

local function getOwnBasePosition()
    for _, plot in ipairs(Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        local base = plot:FindFirstChild("DeliveryHitbox")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled and base then
            return base.Position
        end
    end
    return nil
end

local ESPFolder = PlayerGui:FindFirstChild("PlayerESP") or Instance.new("Folder")
ESPFolder.Name = "PlayerESP"
ESPFolder.Parent = PlayerGui

local function createOrUpdatePlayerESP(player)
    if player == LocalPlayer then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart
    local highlight = ESPFolder:FindFirstChild(player.Name.."_Highlight") or Instance.new("Highlight", ESPFolder)
    highlight.Name = player.Name.."_Highlight"
    highlight.FillColor, highlight.FillTransparency = GOLD_COLOR, 0.6
    highlight.OutlineColor, highlight.Adornee = Color3.fromRGB(255, 255, 255), player.Character

    local billboard = ESPFolder:FindFirstChild(player.Name) or Instance.new("BillboardGui", ESPFolder)
    billboard.Name = player.Name
    billboard.Adornee, billboard.AlwaysOnTop = hrp, true
    billboard.Size, billboard.StudsOffset = UDim2.new(0, 200, 0, 50), Vector3.new(0, 3, 0)

    local label = billboard:FindFirstChild("Label") or Instance.new("TextLabel", billboard)
    label.Name = "Label"
    label.Size, label.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
    label.TextColor3, label.Font, label.TextScaled = GOLD_COLOR, Enum.Font.GothamBold, true
    label.Text = player.DisplayName or player.Name
end

local function createOrUpdatePlotESP(plot)
    local purchases = plot:FindFirstChild("Purchases")
    if not purchases or not purchases:FindFirstChild("PlotBlock") then return end
    local main = purchases.PlotBlock:FindFirstChild("Main")
    if not main then return end
    local base = plot:FindFirstChild("DeliveryHitbox")
    if base and ownBasePos and (base.Position - ownBasePos).Magnitude < 1 then return end

    local billboard = main:FindFirstChild("ESP_Billboard") or Instance.new("BillboardGui", main)
    billboard.Name = "ESP_Billboard"
    billboard.Adornee, billboard.Size, billboard.AlwaysOnTop = main, UDim2.new(0, 200, 0, 50), true
    billboard.StudsOffset = Vector3.new(0, 5, 0)

    local label = billboard:FindFirstChild("Label") or Instance.new("TextLabel", billboard)
    label.Name = "Label"
    label.Size, label.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
    label.TextColor3, label.Font, label.TextScaled = GOLD_COLOR, Enum.Font.GothamBold, true

    local remainingTimeGui = main:FindFirstChild("BillboardGui") and main.BillboardGui:FindFirstChild("RemainingTime")
    if remainingTimeGui then
        local text = remainingTimeGui:IsA("TextLabel") and remainingTimeGui.Text or tostring(remainingTimeGui.Value)
        if text == "0s" or text == "0" then label.Text = "[ UNLOCKED ]" label.TextColor3 = Color3.fromRGB(0, 255, 0)
        else label.Text = "Time: " .. text label.TextColor3 = GOLD_COLOR end
    end
end

task.spawn(function()
    while true do
        ownBasePos = getOwnBasePosition()
        for _, plot in pairs(Plots:GetChildren()) do pcall(function() createOrUpdatePlotESP(plot) end) end
        for _, player in pairs(Players:GetPlayers()) do pcall(function() createOrUpdatePlayerESP(player) end) end
        task.wait(0.5)
    end
end)

-- ================================
-- DESYNC & GUI
-- ================================
local FFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
    LargeReplicatorWrite5 = true, LargeReplicatorEnabled9 = true,
    AngularVelociryLimit = 360, TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646,
    S2PhysicsSenderRate = 15000, DisableDPIScale = true,
    MaxDataPacketPerSend = 2147483647, PhysicsSenderMaxBandwidthBps = 20000,
    TimestepArbiterHumanoidLinearVelThreshold = 21, MaxMissedWorldStepsRemembered = -2147483648,
    PlayerHumanoidPropertyUpdateRestrict = true, SimDefaultHumanoidTimestepMultiplier = 0,
    StreamJobNOUVolumeLengthCap = 2147483647, DebugSendDistInSteps = -2147483648,
    GameNetDontSendRedundantNumTimes = 1, CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
    LargeReplicatorSerializeRead3 = true, ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
    CheckPVCachedVelThresholdPercent = 10, CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
    GameNetDontSendRedundantDeltaPositionMillionth = 1, InterpolationFrameVelocityThresholdMillionth = 5,
    StreamJobNOUVolumeCap = 2147483647, InterpolationFrameRotVelocityThresholdMillionth = 5,
    CheckPVCachedRotVelThresholdPercent = 10, WorldStepMax = 30,
    InterpolationFramePositionThresholdMillionth = 5, TimestepArbiterHumanoidTurningVelThreshold = 1,
    SimOwnedNOUCountThresholdMillionth = 2147483647, GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
    NextGenReplicatorEnabledWrite4 = true, TimestepArbiterOmegaThou = 1073741823,
    MaxAcceptableUpdateDelay = 1, LargeReplicatorSerializeWrite4 = true
}

local function ApplyFFlags()
    for name, value in pairs(FFlags) do pcall(function() setfflag(tostring(name), tostring(value)) end) end
end

local DesyncESPFolder, ServerESP, serverPosition, positionConn

local function RespawnPlayer()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
    char:ClearAllChildren()
    local temp = Instance.new("Model", Workspace)
    LocalPlayer.Character = temp
    task.wait()
    LocalPlayer.Character = char
    temp:Destroy()
end

local function SetServerESP()
    if positionConn then positionConn:Disconnect() end
    if DesyncESPFolder then DesyncESPFolder:Destroy() end
    DesyncESPFolder = Instance.new("Folder", Workspace)
    DesyncESPFolder.Name = "DesyncESP"
    ServerESP = Instance.new("Part", DesyncESPFolder)
    ServerESP.Size, ServerESP.Anchored, ServerESP.CanCollide = Vector3.new(2, 5, 2), true, false
    ServerESP.Material, ServerESP.Color, ServerESP.Transparency = Enum.Material.Neon, GOLD_COLOR, 0.25
    Instance.new("Highlight", ServerESP).FillColor = GOLD_COLOR
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        positionConn = hrp:GetPropertyChangedSignal("Position"):Connect(function()
            task.wait(0.15) if hrp then ServerESP.CFrame = CFrame.new(hrp.Position) end
        end)
    end
end

-- TARGETS
local targetPositions = {
    Vector3.new(-481.88, -3.79, 138.02), Vector3.new(-481.75, -3.79, 89.18),
    Vector3.new(-481.82, -3.79, 30.95), Vector3.new(-481.75, -3.79, -17.79),
    Vector3.new(-481.80, -3.79, -76.06), Vector3.new(-481.72, -3.79, -124.70),
    Vector3.new(-337.45, -3.85, -124.72), Vector3.new(-337.37, -3.85, -76.07),
    Vector3.new(-337.46, -3.79, -17.72), Vector3.new(-337.41, -3.79, 30.92),
    Vector3.new(-337.32, -3.79, 89.02), Vector3.new(-337.27, -
