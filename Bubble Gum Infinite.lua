-- Rayfield Library for Roblox
-- A customized UI library with Main and Info tabs

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Helper Functions
local Player = game.Players.LocalPlayer
local StartTime = os.time()

local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%d hours, %d minutes, %d seconds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%d minutes, %d seconds", minutes, secs)
    else
        return string.format("%d seconds", secs)
    end
end

local function GetExecutorInfo()
    local success, result = pcall(function()
        return identifyexecutor() or "Unknown"
    end)
    
    return success and result or "Unknown"
end

local function GetExecutorVersion()
    local success, result = pcall(function()
        return getexecutorversion and getexecutorversion() or "Unknown"
    end)
    
    return success and result or "Unknown"
end

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by D3f4ult",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "BubbleGumInfinite",
        FileName = "Configuration"
    },
    KeySystem = false
})

-- Function to bring an activation to the player and back
local function bringActivationToPlayer(activationPath, showNotification)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Find the activation
    local activation = activationPath
    if typeof(activationPath) == "string" then
        activation = workspace.Activations:FindFirstChild(activationPath)
    end
    
    if not activation then
        return
    end
    
    -- Find a reference part to teleport (prefer Root)
    local teleportTarget
    if activation:FindFirstChild("Root") then
        teleportTarget = activation.Root
    else
        for _, part in pairs(activation:GetDescendants()) do
            if part:IsA("BasePart") then
                teleportTarget = part
                break
            end
        end
    end
    
    if not teleportTarget then
        return
    end
    
    -- Store original properties
    local originalPosition = teleportTarget.CFrame
    local originalTransparency = {}
    local touchParts = {}
    
    -- Make all parts of the activation invisible and collect parts with TouchTransmitters
    for _, part in pairs(activation:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Store original transparency
            originalTransparency[part] = part.Transparency
            
            -- Make part invisible
            part.Transparency = 1
        elseif part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or part:IsA("Smoke") or part:IsA("Fire") or part:IsA("Sparkles") then
            -- Disable visual effects
            part.Enabled = false
        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
            -- Hide GUI elements
            part.Enabled = false
        end
        
        -- Track parts with TouchTransmitters
        if part:IsA("BasePart") and part:FindFirstChildOfClass("TouchTransmitter") then
            table.insert(touchParts, part)
        end
    end
    
    -- Bring the activation to the player
    teleportTarget.CFrame = humanoidRootPart.CFrame
    
    -- Move slightly in different directions to trigger TouchInterest
    for i = 1, 8 do
        -- Small circular movement around the player to trigger TouchInterest
        local angle = (i / 8) * math.pi * 2
        local offset = CFrame.new(math.cos(angle) * 2, 0, math.sin(angle) * 2)
        teleportTarget.CFrame = humanoidRootPart.CFrame * offset
        
        -- Also move any TouchTransmitter parts to ensure they make contact
        for _, part in ipairs(touchParts) do
            part.CFrame = humanoidRootPart.CFrame * offset
        end
        
        task.wait(0.05)
    end
    
    -- Wait a bit longer at the player
    task.wait(0.2)
    
    -- Return the activation to its original position
    teleportTarget.CFrame = originalPosition
    
    -- Restore original transparency and re-enable visual effects
    for part, transparency in pairs(originalTransparency) do
        part.Transparency = transparency
    end
    
    for _, part in pairs(activation:GetDescendants()) do
        if part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or part:IsA("Smoke") or part:IsA("Fire") or part:IsA("Sparkles") then
            part.Enabled = true
        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
            part.Enabled = true
        end
    end
end

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458) -- You can change the icon ID

-- Auto Bubble Section
local AutoBubbleSection = MainTab:CreateSection("Auto Bubble")

-- Free Label
MainTab:CreateLabel("Auto Bubble is Free")

-- Sell Section
local SellSection = MainTab:CreateSection("Auto Sell")

-- Auto Sell Variables
local autoSellEnabled = false
local autoSellLoop = nil
local twighlightSellOriginalPosition = nil
local currentTwighlightSell = nil

