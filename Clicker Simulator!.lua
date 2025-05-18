local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by D3f4ult",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AutoFarmConfig",
        FileName = "Config"
    }
})

-- Create Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Create sections
local ClickSection = MainTab:CreateSection("Clicking")
-- Auto Click Toggle
local AutoClickToggle = MainTab:CreateToggle({
    Name = "Auto Click",
    CurrentValue = false,
    Flag = "AutoClick",
    Callback = function(Value)
        _G.AutoClick = Value
        while _G.AutoClick do
            game:GetService("ReplicatedStorage").Events.Click:FireServer()
            task.wait()
        end
    end,
})

local RebirthSection = MainTab:CreateSection("Rebirth")
-- Auto Rebirth Toggle with TextBox
local RebirthAmount = 1
local RebirthTextBox = MainTab:CreateInput({
    Name = "Rebirth Amount",
    PlaceholderText = "Enter amount",
    NumbersOnly = true,
    CharacterLimit = 3,
    Flag = "RebirthAmount",
    Callback = function(Text)
        RebirthAmount = tonumber(Text) or 1
    end,
})

local AutoRebirthToggle = MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        _G.AutoRebirth = Value
        while _G.AutoRebirth do
            local args = {
                [1] = RebirthAmount
            }
            game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
            task.wait()
        end
    end,
})

local UpgradeSection = MainTab:CreateSection("Upgrades")
-- Auto Buy Upgrades Toggle
local AutoBuyUpgradesToggle = MainTab:CreateToggle({
    Name = "Auto Buy Upgrades",
    CurrentValue = false,
    Flag = "AutoBuyUpgrades",
    Callback = function(Value)
        _G.AutoBuyUpgrades = Value
        while _G.AutoBuyUpgrades do
            -- Click Multiplier
            local args1 = {
                [1] = "Spawn",
                [2] = "ClickMulti"
            }
            game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args1))
            
            -- Gem Multiplier
            local args2 = {
                [1] = "Spawn",
                [2] = "GemMulti"
            }
            game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args2))
            
            -- Rebirth Buttons
            local args3 = {
                [1] = "Spawn",
                [2] = "RebirthButtons"
            }
            game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args3))
            
            -- Pet Equip
            local args4 = {
                [1] = "Spawn",
                [2] = "PetEquip"
            }
            game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args4))
            
            -- More Storage
            local args5 = {
                [1] = "Spawn",
                [2] = "MoreStorage"
            }
            game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args5))
            
            -- Luck Multiplier
            local args6 = {
                [1] = "Spawn",
                [2] = "LuckMulti"
            }
            game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args6))
            
            -- Hatch Speed
            local args7 = {
                [1] = "Spawn",
                [2] = "HatchSpeed"
            }
            game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args7))
            
            -- Walk Speed
            local args8 = {
                [1] = "Spawn",
                [2] = "WalkSpeed"
            }
            game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args8))
            
            task.wait()
        end
    end,
})

local CraftSection = MainTab:CreateSection("Crafting")
-- Auto Craft Toggle
local AutoCraftToggle = MainTab:CreateToggle({
    Name = "Auto Craft",
    CurrentValue = false,
    Flag = "AutoCraft",
    Callback = function(Value)
        _G.AutoCraft = Value
        while _G.AutoCraft do
            game:GetService("ReplicatedStorage").Functions.CraftPet:InvokeServer()
            task.wait(1)
        end
    end,
})

-- Create Auto Hatch Tab
local AutoHatchTab = Window:CreateTab("Auto Hatch", 4483362458)

-- Create sections for Auto Hatch
local HatchModeSection = AutoHatchTab:CreateSection("Hatch Mode")
-- Variables for hatch mode
local currentHatchMode = "Single"
local hatchModeLabel = AutoHatchTab:CreateLabel("Current Mode: Single")

-- Create buttons for hatch mode
AutoHatchTab:CreateButton({
    Name = "Single Mode",
    Callback = function()
        currentHatchMode = "Single"
        hatchModeLabel:Set("Current Mode: Single")
    end,
})

AutoHatchTab:CreateButton({
    Name = "Triple Mode",
    Callback = function()
        currentHatchMode = "Triple"
        hatchModeLabel:Set("Current Mode: Triple")
    end,
})

local HatchSettingsSection = AutoHatchTab:CreateSection("Hatch Settings")

-- Function to create egg toggles
local function CreateEggToggle(eggName)
    AutoHatchTab:CreateToggle({
        Name = eggName,
        CurrentValue = false,
        Flag = "AutoHatch" .. eggName,
        Callback = function(Value)
            _G["AutoHatch" .. eggName] = Value
            while _G["AutoHatch" .. eggName] do
                local args = {
                    [1] = eggName,
                    [2] = currentHatchMode
                }
                game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
                task.wait()
            end
        end,
    })
end

-- Get all eggs from EggHolders and create toggles
for _, eggHolder in pairs(workspace.Scripted.EggHolders:GetChildren()) do
    if eggHolder:IsA("Model") then
        CreateEggToggle(eggHolder.Name)
    end
end

-- Create GUIs Tab (positioned after Auto Hatch)
local GUIsTab = Window:CreateTab("GUIs", 4483362458)

-- Create section for GUIs
local TouchPartsSection = GUIsTab:CreateSection("Touch Parts")

-- Create buttons for all TouchParts
for _, model in pairs(workspace.Scripted.TouchParts:GetChildren()) do
    if model:IsA("Model") then
        local touchPart = model:FindFirstChild("TouchPart") or model:FindFirstChild("Touch")
        if touchPart then
            GUIsTab:CreateButton({
                Name = model.Name,
                Callback = function()
                    firetouchinterest(touchPart, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                    task.wait()
                    firetouchinterest(touchPart, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                end,
            })
        end
    end
end

-- Create Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Create section for Misc
local ServerSection = MiscTab:CreateSection("Server Options")
-- Server Hop Button
MiscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local function GetRandomServer()
            local Servers = TeleportService:GetGameInstances(game.PlaceId)
            local RandomServer = Servers[math.random(1, #Servers)]
            return RandomServer
        end
        
        local function HopToServer()
            local RandomServer = GetRandomServer()
            if RandomServer then
                TeleportService:TeleportToGameInstance(game.PlaceId, RandomServer)
            end
        end
        
        HopToServer()
    end,
})

-- Rejoin Button
MiscTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
}) 