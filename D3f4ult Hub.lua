-- D3f4ult Hub Games
local gameScripts = {
    [3956818381] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Ninja%20Legends.lua", -- Ninja Legends
	[189707] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Natural%20Disaster.lua", -- Natural Disaster
	[8540346411] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Rebirth%20Champions.lua", -- Rebirth Champions
	[155615604] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Prisone%20Life.lua", -- Prisone Life
	[14031683009] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Clicker%20Master.lua", -- Clicker Master
	[4483381587] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/a%20literal%20baseplate.lua", -- a literal baseplate
	[87854376962069] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/The%201000000%20Glass%20Bridge.lua", -- The 1000000 Glass Bridge
	[205224386] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Hide%20and%20Seek%20Extreme.lua", -- Hide and Seek Extreme
	[94640462621211] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Pet%20Hatching%20Simulator%2099.lua", -- Pet Hatching Simsulator 99
	[7993293100] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Tsunami%20Game.lua", -- Tsunami Game
	[17541425510] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Tap%20Game.lua", -- Tap Game
	[70876832253163] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Dead%20Rails.lua", -- Dead Rails
	[79168182002922] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Pet%20Clickers%20X.lua", -- Pet Clickers X
	[8200787440] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Eat%20Blobs.lua", -- Eat Blobs
	[11040063484] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Sword%20Fighters%20Simulator.lua", -- Sword Fighters Simulator
	[114691972591212] = "@https://raw.githubusercontent.com/D3f4ultscript/Scripts-for-D3f4ult-Hub/refs/heads/main/Tap%20Topia%20Reborn.lua", -- Tap Topia Reborn
	[76764413804358] = "@https://raw.githubusercontent.com/D3f4ultscript/Scripts-for-D3f4ult-Hub/refs/heads/main/Bubble%20Gum%20Infinite.lua", -- Bubble Gum Simulator INFINITY
}

-- The correct key
local correctKey = "D3F4ULT-KEY-njokgbfdskjhb97826345"

-- Whitelisted users (add usernames here)
local whitelistedUsers = {
    "tt_g1212",
    "hanns_boooy",
	"tt_g1313",
	"tt_g1414",
	"OfficerPewP3w",
	"tt_g1616",
    -- Add more usernames here
}

-- Function to check if user is whitelisted
local function isUserWhitelisted(username)
    for _, whitelistedUser in ipairs(whitelistedUsers) do
        if username:lower() == whitelistedUser:lower() then
            return true
        end
    end
    return false
end

-- Get current player's username
local player = game:GetService("Players").LocalPlayer
local currentUsername = player.Name

-- Check if current game is supported
local currentGameId = game.PlaceId
local isSupported = false

-- Create Teleport Button
local TeleportService = game:GetService("TeleportService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 80)
Frame.Position = UDim2.new(0.5, -125, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.2
Frame.Parent = ScreenGui

-- Add corner radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Button.BorderSizePixel = 0
Button.Text = "Teleport to\nJust a Game\n(10)"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 20
Button.TextWrapped = true
Button.Parent = Frame

-- Add corner radius to button
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 12)
ButtonCorner.Parent = Button

-- Add hover effect
Button.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
end)

Button.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 0)}):Play()
end)

-- Countdown timer
local countdown = 10
local timerConnection
local lastUpdate = tick()

local function updateTimer()
    local currentTime = tick()
    if currentTime - lastUpdate >= 1 then
        countdown = countdown - 1
        Button.Text = "Teleport to\nJust a Game\n(" .. countdown .. ")"
        lastUpdate = currentTime
        
        if countdown <= 0 then
            if timerConnection then
                timerConnection:Disconnect()
            end
            ScreenGui:Destroy()
        end
    end
end

timerConnection = game:GetService("RunService").Heartbeat:Connect(updateTimer)

Button.MouseButton1Click:Connect(function()
    local success, errorMessage = pcall(function()
        TeleportService:Teleport(131849657049215)
    end)
    
    if not success then
        warn("Teleport failed:", errorMessage)
    end
end)

for gameId, scriptUrl in pairs(gameScripts) do
    if currentGameId == gameId then
        isSupported = true
        local url = scriptUrl:gsub("^@", "")
        
        -- Create a key verification GUI
        local ScreenGui = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local KeyBox = Instance.new("TextBox")
        local SubmitButton = Instance.new("TextButton")
        local StatusLabel = Instance.new("TextLabel")
        local CloseButton = Instance.new("TextButton")
        
        -- Set ScreenGui properties
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- Set Frame properties
        Frame.Parent = ScreenGui
        Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Frame.BorderSizePixel = 0
        Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
        Frame.Size = UDim2.new(0, 300, 0, 200)
        
        -- Set Title properties
        Title.Parent = Frame
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 0, 0, 10)
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Font = Enum.Font.SourceSansBold
        Title.Text = "D3f4ult - Hub ︱ Key System"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 24
        
        -- Set CloseButton properties
        CloseButton.Parent = Frame
        CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        CloseButton.BorderSizePixel = 0
        CloseButton.Position = UDim2.new(1, -25, 0, 5)
        CloseButton.Size = UDim2.new(0, 20, 0, 20)
        CloseButton.Font = Enum.Font.SourceSansBold
        CloseButton.Text = "X"
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.TextSize = 14
        
        -- Set KeyBox properties
        KeyBox.Parent = Frame
        KeyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        KeyBox.BorderSizePixel = 0
        KeyBox.Position = UDim2.new(0.5, -125, 0.5, -20)
        KeyBox.Size = UDim2.new(0, 250, 0, 40)
        KeyBox.Font = Enum.Font.SourceSans
        KeyBox.PlaceholderText = "Enter Key Here..."
        KeyBox.Text = ""
        KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyBox.TextSize = 18
        
        -- Set SubmitButton properties
        SubmitButton.Parent = Frame
        SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        SubmitButton.BorderSizePixel = 0
        SubmitButton.Position = UDim2.new(0.5, -75, 0.5, 30)
        SubmitButton.Size = UDim2.new(0, 150, 0, 40)
        SubmitButton.Font = Enum.Font.SourceSansBold
        SubmitButton.Text = "Submit"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.TextSize = 18
        
        -- Set StatusLabel properties
        StatusLabel.Parent = Frame
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Position = UDim2.new(0, 0, 0.5, 80)
        StatusLabel.Size = UDim2.new(1, 0, 0, 20)
        StatusLabel.Font = Enum.Font.SourceSans
        StatusLabel.Text = ""
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusLabel.TextSize = 16
        
        -- Setup CloseButton functionality
        CloseButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        
        -- Function to load the script
        local function loadScript()
            StatusLabel.Text = "Key correct! Loading script..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            -- Wait a moment before closing the GUI and loading script
            wait(1.5)
            ScreenGui:Destroy()
            
            -- Load and execute the script
            loadstring(game:HttpGet(url))()
        end
        
        -- Check if user is whitelisted
        if isUserWhitelisted(currentUsername) then
            KeyBox.Text = correctKey
            loadScript()
        end
        
        -- Setup SubmitButton functionality
        SubmitButton.MouseButton1Click:Connect(function()
            local keyInput = KeyBox.Text
            
            if keyInput == correctKey then
                loadScript()
            else
                StatusLabel.Text = "Invalid key! Try again."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end)
        
        break
    end
end

-- Show message if game is not supported
if not isSupported then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Info",
        Text = "Game is not Supportet!",
        Duration = 5
    })
end 