local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Hide and Seek Extreme", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "🏠 Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- ESP Toggle
local highlightPlayersEnabled = false

local function updatePlayerESP(player)
    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
        local highlight = player.Character:FindFirstChild("Highlight")
        local esp = player.Character.Head:FindFirstChild("ESP")

        if highlightPlayersEnabled then
            -- Aktiviere Highlight und ESP
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "Highlight"
                highlight.Parent = player.Character
                highlight.FillColor = player.TeamColor.Color
                highlight.OutlineColor = Color3.new(1, 1, 1)
            end

            if not esp then
                esp = Instance.new("BillboardGui")
                esp.Name = "ESP"
                esp.Parent = player.Character.Head
                esp.AlwaysOnTop = true
                esp.Size = UDim2.new(0, 200, 0, 50)
                esp.StudsOffset = Vector3.new(0, 3, 0)
                esp.Adornee = player.Character.Head

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "NameLabel"
                nameLabel.Parent = esp
                nameLabel.BackgroundTransparency = 1
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextColor3 = player.TeamColor.Color
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                nameLabel.TextSize = 14
                nameLabel.Text = player.Name

                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Name = "DistanceLabel"
                distanceLabel.Parent = esp
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distanceLabel.Font = Enum.Font.SourceSansBold
                distanceLabel.TextColor3 = player.TeamColor.Color
                distanceLabel.TextStrokeTransparency = 0
                distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                distanceLabel.TextSize = 14
                distanceLabel.Text = "Distanz: Berechne..."

                -- Aktualisiere Distanz
                game:GetService("RunService").RenderStepped:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        distanceLabel.Text = string.format("Distanz: %.1f", distance)
                    end
                end)
            end
        else
            -- Deaktiviere Highlight und ESP
            if highlight then
                highlight:Destroy()
            end

            if esp then
                esp:Destroy()
            end
        end
    end
end

local function updateAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        updatePlayerESP(player)
    end
end

-- Kontinuierliche Aktualisierung
local updateLoop

local function startUpdateLoop()
    if updateLoop then
        updateLoop:Disconnect()
    end
    
    updateLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if highlightPlayersEnabled then
            updateAllPlayers()
        end
    end)
end

local function togglePlayerHighlight(newValue)
    highlightPlayersEnabled = newValue
    if highlightPlayersEnabled then
        startUpdateLoop()
    else
        if updateLoop then
            updateLoop:Disconnect()
        end
        updateAllPlayers() -- Um alle Highlights zu entfernen
    end
end

-- Click Teleport Toggle
local isTeleportEnabled = false

local function teleportToMouse()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()

    local teleportConnection
    teleportConnection = mouse.Button1Down:Connect(function()
        if isTeleportEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end)

    -- Verbindung trennen, wenn der Toggle deaktiviert wird
    while isTeleportEnabled do
        wait(0.1)
    end
    teleportConnection:Disconnect()
end

local function toggleTeleport(newValue)
    isTeleportEnabled = newValue
    if isTeleportEnabled then
        coroutine.wrap(teleportToMouse)()
    end
end

-- Orion Toggles erstellen
Tab:AddToggle({
	Name = "ESP",
	Default = false,
	Callback = togglePlayerHighlight
})

Tab:AddToggle({
	Name = "Click Teleport",
	Default = false,
	Callback = toggleTeleport
})

-- Initialisiere für bereits vorhandene Spieler
updateAllPlayers()


local Tab = Window:MakeTab({
	Name = "⚙ Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local speed = 16 -- Standardgeschwindigkeit
local isEnabled = false

-- Funktion zum Anwenden der Geschwindigkeit
local function applySpeed()
    if isEnabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Standardgeschwindigkeit
    end
end

-- Slider für Geschwindigkeit
local speedSlider = Tab:AddSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        speed = Value
        if isEnabled then
            applySpeed()
        end
    end
})

-- Toggle zum Ein- und Ausschalten
local toggleButton = Tab:AddToggle({
    Name = "Speed Changer",
    Default = false,
    Callback = function(Value)
        isEnabled = Value
        applySpeed()
    end
})

-- Button für FPS-Boost
local fpsBoostButton = Tab:AddButton({
    Name = "FPS Boost",
    Callback = function()
        print("FPS Boost aktiviert")
        -- Code zum Verschlechtern der Texturen für FPS-Boost
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            end
        end
    end
})
