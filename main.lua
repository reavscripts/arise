local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = players.LocalPlayer
local enemiesFolder = workspace.__Main.__Enemies.Client
local VirtualUser = game:service("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
local HttpService = game:GetService("HttpService")

-- Anti-AFK 
local antiAfkConnection

antiAfkConnection = LocalPlayer.Idled:Connect(function()
    warn("anti-afk triggered")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new()) -- Simulate a mouse click to prevent AFK
end)
-- Rimuove FlyingFixer
local function removeFlyingFixer()
    local char = LocalPlayer.Character
    local scripts = char and char:FindFirstChild("CharacterScripts")
    if scripts then
        for _, v in pairs(scripts:GetChildren()) do
            if v.Name == "FlyingFixer" then
                v:Destroy()
            end
        end
    end
end
removeFlyingFixer()
LocalPlayer.CharacterAdded:Connect(function()
    removeFlyingFixer()
end)

-- GUI Init
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = GameName .. " World Script",
    SubTitle = "reav's scripts",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "AutoFarm", Icon = "skull" }),
	Autofarm = Window:AddTab({ Title = "City AutoFarm", Icon = "sword" }),
	DungeonHunter = Window:AddTab({ Title = "Dungeon Hunter", Icon = "swords" }),
	Teleports = Window:AddTab({ Title = "Teleports", Icon = "wifi" }),
	GuildMaster = Window:AddTab({ Title = "Daily Donations", Icon = "eye" }),
    Discord = Window:AddTab({ Title = "Discord", Icon = "heart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Variabili di stato
local currentWalkSpeed = 80
local shadowHit = {}
-- Paths for each config file
local ariseConfigPath = "reavscripts/AriseConfig.json"
local dungeonConfigPath = "reavscripts/DungeonConfig.json"

-- States
local dungeonState = false
local ariseState = false
local autofarmState = false

-- Load arise toggle state
if isfile(ariseConfigPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(ariseConfigPath))
    end)
    if success and typeof(data) == "table" then
        ariseState = data.AriseShadow == true
    end
end
-- Load state from file
if isfile(dungeonConfigPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(dungeonConfigPath))
    end)
    if success and typeof(data) == "table" then
        dungeonState = data.AutoDungeon == true
    end
end

-- Save function
local function saveDungeonState(state)
    local config = {}

    if isfile(dungeonConfigPath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(dungeonConfigPath))
        end)
        if success and typeof(data) == "table" then
            config = data
        end
    end

    config.AutoDungeon = state

    local success, err = pcall(function()
        writefile(dungeonConfigPath, HttpService:JSONEncode(config))
    end)
    if not success then
        warn("❌ Failed to save dungeon config:", err)
    end
end


-- DUNGEON TP
Tabs.DungeonHunter:AddButton({
	Title = "Dungeon TP ⛓️",
	Description = "Teleport in a gate in your current island",
    Callback = function()
        for _, v in pairs(workspace["__Main"]["__Dungeon"]:GetChildren()) do
            if v.ClassName == "Part" and v.Name == "Dungeon" then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
            elseif v.ClassName == "Model" and v.Name == "Dungeon" then
                LocalPlayer.Character:PivotTo(v:GetPivot())
            end
        end
    end,
})

-- Toggle
DungeonToggle = Tabs.DungeonHunter:AddToggle("dungeonState", {
    Title = "🔁 Auto Dungeon No Items (AutoExecute)",
    Description = "Farm Dungeon h24 ♾️",
    Default = dungeonState,
    Callback = function(state)
        dungeonState = state
        saveDungeonState(state)
    end
})

-- Arise Toggle (for example)
AriseToggle = Tabs.Main:AddToggle("ariseState", {
    Title = "⚡ Arise Or Destroy",
    Description = "Keep disabled to destroy",
    Default = ariseState,
    Callback = function(state)
        ariseState = state
        -- Save the new state to the config file
        local toSave = {
            AriseShadow = ariseState
        }
        writefile(ariseConfigPath, HttpService:JSONEncode(toSave))
    end
})

-- Funzioni di attacco
local function getEnemyRootPart(npc)
    return npc:FindFirstChild("HumanoidRootPart")
end

local function teleportToEnemy(npc)
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local enemyHRP = getEnemyRootPart(npc)

    if hrp and enemyHRP then
        hrp.CFrame = enemyHRP.CFrame + (enemyHRP.CFrame.LookVector * 8)
    end
end

local function shadowDamage(npc)
    if not npc then return end
    
    local packets = {"\t", "\7", "\5", "\8"}
    
    -- Use a delay for each attack to avoid spamming
    for _, packet in ipairs(packets) do
        local args = {
            [1] = {
                [1] = {
                    ["PetPos"] = {},
                    ["AttackType"] = "All",
                    ["Event"] = "Attack",
                    ["Enemy"] = npc
                },
                [2] = packet
            }
        }
        
        -- Fire server with delay
        task.wait(0.1)  
        ReplicatedStorage:FindFirstChild("BridgeNet2"):FindFirstChild("dataRemoteEvent"):FireServer(unpack(args))
    end