-- Auto Sell Toggle
MainTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "AutoSell", 
    Callback = function(Value)
        autoSellEnabled = Value
        
        if autoSellEnabled then
            -- Start auto sell loop
            if autoSellLoop then
                autoSellLoop:Disconnect()
            end
            
            -- Find the TwighlightSell
            local twighlightSell = workspace.Activations:FindFirstChild("TwighlightSell")
            if not twighlightSell then
                return
            end
            
            -- Find a reference part to teleport (prefer Root)
            local teleportTarget
            if twighlightSell:FindFirstChild("Root") then
                teleportTarget = twighlightSell.Root
            else
                for _, part in pairs(twighlightSell:GetDescendants()) do
                    if part:IsA("BasePart") then
                        teleportTarget = part
                        break
                    end
                end
            end
            
            if not teleportTarget then
                return
            end
            
            -- Store original position for later restoration
            currentTwighlightSell = twighlightSell
            twighlightSellOriginalPosition = teleportTarget.CFrame
            
            -- Hide all parts and disable effects
            local touchParts = {}
            for _, part in pairs(twighlightSell:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    
                    if part:FindFirstChildOfClass("TouchTransmitter") then
                        table.insert(touchParts, part)
                    end
                elseif part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or 
                       part:IsA("Smoke") or part:IsA("Fire") or part:IsA("Sparkles") then
                    part.Enabled = false
                elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
                    part.Enabled = false
                end
            end
            
            autoSellLoop = game:GetService("RunService").Heartbeat:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                
                -- Bring the TwighlightSell to the player
                teleportTarget.CFrame = humanoidRootPart.CFrame
                
                -- Move any TouchTransmitter parts to ensure they make contact
                for _, part in ipairs(touchParts) do
                    part.CFrame = humanoidRootPart.CFrame
                end
            end)
        else
            -- Stop auto sell loop
            if autoSellLoop then
                autoSellLoop:Disconnect()
                autoSellLoop = nil
            end
            
            -- Return TwighlightSell to its original position
            if currentTwighlightSell and twighlightSellOriginalPosition then
                -- Find the teleport target again
                local teleportTarget
                if currentTwighlightSell:FindFirstChild("Root") then
                    teleportTarget = currentTwighlightSell.Root
                else
                    for _, part in pairs(currentTwighlightSell:GetDescendants()) do
                        if part:IsA("BasePart") then
                            teleportTarget = part
                            break
                        end
                    end
                end
                
                if teleportTarget then
                    -- Return to original position
                    teleportTarget.CFrame = twighlightSellOriginalPosition
                    
                    -- Restore visibility of all parts
                    for _, part in pairs(currentTwighlightSell:GetDescendants()) do
                        if part:IsA("BasePart") then
                            -- Return to default transparency
                            part.Transparency = 0
                        elseif part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or 
                               part:IsA("Smoke") or part:IsA("Fire") or part:IsA("Sparkles") then
                            part.Enabled = true
                        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
                            part.Enabled = true
                        end
                    end
                end
            end
        end
    end,
})

-- Auto Collect Gems Section
local GemsSection = MainTab:CreateSection("Auto Collect")

-- Add informational label about future feature
MainTab:CreateLabel("Auto Collect Pickups might be coming soon...")

-- GUIs Tab (positioned before Info Tab)
local GUIsTab = Window:CreateTab("GUIs", 4483362458) -- You can change the icon ID

-- Activations Section
local ActivationsSection = GUIsTab:CreateSection("Open GUIs")

