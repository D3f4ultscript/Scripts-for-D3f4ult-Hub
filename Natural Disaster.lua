local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Prisone Life",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Prisone Life script",
   LoadingSubtitle = "by tt_g1212",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})


local Tab = Window:CreateTab("🔫 Tools", 4483362458)
local Section = Tab:CreateSection("Get Tools")


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createBalloonTool()
    local tool = Instance.new("Tool")
    tool.Name = "Ballon (Beta)"
    tool.CanBeDropped = false
    tool.RequiresHandle = false

    local originalGravity = workspace.Gravity
    local moonGravity = originalGravity * 0.165  -- Ungefähr 1/6 der normalen Schwerkraft, wie auf dem Mond

    tool.Equipped:Connect(function()
        workspace.Gravity = moonGravity
        print("Mondgravitation aktiviert!")
    end)

    tool.Unequipped:Connect(function()
        workspace.Gravity = originalGravity
        print("Normale Gravitation wiederhergestellt.")
    end)

    return tool
end

Tab:CreateButton({
   Name = "Green Ballon [not finished]",
   Callback = function()
      local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
      if backpack then
         for _, item in pairs(backpack:GetChildren()) do
            if item.Name == "Grüner Ballon" then
                item:Destroy()
            end
         end
         
         local balloonTool = createBalloonTool()
         balloonTool.Parent = backpack
         print("Grüner Ballon ins Inventar gelegt!")
      else
         print("Backpack nicht gefunden")
      end
   end,
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createDestroyTool()
    local tool = Instance.new("Tool")
    tool.Name = "B-Tool"
    tool.RequiresHandle = false

    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target:IsA("BasePart") and not target:IsDescendantOf(LocalPlayer.Character) then
            target:Destroy()
        end
    end)

    return tool
end

local DestroyToolButton = Tab:CreateButton({
    Name = "Destroy Tool",
    Callback = function()
        local tool = createDestroyTool()
        tool.Parent = LocalPlayer.Backpack
    end,
})


local Button = Tab:CreateButton({
   Name = "TP-Tool",
   Callback = function()
      local player = game.Players.LocalPlayer
      local mouse = player:GetMouse()
      
      local tool = Instance.new("Tool")
      tool.Name = "TP-Tool"
      tool.RequiresHandle = false
      tool.CanBeDropped = false
      
      tool.Activated:Connect(function()
         local character = player.Character
         if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 3, 0)
         end
      end)
      
      tool.Parent = player.Backpack
      print("Unsichtbares TP-Tool wurde dem Inventar hinzugefügt.")
   end,
})


local Tab = Window:CreateTab("🗺 Map", 4483362458)
local Section = Tab:CreateSection("Destroy")


local Tab = Window:CreateTab("🌀 Teleport", 4483362458)
local Section = Tab:CreateSection("Spawn")


Tab:CreateButton({
   Name = "Teleport to Spawn",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      local targetPlatform = workspace.Tower.Platforms:GetChildren()[8]
      
      if targetPlatform then
         humanoidRootPart.CFrame = targetPlatform.CFrame + Vector3.new(0, 3, 0)
      else
         print("Zielplattform nicht gefunden")
      end
   end,
})


local Section = Tab:CreateSection("Save Position")


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local savedPosition = nil

-- Button zum Speichern der Position
Tab:CreateButton({
   Name = "Save Position",
   Callback = function()
      local character = LocalPlayer.Character
      if character and character:FindFirstChild("HumanoidRootPart") then
         savedPosition = character.HumanoidRootPart.Position
         print("Position gespeichert")
      else
         print("Konnte Position nicht speichern")
      end
   end,
})

