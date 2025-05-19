-------------------------------------------------------------------------------
--! json library
--! cryptography library
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;
-------------------------------------------------------------------------------
local function lDigest(F)
    F = tostring(F)
    local hash = Z(F)
    return hash
end
-------------------------------------------------------------------------------
--! platoboost library

--! configuration
local service = 3954;  -- your service id, this is used to identify your service.
local secret = "6879c3ab-6677-4314-a8b7-8792f03979e0";  -- make sure to obfuscate this if you want to ensure security.
local useNonce = true;  -- use a nonce to prevent replay attacks and request tampering.

--! callbacks
local function onMessage(message)
    local player = game:GetService("Players").LocalPlayer
    if not player then
        warn("❌ Player not found for onMessage")
        return
    end

    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then
        warn("❌ PlayerGui not found")
        return
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationUI"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, -320, 1, -80) -- Bottom right
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextWrapped = true
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 16
    textLabel.Parent = frame

    -- Auto remove notification after 3 seconds
    task.delay(3, function()
        screenGui:Destroy()
    end)
end

--! functions
local requestSending = false;
local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid = setclipboard or toclipboard, request or http_request or syn_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function() return game:GetService("Players").LocalPlayer.UserId end
local cachedLink, cachedTime = "", 0;

--! pick host
local host = "https://api.platoboost.com";
local hostResponse = fRequest({
    Url = host .. "/public/connectivity",
    Method = "GET"
});
if hostResponse.StatusCode ~= 200 or hostResponse.StatusCode ~= 429 then
    host = "https://api.platoboost.net";
end

--!optimize 2
function cacheLink()
    if cachedTime + (10*60) < fOsTime() then
        local response = fRequest({
            Url = host .. "/public/start",
            Method = "POST",
            Body = lEncode({
                service = service,
                identifier = lDigest(fGetHwid())
            }),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        });

        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body);

            if decoded.success == true then
                cachedLink = decoded.data.url;
                cachedTime = fOsTime();
                return true, cachedLink;
            else
                return false, decoded.message;
            end
        elseif response.StatusCode == 429 then
            local msg = "you are being rate limited, please wait 20 seconds and try again.";
            onMessage(msg);
            return false, msg;
        end

        local msg = "Failed to cache link.";
        onMessage(msg);
        return false, msg;
    else
        return true, cachedLink;
    end
end

cacheLink();

--!optimize 2
local generateNonce = function()
    local str = ""
    for _ = 1, 16 do
        str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
    end
    return str
end

--!optimize 1
for _ = 1, 5 do
    local oNonce = generateNonce();
    task.wait(0.2)
    if generateNonce() == oNonce then
        local msg = "platoboost nonce error.";
        onMessage(msg);
        error(msg);
    end
end

--!optimize 2
local copyLink = function()
    local success, link = cacheLink();
    
    if success then
        fSetClipboard(link);
    end
end

--!optimize 2
local redeemKey = function(key)
    local nonce = generateNonce();
    local endpoint = host .. "/public/redeem/" .. fToString(service);

    local body = {
        identifier = lDigest(fGetHwid()),
        key = key
    }

    if useNonce then
        body.nonce = nonce;
    end

    local response = fRequest({
        Url = endpoint,
        Method = "POST",
        Body = lEncode(body),
        Headers = {
            ["Content-Type"] = "application/json"
        }
    });

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);

        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                        return true;
                    else
                        onMessage("failed to verify integrity.");
                        return false;
                    end    
                else
                    return true;
                end
            else
                onMessage("key is invalid.");
                return false;
            end
        else
            if fStringSub(decoded.message, 1, 27) == "unique constraint violation" then
                onMessage("you already have an active key, please wait for it to expire before redeeming it.");
                return false;
            else
                onMessage(decoded.message);
                return false;
            end
        end
    elseif response.StatusCode == 429 then
        onMessage("you are being rate limited, please wait 20 seconds and try again.");
        return false;
    else
        onMessage("server returned an invalid status code, please try again later.");
        return false; 
    end
end

--!optimize 2
local verifyKey = function(key)
    if requestSending == true then
        onMessage("a request is already being sent, please slow down.");
        return false;
    else
        requestSending = true;
    end

    local nonce = generateNonce();
    local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;

    if useNonce then
        endpoint = endpoint .. "&nonce=" .. nonce;
    end

    local response = fRequest({
        Url = endpoint,
        Method = "GET",
    });

    requestSending = false;

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);

        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                        return true;
                    else
                        onMessage("failed to verify integrity.");
                        return false;
                    end
                else
                    return true;
                end
            else
                if fStringSub(key, 1, 4) == "KEY_" then
                    return redeemKey(key);
                else
                    onMessage("key is invalid.");
                    return false;
                end
            end
        else
            onMessage(decoded.message);
            return false;
        end
    elseif response.StatusCode == 429 then
        onMessage("you are being rate limited, please wait 20 seconds and try again.");
        return false;
    else
        onMessage("server returned an invalid status code, please try again later.");
        return false;
    end
end

--!optimize 2
local getFlag = function(name)
    local nonce = generateNonce();
    local endpoint = host .. "/public/flag/" .. fToString(service) .. "?name=" .. name;

    if useNonce then
        endpoint = endpoint .. "&nonce=" .. nonce;
    end

    local response = fRequest({
        Url = endpoint,
        Method = "GET",
    });

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);

        if decoded.success == true then
            if useNonce then
                if decoded.data.hash == lDigest(fToString(decoded.data.value) .. "-" .. nonce .. "-" .. secret) then
                    return decoded.data.value;
                else
                    onMessage("failed to verify integrity.");
                    return nil;
                end
            else
                return decoded.data.value;
            end
        else
            onMessage(decoded.message);
            return nil;
        end
    else
        return nil;
    end
end
-------------------------------------------------------------------------------
-- Prevent Fluent UI from loading yet

_G.FluentUILoaded = false
function loadMainUI()
    if _G.FluentUILoaded then return end
    _G.FluentUILoaded = true
	-- INIZIO SCRIPT
local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = players.LocalPlayer
local enemiesFolder = workspace.__Main.__Enemies.Client
local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
local HttpService = game:GetService("HttpService")
local VirtualUser = game:service("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")
local GameName

local success, result = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)

if success and result and result.Name then
    GameName = result.Name
else
    warn("Failed to fetch game name:", result)
    GameName = "Unknown Game"
end
local targetModule = ReplicatedStorage:FindFirstChild("BridgeNet2")

if targetModule and targetModule:IsA("ModuleScript") then
    local success, result = pcall(require, targetModule)
    if success and typeof(result) == "table" then
        local patch = function()
            for k, v in pairs(result) do
                if typeof(v) == "function" then
                    result[k] = function() end
                end
            end
        end

        if setreadonly then
            pcall(function()
                setreadonly(result, false)
                patch()
                setreadonly(result, true)
            end)
        else
            pcall(patch)
        end
    else
        warn("❌ Failed to disable logging")
    end
else
    warn("❌ module not found")
end

