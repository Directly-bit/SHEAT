-- Infinite Jump + JumpPower + Speed + ТП через стену + Server Hop
-- Superman Fly v5 — БЕЗ ИЗМЕНЕНИЙ (копия как ты дал)

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TeleportService  = game:GetService("TeleportService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local camera           = workspace.CurrentCamera

-- █████████ СОСТОЯНИЯ ПАНЕЛИ █████████
local infiniteJump    = false
local customJumpPower = 50
local customSpeed     = 16
local isMinimized     = false
local wallTPEnabled   = false
local MAX_VALUE       = 5000
local lastMiniClick   = 0

-- █████████ GUI ПАНЕЛИ █████████
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MovementGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.55, 0, 0.7, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 150, 255)
stroke.Thickness = 2
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.07, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ PANEL ⚡"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local btnMinimize = Instance.new("TextButton")
btnMinimize.Size = UDim2.new(0, 34, 0, 34)
btnMinimize.Position = UDim2.new(1, -40, 0, 5)
btnMinimize.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
btnMinimize.Text = "➖"
btnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMinimize.TextScaled = true
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.BorderSizePixel = 0
btnMinimize.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = btnMinimize

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.95, 0, 0.9, 0)
scroll.Position = UDim2.new(0.025, 0, 0.09, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = scroll

local function MakeBtn(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 42)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b
    return b
end

local btnInfJump = MakeBtn("♾️ Infinite Jump: ВЫКЛ", Color3.fromRGB(80, 0, 0))
local btnWallTP  = MakeBtn("🧱 ТП через стену: ВЫКЛ", Color3.fromRGB(80, 0, 0))
local btnServerHop = MakeBtn("🌐 Server Hop", Color3.fromRGB(0, 60, 120))

local jumpRow = Instance.new("Frame")
jumpRow.Size = UDim2.new(1, -8, 0, 36)
jumpRow.BackgroundTransparency = 1
jumpRow.Parent = scroll

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0.55, 0, 1, 0)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "🦘 JumpPower:"
jumpLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
jumpLabel.TextScaled = true
jumpLabel.Font = Enum.Font.GothamBold
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = jumpRow

local jumpInputBox = Instance.new("TextBox")
jumpInputBox.Size = UDim2.new(0.42, 0, 1, 0)
jumpInputBox.Position = UDim2.new(0.58, 0, 0, 0)
jumpInputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
jumpInputBox.TextColor3 = Color3.fromRGB(150, 200, 255)
jumpInputBox.Text = "50"
jumpInputBox.TextScaled = true
jumpInputBox.Font = Enum.Font.GothamBold
jumpInputBox.BorderSizePixel = 0
jumpInputBox.ClearTextOnFocus = false
jumpInputBox.Parent = jumpRow

local jc = Instance.new("UICorner")
jc.CornerRadius = UDim.new(0, 6)
jc.Parent = jumpInputBox

local speedRow = Instance.new("Frame")
speedRow.Size = UDim2.new(1, -8, 0, 36)
speedRow.BackgroundTransparency = 1
speedRow.Parent = scroll

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.55, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🏃 Speed:"
speedLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedRow

local speedInputBox = Instance.new("TextBox")
speedInputBox.Size = UDim2.new(0.42, 0, 1, 0)
speedInputBox.Position = UDim2.new(0.58, 0, 0, 0)
speedInputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
speedInputBox.TextColor3 = Color3.fromRGB(150, 255, 150)
speedInputBox.Text = "16"
speedInputBox.TextScaled = true
speedInputBox.Font = Enum.Font.GothamBold
speedInputBox.BorderSizePixel = 0
speedInputBox.ClearTextOnFocus = false
speedInputBox.Parent = speedRow

local sc = Instance.new("UICorner")
sc.CornerRadius = UDim.new(0, 6)
sc.Parent = speedInputBox

local btnReset = MakeBtn("🔄 Сбросить всё", Color3.fromRGB(60, 0, 60))

