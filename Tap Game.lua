local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading...",
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


local Tab = Window:CreateTab("Farm", "mouse-pointer-click")
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
           rebirthAmount = 1  -- Set to default value for invalid input
       end
   end,
})


local Tab = Window:CreateTab("Auto Hatch", "egg")
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

-- Warnhinweis Paragraph hinzufügen
Tab:CreateParagraph({
    Title = "⚠️ WARNING",
    Content = "Do not open Robux eggs or eggs that no longer exist! This could cause problems!",
    TitleColor = Color3.fromRGB(255, 0, 0),
    ContentColor = Color3.fromRGB(255, 0, 0)
})


local Tab = Window:CreateTab("Events", "calendar")
local Section = Tab:CreateSection("Events")

Tab:CreateParagraph({
    Title = "No Active Events",
    Content = "There are currently no active events available. Check back later for new events!",
    TitleColor = Color3.fromRGB(255, 255, 255),
    ContentColor = Color3.fromRGB(200, 200, 200)
})


local Tab = Window:CreateTab("Open GUIS", "layout-grid")
local Section = Tab:CreateSection("Touch Parts")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Function to create buttons for all TouchParts
local function createTouchPartButtons()
    local touchParts = workspace.Scripted.TouchParts:GetChildren()
    local createdButtons = {} -- Table to track created buttons
    
    for _, touchPart in ipairs(touchParts) do
        if touchPart:FindFirstChild("TouchPart") and not createdButtons[touchPart.Name] then
            createdButtons[touchPart.Name] = true -- Mark this TouchPart as processed
            
            Tab:CreateButton({
                Name = "Open " .. touchPart.Name .. " GUI",
                Callback = function()
                    local touchPartInstance = touchPart.TouchPart
                    if touchPartInstance then
                        local originalPosition = touchPartInstance.Position
                        touchPartInstance.CFrame = humanoidRootPart.CFrame
                        task.wait(0.1)
                        touchPartInstance.Position = originalPosition
                    else
                        print(touchPart.Name .. " TouchPart not found!")
                    end
                end,
            })
        end
    end
end

-- Create buttons for all TouchParts
createTouchPartButtons()


local Tab = Window:CreateTab("Teleport", "map-pin")
local Section = Tab:CreateSection("Teleport")


local Button = Tab:CreateButton({
   Name = "Teleport to Leaderboards",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local targetPart = workspace.Scripted.Islands.Spawn.Map.Alters:GetChildren()[10]:GetChildren()[2]
      
      if targetPart then
         humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0) -- Teleports slightly above the target
      else
         print("Target location not found")
      end
   end,
})

local Button = Tab:CreateButton({
   Name = "Teleport to St. Patricks Event",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
      
      local targetPart = workspace.Scripted.Islands["St. Patricks"].Paths:GetChildren()[69].Cream
      
      if targetPart then
         humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0) -- Teleports slightly above the target
      else
         print("St. Patricks Event target location not found")
      end
   end,
})


local Tab = Window:CreateTab("Misc", "settings")
local Section = Tab:CreateSection("Auto Features")


local Toggle = Tab:CreateToggle({
   Name = "Auto Increase Mastery",
   CurrentValue = false,
   Flag = "AutoMasteryToggle",
   Callback = function(Value)
      if Value then
         -- Start the loop
         _G.AutoMasteryLoop = true
         spawn(function()
            while _G.AutoMasteryLoop do
               game:GetService("ReplicatedStorage").Functions.IncreaseMastery:InvokeServer()
               wait(1) -- Wait 1 second
            end
         end)
      else
         -- Stop the loop
         _G.AutoMasteryLoop = false
      end
   end,
})


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

local isRanking = false
local rankTask

local Toggle = Tab:CreateToggle({
   Name = "Auto Rank Up",
   CurrentValue = false,
   Flag = "AutoRankToggle",
   Callback = function(Value)
      isRanking = Value
      if isRanking then
         rankTask = task.spawn(function()
            while isRanking do
               game:GetService("ReplicatedStorage").Events.RankUp:FireServer()
               task.wait(1)
            end
         end)
      else
         if rankTask then
            task.cancel(rankTask)
         end
      end
   end,
})

local Section = Tab:CreateSection("Chests")

-- Button zum Auslösen aller Chest TouchInterests
Tab:CreateButton({
    Name = "Open All Chests",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Durchsuche alle Modelle im Workspace
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name:find("Chest") then
                local touchPart = model:FindFirstChild("TouchPart")
                if touchPart and touchPart:FindFirstChild("TouchInterest") then
                    local touchInterest = touchPart.TouchInterest
                    -- Simuliere Touch
                    firetouchinterest(humanoidRootPart, touchPart, 0)
                    task.wait(0.1)
                    firetouchinterest(humanoidRootPart, touchPart, 1)
                end
            end
        end
    end,
})

-- Funktion zum Formatieren der Zeit
local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Funktion zum Abrufen der Executor-Informationen
local function GetExecutorInfo()
    if identifyexecutor then
        return identifyexecutor()
    end
    return "Unknown"
end

-- Funktion zum Abrufen der Executor-Version
local function GetExecutorVersion()
    if getexecutorname then
        return getexecutorname()
    end
    return "Unknown"
end

-- Startzeit für die Session
local StartTime = os.time()

-- Info Tab
local InfoTab = Window:CreateTab("Info", "info")
local InfoSection = InfoTab:CreateSection("Credits")

-- Credits
InfoTab:CreateParagraph({
    Title = "Credits",
    Content = "Made by D3f4ult"
})

-- Discord Button
InfoTab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/2ynN9zcVFk")
        Rayfield:Notify({
            Title = "Discord Invite",
            Content = "Invite link copied to clipboard!",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Session Time Section
local SessionTimeSection = InfoTab:CreateSection("Session Time")

-- Session Time
local SessionTimeText = InfoTab:CreateLabel("Session Time: 0 seconds")

-- Update session time loop
spawn(function()
    while true do
        wait(1)
        local elapsedTime = os.time() - StartTime
        SessionTimeText:Set("Session Time: " .. FormatTime(elapsedTime))
        
        -- Break loop if GUI is destroyed
        if not SessionTimeText then
            break
        end
    end
end)

-- Executor Info
local ExecutorSection = InfoTab:CreateSection("Executor Information")

InfoTab:CreateParagraph({
    Title = "Executor Information",
    Content = "Executor: " .. GetExecutorInfo() .. "\nVersion: " .. GetExecutorVersion()
})

-- Player Info
local PlayerSection = InfoTab:CreateSection("Player Information")

local player = game.Players.LocalPlayer
local playerAge = player.AccountAge
local ageText = playerAge == 1 and "1 day" or playerAge .. " days"

InfoTab:CreateParagraph({
    Title = "Player Information",
    Content = "Display Name: " .. player.DisplayName .. 
             "\nUsername: " .. player.Name .. 
             "\nAccount Age: " .. ageText
})