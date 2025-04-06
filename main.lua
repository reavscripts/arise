repeat task.wait() until game:IsLoaded()
local players = game:GetService("Players")
local player = players.LocalPlayer
local worldplace = 87039211657390
local dungeonplace = 128336380114944
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3'))()
local w = library:CreateWindow(GameName)
local b = w:CreateFolder("Config")

-- Anti-AFK
local VirtualUser = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:Connect(function()
    warn("anti-afk")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

for _, v in pairs(player.Character:FindFirstChild("CharacterScripts"):GetChildren()) do
    if v.Name == "FlyingFixer" then
        v:Destroy()
    end
end
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").WalkSpeed = getgenv().Speed
    for _, v in pairs(player.Character:FindFirstChild("CharacterScripts"):GetChildren()) do
        if v.Name == "FlyingFixer" then
            v:Destroy()
            print("antitp bypassed")
        end
    end
end)

getgenv().Speed = 100
getgenv().Enabled = true
spawn(function()
    while getgenv().Enabled and task.wait() do
        players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = getgenv().Speed
    end
end)

b:Box("WalkSpeed", "number", function(value)
    getgenv().Speed = value
end)

-- ✅ UNIFICATO: un solo toggle per danni
local petdamage, weapondamage, arise = false, false, false
local autoDamage = false

b:Toggle("Auto Damage", function(bool)
    autoDamage = bool
    petdamage = bool
    weapondamage = bool
end)

b:Toggle("Arise Shadow", function(bool) arise = bool end)

b:Label("Disable Arise to Destroy", {TextSize = 16, TextColor = Color3.fromRGB(255,255,255), BgColor = Color3.fromRGB(69,69,69)})

local function sendPetAttack(enemyName)
    for _, attackCode in ipairs({"\t", "\7", "\5"}) do
        local args = {
            [1] = {
                [1] = {
                    ["PetPos"] = {},
                    ["AttackType"] = "All",
                    ["Event"] = "Attack",
                    ["Enemy"] = enemyName
                },
                [2] = attackCode
            }
        }
        game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
    end
end

local function sendWeaponAttack(enemyName)
    local args = {
        [1] = {
            [1] = {
                ["Event"] = "PunchAttack",
                ["Enemy"] = enemyName
            },
            [2] = "\4"
        }
    }
    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
end

local function handleEnemyAction(enemyName)
    local action = arise and "EnemyCapture" or "EnemyDestroy"
    local args = {
        [1] = {
            [1] = {
                ["Event"] = action,
                ["Enemy"] = enemyName
            },
            [2] = "\4"
        }
    }
    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
end

local function closest()
    for _, enemy in pairs(workspace["__Main"]["__Enemies"]["Client"]:GetChildren()) do
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
        if enemy:IsA("Model") and enemyRoot and (player.Character.HumanoidRootPart.Position - enemyRoot.Position).Magnitude < 25 then
            if petdamage and not enemy:FindFirstChild("Highlight") then
                sendPetAttack(enemy.Name)
            end
            if weapondamage and enemy:FindFirstChild("Highlight") then
                sendWeaponAttack(enemy.Name)
            end
            handleEnemyAction(enemy.Name)
        end
    end
end

