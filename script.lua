local player = game.Players.LocalPlayer  
local character = player.Character or player.CharacterAdded:Wait()  
local rootpart = character:WaitForChild("HumanoidRootPart")

local mop = nil  
local isMopEquipped = false

local walkSpeed = 16 --default walkspeed

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)  
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.E then -- change to desired key  
        if not isMopEquipped then  
            -- find the mop  
            for i, v in pairs(workspace:GetDescendants()) do  
                if v:IsA("BasePart") and v.Name:Lower() == "mop" then  
                    mop = v  
                    break  
                end  
            end

            if mop then  
                -- equip the mop  
                mop:SetParent(rootpart)  
                mop:SetPrimaryPartCFrame(rootpart.CFrame * CFrame.new(0, -1.5, 0)) --adjust position as needed  
                isMopEquipped = true  
                print("mop equipped")  
                walkSpeed = 8 -- slower walkspeed with mop  
                player.Character.Humanoid.WalkSpeed = walkSpeed

            else  
                print("mop not found")  
            end  
        else  
            -- unequip the mop  
            mop:SetParent(workspace)  
            mop:SetPrimaryPartCFrame(CFrame.new(-130.355, -8.19496, 101.217)) -- original position  
            isMopEquipped = false  
            print("mop unequipped")  
            walkSpeed = 16 -- reset walkspeed  
            player.Character.Humanoid.WalkSpeed = walkSpeed  
        end  
    end  
end)  
