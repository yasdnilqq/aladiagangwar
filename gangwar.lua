_G.Settings = {
    ["key"] = _G.Key,
    ["site"] = "https://raw.githubusercontent.com/yasdnilqq/Bnk/refs/heads/main/keys.json",
    ["text"] = "You're not whitelisted";
}
local abc = game:HttpGet(_G.Settings.site .. _G.Settings.key)
if abc == "true" then
print("Whitelisted")
elseif abc == "false" then
print(_G.Settings.text)
else
print("Unknown response")
end

--// Loaded Check
if BNKONTOPLoaded or BNKONTOPLoading or BNK then
	return
end

getgenv().BNKONTOPLoading = true

--// Cache & Log Blocker
local function blockLogs()
    local oldPrint, oldWarn, oldError = print, warn, error
    print = function(...) end
    warn = function(...) end
    error = function(...) end
    rconsoleprint = function(...) end
    rconsolewarn = function(...) end
    rconsoleerr = function(...) end
end
blockLogs()

--// Patch GuiService:AddSelectionParent (dummy to prevent errors)
local GuiService = game:GetService("GuiService")
if not GuiService.AddSelectionParent then
    function GuiService:AddSelectionParent(name, frame)
        warn("[Patch] Blocked AddSelectionParent call for:", name)
        return
    end
end

--// Aliases
local loadstring, typeof, select, next, pcall = loadstring, typeof, select, next, pcall
local tablefind, tablesort = table.find, table.sort
local mathfloor = math.floor
local stringgsub = string.gsub
local wait, delay, spawn = task.wait, task.delay, task.spawn
local osdate = os.date

--// Load External Libraries
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Roblox-Functions-Library/main/Library.lua"))()
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yasdnilqq/aladiagangwar/refs/heads/main/BNKONTOPLIBLARIES.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()

--// Variables

local MainFrame = GUI:Load()

local ESP_DeveloperSettings = ESP.DeveloperSettings
local ESP_Settings = ESP.Settings
local ESP_Properties = ESP.Properties
local Crosshair = ESP_Properties.Crosshair
local CenterDot = Crosshair.CenterDot

local Aimbot_DeveloperSettings = Aimbot.DeveloperSettings
local Aimbot_Settings = Aimbot.Settings
local Aimbot_FOV = Aimbot.FOVSettings

ESP_Settings.LoadConfigOnLaunch = false
ESP_Settings.Enabled = false
Crosshair.Enabled = false
Aimbot_Settings.Enabled = false

local Fonts = {"UI", "System", "Plex", "Monospace"}
local TracerPositions = {"Bottom", "Center", "Mouse"}
local HealthBarPositions = {"Top", "Bottom", "Left", "Right"}

--// Tabs

local General, GeneralSignal = MainFrame:Tab("General")
local _Aimbot = MainFrame:Tab("Aimbot")
local _ESP = MainFrame:Tab("ESP")
local _SKIN = MainFrame:Tab("SKIN HACK")
local Settings = MainFrame:Tab("Settings")

--// Functions

