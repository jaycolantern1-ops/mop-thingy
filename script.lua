-- Script placed inside your NPC model

local ProximityPromptService = game:GetService("ProximityPromptService")  
local Players = game:GetService("Players")

local npc = script.Parent  
local humanoid = npc:WaitForChild("Humanoid")

local cleaningRange = 5 -- Adjust as needed  
local cleaningSpeed = 16 -- Adjust as needed

local isCleaning = false  
local proximityPrompt

-- Function to find the nearest spill  
local function findNearestSpill()  
    local spills = {}  
    for i, v in pairs(workspace:GetDescendants()) do  
        if v:IsA("ProximityPrompt") and v.Triggered then  
            table.insert(spills, v)  
        end  
    end

    local nearestSpill = nil  
    local shortestDistance = math.huge

    for _, spill in pairs(spills) do  
        local distance = (npc.HumanoidRootPart.Position - spill.Parent.Position).Magnitude  
        if distance < shortestDistance then  
            shortestDistance = distance  
            nearestSpill = spill  
        end  
    end

    return nearestSpill  
end

-- Function to clean a spill  
local function cleanSpill(spill)  
    if spill and spill.Parent then  
        spill.Parent:Destroy()  
        print("Cleaned a spill!")  
    end  
end

-- Function to handle cleaning  
local function handleCleaning()  
    if isCleaning then return end

    isCleaning = true

    while isCleaning do  
        local nearestSpill = findNearestSpill()  
        if nearestSpill then  
            local path = humanoid:getPathTo(nearestSpill.Parent.Position)  
            if path then  
                humanoid:MoveTo(nearestSpill.Parent.Position)

                -- Wait until the NPC is close enough to clean  
                local distance = (npc.HumanoidRootPart.Position - nearestSpill.Parent.Position).Magnitude  
                if distance <= cleaningRange then  
                    cleanSpill(nearestSpill)  
                    wait(1) -- Add a small delay before searching for the next spill  
                end  
            else  
                print("No path found.")  
                break  
            end  
        else  
            print("No spills found.")  
            isCleaning = false  
        end  
        wait(0.1)  
    end  
end

-- Create the ScreenGui  
local screenGui = Instance.new("ScreenGui")  
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")  
screenGui.Name = "CleaningGUI"

local toggleButton = Instance.new("TextButton")  
toggleButton.Parent = screenGui  
toggleButton.Size = Vector2.new(150, 50)  
toggleButton.Position = Vector2.new(10, 10)  
toggleButton.Text = "Start Cleaning"  
toggleButton.BackgroundColor3 = Color3.new(0, 0, 0)  
toggleButton.TextColor3 = Color3.new(1, 1, 1)

toggleButton.MouseButton1Click:Connect(function()  
    if isCleaning then  
        isCleaning = false  
        toggleButton.Text = "Start Cleaning"  
    else  
        isCleaning = true  
        toggleButton.Text = "Stop Cleaning"  
        handleCleaning()  
    end  
end)  
