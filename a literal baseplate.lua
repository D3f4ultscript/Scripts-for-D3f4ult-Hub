local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "a literal baseplate",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading ...",
   LoadingSubtitle = "by D3f4ult",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "tt_g2030"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "f2bm79eA", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
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


local Tab = Window:CreateTab("🏠 Main", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Fly")


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Flying = false
local Speed = 50

local function Fly()
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = HumanoidRootPart.CFrame
    BodyGyro.Parent = HumanoidRootPart

    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = HumanoidRootPart

    while Flying and HumanoidRootPart do
        local Move = {
            Forward = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0,
            Backward = UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0,
            Right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0,
            Left = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0,
            Up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0,
            Down = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0
        }

        BodyGyro.CFrame = workspace.CurrentCamera.CoordinateFrame
        BodyVelocity.Velocity = (workspace.CurrentCamera.CoordinateFrame.LookVector * (Move.Forward + Move.Backward) + 
                                 workspace.CurrentCamera.CoordinateFrame.RightVector * (Move.Right + Move.Left) + 
                                 workspace.CurrentCamera.CoordinateFrame.UpVector * (Move.Up + Move.Down)) * Speed

        RunService.RenderStepped:Wait()
    end

    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
    Humanoid.PlatformStand = false
end

local Toggle = Tab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
       Flying = Value
       if Flying then
           Humanoid.PlatformStand = true
           Fly()
       else
           Humanoid.PlatformStand = false
       end
   end,
})

local Input = Tab:CreateInput({
   Name = "Fly Speed",
   CurrentValue = tostring(Speed),
   PlaceholderText = "Enter fly speed",
   RemoveTextAfterFocusLost = false,
   Flag = "FlySpeedInput",
   Callback = function(Text)
       local newSpeed = tonumber(Text)
       if newSpeed and newSpeed > 0 then
           Speed = newSpeed
       end
   end,
})

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    if Flying then
        Humanoid.PlatformStand = true
        Fly()
    end
end)


local Section = Tab:CreateSection("Speed and Jump Power")

-- Speed Slider
local SpeedSlider = Tab:CreateSlider({
   Name = "Speed",
   Range = {16, 2000},  -- Standard Walkspeed ist 16, maximaler Wert 100
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
       local Character = game.Players.LocalPlayer.Character
       if Character and Character:FindFirstChild("Humanoid") then
           Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Jump Power Slider
local JumpPowerSlider = Tab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 3500},  -- Standard Jump Power ist 50, maximaler Wert 250
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpPowerSlider", 
   Callback = function(Value)
       local Character = game.Players.LocalPlayer.Character
       if Character and Character:FindFirstChild("Humanoid") then
           Character.Humanoid.JumpPower = Value
       end
   end,
})

-- Reset Button für Speed und Jump Power
local ResetStatsButton = Tab:CreateButton({
   Name = "Reset Movement Stats",
   Callback = function()
       local Character = game.Players.LocalPlayer.Character
       if Character and Character:FindFirstChild("Humanoid") then
           -- Setze WalkSpeed auf Standard (16)
           Character.Humanoid.WalkSpeed = 16
           SpeedSlider:Set(16)  -- Setzt auch den Slider zurück
           
           -- Setze JumpPower auf Standard (50)
           Character.Humanoid.JumpPower = 50
           JumpPowerSlider:Set(50)  -- Setzt auch den Slider zurück
           
           print("Movement Stats wurden zurückgesetzt")
       end
   end,
})



local Section = Tab:CreateSection("Noclip")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local NoClipEnabled = false

-- Funktion, die NoClip aktiviert oder deaktiviert
local function ToggleNoClip(enabled)
    NoClipEnabled = enabled
end

-- Überprüft kontinuierlich, ob NoClip aktiviert ist, und deaktiviert Kollisionen
RunService.Stepped:Connect(function()
    if NoClipEnabled and Character then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false -- Deaktiviert die Kollision
            end
        end
    end
end)

-- Toggle für NoClip
local Toggle = Tab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(Value)
        ToggleNoClip(Value)
    end,
})

-- Aktualisiere den Charakter, wenn der Spieler respawnt
LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter

    -- Wenn NoClip aktiv ist, wird es nach dem Respawn weitergeführt
    if NoClipEnabled then
        ToggleNoClip(true)
    end
end)


local Tab = Window:CreateTab("🌀 Teleport", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Player Tp")


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Funktion zur Teleportation
local function TeleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character then
        local targetHumanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHumanoidRootPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetHumanoidRootPart.CFrame
        else
            warn("Konnte HumanoidRootPart nicht finden.")
        end
    else
        warn("Spieler nicht gefunden oder nicht geladen.")
    end
end

-- Textfeld für den Spielernamen
local PlayerNameInput = Tab:CreateInput({
   Name = "Player Name",
   PlaceholderText = "Enter player name",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      -- Diese Funktion wird jedes Mal aufgerufen, wenn der Text geändert wird
   end,
})

-- Button für die einmalige Teleportation
local TeleportButton = Tab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      local targetPlayerName = PlayerNameInput.CurrentValue
      if targetPlayerName and targetPlayerName ~= "" then
          TeleportToPlayer(targetPlayerName)
      else
          warn("Bitte geben Sie einen Spielernamen ein.")
      end
   end,
})