-- █████████ МИНИ-ИКОНКА █████████
local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.new(0, 55, 0, 55)
miniIcon.Position = UDim2.new(0.5, -27, 0.5, -27)
miniIcon.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
miniIcon.Text = "⚡"
miniIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
miniIcon.TextScaled = true
miniIcon.Font = Enum.Font.GothamBold
miniIcon.BorderSizePixel = 0
miniIcon.Visible = false
miniIcon.Active = true
miniIcon.Draggable = true
miniIcon.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1, 0)
miniCorner.Parent = miniIcon

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(255, 200, 50)
miniStroke.Thickness = 3
miniStroke.Parent = miniIcon

-- ═══════════════════════════════════════════════════════════════
-- ═══════════════ SUPERMAN FLY v5 — БЕЗ ИЗМЕНЕНИЙ ═══════════════
-- ═══════════════════════════════════════════════════════════════

local player = LocalPlayer

local CONFIG = {
    SOUND_WAVES       = 5,
    SPEED_PER_WAVE    = 1000,
    ACCELERATION      = 350,
    DECELERATION      = 600,
    TURN_SPEED        = 6,
    WAVE_LIFETIME     = 1.5,
    WAVE_RADIUS       = 50,
    WAVE_COOLDOWN     = 0.3,
    POOL_SIZE         = 10,
    LIFT_HEIGHT       = 8,
    LIFT_SPEED        = 40,
    JOYSTICK_RADIUS   = 70,
    JOYSTICK_DEADZONE = 0.25,
    INPUT_SMOOTHING   = 0.15,
    CAMERA_ROTATE     = true,
}
CONFIG.MAX_SPEED = CONFIG.SOUND_WAVES * CONFIG.SPEED_PER_WAVE

local isFlying      = false
local isLifting     = false
local currentSpeed  = 0
local waveTimer     = 0
local activeWaves   = {}
local wavePool      = {}
local character, humanoid, rootPart
local flyButton, buttonGui
local joyGui, joyBase, joyKnob
local joystickRaw   = Vector2.new(0, 0)
local joystickSmooth = Vector2.new(0, 0)
local joystickActive = false
local currentDirection = nil
local bodyVelocity  = nil
local bodyGyro      = nil
local heartbeatConn

local function initPool()
    for i = 1, CONFIG.POOL_SIZE do
        local wave = Instance.new("Part")
        wave.Shape          = Enum.PartType.Ball
        wave.Size           = Vector3.new(1, 1, 1)
        wave.Anchored       = true
        wave.CanCollide     = false
        wave.CanQuery       = false
        wave.CanTouch       = false
        wave.CastShadow     = false
        wave.Material       = Enum.Material.Neon
        wave.Color          = Color3.fromRGB(0, 200, 255)
        wave.Transparency   = 0.4
        wave.CFrame         = CFrame.new(0, -1000, 0)
        wave.Parent         = workspace
        table.insert(wavePool, wave)
    end
end

local function acquireWave()
    return table.remove(wavePool) or Instance.new("Part")
end

local function releaseWave(part)
    part.Size         = Vector3.new(1, 1, 1)
    part.Transparency = 0.4
    part.Color        = Color3.fromRGB(0, 200, 255)
    part.CFrame       = CFrame.new(0, -1000, 0)
    table.insert(wavePool, part)
end

local function createControllers()
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.P        = 1250
    bodyVelocity.Parent   = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P         = 3000
    bodyGyro.D         = 500
    bodyGyro.CFrame    = rootPart.CFrame
    bodyGyro.Parent    = rootPart
end

local function destroyControllers()
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
end

local function resetState()
    isFlying      = false
    isLifting     = false
    currentSpeed  = 0
    waveTimer     = 0
    joystickRaw   = Vector2.new(0, 0)
    joystickSmooth = Vector2.new(0, 0)
    joystickActive = false
    currentDirection = nil

    destroyControllers()

    for i = #activeWaves, 1, -1 do
        releaseWave(activeWaves[i].part)
        table.remove(activeWaves, i)
    end

    if flyButton then
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        flyButton.Text = "F"
    end
end

local function onCharacterAdded(char)
    character = char
    humanoid  = char:WaitForChild("Humanoid")
    rootPart  = char:WaitForChild("HumanoidRootPart")
    resetState()
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