end
local function swordDamage(npc)
    if not npc then return end  -- Early return if npc is invalid
  	local args = {
		[1] = {
			[1] = {
				["Event"] = "PunchAttack",
				["Enemy"] = npc
			},
			[2] = "\4"
		}
	}

	game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
end

local function ariseAction(npc)
    local action = ariseState and "EnemyCapture" or "EnemyDestroy"
	if not npc then return end 
	local args = {
		[1] = {
			[1] = {
				["Event"] = action,
				["Enemy"] = npc
			},
			[2] = "\4"
		}
	}

	game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
end

-- Selected NPCs reference
local selectedNPC = {}
local npcNameList = {}
local dropdownRef

local hpPriority = "Highest"

Tabs.Main:AddDropdown("HP_Priority", {
    Title = "💖 HP Priority",
    Values = { "Highest", "Lowest" },
    Multi = false,
    Default = 1,
    Callback = function(v)
        hpPriority = v
        print("✅ Farming by HP:", hpPriority)
    end
})

-- Update the dropdown without affecting specificState
local function updateDropdown()
    local enemies = workspace.__Main.__Enemies:FindFirstChild("Client")
    if not enemies then
        warn("Enemies folder not found")
        return
    end

    local seen = {}
    npcNameList = {}  -- Reset list

    for _, npc in ipairs(enemies:GetChildren()) do
        local title = npc:FindFirstChild("HealthBar")
            and npc.HealthBar:FindFirstChild("Main")
            and npc.HealthBar.Main:FindFirstChild("Title")

        if title and title:IsA("TextLabel") then
            local name = title.Text
            if name and not seen[name] then
                table.insert(npcNameList, name)
                seen[name] = true
            end
        end
    end

    if #npcNameList == 0 then
        table.insert(npcNameList, "No NPCs Found")
    end

    if dropdownRef then
        dropdownRef:SetValues(npcNameList)
    else
        -- Create the dropdown only once if not already created
        dropdownRef = Tabs.Main:AddDropdown("SpecificNPCDropdown", {
            Title = "🎯 Target NPC(s)",
            Values = npcNameList,
            Multi = true,
            Default = {npcNameList[1]},
            Callback = function(value)
                selectedNPC = value
                print("Selected NPC(s):", table.concat(value, ", "))
            end
        })
    end
end

-- ✅ Initial call to ensure dropdown appears before button
updateDropdown()

-- 🔁 Refresh button (appears AFTER dropdown in UI)
Tabs.Main:AddButton({
	Title = "🔁 Refresh NPC List",
	Description = "Click to manually refresh the dropdown with active NPCs.",
	Callback = function()
		updateDropdown()
	end
})

-- Add toggle for specificState to control whether autofarming is active
Tabs.Main:AddToggle("specificState", {
    Title = "🤖️ AutoFarm ↑↑↑",
    Default = false,
    Callback = function(value)
        specificState = value
        -- Ensure autofarm stops immediately when toggled off
        if not specificState then
            selectedNPC = {}
        end
    end
})

local suffixes = {
	["K"] = 1e3, ["M"] = 1e6, ["B"] = 1e9, ["T"] = 1e12,
	["Qa"] = 1e15, ["Qi"] = 1e18, ["Sx"] = 1e21,
	["Sp"] = 1e24, ["Oc"] = 1e27, ["No"] = 1e30, ["Dc"] = 1e33
}

local function parseHP(str)
	local number, suffix = str:match("([%d%.]+)(%a+)")
	number = tonumber(number)
	local multiplier = suffixes[suffix] or 1
	return number and number * multiplier or 0
end

local currentTarget = nil


