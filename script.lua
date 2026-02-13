local Players = game:GetService("Players")  
local Player = Players.LocalPlayer  
local Character = Player.Character or Player.CharacterAdded:Wait()  
local Humanoid = Character:WaitForChild("Humanoid")

local spills = {} -- Table to store spill parts  
local cleaningRange = 5 -- Distance to clean spill

-- Function to find all spills  
local function findSpills()  
    for i, v in pairs(workspace:GetDescendants()) do  
        if v:IsA("BasePart") and v.Name == "Spill" then --Assuming spill part name is "Spill"  
            table.insert(spills, v)  
        end  
    end  
end

-- Function to find the nearest spill  
local function getNearestSpill()  
    local nearestSpill = nil  
    local shortestDistance = math.huge

    for i, spill in ipairs(spills) do  
        local distance = (Character.HumanoidRootPart.Position - spill.Position).Magnitude  
        if distance < shortestDistance then  
            shortestDistance = distance  
            nearestSpill = spill  
        end  
    end

    return nearestSpill  
end

-- Pathfinding function  
local function pathfindToSpill(spill)  
    local path = Humanoid:PathfindTo(spill.Position)

    if path then  
        Humanoid:MoveTo(path.Position)  
    end  
end

local cleaningEnabled = false

-- Function to toggle cleaning  
local function toggleCleaning()  
    cleaningEnabled = not cleaningEnabled  
    if cleaningEnabled then  
        print("Cleaning Enabled")  
    else  
        print("Cleaning Disabled")  
    end  
end

-- Event listener for when the player is near a spill  
Humanoid.Changed:Connect(function(property)  
    if property == "Health" then  
        --Check for cleaning  
        local nearestSpill = getNearestSpill()  
        if nearestSpill and (Character.HumanoidRootPart.Position - nearestSpill.Position).Magnitude <= cleaningRange and cleaningEnabled then  
            --Trigger the "Clean Spill" prompt.  
            --You would need to implement the actual interaction here.  
            print("Near spill! Triggering clean prompt.")  
            --Example: nearestSpill:FindFirstChild("ClickDetector").Clicked:FireServer()  
        end  
    end  
end)

findSpills()

--Create the GUI Panel  
local screenGui = Instance.new("ScreenGui")  
screenGui.Parent = Player.PlayerGui

local toggleButton = Instance.new("TextButton")  
toggleButton.Parent = screenGui  
toggleButton.Text = "Toggle Cleaning"  
toggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)  
toggleButton.Size = UDim2.new(0.2, 0, 0.05, 0)  
toggleButton.MouseButton1Click:Connect(toggleCleaning)