local function startLift()
    isFlying  = true
    isLifting = true
    if humanoid then
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
    rootPart.CanCollide = false
    createControllers()
end

local function stopFlight()
    isFlying  = false
    isLifting = false
    destroyControllers()
    if humanoid then
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    if rootPart then rootPart.CanCollide = true end
end

local function createFlyButton()
    buttonGui = Instance.new("ScreenGui")
    buttonGui.Name           = "SupermanFlyGui"
    buttonGui.ResetOnSpawn   = false
    buttonGui.IgnoreGuiInset = true
    buttonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    buttonGui.DisplayOrder   = 100
    buttonGui.Parent         = player:WaitForChild("PlayerGui")

    flyButton = Instance.new("TextButton")
    flyButton.Name             = "FlyButton"
    flyButton.Size             = UDim2.new(0, 110, 0, 110)
    flyButton.Position         = UDim2.new(1, -140, 1, -170)
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    flyButton.BackgroundTransparency = 0.15
    flyButton.Text             = "F"
    flyButton.TextColor3       = Color3.fromRGB(255, 255, 255)
    flyButton.TextScaled       = true
    flyButton.Font             = Enum.Font.GothamBold
    flyButton.AutoButtonColor  = true
    flyButton.Parent           = buttonGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent       = flyButton

    local stroke = Instance.new("UIStroke")
    stroke.Color        = Color3.fromRGB(0, 220, 255)
    stroke.Thickness    = 4
    stroke.Transparency = 0.2
    stroke.Parent       = flyButton

    flyButton.MouseButton1Click:Connect(function()
        if not isFlying then
            startLift()
            flyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            flyButton.Text = "✓"
        else
            stopFlight()
            flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            flyButton.Text = "F"
        end
    end)
end

