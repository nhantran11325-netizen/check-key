local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local StartTime = os.time()

local WebAppUrl = "https://script.google.com/macros/s/AKfycbyVwgZdi1DzatnBiNFYMfSFT4Ls7PH-Hff9iymfwTKYt9ZVZOa_lj4xmnlw2JGAQnZt/exec"
local ScriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"

local function GetFruits()
    local success, result = pcall(function()
        local inventory = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
        local fruits = {}
        for _, v in pairs(inventory) do
            if v.Type == "Fruit" then table.insert(fruits, v.Name) end
        end
        return #fruits > 0 and table.concat(fruits, ", ") or "Không có"
    end)
    return success and result or "N/A"
end

local function SendWebhook(type)
    local url = getgenv().WebhookUrl
    if not url or url == "" then return end
    
    local stats = Player:FindFirstChild("Data")
    local diff = os.time() - StartTime
    local uptime = string.format("%d phút %d giây", math.floor(diff / 60), diff % 60)

    local data = {
        ["embeds"] = {{
            ["title"] = "📊 BÁO CÁO SIGMA HUB [" .. type .. "]",
            ["color"] = type == "LOGIN" and 65280 or 16776960,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = "||" .. Player.Name .. "||", ["inline"] = true},
                {["name"] = "🆙 Level", ["value"] = stats and tostring(stats.Level.Value) or "N/A", ["inline"] = true},
                {["name"] = "⏳ Uptime", ["value"] = uptime, ["inline"] = true},
                {["name"] = "🍎 Inventory", ["value"] = GetFruits(), ["inline"] = false},
                {["name"] = "🔑 Key", ["value"] = "||" .. getgenv().Key .. "||", ["inline"] = true},
            },
            ["footer"] = {["text"] = "Sigma Tracking • " .. os.date("%X")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    pcall(function()
        request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end)
end

local function Verify()
    local k = getgenv().Key
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local url = WebAppUrl .. "?key=" .. k .. "&hwid=" .. hwid
    
    print("[Sigma Hub] Đang xác thực...")

    local success, res = pcall(function() return game:HttpGet(url) end)
    if success then
        local isJson, data = pcall(function() return HttpService:JSONDecode(res) end)
        if isJson and data.success then
            -- NẾU THÀNH CÔNG THÌ MỚI TIẾP TỤC
            print("========================================")
            print("XÁC THỰC THÀNH CÔNG!")
            print("Hạn: " .. tostring(data.message))
            print("========================================")

            -- 1. Gửi Webhook đăng nhập
            SendWebhook("LOGIN")
            
            -- 2. Chạy vòng lặp gửi Webhook cập nhật
            task.spawn(function()
                while task.wait(getgenv().WebhookDelay or 60) do
                    SendWebhook("UPDATE")
                end
            end)

            -- 3. Cuối cùng mới tải source chính
            loadstring(game:HttpGet(ScriptUrl))()
        else
            -- NẾU QUÁ HẠN (Database đã tự đổi status về 0), KICK NGAY
            Player:Kick("\n[Sigma Hub]\n" .. (data and data.message or "Lỗi xác thực"))
        end
    else
        Player:Kick("\n[Sigma Hub]\nKết nối Server thất bại!")
    end
end

Verify()