-- Anti-AFK 
local antiAfkConnection
antiAfkConnection = LocalPlayer.Idled:Connect(function()
    warn("anti-afk triggered")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
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

local camera = workspace.CurrentCamera
local screenSize = camera and camera.ViewportSize or Vector2.new(1920, 1080)

-- Scale window size to ~35% width, 50% height of the screen
local windowWidth = math.clamp(screenSize.X * 0.35, 400, 800)
local windowHeight = math.clamp(screenSize.Y * 0.5, 300, 700)

local Window = Fluent:CreateWindow({
    Title = GameName .. " World Script",
    SubTitle = "reav's scripts",
    TabWidth = 160,
    Size = UDim2.fromOffset(windowWidth, windowHeight),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})



local Tabs = {
    Main = Window:AddTab({ Title = "AutoFarm", Icon = "skull" }),
	Autofarm = Window:AddTab({ Title = "Brutes AutoFarm", Icon = "angry" }),
	WinterHunter = Window:AddTab({ Title = "Winter Hunter", Icon = "snowflake" }),
	DungeonHunter = Window:AddTab({ Title = "Dungeon Hunter", Icon = "aperture" }),
	Teleports = Window:AddTab({ Title = "Teleports", Icon = "wifi" }),
	GuildMaster = Window:AddTab({ Title = "Daily Donations", Icon = "eye" }),
	GuildInvite = Window:AddTab({ Title = "Mass Guild Invite", Icon = "mail" }),
	Utils = Window:AddTab({ Title = "Exchange Dust", Icon = "hammer" }),
    Discord = Window:AddTab({ Title = "Discord", Icon = "heart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local BridgeNet2 = ReplicatedStorage:WaitForChild("BridgeNet2")

-- Config
local autoQuestConfigPath = "reavscripts/AutoQuestConfig.json"
makefolder("reavscripts")

-- Load toggle state from file
local autoClaimEnabled = false
if isfile(autoQuestConfigPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(autoQuestConfigPath))
    end)
    if success and data and data.AutoClaimQuests ~= nil then
        autoClaimEnabled = data.AutoClaimQuests
    end
end

-- Claim quest function
local function claimQuests()
    -- Simulate switching to "Normal" tab using the same remote the module would
    local args = {
        {
            {
                Action = "ChangeType",
                Type = "Normal",
                Event = "QuestButtons"
            },
            "\n"
        }
    }
    BridgeNet2.dataRemoteEvent:FireServer(unpack(args))

    task.wait(0.25)

    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local questsFolder = leaderstats:FindFirstChild("Quests")
    if not questsFolder then return end

    local normalQuests = questsFolder:FindFirstChild("Normal")
    if not normalQuests then return end

    for _, quest in ipairs(normalQuests:GetChildren()) do
        local claimArgs = {
            {
                {
                    Id = quest.Name,
                    Type = "Normal",
                    Event = "ClaimQuest"
                },
                "\n"
            }
        }
        BridgeNet2.dataRemoteEvent:FireServer(unpack(claimArgs))
        task.wait(0.75)
    end
end

-- Background loop
task.spawn(function()
    while true do
        if autoClaimEnabled then
            pcall(claimQuests)
        end
        task.wait(10)
    end
end)

-- Toggle UI
AutoQuestToggle = Tabs.Main:AddToggle("autoQuestState", {
    Title = "📥 Auto Claim Quests",
    Description = "Automatically claim main quests",
    Default = autoClaimEnabled,
    Callback = function(state)
        autoClaimEnabled = state
        writefile(autoQuestConfigPath, HttpService:JSONEncode({
            AutoClaimQuests = autoClaimEnabled
        }))
    end
})

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

-- DUNGEON TP
Tabs.DungeonHunter:AddButton({
	Title = "🌀 Dungeon TP",
	Description = "Teleport in the active dungeon anywhere",
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


-- Shadow Hit Toggle
local shadowHitConfigPath = "reavscripts/shadowHitConfig.json"
local useShadowHit = true -- default

-- Load saved state if available
if isfile(shadowHitConfigPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(shadowHitConfigPath))
    end)
    if success and data and type(data.UseShadowHit) == "boolean" then
        useShadowHit = data.UseShadowHit
    end
end

ShadowHitToggle = Tabs.Main:AddToggle("shadowHitState", {
    Title = "🌑 Use Shadow Hit",
    Description = "Auto Attack with  Shadows",
    Default = useShadowHit,
    Callback = function(state)
        useShadowHit = state
        -- Save the new state to the config file
        local toSave = {
            UseShadowHit = useShadowHit
        }
        writefile(shadowHitConfigPath, HttpService:JSONEncode(toSave))
    end
})

-- Arise Toggle (for example)
AriseToggle = Tabs.Main:AddToggle("ariseState", {
    Title = "👻 Arise Or Destroy",
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
        -- Get the enemy's position
        local enemyPosition = enemyHRP.Position

        -- Calculate the new position slightly below the ground level
        local newPosition = Vector3.new(enemyPosition.X, enemyPosition.Y, enemyPosition.Z)

        -- Set the player's HumanoidRootPart CFrame, with the position adjusted
        hrp.CFrame = CFrame.new(newPosition) + (enemyHRP.CFrame.LookVector * 6)
    end
end
local function shadowDamage(npc)
    if not npc then return end
    
    local packets = {"\6", "\7", "\5", "\8", "\t"}
    
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
        
        task.wait(.1)  
        ReplicatedStorage:FindFirstChild("BridgeNet2"):FindFirstChild("dataRemoteEvent"):FireServer(unpack(args))
    end
end
local function swordDamage(npc)
    if not npc then return end  -- Early return if npc is invalid

    local packets = { "\5", "\4" }
    local remote = game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent

    for _, packet in ipairs(packets) do
        local args = {
            [1] = {
                [1] = {
                    ["Event"] = "PunchAttack",
                    ["Enemy"] = npc
                },
                [2] = packet
            }
        }
        remote:FireServer(unpack(args))
    end
end

local function ariseAction(npc)
    if not npc then return end

    local action = ariseState and "EnemyCapture" or "EnemyDestroy"
    local packets = { "\5", "\4" }
    local remote = game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent

    for _, packet in ipairs(packets) do
        local args = {
            [1] = {
                [1] = {
                    ["Event"] = action,
                    ["Enemy"] = npc
                },
                [2] = packet
            }
        }
        remote:FireServer(unpack(args))
    end
end

-- Selected NPCs reference
local selectedNPC = {}
local npcNameList = {}
local dropdownRef
local isFirstRun = true

-- Update the dropdown without affecting specificState
local function updateDropdown()
    local enemies = workspace.__Main.__Enemies:FindFirstChild("Client")
    if not enemies then
        warn("Enemies folder not found")
        return
    end

    local seen = {}
    npcNameList = {}  -- Reset list
	
	if isFirstRun then
        table.insert(npcNameList, 1, "")
        isFirstRun = false
    end

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
		if #npcNameList > 1 and npcNameList[1] == "" then
			table.remove(npcNameList, 1)
		end
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
        if not specificState then
            selectedNPC = {}
        end
    end
})

-- AUTOSELL SHADOWS
Tabs.Main:AddParagraph({
    Title = "                                ⚠️   A T T E N T I O N   ⚠️",
    Content = "\n 🙅 If the Shadow Inventory is open, the item won't be deleted. 🙅"
})

-- Variables
local isAutoDeleteEnabled = false
local selectedRanks = {}

-- GUI Setup
local rankDropdown = Tabs.Main:AddDropdown("AutoDeleteRankDropdown", {
    Title = "Select Shadow Ranks to Delete",
    Description = "Multi-select ranks to auto-delete",
    Values = {"SS", "S", "A", "B", "C", "D", "E"},
    Multi = true,
    Default = {"E", "D", "C"},
})

rankDropdown:OnChanged(function(Value)
    selectedRanks = {}
    for rank, enabled in next, Value do
        if enabled then
            selectedRanks[rank] = true
        end
    end
end)

local autoDeleteToggle = Tabs.Main:AddToggle("AutoDeletePetsToggle", {
    Title = "Auto Delete Shadows",
    Description = "Continuously delete Shadows with selected ranks.",
    Default = false
})

autoDeleteToggle:OnChanged(function(value)
    isAutoDeleteEnabled = value
end)

-- Pet Deletion Function
local function autoDeletePetsByRank()
    local menus = LocalPlayer.PlayerGui:FindFirstChild("__Disable") and LocalPlayer.PlayerGui.__Disable:FindFirstChild("Menus")
    if not menus then return end

    local petsMenu = menus:FindFirstChild("Pets")
    if not petsMenu or petsMenu.Visible then return end -- ⚠️ Skip if open

    local container = petsMenu:FindFirstChild("Main")
        and petsMenu.Main:FindFirstChild("Container")
    if not container then return end

    for _, petButton in ipairs(container:GetChildren()) do
        if petButton:IsA("ImageButton") then
            local rankLabel = petButton:FindFirstChild("Main") and petButton.Main:FindFirstChild("Rank")
            if rankLabel and selectedRanks[rankLabel.Text] then
                local petID = petButton.Name
                local codes = { "\5", "\8", "\6", "\t" }

                for _, code in ipairs(codes) do
                    local args = {
                        {
                            {
                                Event = "SellPet",
                                Pets = { petID }
                            },
                            code
                        }
                    }
                    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
                    task.wait(0.1)
                end
            end
        end
    end
end

-- Auto Deletion Loop
task.spawn(function()
    while true do
        task.wait(2) -- Check every 2 seconds
        if isAutoDeleteEnabled then
            autoDeletePetsByRank()
        end
    end
end)

-- Toggle Handler
autoDeleteToggle:OnChanged(function(enabled)
    isAutoDeleteEnabled = enabled
    if isAutoDeleteEnabled then
		Fluent:Notify({
            Title = "🗑 Auto Delete",
            Content = "Continuously destroying selected shadow.",
            Duration = 5
        })
        task.spawn(function()
            while isAutoDeleteEnabled do
                autoDeletePetsByRank()
                task.wait(.3)
            end
        end)
    end
end)

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

                    if hpAmount and hpAmount:IsA("TextLabel") and hpAmount.Text ~= "0 HP" then
                        bestTarget = npc
                        break -- Pick the first matching alive NPC
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

                    if useShadowHit and shadowHit[bestTarget.Name] == nil then
                        shadowHit[bestTarget.Name] = false
                    end

                    teleportToEnemy(bestTarget)

                    repeat
                        task.wait(0.1)
                        if not specificState then break end

                        if useShadowHit and not shadowHit[bestTarget.Name] then
                            shadowHit[bestTarget.Name] = true
                            shadowDamage(bestTarget.Name)
                        end

                        healthBar = bestTarget:FindFirstChild("HealthBar")
                        hpAmount = healthBar and healthBar:FindFirstChild("Main")
                            and healthBar.Main:FindFirstChild("Bar")
                            and healthBar.Main.Bar:FindFirstChild("Amount")
                    until not hpAmount or hpAmount.Text == "0 HP" or not specificState

                    if hpAmount and hpAmount.Text == "0 HP" then
                        for i = 1, 10 do
                            ariseAction(bestTarget.Name)
                            wait(0.125)
                        end
                        shadowHit[bestTarget.Name] = nil -- Reset so it can fire again next time
                    end
                end
            end
        end
    end
end)

-- WalkSpeed Handler (Only updates when WalkSpeed is different)
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")    
    removeFlyingFixer()
end)

local placeId = game.PlaceId
local currentJobId = game.JobId
local MAX_ATTEMPTS = 5  -- Limit the number of attempts
local TeleportService = game:GetService("TeleportService")
local localPlayer = game.Players.LocalPlayer

local visitedServers = {}
local serversFile = "reavscripts/VisitedServers.json"
local retryDelay = 5  -- Starting delay after a failed attempt
local maxRetryDelay = 30  -- Maximum delay after multiple failed attempts

-- Load previously visited servers
if isfile(serversFile) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(serversFile))
    end)
    if success and type(data) == "table" then
        visitedServers = data
    end
