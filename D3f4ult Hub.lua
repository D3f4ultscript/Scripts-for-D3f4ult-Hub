-- D3f4ult Hub Games
local gameScripts = {
    [3956818381] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Ninja%20Legends.lua", -- Ninja Legends
	[189707] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Natural%20Disaster.lua", -- Natural Disaster
	[8540346411] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Rebirth%20Champions.lua", -- Rebirth Champions
	[155615604] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Prisone%20Life.lua", -- Prisone Life
	[105964308474851] = "@https://raw.githubusercontent.com/hannes12334/Roblox-Scripts/refs/heads/main/Clicker%20Master.lua", -- Clicker Master
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
	[85896571713843] = "@https://raw.githubusercontent.com/D3f4ultscript/Scripts-for-D3f4ult-Hub/refs/heads/main/Bubble%20Gum%20Infinite.lua", -- Bubble Gum Simulator INFINITY
	[136218655830988] = "@https://raw.githubusercontent.com/D3f4ultscript/Scripts-for-D3f4ult-Hub/refs/heads/main/Clicker%20Madness.lua", -- Clicker Madness
}

-- Function to print supported games
local function printSupportedGames()
    print("\n[🟣] D3f4ult Hub - Supported Games:")
    print("----------------------------------------")
    for gameId, scriptUrl in pairs(gameScripts) do
        local gameName = scriptUrl:match("/([^/]+)%.lua$")
        if gameName then
            gameName = gameName:gsub("%%20", " ")
            print("• " .. gameName)
        end
    end
    print("----------------------------------------\n")
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
Frame.Size = UDim2.new(0, 280, 0, 90)
Frame.Position = UDim2.new(0.5, -140, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1
Frame.Parent = ScreenGui

-- Create outer shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.ZIndex = 0
Shadow.Parent = Frame

-- Add corner radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

-- Create gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 60))
})
Gradient.Rotation = 45
Gradient.Parent = Frame

-- Create button
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9, 0, 0.7, 0)
Button.Position = UDim2.new(0.5, 0, 0.5, 0)
Button.AnchorPoint = Vector2.new(0.5, 0.5)
Button.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
Button.BorderSizePixel = 0
Button.Text = "[🌈] Random Easy Obby\n(15)"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 20
Button.TextWrapped = true
Button.Parent = Frame
Button.ZIndex = 2

-- Add inner stroke to button
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 170)
Stroke.Thickness = 2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Parent = Button

-- Add corner radius to button
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = Button

-- Create button gradient
local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 100))
})
ButtonGradient.Rotation = 90
ButtonGradient.Parent = Button

-- Create glow effect
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 30, 1, 30)
Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://6014261993"
Glow.ImageColor3 = Color3.fromRGB(0, 255, 170)
Glow.ImageTransparency = 0.8
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(49, 49, 450, 450)
Glow.ZIndex = 1
Glow.Parent = Button

-- Add title text
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, -30)
Title.BackgroundTransparency = 1
Title.Text = "My Game"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

-- Add hover effect
Button.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 210, 140)}):Play()
    game:GetService("TweenService"):Create(Glow, TweenInfo.new(0.2), {ImageTransparency = 0.7}):Play()
    game:GetService("TweenService"):Create(Stroke, TweenInfo.new(0.2), {Thickness = 3}):Play()
end)

Button.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 120)}):Play()
    game:GetService("TweenService"):Create(Glow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
    game:GetService("TweenService"):Create(Stroke, TweenInfo.new(0.2), {Thickness = 2}):Play()
end)

-- Countdown timer
local countdown = 15
local timerConnection
local lastUpdate = tick()

local function updateTimer()
    local currentTime = tick()
    if currentTime - lastUpdate >= 1 then
        countdown = countdown - 1
        Button.Text = "[🌈] Random Easy Obby\n(" .. countdown .. ")"
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
        TeleportService:Teleport(137852729354076)
    end)
    
    if not success then
        warn("Teleport failed:", errorMessage)
    end
end)

for gameId, scriptUrl in pairs(gameScripts) do
    if currentGameId == gameId then
        isSupported = true
        
        -- Show notification that game is supported
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "D3f4ult Hub",
            Text = "Game is supported! Script loading...",
            Duration = 5,
            Icon = "rbxassetid://120297272178745"
        })
        
        -- Wait 2 seconds before loading script
        wait(2)
        
        local url = scriptUrl:gsub("^@", "")
        loadstring(game:HttpGet(url))()
        break
    end
end

-- Show message if game is not supported
if not isSupported then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Info",
        Text = "Game is not Supportet!",
        Duration = 5,
        Icon = "rbxassetid://120297272178745"
    })
    
    -- Add second notification
    wait(0.5)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Info",
        Text = "Press [F9] to see supported games!",
        Duration = 5,
        Icon = "rbxassetid://120297272178745"
    })
    
    -- Print supported games after 2 seconds
    wait(2)
    printSupportedGames()
end 