local AddValues = function(Section, Object, Exceptions, Prefix)
	local Keys, Copy = {}, {}

	for Index, _ in next, Object do
		Keys[#Keys + 1] = Index
	end

	tablesort(Keys, function(A, B)
		return A < B
	end)

	for _, Value in next, Keys do
		Copy[Value] = Object[Value]
	end

	for Index, Value in next, Copy do
		if typeof(Value) ~= "boolean" or (Exceptions and tablefind(Exceptions, Index)) then
			continue
		end

		Section:Toggle({
			Name = stringgsub(Index, "(%l)(%u)", function(...)
				return select(1, ...).." "..select(2, ...)
			end),
			Flag = Prefix..Index,
			Default = Value,
			Callback = function(_Value)
				Object[Index] = _Value
			end
		})
	end

	for Index, Value in next, Copy do
		if typeof(Value) ~= "Color3" or (Exceptions and tablefind(Exceptions, Index)) then
			continue
		end

		Section:Colorpicker({
			Name = stringgsub(Index, "(%l)(%u)", function(...)
				return select(1, ...).." "..select(2, ...)
			end),
			Flag = Index,
			Default = Value,
			Callback = function(_Value)
				Object[Index] = _Value
			end
		})
	end
end

--// General Tab

local AimbotSection = General:Section({
	Name = "Aimbot Settings",
	Side = "Left"
})

local ESPSection = General:Section({
	Name = "ESP Settings",
	Side = "Right"
})

local ESPDeveloperSection = General:Section({
	Name = "ESP Developer Settings",
	Side = "Right"
})

AddValues(ESPDeveloperSection, ESP_DeveloperSettings, {}, "ESP_DeveloperSettings_")

ESPDeveloperSection:Dropdown({
	Name = "Update Mode",
	Flag = "ESP_UpdateMode",
	Content = {"RenderStepped", "Stepped", "Heartbeat"},
	Default = ESP_DeveloperSettings.UpdateMode,
	Callback = function(Value)
		ESP_DeveloperSettings.UpdateMode = Value
	end
})

ESPDeveloperSection:Dropdown({
	Name = "Team Check Option",
	Flag = "ESP_TeamCheckOption",
	Content = {"TeamColor", "Team"},
	Default = ESP_DeveloperSettings.TeamCheckOption,
	Callback = function(Value)
		ESP_DeveloperSettings.TeamCheckOption = Value
	end
})

ESPDeveloperSection:Slider({
	Name = "Rainbow Speed",
	Flag = "ESP_RainbowSpeed",
	Default = ESP_DeveloperSettings.RainbowSpeed * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		ESP_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

ESPDeveloperSection:Slider({
	Name = "Width Boundary",
	Flag = "ESP_WidthBoundary",
	Default = ESP_DeveloperSettings.WidthBoundary * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		ESP_DeveloperSettings.WidthBoundary = Value / 10
	end
})

ESPDeveloperSection:Button({
	Name = "Refresh",
	Callback = function()
		ESP:Restart()
	end
})

AddValues(ESPSection, ESP_Settings, {"LoadConfigOnLaunch", "PartsOnly"}, "ESPSettings_")

AimbotSection:Toggle({
	Name = "Enabled",
	Flag = "Aimbot_Enabled",
	Default = Aimbot_Settings.Enabled,
	Callback = function(Value)
		Aimbot_Settings.Enabled = Value
	end
})

AddValues(AimbotSection, Aimbot_Settings, {"Enabled", "Toggle", "OffsetToMoveDirection"}, "Aimbot_")

local AimbotDeveloperSection = General:Section({
	Name = "BNK ON TOP",
	Side = "Left"
})

--// Aimbot Tab

local Players = game:GetService("Players")

-- Function to handle a player's character
local function setupCharacter(player, char)
    -- Wait for important parts
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)

    if hrp and hum then
        print("[Aimbot] Character ready:", player.Name)
        -- Store reference for aimbot system
        -- Example: ESP/Aimbot targeting
        -- Aimbot.Targets[player] = hrp
    end
end

-- Function to setup one player (on join & respawn)
local function setupPlayer(player)
    -- If already spawned
    if player.Character then
        setupCharacter(player, player.Character)
    end
    -- Connect respawn
    player.CharacterAdded:Connect(function(char)
        setupCharacter(player, char)
    end)
end

-- Setup for existing players
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= Players.LocalPlayer then
        setupPlayer(plr)
    end
end

-- Setup for new players
Players.PlayerAdded:Connect(function(plr)
    if plr ~= Players.LocalPlayer then
        setupPlayer(plr)
    end
end)

local AimbotPropertiesSection = _Aimbot:Section({
	Name = "Properties",
	Side = "Left"
})

AimbotPropertiesSection:Toggle({
	Name = "Toggle",
	Flag = "Aimbot_Toggle",
	Default = Aimbot_Settings.Toggle,
	Callback = function(Value)
		Aimbot_Settings.Toggle = Value
	end
})

AimbotPropertiesSection:Slider({
	Name = "Animation Sensitivity (ms)",
	Flag = "Aimbot_Sensitivity",
	Default = Aimbot_Settings.Sensitivity * 100,
	Min = 0,
	Max = 100,
	Callback = function(Value)
		Aimbot_Settings.Sensitivity = Value / 100
	end
})

AimbotPropertiesSection:Slider({
	Name = "mousemoverel Sensitivity",
	Flag = "Aimbot_Sensitivity2",
	Default = Aimbot_Settings.Sensitivity2 * 100,
	Min = 0,
	Max = 500,
	Callback = function(Value)
		Aimbot_Settings.Sensitivity2 = Value / 100
	end
})

AimbotPropertiesSection:Dropdown({
	Name = "Lock Mode",
	Flag = "Aimbot_Settings_LockMode",
	Content = {"CFrame", "mousemoverel"},
	Default = Aimbot_Settings.LockMode == 1 and "CFrame" or "mousemoverel",
	Callback = function(Value)
		Aimbot_Settings.LockMode = Value == "CFrame" and 1 or 2
	end
})

AimbotPropertiesSection:Dropdown({
	Name = "Lock Part",
	Flag = "Aimbot_LockPart",
	Content = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"},
	Default = Aimbot_Settings.LockPart,
	Callback = function(Value)
		Aimbot_Settings.LockPart = Value
	end
})

AimbotPropertiesSection:Keybind({
	Name = "Trigger Key",
	Flag = "Aimbot_TriggerKey",
	Default = Aimbot_Settings.TriggerKey,
	Callback = function(Keybind)
		Aimbot_Settings.TriggerKey = Keybind
	end
})

local AimbotFOVSection = _Aimbot:Section({
	Name = "Field Of View Settings",
	Side = "Right"
})

AddValues(AimbotFOVSection, Aimbot_FOV, {}, "Aimbot_FOV_")

AimbotFOVSection:Slider({
	Name = "Field Of View",
	Flag = "Aimbot_FOV_Radius",
	Default = Aimbot_FOV.Radius,
	Min = 0,
	Max = 720,
	Callback = function(Value)
		Aimbot_FOV.Radius = Value
	end
})

AimbotFOVSection:Slider({
	Name = "Sides",
	Flag = "Aimbot_FOV_NumSides",
	Default = Aimbot_FOV.NumSides,
	Min = 3,
	Max = 60,
	Callback = function(Value)
		Aimbot_FOV.NumSides = Value
	end
})

AimbotFOVSection:Slider({
	Name = "Transparency",
	Flag = "Aimbot_FOV_Transparency",
	Default = Aimbot_FOV.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		Aimbot_FOV.Transparency = Value / 10
	end
})

AimbotFOVSection:Slider({
	Name = "Thickness",
	Flag = "Aimbot_FOV_Thickness",
	Default = Aimbot_FOV.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		Aimbot_FOV.Thickness = Value
	end
})

--// KillFx References
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local KillFx = ReplicatedStorage:WaitForChild("Resources"):WaitForChild("KillFx")
local SP = KillFx:WaitForChild("SP")
local CombatP = KillFx:WaitForChild("Combat_P")
local killEvent = ReplicatedStorage:WaitForChild("Blaster"):WaitForChild("Remotes"):WaitForChild("ReplicateKill")

local selectedEffect = nil

--// Kill Effect Play Function
local function playKillEffect(effectObj, targetChar)
    if not effectObj or not targetChar then return end
    local head = targetChar:FindFirstChild("Head") or targetChar:FindFirstChildWhichIsA("BasePart")
    if not head then return end

    local effect = effectObj:Clone()
    effect.Parent = workspace

    if effect:IsA("Model") then
        if not effect.PrimaryPart then
            for _, part in ipairs(effect:GetChildren()) do
                if part:IsA("BasePart") then
                    effect.PrimaryPart = part
                    break
                end
            end
        end
        if effect.PrimaryPart then
            effect:SetPrimaryPartCFrame(head.CFrame)
        end
    else
        effect.Parent = head
    end

    for _, d in ipairs(effect:GetDescendants()) do
        if d:IsA("Sound") then d:Play() end
    end

    game:GetService("Debris"):AddItem(effect, 5)
end

--// KillFx References
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local KillFx = ReplicatedStorage:WaitForChild("Resources"):WaitForChild("KillFx")
local SP = KillFx:WaitForChild("SP")
local CombatP = KillFx:WaitForChild("Combat_P")
local Pistol = KillFx:WaitForChild("Pistol")
local Pistol50 = KillFx:WaitForChild("Pistol .50")
local killEvent = ReplicatedStorage:WaitForChild("Blaster"):WaitForChild("Remotes"):WaitForChild("ReplicateKill")

local selectedEffect = nil

--// Kill Effect Play Function
local function playKillEffect(effectObj, targetChar)
    if not effectObj or not targetChar then return end
    local head = targetChar:FindFirstChild("Head") or targetChar:FindFirstChildWhichIsA("BasePart")
    if not head then return end

    local effect = effectObj:Clone()
    effect.Parent = workspace

    if effect:IsA("Model") then
        if not effect.PrimaryPart then
            for _, part in ipairs(effect:GetChildren()) do
                if part:IsA("BasePart") then
                    effect.PrimaryPart = part
                    break
                end
            end
        end
        if effect.PrimaryPart then
            effect:SetPrimaryPartCFrame(head.CFrame)
        end
    else
        effect.Parent = head
    end

    for _, d in ipairs(effect:GetDescendants()) do
        if d:IsA("Sound") then d:Play() end
    end

    game:GetService("Debris"):AddItem(effect, 5)
end

--// KillFx References
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local KillFx = ReplicatedStorage:WaitForChild("Resources"):WaitForChild("KillFx")
local SP = KillFx:WaitForChild("SP")
local CombatP = KillFx:WaitForChild("Combat_P")
local Pistol = KillFx:WaitForChild("Pistol")
local Pistol50 = KillFx:WaitForChild("Pistol .50")
local killEvent = ReplicatedStorage:WaitForChild("Blaster"):WaitForChild("Remotes"):WaitForChild("ReplicateKill")

local selectedEffect = nil

--// Kill Effect Play Function
local function playKillEffect(effectObj, targetChar)
    if not effectObj or not targetChar then return end
    local head = targetChar:FindFirstChild("Head") or targetChar:FindFirstChildWhichIsA("BasePart")
    if not head then return end

    local effect = effectObj:Clone()
    effect.Parent = workspace

    if effect:IsA("Model") then
        if not effect.PrimaryPart then
            for _, part in ipairs(effect:GetChildren()) do
                if part:IsA("BasePart") then
                    effect.PrimaryPart = part
                    break
                end
            end
        end
        if effect.PrimaryPart then
            effect:SetPrimaryPartCFrame(head.CFrame)
        end
    else
        effect.Parent = head
    end

    for _, d in ipairs(effect:GetDescendants()) do
        if d:IsA("Sound") then d:Play() end
    end

    game:GetService("Debris"):AddItem(effect, 5)
end

--// Kill Event Listener
killEvent.OnClientEvent:Connect(function(killerName, victimName)
    if killerName == LocalPlayer.Name and selectedEffect then
        local victim = Players:FindFirstChild(victimName)
        if victim and victim.Character then
            playKillEffect(selectedEffect, victim.Character)
        end
    end
end)

--// Helper: Collect skins + add a "Default"
local function getSkinNamesAndDefault(folder)
    local names = {"Default"}
    for _, skin in ipairs(folder:GetChildren()) do
        table.insert(names, skin.Name)
    end
    table.sort(names, function(a, b)
        if a == "Default" then return true end
        if b == "Default" then return false end
        return a < b
    end)
    return names, "Default"
end

--// Get skins lists
local SP_SkinNames, SP_Default = getSkinNamesAndDefault(SP)
local CP_SkinNames, CP_Default = getSkinNamesAndDefault(CombatP)
local Pistol_SkinNames, Pistol_Default = getSkinNamesAndDefault(Pistol)
local Pistol50_SkinNames, Pistol50_Default = getSkinNamesAndDefault(Pistol50)

--// Skin Hack Tab
local SkinHackSection = _SKIN:Section({
    Name = "Skin Hack",
    Side = "Left"
})

--// Scrollable Dropdown Creator with Search
local function makeDropdown(name, folder, skinList, default)
    local dropdown = SkinHackSection:Dropdown({
        Name = "Select " .. name .. " Effect",
        Flag = name .. "_KillFx",
        Content = skinList,
        Default = default,
        Callback = function(Value)
            if Value == "Default" then
                selectedEffect = folder
                warn("[KillFx] Reset to Default for " .. name)
            else
                local chosen = folder:FindFirstChild(Value)
                if chosen then
                    selectedEffect = chosen
                    warn("[KillFx] Selected " .. name .. " effect: " .. chosen.Name)
                end
            end
        end
    })

    -- add scroll + search
    task.defer(function()
        local gui = dropdown.Instance or dropdown
        if not gui or not gui:FindFirstChild("Container") then return end

        local container = gui.Container

        -- scrolling frame
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = container.Size
        scroll.Position = container.Position + UDim2.new(0,0,0,24) -- push down for search bar
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarThickness = 6
        scroll.CanvasSize = UDim2.new(0,0,0,#skinList * 28)
        scroll.Parent = gui

        -- search bar
        local search = Instance.new("TextBox")
        search.Size = UDim2.new(1, -10, 0, 20)
        search.Position = UDim2.new(0,5,0,0)
        search.PlaceholderText = "Search..."
        search.Text = ""
        search.ClearTextOnFocus = true
        search.TextSize = 14
        search.Font = Enum.Font.Gotham
        search.BackgroundColor3 = Color3.fromRGB(40,40,40)
        search.TextColor3 = Color3.fromRGB(220,220,220)
        search.Parent = gui

        local searchCorner = Instance.new("UICorner")
        searchCorner.CornerRadius = UDim.new(0,6)
        searchCorner.Parent = search

        -- move dropdown children to scroll
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then
                child.Parent = scroll
            end
        end
        container:Destroy()

        -- filtering logic
        local function applyFilter(query)
            query = string.lower(query)
            local y = 0
            for _, child in ipairs(scroll:GetChildren()) do
                if child:IsA("TextButton") then
                    if query == "" or string.find(string.lower(child.Text), query) then
                        child.Visible = true
                        child.Position = UDim2.new(0,0,0,y)
                        y += 28
                    else
                        child.Visible = false
                    end
                end
            end
            scroll.CanvasSize = UDim2.new(0,0,0,y)
        end

        search:GetPropertyChangedSignal("Text"):Connect(function()
            applyFilter(search.Text)
        end)
    end)
end

-- Create scrollable dropdowns
makeDropdown("SP", SP, SP_SkinNames, SP_Default)
makeDropdown("Combat_P", CombatP, CP_SkinNames, CP_Default)
makeDropdown("Pistol", Pistol, Pistol_SkinNames, Pistol_Default)
makeDropdown("Pistol .50", Pistol50, Pistol50_SkinNames, Pistol50_Default)




--// ESP Tab

local ESP_Properties_Section = _ESP:Section({
	Name = "ESP Properties",
	Side = "Left"
})

AddValues(ESP_Properties_Section, ESP_Properties.ESP, {}, "ESP_Propreties_")

ESP_Properties_Section:Dropdown({
	Name = "Text Font",
	Flag = "ESP_TextFont",
	Content = Fonts,
	Default = Fonts[ESP_Properties.ESP.Font + 1],
	Callback = function(Value)
		ESP_Properties.ESP.Font = Drawing.Fonts[Value]
	end
})

ESP_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "ESP_TextTransparency",
	Default = ESP_Properties.ESP.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.ESP.Transparency = Value / 10
	end
})

ESP_Properties_Section:Slider({
	Name = "Font Size",
	Flag = "ESP_FontSize",
	Default = ESP_Properties.ESP.Size,
	Min = 1,
	Max = 20,
	Callback = function(Value)
		ESP_Properties.ESP.Size = Value
	end
})

ESP_Properties_Section:Slider({
	Name = "Offset",
	Flag = "ESP_Offset",
	Default = ESP_Properties.ESP.Offset,
	Min = 10,
	Max = 30,
	Callback = function(Value)
		ESP_Properties.ESP.Offset = Value
	end
})

local Tracer_Properties_Section = _ESP:Section({
	Name = "Tracer Properties",
	Side = "Right"
})

AddValues(Tracer_Properties_Section, ESP_Properties.Tracer, {}, "Tracer_Properties_")

Tracer_Properties_Section:Dropdown({
	Name = "Position",
	Flag = "Tracer_Position",
	Content = TracerPositions,
	Default = TracerPositions[ESP_Properties.Tracer.Position],
	Callback = function(Value)
		ESP_Properties.Tracer.Position = tablefind(TracerPositions, Value)
	end
})

Tracer_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "Tracer_Transparency",
	Default = ESP_Properties.Tracer.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Tracer.Transparency = Value / 10
	end
})

