local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Clicker Masters Autofarm",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Clicker Masters",
   LoadingSubtitle = "by D3f4ult",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "???-Hub"
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


local ClickService = game:GetService("ReplicatedStorage").Events.Click

local AutoClickerEnabled = false

local Toggle = Tab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClickerToggle",
    Callback = function(Value)
        AutoClickerEnabled = Value
        if AutoClickerEnabled then
            spawn(function()
                while AutoClickerEnabled do
                    pcall(function()
                        ClickService:FireServer()
                    end)
                    wait(0.01) -- Sehr schnelles Klicken
                end
            end)
        end
    end,
})


local Section = Tab:CreateSection("Auto Rebirth")


local RebirthService = game:GetService("ReplicatedStorage").Events.Rebirth

local RebirthButtonIndex = 1
local AutoRebirthEnabled = false

local Input = Tab:CreateInput({
   Name = "Rebirth Amount",
   CurrentValue = "1",
   PlaceholderText = "Rebirth (1, 5, 10...)",
   RemoveTextAfterFocusLost = false,
   Flag = "RebirthButtonInput",
   Callback = function(Text)
       local index = tonumber(Text)
       if index and index > 0 then
           RebirthButtonIndex = index
       else
           RebirthButtonIndex = 1
       end
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirthToggle",
   Callback = function(Value)
       AutoRebirthEnabled = Value
       if AutoRebirthEnabled then
           spawn(function()
               while AutoRebirthEnabled do
                   local args = {
                       [1] = RebirthButtonIndex
                   }
                   RebirthService:FireServer(unpack(args))
                   wait(0.2)
               end
           end)
       end
   end,
})


local Section = Tab:CreateSection("Open Guis")


local GoldenCraftingMachine = workspace.Scripted.TouchEvent["Golden Crafting Machine"].TouchListener

local Button = Tab:CreateButton({
   Name = "Golden Crafting Machine",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

       firetouchinterest(humanoidRootPart, GoldenCraftingMachine, 0)
       wait(0.1)
       firetouchinterest(humanoidRootPart, GoldenCraftingMachine, 1)
   end,
})


local ToxicCraftingMachine = workspace.Scripted.TouchEvent["Toxic Crafting Machine"].TouchListener

local Button = Tab:CreateButton({
   Name = "Toxic Crafting Machine",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

       firetouchinterest(humanoidRootPart, ToxicCraftingMachine, 0)
       wait(0.1)
       firetouchinterest(humanoidRootPart, ToxicCraftingMachine, 1)
   end,
})


local TapSkinsTouchInterest = workspace.Scripted.TouchEvent.TapSkins.TouchListener.TouchInterest

local Button = Tab:CreateButton({
    Name = "Open TapSkins",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

       firetouchinterest(humanoidRootPart, TapSkinsTouchInterest.Parent, 0)
       wait(0.1)
       firetouchinterest(humanoidRootPart, TapSkinsTouchInterest.Parent, 1)
   end,
})


local AuraShopTouchInterest = workspace.Scripted.TouchEvent.AuraShop.TouchListener.TouchInterest

local Button = Tab:CreateButton({
   Name = "Open AuraShop",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

       firetouchinterest(humanoidRootPart, AuraShopTouchInterest.Parent, 0)
       wait(0.1)
       firetouchinterest(humanoidRootPart, AuraShopTouchInterest.Parent, 1)
   end,
})


local UpgradeTouchInterest = workspace.Scripted.TouchEvent.upgrade.TouchListener.TouchInterest

local Button = Tab:CreateButton({
   Name = "Open Upgrade Shop",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

       firetouchinterest(humanoidRootPart, UpgradeTouchInterest.Parent, 0)
       wait(0.1)
       firetouchinterest(humanoidRootPart, UpgradeTouchInterest.Parent, 1)
   end,
})