end

-- Save visited servers
local function saveVisitedServers()
    writefile(serversFile, HttpService:JSONEncode(visitedServers))
end

-- Find a fresh server
local function findNewServer()
    local cursor = ""
    while true do
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)

        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= currentJobId and not visitedServers[server.id] then
                    visitedServers[server.id] = true
                    saveVisitedServers()
                    return server.id
                end
            end
        end

        if data.nextPageCursor then
            cursor = data.nextPageCursor
        else
            break
        end
    end
    return nil -- No fresh server found
end

local teleporting = false

local function hopServer()
    if teleporting then return end
    teleporting = true
    
    local attempts = 0
    local retryDelay = initialRetryDelay or 1
    local maxRetryDelay = maxRetryDelay or 60
    
    while attempts < MAX_ATTEMPTS do
        local serverId = findNewServer()
        if serverId then
            Fluent:Notify({ Title = "Dungeon", Content = " Hopping to JobId: " .. serverId, Duration = 3 })
            TeleportService:TeleportToPlaceInstance(placeId, serverId, localPlayer)
            teleporting = false
            return
        else
            attempts = attempts + 1
            Fluent:Notify({ Title = "Dungeon", Content = " No new servers found! Attempt " .. attempts .. " of " .. MAX_ATTEMPTS, Duration = 3 })
            task.wait(retryDelay)
            retryDelay = math.min((retryDelay or 1) * 2, maxRetryDelay or 60)
        end
    end
    teleporting = false
    Fluent:Notify({ Title = "Dungeon", Content = " Failed to find a new server after " .. MAX_ATTEMPTS .. " attempts. Retrying later.", Duration = 3 })
end


local larudaState = false

-- Load config
local configData = {}
if isfile(dungeonConfigPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(dungeonConfigPath))
    end)
    if success and type(data) == "table" then
        configData = data
    end
end

-- Save config
local function saveLarudaConfig(value)
    configData.LarudaFarm = value
    writefile(dungeonConfigPath, HttpService:JSONEncode(configData))
end

local function isLarudaTime()
    local timeTable = os.date("*t")
    local weekday = timeTable.wday
    local minutes = timeTable.min
    if not minutes then return false end
    if weekday >= 2 and weekday <= 5 then
        return minutes >= 30 and minutes <= 42
    else
        return (minutes >= 0 and minutes <= 12) or (minutes >= 30 and minutes <= 42)
    end
end

-- KindamaCityPositions
local KindamaCityPositions = { 
    { name = "Baira Brute", pos = Vector3.new(-4264.6875, 21.9620304107666, 5743.556640625) }, 
    { name = "Baira Brute", pos = Vector3.new(-4447.93603515625, 20.962032318115234, 6053.40771484375) }, 
    { name = "Lomo Brute", pos = Vector3.new(-4183.54931640625, 20.962034225463867, 6098.5234375) }, 
    { name = "Lomo Brute", pos = Vector3.new(-4291.3447265625, 22.435827255249023, 6346.900390625) }, 
    { name = "Shrimp Brute", pos = Vector3.new(-4584.20751953125, 20.962032318115234, 5904.73388671875) }, 
    { name = "Shrimp Brute", pos = Vector3.new(-4522.884765625, 20.962034225463867, 5764.294921875) } 
}

-- Solo2World Positions
local HunterCityPositions = { 
    { name = "Wuiri Brute", pos = Vector3.new(5300.2607421875, 24.55080795288086, -6125.78857421875) }, 
    { name = "Wuiri Brute", pos = Vector3.new(5471.6103515625, 25.551197052001953, -6270.6689453125) }, 
    { name = "Chris Brute", pos = Vector3.new(5298.38330078125, 24.550804138183594, -6382.25146484375) }, 
    { name = "Chris Brute", pos = Vector3.new(6161.07421875, 25.5511417388916, -6605.998046875) }, 
    { name = "Gernnart Brute", pos = Vector3.new(5841.50927734375, 25.55118179321289, -6715.8876953125) }, 
    { name = "Gernnart Brute", pos = Vector3.new(5459.17431640625, 25.55127716064453, -6451.51123046875) } 
}

-- Helper to read enemy HP text
local function getHPText(enemy)
    local healthBar = enemy:FindFirstChild("HealthBar")
    if healthBar and healthBar.Main and healthBar.Main.Bar and healthBar.Main.Bar.Amount then
        return healthBar.Main.Bar.Amount.Text or "0 HP"
    end
    return "0 HP"
end

Tabs.WinterHunter:AddParagraph({
    Title = "❄️ ALL + Huter City Farm ✊",
    Content = "The following toggle will autofarm\nEvery npc that give exp and\nWhen outside event time or cleared it will farm Hunter City"
})

local larudaPositions = {
    Vector3.new(4513.5146484375, 30.508359909057617, -1871.9812011718755),
    Vector3.new(4821.76806640625, 32.7220344543457, -2045.9658203125)
}

local function areWinterEnemiesAlive(enemiesFolder)
    for _, npc in ipairs(enemiesFolder:GetChildren()) do
        local healthBar = npc:FindFirstChild("HealthBar")
        local title = healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Title")
        if title then
            local name = title.Text
            if name == "High Frost" or name == "Laruda" or name == "Snow Monarch" or name == "Winter Bear" or name == "Metal" then
                local hpText = healthBar.Main.Bar.Amount.Text
                if hpText ~= "0 HP" then
                    return true
                end
            end
        end
    end
    return false
end

local function allWinterEnemiesDefeated(enemiesFolder)
    for _, pos in ipairs(larudaPositions) do
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(pos)
        end
        task.wait(3) -- Attendere 3 secondi per caricare gli NPC
        local enemies = enemiesFolder:GetChildren()
        for _, enemy in ipairs(enemies) do
            local healthBar = enemy:FindFirstChild("HealthBar")
            local title = healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Title")
            if title then
                local name = title.Text
                if name == "High Frost" or name == "Laruda" or name == "Snow Monarch" or name == "Winter Bear" or name == "Metal" then
                    local hpText = healthBar.Main.Bar.Amount.Text
                    if hpText ~= "0 HP" then
                        return false
                    end
                end
            end
        end
    end
    return true
end


-- Updated toggle logic
local wasLarudaTime = false

local function farmHunterCity()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, spot in ipairs(HunterCityPositions) do
        root.CFrame = CFrame.new(spot.pos)
        task.wait(1.5)

        local closestEnemy, closestDist = nil, math.huge

        for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
            local healthBar = enemy:FindFirstChild("HealthBar")
            local mainBar = healthBar and healthBar:FindFirstChild("Main")
            local title = mainBar and mainBar:FindFirstChild("Title")
            local enemyName = title and title.Text

            if enemyName == spot.name and enemy.Parent == enemiesFolder then
                local hrp = enemy:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (root.Position - hrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestEnemy = enemy
                    end
                end
            end
        end

        if closestEnemy and larudaState then
			teleportToEnemy(closestEnemy)
			task.wait(0.05)

			local shadowUsed = false
			currentTarget = closestEnemy.Name

			while larudaState and closestEnemy.Parent == enemiesFolder do
				task.wait(0.01)

				if useShadowHit and not shadowUsed then
					shadowUsed = true
					shadowDamage(closestEnemy.Name)
				end

				local hp = getHPText(closestEnemy)
				if hp == "0 HP" then
					task.wait(0.1)
					local hrp = closestEnemy:FindFirstChild("HumanoidRootPart")
					if hrp and hrp:FindFirstChild("LeftTime") then
						ariseAction(closestEnemy.Name)
					end
					task.wait(1.3)
					break
				end
			end
			currentTarget = nil
		end
    end
end

local function farmWinterIsland()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, pos in ipairs(larudaPositions) do
        root.CFrame = CFrame.new(pos)
        task.wait(1.5)

        if areWinterEnemiesAlive(workspace.__Main.__Enemies.Client) then
            Fluent:Notify({ Title = "❄ Laruda Time!", Content = "Farming High Frost, Laruda, etc.", Duration = 5 })

            for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                local healthBar = enemy:FindFirstChild("HealthBar")
                local mainBar = healthBar and healthBar:FindFirstChild("Main")
                local title = mainBar and mainBar:FindFirstChild("Title")
                local enemyName = title and title.Text

                if enemyName == "High Frost" or enemyName == "Laruda" or enemyName == "Snow Monarch" or enemyName == "Winter Bear" or enemyName == "Metal" then
                    teleportToEnemy(enemy)
                    task.wait(0.2)

                    local shadowUsed = false
                    currentTarget = enemy.Name

					while larudaState do
						task.wait(0.05)

						if useShadowHit and not shadowUsed then
							shadowUsed = true
							shadowDamage(enemy.Name)
							if not useShadowHit then break end
						end

						local hrp = enemy:FindFirstChild("HumanoidRootPart")
						local hpText = getHPText(enemy)
						local hasLeftTime = hrp and hrp:FindFirstChild("LeftTime")

						if hpText == "0 HP" and hasLeftTime then
							for i = 1, 15 do
								ariseAction(enemy.Name)
								task.wait(0.1)
							end
							break
						end

						if not enemy.Parent then break end
					end

                    currentTarget = nil 
                end
            end
        end
    end
end

Tabs.WinterHunter:AddToggle("LarudaFarmToggle", {
    Title = "❄ ALL + Hunter City Farm",
    Default = configData.LarudaFarm or false,
    Callback = function(state)
        larudaState = state
        saveLarudaConfig(state)
        if state then
            taskHandle = task.spawn(function()
                while task.wait(0.1) and larudaState do
                    if isLarudaTime() then
                        farmWinterIsland()
                        if larudaState and allWinterEnemiesDefeated(workspace.__Main.__Enemies.Client) then
                            farmHunterCity()
                        end
                    else
                        farmHunterCity()
                    end
                end
            end)
        else
            if taskHandle then
                task.cancel(taskHandle)
            end
        end
    end
})

spawn(function()
    while true do
        task.wait(.05)
        if currentTarget and (larudaState or specificState) then
            swordDamage(currentTarget)
        end
    end
end)


local larudaTask
-- Load config from file
if isfile(dungeonConfigPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(dungeonConfigPath))
    end)
    
    -- If loading succeeds and the data is a table, use it
    if success and type(data) == "table" then
        configData = data
    else
        -- Handle invalid or corrupted config (fallback to defaults)
        warn("Failed to load config or invalid data. Using defaults.")
        configData = { LarudaServerHopFarm = false }  -- Default values
    end
