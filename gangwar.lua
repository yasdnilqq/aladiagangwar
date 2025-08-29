--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]

-- https://scriptblox.com/script/Universal-Script-N00BKIDS-jumpscare-42046


local realmscare = Instance.new("ScreenGui")
local ImageLabel = Instance.new("ImageLabel")
local framefrrfr = Instance.new("Frame")
local PercentageBar = Instance.new("ImageLabel")
local Label = Instance.new("TextLabel")
local Frame = Instance.new("ImageLabel")
local TextLabel = Instance.new("TextLabel")
local TextLabel_2 = Instance.new("TextLabel")
local TextLabel_3 = Instance.new("TextLabel")

--Properties:

realmscare.Name = "realm-scare"
realmscare.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
realmscare.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
realmscare.ResetOnSpawn = false

ImageLabel.Parent = realmscare
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
ImageLabel.Position = UDim2.new(0, 0, -0.0335968398, 0)
ImageLabel.Size = UDim2.new(1, 0, 1.03359687, 0)
ImageLabel.Image = "http://www.roblox.com/asset/?id=10545695322"


-- Scripts:

local function RGEBY_fake_script() -- ImageLabel.killoollsa 
	local script = Instance.new('LocalScript', ImageLabel)

	local tubers93		= Instance.new("Sound")
	tubers93.Parent		= game:GetService("Workspace")
	tubers93.SoundId		= "http://www.roblox.com/asset/?id=6863021504"
	tubers93.Playing		= true
	tubers93.Looped		= false
	tubers93.Volume		= 10
	tubers93.Pitch		= 0.7
	wait(6)
	script.Parent.Parent:Destroy()
end
coroutine.wrap(RGEBY_fake_script)()
