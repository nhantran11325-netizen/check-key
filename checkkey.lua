local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer
local StartTime = os.time()

local WebAppUrl = "https://script.google.com/macros/s/AKfycbxeW64BfMiFWzxzONm5B8IkgsCm0Z57b4wYo2YhaF8rPTKZo-86wQrttmITH6Pnqz4/exec"
local ScriptUrl = "https://api.junkie-development.de/api/v1/luascripts/public/c052c97909dcfb35fd4be16f305031c3f19eaf127516dfc7f2da361939d1e4d4/download"

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
                {["name"] = "🔑 Key", ["value"] = "||" .. getgenv().Key .. "||", ["inline"] = true},
            },
            ["footer"] = {["text"] = os.date("%X")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    pcall(function()
        request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end)
end

local function Verify()
    local k = getgenv().Key
    local url = WebAppUrl .. "?key=" .. k .. "&hwid=" .. game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- THỰC HIỆN KIỂM TRA TRƯỚC
    local success, res = pcall(function() return game:HttpGet(url) end)
    if success then
        local isJson, data = pcall(function() return HttpService:JSONDecode(res) end)
        if isJson and data.success then
            -- NẾU THÀNH CÔNG MỚI LÀM CÁC BƯỚC TIẾP THEO
            warn("XÁC THỰC THÀNH CÔNG!")
            
            SendWebhook("LOGIN")
            
            task.spawn(function()
                while task.wait(getgenv().WebhookDelay or 60) do
                    SendWebhook("UPDATE")
                end
            end)

            -- CUỐI CÙNG MỚI KÍCH HOẠT SCRIPT CHÍNH
            loadstring(game:HttpGet(ScriptUrl))()
        else
            -- NẾU QUÁ HẠN (Status đã bị backend đổi thành 0), KICK NGAY
            Player:Kick("\n[Sigma Hub]\n" .. (data and data.message or "Lỗi xác thực"))
        end
    else
        Player:Kick("\n[Sigma Hub]\nKết nối Server thất bại!")
    end
end

Verify()