-- Setup buttons for all activations and sub-activations
local function setupActivationButtons()
    local activationsFolder = workspace:FindFirstChild("Activations")
    if not activationsFolder then
        GUIsTab:CreateLabel("Activations folder not found in workspace")
        return
    end
    
    -- Create a button for each model in Activations
    for _, activation in pairs(activationsFolder:GetChildren()) do
        local activationName = activation.Name
        
        -- Skip certain activations (Chest, Candy Land, Return Home, Spring, Sell, TwighlightSell, GroupBenefits)
        if string.match(activationName, "^Chest") or
           activationName == "Candy Land" or
           activationName == "Return Home" or 
           string.match(string.lower(activationName), "return") or -- Additional check for ReturnHome variants
           activationName == "Spring" or
           activationName == "Sell" or
           activationName == "TwighlightSell" or
           activationName == "GroupBenefits" then
            -- Skip these activations
        else
            -- Check if it's a folder/model with sub-activations
            if activation:IsA("Folder") or activation:IsA("Model") then
                -- If it has children that are models, create a section for it
                local hasSubModels = false
                local hasNonExcludedModels = false
                
                for _, subModel in pairs(activation:GetChildren()) do
                    if subModel:IsA("Model") then
                        if not (string.match(subModel.Name, "^Chest") or
                               subModel.Name == "Candy Land" or
                               subModel.Name == "Return Home" or
                               subModel.Name == "Spring" or
                               subModel.Name == "Sell" or
                               subModel.Name == "TwighlightSell" or
                               subModel.Name == "GroupBenefits") then
                            hasNonExcludedModels = true
                        end
                        hasSubModels = true
                    end
                end
                
                if hasSubModels and hasNonExcludedModels then
                    -- Create a section for this activation category
                    local categorySection = GUIsTab:CreateSection(activation.Name)
                    
                    -- Add buttons for each sub-activation (excluding certain ones)
                    for _, subActivation in pairs(activation:GetChildren()) do
                        if subActivation:IsA("Model") and not (string.match(subActivation.Name, "^Chest") or
                                                             subActivation.Name == "Candy Land" or
                                                             subActivation.Name == "Return Home" or
                                                             string.match(string.lower(subActivation.Name), "return") or -- Additional check
                                                             subActivation.Name == "Spring" or
                                                             subActivation.Name == "Sell" or
                                                             subActivation.Name == "TwighlightSell" or
                                                             subActivation.Name == "GroupBenefits") then
                            GUIsTab:CreateButton({
                                Name = "Open " .. subActivation.Name .. " GUI",
                                Callback = function()
                                    bringActivationToPlayer(subActivation, false) -- Don't show notifications for GUIs
                                end,
                            })
                        end
                    end
                elseif not hasSubModels then
                    -- It's a direct activation, add a button for it
                    GUIsTab:CreateButton({
                        Name = "Open " .. activation.Name .. " GUI",
                        Callback = function()
                            bringActivationToPlayer(activation.Name, false) -- Don't show notifications for GUIs
                        end,
                    })
                end
            end
        end
    end
end

-- Setup the buttons when the script runs
setupActivationButtons()

-- Teleport Tab (positioned between GUIs and Misc tabs)
local TeleportTab = Window:CreateTab("Teleport", 4483362458) -- You can change the icon ID

-- Character Modifications Section
local CharacterSection = TeleportTab:CreateSection("Character Modifications")

-- Jump Power Variables (kept for compatibility)
local jumpPowerEnabled = false
local originalJumpPower = 50
local customJumpPower = 100
local noclipEnabled = false
local noclipConnection = nil
local flyUpEnabled = false
local flyUpConnection = nil

