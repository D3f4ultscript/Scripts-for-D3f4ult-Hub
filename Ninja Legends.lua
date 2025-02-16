local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Ninja Legends", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})


local Tab = Window:MakeTab({
	Name = "❗ info",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


Tab:AddParagraph("✨Discord✨","Join my Discord for more scripts")


local link = "https://discord.gg/vpCmZyn9z4"

local copyButton = Tab:AddButton({
    Name = "click here to copy Discord link",
    Callback = function()
        -- Kopiere den Link in die Zwischenablage
        setclipboard(link)
        
        -- Zeige eine Meldung an, dass der Link kopiert wurde
        game.StarterGui:SetCore("SendNotification", {
            Title = "Copied!",
            Text = "The Discord link has been copied to your clipboard.",
            Duration = 5 -- Die Nachricht wird 5 Sekunden lang angezeigt
        })
    end
})


local Tab = Window:MakeTab({
	Name = "⚒ Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local Section = Tab:AddSection({
	Name = "Auto Swing and Sell"
})


local isSwingingKatana = false

-- Toggle für automatisches Katana-Schwingen
local katanaToggle = Tab:AddToggle({
    Name = "Auto Swing",
    Default = false,
    Callback = function(Value)
        isSwingingKatana = Value
        if isSwingingKatana then
            -- Starte eine Schleife zum kontinuierlichen Schwingen
            spawn(function()
                while isSwingingKatana do
                    local args = {
                        [1] = "swingKatana"
                    }
                    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
                    wait(0.1) -- Warte 0.1 Sekunden zwischen den Schwüngen
                end
            end)
        end
    end
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local isTeleporting = false

local function teleportLoop()
    local sellCircle = workspace.sellAreaCircles.sellAreaCircle.circleInner
    local originalPosition = sellCircle.Position

    while isTeleporting do
        sellCircle.CFrame = humanoidRootPart.CFrame
        wait(0.1) -- Kurze Pause beim Spieler
        sellCircle.CFrame = CFrame.new(originalPosition)
        wait(0.1) -- Kurze Pause an der Originalposition
    end
end

local teleportToggle = Tab:AddToggle({
    Name = "Auto Sell [x1]",
    Default = false,
    Callback = function(Value)
        isTeleporting = Value
        if isTeleporting then
            spawn(teleportLoop)
        end
    end
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local isTeleporting = false

local function teleportSellArea()
    local sellArea = workspace.sellAreaCircles:GetChildren()[20].circleInner
    local originalPosition = sellArea.Position

    while isTeleporting do
        sellArea.CFrame = humanoidRootPart.CFrame
        wait(0.1) -- Kurze Pause beim Spieler
        sellArea.CFrame = CFrame.new(originalPosition)
        wait(0.1) -- Kurze Pause an der Originalposition
    end
end

local sellAreaTeleportToggle = Tab:AddToggle({
    Name = "Auto Sell [x35]",
    Default = false,
    Callback = function(Value)
        isTeleporting = Value
        if isTeleporting then
            spawn(teleportSellArea)
        end
    end
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local originalJumpPower = humanoid.JumpPower
local originalJumpHeight = humanoid.JumpHeight
local isInfiniteJumpEnabled = false

local function enableInfiniteJump()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if isInfiniteJumpEnabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local infiniteJumpToggle = Tab:AddToggle({
    Name = "Infinite Jump + High Jump",
    Default = false,
    Callback = function(Value)
        isInfiniteJumpEnabled = Value
        if Value then
            humanoid.JumpPower = originalJumpPower * 4
            humanoid.JumpHeight = originalJumpHeight * 4
            enableInfiniteJump()
        else
            humanoid.JumpPower = originalJumpPower
            humanoid.JumpHeight = originalJumpHeight
        end
    end
})

-- Verbinde die Funktion mit dem CharacterAdded-Event für den Fall, dass der Charakter neu geladen wird
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    originalJumpPower = humanoid.JumpPower
    originalJumpHeight = humanoid.JumpHeight
    if isInfiniteJumpEnabled then
        humanoid.JumpPower = originalJumpPower * 4
        humanoid.JumpHeight = originalJumpHeight * 4
        enableInfiniteJump()
    end
end)


local Section = Tab:AddSection({
	Name = "Teleport to Hoops and Collect Chests"
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local isTeleporting = false

local function teleportToHoops()
    local hoops = workspace.Hoops:GetChildren()
    local index = 1

    while isTeleporting do
        if hoops[index] and hoops[index]:IsA("BasePart") then
            humanoidRootPart.CFrame = hoops[index].CFrame
            wait(0.5) -- Wartezeit zwischen Teleports, anpassbar
        end

        index = index + 1
        if index > #hoops then
            index = 1 -- Zurück zum Anfang, wenn alle Hoops durchlaufen wurden
        end
    end
end

local hoopTeleportToggle = Tab:AddToggle({
    Name = "Auto Teleport to Hoops",
    Default = false,
    Callback = function(Value)
        isTeleporting = Value
        if isTeleporting then
            spawn(teleportToHoops)
        end
    end
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local objectPaths = {
    workspace.wonderChest.circleInner,
    workspace.ultraNinjitsuChest.circleInner,
    workspace.thunderChest.circleInner,
    workspace.soulFusionChest.circleInner,
    workspace.skystormMastersChest.circleInner,
    workspace.saharaChest.circleInner,
    workspace.mythicalChest.circleInner,
    workspace.midnightShadowChest.circleInner,
    workspace.magmaChest.circleInner,
    workspace.lightKarmaChest.circleInner,
    workspace.legendsChest.circleInner,
    workspace.goldenZenChest.circleInner,
    workspace.goldenChest.circleInner,
    workspace.evilKarmaChest.circleInner,
    workspace.eternalChest.circleInner,
    workspace.enchantedChest.circleInner,
    workspace.chaosLegendsChest.circleInner,
    workspace.ancientChest.circleInner,
}

local function teleportObjects()
    for _, object in ipairs(objectPaths) do
        if object then
            local originalPosition = object.Position
            object.CFrame = humanoidRootPart.CFrame
            wait(0.1) -- Kurze Pause, während das Objekt beim Spieler ist
            object.CFrame = CFrame.new(originalPosition)
            wait(0.1) -- Kurze Pause zwischen den Objekten
        end
    end
end

local teleportButton = Tab:AddButton({
    Name = "Collect Chests",
    Callback = function()
        teleportObjects()
    end
})


local Tab = Window:MakeTab({
	Name = "💰 Auto Buy",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local Section = Tab:AddSection({
	Name = "Auto Buy Swords, Belts, Skills ..."
})


-- Toggle für automatischen Schwertkauf
local isBuyingSwords = false

local function buyAllSwords()
    while isBuyingSwords do
        local args = {
            [1] = "buyAllSwords",
            [2] = "Blazing Vortex Island"
        }
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
        wait(0.5)
    end
end

local swordBuyToggle = Tab:AddToggle({
    Name = "Auto Buy All Swords",
    Default = false,
    Callback = function(Value)
        isBuyingSwords = Value
        if isBuyingSwords then
            spawn(buyAllSwords)
        end
    end
})

-- Toggle für automatischen Gürtelkauf
local isBuyingBelts = false

local function buyAllBelts()
    while isBuyingBelts do
        local args = {
            [1] = "buyAllBelts",
            [2] = "Blazing Vortex Island"
        }
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
        wait(0.5)
    end
end

local beltBuyToggle = Tab:AddToggle({
    Name = "Auto Buy All Belts",
    Default = false,
    Callback = function(Value)
        isBuyingBelts = Value
        if isBuyingBelts then
            spawn(buyAllBelts)
        end
    end
})


local isBuyingSkills = false

local function buyAllSkills()
    while isBuyingSkills do
        local args = {
            [1] = "buyAllSkills",
            [2] = "Blazing Vortex Island"
        }
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
        wait(0.5) -- Wartezeit zwischen den Käufen, um Überlastung zu vermeiden
    end
end

local skillBuyToggle = Tab:AddToggle({
    Name = "Auto Buy All Skills",
    Default = false,
    Callback = function(Value)
        isBuyingSkills = Value
        if isBuyingSkills then
            spawn(buyAllSkills)
        end
    end
})


local isBuyingShurikens = false

local function buyAllShurikens()
    while isBuyingShurikens do
        local args = {
            [1] = "buyAllShurikens",
            [2] = "Blazing Vortex Island"
        }
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
        wait(0.5) -- Wartezeit zwischen den Käufen, um Überlastung zu vermeiden
    end
end

local shurikenBuyToggle = Tab:AddToggle({
    Name = "Auto Buy All Shurikens",
    Default = false,
    Callback = function(Value)
        isBuyingShurikens = Value
        if isBuyingShurikens then
            spawn(buyAllShurikens)
        end
    end
})


local isBuyingRanks = false
local rankNames = {
    "Aether Genesis Master Ninja", "Ancient Battle Legend", "Ancient Battle Master", "Apprentice", "Assassin",
    "Awakened Scythe Legend", "Awakened Scythemaster", "Chaos Legend", "Chaos Sensei", "Comet Strike Lion",
    "Cybernetic Azure Sensei", "Cybernetic Electro Legend", "Cybernetic Electro Master", "Dark Elements Blademaster",
    "Dark Elements Guardian", "Dark Sun Samurai Legend", "Dragon Evolution Form I", "Dragon Evolution Form II",
    "Dragon Evolution Form III", "Dragon Evolution Form IV", "Dragon Evolution Form V", "Dragon Master",
    "Dragon Warrior", "Eclipse Series Soul Master", "Elemental Legend", "Elite Series Master Legend",
    "Eternity Hunter", "Evolved Series Master Ninja", "Golden Sun Shuriken Legend", "Golden Sun Shuriken Master",
    "Grasshopper", "Immortal Assassin", "Infinity Legend", "Infinity Sensei", "Infinity Shadows Master",
    "Legendary Shadow Duelist", "Legendary Shadowmaster", "Lightning Storm Sensei", "Master Elemental Hero",
    "Master Legend Assassin", "Master Legend Sensei Hunter", "Master Legend Zephyr", "Master Ninja",
    "Master Of Elements", "Master Of Shadows", "Master Sensei", "Mythic Shadowmaster", "Ninja", "Ninja Legend",
    "Rising Shadow Eternal Ninja", "Rookie", "Samurai", "Sensei", "Shadow", "Shadow Chaos Assassin",
    "Shadow Chaos Legend", "Shadow Legend", "Shadow Storm Sensei", "Skyblade Ninja Master",
    "Skystorm Series Samurai Legend", "Starstrike Master Sensei"
}

local function buyAllRanks()
    while isBuyingRanks do
        for _, rankName in ipairs(rankNames) do
            local args = {
                [1] = "buyRank",
                [2] = rankName
            }
            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(unpack(args))
        end
        wait(0.1) -- Kurze Pause zwischen den Durchläufen, um Überlastung zu vermeiden
    end
end

local rankBuyToggle = Tab:AddToggle({
    Name = "Auto Buy All Ranks",
    Default = false,
    Callback = function(Value)
        isBuyingRanks = Value
        if isBuyingRanks then
            spawn(buyAllRanks)
        end
    end
})


local Tab = Window:MakeTab({
	Name = "🗺 Islands",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local Section = Tab:AddSection({
	Name = "Discover all Islands"
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local isTeleporting = false

local islandUnlockNames = {
    "Ancient Inferno Island", "Astral Island", "Blazing Vortex Island", "Chaos Legends Island",
    "Cybernetic Legends Island", "Dark Elements Island", "Dragon Legend Island", "Enchanted Island",
    "Eternal Island", "Golden Master Island", "Inner Peace Island", "Midnight Shadow Island",
    "Mystical Island", "Mythical Souls Island", "Sandstorm", "Skystorm Ultraus Island",
    "Soul Fusion Island", "Space Island", "Thunderstorm", "Tundra Island", "Winter Wonder Island"
}

local function teleportToIslandUnlocks()
    local index = 1
    while isTeleporting do
        local unlockName = islandUnlockNames[index]
        local unlockPart = workspace.islandUnlockParts:FindFirstChild(unlockName)
        if unlockPart then
            humanoidRootPart.CFrame = unlockPart.CFrame + Vector3.new(0, 5, 0)
        else
            print("Freischaltungsteil nicht gefunden: " .. unlockName)
        end
        wait(0.5)

        index = index + 1
        if index > #islandUnlockNames then
            index = 1
        end
    end
end

local islandUnlockTeleportToggle = Tab:AddToggle({
    Name = "Teleport to all Islands",
    Default = false,
    Callback = function(Value)
        isTeleporting = Value
        if isTeleporting then
            spawn(teleportToIslandUnlocks)
        end
    end
})


local Section = Tab:AddSection({
	Name = "Teleport"
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local islandNames = {
    "Ancient Inferno Island", "Astral Island", "Blazing Vortex Island", "Chaos Legends Island",
    "Cybernetic Legends Island", "Dark Elements Island", "Dragon Legend Island", "Enchanted Island",
    "Eternal Island", "Golden Master Island", "Inner Peace Island", "Midnight Shadow Island",
    "Mystical Island", "Mythical Souls Island", "Sandstorm", "Skystorm Ultraus Island",
    "Soul Fusion Island", "Space Island", "Thunderstorm", "Tundra Island", "Winter Wonder Island"
}

local function teleportToIsland(islandName)
    local unlockPart = workspace.islandUnlockParts:FindFirstChild(islandName)
    if unlockPart then
        humanoidRootPart.CFrame = unlockPart.CFrame + Vector3.new(0, 5, 0)
    else
        print("Insel nicht gefunden: " .. islandName)
    end
end

local islandDropdown = Tab:AddDropdown({
    Name = "Teleport to Island",
    Default = "",
    Options = islandNames,
    Callback = function(Value)
        teleportToIsland(Value)
    end    
})


local Tab = Window:MakeTab({
	Name = "⚙ Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local speed = 16 -- Standardgeschwindigkeit
local isEnabled = false

-- Funktion zum Anwenden der Geschwindigkeit
local function applySpeed()
    if isEnabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Standardgeschwindigkeit
    end
end

-- Slider für Geschwindigkeit
local speedSlider = Tab:AddSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        speed = Value
        if isEnabled then
            applySpeed()
        end
    end
})

-- Toggle zum Ein- und Ausschalten
local toggleButton = Tab:AddToggle({
    Name = "Speed Changer",
    Default = false,
    Callback = function(Value)
        isEnabled = Value
        applySpeed()
    end
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
