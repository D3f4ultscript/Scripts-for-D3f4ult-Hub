local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Helper functions
local Player = game:GetService("Players").LocalPlayer
local StartTime = os.time()

local function FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    seconds = seconds % 60
    minutes = minutes % 60
    
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function GetExecutorInfo()
    local executorInfo = identifyexecutor and identifyexecutor() or "Unknown"
    return executorInfo
end

local function GetExecutorVersion()
    local executorVersion = "Unknown"
    if getexecutorname then
        executorVersion = getexecutorname()
    end
    return executorVersion
end

-- Get the game name
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local Window = Rayfield:CreateWindow({
    Name = GameName,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by D3f4ult",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AutoClicker",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", "diamond")
local AutoHatchTab = Window:CreateTab("Auto Hatch", "egg")
local GUIsTab = Window:CreateTab("GUIs", "layout")
local MiscTab = Window:CreateTab("Misc", "settings")
local InfoTab = Window:CreateTab("Info", "info")

-- Auto Clicker Section
local AutoClickerSection = MainTab:CreateSection("Auto Clicker")
local Toggle = MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClickerToggle",
    Callback = function(Value)
        if Value then
            -- Start auto clicking
            getgenv().AutoClick = true
            spawn(function()
                while getgenv().AutoClick do
                    game:GetService("ReplicatedStorage").Events.Click:FireServer()
                    wait(0.01)
                end
            end)
        else
            -- Stop auto clicking
            getgenv().AutoClick = false
        end
    end,
})

-- Auto Mastery Section
local AutoMasterySection = MainTab:CreateSection("Auto Mastery")
local MasteryToggle = MainTab:CreateToggle({
    Name = "Auto Increase Mastery",
    CurrentValue = false,
    Flag = "AutoMasteryToggle",
    Callback = function(Value)
        if Value then
            -- Start auto mastery
            getgenv().AutoMastery = true
            spawn(function()
                while getgenv().AutoMastery do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Functions.IncreaseMastery:InvokeServer()
                    end)
                    wait(0.1)
                end
            end)
        else
            -- Stop auto mastery
            getgenv().AutoMastery = false
        end
    end,
})

-- Auto Rebirth Section
local AutoRebirthSection = MainTab:CreateSection("Auto Rebirth")
local RebirthAmount = 1
local RebirthInput = MainTab:CreateInput({
    Name = "Rebirth Amount",
    PlaceholderText = "Enter amount",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        RebirthAmount = tonumber(Text) or 1
    end,
})

local RebirthToggle = MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirthToggle",
    Callback = function(Value)
        if Value then
            -- Start auto rebirth
            getgenv().AutoRebirth = true
            spawn(function()
                while getgenv().AutoRebirth do
                    local args = {
                        [1] = RebirthAmount
                    }
                    game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
                    wait(0.01)
                end
            end)
        else
            -- Stop auto rebirth
            getgenv().AutoRebirth = false
        end
    end,
})

-- Server Section
local ServerSection = MiscTab:CreateSection("Server")
MiscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local function GetRandomServer()
            local Servers = {}
            local Req = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            for i,v in pairs(Req.data) do
                if type(v) == "table" and v.playing ~= nil and v.id ~= game.JobId then
                    table.insert(Servers, v.id)
                end
            end
            if #Servers > 0 then
                return Servers[math.random(1, #Servers)]
            else
                return nil
            end
        end
        
        local newServer = GetRandomServer()
        if newServer then
            local success, errorMessage = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, newServer, LocalPlayer)
            end)
            
            if not success then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Failed to server hop: " .. errorMessage,
                    Duration = 5,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No other servers found",
                Duration = 5,
                Image = 4483362458,
            })
        end
    end,
})

MiscTab:CreateButton({
    Name = "Rejoin Same Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local success, errorMessage = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to rejoin: " .. errorMessage,
                Duration = 5,
                Image = 4483362458,
            })
        end
    end,
})

-- Auto Hatch Section
local AutoHatchSection = AutoHatchTab:CreateSection("Auto Hatch Mode")

-- Create toggles for Single and Triple mode selection
local singleModeEnabled = true
local tripleModeEnabled = false

-- Single Mode Toggle
AutoHatchTab:CreateToggle({
    Name = "Single Hatch Mode",
    CurrentValue = true,
    Flag = "SingleHatchMode",
    Callback = function(Value)
        if Value then
            singleModeEnabled = true
            tripleModeEnabled = false
            -- Disable Triple Mode toggle if Single Mode is enabled
            Rayfield.Flags["TripleHatchMode"] = false
        else
            singleModeEnabled = false
        end
    end,
})

-- Triple Mode Toggle
AutoHatchTab:CreateToggle({
    Name = "Triple Hatch Mode",
    CurrentValue = false,
    Flag = "TripleHatchMode",
    Callback = function(Value)
        if Value then
            tripleModeEnabled = true
            singleModeEnabled = false
            -- Disable Single Mode toggle if Triple Mode is enabled
            Rayfield.Flags["SingleHatchMode"] = false
        else
            tripleModeEnabled = false
        end
    end,
})

