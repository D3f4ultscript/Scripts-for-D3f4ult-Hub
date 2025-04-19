local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Get the game name
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

-- Record start time for session tracking
local StartTime = os.time()

-- Get player reference
local Player = game:GetService("Players").LocalPlayer

-- Function to format time as HH:MM:SS
local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Function to get executor information (with fallbacks for various executors)
local function GetExecutorInfo()
    local executorInfo = identifyexecutor or getexecutorname or function() return "Unknown" end
    return executorInfo() or "Unknown"
end

-- Function to get executor version (with fallbacks)
local function GetExecutorVersion()
    local executorVersion = getexecutorversion or function() return "Unknown" end
    return tostring(executorVersion()) or "Unknown"
end

local Window = Rayfield:CreateWindow({
   Name = gameName,
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by D3f4ult",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AutoClickerConfig",
      FileName = "AutoClickerConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", "diamond") -- Using diamond Lucide icon

-- Clicks Section
local ClicksSection = MainTab:CreateSection("Clicks")

local AutoClickerEnabled = false
local AutoClickerConnection = nil

-- Reference to the Click event
local ClickEvent = game:GetService("ReplicatedStorage").Events.Click

local AutoClickerToggle = MainTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "AutoClickerToggle",
   Callback = function(Value)
      AutoClickerEnabled = Value
      
      if AutoClickerEnabled then
         -- Start the auto clicker loop with 0.01 second delay
         spawn(function()
            while AutoClickerEnabled do
               -- Fire the Click event
               ClickEvent:FireServer()
               wait(0.01) -- 0.01 second delay
            end
         end)
      end
   end,
})

-- Rebirths Section
local RebirthsSection = MainTab:CreateSection("Rebirths")

local AutoRebirthEnabled = false
local AutoRebirthConnection = nil
local RebirthAmount = 1 -- Default rebirth amount

-- Reference to the Rebirth event
local RebirthEvent = game:GetService("ReplicatedStorage").Events.Rebirth

local AutoRebirthToggle = MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirthToggle",
   Callback = function(Value)
      AutoRebirthEnabled = Value
      
      if AutoRebirthEnabled then
         -- Start the auto rebirth loop with 0.01 second delay
         spawn(function()
            while AutoRebirthEnabled do
               -- Fire the Rebirth event
               RebirthEvent:FireServer(RebirthAmount)
               wait(0.01) -- 0.01 second delay
            end
         end)
      end
   end,
})

local RebirthAmountInput = MainTab:CreateInput({
   Name = "Rebirth Amount",
   PlaceholderText = "Enter rebirth amount",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      if tonumber(Text) then
         RebirthAmount = tonumber(Text)
         Rayfield:Notify({
            Title = "Rebirth Amount Updated",
            Content = "Set to " .. RebirthAmount,
            Duration = 3,
         })
      else
         Rayfield:Notify({
            Title = "Invalid Input",
            Content = "Please enter a valid number",
            Duration = 3,
         })
      end
   end,
})

-- Create Hatch Tab
local HatchTab = Window:CreateTab("Hatch", "egg") -- Using egg Lucide icon

-- Egg hatch mode (Single by default)
local EggHatchMode = "Single"

-- Settings Section
local SettingsSection = HatchTab:CreateSection("Settings")

-- Textbox for hatch mode
HatchTab:CreateInput({
   Name = "Hatch Mode",
   PlaceholderText = "Enter hatch mode (default: Single)",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      if Text ~= "" then
         EggHatchMode = Text
         Rayfield:Notify({
            Title = "Hatch Mode Updated",
            Content = "Set to " .. EggHatchMode,
            Duration = 3,
         })
      else
         EggHatchMode = "Single"
         Rayfield:Notify({
            Title = "Hatch Mode Reset",
            Content = "Reset to Single (default)",
            Duration = 3,
         })
      end
   end,
})

-- Label listing available options
HatchTab:CreateLabel("Available Modes: Single, Triple, Quadruple")
HatchTab:CreateLabel("The mode you enter will replace 'Single' in the hatching command")

-- Eggs Section
local EggsSection = HatchTab:CreateSection("Eggs")

-- Store active hatching tasks for each egg type
local AutoHatchTasks = {}