else
    -- If no config file exists, use defaults
    configData = { LarudaServerHopFarm = false }
end

-- Save config
local function saveLarudaServerHopFarmConfig(value)
    configData.LarudaServerHopFarm = value
    local success, err = pcall(function()
        writefile(dungeonConfigPath, HttpService:JSONEncode(configData))
    end)
    
    -- Check if save succeeded
    if not success then
        warn("Failed to save config:", err)
    end
end

-- Add information to the UI
Tabs.WinterHunter:AddParagraph({
    Title = "❄️ Laruda Serverhop + Hunter City Farm",
    Content = "The following toggle will autofarm High Frost and Laruda\n When nothing found serverhop will occur.\nWhen outside event time or cleared it will farm Hunter City"
})

local function handleLarudaNotification(currentLaruda)
    if currentLaruda and not wasLarudaTime then
        Fluent:Notify({
            Title = " Event Time!",
            Content = "Event is on! Let's check for Laruda!",
            Duration = 6
        })
    elseif not currentLaruda and wasLarudaTime then
        Fluent:Notify({
            Title = " Event Ended ",
            Content = "Returning to XZ City farming until next event!",
            Duration = 6
        })
    end
    wasLarudaTime = currentLaruda
end

local function farmLarudaOrHighFrost()
    local enemiesFolder = workspace.__Main.__Enemies.Client
    local larudaTeleportPosition = Vector3.new(5004.945, 29.726, -2107.045)

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(larudaTeleportPosition)
    end
    task.wait(2)

    local foundTarget = false
    for _, npc in ipairs(enemiesFolder:GetChildren()) do
        if npc:IsA("Model") then
            local healthBar = npc:FindFirstChild("HealthBar")
            local title = healthBar and healthBar.Main and healthBar.Main.Title
            if title and (title.Text == "High Frost" or title.Text == "Laruda") then
                local enemyRoot = getEnemyRootPart(npc)
                local hpText = healthBar.Main.Bar.Amount.Text
                if enemyRoot and hpText ~= "0 HP" then
                    foundTarget = true
                    teleportToEnemy(npc)
                    repeat
                        task.wait(0.1)
                        if not larudaState then return true end
                        hpText = healthBar.Main.Bar.Amount.Text
                    until hpText == "0 HP" or not larudaState

                    if title.Text == "Laruda" and hpText == "0 HP" then
                        task.wait(2)
                    end
                    task.wait(1)
                end
            end
        end
    end

    if not foundTarget then
        -- Delay server hop if no Laruda/High Frost found
        task.spawn(function()
            while larudaState do
                task.wait(2)
                for _, npc in ipairs(enemiesFolder:GetChildren()) do
                    local healthBar = npc:FindFirstChild("HealthBar")
                    local title = healthBar and healthBar.Main and healthBar.Main.Title
                    if title and (title.Text == "Laruda" or title.Text == "High Frost") then
                        return
                    end
                end
                hopServer()
                break
            end
        end)
    end

    return true
end

local function fallbackKindamaFarming()
    local enemiesFolder = workspace.__Main.__Enemies.Client
    for _, spot in ipairs(HunterCityPositions) do
        if not larudaState then break end

        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(spot.pos)
            print("Teleporting to Kindama City farming spot:", spot.name)
        else
            print("Player's HumanoidRootPart not found. Skipping spot.")
            break
        end

        task.wait(0.5)

        local closestEnemy, closestDistance = nil, math.huge
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            local healthBar = enemy:FindFirstChild("HealthBar")
            local title = healthBar and healthBar.Main and healthBar.Main.Title
            if title and title.Text == spot.name then
                local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
                if enemyHRP then
                    local distance = (hrp.Position - enemyHRP.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestEnemy = enemy
                    end
                end
            end
        end

        if closestEnemy then
            teleportToEnemy(closestEnemy)
            while larudaState and closestEnemy do
                task.wait(0.05)
                local hpText = getHPText(closestEnemy)
                if hpText == "0 HP" then
                    task.wait(1.3)
                    break
                end
            end
        else
            print("No valid enemy found at this spot.")
        end

        task.wait(0.5)
    end
end

local function monitorLarudaLoop()
    while larudaState do
        local currentLaruda = isLarudaTime()
        handleLarudaNotification(currentLaruda)

        if currentLaruda then
            farmLarudaOrHighFrost()
        else
            fallbackKindamaFarming()
        end
    end
end

local larudaToggle = Tabs.WinterHunter:AddToggle("LarudaHighFrostFarmToggle", {
    Title = "❄️ Laruda + Server Hop ",
    Default = configData.LarudaServerHopFarm or false,
    Callback = function(state)
        larudaState = state
        saveLarudaServerHopFarmConfig(state)

        if state then
            larudaTask = task.spawn(monitorLarudaLoop)
        else
            if larudaTask then
                task.cancel(larudaTask)
                larudaTask = nil
            end
        end
    end
})

local remote = game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent")

-- Load config
local config = {}
if isfile(dungeonConfigPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(dungeonConfigPath))
    end)
    if success and typeof(data) == "table" then
        config = data
    end
end

-- Default states
local dungeonStateWithItems = config.AutoDungeonWithItems or false
local savedItems = config.SelectedItems or {}

-- Gather inventory
local displayToInternalMap = {}
local slotItems = {"None"}
local validInternalItems = {}

for _, item in ipairs(LocalPlayer.PlayerGui.__Disable.Menus.Inventory.Main.Lists.Items:GetChildren()) do
    if item.Name:sub(1, 2) == "Dg" then
        local main = item:FindFirstChild("Main")
        local valueLabel = main and main:FindFirstChild("Value")
        local amountLabel = main and main:FindFirstChild("Amount")

        local rawName = item.Name
        local displayText = valueLabel and valueLabel.Text or rawName
        local amountText = amountLabel and amountLabel.Text:gsub("AMOUNT:%s*", "") or ""
        local displayName = displayText .. (amountText ~= "" and " x" .. amountText or "")

        table.insert(slotItems, displayName)
        displayToInternalMap[displayName] = rawName
        validInternalItems[rawName] = true
    end
end

-- Rebuild dropdown values based on saved internal names
local selectedItems = {}
for _, internal in ipairs(savedItems) do
    for display, raw in pairs(displayToInternalMap) do
        if raw == internal then
            table.insert(selectedItems, display)
        end
    end
end
if #selectedItems == 0 then selectedItems = {"None"} end

-- Add Dropdown
local itemDropdown = Tabs.DungeonHunter:AddDropdown("itemSelectDropdown", {
    Title = "🎒 Select Items",
    Values = slotItems,
    Multi = true,
    Default = selectedItems,
})

itemDropdown:OnChanged(function(Value)
    selectedItems = {}
    local internalItemsToSave = {}

    for itemName, isSelected in next, Value do
        if isSelected then
            local internal = displayToInternalMap[itemName]
            if internal then
                table.insert(selectedItems, internal)
                table.insert(internalItemsToSave, internal)
            end
        end
    end

    if #selectedItems > 2 then
        Fluent:Notify({
            Title = "Dungeon",
            Content = "❌ You can select only up to 2 items.",
            Duration = 3
        })
        for i = #selectedItems, 3, -1 do
            table.remove(selectedItems, i)
            table.remove(internalItemsToSave, i)
        end
        local displayToReset = {}
        for _, v in ipairs(selectedItems) do
            for display, internal in pairs(displayToInternalMap) do
                if internal == v then
                    table.insert(displayToReset, display)
                end
            end
        end
        itemDropdown:SetValue(displayToReset)
    end

    config.SelectedItems = internalItemsToSave
    writefile(dungeonConfigPath, HttpService:JSONEncode(config))
end)

-- Save toggle
local function saveDungeonStateWithItems(state)
    config.AutoDungeonWithItems = state
    writefile(dungeonConfigPath, HttpService:JSONEncode(config))
end

-- Toggle
local DungeonToggleWithItems = Tabs.DungeonHunter:AddToggle("dungeonStateWithItems", {
    Title = "🔁 Auto Dungeon With/Without Items",
    Description = "Farm Dungeon with or without selected items ♾️",
    Default = dungeonStateWithItems,
    Callback = function(state)
        dungeonStateWithItems = state
        saveDungeonStateWithItems(state)
    end
})

