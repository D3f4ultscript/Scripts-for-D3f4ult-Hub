local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Pet Hatching Simulator 99", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- Main 1 Tab
local Tab = Window:MakeTab({
	Name = "⚒ Main 1",
	Icon = "",
	PremiumOnly = false
})


local Section = Tab:AddSection({
	Name = "Farming"
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


local Section = Tab:AddSection({
	Name = "Others"
})


Tab:AddToggle({
    Name = "Auto Mastery",
    Default = false,
    Callback = function(Value)
        _G.AutoMastery = Value
        while _G.AutoMastery do
            game:GetService("ReplicatedStorage").Functions.IncreaseMastery:InvokeServer()
            task.wait(0.5) -- Anpassbarer Delay
        end
    end
})


-- Main 2 Tab
local Tab = Window:MakeTab({
	Name = "⚒ Main 2",
	Icon = "",
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
    {Name = "Cave Upgrades", Part = workspace.Scripted.TouchParts.CaveUpgrades.TouchPart},
    {Name = "Fantasy Upgrades", Part = workspace.Scripted.TouchParts.EasterUpgrades.TouchPart},
    {Name = "Index", Part = workspace.Scripted.TouchParts.Index.TouchPart},
    {Name = "Robux Shop", Part = workspace.Scripted.TouchParts.RobuxShop.TouchPart}
}

for _, partInfo in ipairs(touchParts) do
    Tab:AddButton({
        Name = "Open " .. partInfo.Name,
        Callback = function()
            local originalPosition = partInfo.Part.CFrame
            partInfo.Part.CFrame = humanoidRootPart.CFrame
            task.wait(0.1)
            partInfo.Part.CFrame = originalPosition
        end
    })
end


local Section = Tab:AddSection({
	Name = "Collect Chests"
})

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
            task.wait(0.1)
            part.CFrame = originalPositions[i]
        end
    end
})

-- Teleport Tab
local Tab = Window:MakeTab({
	Name = "🌀 Teleport",
	Icon = "",
	PremiumOnly = false
})

-- SpawnPoints mit benutzerdefinierbaren Namen
local spawnPoints = {
    {
        Path = "workspace.Scripted.Islands['100K Event'].SpawnPoint",
        Name = "100K Event" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands.Candy.SpawnPoint",
        Name = "Candy Island" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands['Fantasy Spawn'].SpawnPoint",
        Name = "Fantasy Spawn" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands.Forest.SpawnPoint",
        Name = "Forest Island" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands.Lava.SpawnPoint",
        Name = "Lava Island" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands.Magic.Model:GetChildren()[2]",
        Name = "Magic Island" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands['Military Base'].SpawnPoint",
        Name = "Military Base" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands.Mystic.SpawnPoint",
        Name = "Mystic Island" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands['Pixel World'].SpawnPoint",
        Name = "Pixel World" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands.Spawn.SpawnPoint",
        Name = "Spawn Island" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands.Swamp.SpawnPoint",
        Name = "Swamp Island" -- Ändere diesen Wert für den Button-Namen
    },
    {
        Path = "workspace.Scripted.Islands['Time World'].SpawnPoint",
        Name = "Time World" -- Ändere diesen Wert für den Button-Namen
    }
}

-- Buttons erstellen mit benutzerdefinierbaren Namen
for _, spawnInfo in ipairs(spawnPoints) do
    Tab:AddButton({
        Name = spawnInfo.Name, -- Hier wird der benutzerdefinierte Name verwendet
        Callback = function()
            local success, spawnPoint = pcall(function()
                return loadstring("return " .. spawnInfo.Path)()
            end)
            
            if success and spawnPoint then
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = spawnPoint.CFrame
                else
                    player.CharacterAdded:Connect(function(character)
                        character:WaitForChild("HumanoidRootPart").CFrame = spawnPoint.CFrame
                    end)
                end
            else
                OrionLib:Notification({
                    Title = "Error",
                    Content = "Invalid spawn point selected.",
                    Duration = 3
                })
            end
        end
    })
end


-- Auto Hatch Tab
local Tab = Window:MakeTab({
	Name = "🥚 Auto Hatch",
	Icon = "",
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
    Options = {"Single", "Triple", "Octuple"},
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



-- Misc Tab
local Tab = Window:MakeTab({
	Name = "⚙ Misc",
	Icon = "",
	PremiumOnly = false
})


-- Button für FPS-Boost
local fpsBoostButton = Tab:AddButton({
    Name = "FPS Boost",
    Callback = function()
        print("FPS Boost aktiviert")
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