-- Vertical Fly Toggle
TeleportTab:CreateToggle({
    Name = "Vertical Fly",
    CurrentValue = false,
    Flag = "VerticalFly",
    Callback = function(Value)
        flyUpEnabled = Value
        local player = game.Players.LocalPlayer
        
        if flyUpEnabled then
            -- Clean up existing connection if any
            if flyUpConnection then
                flyUpConnection:Disconnect()
                flyUpConnection = nil
            end
            
            -- Create new connection for vertical flight
            flyUpConnection = game:GetService("RunService").Stepped:Connect(function()
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")
                    
                    if humanoidRootPart and humanoid then
                        -- Apply strong upward velocity
                        humanoidRootPart.Velocity = Vector3.new(0, 800, 0)
                        
                        -- Make all parts in the character no-clip
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            -- Disable fly
            if flyUpConnection then
                flyUpConnection:Disconnect()
                flyUpConnection = nil
            end
            
            -- Restore normal collision
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    -- Stop the upward velocity
                    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- Most parts should collide, except humanoid root part which doesn't by default
                        if part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end,
})

TeleportTab:CreateLabel("Vertical Fly shoots you upward at high speed with noclip to discover new islands and secret areas")

-- Vertical Noclip Toggle
TeleportTab:CreateToggle({
    Name = "Vertical Noclip",
    CurrentValue = false,
    Flag = "VerticalNoclip",
    Callback = function(Value)
        noclipEnabled = Value
        local player = game.Players.LocalPlayer
        
        if noclipEnabled then
            -- Clean up existing connection if any
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            
            -- Create new connection for vertical noclip
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")
                    
                    if humanoidRootPart and humanoid then
                        -- Get the character's velocity
                        local velocity = humanoidRootPart.Velocity
                        
                        -- Check if player is moving upward (jumping)
                        if velocity.Y > 0 or humanoid.Jump then
                            -- Make all parts in the character no-clip for upward movement
                            for _, part in pairs(character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        else
                            -- For downward movement, re-enable collision except for the Head
                            for _, part in pairs(character:GetDescendants()) do
                                if part:IsA("BasePart") and part.Name ~= "Head" then
                                    part.CanCollide = true
                                end
                            end
                        end
                    end
                end
            end)
        else
            -- Disable noclip
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            
            -- Restore normal collision
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- Most parts should collide, except humanoid root part which doesn't by default
                        if part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end,
})

TeleportTab:CreateLabel("Only allows you to jump through ceilings while still walking normally on the ground")

-- Function to teleport player to a location
local function teleportPlayerTo(targetCFrame)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    humanoidRootPart.CFrame = targetCFrame
end

-- Spawn Teleport Section 
local SpawnSection = TeleportTab:CreateSection("Worlds")

-- Add note about loading GUI in spawn area
TeleportTab:CreateLabel("If other worlds don't load, please load the GUI in the spawn area")

-- Add button to teleport to spawn
TeleportTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        if workspace:FindFirstChild("SpawnLocation") then
            teleportPlayerTo(workspace.SpawnLocation.CFrame + Vector3.new(0, 3, 0))
        else
            teleportPlayerTo(CFrame.new(0, 50, 0))
        end
    end,
})

-- Setup teleport buttons for floating islands
local function setupIslandTeleports()
    -- Check if FloatingIslands.Overworld exists
    if not workspace:FindFirstChild("FloatingIslands") or 
       not workspace.FloatingIslands:FindFirstChild("Overworld") then
        TeleportTab:CreateLabel("Floating Islands not found in workspace")
        return
    end
    
    local overworldFolder = workspace.FloatingIslands.Overworld
    
    -- Sort islands by name if possible
    local islands = {}
    for _, island in pairs(overworldFolder:GetChildren()) do
        if island:IsA("Model") then
            table.insert(islands, island)
        end
    end
    
    table.sort(islands, function(a, b)
        -- Try to sort numerically if islands have numbers
        local aNum = tonumber(string.match(a.Name, "%d+"))
        local bNum = tonumber(string.match(b.Name, "%d+"))
        
        if aNum and bNum then
            return aNum < bNum
        else
            return a.Name < b.Name
        end
    end)
    
    -- Add teleport button for each island
    for _, island in ipairs(islands) do
        local teleportTarget
        
        -- First try to find a TeleportPoint part specifically
        local teleportPoint = island:FindFirstChild("TeleportPoint", true)
        if teleportPoint and teleportPoint:IsA("BasePart") then
            teleportTarget = teleportPoint
        -- If no TeleportPoint was found, use the standard fallbacks
        elseif island:FindFirstChild("SpawnLocation") then
            teleportTarget = island.SpawnLocation
        elseif island:FindFirstChild("Spawn") then
            teleportTarget = island.Spawn
        elseif island:FindFirstChild("Platform") then
            teleportTarget = island.Platform
        elseif island:FindFirstChild("Landing") then
            teleportTarget = island.Landing
        elseif island:FindFirstChild("Root") then
            teleportTarget = island.Root
        elseif island:FindFirstChild("Base") then
            teleportTarget = island.Base
        elseif island:FindFirstChild("Part") then
            teleportTarget = island.Part
        else
            -- Look for the highest part in the island as fallback
            local highestPart = nil
            local highestY = -math.huge
            
            for _, part in pairs(island:GetDescendants()) do
                if part:IsA("BasePart") and part.Position.Y > highestY then
                    -- Filter out very small parts
                    if part.Size.X > 2 and part.Size.Z > 2 then
                        highestY = part.Position.Y
                        highestPart = part
                    end
                end
            end
            
            if highestPart then
                teleportTarget = highestPart
            else
                -- Final fallback to any BasePart
                for _, part in pairs(island:GetDescendants()) do
                    if part:IsA("BasePart") then
                        teleportTarget = part
                        break
                    end
                end
            end
        end
        
        if teleportTarget then
            TeleportTab:CreateButton({
                Name = "Teleport to " .. island.Name,
                Callback = function()
                    -- Teleport to the target part, with proper height offset
                    local size = teleportTarget.Size or Vector3.new(0, 0, 0)
                    local teleportPosition = teleportTarget.CFrame.Position + Vector3.new(0, size.Y/2 + 5, 0)
                    teleportPlayerTo(CFrame.new(teleportPosition))
                end,
            })
        end
    end
