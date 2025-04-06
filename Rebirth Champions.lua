local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TW Hub - Rebirth Champion X",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "TW Hub - Rebirth Champion X",
   LoadingSubtitle = "by D3f4ult",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "TW Hub"
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


local Tab = Window:CreateTab("🔄 Farm", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Auto Clicker")


local isRunning = false  -- Globale Variable zum Kontrollieren

local Toggle = Tab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "AutoClickerToggle", 
   Callback = function(Value)
       isRunning = Value  -- Setzt globale Variable
       
       if Value then
           spawn(function()
               while isRunning do
                   game:GetService("ReplicatedStorage").Events.Click4:FireServer()
                   task.wait(0.00001)  -- Klickt alle 0.1 Sekunden
               end
           end)
       end
   end,
})


local Section = Tab:CreateSection("Auto Rebirth")


local RebirthValue = 1  -- Standardwert
local isRunning = false  -- Globale Variable zum Kontrollieren

local Input = Tab:CreateInput({
   Name = "Rebirth Button",
   CurrentValue = tostring(RebirthValue),
   PlaceholderText = "Enter Rebirth Amount",
   RemoveTextAfterFocusLost = false,
   Flag = "RebirthInput",
   Callback = function(Text)
       local newValue = tonumber(Text)
       if newValue and newValue > 0 then
           RebirthValue = newValue
       end
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirthToggle", 
   Callback = function(Value)
       isRunning = Value  -- Setzt globale Variable
       
       if Value then
           spawn(function()
               while isRunning do  -- Prüft globale Variable
                   local args = {
                       [1] = RebirthValue
                   }
                   game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
                   task.wait(0.00001)
               end
           end)
       end
   end,
})


local Section = Tab:CreateSection("Craft All")


local isRunning = false

local Toggle = Tab:CreateToggle({
   Name = "Auto Craft All",
   CurrentValue = false,
   Flag = "AutoCraftToggle", 
   Callback = function(Value)
       isRunning = Value
       
       if Value then
           spawn(function()
               while isRunning do
                   local args = {
                       [1] = "CraftAll",
                       [2] = {}
                   }
                   game:GetService("ReplicatedStorage").Functions.Request:InvokeServer(unpack(args))
                   task.wait(0.001)  -- Kurze Wartezeit zwischen Crafts
               end
           end)
       end
   end,
})


