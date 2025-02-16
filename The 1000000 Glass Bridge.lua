local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "The 1.000.000 Glass Bridge", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})


local Tab = Window:MakeTab({
	Name = "🏠 Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local RunService = game:GetService("RunService")

local function removeSpecificGlasses()
    local glassesToRemove = {
        workspace.Glasses.Wrong:GetChildren()[42],
        workspace.Glasses.Wrong.glass,
        workspace.Glasses.Wrong:GetChildren()[21],
        workspace.Glasses.Wrong:GetChildren()[2],
        workspace.Glasses.Wrong:GetChildren()[40],
        workspace.Glasses.Wrong:GetChildren()[39],
        workspace.Glasses.Wrong:GetChildren()[38],
        workspace.Glasses.Wrong:GetChildren()[37],
        workspace.Glasses.Wrong:GetChildren()[36],
        workspace.Glasses.Wrong:GetChildren()[35],
        workspace.Glasses.Wrong:GetChildren()[34],
        workspace.Glasses.Wrong:GetChildren()[33],
        workspace.Glasses.Wrong:GetChildren()[32],
        workspace.Glasses.Wrong:GetChildren()[31],
        workspace.Glasses.Wrong:GetChildren()[30],
        workspace.Glasses.Wrong:GetChildren()[29],
        workspace.Glasses.Wrong:GetChildren()[28],
        workspace.Glasses.Wrong:GetChildren()[27],
        workspace.Glasses.Wrong:GetChildren()[26],
        workspace.Glasses.Wrong:GetChildren()[25],
        workspace.Glasses.Wrong:GetChildren()[24],
        workspace.Glasses.Wrong:GetChildren()[23],
        workspace.Glasses.Wrong:GetChildren()[22],
        workspace.Glasses.Wrong:GetChildren()[41],
        workspace.Glasses.Wrong:GetChildren()[20],
        workspace.Glasses.Wrong:GetChildren()[19],
        workspace.Glasses.Wrong:GetChildren()[18],
        workspace.Glasses.Wrong:GetChildren()[17],
        workspace.Glasses.Wrong:GetChildren()[16],
        workspace.Glasses.Wrong:GetChildren()[15],
        workspace.Glasses.Wrong:GetChildren()[14],
        workspace.Glasses.Wrong:GetChildren()[13],
        workspace.Glasses.Wrong:GetChildren()[12],
        workspace.Glasses.Wrong:GetChildren()[11],
        workspace.Glasses.Wrong:GetChildren()[10],
        workspace.Glasses.Wrong:GetChildren()[9],
        workspace.Glasses.Wrong:GetChildren()[8],
        workspace.Glasses.Wrong:GetChildren()[7],
        workspace.Glasses.Wrong:GetChildren()[6],
        workspace.Glasses.Wrong:GetChildren()[5],
        workspace.Glasses.Wrong:GetChildren()[4],
        workspace.Glasses.Wrong:GetChildren()[3],
    }
    
    for _, glass in ipairs(glassesToRemove) do
        if glass and glass:IsA("BasePart") then
            glass.Transparency = 1
        end
    end
end

local connection

Tab:AddToggle({
    Name = "Remove Glasses",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Aktiviere die Funktion
            connection = RunService.Heartbeat:Connect(removeSpecificGlasses)
        else
            -- Deaktiviere die Funktion und stelle den Originalzustand wieder her
            if connection then
                connection:Disconnect()
            end
            -- Stelle die Sichtbarkeit der spezifischen Gläser wieder her
            local glassesToRestore = {
                workspace.Glasses.Wrong:GetChildren()[42],
                workspace.Glasses.Wrong.glass,
                workspace.Glasses.Wrong:GetChildren()[21],
                workspace.Glasses.Wrong:GetChildren()[2],
                workspace.Glasses.Wrong:GetChildren()[40],
                workspace.Glasses.Wrong:GetChildren()[39],
                workspace.Glasses.Wrong:GetChildren()[38],
                workspace.Glasses.Wrong:GetChildren()[37],
                workspace.Glasses.Wrong:GetChildren()[36],
                workspace.Glasses.Wrong:GetChildren()[35],
                workspace.Glasses.Wrong:GetChildren()[34],
                workspace.Glasses.Wrong:GetChildren()[33],
                workspace.Glasses.Wrong:GetChildren()[32],
                workspace.Glasses.Wrong:GetChildren()[31],
                workspace.Glasses.Wrong:GetChildren()[30],
                workspace.Glasses.Wrong:GetChildren()[29],
                workspace.Glasses.Wrong:GetChildren()[28],
                workspace.Glasses.Wrong:GetChildren()[27],
                workspace.Glasses.Wrong:GetChildren()[26],
                workspace.Glasses.Wrong:GetChildren()[25],
                workspace.Glasses.Wrong:GetChildren()[24],
                workspace.Glasses.Wrong:GetChildren()[23],
                workspace.Glasses.Wrong:GetChildren()[22],
                workspace.Glasses.Wrong:GetChildren()[41],
                workspace.Glasses.Wrong:GetChildren()[20],
                workspace.Glasses.Wrong:GetChildren()[19],
                workspace.Glasses.Wrong:GetChildren()[18],
                workspace.Glasses.Wrong:GetChildren()[17],
                workspace.Glasses.Wrong:GetChildren()[16],
                workspace.Glasses.Wrong:GetChildren()[15],
                workspace.Glasses.Wrong:GetChildren()[14],
                workspace.Glasses.Wrong:GetChildren()[13],
                workspace.Glasses.Wrong:GetChildren()[12],
                workspace.Glasses.Wrong:GetChildren()[11],
                workspace.Glasses.Wrong:GetChildren()[10],
                workspace.Glasses.Wrong:GetChildren()[9],
                workspace.Glasses.Wrong:GetChildren()[8],
                workspace.Glasses.Wrong:GetChildren()[7],
                workspace.Glasses.Wrong:GetChildren()[6],
                workspace.Glasses.Wrong:GetChildren()[5],
                workspace.Glasses.Wrong:GetChildren()[4],
                workspace.Glasses.Wrong:GetChildren()[3],
            }
            for _, glass in ipairs(glassesToRestore) do
                if glass and glass:IsA("BasePart") then
                    glass.Transparency = 0
                end
            end
        end
    end    
})


Tab:AddButton({
    Name = "Teleport to End",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local targetPart = workspace.Rich_final.rich_stairs:GetChildren()[46]
        
        if targetPart then
            humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        else
            warn("Target part not found!")
        end
    end
})


local RunService = game:GetService("RunService")

local remotes = {
    game:GetService("ReplicatedStorage").GiveTrophyFinal,
    game:GetService("ReplicatedStorage").Invite_Remotes.Give,
    game:GetService("ReplicatedStorage").GiveBadge,
    game:GetService("ReplicatedStorage").GiveClaimMoney,
    game:GetService("ReplicatedStorage").GiveCoins,
}

local function executeRemotes()
    for _, remote in ipairs(remotes) do
        if remote:IsA("RemoteFunction") then
            pcall(function()
                remote:InvokeServer()
            end)
        elseif remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer()
            end)
        end
    end
end

local connection

Tab:AddToggle({
    Name = "Give Money",
    Default = false,
    Callback = function(Value)
        if Value then
            connection = RunService.Heartbeat:Connect(executeRemotes)
        else
            if connection then
                connection:Disconnect()
            end
        end
    end
})


local Tab = Window:MakeTab({
	Name = "⚒ Tools",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Funktion zum Erstellen des Teleport-Tools
local function createTeleportTool()
    local tool = Instance.new("Tool")
    tool.Name = "Tp - Tool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)

    return tool
end

-- Button zum Geben des Teleport-Tools
Tab:AddButton({
    Name = "Give Tp - Tool",
    Callback = function()
        local tool = createTeleportTool()
        if LocalPlayer.Character then
            tool.Parent = LocalPlayer.Backpack
        else
            LocalPlayer.CharacterAdded:Wait()
            tool.Parent = LocalPlayer.Backpack
        end
    end
})


Tab:AddButton({
    Name = "Give Carpets [Need 95.000💵]",
    Callback = function()
        local carpetEvents = {
            game:GetService("ReplicatedStorage").CarpetsEvents.DiamondPrompt,
            game:GetService("ReplicatedStorage").CarpetsEvents.Donate,
            game:GetService("ReplicatedStorage").CarpetsEvents.GoldenPrompt,
            game:GetService("ReplicatedStorage").CarpetsEvents.Rainbow,
        }

        for _, event in ipairs(carpetEvents) do
            if event:IsA("RemoteEvent") then
                local success, result = pcall(function()
                    event:FireServer()
                end)
                
                if success then
                    print(event.Name .. " fired successfully!")
                else
                    warn("Failed to fire " .. event.Name .. ": " .. tostring(result))
                end
            else
                warn(event.Name .. " is not a RemoteEvent!")
            end
        end
    end
})


Tab:AddButton({
    Name = "Give Coils [Need 85.000💵]",
    Callback = function()
        local moneyCoilRemotes = {
            game:GetService("ReplicatedStorage").Money_Coil_Remotes.Void,
            game:GetService("ReplicatedStorage").Money_Coil_Remotes.CarpetGold,
            game:GetService("ReplicatedStorage").Money_Coil_Remotes.CoilGold,
            game:GetService("ReplicatedStorage").Money_Coil_Remotes.Diamond,
            game:GetService("ReplicatedStorage").Money_Coil_Remotes.Fire,
        }

        for _, remote in ipairs(moneyCoilRemotes) do
            if remote:IsA("RemoteEvent") then
                local success, result = pcall(function()
                    remote:FireServer()
                end)
                
                if success then
                    print(remote.Name .. " fired successfully!")
                else
                    warn("Failed to fire " .. remote.Name .. ": " .. tostring(result))
                end
            elseif remote:IsA("RemoteFunction") then
                local success, result = pcall(function()
                    return remote:InvokeServer()
                end)
                
                if success then
                    print(remote.Name .. " invoked successfully!")
                else
                    warn("Failed to invoke " .. remote.Name .. ": " .. tostring(result))
                end
            else
                warn(remote.Name .. " is neither a RemoteEvent nor a RemoteFunction!")
            end
        end
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
