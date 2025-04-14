repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:service("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    warn("anti-afk")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- GUI Setup
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = GameName .. " AFK World Script",
    SubTitle = "reav's scripts",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "AFK World", Icon = "skull" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Main:AddParagraph({
    Title = "Send rewards notice to Discord!",
    Content = "Join our discord server to see all your rewards\n from your smartphone directly on discord!"
})

Tabs.Main:AddButton({
    Title = "Join reav's scripts discord",
    Description = "Copy invite and paste it in your browser!",
    Callback = function()
        setclipboard("https://discord.gg/8Fxnd74Eyq")
        StarterGui:SetCore("SendNotification", {
            Title = "Invite Copied!",
            Text = "Link copied to clipboard.",
            Duration = 3
        })
    end
})


-- Global Variables
local webhookURL = "https://discord.com/api/webhooks/1361421824906367027/O6rxh5Iqh2dptZnhoE9Orz9Xp5a_em7qB-WAqsrhw8RE52L6GYesoalAK1gc-Bm3wP74"

-- Reward monitor (auto-starts using username)
task.spawn(function()
    local function sendToDiscord(message)
        local payload = HttpService:JSONEncode({ content = message })
        local req = request or (http and http.request)
        if req then
            req({
                Url = webhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = payload
            })
        else
            warn("❌ HTTP request function not supported by this executor.")
        end
    end

    local lastReward = ""
    local success, err = pcall(function()
        local gui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CountDown")
        local rewardName = gui:WaitForChild("Frame"):WaitForChild("RewardPopup"):WaitForChild("RewardName")

        rewardName:GetPropertyChangedSignal("Text"):Connect(function()
            local reward = rewardName.Text
            if reward and reward ~= "" and reward ~= "RewardName" and reward ~= lastReward then
                lastReward = reward
                local sender = "**" .. LocalPlayer.Name .. "**"
                sendToDiscord("🎁 " .. sender .. " got a new reward: `" .. reward .. "`")
            end
        end)
    end)

    if success then
        Fluent:Notify({
            Title = "Webhook",
            Content = "Auto-started reward watcher using username!",
            Duration = 4
        })
    else
        warn("❌ Could not start reward watcher:", err)
    end
end)



-- Settings
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetIgnoreIndexes({})
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("reavscripts/arisecrossover")
InterfaceManager:SetFolder("reavscripts")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "reav's scripts",
    Content = "The script has been loaded.",
    Duration = 3
})
SaveManager:LoadAutoloadConfig()
