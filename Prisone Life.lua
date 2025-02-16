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

local function createDestroyTool()
    local tool = Instance.new("Tool")
    tool.Name = "Zerstörer"
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
    Name = "Zerstörer-Tool erhalten",
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
      tool.Name = "Unsichtbares TP-Tool"
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


local Button = Tab:CreateButton({
   Name = "Get Sharpened Stick",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local sharpenedStick = game:GetService("ReplicatedStorage").Tools["Sharpened stick"]
      
      if sharpenedStick then
         local tool = sharpenedStick:Clone()
         tool.Parent = player.Backpack
         print("Sharpened stick wurde dem Inventar hinzugefügt.")
      else
         print("Sharpened stick nicht gefunden.")
      end
   end,
})


local Button = Tab:CreateButton({
   Name = "Get Extendo Mirror",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local extendoMirror = game:GetService("ReplicatedStorage").Tools["Extendo mirror"]
      
      if extendoMirror then
         local tool = extendoMirror:Clone()
         tool.Parent = player.Backpack
         print("Extendo mirror wurde dem Inventar hinzugefügt.")
      else
         print("Extendo mirror nicht gefunden.")
      end
   end,
})


local Button = Tab:CreateButton({
   Name = "Get Crude Knife",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local crudeKnife = game:GetService("ReplicatedStorage").Tools["Crude Knife"]
      
      if crudeKnife then
         local tool = crudeKnife:Clone()
         tool.Parent = player.Backpack
         print("Crude Knife wurde dem Inventar hinzugefügt.")
      else
         print("Crude Knife nicht gefunden.")
      end
   end,
})


local Tab = Window:CreateTab("🗺 Map", 4483362458)
local Section = Tab:CreateSection("Destroy")


local Button = Tab:CreateButton({
   Name = "Destroy Prisone Doors",
   Callback = function()
      local doorsToRemove = {
         workspace.Doors:GetChildren()[11],
         workspace.Doors.door_v3,
         workspace.Doors:GetChildren()[7],
         workspace.Doors:GetChildren()[2],
         workspace.Doors:GetChildren()[4],
         workspace.Doors.door_v3_cellblock1,
         workspace.Doors.door_v3_ct,
         workspace.Doors:GetChildren()[9],
         workspace.Doors:GetChildren()[6],
         workspace.Doors.door_v3_small,
         workspace.Doors:GetChildren()[10],
         workspace.Doors.gate_v3,
      }

      for _, door in ipairs(doorsToRemove) do
         if door then
            door:Destroy()
            print("Tür entfernt:", door.Name)
         else
            print("Tür nicht gefunden")
         end
      end
      print("Entfernen der spezifizierten Türen abgeschlossen.")
   end,
})


local function destroyGlassParts()
    local glassPartsToDestroy = {
        workspace.Prison_Cellblock.b_front.glass:GetChildren()[3],
        workspace.Prison_Cellblock.b_front.glass:GetChildren()[8],
        workspace.Prison_Cellblock.b_front.glass.Part,
        workspace.Prison_Cellblock.b_front.glass:GetChildren()[4],
        workspace.Prison_Cellblock.b_front.glass:GetChildren()[2],
        workspace.Prison_Cellblock.b_front.glass:GetChildren()[6],
        workspace.Prison_Cellblock.b_front.glass:GetChildren()[5],
        workspace.Prison_Cellblock.b_front.glass:GetChildren()[7],
        workspace.Prison_Cellblock.a_front.glass:GetChildren()[3],
        workspace.Prison_Cellblock.a_front.glass:GetChildren()[7],
        workspace.Prison_Cellblock.a_front.glass:GetChildren()[5],
        workspace.Prison_Cellblock.a_front.glass:GetChildren()[6],
        workspace.Prison_Cellblock.a_front.glass:GetChildren()[2],
        workspace.Prison_Cellblock.a_front.glass:GetChildren()[4],
        workspace.Prison_Cellblock.a_front.glass.Part,
        workspace.Prison_Cellblock.a_front.glass:GetChildren()[8],
    }

    for _, part in ipairs(glassPartsToDestroy) do
        if part then
            part:Destroy()
        end
    end
end

local DestroyGlassButton = Tab:CreateButton({
    Name = "Destroy cell glass",
    Callback = function()
        destroyGlassParts()
    end,
})


local Tab = Window:CreateTab("🌀 Teleport", 4483362458)
local Section = Tab:CreateSection("Spawnpoints")


local Button = Tab:CreateButton({
   Name = "Teleport to Prisone Spawn",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local destination = workspace.Prison_spawn.Nexus:GetChildren()[12]
      
      if destination then
         humanoidRootPart.CFrame = destination.CFrame + Vector3.new(0, 3, 0) -- Teleportiert etwas über dem Ziel
         print("Teleportiert zu: " .. destination.Name)
      else
         print("Teleportationsziel nicht gefunden.")
      end
   end,
})


local Button = Tab:CreateButton({
   Name = "Teleport to Guard Spawn",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local destination = workspace.Prison_guardspawn:GetChildren()[5]
      
      if destination then
         humanoidRootPart.CFrame = destination.CFrame + Vector3.new(0, 3, 0) -- Teleportiert etwas über dem Ziel
         print("Teleportiert zu: Guard Spawn Position")
      else
         print("Teleportationsziel nicht gefunden.")
      end
   end,
})


local Button = Tab:CreateButton({
   Name = "Teleport to Criminal Spawn",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local criminalSpawn = workspace["Criminals Spawn"].SpawnLocation
      
      if criminalSpawn then
         humanoidRootPart.CFrame = criminalSpawn.CFrame + Vector3.new(0, 3, 0)
         print("Zum Criminals Spawn teleportiert.")
      else
         print("Criminals Spawn nicht gefunden.")
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



local Section = Tab:CreateSection("Noclip")


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local noclip = false
local connection

local function setNoclip(state)
    if state then
        connection = RunService.Stepped:Connect(function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        -- Setze den Charakter zurück
        Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end

local NoclipToggle = Tab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        noclip = Value
        setNoclip(noclip)
    end,
})

local function onCharacterAdded(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    noclip = false
    NoclipToggle:Set(false)
    if connection then
        connection:Disconnect()
    end
end


LocalPlayer.CharacterAdded:Connect(onCharacterAdded)


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
