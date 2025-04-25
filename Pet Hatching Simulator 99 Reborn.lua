local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by D3f4ult",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "D3f4ult Hub",
        FileName = "Pet Hatching Simulator"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", "home")

MainTab:CreateSection("Auto Clicker")

local AutoClicker = MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClicker",
    Callback = function(Value)
        _G.AutoClickerEnabled = Value
        if Value then
            spawn(function()
                while _G.AutoClickerEnabled do
                    game:GetService("ReplicatedStorage").Events.Click:FireServer()
                    task.wait(0.01)
                end
            end)
        end
    end,
})

MainTab:CreateSection("Auto Rebirth")

local rebirthAmount = 1

local RebirthAmountInput = MainTab:CreateInput({
    Name = "Rebirth Amount",
    PlaceholderText = "Enter amount (default: 1)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if tonumber(Text) then
            rebirthAmount = tonumber(Text)
        else
            Rayfield:Notify({
                Title = "Invalid Input",
                Content = "Please enter a valid number",
                Duration = 3,
            })
        end
    end,
})

local AutoRebirth = MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        _G.AutoRebirthEnabled = Value
        if Value then
            spawn(function()
                while _G.AutoRebirthEnabled do
                    local args = {
                        [1] = rebirthAmount
                    }
                    game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end,
})

MainTab:CreateSection("Auto Mastery")

local AutoMastery = MainTab:CreateToggle({
    Name = "Auto Increase Mastery",
    CurrentValue = false,
    Flag = "AutoMastery",
    Callback = function(Value)
        _G.AutoMasteryEnabled = Value
        if Value then
            spawn(function()
                while _G.AutoMasteryEnabled do
                    game:GetService("ReplicatedStorage").Functions.IncreaseMastery:InvokeServer()
                    task.wait(0.01)
                end
            end)
        end
    end,
})

-- Eggs Tab
local EggsTab = Window:CreateTab("Eggs", "egg")

-- Hatch Options Section
EggsTab:CreateSection("Hatch Options")

-- Variable to store the selected hatch option
local selectedHatchOption = "Single"

-- Dropdown for hatch options
local HatchOptionsDropdown = EggsTab:CreateDropdown({
    Name = "Hatch Type",
    Options = {"Single", "Triple"},
    CurrentOption = selectedHatchOption,
    Flag = "HatchType",
    Callback = function(Option)
        selectedHatchOption = Option
    end,
})

-- Eggs Section
EggsTab:CreateSection("Eggs")

-- Store all auto hatch loops
local autoHatchLoops = {}

-- Create toggles for all items in EggHolders (directly in the script)
if workspace:FindFirstChild("Scripted") and workspace.Scripted:FindFirstChild("EggHolders") then
    local eggHolders = workspace.Scripted.EggHolders
    for _, item in pairs(eggHolders:GetChildren()) do
        local itemName = item.Name
        if not string.find(itemName:lower(), "robux") and not string.find(itemName:lower(), "carnival") and not string.find(itemName:lower(), "daily reward") then
            EggsTab:CreateToggle({
                Name = "Auto Hatch " .. itemName,
                CurrentValue = false,
                Flag = "AutoHatch" .. itemName:gsub("[^%w]", ""),
                Callback = function(Value)
                    _G["AutoHatch" .. itemName:gsub("[^%w]", "")] = Value
                    if Value then
                        spawn(function()
                            while _G["AutoHatch" .. itemName:gsub("[^%w]", "")] do
                                local args = {
                                    [1] = itemName,
                                    [2] = selectedHatchOption
                                }
                                game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
                                task.wait(0.01)
                            end
                        end)
                    end
                end,
            })
        end
    end
else
    -- Fallback toggles in case the folder isn't found
    local commonEggs = {"Basic Egg", "Forest Egg", "Desert Egg", "Winter Egg", "Lava Egg"}
    for _, eggName in pairs(commonEggs) do
        if not string.find(eggName:lower(), "robux") and not string.find(eggName:lower(), "carnival") and not string.find(eggName:lower(), "daily reward") then
            EggsTab:CreateToggle({
                Name = "Auto Hatch " .. eggName,
                CurrentValue = false,
                Flag = "AutoHatch" .. eggName:gsub("[^%w]", ""),
                Callback = function(Value)
                    _G["AutoHatch" .. eggName:gsub("[^%w]", "")] = Value
                    if Value then
                        spawn(function()
                            while _G["AutoHatch" .. eggName:gsub("[^%w]", "")] do
                                local args = {
                                    [1] = eggName,
                                    [2] = selectedHatchOption
                                }
                                game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
                                task.wait(0.01)
                            end
                        end)
                    end
                end,
            })
        end
    end
end

-- TouchParts Tab
local TouchTab = Window:CreateTab("GUIs", "layout")