-- Button zum Teleportieren zur gespeicherten Position
Tab:CreateButton({
   Name = "Teleport to saved Position",
   Callback = function()
      if savedPosition then
         local character = LocalPlayer.Character
         if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
               humanoid:ChangeState(Enum.HumanoidStateType.Physics) -- Physik kurz deaktivieren
               character.HumanoidRootPart.CFrame = CFrame.new(savedPosition) + Vector3.new(0, 3, 0)
               task.wait(0.1) -- Kurze Verzögerung
               humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) -- Normalen Zustand wiederherstellen
               print("Zur gespeicherten Position teleportiert")
            end
         else
            print("Konnte nicht teleportieren")
         end
      else
         print("Keine Position gespeichert")
      end
   end,
})


local Section = Tab:CreateSection("Player Tp / Spectate")


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local playerNameInput = ""
local isSpectating = false

-- Textfeld für Spielernamen
local Input = Tab:CreateInput({
   Name = "Type player name",
   PlaceholderText = "Name des Spielers",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      playerNameInput = Text
   end,
})

-- Button zum Teleportieren
Tab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      if playerNameInput ~= "" then
         local targetPlayer = Players:FindFirstChild(playerNameInput)
         if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
               local humanoid = character:FindFirstChildOfClass("Humanoid")
               if humanoid and humanoid.SeatPart then
                  humanoid.Sit = false
                  task.wait(0.1)
               end
               character.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
               print("Zum Spieler " .. targetPlayer.Name .. " teleportiert")
            else
               print("Lokaler Charakter nicht gefunden")
            end
         else
            print("Zielspieler nicht gefunden oder hat keinen gültigen Charakter")
         end
      else
         print("Bitte geben Sie einen Spielernamen ein")
      end
   end,
})

-- Toggle für Spectate-Funktion
Tab:CreateToggle({
   Name = "Spectate Player",
   CurrentValue = false,
   Flag = "SpectateToggle",
   Callback = function(Value)
      isSpectating = Value

      if isSpectating then
         if playerNameInput ~= "" then
            local targetPlayer = Players:FindFirstChild(playerNameInput)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
               Camera.CameraSubject = targetPlayer.Character.Humanoid -- Kamera auf den Spieler setzen
               print("Spectating " .. targetPlayer.Name)
            else
               print("Zielspieler nicht gefunden oder hat keinen gültigen Charakter")
            end
         else
            print("Bitte geben Sie einen Spielernamen ein")
         end
      else
         Camera.CameraSubject = LocalPlayer.Character.Humanoid -- Kamera zurücksetzen auf den lokalen Spieler
         print("Spectating beendet")
      end
   end,
})


local Tab = Window:CreateTab("⚙ Character", 4483362458)
local Section = Tab:CreateSection("ESP (Team Colors)")


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")

local function getTeamColor(player)
    if player.Team then
        return player.Team.TeamColor.Color
    end
    return Color3.new(1, 1, 1)  -- Weiß für Spieler ohne Team
end

local function highlightPlayer(player, highlight)
    local character = player.Character
    if character then
        local existingHighlight = character:FindFirstChild("Highlight")
        if highlight then
            if not existingHighlight then
                existingHighlight = Instance.new("Highlight")
                existingHighlight.Parent = character
            end
            local teamColor = getTeamColor(player)
            existingHighlight.FillColor = teamColor
            existingHighlight.OutlineColor = teamColor:Lerp(Color3.new(1, 1, 1), 0.5)
            existingHighlight.FillTransparency = 0.5
            existingHighlight.OutlineTransparency = 0
        elseif existingHighlight then
            existingHighlight:Destroy()
        end
    end
end

local function updateHighlights(highlight)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            highlightPlayer(player, highlight)
        end
    end
end

-- Verwenden Sie den bereitgestellten Toggle
local Toggle = Tab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
       updateHighlights(Value)
   end,
})

Players.PlayerAdded:Connect(function(player)
    if Toggle.CurrentValue then
        highlightPlayer(player, true)
    end
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if Toggle.CurrentValue then
            highlightPlayer(player, true)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    highlightPlayer(player, false)
end)

RunService.Heartbeat:Connect(function()
    if Toggle.CurrentValue then
        updateHighlights(true)
    end
end)

Teams.ChildAdded:Connect(function()
    if Toggle.CurrentValue then
        updateHighlights(true)
    end
end)

