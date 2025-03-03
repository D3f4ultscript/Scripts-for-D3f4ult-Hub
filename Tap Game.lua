local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
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


local Tab = Window:CreateTab("🔄 Farm", 4483362458)
local Section = Tab:CreateSection("Auto Clicker")


local AutoClickEnabled = false
local ClickLoop

local Toggle = Tab:CreateToggle({
    Name = "Auto Click",
    CurrentValue = false,
    Callback = function(Value)
        AutoClickEnabled = Value
        if AutoClickEnabled then
            ClickLoop = task.spawn(function()
                while true do
                    if not AutoClickEnabled then break end
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").Events.Click:FireServer()
                    end)
                    
                    task.wait(0.02)
                end
            end)
        else
            if ClickLoop then
                task.cancel(ClickLoop)
                ClickLoop = nil
            end
        end
    end
})


local Section = Tab:CreateSection("Auto Rebirth")


local AutoRebirthEnabled = false
local RebirthLoop
local rebirthAmount = 1

-- Toggle für Auto-Rebirth
local Toggle = Tab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Callback = function(Value)
        AutoRebirthEnabled = Value
        if AutoRebirthEnabled then
            RebirthLoop = task.spawn(function()
                while AutoRebirthEnabled do
                    local success, error = pcall(function()
                        game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(rebirthAmount)
                    end)
                    
                    if not success then
                        warn("Rebirth Error: " .. tostring(error))
                    end
                    
                    task.wait(0.2)  -- Pause zwischen Rebirths, anpassbar
                end
            end)
        else
            if RebirthLoop then
                task.cancel(RebirthLoop)
                RebirthLoop = nil
            end
        end
    end
})

-- Eingabefeld zur Änderung der Rebirth-Anzahl
local Input = Tab:CreateInput({
   Name = "Rebirth Amount Input",
   CurrentValue = "1",
   PlaceholderText = "Enter Rebirth Amount",
   RemoveTextAfterFocusLost = false,
   Flag = "RebirthInput",
   Callback = function(Text)
       local number = tonumber(Text)
       if number and number > 0 then
           rebirthAmount = number
       else
           rebirthAmount = 1  -- Setzt auf Standardwert bei ungültiger Eingabe
       end
   end,
})


local Tab = Window:CreateTab("🥚 Auto Hatch", 4483362458)
local Section = Tab:CreateSection("Auto Hatch")


-- Funktion zum Erstellen der Dropdowns und des Toggles
local function CreateDropdownsAndToggle()
    -- Funktion zum Abrufen der aktuellen EggHolders
    local function GetCurrentEggHolders()
        local eggHolders = {}
        for _, egg in pairs(workspace.Scripted.EggHolders:GetChildren()) do
            table.insert(eggHolders, egg.Name)
        end
        return eggHolders
    end

    -- Dropdown für EggHolders erstellen
    local eggHolderDropdown = Tab:CreateDropdown({
       Name = "Egg Holder",
       Options = GetCurrentEggHolders(),
       CurrentOption = {"Basic"},
       MultipleOptions = false,
       Flag = "Dropdown1",
       Callback = function(Options)
           print("Ausgewählte Egg Holder:", Options[1])
       end,
    })

    -- Liste der Anzahl-Optionen
    local quantityOptions = {"Single", "Triple", "Octuple"}

    -- Dropdown für Anzahl erstellen
    local quantityDropdown = Tab:CreateDropdown({
       Name = "Hatch Type",
       Options = quantityOptions,
       CurrentOption = {"Single"},
       MultipleOptions = false,
       Flag = "Dropdown2",
       Callback = function(Options)
           print("Ausgewählte Anzahl:", Options[1])
       end,
    })

    -- Variable zur Steuerung des kontinuierlichen Hatchens
    local isHatching = false

    -- Toggle erstellen
    local toggle = Tab:CreateToggle({
       Name = "Auto Hatch",
       CurrentValue = false,
       Flag = "Toggle1",
       Callback = function(Value)
           isHatching = Value

           if Value then
               print("Hatch aktiviert")
               while isHatching do
                   local eggHolderOption = eggHolderDropdown.CurrentOption[1]
                   local quantityOption = quantityDropdown.CurrentOption[1]

                   -- Argumente für das Hatch-Skript vorbereiten
                   local args = {
                       [1] = eggHolderOption,
                       [2] = quantityOption
                   }

                   -- Hatch-Funktion aufrufen
                   game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))

                   task.wait()  -- Wartezeit zwischen den Hatches
               end
           else
               print("Hatch deaktiviert")
           end
       end,
    })

    -- Funktion zum Aktualisieren der EggHolder-Optionen
    local function UpdateEggHolderOptions()
        local currentOptions = GetCurrentEggHolders()
        eggHolderDropdown:Refresh(currentOptions, true)
    end

    -- Verbindung erstellen, um auf Änderungen in EggHolders zu reagieren
    workspace.Scripted.EggHolders.ChildAdded:Connect(UpdateEggHolderOptions)
    workspace.Scripted.EggHolders.ChildRemoved:Connect(UpdateEggHolderOptions)