spawn(function()
    while task.wait(0.1) do
        if specificState and selectedNPC and next(selectedNPC) then
            local bestHP = (hpPriority == "Highest") and -math.huge or math.huge
            local bestTarget = nil

            for _, npc in ipairs(enemiesFolder:GetChildren()) do
                local titleObj = npc:FindFirstChild("HealthBar")
                    and npc.HealthBar:FindFirstChild("Main")
                    and npc.HealthBar.Main:FindFirstChild("Title")

                if titleObj and selectedNPC[titleObj.Text] then
                    local healthBar = npc:FindFirstChild("HealthBar")
                    local hpAmount = healthBar and healthBar:FindFirstChild("Main")
                        and healthBar.Main:FindFirstChild("Bar")
                        and healthBar.Main.Bar:FindFirstChild("Amount")

                    if hpAmount and hpAmount:IsA("TextLabel") then
                        local hpVal = parseHP(hpAmount.Text)
                        if hpAmount.Text ~= "0 HP" then
                            if (hpPriority == "Highest" and hpVal > bestHP) or
                               (hpPriority == "Lowest" and hpVal < bestHP) then
                                bestHP = hpVal
                                bestTarget = npc
                            end
                        end
                    end
                end
            end

            if bestTarget then
                local playerHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local npcHRP = getEnemyRootPart(bestTarget)
                local healthBar = bestTarget:FindFirstChild("HealthBar")
                local hpAmount = healthBar and healthBar:FindFirstChild("Main")
                    and healthBar.Main:FindFirstChild("Bar")
                    and healthBar.Main.Bar:FindFirstChild("Amount")

                if playerHRP and npcHRP and hpAmount and hpAmount.Text ~= "0 HP" then
                    currentTarget = bestTarget.Name

                    -- Ensure we haven't already cast the shadow hit
                    if not shadowHit[bestTarget.Name] then
                        shadowHit[bestTarget.Name] = false  -- Mark target as not having shadow hit initially
                    end
					teleportToEnemy(bestTarget)
                    -- Handle the loop to check the conditions and attack
                    repeat
                        task.wait(0.1)
                        
                        if not specificState then break end

                        
                        swordDamage(bestTarget.Name)

                        -- Only cast shadow damage if it hasn't been casted yet
                        if not shadowHit[bestTarget.Name] then
                            shadowHit[bestTarget.Name] = true  -- Mark that shadow damage has been casted
                            shadowDamage(bestTarget.Name)
                        end
                        
                        -- Refresh HPAmount after each attack
                        healthBar = bestTarget:FindFirstChild("HealthBar")
                        hpAmount = healthBar and healthBar:FindFirstChild("Main")
                            and healthBar.Main:FindFirstChild("Bar")
                            and healthBar.Main.Bar:FindFirstChild("Amount")

                    until not hpAmount or hpAmount.Text == "0 HP" or not specificState

                    -- After target HP reaches 0, perform Arise action
                    if hpAmount and hpAmount.Text == "0 HP" then
                        for i = 1, 10 do
                            ariseAction(bestTarget.Name)
                            wait(0.08)
                        end
                    end
                end
            end
        end
    end
end)
-- 🏷️ Set this before teleporting via remote
local function storeJobId()
	previousJobId = game.JobId
	print("📌 Stored current JobId:", previousJobId)
end
-- WalkSpeed Handler (Only updates when WalkSpeed is different)
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")    
    removeFlyingFixer()
end)


local remote = game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent
-- Function to fire the remote events
local function startDungeonHunt()
    if not dungeonState then return end
	
    task.wait(3)
	Fluent:Notify({ Title = "Dungeon", Content = "🏃 7 Seconds to disable AutoDungeon.", Duration = 4 })
    if not dungeonState then
        Fluent:Notify({ Title = "Dungeon", Content = "❌ Cancelled before buying ticket.", Duration = 4 })
        return
    end

    -- Buy ticket
    local buyTicketArgs = {
        [1] = {
            [1] = {
                ["Type"] = "Gems",
                ["Event"] = "DungeonAction",
                ["Action"] = "BuyTicket"
            },
            [2] = "\n"
        }
    }
    remote:FireServer(unpack(buyTicketArgs))
    Fluent:Notify({ Title = "Dungeon", Content = "🎟️ Ticket bought!", Duration = 3 })

    task.wait(1)
    if not dungeonState then
        Fluent:Notify({ Title = "Dungeon", Content = "❌ Cancelled before creating dungeon.", Duration = 4 })
        return
    end

    -- Create dungeon
    local createDungeonArgs = {
        [1] = {
            [1] = {
                ["Event"] = "DungeonAction",
                ["Action"] = "Create"
            },
            [2] = "\n"
        }
    }
    remote:FireServer(unpack(createDungeonArgs))
    Fluent:Notify({ Title = "Dungeon", Content = "🧱 Dungeon created!", Duration = 3 })

    task.wait(3)
    if not dungeonState then
        Fluent:Notify({ Title = "Dungeon", Content = "❌ Cancelled before starting dungeon.", Duration = 4 })
        return
    end

    -- Start dungeon
    local startDungeonArgs = {
        [1] = {
            [1] = {
                ["Event"] = "DungeonAction",
                ["Action"] = "Start"
            },
            [2] = "\n"
        }
    }
    remote:FireServer(unpack(startDungeonArgs))
    Fluent:Notify({ Title = "Dungeon", Content = "⚔️ Dungeon started!", Duration = 3 })
end

-- Loop to continuously check the toggle and start dungeon hunt when enabled
task.spawn(function()
    while true do
        task.wait(1) 
        if dungeonState then
            startDungeonHunt()
        end
    end
end)


  Tabs.DungeonHunter:AddParagraph({
        Title = "🛠️ HOW TO USE",
        Content = "\n🔄 AutoDungeon will be autostarted with no restriction e with no items. \n--------------------------------------------------- \n ⚔️ AutoDungeon with item make you pick 1 item before starting the dungeon"
    })

--Start with items
local dungeonItemDropdown, selectedItem
local HttpService = game:GetService("HttpService")
local remote = game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Start with items
local dungeonItemDropdown, secondDungeonItemDropdown, selectedItem, selectedSecondItem
local HttpService = game:GetService("HttpService")
local remote = game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Manually mapping the item names to their real names
local itemOptions = {
    { Name = "DgURankUpRune", RealName = "Ultimate Rank Up Rune" },
    { Name = "DgRankUpRune", RealName = "Rank Up Rune" },
    { Name = "DgRankDownRune", RealName = "Rank Down Rune" },
}

-- Slot 1: List of items to display (Only the specified items)
local slot1Items = {}
-- Slot 2: Items that end with "Rune", excluding those already in Slot 1
local slot2Items = {}