local function createJoystick()
    joyGui = Instance.new("ScreenGui")
    joyGui.Name           = "SupermanJoyGui"
    joyGui.ResetOnSpawn   = false
    joyGui.IgnoreGuiInset = true
    joyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    joyGui.DisplayOrder   = 99
    joyGui.Parent         = player:WaitForChild("PlayerGui")

    joyBase = Instance.new("Frame")
    joyBase.Name             = "JoyBase"
    joyBase.Size             = UDim2.new(0, CONFIG.JOYSTICK_RADIUS * 2, 0, CONFIG.JOYSTICK_RADIUS * 2)
    joyBase.Position         = UDim2.new(0, 40, 1, -CONFIG.JOYSTICK_RADIUS * 2 - 40)
    joyBase.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    joyBase.BackgroundTransparency = 0.5
    joyBase.BorderSizePixel  = 0
    joyBase.Parent           = joyGui

    local baseCorner = Instance.new("UICorner")
    baseCorner.CornerRadius = UDim.new(1, 0)
    baseCorner.Parent       = joyBase

    local baseStroke = Instance.new("UIStroke")
    baseStroke.Color        = Color3.fromRGB(0, 200, 255)
    baseStroke.Thickness    = 3
    baseStroke.Transparency = 0.4
    baseStroke.Parent       = joyBase

    for _, rot in ipairs({0, 90}) do
        local line = Instance.new("Frame")
        line.Size             = UDim2.new(0, CONFIG.JOYSTICK_RADIUS * 2 - 20, 0, 2)
        line.Position         = UDim2.new(0.5, -(CONFIG.JOYSTICK_RADIUS - 10), 0.5, -1)
        line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        line.BackgroundTransparency = 0.7
        line.BorderSizePixel  = 0
        line.Rotation         = rot
        line.Parent           = joyBase
    end

    joyKnob = Instance.new("Frame")
    joyKnob.Name             = "JoyKnob"
    joyKnob.Size             = UDim2.new(0, CONFIG.JOYSTICK_RADIUS * 0.9, 0, CONFIG.JOYSTICK_RADIUS * 0.9)
    joyKnob.Position         = UDim2.new(0.5, -CONFIG.JOYSTICK_RADIUS * 0.45, 0.5, -CONFIG.JOYSTICK_RADIUS * 0.45)
    joyKnob.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    joyKnob.BackgroundTransparency = 0.15
    joyKnob.BorderSizePixel  = 0
    joyKnob.Parent           = joyBase

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent       = joyKnob

    RunService.RenderStepped:Connect(function()
        if not joyKnob or not joyBase then return end

        joystickSmooth = joystickSmooth:Lerp(joystickRaw, CONFIG.INPUT_SMOOTHING)

        local targetX = joystickSmooth.X * CONFIG.JOYSTICK_RADIUS
        local targetY = joystickSmooth.Y * CONFIG.JOYSTICK_RADIUS
        joyKnob.Position = UDim2.new(
            0.5, targetX - CONFIG.JOYSTICK_RADIUS * 0.45,
            0.5, targetY - CONFIG.JOYSTICK_RADIUS * 0.45
        )
    end)

    local function updateJoystick(inputPos, baseAbsPos)
        local center = Vector2.new(
            baseAbsPos.X + CONFIG.JOYSTICK_RADIUS,
            baseAbsPos.Y + CONFIG.JOYSTICK_RADIUS
        )
        local delta = inputPos - center
        local len = delta.Magnitude
        local maxLen = CONFIG.JOYSTICK_RADIUS

        if len > maxLen then
            delta = delta.Unit * maxLen
        end

        local nx = delta.X / maxLen
        local ny = delta.Y / maxLen

        local magnitude = math.sqrt(nx*nx + ny*ny)
        if magnitude < CONFIG.JOYSTICK_DEADZONE then
            nx, ny = 0, 0
        else
            local t = (magnitude - CONFIG.JOYSTICK_DEADZONE) / (1 - CONFIG.JOYSTICK_DEADZONE)
            t = t ^ 1.5
            local unit = Vector2.new(nx, ny).Unit
            nx = unit.X * t
            ny = unit.Y * t
        end

        joystickRaw = Vector2.new(nx, ny)
    end

    local function resetJoystick()
        joystickRaw = Vector2.new(0, 0)
        joystickActive = false
    end

    joyBase.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            joystickActive = true
            updateJoystick(Vector2.new(input.Position.X, input.Position.Y), joyBase.AbsolutePosition)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not joystickActive then return end
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
            updateJoystick(Vector2.new(input.Position.X, input.Position.Y), joyBase.AbsolutePosition)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            resetJoystick()
        end
    end)
end

local function spawnWave(position)
    if not rootPart then return end

    if #activeWaves >= CONFIG.SOUND_WAVES then
        local oldest = table.remove(activeWaves, 1)
        releaseWave(oldest.part)
    end

    local part = acquireWave()
    part.Size         = Vector3.new(1, 1, 1)
    part.Transparency = 0.35
    part.Color        = Color3.fromRGB(0, 200, 255)
    part.CFrame       = CFrame.new(position)
    part.Parent       = workspace

    table.insert(activeWaves, { part = part, age = 0 })
end

local function updateWaves(dt)
    for i = #activeWaves, 1, -1 do
        local wave = activeWaves[i]
        wave.age = wave.age + dt

        if wave.age >= CONFIG.WAVE_LIFETIME then
            releaseWave(wave.part)
            table.remove(activeWaves, i)
        else
            local progress = wave.age / CONFIG.WAVE_LIFETIME
            local size     = 1 + CONFIG.WAVE_RADIUS * progress
            wave.part.Size = Vector3.new(size, size, size)
            wave.part.Transparency = 0.35 + progress * 0.65
            wave.part.Color = Color3.fromRGB(
                math.floor(255 * progress),
                math.floor(220 * (1 - progress * 0.7)),
                255
            )
        end
    end
end