end

-- Aufruf der Funktion zum Erstellen der Dropdowns und des Toggles
CreateDropdownsAndToggle()


local Tab = Window:CreateTab("📅 Events", 4483362458)
local Section = Tab:CreateSection("Collect Heart Coins")


local isTeleporting = false
local teleportTask
local currentIndex = 1

local Toggle = Tab:CreateToggle({
   Name = "Schnell Heart Pickups einsammeln",
   CurrentValue = false,
   Flag = "FastTeleportToHeartPickups",
   Callback = function(Value)
      isTeleporting = Value
      if isTeleporting then
         teleportTask = task.spawn(function()
            while isTeleporting do
               local player = game.Players.LocalPlayer
               local character = player.Character
               if character and character:FindFirstChild("HumanoidRootPart") then
                  local hrp = character.HumanoidRootPart
                  local spawnPoints = workspace.Scripted.HeartPickups.SpawnPoints:GetChildren()
                  
                  if #spawnPoints > 0 then
                     if currentIndex > #spawnPoints then
                        currentIndex = 1 -- Zurück zum ersten SpawnPoint
                     end
                     
                     local targetSpawnPoint = spawnPoints[currentIndex]
                     if targetSpawnPoint:IsA("BasePart") then
                        -- Spieler springen lassen
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                           humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end

                        -- Warte kurz, um den Sprung auszuführen
                        task.wait(0.08)

                        -- Teleportiere den Spieler zum SpawnPoint
                        hrp.CFrame = targetSpawnPoint.CFrame

                        -- Gehe zum nächsten SpawnPoint
                        currentIndex = currentIndex + 1
                     end
                  end
               end

               -- Warte 0,2 Sekunden vor dem nächsten Teleport (sehr schnell)
               task.wait(0.08)
            end
         end)
      else
         if teleportTask then
            task.cancel(teleportTask)
         end
         currentIndex = 1 -- Zurücksetzen des Indexes, wenn der Toggle deaktiviert wird
      end
   end,
})


local Tab = Window:CreateTab("📝 Open GUIS", 4483362458)
local Section = Tab:CreateSection("Shops, upgrades ...")


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function teleportTouchPart(touchPartPath)
    local touchPart = workspace.Scripted.TouchParts:FindFirstChild(touchPartPath)
    if touchPart and touchPart:FindFirstChild("TouchPart") then
        local originalPosition = touchPart.TouchPart.Position
        local originalParent = touchPart.TouchPart.Parent

        -- Teleport TouchPart to player
        touchPart.TouchPart.CFrame = humanoidRootPart.CFrame
        task.wait(0.1)

        -- Teleport TouchPart back
        touchPart.TouchPart.Position = originalPosition
    else
        print(touchPartPath .. " TouchPart not found!")
    end
end

-- Füge Buttons für die TouchParts hinzu
local buttonData = {
    {"Upgrades", "Upgrades"},
    {"Tap Skins", "TapSkins"},
    {"Rebirth Upgrader", "RebirthUpgrader"},
    {"Potion Shop", "PotionShop"},
    {"Luck Upgrader", "LuckUpgrader"},
    {"Bank", "Bank"},
    {"Galaxy Upgrades", "GalaxyUpgrades"},
    {"Galaxy Potions", "GalaxyPotions"},
    {"Pixel Upgrades", "PixelUpgrades"},
}

for _, data in ipairs(buttonData) do
    local buttonName, touchPartPath = unpack(data)
    Tab:CreateButton({
        Name = "Open " .. buttonName .. " GUI",
        Callback = function()
            teleportTouchPart(touchPartPath)
        end,
    })
end

-- Füge den Button für PetAdventure hinzu
Tab:CreateButton({
    Name = "Open Pet Adventure GUI",
    Callback = function()
        local touchPart = workspace.Scripted.TouchParts.PetAdventure.TouchPart
        if touchPart then
            local originalPosition = touchPart.Position
            touchPart.CFrame = humanoidRootPart.CFrame
            task.wait(0.1)
            touchPart.Position = originalPosition
        else
            print("Pet Adventure TouchPart not found!")
        end
    end,
})


local Section = Tab:CreateSection("Events [Valentines]")


local Button = Tab:CreateButton({
   Name = "Open Valentine Prize GUI",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

      local touchPart = workspace.Scripted.TouchParts.ValentinePrize:FindFirstChild("TouchPart")
      if touchPart then
         local originalPosition = touchPart.CFrame
         
         -- Teleportiere TouchPart zum Spieler
         touchPart.CFrame = humanoidRootPart.CFrame
         
         -- Warte 1 Sekunde
         task.wait(1)
         
         -- Teleportiere TouchPart zurück
         touchPart.CFrame = originalPosition
      else
         warn("TouchPart nicht gefunden!")
      end
   end,
})


