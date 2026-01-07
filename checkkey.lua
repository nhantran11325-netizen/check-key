local function VerifyLicense()
    local HttpService = game:GetService("HttpService")
    local ANYF_API = "a5cfea1a476fae28bf901a04527a50edaa06146bfa38167b16652842d2c94dcf"
    local BaseUrl = "https://pandadevelopment.net/api/key/fetch?apiKey=" .. ANYF_API .. "&fetch=" .. getgenv().Key

    -- Kiểm tra nếu để trống key
    if getgenv().Key == "" or getgenv().Key == nil then
        game.Players.LocalPlayer:Kick("\n[Sigma Hub]\nLỗi: Bạn chưa nhập Key!")
        return
    end

    -- Gửi yêu cầu xác thực
    local success, response = pcall(function()
        return game:HttpGet(BaseUrl)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        -- So khớp key từ server trả về với key người dùng nhập
        if data.key and data.key.value == getgenv().Key then
            print("Xác thực thành công! Đang khởi động Banana Cat...")
            
            -- CHỈ LOAD KHI KEY ĐÚNG
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nhantran11325-netizen/test-kaitun/refs/heads/main/Neon.txt?token=GHSAT0AAAAAADRH5HHG62BBJPAG4CP6GBXW2K56NSQ"))()
        else
            game.Players.LocalPlayer:Kick("\n[Sigma Hub Error]\nKey sai hoặc đã hết hạn!")
        end
    else
        game.Players.LocalPlayer:Kick("\n[Sigma Hub Error]\nKhông thể kết nối máy chủ xác thực!")
    end
end

-- Chạy ngầm xác thực
VerifyLicense()