Teams.ChildRemoved:Connect(function()
    if Toggle.CurrentValue then
        updateHighlights(true)
    end
end)


local Section = Tab:CreateSection("Fly")


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local Flying = false
local DEFAULT_FLY_SPEED = 50
local FlySpeed = DEFAULT_FLY_SPEED

local function Fly()
    Flying = true
    Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    local BV = Instance.new("BodyVelocity", HumanoidRootPart)
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    local BG = Instance.new("BodyGyro", HumanoidRootPart)
    BG.P = 9e4
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    
    local Connection
    Connection = RunService.Heartbeat:Connect(function()
        if not Flying then 
            Connection:Disconnect()
            BV:Destroy()
            BG:Destroy()
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            return 
        end
        
        local MoveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            MoveDirection = MoveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            MoveDirection = MoveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            MoveDirection = MoveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            MoveDirection = MoveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            MoveDirection = MoveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            MoveDirection = MoveDirection - Vector3.new(0, 1, 0)
        end
        
        if MoveDirection.Magnitude > 0 then
            MoveDirection = MoveDirection.Unit
        end
        
        BV.Velocity = MoveDirection * FlySpeed
        BG.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + Camera.CFrame.LookVector)
    end)
end

local function Unfly()
    Flying = false
end

local FlyToggle = Tab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        if Value then
            Fly()
        else
            Unfly()
        end
    end,
})

local FlySpeedSlider = Tab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = DEFAULT_FLY_SPEED,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        FlySpeed = Value
    end,
})

local ResetFlySpeedButton = Tab:CreateButton({
    Name = "Reset Fly Speed",
    Callback = function()
        FlySpeed = DEFAULT_FLY_SPEED
        FlySpeedSlider:Set(DEFAULT_FLY_SPEED)
    end,
})

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    FlyToggle:Set(false)
end)






local Section = Tab:CreateSection("Speed & Jump Power")


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local DEFAULT_SPEED = 16
local DEFAULT_JUMP_POWER = 50

local function updateSpeed(value)
    Humanoid.WalkSpeed = value
end

local function updateJumpPower(value)
    Humanoid.JumpPower = value
end

local SpeedSlider = Tab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 350},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = DEFAULT_SPEED,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        updateSpeed(Value)
    end,
})

local JumpPowerSlider = Tab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 1000},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = DEFAULT_JUMP_POWER,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        updateJumpPower(Value)
    end,
})

local ResetButton = Tab:CreateButton({
    Name = "Reset to Default",
    Callback = function()
        SpeedSlider:Set(DEFAULT_SPEED)
        JumpPowerSlider:Set(DEFAULT_JUMP_POWER)
        updateSpeed(DEFAULT_SPEED)
        updateJumpPower(DEFAULT_JUMP_POWER)
    end,
})

-- Update speed and jump power when character respawns
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    updateSpeed(SpeedSlider.CurrentValue)
    updateJumpPower(JumpPowerSlider.CurrentValue)
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function resetCharacterPhysics(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart then
        -- Setze Schwerkraft zurück
        workspace.Gravity = 196.2  -- Standardwert in Roblox
        
        -- Entferne alle BodyMover
        for _, child in pairs(rootPart:GetChildren()) do
            if child:IsA("BodyMover") then
                child:Destroy()
            end
        end
        
        -- Setze Bodenhaftung zurück
        humanoid.PlatformStand = false
        
        -- Setze Geschwindigkeit zurück
        rootPart.Velocity = Vector3.new(0, 0, 0)
        
        -- Setze Sprunghöhe zurück
        humanoid.JumpHeight = 7.2  -- Standardwert in Roblox
        
        -- Setze Laufgeschwindigkeit zurück
        humanoid.WalkSpeed = 16  -- Standardwert in Roblox
    end
end

local function setupCharacter(player)
    local function onCharacterAdded(character)
        character:WaitForChild("Humanoid")
        
        -- Verbinde den Tod des Charakters
        character.Humanoid.Died:Connect(function()
            wait(1)  -- Warte kurz, bis der Charakter neu gespawnt ist
            resetCharacterPhysics(player.Character)
        end)
        
        -- Initialer Reset
        resetCharacterPhysics(character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Setze für alle aktuellen Spieler auf
for _, player in ipairs(Players:GetPlayers()) do
    setupCharacter(player)
end

-- Setze für neue Spieler auf
Players.PlayerAdded:Connect(setupCharacter)

-- Kontinuierliche Überprüfung
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            -- Überprüfe, ob der Spieler in der Luft schwebt
            if rootPart.Position.Y > workspace.FallenPartsDestroyHeight and not player.Character.Humanoid.Jump then
                local raycastResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -10, 0), 
                    RaycastParams.new())
                if not raycastResult then
                    resetCharacterPhysics(player.Character)
                end
            end
        end
    end