local Button = Tab:CreateButton({
   Name = "Open Valentine Shop GUI",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

      local touchPart = workspace.Scripted.TouchParts.ValentineShop:FindFirstChild("TouchPart")
      if touchPart then
         local originalPosition = touchPart.CFrame
         
         -- Teleportiere TouchPart zum Spieler
         touchPart.CFrame = humanoidRootPart.CFrame
         
         -- Warte 1 Sekunde
         task.wait(1)
         
         -- Teleportiere TouchPart zurück
         touchPart.CFrame = originalPosition
      else
         warn("ValentineShop TouchPart nicht gefunden!")
      end
   end,
})


local Button = Tab:CreateButton({
   Name = "Open Valentine Upgrades GUI",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

      local touchPart = workspace.Scripted.TouchParts.ValentineUpgrades:FindFirstChild("TouchPart")
      if touchPart then
         local originalPosition = touchPart.CFrame
         
         -- Teleportiere TouchPart zum Spieler
         touchPart.CFrame = humanoidRootPart.CFrame
         
         -- Warte 1 Sekunde
         task.wait(1)
         
         -- Teleportiere TouchPart zurück
         touchPart.CFrame = originalPosition
      else
         warn("ValentineUpgrades TouchPart nicht gefunden!")
      end
   end,
})


local Section = Tab:CreateSection("Reward Houses")


-- Button für GemRewardHouse
Tab:CreateButton({
    Name = "Open Gem Reward House GUI",
    Callback = function()
        local touchPart = workspace.Scripted.TouchParts.GemRewardHouse.TouchPart
        if touchPart then
            local originalPosition = touchPart.Position
            touchPart.CFrame = humanoidRootPart.CFrame
            task.wait(0.1)
            touchPart.Position = originalPosition
        else
            print("Gem Reward House TouchPart not found!")
        end
    end,
})

-- Button für GalaxyRewardHouse
Tab:CreateButton({
    Name = "Open Galaxy Reward House GUI",
    Callback = function()
        local touchPart = workspace.Scripted.TouchParts.GalaxyRewardHouse.TouchPart
        if touchPart then
            local originalPosition = touchPart.Position
            touchPart.CFrame = humanoidRootPart.CFrame
            task.wait(0.1)
            touchPart.Position = originalPosition
        else
            print("Galaxy Reward House TouchPart not found!")
        end
    end,
})

-- Button für PixelPrize
Tab:CreateButton({
    Name = "Open Pixel Prize GUI",
    Callback = function()
        local touchPart = workspace.Scripted.TouchParts.PixelPrize.TouchPart
        if touchPart then
            local originalPosition = touchPart.Position
            touchPart.CFrame = humanoidRootPart.CFrame
            task.wait(0.1)
            touchPart.Position = originalPosition
        else
            print("Pixel Prize TouchPart not found!")
        end
    end,
})


local Tab = Window:CreateTab("🌀 Teleport", 4483362458)
local Section = Tab:CreateSection("Teleport")


local Button = Tab:CreateButton({
   Name = "Teleport to Leaderboards",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local targetPart = workspace.Scripted.Islands.Spawn["LeaderBoard Pets"].Podium["1"].Part
      
      if targetPart then
         humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0) -- Teleportiert etwas über dem Ziel
      else
         print("Zielort nicht gefunden")
      end
   end,
})


local Tab = Window:CreateTab("⚙ Misc", 4483362458)
local Section = Tab:CreateSection("Auto Mastery")


local Toggle = Tab:CreateToggle({
   Name = "Auto Increase Mastery",
   CurrentValue = false,
   Flag = "AutoMasteryToggle",
   Callback = function(Value)
      if Value then
         -- Starte den Loop
         _G.AutoMasteryLoop = true
         spawn(function()
            while _G.AutoMasteryLoop do
               game:GetService("ReplicatedStorage").Functions.IncreaseMastery:InvokeServer()
               wait(1) -- Warte 1 Sekunde
            end
         end)
      else
         -- Stoppe den Loop
         _G.AutoMasteryLoop = false
      end
   end,
})


local Section = Tab:CreateSection("Auto Super Rebirth")


local isRunning = false
local rebirthTask

local Toggle = Tab:CreateToggle({
   Name = "Auto Super Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirthToggle",
   Callback = function(Value)
      isRunning = Value
      if isRunning then
         rebirthTask = task.spawn(function()
            while isRunning do
               game:GetService("ReplicatedStorage").Functions.IncreaseRebirth:InvokeServer()
               task.wait(1) -- Führt die Funktion so schnell wie möglich aus
            end
         end)
      else
         if rebirthTask then
            task.cancel(rebirthTask)
         end
      end
   end,
})