Tracer_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "Tracer_Thickness",
	Default = ESP_Properties.Tracer.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Tracer.Thickness = Value
	end
})

local HeadDot_Properties_Section = _ESP:Section({
	Name = "Head Dot Properties",
	Side = "Left"
})

AddValues(HeadDot_Properties_Section, ESP_Properties.HeadDot, {}, "HeadDot_Properties_")

HeadDot_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "HeadDot_Transparency",
	Default = ESP_Properties.HeadDot.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.HeadDot.Transparency = Value / 10
	end
})

HeadDot_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "HeadDot_Thickness",
	Default = ESP_Properties.HeadDot.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.HeadDot.Thickness = Value
	end
})

HeadDot_Properties_Section:Slider({
	Name = "Sides",
	Flag = "HeadDot_Sides",
	Default = ESP_Properties.HeadDot.NumSides,
	Min = 3,
	Max = 30,
	Callback = function(Value)
		ESP_Properties.HeadDot.NumSides = Value
	end
})

local Box_Properties_Section = _ESP:Section({
	Name = "Box Properties",
	Side = "Left"
})

AddValues(Box_Properties_Section, ESP_Properties.Box, {}, "Box_Properties_")

Box_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "Box_Transparency",
	Default = ESP_Properties.Box.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Box.Transparency = Value / 10
	end
})

