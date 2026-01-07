local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local ANYF_API = "a5cfea1a476fae28bf901a04527a50edaa06146bfa38167b16652842d2c94dcf"
local BASE_URL = "https://pandadevelopment.net"

-- ===== GET KEY (ĐỒNG BỘ VỚI LOADER) =====
local USER_KEY = getgenv().CheckKey
if not USER_KEY or USER_KEY == "" then
    Players.LocalPlayer:Kick("\n[Sigma Hub]\nLỗi: Bạn chưa nhập Key!")
    return
end

-- ===== CHECK LICENSE =====
local function CheckLicense()
    local url =
        BASE_URL ..
        "/api/key/fetch?apiKey=" .. ANYF_API ..
        "&fetch=" .. USER_KEY

    local res = syn.request({
        Url = url,
        Method = "GET"
    })

    if not res then
        return false, "Không có phản hồi từ API"
    end

    if res.StatusCode ~= 200 then
        return false, "HTTP Error: "..res.StatusCode
    end

    local data
    local ok = pcall(function()
        data = HttpService:JSONDecode(res.Body)
    end)

    if not ok or not data or not data.key then
        return false, "Key không hợp lệ"
    end

    -- Check hết hạn
    if data.key.expiresAt then
        local exp = DateTime.fromIsoDate(data.key.expiresAt).UnixTimestamp
        if os.time() > exp then
            return false, "Key đã hết hạn"
        end
    end

    return true
end

-- ===== RUN CHECK =====
local valid, err = CheckLicense()
if not valid then
    Players.LocalPlayer:Kick("\n[Sigma Hub Error]\n"..tostring(err))
    return
end

print("✅ Xác thực thành công – đang tải script...")

-- ===== LOAD SCRIPT CHÍNH =====
loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/nhantran11325-netizen/test-kaitun/refs/heads/main/Neon.txt"
))()
