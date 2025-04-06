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

		local f = w:CreateFolder("RAID")


		local infernalCastleToggle
		f:Toggle("InfernalCastle", function(bool) 
			infernalCastleToggle = bool
		end)
		
		local function getHighestRoom()
				local highestRoom = 0
			for i = 1, 100 do
				local room = workspace.__Main.__World:FindFirstChild("Room_" .. i)
				if room then
					highestRoom = i
				end
			end
			return highestRoom
		end

		local function teleportToHighestRoom()
			local highestRoom = getHighestRoom()
			local room = workspace.__Main.__World:FindFirstChild("Room_" .. highestRoom)
			
			if room then
				player.Character:PivotTo(room:GetPivot())
				print("Teleported to Room_" .. highestRoom)
			else
				print("Highest room not available yet.")
			end
		end

		spawn(function()
			while task.wait() do
				if infernalCastleToggle then		
					for _, v in pairs(workspace["__Main"]["__Enemies"]["Client"]:GetChildren()) do
						if v.ClassName == "Model" and v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("Highlight") then
							if workspace["__Main"]["__Enemies"]["Server"]:FindFirstChild(v.Name, true) then
								pcall(function()
									repeat task.wait()
											player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame - player.Character.HumanoidRootPart.CFrame.lookVector * -8  
											closest()
									until v:FindFirstChild("HealthBar").Main.Bar.Amount.Text == "0 HP" or not infernalCastleToggle
								end)                       

								-- Controlla se tutti i nemici sono stati sconfitti
								local allEnemiesDefeated = true
								for _, v in pairs(workspace["__Main"]["__Enemies"]["Client"]:GetChildren()) do
									if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("Highlight") then
										if workspace["__Main"]["__Enemies"]["Server"]:FindFirstChild(v.Name, true) then
											if v:FindFirstChild("HealthBar").Main.Bar.Amount.Text ~= "0 HP" then
												allEnemiesDefeated = false
												break
											end
										end
									end
								end
								-- Se tutti i nemici sono sconfitti, vai alla stanza successiva
								if allEnemiesDefeated then
									teleportToHighestRoom()
								end
							end
						end
					end
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