Box_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "Box_Thickness",
	Default = ESP_Properties.Box.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Box.Thickness = Value
	end
})

local HealthBar_Properties_Section = _ESP:Section({
	Name = "Health Bar Properties",
	Side = "Right"
})

AddValues(HealthBar_Properties_Section, ESP_Properties.HealthBar, {}, "HealthBar_Properties_")

HealthBar_Properties_Section:Dropdown({
	Name = "Position",
	Flag = "HealthBar_Position",
	Content = HealthBarPositions,
	Default = HealthBarPositions[ESP_Properties.HealthBar.Position],
	Callback = function(Value)
		ESP_Properties.HealthBar.Position = tablefind(HealthBarPositions, Value)
	end
})

HealthBar_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "HealthBar_Transparency",
	Default = ESP_Properties.HealthBar.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.HealthBar.Transparency = Value / 10
	end
})

HealthBar_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "HealthBar_Thickness",
	Default = ESP_Properties.HealthBar.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.HealthBar.Thickness = Value
	end
})

HealthBar_Properties_Section:Slider({
	Name = "Offset",
	Flag = "HealthBar_Offset",
	Default = ESP_Properties.HealthBar.Offset,
	Min = 4,
	Max = 12,
	Callback = function(Value)
		ESP_Properties.HealthBar.Offset = Value
	end
})