end

-- Add Island teleport buttons (if the folder exists)
setupIslandTeleports()

-- Create Event Section at the bottom of Teleport Tab
local EventSection = TeleportTab:CreateSection("Event")

-- Add Spring Event teleport buttons
TeleportTab:CreateButton({
    Name = "Teleport to Spring Spawn",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local springSpawn = workspace:FindFirstChild("TeleportPoints")
        if springSpawn and springSpawn:FindFirstChild("SpringSpawn") then
            humanoidRootPart.CFrame = springSpawn.SpringSpawn.CFrame + Vector3.new(0, 5, 0)
        else
            -- Notify if the teleport point can't be found
            Rayfield:Notify({
                Title = "Teleport Failed",
                Content = "Spring Spawn teleport point not found",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Blossom Island",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local floatingIslands = workspace:FindFirstChild("FloatingIslands")
        if floatingIslands and floatingIslands:FindFirstChild("Spring") then
            local blossomIsland = floatingIslands.Spring:FindFirstChild("Blossom Island")
            if blossomIsland and blossomIsland:FindFirstChild("TeleportPoint") then
                humanoidRootPart.CFrame = blossomIsland.TeleportPoint.CFrame + Vector3.new(0, 5, 0)
            else
                -- Notify if the teleport point can't be found
                Rayfield:Notify({
                    Title = "Teleport Failed",
                    Content = "Blossom Island teleport point not found",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            -- Notify if the teleport point can't be found
            Rayfield:Notify({
                Title = "Teleport Failed",
                Content = "Spring islands not found",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Honey Island",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local floatingIslands = workspace:FindFirstChild("FloatingIslands")
        if floatingIslands and floatingIslands:FindFirstChild("Spring") then
            local honeyIsland = floatingIslands.Spring:FindFirstChild("Honey Island")
            if honeyIsland and honeyIsland:FindFirstChild("TeleportPoint") then
                humanoidRootPart.CFrame = honeyIsland.TeleportPoint.CFrame + Vector3.new(0, 5, 0)
            else
                -- Notify if the teleport point can't be found
                Rayfield:Notify({
                    Title = "Teleport Failed",
                    Content = "Honey Island teleport point not found",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            -- Notify if the teleport point can't be found
            Rayfield:Notify({
                Title = "Teleport Failed",
                Content = "Spring islands not found",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Misc Tab (positioned after Teleport tab)
local MiscTab = Window:CreateTab("Misc", 4483362458) -- You can change the icon ID

-- Chests Section
local ChestsSection = MiscTab:CreateSection("Auto Collect")

-- Function to find all chest-related activations
local function findAllChestActivations()
    local chestActivations = {}
    local activationsFolder = workspace:FindFirstChild("Activations")
    
    if not activationsFolder then
        return chestActivations
    end
    
    -- Helper function to check if a name starts with "Chest"
    local function isChest(name)
        return string.match(name, "^Chest") ~= nil
    end
    
    -- Search through all activations
    for _, activation in pairs(activationsFolder:GetChildren()) do
        -- Direct chest activations
        if isChest(activation.Name) then
            table.insert(chestActivations, activation)
        end
        
        -- Check for chest sub-activations
        if (activation:IsA("Folder") or activation:IsA("Model")) then
            for _, subActivation in pairs(activation:GetChildren()) do
                if subActivation:IsA("Model") and isChest(subActivation.Name) then
                    table.insert(chestActivations, subActivation)
                end
            end
        end
    end
    
    return chestActivations
end

-- Button to collect all chests in sequence
MiscTab:CreateButton({
    Name = "Collect All Chests",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Find all chest activations
        local chestActivations = findAllChestActivations()
        
        if #chestActivations == 0 then
            Rayfield:Notify({
                Title = "No Chests Found",
                Content = "Could not find any chest-related activations",
                Duration = 3
            })
            return
        end
        
        Rayfield:Notify({
            Title = "Chest Collection Started",
            Content = "Found " .. #chestActivations .. " chests to collect",
            Duration = 3
        })
        
        -- Bring each chest to the player in sequence
        for i, chest in ipairs(chestActivations) do
            -- Find a reference part to teleport (prefer Root)
            local teleportTarget
            if chest:FindFirstChild("Root") then
                teleportTarget = chest.Root
            else
                for _, part in pairs(chest:GetDescendants()) do
                    if part:IsA("BasePart") then
                        teleportTarget = part
                        break
                    end
                end
            end
            
            if teleportTarget then
                -- Store original position and transparency
                local originalPosition = teleportTarget.CFrame
                local originalTransparency = {}
                
                -- Make all parts of the chest invisible
                for _, part in pairs(chest:GetDescendants()) do
                    if part:IsA("BasePart") then
                        originalTransparency[part] = part.Transparency
                        part.Transparency = 1
                    end
                end
                
                -- Bring chest to player
                teleportTarget.CFrame = humanoidRootPart.CFrame
                
                -- Move slightly in different directions to trigger collection
                for j = 1, 4 do
                    -- Small circular movement around the player
                    local angle = (j / 4) * math.pi * 2
                    local offset = CFrame.new(math.cos(angle) * 2, 0, math.sin(angle) * 2)
                    teleportTarget.CFrame = humanoidRootPart.CFrame * offset
                    task.wait(0.1)
                end
                
                -- Return chest to original position
                teleportTarget.CFrame = originalPosition
                
                -- Restore original transparency and re-enable visual effects
                for part, transparency in pairs(originalTransparency) do
                    part.Transparency = transparency
                end
                
                for _, part in pairs(chest:GetDescendants()) do
                    if part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or part:IsA("Smoke") or part:IsA("Fire") or part:IsA("Sparkles") then
                        part.Enabled = true
                    elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
                        part.Enabled = true
                    end
                end
                
                Rayfield:Notify({
                    Title = "Chest " .. i .. "/" .. #chestActivations,
                    Content = "Collected " .. chest.Name,
                    Duration = 1
                })
            end
        end
        
        Rayfield:Notify({
            Title = "Chest Collection Complete",
            Content = "Collected all " .. #chestActivations .. " chests",
            Duration = 3
        })
    end,
})

-- Add informational label about chest collection
MiscTab:CreateLabel("Note: You may need to press 'Collect All Chests' multiple times to claim all chests")

-- Info Tab
local InfoTab = Window:CreateTab("Info", 4483362458) -- You can change the icon ID

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

-- Return the library to allow imports
return Rayfield 