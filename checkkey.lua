local WebAppUrl = "https://script.google.com/macros/s/AKfycbxBvMfAzYBzZUOR_3dtUQLc0SKu_6nICwSK0gYV96ZvCXqUtJGGTOk9TJJrx6LTYrbR/exec"

local function Verify()
    if getgenv().Key == "" then 
        game.Players.LocalPlayer:Kick("\n[Sigma Hub]\nVui lòng điền Key vào config!") 
        return 
    end

    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local url = WebAppUrl .. "?key=" .. getgenv().Key .. "&hwid=" .. hwid
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local data = game:GetService("HttpService"):JSONDecode(result)
        if data.success then
            print("==============================")
            print("Xác thực thành công!")
            print("Hạn dùng: " .. data.message)
            print("==============================")
            
            -- LOAD SOURCE CHÍNH
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nhantran11325-netizen/test-kaitun/refs/heads/main/Neon.txt"))()
        else
            game.Players.LocalPlayer:Kick("\n[Sigma Hub Error]\n" .. data.message)
        end
    else
        game.Players.LocalPlayer:Kick("\n[Lỗi kết nối]\nKhông thể gửi yêu cầu tới Database!")
    end
end

Verify()