HealthBar_Properties_Section:Slider({
	Name = "Blue",
	Flag = "HealthBar_Blue",
	Default = ESP_Properties.HealthBar.Blue,
	Min = 0,
	Max = 255,
	Callback = function(Value)
		ESP_Properties.HealthBar.Blue = Value
	end
})

local Chams_Properties_Section = _ESP:Section({
	Name = "Chams Properties",
	Side = "Right"
})

AddValues(Chams_Properties_Section, ESP_Properties.Chams, {}, "Chams_Properties_")

Chams_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "Chams_Transparency",
	Default = ESP_Properties.Chams.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Chams.Transparency = Value / 10
	end
})

Chams_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "Chams_Thickness",
	Default = ESP_Properties.Chams.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Chams.Thickness = Value
	end
})

--// Settings Tab

local SettingsSection = Settings:Section({
	Name = "Settings",
	Side = "Left"
})

local InformationSection = Settings:Section({
	Name = "Information",
	Side = "Right"
})

SettingsSection:Keybind({
	Name = "Show / Hide GUI",
	Flag = "UI Toggle",
	Default = Enum.KeyCode.RightShift,
	Blacklist = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3},
	Callback = function(_, NewKeybind)
		if not NewKeybind then
			GUI:Close()
		end
	end
})