-- Get the inventory items
local inventoryItems = game:GetService("Players").LocalPlayer.PlayerGui.__Disable.Menus.Inventory.Main.Lists.Items:GetChildren()

-- Check the inventory items and categorize them
for _, item in ipairs(inventoryItems) do
    -- Check if item name starts with "Dg"
    if item.Name:sub(1, 2) == "Dg" then
        -- Manually add specific items to slot 1
        local isSlot1Item = false
        for _, option in ipairs(itemOptions) do
            if item.Name == option.Name then
                table.insert(slot1Items, option.RealName)  -- Insert RealName into Slot 1
                isSlot1Item = true
                break
            end
        end
        
        -- If it's not a Slot 1 item, check if it ends with "Rune" and add to Slot 2
        if not isSlot1Item and item.Name:sub(-4) == "Rune" then
            table.insert(slot2Items, item.Name)  -- Insert Rune items into Slot 2
        end
    end
end

-- Debug: Print slot 1 and slot 2 items to check if they're populated correctly
print("Slot 1 Items:", table.concat(slot1Items, ", "))
print("Slot 2 Items:", table.concat(slot2Items, ", "))

-- Create the first dropdown for Slot 1 (specific items)
dungeonItemDropdown = Tabs.DungeonHunter:AddDropdown("dungeonItemSelect", {
    Title = "🎯 Select Item 1",  -- Title of the dropdown
    Values = slot1Items,              -- Populate dropdown with Slot 1 items
    Multi = false,                    -- Single item selection
    Default = slot1Items[1],          -- Default selection (first item in the list)
    Callback = function(item)
        selectedItem = item  -- Store the selected item for Slot 1
        Fluent:Notify({ Title = "Dungeon", Content = "🎒 Selected item for Slot 1: " .. item, Duration = 3 })
    end
})

-- Create the second dropdown for Slot 2 (items that end with "Rune")
secondDungeonItemDropdown = Tabs.DungeonHunter:AddDropdown("secondDungeonItemSelect", {
    Title = "🎯 Select Item 2",  -- Title of the second dropdown
    Values = slot2Items,                     -- Populate dropdown with Slot 2 items
    Multi = false,                           -- Single item selection
    Default = slot2Items[1],                 -- Default selection (first item in the list)
    Callback = function(item)
        selectedSecondItem = item  -- Store the selected item for Slot 2
        Fluent:Notify({ Title = "Dungeon", Content = "🎒 Selected item for Slot 2: " .. item, Duration = 3 })
    end
})

-- Button to run the dungeon sequence
Tabs.DungeonHunter:AddButton({
    Title = "⚔️ Start Dungeon with Items",  -- Button Title
    Description = "Start a dungeon run using the selected rune items.",  -- Button Description
    Callback = function()
        if not selectedItem then
            Fluent:Notify({ Title = "Dungeon", Content = "❌ Please select a dungeon item for Slot 1.", Duration = 4 })
            return
        end
        if not selectedSecondItem then
            Fluent:Notify({ Title = "Dungeon", Content = "❌ Please select a dungeon item for Slot 2.", Duration = 4 })
            return
        end

        -- Step 1: Buy ticket
        local buyTicketArgs = {
            [1] = {
                [1] = {
                    ["Type"] = "Gems",
                    ["Event"] = "DungeonAction",
                    ["Action"] = "BuyTicket"
                },
                [2] = "\n"
            }
        }
        remote:FireServer(unpack(buyTicketArgs))
        Fluent:Notify({ Title = "Dungeon", Content = "🎟️ Ticket bought!", Duration = 3 })

        task.wait(1)

        -- Step 2: Create dungeon
        local createDungeonArgs = {
            [1] = {
                [1] = {
                    ["Event"] = "DungeonAction",
                    ["Action"] = "Create"
                },
                [2] = "\n"
            }
        }
        remote:FireServer(unpack(createDungeonArgs))
        Fluent:Notify({ Title = "Dungeon", Content = "🏰 Dungeon created!", Duration = 3 })

        task.wait(1)

        -- Step 3: Add first item (after creation) to Slot 1
        local addItemArgs = {
            [1] = {
                [1] = {
                    ["Dungeon"] = LocalPlayer.UserId,
                    ["Action"] = "AddItems",
                    ["Slot"] = 1,
                    ["Event"] = "DungeonAction",
                    ["Item"] = selectedItem  -- Ensure this is the selected item for Slot 1
                },
                [2] = "\n"
            }
        }
        remote:FireServer(unpack(addItemArgs))
        Fluent:Notify({ Title = "Dungeon", Content = "📦 Added first item: " .. selectedItem, Duration = 3 })

        task.wait(1)

        -- Step 4: Add second item (after first item) to Slot 2
        local addSecondItemArgs = {
            [1] = {
                [1] = {
                    ["Dungeon"] = LocalPlayer.UserId,
                    ["Action"] = "AddItems",
                    ["Slot"] = 2,
                    ["Event"] = "DungeonAction",
                    ["Item"] = selectedSecondItem  -- Ensure this is the selected second item for Slot 2
                },
                [2] = "\n"
            }
        }
        remote:FireServer(unpack(addSecondItemArgs))
        Fluent:Notify({ Title = "Dungeon", Content = "📦 Added second item: " .. selectedSecondItem, Duration = 3 })

        task.wait(1)

        -- Step 5: Start dungeon
        local startDungeonArgs = {
            [1] = {
                [1] = {
                    ["Event"] = "DungeonAction",
                    ["Action"] = "Start"
                },
                [2] = "\n"
            }
        }
        remote:FireServer(unpack(startDungeonArgs))
        Fluent:Notify({ Title = "Dungeon", Content = "⚔️ Dungeon started!", Duration = 3 })
    end
})
--InfernalToggle
Tabs.DungeonHunter:AddParagraph({
        Title = "🔥 Infernal Castle ",
        Content = "Start the event during its opening time xx:45-xx:55"
    })
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local gui = LocalPlayer:WaitForChild("PlayerGui")

