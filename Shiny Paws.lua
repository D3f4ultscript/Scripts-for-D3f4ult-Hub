local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Helper Functions and Variables
local Player = game.Players.LocalPlayer
local StartTime = os.time()

local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%02d:%02d", minutes, secs)
    end
end

local function GetExecutorInfo()
    local success, result = pcall(function()
        return identifyexecutor()
    end)
    return success and result or "Unknown"
end

local function GetExecutorVersion()
    -- Try multiple methods to get the executor version
    local methods = {
        function() -- Method 1: Direct version function
            if type(version) == "function" then
                return "v" .. version()
            end
            return nil
        end,
        function() -- Method 2: Executor-specific variables
            if KRNL_LOADED and KRNL_VERSION then
                return KRNL_VERSION
            elseif syn and syn.version then
                return "v" .. syn.version()
            elseif SENTINEL_V2 then
                return "v2"
            elseif is_sirhurt_closure then
                return "v4"
            elseif pebc_execute then
                return "v2"
            elseif secure_load then
                return "v1.0"
            end
            return nil
        end
    }

    -- Try each method
    for _, method in ipairs(methods) do
        local success, result = pcall(method)
        if success and result then
            return result
        end
    end

    -- If no method worked, return Unknown
    return "Unknown"
end

local Window = Rayfield:CreateWindow({
   Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by D3f4ult",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ShinyPawsConfig",
      FileName = "ShinyPawsHub"
   }
})

-- Create the Main Tab
local MainTab = Window:CreateTab("Main", "diamond")

-- Create Orbs Section
local OrbsSection = MainTab:CreateSection("Orbs")

-- Orbs Auto-Collection Toggle
local OrbsConnection
MainTab:CreateToggle({
    Name = "Auto-Collect Orbs",
    CurrentValue = false,
    Flag = "AutoCollectOrbs",
    Callback = function(Value)
        if Value then
            -- Enable auto-collect
            OrbsConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local orbs = workspace:FindFirstChild("Orbs")
                if orbs then
                    for _, orb in pairs(orbs:GetChildren()) do
                        if orb and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                            orb.CFrame = Player.Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
            Rayfield:Notify({
                Title = "Auto-Collect Enabled",
                Content = "Now teleporting all orbs to you!",
                Duration = 3,
            })
        else
            -- Disable auto-collect
            if OrbsConnection then
                OrbsConnection:Disconnect()
                OrbsConnection = nil
            end
            Rayfield:Notify({
                Title = "Auto-Collect Disabled",
                Content = "No longer teleporting orbs.",
                Duration = 3,
            })
        end
    end,
})

-- Create GUIs Tab (was Event Tab)
local GUIsTab = Window:CreateTab("GUIs", "layout")

-- Rings Section
local RingsSection = GUIsTab:CreateSection("Rings")

-- Function to teleport all parts in a model to player and back
local function TeleportRingPartsTemporarily(model)
    -- Store original positions
    local originalPositions = {}
    local partsToTp = {}
    
    -- Check if player exists and has a character
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
        Rayfield:Notify({
            Title = "Error",
            Content = "Your character doesn't exist yet!",
            Duration = 2,
        })
        return
    end
    
    local humanoidRootPart = Player.Character.HumanoidRootPart
    
    -- Collect all parts and their original positions
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(partsToTp, part)
            originalPositions[part] = part.CFrame
        end
    end
    
    -- Teleport all parts to player
    for _, part in pairs(partsToTp) do
        part.CFrame = humanoidRootPart.CFrame
    end
    
    -- Schedule return to original positions after 0.1 seconds
    task.delay(0.1, function()
        for part, originalCFrame in pairs(originalPositions) do
            if part and part:IsA("BasePart") then
                part.CFrame = originalCFrame
            end
        end
    end)
    
    Rayfield:Notify({
        Title = "Ring Collected",
        Content = "Temporarily teleported " .. model.Name .. " to you!",
        Duration = 1,
    })
end

-- Create buttons for regular rings
local rings = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Rings")
if rings then
    -- First, create regular ring buttons
    for _, model in pairs(rings:GetChildren()) do
        if model:IsA("Model") then
            local name = model.Name
            if not (name:find("Chest") or name:find("Reward")) then
                GUIsTab:CreateButton({
                    Name = name,
                    Callback = function()
                        TeleportRingPartsTemporarily(model)
                    end,
                })
            end
        end
    end
    
    -- Create Rewards section with chest/reward buttons
    local RewardsSection = GUIsTab:CreateSection("Rewards & Chests")
    
    -- Then create reward buttons
    for _, model in pairs(rings:GetChildren()) do
        if model:IsA("Model") then
            local name = model.Name
            if name:find("Chest") or name:find("Reward") then
                GUIsTab:CreateButton({
                    Name = name,
                    Callback = function()
                        TeleportRingPartsTemporarily(model)
                    end,
                })
            end
        end
    end
else
    GUIsTab:CreateLabel("No Rings folder found in workspace.Map")
end

-- Create Misc Tab (insert after GUIs Tab)
local MiscTab = Window:CreateTab("Misc", "settings")

-- Notifications and more Section
local NotificationsSection = MiscTab:CreateSection("Notifications and more")

-- Anti-Particles Button
MiscTab:CreateButton({
    Name = "Remove Particles & Popups",
    Callback = function()
        -- Remove all parts named "Particles"
        for _, particle in pairs(workspace:GetDescendants()) do
            if particle:IsA("BasePart") and (particle.Name == "Particles" or particle.Name == "Confetti") then
                particle:Destroy()
            end
        end
        
        -- Remove popups
        local popups = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("GameUI")
        if popups and popups:FindFirstChild("Popups") then
            popups.Popups:ClearAllChildren()
        end
        
        Rayfield:Notify({
            Title = "Cleanup Complete",
            Content = "All Particles, Confetti, and Popups have been removed!",
            Duration = 3,
        })
    end,
})

-- Rejoin Section
local RejoinSection = MiscTab:CreateSection("Server Options")

-- Same Server Rejoin
MiscTab:CreateButton({
    Name = "Rejoin Same Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local p = game:GetService("Players").LocalPlayer
        
        Rayfield:Notify({
            Title = "Rejoining...",
            Content = "Attempting to rejoin the same server!",
            Duration = 2,
        })
        
        ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
    end,
})

-- Different Server Rejoin
MiscTab:CreateButton({
    Name = "Join Different Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local p = game:GetService("Players").LocalPlayer
        
        Rayfield:Notify({
            Title = "Server Hopping...",
            Content = "Finding a different server to join!",
            Duration = 2,
        })
        
        local x = {}
        for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                x[#x + 1] = v.id
            end
        end
        if #x > 0 then
            ts:TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Could not find a different server!",
                Duration = 3,
            })
        end
    end,
})

-- Create Info Tab
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

local playerAge = Player.AccountAge
local ageText = playerAge == 1 and "1 day" or playerAge .. " days"

InfoTab:CreateParagraph({
    Title = "Player Information",
    Content = "Display Name: " .. Player.DisplayName .. 
             "\nUsername: " .. Player.Name .. 
             "\nAccount Age: " .. ageText
})

Rayfield:LoadConfiguration() 