-- Utility to prevent dungeon start at specific minutes
local function shouldSkipDueToMinute()
    local currentUtc = os.date("!*t")
    local badMinutes = {14, 29, 44, 59}
    for _, m in ipairs(badMinutes) do
        if currentUtc.min == m then
            return true
        end
    end
    return false
end

-- Dungeon start function with toggle-aware logic and minute check
local function startDungeonWithItems()
    task.spawn(function()
        while dungeonStateWithItems do
            if shouldSkipDueToMinute() then
                Fluent:Notify({
                    Title = "Dungeon",
                    Content = "⏱️ Waiting... Cannot start at minute 14, 29, 44, or 59 UTC.",
                    Duration = 3
                })
                task.wait(10) -- Check every 10 seconds
            else
                -- Passed the bad minutes check, continue with dungeon logic
                Fluent:Notify({ Title = "Dungeon", Content = "⏱️ AutoDungeon is going to begin.", Duration = 3 })
                task.wait(4)
                if not dungeonStateWithItems then return end

                remote:FireServer({{
                    ["Type"] = "Gems",
                    ["Event"] = "DungeonAction",
                    ["Action"] = "BuyTicket"
                }, "\n"})
                Fluent:Notify({ Title = "Dungeon", Content = "🎟️ Ticket bought!", Duration = 3 })
                task.wait(1)
                if not dungeonStateWithItems then return end

                remote:FireServer({{
                    ["Event"] = "DungeonAction",
                    ["Action"] = "Create"
                }, "\n"})
                Fluent:Notify({ Title = "Dungeon", Content = "🏰 Dungeon created!", Duration = 3 })
                task.wait(1)
                if not dungeonStateWithItems then return end

                if #selectedItems == 0 or selectedItems[1] == "None" then
                    remote:FireServer({{
                        ["Event"] = "DungeonAction",
                        ["Action"] = "Start"
                    }, "\n"})
                    Fluent:Notify({ Title = "Dungeon", Content = "⚔️ Dungeon started without items!", Duration = 3 })
                else
                    for i, item in ipairs(selectedItems) do
                        if not dungeonStateWithItems then return end
                        remote:FireServer({{
                            ["Dungeon"] = LocalPlayer.UserId,
                            ["Action"] = "AddItems",
                            ["Slot"] = i,
                            ["Event"] = "DungeonAction",
                            ["Item"] = item
                        }, "\n"})
                        Fluent:Notify({ Title = "Dungeon", Content = "📦 Added item: " .. item, Duration = 3 })
                        task.wait(1)
                    end

                    if not dungeonStateWithItems then return end
                    remote:FireServer({{
                        ["Event"] = "DungeonAction",
                        ["Action"] = "Start"
                    }, "\n"})
                    Fluent:Notify({ Title = "Dungeon", Content = "⚔️ Dungeon started with items!", Duration = 3 })
                end

                break -- Exit loop after successful start
            end
        end
    end)
end

-- Check the toggle state and start the dungeon if enabled
DungeonToggleWithItems:OnChanged(function(state)
    if state then
        startDungeonWithItems()  -- Start dungeon when toggle is turned on
    else
        Fluent:Notify({
            Title = "Dungeon",
            Content = "❌ Auto Dungeon with/without Items disabled.",
            Duration = 3
        })
    end
end)

local gui = LocalPlayer:WaitForChild("PlayerGui")

-- REJOIN PRIVATE SERVER
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

-- Utility functions for config loading and saving
local function loadConfig(path)
    local success, result = pcall(function()
        if isfile(path) then
            return HttpService:JSONDecode(readfile(path))
        end
    end)
    if success then

    else

    end
    return (success and result) or { enabled = false }
end

local function saveConfig(path, state)
    local data = { enabled = state }
    writefile(path, HttpService:JSONEncode(data))
end

-- Watchdog to handle memory usage and auto-rejoin if needed
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
    local isRunning = true
    currentTarget = nil 

    local damageLoop = task.spawn(function()
        while isRunning do
            task.wait(0.001)
            if currentTarget and currentTarget ~= "" and getRunning() then
                -- Call swordDamage safely
                local success, err = pcall(function()
                    swordDamage(currentTarget)
                end)
                if not success then
                    warn("swordDamage error:", err)
                end
            end
        end
    end)

    task.spawn(function()
        while getRunning() do
            for _, spot in ipairs(positions) do
                if not getRunning() then break end
                
                local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not playerRoot then
                    print("Player's HumanoidRootPart not found; skipping spot:", spot.name)
                    task.wait(1)
                    break
                end
                playerRoot.CFrame = CFrame.new(spot.pos + Vector3.new(0, 5, 0))
                task.wait(0.5)
                local closestEnemy, closestDistance = nil, math.huge
                local enemies = enemiesFolder:GetChildren()
                for _, enemy in ipairs(enemies) do
                    local healthBar = enemy:FindFirstChild("HealthBar")
                    local main = healthBar and healthBar:FindFirstChild("Main")
                    local title = main and main:FindFirstChild("Title")
                    local enemyName = title and title.Text

                    if enemyName == spot.name and enemy.Parent == enemiesFolder then
                        local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyHRP then
                            local distance = (playerRoot.Position - enemyHRP.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestEnemy = enemy
                            end
                        end
                    end
                end
                if closestEnemy and closestEnemy.Parent == enemiesFolder then
                    teleportToEnemy(closestEnemy)
                    currentTarget = closestEnemy.Name
                    task.wait(0.1)
                    local shadowUsed = false
                    while getRunning() and closestEnemy and closestEnemy.Parent == enemiesFolder do
                        task.wait(0.1)
                        if useShadowHit and not shadowUsed then
                            shadowUsed = true
                            shadowDamage(closestEnemy.Name)
                        end

                        local hpText = getHPText(closestEnemy)
                        if hpText == "0 HP" then
                            for i = 1, 10 do
                                ariseAction(closestEnemy.Name)
                                task.wait(0.07)
                            end
                            shadowHit[closestEnemy] = nil
                            break
                        end
                    end
                    currentTarget = nil
                else
                    print("No valid enemy found at spot:", spot.name)
                end
            end
        end
        isRunning = false
        currentTarget = nil
    end)
end


Tabs.Autofarm:AddParagraph({
    Title = "💪 Brutes Autofarm",
    Content = "This autofarm is meant to be used with autodestroy gamepass \nOtherwise npcs wont respawn in time. Buy it with tickets noob"
})

-- New names for DragonCity autofarm configuration and positions
local dragonIslandPath = "reavscripts/DragonIslandConfig.json"
local dragonIslandPositions = {
    { name = "Turtle Brute", pos = Vector3.new(-6771.49, 27.20, -160.97) },
    { name = "Turtle Brute", pos = Vector3.new(-6344.54, 26.19, 33.05) },
    { name = "Green Brute", pos = Vector3.new(-6728.24, 27.20, 318.67) },
    { name = "Green Brute", pos = Vector3.new(-7375.45, 27.19, -745.51) },
    { name = "Sky Brute", pos = Vector3.new(-7565.46, 28.20, -351.83) },
    { name = "Sky Brute", pos = Vector3.new(-7040.63, 28.19, -752.75) }
}
local dragonIslandState = loadConfig(dragonIslandPath)
local dragonIslandRunning = dragonIslandState.enabled

-- Add toggle for DragonIsland autofarm
Tabs.Autofarm:AddToggle("dragonIslandState", {
    Title = "🐉 DragonCity AutoFarm ㊙️",
    Default = dragonIslandRunning,
    Callback = function(value)
        dragonIslandRunning = value
        saveConfig(dragonIslandPath, value)
        if value then
            memoryWatchdog(function() return dragonIslandRunning end)
            autoFarmLoop(function() return dragonIslandRunning end, dragonIslandPath, dragonIslandPositions)
        end
    end
})

-- New names for XZCity autofarm configuration and positions
local XZCityPath = "reavscripts/XZCityConfig.json"
local XZCityPositions = {
    { name = "Cyborg Brute", pos = Vector3.new(5765.88, 25.59, 4664.02) },
    { name = "Cyborg Brute", pos = Vector3.new(6099.98, 25.59, 4924.84) },
    { name = "Hurricane Brute", pos = Vector3.new(6022.10, 356.26, 4963.73) },
    { name = "Hurricane Brute", pos = Vector3.new(5669.92, 26.09, 4908.05) },
    { name = "Rider Brute", pos = Vector3.new(6074.61, 26.09, 4417.30) },
    { name = "Rider Brute", pos = Vector3.new(6038.87, 26.09, 5387.69) }
}
local XZCityState = loadConfig(XZCityPath)
local XZCityRunning = XZCityState.enabled

-- Add toggle for XZCity autofarm
Tabs.Autofarm:AddToggle("XZCityState", {
    Title = "👊 XZCity AutoFarm 👽",
    Default = XZCityRunning,
    Callback = function(value)
        XZCityRunning = value
        saveConfig(XZCityPath, value)
        if value then
            memoryWatchdog(function() return XZCityRunning end)
            autoFarmLoop(function() return XZCityRunning end, XZCityPath, XZCityPositions)
        end
    end
})

-- KindamaCity Config Path and Positions
local KindamaCityPath = "reavscripts/KindamaCityConfig.json"
local KindamaCityState = loadConfig(KindamaCityPath)
local KindamaCityRunning = KindamaCityState.enabled

-- Add toggle for KindamaCity autofarm
Tabs.Autofarm:AddToggle("KindamaCityState", {
    Title = "🛸 KindamaCity AutoFarm 👹",
    Default = KindamaCityRunning,
    Callback = function(value)
        KindamaCityRunning = value
        saveConfig(KindamaCityPath, value)
        if value then
            memoryWatchdog(function() return KindamaCityRunning end)
            autoFarmLoop(function() return KindamaCityRunning end, KindamaCityPath, KindamaCityPositions)
        end
    end
})

-- HunterCity Config Path and Positions
local HunterCityPath = "reavscripts/HunterCityConfig.json"
local HunterCityState = loadConfig(HunterCityPath)
local HunterCityRunning = HunterCityState.enabled

-- Add toggle for KindamaCity autofarm
Tabs.Autofarm:AddToggle("HunterCityState", {
    Title = "🗡️ HunterCity AutoFarm 🌌",
    Default = HunterCityRunning,
    Callback = function(value)
        HunterCityRunning = value
        saveConfig(HunterCityPath, value)
        if value then
            memoryWatchdog(function() return HunterCityRunning end)
            autoFarmLoop(function() return HunterCityRunning end, HunterCityPath, HunterCityPositions)
        end
    end
})




-- Load config
local castleConfig = {}
if isfile(dungeonConfigPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(dungeonConfigPath))
    end)
    if success and typeof(data) == "table" then
        castleConfig = data
    end
