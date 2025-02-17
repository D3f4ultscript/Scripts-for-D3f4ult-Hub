local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Pet Hatching Simulator 99", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "⚒ Main 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


Tab:AddToggle({
    Name = "Auto Click",
    Default = false,
    Callback = function(Value)
        _G.AutoClick = Value
        while _G.AutoClick do
            game:GetService("ReplicatedStorage").Events.Click:FireServer()
            task.wait(0.1)
        end
    end
})


local rebirthAmount = 1

local rebirthLabel

Tab:AddToggle({
    Name = "Auto Rebirth",
    Default = false,
    Callback = function(Value)
        _G.AutoRebirth = Value
        while _G.AutoRebirth do
            local args = {
                [1] = rebirthAmount
            }
            game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
            task.wait(0.1)
        end
    end
})

Tab:AddTextbox({
    Name = "Rebirth Amount",
    Default = "1",
    TextDisappear = false,
    Callback = function(Value)
        rebirthAmount = tonumber(Value) or 1
        if rebirthLabel then
            rebirthLabel:Set("Current Rebirth Amount: " .. tostring(rebirthAmount))
        end
    end
})

rebirthLabel = Tab:AddLabel("Current Rebirth Amount: 1")


local Tab = Window:MakeTab({
	Name = "⚒ Main 2",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local Section = Tab:AddSection({
	Name = "GUIS"
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local touchParts = {
    {Name = "Upgrades", Part = workspace.Scripted.TouchParts.Upgrades.TouchPart},
    {Name = "Relic Upgrader", Part = workspace.Scripted.TouchParts.RelicUpgrader.TouchPart},
    {Name = "Relic Inventory", Part = workspace.Scripted.TouchParts.RelicInventory.TouchPart},
    {Name = "Potion Shop", Part = workspace.Scripted.TouchParts.PotionShop.TouchPart},
    {Name = "Pet Adventure", Part = workspace.Scripted.TouchParts.PetAdventure.TouchPart},
    {Name = "Mastery", Part = workspace.Scripted.TouchParts.Mastery.TouchPart},
    {Name = "Bank", Part = workspace.Scripted.TouchParts.Bank.TouchPart},
    {Name = "200K Shop", Part = workspace.Scripted.TouchParts["200KShop"].TouchPart},
}

for _, partInfo in ipairs(touchParts) do
    Tab:AddButton({
        Name = "Open " .. partInfo.Name,
        Callback = function()
            local originalPosition = partInfo.Part.CFrame
            partInfo.Part.CFrame = humanoidRootPart.CFrame
            task.wait(0.1)  -- Kurze Pause, um das Spiel Zeit zum Registrieren der Berührung zu geben
            partInfo.Part.CFrame = originalPosition
        end
    })
end


local Section = Tab:AddSection({
	Name = "Collect Chests"
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local chestTouchParts = {
    workspace.Scripted.Chests["100KChest"].TouchPart,
    workspace.Scripted.Chests.ElectroChest.TouchPart,
    workspace.Scripted.Chests.GroupChest.TouchPart,
    workspace.Scripted.Chests.SummerChest.TouchPart,
    workspace.Scripted.Chests.VolcanicChest.TouchPart,
}

Tab:AddButton({
    Name = "Collect All Chests",
    Callback = function()
        local originalPositions = {}
        for i, part in ipairs(chestTouchParts) do
            originalPositions[i] = part.CFrame
            part.CFrame = humanoidRootPart.CFrame
            task.wait(0.1)  -- Kurze Pause, um das Spiel Zeit zum Registrieren der Berührung zu geben
            part.CFrame = originalPositions[i]
        end
    end
})


local Tab = Window:MakeTab({
	Name = "🌀 Teleport",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
-- KEINE WELTEN ENTFERNEN SONST GEHT ES NICHT MEHR

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local teleportLocations = {
    {Name = "Magic [soon]", Part = workspace.Scripted.Islands.Magic:GetChildren()[16]},
    {Name = "Lava", Part = workspace.Scripted.Islands.Lava.SpawnPoint},
    {Name = "Forest [Event]", Part = workspace.Scripted.Islands.Forest.SpawnPoint},
    {Name = "Fantasy", Part = workspace.Scripted.Islands["Fantasy Spawn"].SpawnPoint},
    {Name = "Military Base", Part = workspace.Scripted.Islands["Military Base"].SpawnPoint},
    {Name = "Mystic", Part = workspace.Scripted.Islands.Mystic.SpawnPoint},
    {Name = "Pixel World", Part = workspace.Scripted.Islands["Pixel World"].SpawnPoint},
    {Name = "Spawn", Part = workspace.Scripted.Islands.Spawn.SpawnPoint},
    {Name = "Swamp", Part = workspace.Scripted.Islands.Swamp.SpawnPoint},
    {Name = "Time World", Part = workspace.Scripted.Islands["Time World"].SpawnPoint},
}

local locationNames = {}
for _, location in ipairs(teleportLocations) do
    table.insert(locationNames, location.Name)
end

Tab:AddDropdown({
    Name = "Teleport Locations",
    Default = "Select a location",
    Options = locationNames,
    Callback = function(Value)
        for _, location in ipairs(teleportLocations) do
            if location.Name == Value then
                humanoidRootPart.CFrame = location.Part.CFrame
                break
            end
        end
    end
})



local Tab = Window:MakeTab({
	Name = "🥚 Auto Hatch",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local eggTypes = {}
for _, egg in pairs(workspace.Scripted.EggHolders:GetChildren()) do
    table.insert(eggTypes, egg.Name)
end

local selectedEgg = eggTypes[1]
local selectedHatchType = "Single"

Tab:AddDropdown({
    Name = "Select Egg",
    Default = selectedEgg,
    Options = eggTypes,
    Callback = function(Value)
        selectedEgg = Value
    end
})

Tab:AddDropdown({
    Name = "Hatch Type",
    Default = "Single",
    Options = {"Single", "Triple"},
    Callback = function(Value)
        selectedHatchType = Value
    end
})

Tab:AddToggle({
    Name = "Auto Hatch",
    Default = false,
    Callback = function(Value)
        _G.AutoHatch = Value
        while _G.AutoHatch do
            local args = {
                [1] = selectedEgg,
                [2] = selectedHatchType
            }
            game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
            task.wait()
        end
    end
})

Tab:AddParagraph("❗Warning❗","dont open the Robux Eggs")


local Tab = Window:MakeTab({
	Name = "⚙ Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


-- Button für FPS-Boost
local fpsBoostButton = Tab:AddButton({
    Name = "FPS Boost",
    Callback = function()
        print("FPS Boost aktiviert")
        -- Code zum Verschlechtern der Texturen für FPS-Boost
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            end
        end
    end
})