local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
   Name = "Auto Clicker",
   LoadingTitle = "Auto Clicker Script",
   LoadingSubtitle = "by Claude",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AutoClickerConfig",
      FileName = "AutoClicker"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   }
})

-- Create a tab in the window
local Tab = Window:CreateTab("Main", "hammer")

-- Variable to keep track of the clicking loop
local ClickingEnabled = false
local ClickingConnection = nil

-- Create a toggle in the tab
local Toggle = Tab:CreateToggle({
   Name = "Auto Click",
   CurrentValue = false,
   Flag = "AutoClickToggle",
   Callback = function(Value)
      ClickingEnabled = Value
      
      if ClickingEnabled then
         -- Start the clicking loop
         ClickingConnection = task.spawn(function()
            while ClickingEnabled and task.wait(0.001) do -- Run at 0.01 second intervals
               game:GetService("ReplicatedStorage").Events.Click:FireServer()
            end
         end)
      else
         -- Stop the clicking loop
         if ClickingConnection then
            task.cancel(ClickingConnection)
            ClickingConnection = nil
         end
      end
   end,
}) 

-- Variable for Rebirth value - this will be replaced by textbox input
local RebirthValue = 1

-- Variables for Rebirth loop
local RebirthEnabled = false
local RebirthThread = nil

-- Textbox for Rebirth value - PLACE THIS BEFORE THE TOGGLE
local RebirthInput = Tab:CreateInput({
   Name = "Rebirth Value",
   PlaceholderText = "Enter rebirth value (default: 1)",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      -- Convert text to number
      local number = tonumber(Text)
      if number then
         RebirthValue = number
         
         -- If rebirth is running, refresh it with the new value
         if RebirthEnabled and RebirthThread then
            task.cancel(RebirthThread)
            
            RebirthThread = task.spawn(function()
               while RebirthEnabled and task.wait(0.001) do
                  local args = {
                     [1] = RebirthValue  -- Using updated value
                  }
                  
                  game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
               end
            end)
         end
      end
   end,
})

-- Create a toggle for Auto Rebirth
local RebirthToggle = Tab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirthToggle",
   Callback = function(Value)
      RebirthEnabled = Value
      
      if RebirthEnabled then
         -- Start the rebirth loop
         RebirthThread = task.spawn(function()
            while RebirthEnabled and task.wait(0.001) do  -- Run at 0.01 second intervals
               -- Create args table inside the loop to ensure it always has the latest value
               local args = {
                  [1] = RebirthValue  -- This is the value from the textbox
               }
               
               -- Fire the rebirth event
               game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
            end
         end)
      else
         -- Stop the rebirth loop
         if RebirthThread then
            task.cancel(RebirthThread)
            RebirthThread = nil
         end
      end
   end,
}) 

-- Variables for mastery loop
local MasteryEnabled = false
local MasteryThread = nil

-- Create a toggle for Auto Mastery
local MasteryToggle = Tab:CreateToggle({
   Name = "Auto Increase Mastery",
   CurrentValue = false,
   Flag = "AutoMasteryToggle",
   Callback = function(Value)
      MasteryEnabled = Value
      
      if MasteryEnabled then
         -- Start the mastery loop
         MasteryThread = task.spawn(function()
            while MasteryEnabled and task.wait(0.001) do  -- Run at 0.01 second intervals
               -- Call the mastery function
               game:GetService("ReplicatedStorage").Functions.IncreaseMastery:InvokeServer()
            end
         end)
      else
         -- Stop the mastery loop
         if MasteryThread then
            task.cancel(MasteryThread)
            MasteryThread = nil
         end
      end
   end,
})

-- Variables for daily rewards loop
local DailyRewardsEnabled = false
local DailyRewardsThread = nil