end

-- Save function
local function saveCastleConfig()
    castleConfig.AutoCastle = autoCastleEnabled
    castleConfig.CastleStartMode = castleStartMode
    castleConfig.CheckpointFloor = checkpointFloor
    writefile(dungeonConfigPath, HttpService:JSONEncode(castleConfig))
end

-- Default values
local autoCastleEnabled = castleConfig.AutoCastle or false
local castleStartMode = castleConfig.CastleStartMode or "Stage 1"
local checkpointFloor = castleConfig.CheckpointFloor or "30"

-- Dropdown floors
local checkpointFloors = {}
for i = 10, 90, 10 do
    table.insert(checkpointFloors, tostring(i))
end

-- Sanitize loaded checkpointFloor
local validFloors = {}
for _, v in ipairs(checkpointFloors) do
    validFloors[v] = true
end

if not validFloors[checkpointFloor] then
    checkpointFloor = "30"  -- fallback to default valid floor
end

-- Dropdown for start mode
local castleDropdown = Tabs.DungeonHunter:AddDropdown("castleStartDropdown", {
    Title = "🔥 Infernal Castle Start Mode",
    Description = "Choose how to enter the castle",
    Values = { "Stage 1", "Checkpoint" },
    Default = castleStartMode,
})

castleDropdown:OnChanged(function(value)
    castleStartMode = value
    saveCastleConfig()
end)

local floorDropdown = Tabs.DungeonHunter:AddDropdown("checkpointFloorDropdown", {
    Title = "🏰 Castle Checkpoint Floor",
    Description = "Select the floor to start from at checkpoint",
    Values = checkpointFloors,
    Default = checkpointFloor,
})

floorDropdown:OnChanged(function(value)
    checkpointFloor = value
    saveCastleConfig()
end)

-- Toggle for Auto Castle
local autoCastleToggle = Tabs.DungeonHunter:AddToggle("autoCastleToggle", {
    Title = "🔥 Auto Infernal Castle",
    Description = "Automatically enter Castle during Castle time.",
    Default = autoCastleEnabled,
    Callback = function(state)
        autoCastleEnabled = state
        saveCastleConfig()
    end
})

-- Castle Time Checker
local function isCastleTime()
    local time = os.date("!*t")
    return time.min >= 45 and time.min < 57
end

-- Auto Castle Join Logic
task.spawn(function()
    while true do
        if autoCastleEnabled and isCastleTime() then
            Fluent:Notify({
                Title = "Infernal Castle",
                Content = "🔥 Infernal Castle run is starting in 5 seconds...",
                Duration = 3
            })
            task.wait(5)

            -- Buy Ticket
            local ticketArgs = {
                [1] = {
                    [1] = {
                        ["Type"] = "Gems",
                        ["Event"] = "CastleAction",
                        ["Action"] = "BuyTicket"
                    },
                    [2] = "\n"
                }
            }
            game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(ticketArgs))
            task.wait(1)

            -- Join Castle based on mode and floor
            local joinPayload = {
                ["Check"] = (castleStartMode == "Checkpoint"),
                ["Event"] = "CastleAction",
                ["Action"] = "Join"
            }

            if joinPayload.Check then
                joinPayload["Floor"] = checkpointFloor
            end

            local joinArgs = {
                [1] = {
                    [1] = joinPayload,
                    [2] = "\n"
                }
            }

            game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(joinArgs))

            Fluent:Notify({
                Title = "Infernal Castle",
                Content = "✅ Infernal Castle joined using: " .. (joinPayload.Check and ("Checkpoint (Floor " .. checkpointFloor .. ")") or "Stage 1"),
                Duration = 4
            })

            -- Prevent spamming - wait until next valid window
            repeat task.wait(5) until not isCastleTime()
        else
            task.wait(5)
        end
    end
end)

--TELEPORTS
-- Utility
local function safeTeleport(cframe)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cframe
    else
        warn("HumanoidRootPart not found")
    end
end

local function safePivot(model)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:PivotTo(model:GetPivot())
    else
        warn("PivotTo failed: HumanoidRootPart not found")
    end
end
-- ➕ EXTRAS SECTION (Ordered)
do
    local teleportLocations = {
        ["Rank UP ⏫"] = function()
            task.delay(1.5, function()
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
            end)
        end,

		["Winter Island ❄️"] = function()
			safeTeleport(CFrame.new(4509.627, 75.508, -1863.173))
		end,

        ["Jeju Island 🏝"] = function()
            safeTeleport(CFrame.new(4012.385, 60.36, 3318.841))
        end,
    }

	local orderedExtras = {       
		"Winter Island ❄️",
		"Jeju Island 🏝",  -- Added the missing comma
		"Rank UP ⏫",       -- Now the list is correctly ordered
	}
    for _, name in ipairs(orderedExtras) do
        Tabs.Teleports:AddButton({
            Title = name,
            Description = "Teleport to " .. name,
            Callback = teleportLocations[name]
        })
    end
end


-- 🏙️ CITIES SECTION
do
    local customNames = {
        SoloWorld = "1. Solo City",
        NarutoWorld = "2. Grass Village",
        OPWorld = "3. Brum Village",
        BleachWorld = "4. FaceHeal Town",
        BCWorld = "5. Lucky Kingdom",
        ChainsawWorld = "6. Nipon City",
        JojoWorld = "7. Mori Town",
        DBWorld = "8. Dragon City",
        OPMWorld = "9. XZ City",
		DanWorld = "10. Kindama City",
		Solo2World = "11. Hunters City"
    }

    local orderedSpawns = {
        "SoloWorld",
        "NarutoWorld",
        "OPWorld",
        "BleachWorld",
        "BCWorld",
        "ChainsawWorld",
        "JojoWorld",
        "DBWorld",
        "OPMWorld",
		"DanWorld",
		"Solo2World"
    }

    for _, spawnName in ipairs(orderedSpawns) do
        local spawnPoint = workspace["__Extra"]["__Spawns"]:FindFirstChild(spawnName)
        if spawnPoint and spawnPoint:IsA("SpawnLocation") then
            local displayName = customNames[spawnPoint.Name] or spawnPoint.Name
            Tabs.Teleports:AddButton({
                Title = displayName,
                Description = "Teleport to " .. displayName,
                Callback = function()
                    safeTeleport(CFrame.new(spawnPoint.Position))
                end
            })
        end
    end
end

-- 🔹 MOUNTS SECTION
do
    local wilds = workspace.__Main.__World:FindFirstChild("Wilds")
    local appear = workspace.__Extra:FindFirstChild("__Appear")

    if wilds and appear then
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
                autofarmState = false
                task.spawn(function()
                    for _, model in ipairs(wildsList) do
                        if #appear:GetChildren() > 0 then break end
                        safePivot(model)
                        task.wait(2)
                    end

                    if #appear:GetChildren() > 0 then
                        print("Something appeared in __Appear!")
                    else
                        print("Nothing appeared after one full loop.")
                    end
                end)
            end
        })
    else
        warn("Mount section skipped: Wilds or __Appear not found.")
    end
end



--
local GuildListSection = Tabs.GuildMaster:AddSection("Members List 📃")
local guildEntries = {}
local donationHistory = {}
local dailyDonations = {}
local expHistory = {}
local dailyExp = {}

-- File paths
local savePath = "reavscripts/GuildDonations.json"
local dailyDonationsPath = "reavscripts/DailyDonations.json"
local expSavePath = "reavscripts/GuildExp.json"
local dailyExpPath = "reavscripts/DailyExp.json"

-- Load all history data
local function loadHistoryData()
    local function loadData(filePath)
        if isfile(filePath) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(filePath))
            end)
            if success and typeof(data) == "table" then
                return data
            end
        end
        return {}
    end

    donationHistory = loadData(savePath)
    dailyDonations = loadData(dailyDonationsPath)
    expHistory = loadData(expSavePath)
    dailyExp = loadData(dailyExpPath)
end


loadHistoryData()

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

local function getGuildFolder()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return nil end

    local possiblePaths = {
        gui:FindFirstChild("__Disable") and gui.__Disable:FindFirstChild("Menus"),
        gui:FindFirstChild("Menus")
    }

    for _, menu in ipairs(possiblePaths) do
        if menu and menu:FindFirstChild("Guilds") then
            return menu.Guilds
        end
    end
    return nil