-- Function to create toggle for each egg type
local function CreateEggToggle(eggName)
   local toggleFlag = "AutoHatch_" .. eggName
   
   HatchTab:CreateToggle({
      Name = "Auto Hatch " .. eggName .. " Egg",
      CurrentValue = false,
      Flag = toggleFlag,
      Callback = function(Value)
         -- Stop existing task if it exists
         if AutoHatchTasks[eggName] then
            AutoHatchTasks[eggName] = false
         end
         
         -- Create new task if enabled
         if Value then
            AutoHatchTasks[eggName] = true
            
            -- Start the auto hatch loop with 0.01 second delay
            spawn(function()
               while AutoHatchTasks[eggName] do
                  -- Create arguments for hatching
                  local args = {
                     [1] = eggName,
                     [2] = EggHatchMode -- Use the selected hatch mode
                  }
                  
                  -- Invoke the Hatch function
                  game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
                  
                  wait(0.01) -- 0.01 second delay
               end
            end)
         end
      end,
   })
end

-- Create toggles for all egg types
if workspace:FindFirstChild("Scripted") and workspace.Scripted:FindFirstChild("EggHolders") then
   for _, eggHolder in pairs(workspace.Scripted.EggHolders:GetChildren()) do
      if eggHolder:IsA("Model") then
         CreateEggToggle(eggHolder.Name)
      end
   end
else
   -- Fallback for if the egg path is not found yet (game still loading)
   CreateEggToggle("Basic") -- Default egg as fallback
   
   -- Try to load eggs when the game is fully loaded
   spawn(function()
      wait(5) -- Wait 5 seconds for game to load
      if workspace:FindFirstChild("Scripted") and workspace.Scripted:FindFirstChild("EggHolders") then
         -- Clear previous toggles
         for _, item in pairs(HatchTab:GetChildren()) do
            if item:IsA("Frame") and item.Name ~= "EggsSection" and item.Name ~= "SettingsSection" then
               item:Destroy()
            end
         end
         
         -- Create new toggles
         for _, eggHolder in pairs(workspace.Scripted.EggHolders:GetChildren()) do
            if eggHolder:IsA("Model") then
               CreateEggToggle(eggHolder.Name)
            end
         end
      end
   end)
end

-- Create GUIs Tab
local GuisTab = Window:CreateTab("GUIs", "layout") -- Using layout Lucide icon

-- Für jeden Part namens TouchListener im Workspace einen Button erstellen
local function findAllTouchListeners()
   local found = {}
   local function scan(obj)
      for _, child in ipairs(obj:GetChildren()) do
         if child:IsA("BasePart") and child.Name == "TouchListener" then
            table.insert(found, child)
         end
         scan(child)
      end
   end
   scan(workspace)
   return found
end

local touchListeners = findAllTouchListeners()

if #touchListeners == 0 then
   GuisTab:CreateLabel("Keine TouchListener im Workspace gefunden.")
else
   for _, part in ipairs(touchListeners) do
      local model = part.Parent
      local buttonName = part.Name
      if model and model:IsA("Model") then
         buttonName = model.Name
      end
      GuisTab:CreateButton({
         Name = buttonName,
         Callback = function()
            local originalCFrame = part.CFrame
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
               part.CFrame = root.CFrame
               task.wait(0.15)
               part.CFrame = originalCFrame
               Rayfield:Notify({
                  Title = "TouchListener bewegt",
                  Content = buttonName .. " wurde zu dir und zurück teleportiert!",
                  Duration = 2,
               })
            else
               Rayfield:Notify({
                  Title = "Fehler",
                  Content = "Dein Charakter ist nicht geladen!",
                  Duration = 2,
               })
            end
         end,
      })
   end
end

-- Info Tab
local InfoTab = Window:CreateTab("Info", "info") -- Using info Lucide icon

-- Info Tab
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

local playerAge = Player.AccountAge
local ageText = playerAge == 1 and "1 day" or playerAge .. " days"

InfoTab:CreateParagraph({
    Title = "Player Information",
    Content = "Display Name: " .. Player.DisplayName .. 
             "\nUsername: " .. Player.Name .. 
             "\nAccount Age: " .. ageText
})

-- Keep the script running
while true do
   wait(1)
end 