-- Toggle für kontinuierliche Teleportation
local isTeleporting = false
local TeleportToggle = Tab:CreateToggle({
    Name = "Auto Teleport to Player",
    CurrentValue = false,
    Flag = "AutoTeleportToggle",
    Callback = function(Value)
        isTeleporting = Value
        if isTeleporting then
            RunService.Heartbeat:Connect(function()
                if isTeleporting then
                    local targetPlayerName = PlayerNameInput.CurrentValue
                    if targetPlayerName and targetPlayerName ~= "" then
                        TeleportToPlayer(targetPlayerName)
                    end
                end
            end)
        end
    end,
})


local Section = Tab:CreateSection("Position Teleport")


local savedPosition = nil

local SaveButton = Tab:CreateButton({
   Name = "save Position",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      savedPosition = character:GetPrimaryPartCFrame()
      print("Position gespeichert")
   end,
})

local TeleportButton = Tab:CreateButton({
    Name = "Teleport to saved Position",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      if savedPosition then
         character:SetPrimaryPartCFrame(savedPosition)
         print("Zur gespeicherten Position teleportiert")
      else
         print("Keine Position gespeichert")
      end
   end,
})


local Tab = Window:CreateTab("🛠 Give Tools", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Tools")


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function CreateTpTool()
    local tool = Instance.new("Tool")
    tool.Name = "TP Tool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    tool.Activated:Connect(function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)

    return tool
end

local TpButton = Tab:CreateButton({
   Name = "Get TP Tool",
   Callback = function()
      local tpTool = CreateTpTool()
      if LocalPlayer.Character then
          tpTool.Parent = LocalPlayer.Backpack
          print("Invisible TP Tool added to your inventory!")
      else
          warn("Character not found. Please try again when your character has loaded.")
      end
   end,
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Funktion, um das Destroy Tool zu erstellen
local function CreateDestroyTool()
    local tool = Instance.new("Tool")
    tool.Name = "Destroy Tool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    -- Funktion, die beim Klicken mit dem Tool ausgeführt wird
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target then
            mouse.Target:Destroy() -- Löscht das angeklickte Objekt
        end
    end)

    return tool
end

-- Button, um das Destroy Tool zu erhalten
local DestroyToolButton = Tab:CreateButton({
   Name = "Get Destroy Tool",
   Callback = function()
      local destroyTool = CreateDestroyTool()
      if LocalPlayer.Backpack then
          destroyTool.Parent = LocalPlayer.Backpack
          print("Destroy Tool added to your inventory!")
      else
          warn("Backpack not found. Please try again.")
      end
   end,
})


local Button = Tab:CreateButton({
   Name = "Get Troll Tool [Click on Players to activate it]",
   Callback = function()
      local tool = Instance.new("Tool")
      tool.Name = "TrollTool"
      tool.RequiresHandle = false
      
      local isOrbiting = false
      local connection

      tool.Activated:Connect(function()
         local player = game.Players.LocalPlayer
         local mouse = player:GetMouse()
         local target = mouse.Target
         
         if target and target.Parent:FindFirstChild("Humanoid") then
            local targetPlayer = target.Parent
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
               isOrbiting = true
               if connection then connection:Disconnect() end
               connection = game:GetService("RunService").Heartbeat:Connect(function(dt)
                  if not isOrbiting or not targetPlayer or not targetPlayer.Parent then
                     connection:Disconnect()
                     return
                  end
                  local targetPos = targetPlayer.PrimaryPart.Position
                  local time = tick() * 15  -- Moderate Geschwindigkeit
                  local radius = 6 + math.sin(time * 0.7) * 3  -- Variabler Radius
                  local height = math.sin(time * 0.5) * 4  -- Moderate vertikale Bewegung
                  local newPos = targetPos + Vector3.new(
                     math.cos(time) * radius,
                     height,
                     math.sin(time) * radius
                  )
                  character.HumanoidRootPart.CFrame = CFrame.new(newPos, targetPos)
               end)
            end
         else
            isOrbiting = false
            if connection then connection:Disconnect() end
         end
      end)
      
      game.Players.LocalPlayer.Character.Humanoid.Jumping:Connect(function()
         isOrbiting = false
         if connection then connection:Disconnect() end
      end)
      
      tool.Parent = game.Players.LocalPlayer.Backpack
   end,
})

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