end

local function updateGuildList()
    -- Ottieni l'elenco dei membri del gruppo
    local guildFolder = getGuildFolder()
    if not guildFolder then return end

    local listContainer = guildFolder:FindFirstChild("PlayerList") and guildFolder.PlayerList:FindFirstChild("List")
    if not listContainer then return end

    -- Crea un elenco dei membri del gruppo
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
                        UserId = tonumber(frame.Name),
                        Gems = parseGems(gemsRaw),
                        GemsText = gemsRaw,
                        Exp = exp,
                        ExpText = expRaw
                    })
                end
            end
        end
    end

    -- Pulisci le voci dei membri del gruppo
    cleanupGuildEntries(players)

    -- Ordina l'elenco dei membri del gruppo per quantità di gemme donate
    table.sort(players, function(a, b) return a.Gems > b.Gems end)

    -- Ottieni la data odierna
    local currentDate = os.date("!*t")
    local todayKey = string.format("%d-%d-%d", currentDate.year, currentDate.month, currentDate.day)

    -- Inizializza i dati delle donazioni giornaliere se non esistono
    if not dailyDonations[todayKey] then
        dailyDonations[todayKey] = {}
    end

    if not dailyExp[todayKey] then
        dailyExp[todayKey] = {}
    end

    -- Aggiorna le voci dei membri del gruppo
    for _, player in ipairs(players) do
        -- Ottieni i dati storici del giocatore
        local prevGems = donationHistory[player.Name] or 0
        local gemsDiff = player.Gems - prevGems
        local dailyGems = dailyDonations[todayKey][player.Name] or 0
        dailyGems = dailyGems + gemsDiff

        local prevExp = expHistory[player.Name] or 0
        local expDiff = player.Exp - prevExp
        local dailyGain = dailyExp[todayKey][player.Name] or 0
        dailyGain = dailyGain + expDiff

        -- Aggiorna i dati storici del giocatore
        donationHistory[player.Name] = player.Gems
        expHistory[player.Name] = player.Exp

        -- Aggiorna i dati delle donazioni giornaliere del giocatore
        dailyDonations[todayKey][player.Name] = dailyGems
        dailyExp[todayKey][player.Name] = dailyGain

        -- Crea o aggiorna la voce del giocatore nell'elenco dei membri del gruppo
        local existingParagraph = guildEntries[player.Name]
        local content = string.format(
            "\n💎 Gems Donated: %s (Daily: %s)\n\n📖 EXP Gained: %s (Daily: %s)",
            player.GemsText, formatToSuffix(dailyGems), player.ExpText, formatToSuffix(dailyGain)
        )

        if existingParagraph then
            existingParagraph.Title = player.Name
            existingParagraph.Content = content
        else
            local paragraph = GuildListSection:AddParagraph({
                Title = player.Name,
                Content = content
            })

            local kickButton = GuildListSection:AddButton({
                Title = "👟 Kick out " .. player.Name,
                Callback = function()
                    -- Codice per kickare il giocatore
					local args = {
                        { { Target = tostring(player.UserId), Event = "GuildAction", Action = "Kick" }, "\n" }
                    }
                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
                    Fluent:Notify({
                        Title = "Dungeon",
                        Content = "Kicked " .. player.Name .. " (UserId: " .. player.UserId .. ")",
                        Duration = 3
                    })
                end
            })

            guildEntries[player.Name] = { Paragraph = paragraph, KickButton = kickButton }
        end
    end

    -- Salva i dati storici
    writefile(savePath, HttpService:JSONEncode(donationHistory))
    writefile(dailyDonationsPath, HttpService:JSONEncode(dailyDonations))
    writefile(expSavePath, HttpService:JSONEncode(expHistory))
    writefile(dailyExpPath, HttpService:JSONEncode(dailyExp))
end


-- Check every minute if the day has changed
task.spawn(function()
    local lastCheckedDate = os.date("!*t")
    while true do
        task.wait(60)
        local currentDate = os.date("!*t")
        if currentDate.day ~= lastCheckedDate.day then
            lastCheckedDate = currentDate
            dailyDonations = {} -- Resetta i dati delle donazioni giornaliere
            Fluent:Notify({
                Title = "Dungeon",
                Content = " New day started. Daily donations reset.",
                Duration = 3
            })
            writefile(dailyDonationsPath, HttpService:JSONEncode(dailyDonations))
        end
    end
end)


updateGuildList()

-- Dust Swap: Common to Rare
local isSwappingCommon = false
Tabs.Utils:AddToggle("commonToRareToggle", {
    Title = "⚪️ Common x10 ➡️ Rare Dust x1 🔵",
    Default = false,
    Callback = function(enabled)
        isSwappingCommon = enabled
        if enabled then
            task.spawn(function()
                while isSwappingCommon do
                    local args = {
                        [1] = {
                            [1] = {
                                ["Item"] = "EnchRare",
                                ["Shop"] = "ExchangeShop",
                                ["Event"] = "ItemShopAction",
                                ["Action"] = "Buy"
                            },
                            [2] = "\n"
                        }
                    }
                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
                    task.wait(0.05)
                end
            end)
        end
    end
})

local legendaryToRareRunning = false

local legendaryToggle = Tabs.Utils:AddToggle("legendaryToRareToggle", {
    Title = "🔴 Legendary x1 ➡️ Rare Dust x1 🔵",
    Default = false,
    Callback = function(enabled)
        legendaryToRareRunning = enabled
        if enabled then
            task.spawn(function()
                while legendaryToRareRunning do
                    local args = {
                        [1] = {
                            [1] = {
                                ["Item"] = "EnchRare2",
                                ["Shop"] = "ExchangeShop",
                                ["Event"] = "ItemShopAction",
                                ["Action"] = "Buy"
                            },
                            [2] = "\n"
                        }
                    }

                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
                    task.wait(0.05)
                end
            end)
        end
    end
})

local rareToLegendaryRunning = false

local rareToLegendaryToggle = Tabs.Utils:AddToggle("rareToLegendaryToggle", {
    Title = "🔵 Rare x5 ➡️ Legendary x1 🔴",
    Default = false,
    Callback = function(enabled)
        rareToLegendaryRunning = enabled
        if enabled then
            task.spawn(function()
                while rareToLegendaryRunning do
                    local args = {
                        [1] = {
                            [1] = {
                                ["Shop"] = "ExchangeShop",
                                ["Action"] = "Buy",
                                ["Amount"] = 1,
                                ["Event"] = "ItemShopAction",
                                ["Item"] = "EnchLegendary"
                            },
                            [2] = "\n"
                        }
                    }

                    game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
                    task.wait(0.05)
                end
            end)
        end
    end
})

-- Rank Up x10 ➡️ Ultra Rank Up x1
Tabs.Utils:AddButton({
    Title = "🔼 Rank Up x10 ➡️ Ultra Rank Up x1 ⏫",  -- Button title
    Callback = function()
        local args = {
            [1] = {
                [1] = {
                    ["Item"] = "DgURankUpRune",
                    ["Shop"] = "ExchangeShop",
                    ["Event"] = "ItemShopAction",
                    ["Action"] = "Buy"
                },
                [2] = "\n"
            }
        }

        -- Fire the remote event to buy the item
        game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
    end
})

-- Invite
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Config
local configPath = "reavscripts/AutoInviteConfig.json"
local autoInviteOnStart = false
local serverhopEnabled = false
local selectedRanks = { ["M+"] = true }
local config = {}

-- Load Config
if isfile(configPath) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(configPath))
    end)
    if success and type(data) == "table" then
        config = data
        autoInviteOnStart = config.autoInviteOnStart or false
        serverhopEnabled = config.ServerhopToggle or false
    end
end

-- Save Config
local function saveConfig()
    writefile(configPath, HttpService:JSONEncode(config))
end

-- Rank Dropdown
local RankDropdown = Tabs.GuildInvite:AddDropdown("RankInviteDropdown", {
    Title = "☑️ Select Ranks to Invite",
    Description = "Invite guildless players with selected ranks",
    Values = { "M+","M","N+", "N", "G", "SS" },
    Multi = true,
    Default = { "M+"}
})

RankDropdown:OnChanged(function(newValues)
    selectedRanks = {}
    for _, v in ipairs(newValues) do
        selectedRanks[v] = true
    end
end)

-- Auto Invite Toggle
Tabs.GuildInvite:AddToggle("AutoInviteToggle", {
    Title = "🔁 Auto Invite on join",
    Default = autoInviteOnStart,
    Callback = function(state)
        autoInviteOnStart = state
        config.autoInviteOnStart = state
        saveConfig()
    end
})

-- Serverhop Toggle
Tabs.GuildInvite:AddToggle("ServerhopToggle", {
    Title = "🔁 Auto Serverhop 🐇",
    Default = serverhopEnabled,
    Callback = function(state)
        serverhopEnabled = state
        config.ServerhopToggle = state
        saveConfig()
    end
})