local function getWaveSpeed()
    return math.min(#activeWaves * CONFIG.SPEED_PER_WAVE, CONFIG.MAX_SPEED)
end

local function getDesiredDirection()
    if not joystickActive then return nil end
    if joystickSmooth.Magnitude < CONFIG.JOYSTICK_DEADZONE then return nil end

    local camCF   = camera.CFrame
    local forward = camCF.LookVector
    local right   = camCF.RightVector

    local vertical   = -joystickSmooth.Y
    local horizontal =  joystickSmooth.X

    local dir = (forward * vertical + right * horizontal)

    if vertical > 0.5 then
        dir = dir + Vector3.new(0, vertical * 0.7, 0)
    end

    if dir.Magnitude < 0.001 then return nil end
    return dir.Unit
end

heartbeatConn = RunService.Heartbeat:Connect(function(dt)
    if not rootPart or not humanoid then return end

    if isLifting and isFlying then
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, CONFIG.LIFT_SPEED, 0)
        end

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = { character }
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        local result = workspace:Raycast(
            rootPart.Position,
            Vector3.new(0, -CONFIG.LIFT_HEIGHT * 3, 0),
            rayParams
        )
        local groundY = result and result.Position.Y or (rootPart.Position.Y - 100)

        if (rootPart.Position.Y - groundY) >= CONFIG.LIFT_HEIGHT then
            isLifting = false
            currentSpeed = 0
            currentDirection = nil
            if bodyVelocity then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end

        updateWaves(dt)
        return
    end

    if isFlying then
        waveTimer = waveTimer + dt
        if waveTimer >= CONFIG.WAVE_COOLDOWN and #activeWaves < CONFIG.SOUND_WAVES then
            waveTimer = 0
            spawnWave(rootPart.Position)
        end

        local targetSpeed = getWaveSpeed()
        local desiredDir = getDesiredDirection()

        if desiredDir then
            if not currentDirection then
                currentDirection = desiredDir
            else
                local alpha = math.min(CONFIG.TURN_SPEED * dt, 1)
                currentDirection = currentDirection:Lerp(desiredDir, alpha).Unit
            end

            currentSpeed = math.min(
                currentSpeed + CONFIG.ACCELERATION * dt,
                targetSpeed
            )
        else
            currentSpeed = math.max(currentSpeed - CONFIG.DECELERATION * dt, 0)
            if currentSpeed <= 0 then
                currentDirection = nil
            end
        end

        if bodyVelocity then
            if currentDirection and currentSpeed > 0 then
                bodyVelocity.Velocity = currentDirection * currentSpeed

                if bodyGyro then
                    local lookCF = CFrame.lookAt(rootPart.Position, rootPart.Position + currentDirection)
                    bodyGyro.CFrame = bodyGyro.CFrame:Lerp(lookCF, math.min(8 * dt, 1))
                end
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end
    else
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end

    updateWaves(dt)
end)

initPool()
createFlyButton()
createJoystick()

-- ═══════════════════════════════════════════════════════════════
-- ═══════════════ КОНЕЦ SUPERMAN FLY v5 ═══════════════════════
-- ═══════════════════════════════════════════════════════════════

-- █████████ ФУНКЦИИ ПАНЕЛИ █████████
local function ApplyJumpPower()
    local char = LocalPlayer.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h then return end
    if h.UseJumpPower then
        h.JumpPower = customJumpPower
    else
        h.JumpHeight = customJumpPower / 5
    end
end

local function ApplySpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = customSpeed
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    ApplyJumpPower()
    ApplySpeed()
end)

UserInputService.JumpRequest:Connect(function()
    if not infiniteJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

btnInfJump.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    if infiniteJump then
        btnInfJump.Text = "♾️ Infinite Jump: ВКЛ"
        btnInfJump.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    else
        btnInfJump.Text = "♾️ Infinite Jump: ВЫКЛ"
        btnInfJump.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end
end)

-- ███████ ТП ЧЕРЕЗ СТЕНУ ███████
local function TeleportThroughWall()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local mouse = LocalPlayer:GetMouse()
    local unitRay = camera:ViewportPointToRay(mouse.X, mouse.Y)
    local origin = unitRay.Origin
    local direction = unitRay.Direction

    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {char, camera}
    rp.IgnoreWater = true

    local hitResult = workspace:Raycast(origin, direction * 1000, rp)
    if not hitResult then
        hrp.CFrame = CFrame.new(hrp.Position + direction * 7)
        return
    end

    local behindOrigin = hitResult.Position + direction * 1
    local behindRay = workspace:Raycast(behindOrigin, direction * 15, rp)

    local targetPos
    if behindRay then
        targetPos = behindRay.Position - direction * 1.5
    else
        targetPos = hitResult.Position + direction * 3
    end

    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not wallTPEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        local guiObjs = LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
        for _, obj in ipairs(guiObjs) do
            if obj:IsDescendantOf(screenGui) or obj:IsDescendantOf(buttonGui) or obj:IsDescendantOf(joyGui) then return end
        end
        TeleportThroughWall()
    end