end)

-- Create a new tab for Info
local InfoTab = Window:CreateTab("Info", "info")

-- Credits section
InfoTab:CreateSection("Credits")
InfoTab:CreateLabel("Made by D3f4ult")

-- Discord button
InfoTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/2ynN9zcVFk")
        Rayfield:Notify({
            Title = "Discord Link Copied",
            Content = "Invite link copied to clipboard!",
            Duration = 3,
        })
    end,
}) 

-- Variables for time tracking
local startTime = os.time()
local loadingTime = 0

-- Get the executor name
local function getExecutor()
    local executor = identifyexecutor or getexecutorname or function() return "Unknown" end
    local executorInfo = executor() or "Unknown"
    
    -- Try to get executor version if available
    local version = ""
    if typeof(getexecutorversion) == "function" then
        version = getexecutorversion() or ""
        -- Remove 'v' prefix if it exists
        if version:sub(1, 1) == "v" then
            version = version:sub(2)
        end
    elseif syn and syn.version then
        version = tostring(syn.version)
        -- Remove 'v' prefix if it exists
        if version:sub(1, 1) == "v" then
            version = version:sub(2)
        end
    elseif KRNL_LOADED and KRNL_VERSION then
        version = tostring(KRNL_VERSION)
        -- Remove 'v' prefix if it exists
        if version:sub(1, 1) == "v" then
            version = version:sub(2)
        end
    end
    
    -- Format with version in brackets if version is available
    if version ~= "" then
        return executorInfo .. " [Version: " .. version .. "]"
    else
        return executorInfo
    end
end

-- Function to format time (seconds to MM:SS format)
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

-- Function to format account age
local function formatAccountAge(days)
    local years = math.floor(days / 365)
    local remainingDays = days % 365
    local months = math.floor(remainingDays / 30)
    remainingDays = remainingDays % 30
    
    if years > 0 then
        return string.format("%d years, %d months, %d days", years, months, remainingDays)
    elseif months > 0 then
        return string.format("%d months, %d days", months, remainingDays)
    else
        return string.format("%d days", remainingDays)
    end
end

-- Section for uptime
InfoTab:CreateSection("Session Statistics")

-- Label for uptime
local uptimeLabel = InfoTab:CreateLabel("Session Time: 00:00")

-- Start a timer to update the uptime label
task.spawn(function()
    while task.wait(1) do
        local elapsedTime = os.time() - startTime
        if uptimeLabel and uptimeLabel.Set then
            uptimeLabel:Set("Session Time: " .. formatTime(elapsedTime))
        end
    end
end)

-- Section for general info
InfoTab:CreateSection("System Information")

-- Label for executor
local executorLabel = InfoTab:CreateLabel("Executor: " .. getExecutor())

-- Get player information
local player = game.Players.LocalPlayer
local displayName = player.DisplayName or "Unknown"
local userName = player.Name or "Unknown"
local accountAge = player.AccountAge or 0

-- Add player information labels
InfoTab:CreateLabel("Display Name: " .. displayName)
InfoTab:CreateLabel("Username: " .. userName)
InfoTab:CreateLabel("Account Age: " .. formatAccountAge(accountAge)) 
