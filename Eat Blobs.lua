

-- Speed Changer


-- creating screengui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- creating frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.5  -- Transparenz hinzugefügt
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- labels
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0.3, 0)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.Text = "Speed"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.BackgroundTransparency = 1
textLabel.Parent = frame

-- textlabel
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0.3, 0)
textBox.Position = UDim2.new(0.1, 0, 0.35, 0)
textBox.Text = "50"  -- Standardwert
textBox.TextColor3 = Color3.fromRGB(0, 0, 0)
textBox.TextScaled = true
textBox.Parent = frame

-- speed button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0.3, 0)
button.Position = UDim2.new(0.1, 0, 0.7, 0)
button.Text = "Set Speed"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
button.Parent = frame

-- speed function
local function setPlayerSpeed()
    local speed = tonumber(textBox.Text)
    if speed and speed > 0 then
        -- Setze die Geschwindigkeit des Spielers
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            humanoid.WalkSpeed = speed

            -- reload all 0.1 seconds
            while true do
                wait(0.1)
                if character and character:FindFirstChild("Humanoid") then
                    humanoid.WalkSpeed = speed
                end
            end
        end
    else

        textLabel.Text = "Invalid Speed!"
        wait(2)
        textLabel.Text = "Speed"
    end
end

-- button event
button.MouseButton1Click:Connect(setPlayerSpeed)


-- Auto cellect Orbs


_G.func = true

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function notify(message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Notification";
        Text = message;
    })
end

local function findNearestOrb()
    local nearestOrb, shortestDistance = nil, math.huge
    for _, orb in ipairs(workspace.Orbs:GetChildren()) do
        local distance = (orb.Position - character.HumanoidRootPart.Position).magnitude
        if distance < shortestDistance then
            nearestOrb, shortestDistance = orb, distance
        end
    end
    return nearestOrb
end

local function moveOrbsThroughCharacter()
    -- scripts started
    notify("This script auto collects the nearest Orbs")

    -- move orbs
    while _G.func do
        local nearestOrb = findNearestOrb()
        
        if nearestOrb then
            -- move orbs trought character
            -- random move orbs
            local randomOffset = Vector3.new(
                math.random(-5, 5),  -- ⬇
                math.random(0, 10),  -- random move position
                math.random(-5, 5)   -- ⬆
            )

            -- teleports orb to random position trought player (you)
            nearestOrb.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(randomOffset)

            -- wait for next orb move
            wait()
        else
            -- wait 1 second when the scripts cant find more orbs
            wait(1)
        end
    end
end

moveOrbsThroughCharacter()