end)

btnWallTP.MouseButton1Click:Connect(function()
    wallTPEnabled = not wallTPEnabled
    if wallTPEnabled then
        btnWallTP.Text = "🧱 ТП через стену: ВКЛ"
        btnWallTP.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    else
        btnWallTP.Text = "🧱 ТП через стену: ВЫКЛ"
        btnWallTP.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end
end)

-- ███████ SERVER HOP ███████
local function ServerHop()
    local placeId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, resp = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if not ok or not resp or not resp.data then return end
    local list = {}
    for _, s in ipairs(resp.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            table.insert(list, s)
        end
    end
    if #list == 0 then return end
    local r = list[math.random(1, #list)]
    TeleportService:TeleportToPlaceInstance(placeId, r.id, LocalPlayer)
end

btnServerHop.MouseButton1Click:Connect(ServerHop)

-- ███████ СВОРАЧИВАНИЕ (двойной тап для открытия) ███████
btnMinimize.MouseButton1Click:Connect(function()
    isMinimized = true
    local cx = frame.AbsolutePosition.X + frame.AbsoluteSize.X / 2
    local cy = frame.AbsolutePosition.Y + frame.AbsoluteSize.Y / 2
    frame.Visible = false
    miniIcon.Visible = true
    miniIcon.Position = UDim2.new(0, cx - 27, 0, cy - 27)
end)

miniIcon.MouseButton1Click:Connect(function()
    local now = tick()
    if now - lastMiniClick < 0.5 then
        isMinimized = false
        local cx = miniIcon.AbsolutePosition.X + miniIcon.AbsoluteSize.X / 2
        local cy = miniIcon.AbsolutePosition.Y + miniIcon.AbsoluteSize.Y / 2
        miniIcon.Visible = false
        frame.Visible = true
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        lastMiniClick = 0
    else
        lastMiniClick = now
        miniIcon.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        task.wait(0.15)
        if miniIcon.Visible then
            miniIcon.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
        end
    end
end)

-- ███████ РУЧНОЙ ВВОД ███████
jumpInputBox.FocusLost:Connect(function()
    local num = tonumber(jumpInputBox.Text)
    if num then
        num = math.clamp(math.floor(num), 0, MAX_VALUE)
        customJumpPower = num
        jumpInputBox.Text = tostring(num)
        ApplyJumpPower()
    else
        jumpInputBox.Text = tostring(customJumpPower)
    end
end)

speedInputBox.FocusLost:Connect(function()
    local num = tonumber(speedInputBox.Text)
    if num then
        num = math.clamp(math.floor(num), 0, MAX_VALUE)
        customSpeed = num
        speedInputBox.Text = tostring(num)
        ApplySpeed()
    else
        speedInputBox.Text = tostring(customSpeed)
    end
end)

-- ███████ СБРОС ███████
btnReset.MouseButton1Click:Connect(function()
    infiniteJump = false
    btnInfJump.Text = "♾️ Infinite Jump: ВЫКЛ"
    btnInfJump.BackgroundColor3 = Color3.fromRGB(80, 0, 0)

    wallTPEnabled = false
    btnWallTP.Text = "🧱 ТП через стену: ВЫКЛ"
    btnWallTP.BackgroundColor3 = Color3.fromRGB(80, 0, 0)

    customJumpPower = 50
    jumpInputBox.Text = "50"

    customSpeed = 16
    speedInputBox.Text = "16"

    ApplyJumpPower()
    ApplySpeed()
end)

print("⚡ Panel загружен |СКРИПТ ОТ ТГК КАНАЛА DELTA_ROBLOX_2")
