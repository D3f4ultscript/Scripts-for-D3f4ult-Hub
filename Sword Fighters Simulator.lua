local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Sword Fighters Simulator [Beta]",
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

-- Store last position
local lastPosition = nil

-- Function to save current position
local function savePosition()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        lastPosition = character.HumanoidRootPart.CFrame
    end
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

-- Button to teleport back to last position
local TeleportBackButton = TeleportTab:CreateButton({
    Name = "Teleport Back",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") and lastPosition then
            character.HumanoidRootPart.CFrame = lastPosition
        end
    end,
})

-- Button to teleport to EggCapsule
local TeleportToEggCapsuleButton = TeleportTab:CreateButton({
    Name = "Upgrades World 1",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            savePosition() -- Save position before teleporting
            local target = workspace.Map.UpgradesDetail["Meshes/EggCapsule_Plane"]
            if target then
                character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 2, 0)
            end
        end
    end,
})

-- Button to teleport to Robux Shop
local TeleportToRobuxShopButton = TeleportTab:CreateButton({
    Name = "Robux Shop",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            savePosition() -- Save position before teleporting
            local target = workspace.Map.ShopDetail["Meshes/EggCapsule_Plane"]
            if target then
                character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 2, 0)
            end
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
