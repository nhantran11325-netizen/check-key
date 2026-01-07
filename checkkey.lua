local HttpService = game:GetService("HttpService")
local API_KEY = "a5cfea1a476fae28bf901a04527a50edaa06146bfa38167b16652842d2c94dcf"

-- 1. Nếu key trống -> Kick ngay
if getgenv().Key == "" or getgenv().Key == nil then
    game.Players.LocalPlayer:Kick("\n[Sigma Hub Error]\nBạn chưa nhập Key!")
    return -- Chặn không cho code chạy tiếp
end

-- 2. Thực hiện check key qua server Panda
local check_url = "https://pandadevelopment.net/api/key/fetch?apiKey=" .. API_KEY .. "&fetch=" .. getgenv().Key

local success, response = pcall(function()
    return game:HttpGet(check_url)
end)

if success then
    local data = HttpService:JSONDecode(response)
    
    -- Nếu key đúng và còn hạn -> Load script chính
    if data and data.key and data.key.value == getgenv().Key then
        print("Xác thực thành công! Đang tải script...")
        
        -- LOAD SOURCE CHÍNH (Chỉ chạy khi key đúng)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nhantran11325-netizen/test-kaitun/refs/heads/main/Neon.txt?token=GHSAT0AAAAAADRH5HHG4OFZGLUBWCNEN4XA2K56R4Q"))()
    else
        -- Key sai hoặc hết hạn -> Kick
        game.Players.LocalPlayer:Kick("\n[Sigma Hub Error]\nKey không chính xác hoặc đã hết hạn!")
    end
else
    -- Lỗi server API
    game.Players.LocalPlayer:Kick("\n[Sigma Hub Error]\nKhông thể kết nối máy chủ xác thực!")
end