SettingsSection:Button({
	Name = "Unload Script",
	Callback = function()
		GUI:Unload()
		ESP:Exit()
		Aimbot:Exit()
		getgenv().BNKONTOPLoaded = nil
	end
})

InformationSection:Label("BNK ON TOP 2025"..osdate("%Y"))

InformationSection:Button({
	Name = "Copy Discord Invite",
	Callback = function()
		setclipboard("https://discord.gg/sM2tVAHNJN")
	end
})

--[=[
local MiscellaneousSection = Settings:Section({
	Name = "Miscellaneous",
	Side = "Right"
})

local TimeLabel = MiscellaneousSection:Label("...")
local FPSLabel = MiscellaneousSection:Label("...")
local PlayersLabel = MiscellaneousSection:Label("...")

MiscellaneousSection:Button({
	Name = "Rejoin",
	Callback = Rejoin
})

delay(2, function()
	spawn(function()
		while wait(1) do
			TimeLabel:Set(osdate("%c"))
			PlayersLabel:Set(#Players:GetPlayers())
		end
	end)

	RunService.RenderStepped:Connect(function(FPS)
		FPSLabel:Set("FPS: "..mathfloor(1 / FPS))
	end)
end)
]=]

--//

ESP.Load()
Aimbot.Load()
getgenv().BNKONTOPLoaded = true
getgenv().BNKONTOPLoading = nil

GeneralSignal:Fire()
GUI:Close()
