local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Tsunami Game",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading ...",
   LoadingSubtitle = "by D3f4ult",
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


Rayfield:Notify({
   Title = "Tsunami Game script",
   Content = "Enjoy my script :D",
   Duration = 5,
   Image = "info",
})


local Tab = Window:CreateTab("Info", "info")


local Paragraph = Tab:CreateParagraph({Title = "✨Discord✨", Content = "join my discord for more informations"})


local Button = Tab:CreateButton({
   Name = "Copy Discord link",
   Callback = function()
      local discordLink = "https://discord.gg/vpCmZyn9z4"
      
      if setclipboard then
         setclipboard(discordLink)
         print("Discord Link wurde in die Zwischenablage kopiert: " .. discordLink)
      else
         warn("setclipboard wird nicht unterstützt!")
      end
   end,
})


local Tab = Window:CreateTab("Collect Points", "anchor")


local workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local isTeleporting = false
local teleportCooldown = 0.1 -- Cooldown zwischen Teleportationen in Sekunden

local function teleportToCoins()
    if not isTeleporting then return end

    local coinFolders = workspace.CurrentPointCoins:GetChildren()
    for _, coinFolder in ipairs(coinFolders) do
        if not isTeleporting then break end
        local coinCollision = coinFolder:FindFirstChild("CoinCollision")
        if coinCollision then
            humanoidRootPart.CFrame = coinCollision.CFrame
            wait(teleportCooldown)
        end
    end
end

local Toggle = Tab:CreateToggle({
    Name = "Teleport to Coins",
    CurrentValue = false,
    Flag = "CoinTeleportToggle",
    Callback = function(Value)
        isTeleporting = Value
        if Value then
            while isTeleporting do
                teleportToCoins()
                wait(0.1) -- Kurze Pause, bevor erneut nach Coins gesucht wird
            end
        end
    end,
})


local Label = Tab:CreateLabel("Notice: If it doesn't go any further then it is because there are no points on the map", "info")


local Tab = Window:CreateTab("Teleport", "wind")
local Section = Tab:CreateSection("Teleport Locations")


local Button = Tab:CreateButton({
   Name = "Teleport to Spawn",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local targetZone = workspace.RedBoxParts.Zones:GetChildren()[2]
      if targetZone then
         humanoidRootPart.CFrame = targetZone.CFrame
      else
         print("Target zone not found")
      end
   end,
})


local Button = Tab:CreateButton({
   Name = "Teleport to the end",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local targetPart = workspace.ScriptImportance.WinnersTunnelBuild:GetChildren()[9]
      if targetPart then
         humanoidRootPart.CFrame = targetPart.CFrame
      else
         print("Zielobjekt nicht gefunden")
      end
   end,
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local targetPart = workspace.ScriptImportance.StreamingPersistent.WinnersPart
local respawnZone = workspace.RedBoxParts.Zones:GetChildren()[2]
local isFlying = false
local speed = 100 -- Sehr schnelle Fluggeschwindigkeit

local function toggleNoclip(state)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

local function teleportToRespawnZone()
    humanoidRootPart.CFrame = respawnZone.CFrame + Vector3.new(0, 5, 0)
end

local function flyToTarget()
    if not isFlying then return end
    
    local targetPosition = targetPart.Position + Vector3.new(0, 5, 0)
    local direction = (targetPosition - humanoidRootPart.Position).Unit
    local newPosition = humanoidRootPart.Position + direction * speed * RunService.Heartbeat:Wait()
    
    humanoidRootPart.CFrame = CFrame.new(newPosition, targetPosition)
    
    -- Überprüfen, ob das Ziel berührt wurde
    if (targetPart.Position - humanoidRootPart.Position).Magnitude < 5 then
        teleportToRespawnZone()
    end
end

local Toggle = Tab:CreateToggle({
    Name = "Zum Ziel fliegen",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        isFlying = Value
        toggleNoclip(Value)
        
        if Value then
            RunService:BindToRenderStep("FlyToTarget", Enum.RenderPriority.Character.Value, flyToTarget)
        else
            RunService:UnbindFromRenderStep("FlyToTarget")
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end,
})

-- Charakter neu laden Event
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    if isFlying then
        toggleNoclip(true)
    end
end)


local Label = Tab:CreateLabel("Notice: In some instances, the claim might not register. If this occurs, please continue attempting.", "info")


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
   Name = "Teleport to saved position",
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
   Name = "Enter player name",
   PlaceholderText = "Name des Spielers",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      playerNameInput = Text
   end,
})

-- Button zum Teleportieren
Tab:CreateButton({
   Name = "Teleport to player",
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
   Name = "Spectate player",
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


local Tab = Window:CreateTab("settings", "settings")
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
