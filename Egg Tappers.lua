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


local Tab = Window:CreateTab("🏠 Home", 4483362458)
local Section = Tab:CreateSection("Auto Clicker")


local isAutoClicking = false
local clickLoop

local AutoClickToggle = Tab:CreateToggle({
    Name = "Auto Click",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        isAutoClicking = Value
        if isAutoClicking then
            print("Auto Click aktiviert")
            clickLoop = task.spawn(function()
                while isAutoClicking do
                    local success, error = pcall(function()
                        game:GetService("ReplicatedStorage").Events.Click:FireServer()
                    end)
                    if success then
                        -- print("Click ausgeführt") -- Kommentiert, um Spam zu vermeiden
                    else
                        warn("Fehler beim Click:", error)
                    end
                    task.wait(0.01) -- 0.01 Sekunden Wartezeit, wie gewünscht
                end
            end)
        else
            print("Auto Click deaktiviert")
            if clickLoop then
                task.cancel(clickLoop)
                clickLoop = nil
            end
        end
    end,
})


local Section = Tab:CreateSection("Auto Rebirth")


local isAutoRebirthing = false
local rebirthLoop
local rebirthAmount = 1

-- Textbox für die Rebirth-Anzahl
local RebirthAmountInput = Tab:CreateInput({
    Name = "Rebirth Anzahl",
    PlaceholderText = "Anzahl eingeben",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local amount = tonumber(Text)
        if amount and amount > 0 then
            rebirthAmount = amount
            print("Rebirth Anzahl gesetzt auf:", rebirthAmount)
        else
            warn("Ungültige Eingabe. Bitte geben Sie eine positive Zahl ein.")
        end
    end,
})

-- Toggle für Auto-Rebirth
local AutoRebirthToggle = Tab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirthToggle",
    Callback = function(Value)
        isAutoRebirthing = Value
        if isAutoRebirthing then
            print("Auto Rebirth aktiviert")
            rebirthLoop = task.spawn(function()
                while isAutoRebirthing do
                    local args = {
                        [1] = rebirthAmount
                    }
                    local success, error = pcall(function()
                        game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
                    end)
                    if success then
                        print("Rebirth ausgeführt:", rebirthAmount)
                    else
                        warn("Fehler beim Rebirth:", error)
                    end
                    task.wait(0.01) -- Wartezeit zwischen Rebirths
                end
            end)
        else
            print("Auto Rebirth deaktiviert")
            if rebirthLoop then
                task.cancel(rebirthLoop)
                rebirthLoop = nil
            end
        end
    end,
})


local Tab = Window:CreateTab("🥚 Auto Hatch", 4483362458)
local Section = Tab:CreateSection("Auto Hatch")


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HatchFunction = ReplicatedStorage.Functions.Hatch

local isAutoHatchEnabled = false
local selectedEgg = "Basic" -- Standardwert
local selectedHatchType = "Single" -- Standardwert

-- Funktion zum Abrufen aller Eier-Namen
local function getEggNames()
    local eggNames = {}
    for _, eggHolder in pairs(workspace.Scripted.EggHolders:GetChildren()) do
        table.insert(eggNames, eggHolder.Name)
    end
    return eggNames
end

-- Erstellen des Ei-Dropdowns
local EggDropdown = Tab:CreateDropdown({
   Name = "Ei auswählen",
   Options = getEggNames(),
   CurrentOption = selectedEgg,
   MultipleOptions = false,
   Flag = "EggDropdown",
   Callback = function(Option)
      selectedEgg = Option[1] -- Aktualisiere das ausgewählte Ei
   end,
})

-- Erstellen des Hatch-Typ-Dropdowns
local HatchTypeDropdown = Tab:CreateDropdown({
   Name = "Hatch-Typ auswählen",
   Options = {"Single", "Triple", "Quintuple", "Decuple"},
   CurrentOption = selectedHatchType,
   MultipleOptions = false,
   Flag = "HatchTypeDropdown",
   Callback = function(Option)
      selectedHatchType = Option[1] -- Aktualisiere den ausgewählten Hatch-Typ
   end,
})

-- Toggle für Auto-Hatch
local Toggle = Tab:CreateToggle({
   Name = "Auto Hatch",
   CurrentValue = false,
   Flag = "AutoHatchToggle",
   Callback = function(Value)
      isAutoHatchEnabled = Value
   end,
})

-- Auto-Hatch Funktion
local function autoHatch()
    while true do
        if isAutoHatchEnabled then
            local args = {
                [1] = selectedEgg,
                [2] = selectedHatchType
            }
            HatchFunction:InvokeServer(unpack(args))
        end
        task.wait(0.001) -- Kurze Verzögerung zwischen den Aufrufen
    end
end