-- Get all egg names from workspace
local eggNames = {}
for _, eggHolder in pairs(workspace.Scripted.EggHolders:GetChildren()) do
    local name = eggHolder.Name
    -- Filter out names containing "Robux" or exactly "Daily Rewards"
    if not string.find(name, "Robux") and name ~= "Daily Rewards" then
        table.insert(eggNames, name)
    end
end

-- Fallback if no eggs found
if #eggNames == 0 then
    eggNames = {"Basic", "Rare", "Epic", "Legendary", "Mythical"}
end

-- Create egg toggles
local EggsSection = AutoHatchTab:CreateSection("Eggs")

-- Create a toggle for each egg
for _, eggName in ipairs(eggNames) do
    -- Egg Toggle
    AutoHatchTab:CreateToggle({
        Name = "Auto Hatch " .. eggName,
        CurrentValue = false,
        Flag = "Hatch_" .. eggName,
        Callback = function(Value)
            if Value then
                -- Start hatching thread
                getgenv()["Hatch_" .. eggName] = true
                spawn(function()
                    while getgenv()["Hatch_" .. eggName] do
                        pcall(function()
                            local hatchMode = "Single"
                            if tripleModeEnabled then
                                hatchMode = "Triple"
                            end
                            
                            local args = {
                                [1] = eggName,
                                [2] = hatchMode
                            }
                            game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
                        end)
                        task.wait(0.01)
                    end
                end)
            else
                -- Stop hatching thread
                getgenv()["Hatch_" .. eggName] = false
            end
        end,
    })
end

-- GUIs Tab
local GUIsSection = GUIsTab:CreateSection("Touch Parts")

-- Function to find the first touchable part in a model
local function FindTouchPart(model)
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("touch") or part.Name:lower():find("trigger") or part.Name:lower():find("detector")) then
            return part
        end
    end
    
    -- If no specific touch part found, return the first BasePart
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    
    return nil
end

-- Function to safely fire touch interest
local function FireTouchInterest(part)
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            firetouchinterest(Player.Character.HumanoidRootPart, part, 0)
            task.wait()
            firetouchinterest(Player.Character.HumanoidRootPart, part, 1)
        end
    end)
end

-- Create buttons for each model in TouchParts
local touchModelsFound = false
pcall(function()
    if workspace:FindFirstChild("Scripted") and workspace.Scripted:FindFirstChild("TouchParts") then
        local touchModels = workspace.Scripted.TouchParts:GetChildren()
        if #touchModels > 0 then
            for _, model in ipairs(touchModels) do
                local touchPart = FindTouchPart(model)
                if touchPart then
                    GUIsTab:CreateButton({
                        Name = model.Name,
                        Callback = function()
                            FireTouchInterest(touchPart)
                            Rayfield:Notify({
                                Title = "Activated",
                                Content = "Triggered " .. model.Name,
                                Duration = 1,
                                Image = 4483362458
                            })
                        end
                    })
                    touchModelsFound = true
                end
            end
        end
    end
end)

if not touchModelsFound then
    GUIsTab:CreateLabel("No touch parts found. Try again after joining the game.")
    
    -- Add a refresh button
    GUIsTab:CreateButton({
        Name = "Refresh Touch Parts",
        Callback = function()
            -- Clear existing buttons in this section
            for i,v in pairs(GUIsSection.Components) do
                if v.Type == "Button" and v.Name ~= "Refresh Touch Parts" then
                    v:Remove()
                end
            end
            
            -- Try to find touch models again
            local foundAny = false
            pcall(function()
                if workspace:FindFirstChild("Scripted") and workspace.Scripted:FindFirstChild("TouchParts") then
                    local touchModels = workspace.Scripted.TouchParts:GetChildren()
                    if #touchModels > 0 then
                        for _, model in ipairs(touchModels) do
                            local touchPart = FindTouchPart(model)
                            if touchPart then
                                GUIsTab:CreateButton({
                                    Name = model.Name,
                                    Callback = function()
                                        FireTouchInterest(touchPart)
                                        Rayfield:Notify({
                                            Title = "Activated",
                                            Content = "Triggered " .. model.Name,
                                            Duration = 1,
                                            Image = 4483362458
                                        })
                                    end
                                })
                                foundAny = true
                            end
                        end
                    end
                end
            end)
            
            if not foundAny then
                Rayfield:Notify({
                    Title = "No Touch Parts",
                    Content = "Still no touch parts found.",
                    Duration = 3,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "Success",
                    Content = "Touch parts refreshed!",
                    Duration = 3,
                    Image = 4483362458
                })
            end
        end
    })
end

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

Rayfield:LoadConfiguration() 