-- REJOIN PRIVATE SERVER
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer
local Stats = game:GetService("Stats")

local PlaceId = game.PlaceId
local JobId = game.JobId

local function getTotalMemory()
    local totalMemory = Stats:GetTotalMemoryUsageMb() -- in MB
    return totalMemory or 0
end

-- Rejoin logic function
local function rejoin()
    local playersInGame = #game.Players:GetPlayers()
    if playersInGame <= 1 then
        player:Kick("\nWAIT DONT LEAVE")
        task.wait()
        TeleportService:Teleport(PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, player)
    end
end

-- Simulated execCmd function
local function execCmd(cmd)
    if cmd == "rejoin" then
        rejoin()
    end
end

local function getHPText(enemy)
	local healthBar = enemy:FindFirstChild("HealthBar")
	if not healthBar then return "0 HP" end
	local main = healthBar:FindFirstChild("Main")
	local bar = main and main:FindFirstChild("Bar")
	local amount = bar and bar:FindFirstChild("Amount")
	return amount and amount.Text or "0 HP"
end

-- Assumes parseHP and teleportToEnemy and swordDamage are defined elsewhere

local function loadConfig(path)
	local success, result = pcall(function()
		if isfile(path) then
			return HttpService:JSONDecode(readfile(path))
		end
	end)
	return (success and result) or { enabled = false }
end

local function saveConfig(path, state)
	local data = { enabled = state }
	writefile(path, HttpService:JSONEncode(data))
end

local function memoryWatchdog(toggleFn)
	task.spawn(function()
		while toggleFn() do
			task.wait(10)
			local usedMemory = collectgarbage("count") / 1024
			if usedMemory >= 10240 then
				player:Kick("Memory usage exceeded 10GB. Rejoining...")
				task.wait()
				TeleportService:Teleport(PlaceId, player)
				break
			end
		end
	end)
end

local function autoFarmLoop(getRunning, configPath, positions)
    task.spawn(function()
        local firstTeleport = true  -- Flag to track if it's the first teleport
        while getRunning() do
            for _, spot in ipairs(positions) do
                if not getRunning() then break end
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(spot.pos)
                else
                    print("Player's HumanoidRootPart is not available. Skipping this spot.")
                    break
                end

                task.wait(0.5)

                local closestEnemy, closestDistance = nil, math.huge

                -- Find the closest enemy at the current position
                for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                    local healthBar = enemy:FindFirstChild("HealthBar")
                    if healthBar then
                        local main = healthBar:FindFirstChild("Main")
                        local title = main and main:FindFirstChild("Title")
                        if title and title.Text == spot.name then
                            -- Ensure enemy has a HumanoidRootPart
                            local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
                            if enemyHRP then
                                -- Calculate distance to the enemy
                                local distance = (hrp.Position - enemyHRP.Position).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestEnemy = enemy
                                end
                            end
                        end
                    end
                end

                -- Target the closest enemy
                if closestEnemy then
                    teleportToEnemy(closestEnemy)

                    while getRunning() and closestEnemy and closestEnemy:IsDescendantOf(workspace) do
                        task.wait(0.1)
                        swordDamage(closestEnemy.Name)
                        local hpText = getHPText(closestEnemy)
                        if hpText == "0 HP" then
                            task.wait(.8)
                            break  -- Move to the next position after current NPC dies
                        end
                    end
                else
                    print("No valid enemy found at this spot.")
                end
            end
        end
    end)
end

-- DragonCity
local dragonCityPath = "reavscripts/DragonCityConfig.json"
local dragonCityPositions = {
	{ name = "Turtle", pos = Vector3.new(-6771.49, 27.20, -160.97) },
	{ name = "Turtle", pos = Vector3.new(-6344.54, 26.19, 33.05) },
	{ name = "Green", pos = Vector3.new(-6728.24, 27.20, 318.67) },
	{ name = "Green", pos = Vector3.new(-7375.45, 27.19, -745.51) },
	{ name = "Sky", pos = Vector3.new(-7565.46, 28.20, -351.83) },
	{ name = "Sky", pos = Vector3.new(-7040.63, 28.19, -752.75) }
}
local dragonCityState = loadConfig(dragonCityPath)
local dragonCityRunning = dragonCityState.enabled