local Tab = Window:CreateTab("🥚 Auto Hatch", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Auto Hatch")


local eggOptions = {}

-- Eggs aus workspace.Scripts.Eggs auslesen
for _, egg in pairs(workspace.Scripts.Eggs:GetChildren()) do
    table.insert(eggOptions, egg.Name)
end

local selectedEgg = eggOptions[1]
local hatchMode = "Single"
local isRunning = false

local Dropdown = Tab:CreateDropdown({
   Name = "Select Egg",
   Options = eggOptions,
   CurrentOption = {eggOptions[1]},
   MultipleOptions = false,
   Flag = "EggSelector", 
   Callback = function(Options)
       selectedEgg = Options[1]
   end,
})

local Dropdown2 = Tab:CreateDropdown({
   Name = "Hatch Mode",
   Options = {"Single", "Triple", "Octuple"},
   CurrentOption = {"Single"},
   MultipleOptions = false,
   Flag = "HatchModeSelector",
   Callback = function(Options)
       hatchMode = Options[1]
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Auto Hatch",
   CurrentValue = false,
   Flag = "AutoHatchToggle", 
   Callback = function(Value)
       isRunning = Value
       
       if Value then
           spawn(function()
               while isRunning do
                   local args = {
                       [1] = selectedEgg,
                       [2] = hatchMode
                   }
                   game:GetService("ReplicatedStorage").Functions.Unbox:InvokeServer(unpack(args))
                   task.wait(0.001)
               end
           end)
       end
   end,
})


local Tab = Window:CreateTab("🌀 Teleport", 4483362458) -- Title, Image


local Button = Tab:CreateButton({
    Name = "Teleport to Leaderboards",
    Callback = function()
        local success, message = pcall(function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            local targetLocation = workspace.Scripts.Leaderboards.TotalClicks:GetChildren()[4]

            assert(targetLocation, "Zielort nicht gefunden")
            assert(humanoidRootPart and humanoid, "Character nicht vollständig geladen")

            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            humanoidRootPart.CFrame = targetLocation.CFrame + Vector3.new(0, 5, 0)
            task.wait(0.1)
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            humanoid:ChangeState(Enum.HumanoidStateType.Landing)
        end)

        if not success then
            warn("Teleport fehlgeschlagen: " .. message)
        end
    end
})


local Tab = Window:CreateTab("📝 Open Guis", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Shops, upgrades ...")


local Button = Tab:CreateButton({
    Name = "Open Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.Upgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Space Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.SpaceUpgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Aqua Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.AquaUpgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Fantasy Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.FantasyUpgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Time Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.TimeUpgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Fire Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.FireUpgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Fun Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.FunUpgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Elemental Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.ElementalUpgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Celestial Upgrades GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.CelestialUpgrades.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Spawn Potions GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.Potions.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Space Potions Gui",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn:GetChildren()[7].Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Aqua Potions GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.AquaPotions.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Tap Skins GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.TapSkins.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Auras GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.Auras.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Bank GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.Bank.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Boosts Crafting GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.BoostsCrafting.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Destruction Machine GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.DestructionMachine.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Evolution GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.Evolution.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Flames Shop GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.FlamesShop.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Global Event Wheel GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.GlobalEventWheel.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Index GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.Index.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Multiplier Upgrader GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.MultiplierUpgrader.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Pet Machine GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.PetMachine.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Pet Upgrader GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.PetUpgrader.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Button = Tab:CreateButton({
    Name = "Open Playtime Machine GUI",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local touchPart = workspace.Scripts.Spawn.PlaytimeMachine.Touch

        firetouchinterest(rootPart, touchPart, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, touchPart, 1)
    end,
})


local Tab = Window:CreateTab("⚙ Misc", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Rebirth Buttons")


local isRunning = false  -- Globale Variable zum Kontrollieren

local Toggle = Tab:CreateToggle({
   Name = "Auto Rebirth Upgrade",
   CurrentValue = false,
   Flag = "AutoRebirthUpgradeToggle", 
   Callback = function(Value)
       isRunning = Value  -- Setzt globale Variable
       
       if Value then
           spawn(function()
               while isRunning do
                   local args = {
                       [1] = "RebirthButtons"
                   }
                   game:GetService("ReplicatedStorage").Functions.Upgrade:InvokeServer(unpack(args))
                   task.wait(0.1)  -- Kurze Wartezeit zwischen Upgrades
               end
           end)
       end
   end,
})


local Section = Tab:CreateSection("Claim Chests")


local Button = Tab:CreateButton({
    Name = "Claim All Chests",
    Callback = function()
        local chestFolders = {
            workspace.Scripts.Chests.Aqua,
            workspace.Scripts.Chests.Beach,
            workspace.Scripts.Chests.Celestial,
            workspace.Scripts.Chests.Cyber,
            workspace.Scripts.Chests.Fantasy,
            workspace.Scripts.Chests.Fire,
            workspace.Scripts.Chests.Galaxy,
            workspace.Scripts.Chests.Hacker,
            workspace.Scripts.Chests.Haunted,
            workspace.Scripts.Chests.Hell,
            workspace.Scripts.Chests["Magma Temple"],
            workspace.Scripts.Chests.Maze,
            workspace.Scripts.Chests.Nuclear,
            workspace.Scripts.Chests.Pirate,
            workspace.Scripts.Chests.Sandbox,
            workspace.Scripts.Chests.Shadow,
            workspace.Scripts.Chests.Space,
            workspace.Scripts.Chests.Spawn,
            workspace.Scripts.Chests.Time,
            workspace.Scripts.Chests.Viking,
            workspace.Scripts.Chests.Winter
        }

        for _, folder in ipairs(chestFolders) do
            for _, chest in ipairs(folder:GetDescendants()) do
                if chest:IsA("TouchTransmitter") then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, chest.Parent, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, chest.Parent, 1)
                end
            end
        end
    end,
})


local Section = Tab:CreateSection("Claim Amulets (maybe collecting not all first time, spam E to claim)")


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRootPart()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char:WaitForChild("Humanoid")
end

local AmuletFolders = {
    workspace.Scripts.Amulets.Collect.Aqua,
    workspace.Scripts.Amulets.Collect.Fantasy,
    workspace.Scripts.Amulets.Collect.Fire,
    workspace.Scripts.Amulets.Collect.Forest,
    workspace.Scripts.Amulets.Collect.Fun,
    workspace.Scripts.Amulets.Collect.Magic,
    workspace.Scripts.Amulets.Collect.Sand,
    workspace.Scripts.Amulets.Collect.Space,
}

local function freezeCharacter()
    local char = getCharacter()
    local rootPart = getRootPart()
    local humanoid = getHumanoid()
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    if not char:FindFirstChild("BodyVelocity") then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = rootPart
    end
    
    if not char:FindFirstChild("BodyGyro") then
        local bg = Instance.new("BodyGyro")
        bg.CFrame = rootPart.CFrame
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 10000
        bg.Parent = rootPart
    end
end

local function unfreezeCharacter()
    local char = getCharacter()
    local rootPart = getRootPart()
    local humanoid = getHumanoid()
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    
    local bv = rootPart:FindFirstChild("BodyVelocity")
    if bv then bv:Destroy() end
    
    local bg = rootPart:FindFirstChild("BodyGyro")
    if bg then bg:Destroy() end
end

local function collectAmulets(folder)
    freezeCharacter()
    
    for _, model in pairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local prompt = model:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt then
                prompt.HoldDuration = 0
                getRootPart().CFrame = model:GetPivot() * CFrame.new(0, 3, 0)
                task.wait(0.1)
                fireproximityprompt(prompt)
                task.wait(0.2)
            end
        end
    end
    
    unfreezeCharacter()
end

for _, folder in pairs(AmuletFolders) do
    local Button = Tab:CreateButton({
        Name = "Collect " .. folder.Name .. " Amulets",
        Callback = function()
            task.spawn(function()
                collectAmulets(folder)
            end)
        end,
    })
end

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
