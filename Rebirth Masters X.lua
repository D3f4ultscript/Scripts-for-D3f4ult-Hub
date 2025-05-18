-- Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Table to store running tasks
local runningTasks = {}

-- Create the window
local Window = Rayfield:CreateWindow({
    Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " | [Beta🛠]",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by D3f4ult",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "Pet Game",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter your key",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = "Hello"
    }
})

-- Find the Rebirth remote event
local rebirthRemote = nil
local function findRebirthRemote()
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotes then
        rebirthRemote = remotes:FindFirstChild("Rebirth")
    end
    return rebirthRemote ~= nil
end

-- Try to find the remote event immediately
findRebirthRemote()

-- Create the Main tab
local MainTab = Window:CreateTab("Main", "home")

-- Add Rebirth toggle to Main tab
local autoRebirthRunning = false -- Dedicated variable just for auto rebirth

MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        autoRebirthRunning = Value -- Set the state directly
        
        if autoRebirthRunning then
            -- Start auto rebirth in a new thread
            task.spawn(function()
                while task.wait(0.1) do -- Wait first, then check condition
                    if not autoRebirthRunning then break end -- Check at the start of each loop
                    
                    -- Fire the Rebirth remote event
                    game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
                    
                    -- Check again after firing, to stop as soon as possible
                    if not autoRebirthRunning then break end
                end
            end)
        end
        -- When Value is false, the loop will exit on its next iteration due to autoRebirthRunning being false
    end,
})

-- Create Divider instead of section
local MainDivider = MainTab:CreateDivider()

-- Create label showing collect zones count
local collectZonesLabel = MainTab:CreateLabel("Collect Zones Found: 0")

