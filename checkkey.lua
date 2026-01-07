local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer

-- Link Web App Google của bạn
local WEB_APP_URL = "https://script.google.com/macros/s/AKfycbxRp045AjiWfZqkDRHnqFpsgRkYOIqUtkxGGXSL4ILN9vS5LtqdXDlyVVnt4MnEpI2E/exec"

local function GetHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local function CheckDatabase()
    local userKey = getgenv().Key
    local userHWID = GetHWID()

    -- Chặn nếu key trống
    if userKey == "" or userKey == nil then
        Player:Kick("\n[Sigma Hub]\nLỗi: Vui lòng nhập Key!")
        return
    end

    -- Gửi yêu cầu kiểm tra tới Google Sheets (Sử dụng POST)
    local requestFunc = (syn and syn.request) or (http and http.request) or request or http_request
    
    local success, response = pcall(function()
        return requestFunc({
            Url = WEB_APP_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                key = userKey,
                hwid = userHWID
            })
        })
    end)

    if success and response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body)
        
        if data.success then
            print("Xác thực thành công! Đang tải script...")
            
            -- LOAD SOURCE CHÍNH (Chỉ chạy khi Google Sheets trả về Success)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nhantran11325-netizen/test-kaitun/refs/heads/main/Neon.txt"))()
        else
            -- Key sai, HWID sai hoặc Key hết hạn
            Player:Kick("\n[Sigma Hub Error]\n" .. (data.message or "Xác thực thất bại!"))
        end
    else
        -- Lỗi kết nối Web App
        Player:Kick("\n[Sigma Hub Error]\nKhông thể kết nối Database Google Sheets!")
    end
end

-- Chạy xác thực
CheckDatabase()