local Button = Tab:CreateButton({
   Name = "Open Combine-O-Matic",
   Callback = function()
      local TouchPart = workspace.Scripted.TouchEvent.CombineOMatic.TouchListener
      firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, TouchPart, 0)
      firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, TouchPart, 1)
   end
})


local Button = Tab:CreateButton({
    Name = "Open Potion Shop",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local touchPart = workspace.Scripted.TouchEvent.PotionShop.TouchListener
        local touchInterest = touchPart.TouchInterest
        
        firetouchinterest(humanoidRootPart, touchPart, 0)
        task.wait()
        firetouchinterest(humanoidRootPart, touchPart, 1)
    end,
})


local Tab = Window:CreateTab("🥚 Auto Hatch", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Auto Hatch")


local HatchService = game:GetService("ReplicatedStorage").Functions.Hatch
local EggHolders = workspace.Scripted.EggHolders

-- Sammle alle Eggs aus dem EggHolders Ordner
local Eggs = {}
for _, egg in ipairs(EggHolders:GetChildren()) do
    table.insert(Eggs, egg.Name)
end

local SelectedEgg = Eggs[1]
local SelectedHatchMode = "Single"  -- Standardmäßig auf "Single" setzen
local AutoHatchEnabled = false

-- Dropdown für die Auswahl des Eis
local EggDropdown = Tab:CreateDropdown({
   Name = "Egg Auswahl",
   Options = Eggs,
   CurrentOption = {Eggs[1]},
   MultipleOptions = false,
   Flag = "EggDropdown",
   Callback = function(Option)
       SelectedEgg = Option[1]
       print("Ausgewähltes Ei: " .. SelectedEgg)
   end,
})

-- Dropdown für den Hatch-Modus
local HatchModeDropdown = Tab:CreateDropdown({
   Name = "Hatch Mode",
   Options = {"Single", "Triple", "Octuple"},
   CurrentOption = {"Single"},  -- Standardmäßig auf "Single" setzen
   MultipleOptions = false,
   Flag = "HatchModeDropdown",
   Callback = function(Option)
       SelectedHatchMode = Option[1]
       print("Ausgewählter Hatch Mode: " .. SelectedHatchMode)
   end,
})

-- Toggle für Auto Hatch
local Toggle = Tab:CreateToggle({
   Name = "Auto Hatch",
   CurrentValue = false,
   Flag = "AutoHatchToggle",
   Callback = function(Value)
       AutoHatchEnabled = Value
       if AutoHatchEnabled then
           spawn(function()
               while AutoHatchEnabled do
                   local hatchMode
                   if SelectedHatchMode == "Single" then
                       hatchMode = "Single"
                   elseif SelectedHatchMode == "Triple" then
                       hatchMode = "Triple"
                   elseif SelectedHatchMode == "Octuple" then
                       hatchMode = "Octuple"
                   end

                   local args = {
                       [1] = SelectedEgg,
                       [2] = hatchMode
                   }
                   HatchService:InvokeServer(unpack(args))
                   wait(0.000001) -- Wartezeit zwischen den Hatches (anpassen wie nötig)
               end
           end)
       end
   end,
})


local Tab = Window:CreateTab("🌀 Teleport", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Map")


Tab:CreateButton({
   Name = "Teleport to Leaderboard",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local targetObject = workspace.Folder:GetChildren()[13]
      
      if targetObject then
         if targetObject:IsA("BasePart") then
            -- Wenn das Zielobjekt ein BasePart ist, teleportiere direkt darüber
            humanoidRootPart.CFrame = targetObject.CFrame * CFrame.new(0, 5, 0)
         elseif targetObject:IsA("Model") then
            -- Wenn das Zielobjekt ein Model ist, suche nach dem PrimaryPart oder dem ersten BasePart
            local targetPart = targetObject.PrimaryPart or targetObject:FindFirstChildWhichIsA("BasePart")
            if targetPart then
               humanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 5, 0)
            else
               print("Kein geeigneter Teil im Zielobjekt gefunden.")
               return
            end
         else
            print("Zielobjekt ist weder ein BasePart noch ein Model.")
            return
         end
         print("Zum 13. Objekt teleportiert!")
      else
         print("13. Objekt nicht gefunden.")
      end
   end,
})


local Tab = Window:CreateTab("⚙ Misc", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Give Pets")


local ClaimHugeDollService = game:GetService("ReplicatedStorage").Events.ClaimHugeDoll

local Button = Tab:CreateButton({
   Name = "Huge Doll [Huge]",
   Callback = function()
       ClaimHugeDollService:FireServer()
   end,
})


local Section = Tab:CreateSection("Miltiple Clicks Limited")


local Button = Tab:CreateButton({
   Name = "Buy Double Clicks [Not Working!]",
   Callback = function()
       game:GetService("ReplicatedStorage").Events.BoughtDoubleClicks:FireServer()
   end,
})


local Section = Tab:CreateSection("Give Gems and Clicks")


local AutoClaimEnabled = false
local ClaimLoop

local function stopClaimLoop()
    AutoClaimEnabled = false
    if ClaimLoop then
        task.cancel(ClaimLoop)
        ClaimLoop = nil
    end
end

local Toggle = Tab:CreateToggle({
    Name = "Auto Claim Gems [Not Working!]",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            AutoClaimEnabled = true
            ClaimLoop = task.spawn(function()
                while AutoClaimEnabled do
                    for i = 1, 10000 do
                        if not AutoClaimEnabled then return end
                        game:GetService("ReplicatedStorage").Events.Claim3:FireServer()
                        task.wait()  -- Kleine Pause zwischen den Aufrufen
                    end
                    task.wait(0.10)
                end
            end)
        else
            stopClaimLoop()
        end
    end
})


local AutoClaim1Enabled = false

local Toggle = Tab:CreateToggle({
    Name = "Auto Claim Clicks [Not Working!]",
    CurrentValue = false,
    Callback = function(Value)
        AutoClaim1Enabled = Value
        if AutoClaim1Enabled then
            spawn(function()
                while true do
                    if not AutoClaim1Enabled then break end
                    for i = 1, 10000 do
                        if not AutoClaim1Enabled then break end
                        game:GetService("ReplicatedStorage").Events.Claim1:FireServer()
                        task.wait()  -- Kurze Pause zwischen den Aufrufen
                    end
                    task.wait(0.10)
                end
            end)
        end
    end
})


local Section = Tab:CreateSection("Give Potions")


local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function CreateRewardButton(name, event)
    Tab:CreateButton({
        Name = "Give " .. name,
        Callback = function()
            event:FireServer()
        end,
    })
end

CreateRewardButton("Potions", ReplicatedStorage.Events.BoughtReward1)


local Section = Tab:CreateSection("Claim Gifts [Patched!]")


local ClaimEvents = {
    game:GetService("ReplicatedStorage").Events.Claim1,
    game:GetService("ReplicatedStorage").Events.Claim2,
    game:GetService("ReplicatedStorage").Events.Claim3,
    game:GetService("ReplicatedStorage").Events.Claim4,
    game:GetService("ReplicatedStorage").Events.Claim5,
    game:GetService("ReplicatedStorage").Events.Claim6,
    game:GetService("ReplicatedStorage").Events.Claim7,
    game:GetService("ReplicatedStorage").Events.Claim8,
    game:GetService("ReplicatedStorage").Events.Claim9
}

local AutoClaimEnabled = false

local Toggle = Tab:CreateToggle({
   Name = "Auto Claim (Exclusive Alien Egg, V.I.P and more!)",
   CurrentValue = false,
   Flag = "AutoClaimToggle",
   Callback = function(Value)
       AutoClaimEnabled = Value
       if AutoClaimEnabled then
           spawn(function()
               while AutoClaimEnabled do
                   for _, claimEvent in ipairs(ClaimEvents) do
                       claimEvent:FireServer()
                   end
                   wait(0.2)
               end
           end)
       end
   end,
})