Tabs.Autofarm:AddToggle("dragoncityState", {
	Title = "🐉 DragonCity AutoFarm 🏙️",
	Default = dragonCityRunning,
	Callback = function(value)
		dragonCityRunning = value
		saveConfig(dragonCityPath, value)
		if value then
			memoryWatchdog(function() return dragonCityRunning end)
			autoFarmLoop(function() return dragonCityRunning end, dragonCityPath, dragonCityPositions)
		end
	end
})

-- XZcity
local xzCityPath = "reavscripts/XZcityConfig.json"
local xzCityPositions = {
	{ name = "Cyborg", pos = Vector3.new(5765.88, 25.59, 4664.02) },
	{ name = "Cyborg", pos = Vector3.new(6099.98, 25.59, 4924.84) },
	{ name = "Hurricane", pos = Vector3.new(6022.10, 356.26, 4963.73) },
	{ name = "Hurricane", pos = Vector3.new(5669.92, 26.09, 4908.05) },
	{ name = "Rider", pos = Vector3.new(6074.61, 26.09, 4417.30) },
	{ name = "Rider", pos = Vector3.new(6038.87, 26.09, 5387.69) }
}
local xzCityState = loadConfig(xzCityPath)
local xzCityRunning = xzCityState.enabled

Tabs.Autofarm:AddToggle("xzcityState", {
	Title = "🌌 XZcity AutoFarm 🚀",
	Default = xzCityRunning,
	Callback = function(value)
		xzCityRunning = value
		saveConfig(xzCityPath, value)
		if value then
			memoryWatchdog(function() return xzCityRunning end)
			autoFarmLoop(function() return xzCityRunning end, xzCityPath, xzCityPositions)
		end
	end
})

  Tabs.Autofarm:AddParagraph({
        Title = "8",
        Content = ""
    })
-- Update damage & actions while farming
spawn(function()
    while task.wait(0.05) do
        if (dragoncityRunning or specificState or xzcityRunning) and currentTarget then
            -- Update sword damage with different timing intervals
            swordDamage(currentTarget)
            -- Repeating sword damage and arise actions
            if task.wait(0.2) then
                ariseAction(currentTarget)
            end
        end
    end
end)

--TELEPORTS

--WILDS
local wilds = workspace.__Main.__World:FindFirstChild("Wilds")
local appear = workspace.__Extra:FindFirstChild("__Appear")

if not wilds or not appear then
	warn("Wilds or __Appear not found")
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

Tabs.Teleports:AddButton({
	Title = "Search for Mount 🔎",
	Description = "Teleport once through Wilds until something appears",
	Callback = function()
		-- Force-stop autofarm
		autofarmState = false
		local char = LocalPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then
			warn("HumanoidRootPart not found")
			return
		end

		task.spawn(function()
			for _, model in ipairs(wildsList) do
				if #appear:GetChildren() > 0 then
					break
				end

				char:PivotTo(model:GetPivot())
				task.wait(2) -- adjust delay if needed
			end

			if #appear:GetChildren() > 0 then
				print("Something appeared in __Appear!")
			else
				print("Nothing appeared after one full loop.")
			end
		end)
	end
})

local customNames = {
    SoloWorld = "1. Solo City",
    NarutoWorld = "2. Grass Village",
    OPWorld = "3. Brum Village",
    BleachWorld = "4. FaceHeal Town",
    BCWorld = "5. Lucky Kingdom",
    ChainsawWorld = "6. Nipon City",
    JojoWorld = "7. Mori Town",
	DBWorld = "8. Dragon City",
	OPMWorld = "9. XZ City"
}

-- Create a list of spawn points with custom order
local orderedSpawns = {
    "SoloWorld",
    "NarutoWorld",
    "OPWorld",
    "BleachWorld",
    "BCWorld",
    "ChainsawWorld",
    "JojoWorld",
	"DBWorld",
	"OPMWorld"
}

-- Add buttons in the custom order
for _, spawnName in ipairs(orderedSpawns) do
    local spawnPoint = workspace["__Extra"]["__Spawns"]:FindFirstChild(spawnName)
    if spawnPoint and spawnPoint:IsA("SpawnLocation") then
        local displayName = customNames[spawnPoint.Name] or spawnPoint.Name
        Tabs.Teleports:AddButton({
            Title = displayName,  
            Description = "Teleport to " .. displayName,  
            Callback = function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPoint.Position)
                else
                    print("Player's HumanoidRootPart not found.") 
                end
            end
        })
    end
end

-- Define teleport locations with custom functions
local teleportLocations = {
    ["Rank UP ⏫"] = function()
        
        wait(1.5)
        
        
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
        
    end,

    ["Guild Hall 🏰"] = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.__Extra.GuildTPs.Main.CFrame
        wait(1.5)
        LocalPlayer.Character:PivotTo(workspace.__Main.__World.GuildHall.Base["predio interna"]["fonte sozinha"]:GetPivot() + Vector3.new(0, 5, 0))
    end,

    ["Jeju Island 🏝"] = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4012.385498046875, 60.360130310058594, 3318.841796875)
    end
}

-- Add the button with proper title
Tabs.Teleports:AddButton({
    Title = "ServerHop",
    Description = "Hop to a new server. 🐇",
    Callback = function()
        hopServer()
    end
})