local function hopToNewServer()
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local httprequest = http and http.request or http_request or syn and syn.request
    local JobId = game.JobId
    local PlaceId = game.PlaceId
    local tried = {}

    for attempt = 1, 10 do
        local success, result = pcall(function()
            return httprequest({
                Url = string.format(
                    "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
                    PlaceId
                )
            })
        end)

        if success and result and result.Body then
            local jsonData = HttpService:JSONDecode(result.Body)
            if jsonData and jsonData.data then
                local servers = jsonData.data
                if servers then
                    for _, server in ipairs(servers) do
                        if server.id ~= JobId and not tried[server.id] and server.playing >= 13 and server.playing < server.maxPlayers then
                            tried[server.id] = true
                            local ok, err = pcall(function()
                                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Players.LocalPlayer)
                            end)
                            if not ok then
                                warn("Teleport failed:", err)
                                task.wait(5)
                            else
                                return
                            end
                        end
                    end
                else
                    warn("Servers non disponibili")
                end
            else
                warn("Risposta non valida")
            end
        else
            warn("Errore durante la richiesta")
        end
        task.wait(5)
    end
    warn("No available servers found after retries.")
    Fluent:Notify({
        Title = "Serverhop Failed",
        Content = "Could not find a new server after 10 attempts.",
        Duration = 5
    })
end


-- Invite Loop (Improved with memory)
local lastHopTime = 0
local lastInvitedIds = {}
task.spawn(function()
    while true do
        if autoInviteOnStart then
            local newInvites = {}
            for _, player in ipairs(workspace.__Main.__Players:GetChildren()) do
                if player:IsA("Model") and player:FindFirstChild("HumanoidRootPart") then
                    local tag = player.HumanoidRootPart:FindFirstChild("PlayerTag")
                    if tag then
                        local main = tag:FindFirstChild("Main")
                        local guildLabel = main and main:FindFirstChild("GuildName")
                        local rankLabel = main and main:FindFirstChild("Rank")
                        if guildLabel and rankLabel and guildLabel.Text == "LOG HORIZON" and selectedRanks[rankLabel.Text] then
                            local foundPlayer = Players:FindFirstChild(player.Name)
                            if foundPlayer and not lastInvitedIds[foundPlayer.UserId] then
                                table.insert(newInvites, foundPlayer)
                            end
                        end
                    end
                end
            end
            if #newInvites > 0 then
                for _, p in ipairs(newInvites) do
                    local args = {
                        [1] = {
                            [1] = {
                                ["Player"] = p.UserId,
                                ["Event"] = "GuildAction",
                                ["Action"] = "InvitePlayer"
                            },
                            [2] = "\n"
                        }
                    }
                    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
                    lastInvitedIds[p.UserId] = true
                    pcall(function()
                        Fluent:Notify({
                            Title = "Player Invited",
                            Content = "Invited player: " .. p.Name,
                            Duration = 3
                        })
                    end)
                    task.wait(3.5)
                end
            else
                Fluent:Notify({
                    Title = "No New Players",
                    Content = "Everyone matching the selected ranks has already been invited.",
                    Duration = 4
                })

                if serverhopEnabled then
                    local now = tick()
                    if now - lastHopTime >= 10 then 
                        task.wait(2)
                        lastHopTime = now
                        hopToNewServer()
                    else
                        Fluent:Notify({
                            Title = "Serverhop Skipped",
                            Content = "Waiting cooldown before next hop...",
                            Duration = 4
                        })
                    end
                end
            end
        end
        task.wait(10)
    end
end)
Tabs.GuildInvite:AddParagraph({
    Title = "\n\n\n",
    Content = "\n\n\n"
})

-- Add the button with proper title
Tabs.GuildInvite:AddButton({
    Title = "🐇 ServerHop",
    Description = "Hop to a server with less people.",
    Callback = function()
        hopServer()
    end
})

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

-- SETTINGS
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "FluentRestoreGui"
ScreenGui.Parent = playerGui

local restoreButton = Instance.new("TextButton")
restoreButton.AnchorPoint = Vector2.new(0, 1)
restoreButton.Position = UDim2.new(0, 10, 1, -10) -- 10px from bottom-left
restoreButton.Text = "🧐 Hide/Show reav's scripts"
restoreButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
restoreButton.BorderSizePixel = 0
restoreButton.Font = Enum.Font.Gotham
restoreButton.TextSize = 16
restoreButton.TextWrapped = true
restoreButton.Parent = ScreenGui

-- Use scale-based size for true responsiveness
local screenWidth = workspace.CurrentCamera.ViewportSize.X

if screenWidth < 800 then
    -- Mobile
    restoreButton.Size = UDim2.new(0.4, 0, 0, 32) -- 40% screen width
else
    -- PC
    restoreButton.Size = UDim2.new(0, 220, 0, 36) -- Fixed width
end

-- Track GUI visibility
local isVisible = true

restoreButton.MouseButton1Click:Connect(function()
    if Window then
        Window:Minimize()
    end
end)

-- Fluent Tab minimize still works
Tabs.Settings:AddButton({
    Title = "🔽 Minimize Window",
    Description = "Tap to minimize this UI (mobile friendly)",
    Callback = function()
        if Window then
            Window:Minimize()
        end
    end
})

Tabs.Settings:AddButton({
    Title = "Destroy The World 💥",  -- Title for the button
    Description = "",  -- Optional description
    Callback = function()
        local world = workspace:FindFirstChild("__Main") and workspace.__Main:FindFirstChild("__World")
        if world then
            for _, child in ipairs(world:GetChildren()) do
                child:Destroy()
            end
            Fluent:Notify({
                Title = "World Destroyed! 💥",
                Content = "rejoin to revert",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "",
                Duration = 5
            })
        end
    end,
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("reavscripts")
SaveManager:SetFolder("reavscripts/arisecrossover")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(Tabs.Main)

Fluent:Notify({
    Title = "reav's scripts",
    Content = "The script has been loaded.",
    Duration = 1
})

SaveManager:LoadAutoloadConfig()

end

-- File path to store the key
local keyFilePath = "reavscripts/platoboost_key.txt"
local savedKey = nil

if isfile(keyFilePath) then
    local content = readfile(keyFilePath)
    if content and content ~= "" and verifyKey(content) then
        savedKey = content
    end
end

if savedKey then
    -- Valid key exists, skip UI
    loadMainUI()
    return
end

-- UI Setup
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Clean old GUI if exists
if PlayerGui:FindFirstChild("PlatoboostKeyUI") then
    PlayerGui.PlatoboostKeyUI:Destroy()
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlatoboostKeyUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 220)
frame.Position = UDim2.new(0.5, -200, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔐 reav's scripts"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Parent = frame

-- TextBox for key input
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.9, 0, 0, 40)
keyBox.Position = UDim2.new(0.05, 0, 0.3, 0)
keyBox.PlaceholderText = "Paste your key here..."
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
keyBox.BorderSizePixel = 0
keyBox.TextSize = 18
keyBox.ClearTextOnFocus = false
keyBox.Parent = frame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyBox

-- Copy Key Link button
local linkButton = Instance.new("TextButton")
linkButton.Size = UDim2.new(0.43, 0, 0, 40)
linkButton.Position = UDim2.new(0.05, 0, 0.6, 0)
linkButton.Text = "🔗 Copy Key Link"
linkButton.Font = Enum.Font.GothamSemibold
linkButton.TextColor3 = Color3.new(1, 1, 1)
linkButton.BackgroundColor3 = Color3.fromRGB(64, 64, 64)
linkButton.TextSize = 16
linkButton.Parent = frame

local linkCorner = Instance.new("UICorner")
linkCorner.CornerRadius = UDim.new(0, 8)
linkCorner.Parent = linkButton

-- Submit Key button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0.43, 0, 0, 40)
verifyButton.Position = UDim2.new(0.52, 0, 0.6, 0)
verifyButton.Text = "✅ Submit Key"
verifyButton.Font = Enum.Font.GothamSemibold
verifyButton.TextColor3 = Color3.new(1, 1, 1)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Colore diverso
verifyButton.TextSize = 16
verifyButton.Parent = frame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 8)
verifyCorner.Parent = verifyButton

-- Shop Button
local shopButton = Instance.new("TextButton")
shopButton.Size = UDim2.new(0.9, 0, 0, 40)
shopButton.Position = UDim2.new(0.05, 0, 0.8, 0)
shopButton.Text = "🛒 Open Shop"
shopButton.Font = Enum.Font.GothamSemibold
shopButton.TextColor3 = Color3.new(1, 1, 1)
shopButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
shopButton.TextSize = 16
shopButton.Parent = frame

local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 8)
shopCorner.Parent = shopButton

-- Click behavior
shopButton.MouseButton1Click:Connect(function()
    local link = "https://reavscripts.free.nf/"

    -- Copy to clipboard if possible
    if setclipboard then
        setclipboard(link)
		onMessage("✅ Link copied to clipboard!")
    end

    -- Attempt to open in browser (if exploit allows)
    if syn and syn.request then
        syn.request({Url = link, Method = "GET"})
    elseif http and http.request then
        http.request({Url = link, Method = "GET"})
    elseif request then
        request({Url = link, Method = "GET"})
    else
        warn("No supported HTTP request function found to open the shop.")
    end
end)

-- Button logic
linkButton.MouseButton1Click:Connect(function()
    copyLink() 
    onMessage("✅ Link copied to clipboard!")
end)

verifyButton.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    local success, result = pcall(function()
        return verifyKey(key)
    end)
    if not success then
        warn("❌ Error in verifyKey:", result)
        onMessage("❌ Verification error! Check your internet or key setup.")
        return
    end

    if result then
        print("✅ Verified key:", key)
        onMessage("✅ Key accepted! Loading UI...")
        writefile(keyFilePath, key)
        screenGui:Destroy()
        loadMainUI()
    else
        onMessage("❌ Key invalid. Please try again.")
    end
end)
