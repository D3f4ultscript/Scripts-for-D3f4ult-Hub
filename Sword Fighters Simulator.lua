local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Helper functions for Info tab
local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function GetExecutorInfo()
    if identifyexecutor then
        return identifyexecutor()
    end
    return "Unknown"
end

local function GetExecutorVersion()
    if getexecutorname then
        return getexecutorname()
    end
    return "Unknown"
end

local Window = Rayfield:CreateWindow({
    Name = "Sword Fighters Simulator [V1.0]",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by D3f4ult",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Model Teleporter",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
local InfoTab = Window:CreateTab("Info", 4483362458)

-- Store session start time
local StartTime = os.time()

-- Store last position
local lastPosition = nil

-- Function to save current position
local function savePosition()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        lastPosition = character.HumanoidRootPart.CFrame
    end
end

-- Function to freeze player
local function freezePlayer(character)
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
    end
end

-- Function to unfreeze player
local function unfreezePlayer(character)
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end

-- Function to teleport and freeze
local function teleportAndFreeze(target)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") and target then
        local head = target:FindFirstChild("Head")
        if head then
            savePosition()
            
            -- Get current and target positions
            local currentPos = character.HumanoidRootPart.Position
            local targetPos = head.Position
            
            -- Calculate distance
            local distance = (currentPos - targetPos).Magnitude
            
            -- If distance is too large, teleport in steps
            if distance > 1000 then
                local steps = math.ceil(distance / 1000)
                local stepVector = (targetPos - currentPos) / steps
                
                for i = 1, steps do
                    local stepPos = currentPos + (stepVector * i)
                    character.HumanoidRootPart.CFrame = CFrame.new(stepPos) * CFrame.new(0, 2, 0)
                    wait(0.1)
                end
            end
            
            -- Final teleport to exact position
            character.HumanoidRootPart.CFrame = head.CFrame * CFrame.new(0, 2, 0)
            freezePlayer(character)
            wait(6)
            unfreezePlayer(character)
        end
    end
end

-- Create buttons for each QuestDummy
local questDummies = {
    {name = "Area 1", target = workspace.Resources.QuestDummy["Area 1"]},
    {name = "Area 10", target = workspace.Resources.QuestDummy["Area 10"]},
    {name = "Area 12", target = workspace.Resources.QuestDummy["Area 12"]},
    {name = "Area 2", target = workspace.Resources.QuestDummy["Area 2"]},
    {name = "Area 3", target = workspace.Resources.QuestDummy["Area 3"]},
    {name = "Area 4", target = workspace.Resources.QuestDummy["Area 4"]},
    {name = "Area 5", target = workspace.Resources.QuestDummy["Area 5"]},
    {name = "Area 6", target = workspace.Resources.QuestDummy["Area 6"]},
    {name = "Area 7", target = workspace.Resources.QuestDummy["Area 7"]},
    {name = "Area 8", target = workspace.Resources.QuestDummy["Area 8"]},
    {name = "Area 9", target = workspace.Resources.QuestDummy["Area 9"]},
    {name = "Dungeon 1", target = workspace.Resources.QuestDummy["Dungeon 1"]},
    {name = "Egg Master", target = workspace.Resources.QuestDummy["Egg Master"]},
    {name = "Executioner", target = workspace.Resources.QuestDummy.Executioner},
    {name = "Power Master", target = workspace.Resources.QuestDummy["Power Master"]},
    {name = "Soul Teacher", target = workspace.Resources.QuestDummy["Soul Teacher"]},
    {name = "Sword Master", target = workspace.Resources.QuestDummy["Sword Master"]},
    {name = "Area 16", target = workspace.Resources.QuestDummy:GetChildren()[16]}
}

for _, dummy in ipairs(questDummies) do
    TeleportTab:CreateButton({
        Name = dummy.name,
        Callback = function()
            teleportAndFreeze(dummy.target)
        end,
    })
end

-- Function to get valid models and their sizes
local function getValidModels()
    local models = {}
    for _, model in pairs(workspace.Live.NPCs.Client:GetChildren()) do
        if model:IsA("Model") then
            local primaryPart = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
            if primaryPart and primaryPart.Position.Y > -100 then
                local size = 0
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        size = size + (part.Size.X * part.Size.Y * part.Size.Z)
                    end
                end
                table.insert(models, {model = model, size = size})
            end
        end
    end
    return models
end

-- Function to teleport to a model
local function teleportToModel(model, character)
    if model and character and character:FindFirstChild("HumanoidRootPart") then
        savePosition() -- Save position before teleporting
        local targetCFrame = (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart).CFrame
        if targetCFrame.Position.Y > -100 then
            character.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 2, 0)
        end
    end
end

-- Function to check if a model is valid and not in damage bug state
local function isModelValid(model)
    if not model or not model.Parent or not model:IsA("Model") then
        return false
    end
    
    local primaryPart = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if not primaryPart or primaryPart.Position.Y <= -100 then
        return false
    end
    
    -- Check if model has any visible parts
    local hasVisibleParts = false
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 then
            hasVisibleParts = true
            break
        end
    end
    
    return hasVisibleParts
end

-- Toggle for smallest model
local TeleportToSmallestToggle = MainTab:CreateToggle({
    Name = "Teleport to Smallest Model",
    CurrentValue = false,
    Flag = "TeleportToSmallestToggle",
    Callback = function(Value)
        if Value then
            spawn(function()
                while Rayfield.Flags["TeleportToSmallestToggle"].CurrentValue do
                    local models = getValidModels()
                    table.sort(models, function(a, b)
                        return a.size < b.size
                    end)
                    
                    local smallestModel = nil
                    for _, data in ipairs(models) do
                        if isModelValid(data.model) then
                            smallestModel = data.model
                            break
                        end
                    end
                    
                    if smallestModel then
                        teleportToModel(smallestModel, game.Players.LocalPlayer.Character)
                    end
                    
                    wait(0.5)
                end
            end)
        end
    end,
})

-- Toggle for largest model
local TeleportToLargestToggle = MainTab:CreateToggle({
    Name = "Teleport to Largest Model",
    CurrentValue = false,
    Flag = "TeleportToLargestToggle",
    Callback = function(Value)
        if Value then
            spawn(function()
                local currentTarget = nil
                local lastValidPosition = nil
                local lastValidTime = 0
                
                while Rayfield.Flags["TeleportToLargestToggle"].CurrentValue do
                    -- If we have a current target and it's still valid, stick with it
                    if currentTarget and isModelValid(currentTarget) then
                        teleportToModel(currentTarget, game.Players.LocalPlayer.Character)
                        lastValidPosition = currentTarget:GetPrimaryPartCFrame().Position
                        lastValidTime = tick()
                    else
                        -- Find new largest model
                        local models = getValidModels()
                        table.sort(models, function(a, b)
                            return a.size > b.size
                        end)
                        
                        local newTarget = nil
                        for _, data in ipairs(models) do
                            if isModelValid(data.model) then
                                newTarget = data.model
                                break
                            end
                        end
                        
                        -- Only switch targets if:
                        -- 1. We have no current target, or
                        -- 2. The current target is gone for more than 3 seconds
                        if newTarget and (not currentTarget or (tick() - lastValidTime) > 3) then
                            currentTarget = newTarget
                            teleportToModel(currentTarget, game.Players.LocalPlayer.Character)
                            lastValidPosition = currentTarget:GetPrimaryPartCFrame().Position
                            lastValidTime = tick()
                        end
                    end
                    
                    wait(0.5)
                end
            end)
        end
    end,
})

-- Button to temporarily teleport chests
local TeleportChestsButton = MiscTab:CreateButton({
    Name = "Teleport Chests",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local chest1 = workspace.Resources.Chests["Chest 1"]
            local chest2 = workspace.Resources.Chests["Chest 2"]
            
            if chest1 or chest2 then
                -- Save current position
                savePosition()
                
                -- Teleport to Chest 1 if it exists
                if chest1 then
                    character.HumanoidRootPart.CFrame = chest1.CFrame * CFrame.new(0, 2, 0)
                    wait(1) -- Wait 1 second
                end
                
                -- Teleport to Chest 2 if it exists
                if chest2 then
                    character.HumanoidRootPart.CFrame = chest2.CFrame * CFrame.new(0, 2, 0)
                    wait(1) -- Wait 1 second
                end
                
                -- Return to original position
                if lastPosition then
                    character.HumanoidRootPart.CFrame = lastPosition
                end
            end
        end
    end,
})

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

InfoTab:CreateLabel("Note: Version information might be inaccurate")

-- Player Info
local PlayerSection = InfoTab:CreateSection("Player Information")

local playerAge = game.Players.LocalPlayer.AccountAge
local ageText = playerAge == 1 and "1 day" or playerAge .. " days"

InfoTab:CreateParagraph({
    Title = "Player Information",
    Content = "Display Name: " .. game.Players.LocalPlayer.DisplayName .. 
             "\nUsername: " .. game.Players.LocalPlayer.Name .. 
             "\nAccount Age: " .. ageText
}) 
