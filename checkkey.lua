local HttpService = game:GetService("HttpService")
local ANYF_API = "a5cfea1a476fae28bf901a04527a50edaa06146bfa38167b16652842d2c94dcf"

-- 1. Kiểm tra Key trống
if getgenv().Key == "" or getgenv().Key == nil then
    game.Players.LocalPlayer:Kick("\n[Sigma Hub]\nLỗi: Bạn chưa nhập Key vào dòng getgenv().Key!")
    return -- Dừng script ngay lập tức
end

-- 2. Gửi yêu cầu xác thực đến Panda Development
local function CheckLicense()
    local url = "https://pandadevelopment.net/api/key/fetch?apiKey=" .. ANYF_API .. "&fetch=" .. getgenv().Key
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        
        -- Nếu Key hợp lệ và khớp với server
        if data and data.key and data.key.value == getgenv().Key then
            print("Xác thực thành công! Đang tải Banana Cat...")
            
            -- CHỈ KHI ĐÚNG MỚI CHẠY LỆNH NÀY
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nhantran11325-netizen/test-kaitun/refs/heads/main/Neon.txt?token=GHSAT0AAAAAADRH5HHG4OFZGLUBWCNEN4XA2K56R4Q"))()
        else
            -- Key sai hoặc hết hạn
            game.Players.LocalPlayer:Kick("\n[Sigma Hub Error]\nKey không chính xác hoặc đã hết hạn!")
        end
    else
        -- Lỗi kết nối API
        game.Players.LocalPlayer:Kick("\n[Sigma Hub Error]\nKhông thể kết nối máy chủ xác thực!")
    end
end

-- Chạy hàm kiểm tra
CheckLicense()