-- Adding the new teleport buttons to the "Teleports" tab
for name, func in pairs(teleportLocations) do
    Tabs.Teleports:AddButton({
        Title = name,  -- Button title
        Description = "Teleport to " .. name,  
        Callback = func  
    })
end

local GuildListSection = Tabs.GuildMaster:AddSection("Members List 📃")
local guildEntries = {}
local donationHistory = {}
local dailyDonations = {}
local expHistory = {}
local dailyExp = {}

local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

-- File paths
local savePath = "reavscripts/GuildDonations.json"
local dailyDonationsPath = "reavscripts/DailyDonations.json"
local expSavePath = "reavscripts/GuildExp.json"
local dailyExpPath = "reavscripts/DailyExp.json"

-- Load donation history
if isfile(savePath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(savePath))
    end)
    if success and typeof(data) == "table" then
        donationHistory = data
    end
end

-- Load daily donations
if isfile(dailyDonationsPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(dailyDonationsPath))
    end)
    if success and typeof(data) == "table" then
        dailyDonations = data
    end
end

-- Load EXP history
if isfile(expSavePath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(expSavePath))
    end)
    if success and typeof(data) == "table" then
        expHistory = data
    end
end

-- Load daily EXP
if isfile(dailyExpPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(dailyExpPath))
    end)
    if success and typeof(data) == "table" then
        dailyExp = data
    end
end

-- Parse gem string like "1.23Qa"
local suffixes = {
    K = 1e3, M = 1e6, B = 1e9, T = 1e12, Qa = 1e15, Qi = 1e18,
    Sx = 1e21, Sp = 1e24, Oc = 1e27, No = 1e30, Dc = 1e33
}
local function parseGems(str)
    local number, suffix = str:match("([%d%.]+)(%a+)")
    number = tonumber(number)
    local multiplier = suffixes[suffix] or 1
    return number and number * multiplier or 0
end

local function formatToSuffix(value)
    local sortedSuffixes = {}
    for suffix, multiplier in pairs(suffixes) do
        table.insert(sortedSuffixes, {suffix = suffix, multiplier = multiplier})
    end
    table.sort(sortedSuffixes, function(a, b)
        return a.multiplier > b.multiplier
    end)

    for _, entry in ipairs(sortedSuffixes) do
        if value >= entry.multiplier then
            return string.format("%.2f%s", value / entry.multiplier, entry.suffix)
        end
    end
    return string.format("%.2f", value)
end

local function cleanupGuildEntries(players)
    local playersInList = {}
    for _, player in ipairs(players) do
        playersInList[player.Name] = true
    end
    for playerName, entry in pairs(guildEntries) do
        if not playersInList[playerName] then
            guildEntries[playerName] = nil
            entry:Destroy()
        end
    end
end

local function updateGuildList()
    local guildFolder = LocalPlayer.PlayerGui.__Disable:FindFirstChild("Menus")
        and LocalPlayer.PlayerGui.__Disable.Menus:FindFirstChild("Guilds")
    if not guildFolder then return end

    local listContainer = guildFolder:FindFirstChild("PlayerList")
        and guildFolder.PlayerList:FindFirstChild("List")
    if not listContainer then return end

    local players = {}
    for _, frame in pairs(listContainer:GetChildren()) do
        if frame:IsA("Frame") and frame:FindFirstChild("Main") then
            local main = frame.Main
            local playerNameLabel = main:FindFirstChild("PlayerName")
            local gemsLabel = main:FindFirstChild("GemsLabel")
            local expLabel = main:FindFirstChild("ExpLabel")

            if playerNameLabel and typeof(playerNameLabel.Text) == "string" then
                local name = playerNameLabel.Text
                if name ~= "" and name ~= "Player Name" and name ~= "HypeSubs" then
                    local gemsRaw = gemsLabel and gemsLabel:FindFirstChild("Value") and gemsLabel.Value.Text or "0"
                    local expRaw = expLabel and expLabel:FindFirstChild("Value") and expLabel.Value.Text or "0"

                    local gems = tonumber(gemsRaw) or 0
                    local exp = tonumber(expRaw) or 0

                    table.insert(players, {
                        Name = name,
                        Gems = parseGems(gemsRaw),
                        GemsText = gemsRaw,
                        Exp = exp,
                        ExpText = expRaw
                    })
                end
            end
        end
    end

    cleanupGuildEntries(players)
    table.sort(players, function(a, b) return a.Gems > b.Gems end)

    local currentDate = os.date("!*t")
    local todayKey = string.format("%d-%d-%d", currentDate.year, currentDate.month, currentDate.day)
    if not dailyDonations[todayKey] then dailyDonations[todayKey] = {} end
    if not dailyExp[todayKey] then dailyExp[todayKey] = {} end

    for _, player in ipairs(players) do
        local prevGems = donationHistory[player.Name] or 0
        local gemsDiff = player.Gems - prevGems
        local dailyGems = dailyDonations[todayKey][player.Name] or 0
        dailyGems = dailyGems + gemsDiff  -- Corrected increment

        local prevExp = expHistory[player.Name] or 0
        local expDiff = player.Exp - prevExp
        local dailyGain = dailyExp[todayKey][player.Name] or 0
        dailyGain = dailyGain + expDiff  -- Corrected increment

        dailyDonations[todayKey][player.Name] = dailyGems
        dailyExp[todayKey][player.Name] = dailyGain
        donationHistory[player.Name] = player.Gems
        expHistory[player.Name] = player.Exp

        local existingParagraph = guildEntries[player.Name]
		local content = string.format(
			"\n💎 Gems Donated: %s (Daily: %s)\n\n📘 EXP Gained: %s (Daily: %s)",  -- Added an extra \n for space between lines
			player.GemsText, formatToSuffix(dailyGems),
			player.ExpText, formatToSuffix(dailyGain)
		)

        if existingParagraph then
            if existingParagraph.Title then existingParagraph.Title = player.Name end
            if existingParagraph.Content then
                existingParagraph.Content = content
            end
        else
            local paragraph = GuildListSection:AddParagraph({
                Title = player.Name,
                Content = content
            })
            guildEntries[player.Name] = paragraph
        end
    end

    writefile(savePath, HttpService:JSONEncode(donationHistory))
    writefile(dailyDonationsPath, HttpService:JSONEncode(dailyDonations))
    writefile(expSavePath, HttpService:JSONEncode(expHistory))
    writefile(dailyExpPath, HttpService:JSONEncode(dailyExp))
