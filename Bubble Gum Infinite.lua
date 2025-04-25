local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by D3f4ult",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BubbleGumSimulatorInfinity",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- Create Main Tab
local MainTab = Window:CreateTab("Main", "home")

-- Create Auto Bubble Section
local AutoBubbleSection = MainTab:CreateSection("Auto Bubble")

-- Auto Clicker Toggle
local AutoClickerEnabled = false
local AutoClickerConnection = nil

local AutoClickerToggle = MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClicker",
    Callback = function(Value)
        AutoClickerEnabled = Value
        
        if AutoClickerEnabled then
            -- Trenne bestehende Verbindungen
            if AutoClickerConnection then
                AutoClickerConnection:Disconnect()
                AutoClickerConnection = nil
            end
            
            -- Erstelle eine neue Verbindung
            AutoClickerConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    local args = {
                        [1] = "BlowBubble"
                    }
                    game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer(unpack(args))
                    task.wait(0.1) -- Verzögerung hinzugefügt
                end
            end)
        else
            -- Trenne die Verbindung
            if AutoClickerConnection then
                AutoClickerConnection:Disconnect()
                AutoClickerConnection = nil
            end
        end
    end
})

-- Create Auto Sell Section
local AutoSellSection = MainTab:CreateSection("Auto Sell")

-- Auto Sell Bubbles Toggle
local AutoSellEnabled = false
local AutoSellConnection = nil

local AutoSellToggle = MainTab:CreateToggle({
    Name = "Auto Sell Bubbles",
    CurrentValue = false,
    Flag = "AutoSellBubbles",
    Callback = function(Value)
        AutoSellEnabled = Value
        
        if AutoSellEnabled then
            -- Trenne bestehende Verbindungen
            if AutoSellConnection then
                AutoSellConnection:Disconnect()
                AutoSellConnection = nil
            end
            
            -- Erstelle eine neue Verbindung
            AutoSellConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    local args = {
                        [1] = "SellBubble"
                    }
                    game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer(unpack(args))
                    task.wait(0.1) -- Verzögerung hinzugefügt
                end
            end)
        else
            -- Trenne die Verbindung
            if AutoSellConnection then
                AutoSellConnection:Disconnect()
                AutoSellConnection = nil
            end
        end
    end
})

-- Create Tp Tab
local TpTab = Window:CreateTab("Tp", "map")

-- Create Teleport Section
local TpSection = TpTab:CreateSection("Locations")

-- Erstelle den neuen Button
local UnlockIslandsButton = TpTab:CreateButton({
    Name = "Inseln freischalten",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then
            print("Fehler: Charakter nicht gefunden!")
            return
        end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            print("Fehler: HumanoidRootPart nicht gefunden!")
            return
        end
        
        -- Liste der Ziel-CFrames
        local targets = {
            workspace.Worlds["The Overworld"].Islands.Twilight.Island.UnlockHitbox.CFrame,
            workspace.Worlds["The Overworld"].Islands.Zen.Island.UnlockHitbox.CFrame,
            workspace.Worlds["The Overworld"].Islands["The Void"].Island.UnlockHitbox.CFrame,
            workspace.Worlds["The Overworld"].Islands["Outer Space"].Island.UnlockHitbox.CFrame,
            workspace.Worlds["The Overworld"].Islands["Floating Island"].Island.UnlockHitbox.CFrame
        }
        
        local numIterations = 5
        
        -- Wiederhole den Teleport-Vorgang mehrmals
        for i = 1, numIterations do
            print("Starte Durchlauf " .. i .. " von " .. numIterations)
            
            -- Teleportiere zu jedem Ziel nacheinander
            for _, targetCFrame in ipairs(targets) do
                humanoidRootPart.CFrame = targetCFrame
                task.wait(0.1) -- Kurze Pause zwischen Teleports
            end
            
            print("Durchlauf " .. i .. " abgeschlossen")
        end
        
        print("Inseln freischalten abgeschlossen nach " .. numIterations .. " Durchläufen!")
    end
})

-- Create Player Tab
local PlayerTab = Window:CreateTab("Player", "user")

-- Create Speed Section
local SpeedSection = PlayerTab:CreateSection("Speed")

-- Speed Slider
local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Speed",
    Range = {1, 42},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = Value
        end
    end
})

-- Create Jump Power Section
local JumpSection = PlayerTab:CreateSection("Jump Power")

-- Jump Power Slider
local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpSlider", 
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = Value
        end
    end
})

-- Create Noclip Section
local NoclipSection = PlayerTab:CreateSection("Noclip")

-- Noclip Toggle
local NoclipToggle = PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = not Value
                end
            end
        end
    end
})

-- Create Better Scripts Tab
local BetterScriptsTab = Window:CreateTab("Better Scripts", "code")

-- Create Load Button
local LoadButton = BetterScriptsTab:CreateButton({
    Name = "Load Better Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vertex-peak/vertex/refs/heads/main/loadstring"))()
    end
})

-- Create Credits Tab
local CreditsTab = Window:CreateTab("Credits", 120297272178745)

-- Create Info Section
local InfoSection = CreditsTab:CreateSection("Information")

-- Dunkelgrau-Farbdefinition
local darkGray = Color3.fromRGB(80, 80, 80)

-- Create Made by Label
local MadeByLabel = CreditsTab:CreateLabel("Made by D3f4ult", "user", darkGray, true)