-- Starten der Auto-Hatch Funktion
coroutine.wrap(autoHatch)()


local Tab = Window:CreateTab("🟢 Open Guis", 4483362458)
local Section = Tab:CreateSection("Shops, upgrades ...")


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local UpgradesButton = Tab:CreateButton({
   Name = "Open Upgrades GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.Upgrades.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Upgrades TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local TapSkinsButton = Tab:CreateButton({
   Name = "Open Tap Skins GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.TapSkins.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Tap Skins TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local MasteryButton = Tab:CreateButton({
   Name = "Open Mastery GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.Mastery.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Mastery TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local SuperRebirthButton = Tab:CreateButton({
   Name = "Open Super Rebirth GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.SuperRebirth.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Super Rebirth TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local RebirthUpgraderButton = Tab:CreateButton({
   Name = "Open Rebirth Upgrader GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.RebirthUpgrader.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Rebirth Upgrader TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local PotionShopButton = Tab:CreateButton({
   Name = "Open Potion Shop GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.PotionShop.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Potion Shop TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local PetAdventureButton = Tab:CreateButton({
   Name = "Open Pet Adventure GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.PetAdventure.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Pet Adventure TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local LuckUpgraderButton = Tab:CreateButton({
   Name = "Open Luck Upgrader GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.LuckUpgrader.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Luck Upgrader TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local GemUpgraderButton = Tab:CreateButton({
   Name = "Open Gem Upgrader GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.GemUpgrader.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Gem Upgrader TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local GalaxyUpgradesButton = Tab:CreateButton({
   Name = "Open Galaxy Upgrades GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.GalaxyUpgrades.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Galaxy Upgrades TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local GalaxyPotionsButton = Tab:CreateButton({
   Name = "Open Galaxy Potions GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.GalaxyPotions.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Galaxy Potions TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local BankButton = Tab:CreateButton({
   Name = "Open Bank GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.Bank.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Bank TouchPart not found!")
      end
   end,
})


local Section = Tab:CreateSection("Events")


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Upgrades150KButton = Tab:CreateButton({
   Name = "Open 150K Upgrades GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts["150KUpgrades"].TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("150K Upgrades TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Shop200KButton = Tab:CreateButton({
   Name = "Open 200K Shop GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts["200KShop"].TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("200K Shop TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local ValentinesUpgradesButton = Tab:CreateButton({
   Name = "Open Valentines Upgrades GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.ValentinesUpgrades.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Valentines Upgrades TouchPart not found!")
      end
   end,
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local ValentinesShopButton = Tab:CreateButton({
   Name = "Open Valentines Shop GUI",
   Callback = function()
      local touchPart = workspace.Scripted.TouchParts.ValentinesShop.TouchPart
      if touchPart then
         local touchInterest = touchPart:FindFirstChild("TouchInterest")
         if touchInterest then
            firetouchinterest(humanoidRootPart, touchPart, 0)
            task.wait()
            firetouchinterest(humanoidRootPart, touchPart, 1)
         else
            print("TouchInterest not found!")
         end
      else
         print("Valentines Shop TouchPart not found!")
      end
   end,
})


local Tab = Window:CreateTab("⚙ Misc", 4483362458)
local Section = Tab:CreateSection("Auto Super Rebirth")


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RebirthFunction = ReplicatedStorage.Functions.IncreaseRebirth

local isAutoRebirthEnabled = false

-- Toggle für Auto-Rebirth
local RebirthToggle = Tab:CreateToggle({
   Name = "Auto Super Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirthToggle",
   Callback = function(Value)
      isAutoRebirthEnabled = Value
   end,
})

-- Auto-Rebirth Funktion
local function autoRebirth()
    while true do
        if isAutoRebirthEnabled then
            RebirthFunction:InvokeServer()
        end
        task.wait(0.1) -- Kurze Verzögerung zwischen den Aufrufen
    end
end

-- Starten der Auto-Rebirth Funktion
coroutine.wrap(autoRebirth)()


local Section = Tab:CreateSection("Auto Mastery")


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MasteryFunction = ReplicatedStorage.Functions.IncreaseMastery

local isAutoMasteryEnabled = false

-- Toggle für Auto-Mastery
local MasteryToggle = Tab:CreateToggle({
   Name = "Auto Mastery",
   CurrentValue = false,
   Flag = "AutoMasteryToggle",
   Callback = function(Value)
      isAutoMasteryEnabled = Value
   end,
})

-- Auto-Mastery Funktion
local function autoMastery()
    while true do
        if isAutoMasteryEnabled then
            MasteryFunction:InvokeServer()
        end
        task.wait(0.1) -- Kurze Verzögerung zwischen den Aufrufen
    end
end

-- Starten der Auto-Mastery Funktion
coroutine.wrap(autoMastery)()
