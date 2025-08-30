-- // Library Tables
local library = {}
local utility = {}
local obelus = {
	connections = {}
}
-- // Variables
local uis = game:GetService("UserInputService")
local cre = game:GetService("CoreGui")
-- // Indexing
library.__index = library
-- // Functions
do
	function utility:Create(createInfo)
		local createInfo = createInfo or {}
		if createInfo.Type then
			local instance = Instance.new(createInfo.Type)
			if createInfo.Properties and typeof(createInfo.Properties) == "table" then
				for property, value in pairs(createInfo.Properties) do
					instance[property] = value
				end
			end
			return instance
		end
	end
	--
	function utility:Connection(connectionInfo)
		local connectionInfo = connectionInfo or {}
		if connectionInfo.Type then
			local connection = connectionInfo.Type:Connect(connectionInfo.Callback or function() end)
			obelus.connections[#obelus.connections] = connection
			return connection
		end
	end
	--
	function utility:RemoveConnection(connectionInfo)
		local connectionInfo = connectionInfo or {}
		if connectionInfo.Connection then
			local found = table.find(obelus.connections, connectionInfo.Connection)
			if found then
				connectionInfo.Connection:Disconnect()
				table.remove(obelus.connections, found)
			end
		end
	end
end

-- // Ui Functions
do
	function library:Window(windowInfo)
		-- // Variables
		local info = windowInfo or {}
		local window = {Pages = {}, Dragging = false, Delta = UDim2.new(), Delta2 = Vector3.new()}

		-- // Utilisation
		local screen = utility:Create({Type = "ScreenGui", Properties = {
			Parent = cre,
			DisplayOrder = 8888,
			IgnoreGuiInset = true,
			Name = "obleus",
			ZIndexBehavior = "Global",
			ResetOnSpawn = false
		}})

		-- PC keybind (RightShift) hide
		game:GetService("UserInputService").InputBegan:Connect(function(k,g)
			if not g then 
				if k.KeyCode == Enum.KeyCode.RightShift then 
					screen.Enabled = not screen.Enabled 
				end
			end
		end)

		-- Mobile Hide Button
		local mobileHideButton = utility:Create({
			Type = "TextButton",
			Properties = {
				Parent = screen,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -10, 0, 10),
				Size = UDim2.new(0, 80, 0, 30),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				BorderSizePixel = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Hide UI",
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Font = Enum.Font.Code,
				TextSize = 14,
				ZIndex = 10
			}
		})

		mobileHideButton.MouseButton1Click:Connect(function()
			screen.Enabled = not screen.Enabled
			if screen.Enabled then
				mobileHideButton.Text = "Hide UI"
			else
				mobileHideButton.Text = "Show UI"
			end
		end)

		-- // Main UI Frame
		local main = utility:Create({Type = "Frame", Properties = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(51, 51, 51),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderMode = "Inset",
			BorderSizePixel = 1,
			Parent = screen,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 516, 0, 563)
		}})

        -- rest of your UI code (unchanged) --
        -- all your Frames, Tabs, Pages, Sections, Sliders, Toggles, etc.
        -- (I kept them the same, only added the Hide button above)
        -- ...

		-- // Returning
		return window
	end
end

-- // Main
local window = library:Window({name = "<font color=\"#AA55EB\">BNK ON TOP</font> | https://discord.gg/sM2tVAHNJN"})
--
local aimbot = window:Page({Name = "aimbot"})
local antiaim = window:Page({Name = "Hitbox"})
local visuals = window:Page({Name = "visuals"})
local skins = window:Page({Name = "skins"})
--
local aimbot_section = aimbot:Section({Name = "players", size = 300})
local aimbot_section2 = aimbot:Section({Name = "colored models", Side = "Right"})
--
local label = aimbot_section:Label({Name = "label hello random"})
local label2 = aimbot_section:Label({Name = "with none", Offset = 16})
local toggle = aimbot_section:Toggle({Name = "random toggle", Default = true, Callback = function(val) warn(val) end})
local slider = aimbot_section:Slider({Default = 10, Minimum = -10, Maximum = 30, Decimals = 10, Suffix = "%", Callback = function(val) warn(val) end})
local button = aimbot_section:Button({Name = "random button", Callback = function() warn("clicked") end})
local slider = aimbot_section:Slider({Name = "random slider", Callback = function(val) warn(val) end})
local slider = aimbot_section:Slider({Name = "random slider", Default = 10, Minimum = -10, Maximum = 30, Decimals = 10, Suffix = "%", Callback = function(val) warn(val) end})
local label = aimbot_section:Label({Name = "label hello random"})
local label2 = aimbot_section:Label({Name = "with none", Offset = 16})
local toggle = aimbot_section:Toggle({Name = "random toggle", Default = true, Callback = function(val) warn(val) end})
local slider = aimbot_section:Slider({Default = 10, Minimum = -10, Maximum = 30, Decimals = 10, Suffix = "%", Callback = function(val) warn(val) end})
local button = aimbot_section:Button({Name = "random button", Callback = function() warn("clicked") end})
local slider = aimbot_section:Slider({Name = "random slider", Callback = function(val) warn(val) end})
local slider = aimbot_section:Slider({Name = "random slider", Default = 10, Minimum = -10, Maximum = 30, Decimals = 10, Suffix = "%", Callback = function(val) warn(val) end})
--
aimbot:Turn(true)
-- // Returning
return library, utility, obelus