-- Function to update collect zones count
local function updateCollectZonesCount()
    local collectAreas = {}
    local map = workspace:FindFirstChild("Map")
    if map then
        local collectAreasFolder = map:FindFirstChild("CollectAreas")
        if collectAreasFolder then
            collectAreas = collectAreasFolder:GetChildren()
        end
    end
    collectZonesLabel:Set("Collect Zones Found: " .. #collectAreas)
end

-- Initial update of collect zones count
updateCollectZonesCount()

-- Start automatic updates for collect zones count
task.spawn(function()
    while true do
        updateCollectZonesCount()
        task.wait(1) -- Update every second
    end
end)

-- Function to teleport all MeshParts to player
local function teleportAllMeshParts()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Get all parts in CollectAreas
    local collectAreas = {}
    local map = workspace:FindFirstChild("Map")
    if map then
        local collectAreasFolder = map:FindFirstChild("CollectAreas")
        if collectAreasFolder then
            collectAreas = collectAreasFolder:GetChildren()
        end
    end
    
    local allMeshParts = {}
    
    -- Collect all MeshParts first
    for _, area in ipairs(collectAreas) do
        local meshParts = area:GetDescendants()
        for _, part in ipairs(meshParts) do
            if part:IsA("MeshPart") then
                table.insert(allMeshParts, part)
            end
        end
    end
    
    -- Teleport 10 MeshParts at once
    for i = 1, #allMeshParts, 10 do
        if not runningTasks["CollectAllCoins"] then break end
        
        for j = i, math.min(i + 9, #allMeshParts) do
            local part = allMeshParts[j]
            -- Make part invisible and non-collidable
            part.Transparency = 1
            part.CanCollide = false
            -- Teleport part to player
            part.Position = humanoidRootPart.Position
        end
        task.wait(0.01) -- Reduced delay between batches from 0.05 to 0.01
    end
end

-- Create single toggle for all MeshParts
MainTab:CreateToggle({
    Name = "Collect All Coins",
    CurrentValue = false,
    Flag = "CollectAllCoins",
    Callback = function(Value)
        if Value then
            -- Start teleporting all MeshParts
            runningTasks["CollectAllCoins"] = true
            task.spawn(function()
                while runningTasks["CollectAllCoins"] do
                    teleportAllMeshParts()
                    task.wait(0.01) -- Reduced delay between teleportation cycles from 0.05 to 0.01
                end
            end)
        else
            -- Stop teleporting all MeshParts immediately
            runningTasks["CollectAllCoins"] = false
        end
    end,
})

-- Add another divider
local AnotherDivider = MainTab:CreateDivider()

-- Storage for original positions
local objectOriginalPosition = nil
local waterOriginalPosition = nil
local objectOriginalTransparency = nil
local waterOriginalTransparency = nil
local specialObjectsToggle = false

-- Add toggle for teleporting both objects
MainTab:CreateToggle({
    Name = "Tp Fish Area to you",
    CurrentValue = false,
    Flag = "KeepSpecialObjects",
    Callback = function(Value)
        specialObjectsToggle = Value
        
        -- Get the target objects
        local specialObject = workspace:GetChildren()[897]
        local water = workspace:FindFirstChild("Water")
        
        local objectsFound = true
        
        -- Check if objects exist
        if not specialObject then
            Rayfield:Notify({
                Title = "Warning",
                Content = "Special object not found!",
                Duration = 3,
                Image = "info"
            })
            objectsFound = false
        end
        
        if not water then
            Rayfield:Notify({
                Title = "Warning",
                Content = "Water not found!",
                Duration = 3,
                Image = "info"
            })
            objectsFound = false
        end
        
        if not objectsFound then
            return
        end
        
        -- Store original positions and transparencies if not stored yet
        if not objectOriginalPosition and specialObject and specialObject:IsA("BasePart") then
            objectOriginalPosition = specialObject.Position
            objectOriginalTransparency = specialObject.Transparency
        end
        
        if not waterOriginalPosition and water and water:IsA("BasePart") then
            waterOriginalPosition = water.Position
            waterOriginalTransparency = water.Transparency
        end
        
        if Value then
            -- Teleport objects to player continuously
            task.spawn(function()
                while specialObjectsToggle do
                    local player = game.Players.LocalPlayer
                    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = player.Character.HumanoidRootPart
                        
                        -- Keep special object near player and make invisible
                        if specialObject and specialObject:IsA("BasePart") then
                            specialObject.Position = humanoidRootPart.Position + Vector3.new(0, 0, 5) -- 5 studs in front
                            specialObject.Transparency = 1 -- Make invisible
                        end
                        
                        -- Keep water near player and make invisible
                        if water and water:IsA("BasePart") then
                            water.Position = humanoidRootPart.Position + Vector3.new(0, -2, 0) -- 2 studs below
                            water.Transparency = 1 -- Make invisible
                        end
                    end
                    task.wait(0.01) -- Update position frequently
                end
                
                -- Return objects to original positions and transparencies when toggle is off
                if specialObject and objectOriginalPosition and specialObject:IsA("BasePart") then
                    specialObject.Position = objectOriginalPosition
                    specialObject.Transparency = objectOriginalTransparency or 0
                end
                
                if water and waterOriginalPosition and water:IsA("BasePart") then
                    water.Position = waterOriginalPosition
                    water.Transparency = waterOriginalTransparency or 0
                end
                
                -- Notify user
                Rayfield:Notify({
                    Title = "Objects Returned",
                    Content = "Special objects returned to their original positions",
                    Duration = 3,
                    Image = "info"
                })
            end)
            
            -- Notify user
            Rayfield:Notify({
                Title = "Objects Following",
                Content = "Special objects will follow you (invisible)",
                Duration = 3,
                Image = "info"
            })
        end
    end,
})

-- Create the Eggs tab
local EggsTab = Window:CreateTab("Eggs", "egg")

-- Create the GUIs tab
local CollectAreasTab = Window:CreateTab("GUIs", "layout")

-- Add Gem Shop teleport button
local originalGemShopPosition = nil

CollectAreasTab:CreateButton({
    Name = "Open Gem Shop Gui",
    Callback = function()
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end
        
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local gemShop = workspace.Map.Rings.GemShop.MainPart
        if not gemShop then return end
        
        -- Store original position if not already stored
        if not originalGemShopPosition then
            originalGemShopPosition = gemShop.Position
        end
        
        -- Teleport to player
        gemShop.Position = humanoidRootPart.Position + Vector3.new(0, -5, 0)
        
        -- Create a notification
        Rayfield:Notify({
            Title = "Gem Shop Teleported",
            Content = "Gem Shop has been teleported to you!",
            Duration = 3,
            Image = "info"
        })
        
        -- Wait 5 seconds and teleport back
        task.spawn(function()
            task.wait(0.1) -- Wait just 0.1 seconds before teleporting back
            gemShop.Position = originalGemShopPosition
            
            -- Create a notification
            Rayfield:Notify({
                Title = "Gem Shop Returned",
                Content = "Gem Shop has been returned to its original position!",
                Duration = 3,
                Image = "info"
            })
        end)
    end,
})

-- Create label showing the number of eggs
local eggCountLabel = EggsTab:CreateLabel("Eggs Found: 0")

-- Store the previous player position
local previousPosition = nil

-- Button to teleport back to previous position
local teleportBackButton = EggsTab:CreateButton({
    Name = "Teleport Back",
    Callback = function()
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end
        
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart or not previousPosition then return end
        
        -- Teleport back to previous position
        humanoidRootPart.CFrame = CFrame.new(previousPosition)
    end,
})

-- Store created buttons for each Egg model
local createdButtons = {}

-- Function to create buttons for each Egg model
local function createEggButtons()
    -- Get all Eggs from workspace.Map.Eggs
    local eggsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Eggs")
    if not eggsFolder then 
        eggCountLabel:Set("Eggs Found: 0")
        return 
    end
    
    local eggs = eggsFolder:GetChildren()
    
    -- Update the count label
    eggCountLabel:Set("Eggs Found: " .. #eggs)
    
    -- Create a list of buttons to remove
    local buttonsToRemove = {}
    for eggName in pairs(createdButtons) do
        buttonsToRemove[eggName] = true
    end
    
    -- Keep buttons that still have an Egg
    for _, egg in ipairs(eggs) do
        buttonsToRemove[egg.Name] = nil
    end
    
    -- Remove buttons for Eggs that no longer exist
    for eggName in pairs(buttonsToRemove) do
        if createdButtons[eggName] then
            createdButtons[eggName]:Remove()
            createdButtons[eggName] = nil
        end
    end
    
    -- Create buttons for new Eggs
    for _, egg in ipairs(eggs) do
        if not createdButtons[egg.Name] then
            local button = EggsTab:CreateButton({
                Name = "Teleport to " .. egg.Name,
                Callback = function()
                    local player = game.Players.LocalPlayer
                    if not player or not player.Character then return end
                    
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then return end
                    
                    -- Store current position
                    previousPosition = humanoidRootPart.Position
                    
                    -- Find the egg's position
                    local position
                    
                    -- Try to get the model's CFrame position
                    if typeof(egg.GetModelCFrame) == "function" then
                        position = egg:GetModelCFrame().Position
                    else
                        -- Find any BasePart in the model
                        local basePart
                        for _, child in ipairs(egg:GetDescendants()) do
                            if child:IsA("BasePart") then
                                basePart = child
                                break
                            end
                        end
                        
                        if basePart then
                            position = basePart.Position
                        else
                            -- If no BasePart is found, use the model's PrimaryPart or first child
                            local primaryPart = egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart")
                            if primaryPart then
                                position = primaryPart.Position
                            else
                                -- Fallback to world origin if nothing else works
                                position = Vector3.new(0, 0, 0)
                                
                                -- Notify about the error
                                Rayfield:Notify({
                                    Title = "Error",
                                    Content = "Could not find a suitable position for " .. egg.Name,
                                    Duration = 3,
                                    Image = "info"
                                })
                                return
                            end
                        end
                    end
                    
                    -- Teleport to the egg position
                    humanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
                    
                    -- Notify the user
                    Rayfield:Notify({
                        Title = "Teleported",
                        Content = "Teleported to " .. egg.Name,
                        Duration = 3,
                        Image = "info"
                    })
                end,
            })
            
            createdButtons[egg.Name] = button
        end
    end
end

-- Initial creation of buttons
createEggButtons()

-- Update buttons every 2 seconds
task.spawn(function()
    while true do
        task.wait(2)  -- Update every 2 seconds
        createEggButtons()
    end
end)

-- Initialize the UI
Rayfield:LoadConfiguration()

-- Helper functions for Info Tab
local StartTime = os.time()

local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function GetExecutorInfo()
    if syn then
        return "Synapse X"
    elseif KRNL_LOADED then
        return "KRNL"
    elseif secure_load then
        return "Sentinel"
    elseif PROTOSMASHER_LOADED then
        return "ProtoSmasher"
    elseif is_sirhurt_closure then
        return "SirHurt"
    else
        return identifyexecutor() or "Unknown"
    end
end

local function GetExecutorVersion()
    if syn then
        return tostring(syn.version)
    else
        return "1.0"
    end
end

-- Info Tab
local InfoTab = Window:CreateTab("Info", "info")

-- Credits Section
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
task.spawn(function()
    while true do
        task.wait(1)
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

local Player = game.Players.LocalPlayer
local playerAge = Player.AccountAge
local ageText = playerAge == 1 and "1 day" or playerAge .. " days"

InfoTab:CreateParagraph({
    Title = "Player Information",
    Content = "Display Name: " .. Player.DisplayName .. 
             "\nUsername: " .. Player.Name .. 
             "\nAccount Age: " .. ageText
})

-- Show loading complete notification
task.spawn(function()
    task.wait(1) -- Wait a second to ensure everything is loaded
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    Rayfield:Notify({
        Title = gameName,
        Content = "GUI loaded 100% successfully!",
        Duration = 6.5,
        Image = "info"
    })
end)