-- Function to find all TouchInterest parts
local function findTouchInterestParts()
    local parts = {}
    if workspace:FindFirstChild("Scripted") and workspace.Scripted:FindFirstChild("TouchParts") then
        for _, item in pairs(workspace.Scripted.TouchParts:GetDescendants()) do
            if item:IsA("TouchTransmitter") or item.Name == "TouchInterest" then
                local part = item.Parent
                if part:IsA("BasePart") then
                    -- Find the model name
                    local model = part
                    while model.Parent and not model:IsA("Model") do
                        model = model.Parent
                    end
                    table.insert(parts, {
                        part = part,
                        modelName = model.Name
                    })
                end
            end
        end
    end
    return parts
end

-- Find all TouchInterest parts
local touchInterestParts = findTouchInterestParts()

-- Show notification with count
Rayfield:Notify({
    Title = "TouchInterest Parts Found",
    Content = "Found " .. #touchInterestParts .. " parts with TouchInterest",
    Duration = 5,
})

-- Create a button for each TouchInterest part
if #touchInterestParts > 0 then
    for i, data in ipairs(touchInterestParts) do
        TouchTab:CreateButton({
            Name = data.modelName,
            Callback = function()
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        firetouchinterest(player.Character.HumanoidRootPart, data.part, 0)
                        task.wait()
                        firetouchinterest(player.Character.HumanoidRootPart, data.part, 1)
                        
                        -- Show notification when touched
                        Rayfield:Notify({
                            Title = "TouchInterest Triggered",
                            Content = "Successfully touched " .. data.modelName,
                            Duration = 2,
                        })
                    end)
                end
            end,
        })
    end
else
    TouchTab:CreateLabel({
        Text = "No TouchInterest parts found in workspace.Scripted.TouchParts"
    })
end

-- Player Settings Tab
local PlayerTab = Window:CreateTab("Player Settings", "user")

-- Noclip Section
PlayerTab:CreateSection("Noclip")

local noclipToggle = PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        _G.NoclipEnabled = Value
        
        -- Store the original collision states
        if Value and not _G.OriginalCollisionStates then
            _G.OriginalCollisionStates = {}
        end
        
        if Value then
            -- Create noclip functionality
            if not _G.NoclipConnection then
                _G.NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
                    if not _G.NoclipEnabled then _G.NoclipConnection:Disconnect(); _G.NoclipConnection = nil; return; end
                    
                    local player = game.Players.LocalPlayer
                    if player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                -- Store original state if not already stored
                                if not _G.OriginalCollisionStates[part] then
                                    _G.OriginalCollisionStates[part] = part.CanCollide
                                end
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end
            
            -- Notification
            Rayfield:Notify({
                Title = "Noclip Enabled",
                Content = "You can now walk through walls",
                Duration = 3,
            })
        else
            -- Clean up noclip functionality
            if _G.NoclipConnection then
                _G.NoclipConnection:Disconnect()
                _G.NoclipConnection = nil
            end
            
            -- Restore original collision states
            if _G.OriginalCollisionStates then
                local player = game.Players.LocalPlayer
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and _G.OriginalCollisionStates[part] ~= nil then
                            part.CanCollide = _G.OriginalCollisionStates[part]
                        end
                    end
                end
                _G.OriginalCollisionStates = nil
            end
            
            -- Notification
            Rayfield:Notify({
                Title = "Noclip Disabled",
                Content = "Collision restored",
                Duration = 3,
            })
        end
    end,
})

-- Helper functions for Info tab
local StartTime = os.time()

local function FormatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if days > 0 then
        return string.format("%d days, %d hours, %d minutes, %d seconds", days, hours, minutes, secs)
    elseif hours > 0 then
        return string.format("%d hours, %d minutes, %d seconds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%d minutes, %d seconds", minutes, secs)
    else
        return string.format("%d seconds", secs)
    end
end

local function GetExecutorInfo()
    local executorInfo = "Unknown"
    if identifyexecutor then
        pcall(function()
            executorInfo = identifyexecutor()
        end)
    elseif syn and syn.protect_gui then
        executorInfo = "Synapse X"
    elseif KRNL_LOADED then
        executorInfo = "KRNL"
    elseif is_sirhurt_closure then
        executorInfo = "SirHurt"
    elseif SENTINEL_LOADED then
        executorInfo = "Sentinel"
    elseif gethui then
        executorInfo = "Script-Ware"
    elseif fluxus then
        executorInfo = "Fluxus"
    end
    return executorInfo
end

local function GetExecutorVersion()
    local version = "Unknown"
    pcall(function()
        if syn and syn.version then
            version = tostring(syn.version)
        elseif KRNL_VERSION then
            version = tostring(KRNL_VERSION)
        end
    end)
    return version
end

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

local Player = game.Players.LocalPlayer
local playerAge = Player.AccountAge
local ageText = playerAge == 1 and "1 day" or playerAge .. " days"

InfoTab:CreateParagraph({
    Title = "Player Information",
    Content = "Display Name: " .. Player.DisplayName .. 
             "\nUsername: " .. Player.Name .. 
             "\nAccount Age: " .. ageText
})