local e = w:CreateFolder("World")

    world = false
    e:Toggle("AutoFarm (TP)", function(bool) world = bool end)

    spawn(function()
        while task.wait() do
            if world then		
                for _, v in pairs(workspace["__Main"]["__Enemies"]["Client"]:GetChildren()) do
                    if v.ClassName == "Model" and v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("Highlight") then
                        if workspace["__Main"]["__Enemies"]["Server"]:FindFirstChild(v.Name, true) then
                            pcall(function()
                                repeat task.wait()
                                    player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame - player.Character.HumanoidRootPart.CFrame.lookVector * -8  
									closest()
                                until v:FindFirstChild("HealthBar").Main.Bar.Amount.Text == "0 HP" or not world
                            end)                       
                        end
                    end
                end
            end
        end
    end)

    -- Nearest Aura toggle
    nearest = false
    e:Toggle("AutoFarm (Closest)", function(bool) nearest = bool end)
  
    spawn(function()
        while task.wait() do
            if nearest then closest() end
        end
    end)
	local c = w:CreateFolder("Teleport")

	local customNames = {
		SoloWorld = "1.Solo City",
		NarutoWorld = "2.Grass Village",
		OPWorld = "3.Brum Village",
		BleachWorld = "4.FaceHeal Town",
		BCWorld = "5.Lucky Kingdom",
		ChainsawWorld = "6.Nipon City",
		JojoWorld = "7.Mori Town"
	}
	local teleportLocations = {}
	for _, spawnPoint in pairs(workspace["__Extra"]["__Spawns"]:GetChildren()) do
		if spawnPoint:IsA("SpawnLocation") then
			local displayName = customNames[spawnPoint.Name] or spawnPoint.Name
			teleportLocations[displayName] = function()
				player.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPoint.Position)
			end
		end
	end
	teleportLocations["Dungeon TP"] = function()
		for _, v in pairs(workspace["__Main"]["__Dungeon"]:GetChildren()) do
			if v.ClassName == "Part" and v.Name == "Dungeon" then
				player.Character.HumanoidRootPart.CFrame = v.CFrame
			elseif v.ClassName == "Model" and v.Name == "Dungeon" then
				player.Character:PivotTo(v:GetPivot())
			end
		end
	end
	teleportLocations["Rank UP"] = function()
		player.Character.HumanoidRootPart.CFrame = workspace.__Extra.GuildTPs.Main.CFrame
		wait(1)
		player.Character:PivotTo(workspace.__Extra.__Interactions.DgTest.Test:GetPivot())
		if game:GetService("Players").LocalPlayer.PlayerGui.Menus:WaitForChild("DungeonTest") then
			local args = {
				[1] = {
					[1] = {
						["Event"] = "DungeonAction",
						["Action"] = "TestEnter"
					},
					[2] = "\n"
				}
			}
			game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
		end
	end

	teleportLocations["Guild Hall"] = function()
		player.Character.HumanoidRootPart.CFrame = workspace.__Extra.GuildTPs.Main.CFrame
		wait(1)
		player.Character:PivotTo(workspace.__Main.__World.GuildHall.Base["predio interna"]["fonte sozinha"]:GetPivot()+Vector3.new(0,5,0))
	end

	teleportLocations["Jeju Island"] = function()
		player.Character.HumanoidRootPart.CFrame = CFrame.new(4012.385498046875, 60.360130310058594, 3318.841796875)
	end

	local sortedNames = {}
	for name in pairs(teleportLocations) do
		table.insert(sortedNames, name)
	end

	table.sort(sortedNames, function(a, b) return a < b end)

	for _, name in ipairs(sortedNames) do
		c:Button(name, teleportLocations[name])
	end

	local h = w:CreateFolder("Mount TP")

	local wilds = workspace.__Main.__World:FindFirstChild("Wilds")
	if not wilds then
		warn("Wilds not found")
		return
	end

	local wildsList = {}
	for _, model in ipairs(wilds:GetChildren()) do
		if model:IsA("Model") then
			table.insert(wildsList, model)
		end
	end

	table.sort(wildsList, function(a, b)
		return a.Name < b.Name
	end)

	for index, model in ipairs(wildsList) do
		local newName = "Location " .. index
		model.Name = newName

		local targetModel = model

		h:Button(newName, function()
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") and targetModel then
				char:PivotTo(targetModel:GetPivot())
			else
				warn("HumanoidRootPart not found")
			end
		end)
	end

local StarterGui = game:GetService("StarterGui")

local g = w:CreateFolder("Credits")

g:Label("made by reav#2966", {
    TextSize = 20,
    TextColor = Color3.fromRGB(255,255,255),
    BgColor = Color3.fromRGB(69,69,69),
})

g:Label("discord.gg/8Fxnd74Eyq", {
    TextSize = 18,
    TextColor = Color3.fromRGB(255,255,255),
    BgColor = Color3.fromRGB(69,69,69),
})

g:Button("Copy Discord Link", function()
    setclipboard("https://discord.gg/8Fxnd74Eyq")
    StarterGui:SetCore("SendNotification", {
        Title = "Copied!",
        Text = "Discord link copied to clipboard.\nPaste it in your browser.",
        Duration = 5
    })
end)
