-- [[ CHECKKEY.LUA - OPTIMIZED FOR NEW BACKEND ]]
local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local StartTime = os.time()

-- Cấu hình URL
local WebAppUrl = "https://script.google.com/macros/s/AKfycbzrx9Wg_ieu5tuIavFMLW7EnDZtpkx4sJMwCS0j8JmghWzUTEAtaPoLGtRXY7nr5Qfb/exec"
local ScriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"

-- Hàm lấy trái ác quỷ trong túi
local function GetFruits()
    local success, result = pcall(function()
        local inv = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
        local f = {}
        for _, v in pairs(inv) do
            if v.Type == "Fruit" then table.insert(f, v.Name) end
        end
        return #f > 0 and table.concat(f, ", ") or "Trống"
    end)
    return success and result or "N/A"
end

-- Hàm gửi Webhook báo cáo
local function SendWebhook(statusType)
    local url = getgenv().WebhookUrl
    if not url or url == "" or url == " " then return end
    
    local stats = Player:FindFirstChild("Data")
    local diff = os.time() - StartTime
    local uptime = string.format("%d phút %d giây", math.floor(diff / 60), diff % 60)

    local data = {
        ["embeds"] = {{
            ["title"] = "📊 SIGMA HUB - " .. statusType,
            ["color"] = statusType == "LOGIN" and 65280 or 16776960,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = "||" .. Player.Name .. "||", ["inline"] = true},
                {["name"] = "🆙 Level", ["value"] = stats and tostring(stats.Level.Value) or "N/A", ["inline"] = true},
                {["name"] = "💰 Beli", ["value"] = stats and tostring(stats.Beli.Value) or "0", ["inline"] = true},
                {["name"] = "🍎 Inventory", ["value"] = GetFruits(), ["inline"] = false},
                {["name"] = "⏳ Uptime", ["value"] = uptime, ["inline"] = true},
                {["name"] = "🔑 Key", ["value"] = "||" .. getgenv().Key .. "||", ["inline"] = true}
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

-- Hàm Xác Thực Chính
local function Verify()
    local key = getgenv().Key
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local finalUrl = WebAppUrl .. "?key=" .. tostring(key) .. "&hwid=" .. tostring(hwid)
    
    print("[Sigma Hub] Đang kiểm tra Key với hệ thống...")

    local success, response = pcall(function() return game:HttpGet(finalUrl) end)
    
    if success then
        local isJson, data = pcall(function() return HttpService:JSONDecode(response) end)
        
        if isJson then
            if data.success then
                -- THÀNH CÔNG: Chạy các tiến trình phụ
                print("----------------------------------------")
                print("XÁC THỰC THÀNH CÔNG!")
                print("Hạn dùng: " .. tostring(data.message))
                print("----------------------------------------")

                -- Gửi Webhook lần đầu
                task.spawn(function() SendWebhook("LOGIN") end)

                -- Vòng lặp Webhook cập nhật
                task.spawn(function()
                    while task.wait(getgenv().WebhookDelay or 60) do
                        SendWebhook("UPDATE")
                    end
                end)

                -- TẢI VÀ CHẠY SCRIPT CHÍNH (Neon.txt)
                local loadOk, content = pcall(function() return game:HttpGet(ScriptUrl) end)
                if loadOk then
                    loadstring(content)()
                else
                    Player:Kick("\n[Sigma Hub]\nLỗi: Không thể tải Script chính từ Server!")
                end
            else
                -- THẤT BẠI: (Sai Key/Hết hạn/HWID) -> Backend đã tự khóa key nếu hết hạn
                Player:Kick("\n[Sigma Hub Error]\n" .. tostring(data.message))
            end
        else
            warn("[Sigma Hub] Phản hồi lỗi từ Server. Hãy kiểm tra lại link Web App!")
            print("Server Response: " .. tostring(response))
        end
    else
        Player:Kick("\n[Sigma Hub]\nLỗi kết nối Server! Vui lòng thử lại sau.")
    end
end

-- Thực thi
Verify()
