-- [[ CHECKKEY.LUA - WEBHOOK CONFIGURABLE ]]
local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local StartTime = os.time()

-- Web App & Script URL
local WebAppUrl = "https://script.google.com/macros/s/AKfycbywblsMG_dj9XsRtdC-E9BPzZk6NgIO7avGOTWFINm70dBVj6CioSgvQQDj1R9VBkkJ/exec"
local ScriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"

-- Hàm lấy trái ác quỷ
local function GetFruits()
    local success, result = pcall(function()
        local inventory = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
        local fruits = {}
        for _, v in pairs(inventory) do
            if v.Type == "Fruit" then table.insert(fruits, v.Name) end
        end
        return #fruits > 0 and table.concat(fruits, ", ") or "Không có"
    end)
    return success and result or "Lỗi lấy túi đồ"
end

-- Hàm gửi Webhook
local function SendWebhook(type)
    local url = getgenv().WebhookUrl
    if not url or url == "" then return end -- Nếu không điền thì không gửi

    local stats = Player:FindFirstChild("Data")
    if not stats then return end

    local diff = os.time() - StartTime
    local uptime = string.format("%d phút %d giây", math.floor(diff / 60), diff % 60)

    local data = {
        ["embeds"] = {{
            ["title"] = "📊 BÁO CÁO SIGMA HUB [" .. type .. "]",
            ["color"] = type == "LOGIN" and 65280 or 16776960,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = "||" .. Player.Name .. "||", ["inline"] = true},
                {["name"] = "🆙 Level", ["value"] = tostring(stats.Level.Value), ["inline"] = true},
                {["name"] = "💰 Beli", ["value"] = tostring(stats.Beli.Value), ["inline"] = true},
                {["name"] = "💎 Fragment", ["value"] = tostring(stats.Fragments.Value), ["inline"] = true},
                {["name"] = "🍎 Inventory", ["value"] = GetFruits(), ["inline"] = false},
                {["name"] = "⏳ Uptime", ["value"] = uptime, ["inline"] = true},
                {["name"] = "🔑 Key", ["value"] = "||" .. getgenv().Key .. "||", ["inline"] = true},
            },
            ["footer"] = {["text"] = "Sigma Tracking • " .. os.date("%X")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    pcall(function()
        request({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- Xác thực
local function Verify()
    local k = getgenv().Key
    if not k or k == "" then Player:Kick("Thiếu Key!") return end

    local url = WebAppUrl .. "?key=" .. k .. "&hwid=" .. game:GetService("RbxAnalyticsService"):GetClientId()
    local success, res = pcall(function() return game:HttpGet(url) end)

    if success then
        local isJson, data = pcall(function() return HttpService:JSONDecode(res) end)
        if isJson and data.success then
            -- Gửi login webhook
            SendWebhook("LOGIN")

            -- Gửi update webhook theo thời gian tùy chỉnh
            task.spawn(function()
                local delayTime = getgenv().WebhookDelay or 60
                while task.wait(delayTime) do
                    SendWebhook("UPDATE")
                end
            end)

            -- Load script chính
            if not getgenv().Configs then getgenv().Configs = {} end
            loadstring(game:HttpGet(ScriptUrl))()
        else
            Player:Kick("\n[Sigma Hub]\n" .. (data and data.message or "Lỗi xác thực"))
        end
    else
        Player:Kick("\n[Sigma Hub]\nLỗi kết nối Server!")
    end
end

Verify()