end

-- Check every minute if the day has changed
task.spawn(function()
    local lastCheckedDate = os.date("!*t")
    while true do
        task.wait(60)  -- Check every minute
        local currentDate = os.date("!*t")
        if currentDate.day ~= lastCheckedDate.day then
            -- New day started, reset daily donations for all players
            lastCheckedDate = currentDate
            dailyDonations = {}  -- Reset the daily donations data
            print("🎉 New day started. Daily donations reset.")
            -- Save the reset data
            writefile(dailyDonationsPath, HttpService:JSONEncode(dailyDonations))
        end
    end
end)

-- Call the function to initially populate the guild list
updateGuildList()
-- Add Paragraph to the Discord Section
Tabs.Discord:AddParagraph({
    Title = "Join our Discord server!",
    Content = "Join our Discord server for updates, news, and support!\nClick the button below to join the community.\n"
})

-- Add Button to Copy Discord Invite with Fireworks Effect
Tabs.Discord:AddButton({
    Title = "Join Discord",
    Description = "Click to join the Discord server",
    Callback = function()
        -- Copy the Discord link to the clipboard
        setclipboard("https://discord.gg/8Fxnd74Eyq")  -- Copies the link to clipboard

        -- Show notification to user
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Discord Invite Copied!",
            Text = "The Discord invite has been copied to your clipboard!",
            Duration = 3,
        })

        -- Create Fireworks Effect
        local fireworkPart = Instance.new("Part")
        fireworkPart.Size = Vector3.new(1, 1, 1)  -- Size of the firework explosion
        fireworkPart.Shape = Enum.PartType.Ball
        fireworkPart.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
        fireworkPart.Anchored = true
        fireworkPart.CanCollide = false
        fireworkPart.Parent = workspace
        
        -- Create ParticleEmitter to simulate fireworks explosion
        local emitter = Instance.new("ParticleEmitter")
        emitter.Parent = fireworkPart
        emitter.Lifetime = NumberRange.new(4, 4)  -- Duration of the fireworks particles
        emitter.Rate = 1000  -- Emit 1000 particles per second
        emitter.Speed = NumberRange.new(50, 100)  -- Speed of the particles
        emitter.SpreadAngle = Vector2.new(0, 360)  -- Spread in a full circle
        emitter.Size = NumberSequence.new(0.5, 0)  -- Particles start larger and fade
        emitter.Texture = "rbxassetid://149090503"  -- Texture for particles (Firework)
        emitter.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0))  -- Color of fireworks

        -- Destroy the firework after 1.5 seconds
        game:GetService("Debris"):AddItem(fireworkPart, 4)
    end
})

--SETTINGS
local TeleportService = game:GetService("TeleportService")

local localPlayer = Players.LocalPlayer
local placeId = game.PlaceId
local currentJobId = game.JobId

local triedJobIds = {}

-- Function to attempt teleporting to a new server
local function hopServer()
    local cursor = ""
    local found = false

    while not found do
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&cursor=%s", placeId, cursor)
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)

        if success then
            local data = HttpService:JSONDecode(result)
            for _, server in ipairs(data.data) do
                if server.id ~= currentJobId and not triedJobIds[server.id] and server.playing < server.maxPlayers then
                    triedJobIds[server.id] = true
                    print("🌐 Hopping to JobId:", server.id)
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, localPlayer)
                    found = true
                    break
                end
            end

            if data.nextPageCursor then
                cursor = data.nextPageCursor
            else
                break
            end
        else
            warn("❌ Failed to fetch servers:", result)
            break
        end
    end

    if not found then
        warn("⚠️ Could not find a new server to hop to.")
    end
end


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("reavscripts")
SaveManager:SetFolder("reavscripts/arisecrossover")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "reav's scripts",
    Content = "The script has been loaded.",
    Duration = 1
})

SaveManager:LoadAutoloadConfig()
