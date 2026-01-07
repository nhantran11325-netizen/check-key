local HttpService = game:GetService("HttpService")
local API_ANYF = "a5cfea1a476fae28bf901a04527a50edaa06146bfa38167b16652842d2c94dcf"

-- 1. Kiểm tra nếu không nhập key
if getgenv().Key == "" or getgenv().Key == nil then
    game.Players.LocalPlayer:Kick("\n[LỖI]: Bạn chưa nhập Key vào dòng getgenv().Key = \"\"")
    return -- Dừng hoàn toàn script
end

-- 2. Gọi API để check key (Đúng vô, sai cút)
local success, result = pcall(function()
    return game:HttpGet("https://pandadevelopment.net/api/key/fetch?apiKey=" .. API_ANYF .. "&fetch=" .. getgenv().Key)
end)

if success then
    local data = HttpService:JSONDecode(result)
    
    -- Kiểm tra tính hợp lệ của key từ dữ liệu API trả về
    if data and data.key and data.key.value == getgenv().Key then
        print("Xác thực thành công! Đang khởi động script chính...")
        
        -- LOAD SCRIPT CHÍNH (Chỉ thực thi khi key đúng)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nhantran11325-netizen/test-kaitun/refs/heads/main/Neon.txt?token=GHSAT0AAAAAADRH5HHG4OFZGLUBWCNEN4XA2K56R4Q"))()
    else
        -- Key sai hoặc hết hạn
        game.Players.LocalPlayer:Kick("\n[Sigma Hub]: Key sai hoặc đã hết hạn!")
        return
    end
else
    -- Lỗi API hoặc lỗi mạng
    game.Players.LocalPlayer:Kick("\n[Sigma Hub]: Lỗi kết nối Server Xác Thực!")
    return
end