-- Create Discord Button
local DiscordButton = CreditsTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/2ynN9zcVFk")
        Rayfield:Notify({
            Title = "Discord Link",
            Content = "Discord link copied to clipboard!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- Create Session Time Section
local SessionTimeSection = CreditsTab:CreateSection("Session Time")

-- Create Session Time Label
local startTime = os.time()
local SessionTimeLabel = CreditsTab:CreateLabel("Session Time: 0m 0s", "clock", darkGray, true)

-- Update Session Time
spawn(function()
    while true do
        local elapsedTime = os.time() - startTime
        local minutes = math.floor(elapsedTime / 60)
        local seconds = elapsedTime % 60
        SessionTimeLabel:Set("Session Time: " .. minutes .. "m " .. seconds .. "s")
        wait(1)
    end
end)

-- Create Account Info Section
local AccountSection = CreditsTab:CreateSection("Account Info")

-- Get player information
local Player = game.Players.LocalPlayer
local Username = Player.Name
local DisplayName = Player.DisplayName
local AccountAge = Player.AccountAge

-- Create Account Info Labels
local UsernameLabel = CreditsTab:CreateLabel("Username: " .. Username, "user", darkGray, true)
local DisplayNameLabel = CreditsTab:CreateLabel("Display Name: " .. DisplayName, "user", darkGray, true)
local AccountAgeLabel = CreditsTab:CreateLabel("Account Age: " .. AccountAge .. " days", "calendar", darkGray, true)

-- Create Executor Info Section
local ExecutorSection = CreditsTab:CreateSection("Executor Info")

-- Get executor information
local executorInfo = {
    Name = "Unknown",
    Version = "Unknown"
}

-- Try to get executor information using common methods
local success, result = pcall(function()
    if identifyexecutor then
        return identifyexecutor()
    elseif getexecutorname then
        return getexecutorname()
    elseif KRNL_LOADED then
        return "KRNL"
    elseif syn then
        return "Synapse X"
    elseif secure_load then
        return "Sentinel"
    elseif SONA_LOADED then
        return "Sona"
    elseif FLUXUS_LOADED then
        return "Fluxus"
    elseif IS_VIVA_LOADED then
        return "Viva"
    elseif IS_ELECTRON_LOADED then
        return "Electron"
    else
        return "Unknown"
    end
end)

if success then
    executorInfo.Name = result or "Unknown"
end

-- Try to get version
local versionSuccess, versionResult = pcall(function()
    -- Synapse X
    if syn and syn.version then
        return tostring(syn.version)
    -- KRNL
    elseif KRNL_VERSION then
        return tostring(KRNL_VERSION)
    -- Fluxus
    elseif FLUXUS_VERSION then
        return tostring(FLUXUS_VERSION)
    -- Sentinel
    elseif secure_load and secure_load.version then
        return tostring(secure_load.version)
    -- JJSploit
    elseif getgenv and getgenv().JJSPLOIT_VERSION then
        return tostring(getgenv().JJSPLOIT_VERSION)
    -- Electron
    elseif IS_ELECTRON_LOADED and ELECTRON_VERSION then
        return tostring(ELECTRON_VERSION)
    -- Viva
    elseif IS_VIVA_LOADED and VIVA_VERSION then
        return tostring(VIVA_VERSION)
    -- Sona
    elseif SONA_LOADED and SONA_VERSION then
        return tostring(SONA_VERSION)
    -- Script-Ware
    elseif SW_VERSION then
        return tostring(SW_VERSION)
    -- ProtoSmasher
    elseif PROTOSMASHER_VERSION then
        return tostring(PROTOSMASHER_VERSION)
    -- Elysian
    elseif ELYSIAN_VERSION then
        return tostring(ELYSIAN_VERSION)
    -- Calamari
    elseif CALAMARI_VERSION then
        return tostring(CALAMARI_VERSION)
    -- Oxygen U
    elseif OXYGEN_VERSION then
        return tostring(OXYGEN_VERSION)
    -- Comet
    elseif COMET_VERSION then
        return tostring(COMET_VERSION)
    -- Xeno
    elseif XENO_VERSION then
        return tostring(XENO_VERSION)
    elseif getgenv and getgenv().XENO_VERSION then
        return tostring(getgenv().XENO_VERSION)
    -- Try to get version from identifyexecutor
    elseif identifyexecutor then
        local executor = identifyexecutor()
        if type(executor) == "string" and executor:find(" V") then
            return executor:match("V(.+)")
        end
        return executor
    -- Try to get version from getexecutorname
    elseif getexecutorname then
        local executor = getexecutorname()
        if type(executor) == "string" and executor:find(" V") then
            return executor:match("V(.+)")
        end
        return executor
    -- Try to get version from getversion
    elseif getversion then
        return tostring(getversion())
    -- Try to get version from _VERSION
    elseif _VERSION then
        return tostring(_VERSION)
    else
        return "Unknown"
    end
end)

if versionSuccess and versionResult then
    executorInfo.Version = versionResult
else
    executorInfo.Version = "Unknown"
end

-- Create Executor Info Labels
local ExecutorNameLabel = CreditsTab:CreateLabel("Executor: " .. executorInfo.Name, "code", darkGray, true)
local ExecutorVersionLabel = CreditsTab:CreateLabel("Version: " .. executorInfo.Version, "code", darkGray, true)

-- Initialize the UI
Rayfield:LoadConfiguration() 