-- Create a toggle for Auto Daily Rewards
local DailyRewardsToggle = Tab:CreateToggle({
   Name = "Auto Collect Daily Rewards",
   CurrentValue = false,
   Flag = "AutoDailyRewardsToggle",
   Callback = function(Value)
      DailyRewardsEnabled = Value
      
      if DailyRewardsEnabled then
         -- Start the daily rewards loop
         DailyRewardsThread = task.spawn(function()
            while DailyRewardsEnabled do
               -- Try to collect all daily rewards from 1 to 12
               for i = 1, 12 do
                  local args = {
                     [1] = "Reward" .. i
                  }
                  
                  -- Fire the daily reward event
                  game:GetService("ReplicatedStorage").Events.CollectDailyReward:FireServer(unpack(args))
                  
                  -- Wait 0.1 seconds between reward attempts
                  task.wait(0.1)
               end
               
               -- After trying all rewards, wait a bit longer before the next attempt
               task.wait(1)
            end
         end)
      else
         -- Stop the daily rewards loop
         if DailyRewardsThread then
            task.cancel(DailyRewardsThread)
            DailyRewardsThread = nil
         end
      end
   end,
})

-- Create a new tab for egg hatching
local EggTab = Window:CreateTab("Eggs", "egg")

-- Variable for hatching loop
local HatchingEnabled = false
local HatchingThread = nil

-- Create a toggle for Auto Hatch Release Egg
local HatchToggle = EggTab:CreateToggle({
   Name = "Auto Hatch Release Egg (Triple)",
   CurrentValue = false,
   Flag = "AutoHatchToggle",
   Callback = function(Value)
      HatchingEnabled = Value
      
      if HatchingEnabled then
         -- Start the hatching loop
         HatchingThread = task.spawn(function()
            while HatchingEnabled do
               -- Exact code as provided
               local args = {
                  [1] = "Release Egg",
                  [2] = "Triple"
               }
               
               game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
               
               -- Wait as specified
               task.wait(0.0001)
            end
         end)
      else
         -- Stop the hatching loop
         if HatchingThread then
            task.cancel(HatchingThread)
            HatchingThread = nil
         end
      end
   end,
})

-- Variables for 1K Egg hatching
local Hatch1KEggEnabled = false
local Hatch1KEggThread = nil

-- Create a toggle for Auto Hatch 1K Egg
local Hatch1KEggToggle = EggTab:CreateToggle({
   Name = "Auto Hatch 1K Egg (Triple)",
   CurrentValue = false,
   Flag = "AutoHatch1KEggToggle",
   Callback = function(Value)
      Hatch1KEggEnabled = Value
      
      if Hatch1KEggEnabled then
         -- Start the hatching loop
         Hatch1KEggThread = task.spawn(function()
            while Hatch1KEggEnabled do
               -- Exact code as provided
               local args = {
                  [1] = "1K Egg",
                  [2] = "Triple"
               }
               
               game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
               
               -- Wait as specified
               task.wait(0.0001)
            end
         end)
      else
         -- Stop the hatching loop
         if Hatch1KEggThread then
            task.cancel(Hatch1KEggThread)
            Hatch1KEggThread = nil
         end
      end
   end,
})

-- Variables for Atlantis Egg hatching
local HatchAtlantisEggEnabled = false
local HatchAtlantisEggThread = nil

-- Create a toggle for Auto Hatch Atlantis Egg
local HatchAtlantisEggToggle = EggTab:CreateToggle({
   Name = "Auto Hatch Atlantis Egg (Triple)",
   CurrentValue = false,
   Flag = "AutoHatchAtlantisEggToggle",
   Callback = function(Value)
      HatchAtlantisEggEnabled = Value
      
      if HatchAtlantisEggEnabled then
         -- Start the hatching loop
         HatchAtlantisEggThread = task.spawn(function()
            while HatchAtlantisEggEnabled do
               -- Exact code as provided
               local args = {
                  [1] = "Atlantis Egg",
                  [2] = "Triple"
               }
               
               game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
               
               -- Wait as specified
               task.wait(0.0001)
            end
         end)
      else
         -- Stop the hatching loop
         if HatchAtlantisEggThread then
            task.cancel(HatchAtlantisEggThread)
            HatchAtlantisEggThread = nil
         end
      end
   end,
})

-- Create a new tab for TouchParts
local TouchPartsTab = Window:CreateTab("TouchParts", "hand")

