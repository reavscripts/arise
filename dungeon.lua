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
		local dungeon = false
		f:Toggle("Autofarm (TP)", function(bool) 
			dungeon = bool
		end)
		local f = w:CreateFolder("RAID")
		-- MultiPlayer toggle setup
		local dungeon2
		f:Toggle("Aura (Closest)", function(bool) 
			dungeon2 = bool
		end)

		-- Dropdown for selecting player to follow
		f:Label("Follow to farm with friend", {TextSize = 14, TextColor = Color3.fromRGB(255,255,255), BgColor = Color3.fromRGB(69,69,69)})
		local dropdown
		f:Dropdown("Follow Player1:", PLAYERS, true, function(func) 
			dropdown = func
		end)
		local function attackEnemy(v)
			local args = {
				[1] = {
					[1] = {
						["PetPos"] = {},
						["AttackType"] = "All",
						["Event"] = "Attack",
						["Enemy"] = v.Name
					},
					[2] = "\t"
				}
			}
			for _, attackType in ipairs({"\t", "\5", "\7"}) do
				args[1][2] = attackType
				game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
			end
		end

		local function weaponAttack(v)
			local args = {
				[1] = {
					[1] = {
						["Event"] = "PunchAttack",
						["Enemy"] = v.Name
					},
					[2] = "\4"
				}
			}
			game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
		end

		-- Main enemy interaction loop
		spawn(function()
			while task.wait() do
				if dungeon then
					-- Aspetta finché non ci sono nemici validi
					local foundEnemy = false
					repeat
						foundEnemy = false
						local enemies = workspace["__Main"]["__Enemies"]["Client"]:GetChildren()
						for _, v in pairs(enemies) do
							if v.ClassName == "Model" and v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("Highlight") then
								foundEnemy = true
								break
							end
						end
						if not foundEnemy then
							task.wait(1) -- aspetta un po’ prima di ricontrollare
						end
					until foundEnemy or not dungeon

					-- Ora attacca tutti i nemici validi uno per uno
					local enemies = workspace["__Main"]["__Enemies"]["Client"]:GetChildren()
					for _, v in pairs(enemies) do
						if v.ClassName == "Model" and v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("Highlight") then
							local enemyServer = workspace["__Main"]["__Enemies"]["Server"]:FindFirstChild(v.Name)
							if enemyServer then
								pcall(function()
									repeat task.wait()
										player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame - player.Character.HumanoidRootPart.CFrame.lookVector * -8
										if petdamage and not v:FindFirstChild("Highlight") then
											attackEnemy(v)
										end
										if weapondamage and v:FindFirstChild("Highlight") then
											weaponAttack(v)
										end
									until v:FindFirstChild("HealthBar").Main.Bar.Amount.Text == "0 HP" or not dungeon
								end)

								local event = arise and "EnemyCapture" or "EnemyDestroy"
								local args = {
									[1] = {
										[1] = {
											["Event"] = event,
											["Enemy"] = v.Name
										},
										[2] = "\4"
									}
								}
								game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
							end
						end
					end
				end
			end
		end)
	

		spawn(function()
			while task.wait() do
				if dungeon2 then
					closest()
				end
			end
		end)
		
local g = w:CreateFolder("Credits")
g:Label("made by reav#2966",{
    TextSize = 20;
    TextColor = Color3.fromRGB(255,255,255); 
    BgColor = Color3.fromRGB(69,69,69);
}) 
g:Label("discord.gg/8Fxnd74Eyq",{
    TextSize = 18;
    TextColor = Color3.fromRGB(255,255,255); 
    BgColor = Color3.fromRGB(69,69,69); 
}) 
g:Button("Copy Discord Link",function()
    setclipboard("https://discord.gg/8Fxnd74Eyq")
end)