-- Function to find all TouchParts in the workspace
local function FindTouchParts()
    local touchParts = {}
    local chestParts = {}
    
    -- Recursively search the workspace for parts named "TouchPart"
    local function SearchForTouchParts(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("BasePart") and child.Name == "TouchPart" then
                -- Check if the parent name contains "Chest"
                if child.Parent and string.find(child.Parent.Name:lower(), "chest") then
                    table.insert(chestParts, child)
                else
                    table.insert(touchParts, child)
                end
            end
            
            if #child:GetChildren() > 0 then
                SearchForTouchParts(child)
            end
        end
    end
    
    SearchForTouchParts(workspace)
    return touchParts, chestParts
end

-- Function to teleport a part to the player and back
local function TeleportPartToPlayerAndBack(part)
    -- Store the original position and CFrame
    local originalCFrame = part.CFrame
    local originalParent = part.Parent
    
    -- Get the player's character
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Teleport the part to the player
    part.CFrame = humanoidRootPart.CFrame
    
    -- Create a thread to wait and then teleport back
    task.spawn(function()
        task.wait(1) -- Wait for 1 second
        
        -- Teleport the part back to its original position
        part.CFrame = originalCFrame
    end)
end

-- Find all TouchParts and ChestParts
local touchParts, chestParts = FindTouchParts()

-- Add section for regular TouchParts
TouchPartsTab:CreateSection("Touch Parts")

if #touchParts > 0 then
    for _, part in ipairs(touchParts) do
        local parentName = part.Parent and part.Parent.Name or "Unknown"
        
        -- Skip buttons named "Workspace"
        if parentName ~= "Workspace" then
            -- Create a button for this TouchPart
            local Button = TouchPartsTab:CreateButton({
                Name = parentName,
                Callback = function()
                    TeleportPartToPlayerAndBack(part)
                end,
            })
        end
    end
else
    -- If no TouchParts were found, add a label indicating this
    TouchPartsTab:CreateLabel("No regular TouchParts found")
end

-- Add section for Chest TouchParts
TouchPartsTab:CreateSection("Claim Chests")

if #chestParts > 0 then
    for _, part in ipairs(chestParts) do
        local parentName = part.Parent and part.Parent.Name or "Unknown"
        
        -- Skip buttons named "Workspace"
        if parentName ~= "Workspace" then
            -- Create a button for this Chest TouchPart
            local Button = TouchPartsTab:CreateButton({
                Name = parentName,
                Callback = function()
                    TeleportPartToPlayerAndBack(part)
                end,
            })
        end
    end
else
    -- If no Chest TouchParts were found, add a label indicating this
    TouchPartsTab:CreateLabel("No chest TouchParts found")
end

-- Create a new tab for Teleports
local TeleportTab = Window:CreateTab("Teleport", "navigation")

-- Function to find all SpawnPoint parts in the workspace
local function FindSpawnPoints()
    local spawnPoints = {}
    
    -- Recursively search the workspace for parts named "SpawnPoint"
    local function SearchForSpawnPoints(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("BasePart") and child.Name == "SpawnPoint" then
                table.insert(spawnPoints, child)
            end
            
            if #child:GetChildren() > 0 then
                SearchForSpawnPoints(child)
            end
        end
    end
    
    SearchForSpawnPoints(workspace)
    return spawnPoints
end

-- Function to teleport the player to a part
local function TeleportPlayerToPart(part)
    -- Get the player's character
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Teleport the player to the part
    humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0) -- Teleport slightly above the part
end

-- Find all SpawnPoints
local spawnPoints = FindSpawnPoints()

if #spawnPoints > 0 then
    for _, part in ipairs(spawnPoints) do
        local parentName = part.Parent and part.Parent.Name or "Unknown"
        
        -- Skip buttons named "Workspace"
        if parentName ~= "Workspace" then
            -- Create a button for this SpawnPoint
            local Button = TeleportTab:CreateButton({
                Name = parentName,
                Callback = function()
                    TeleportPlayerToPart(part)
                end,
            })
        end
    end
else
    -- If no SpawnPoints were found, add a label indicating this
    TeleportTab:CreateLabel("No teleport locations found")
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